//
//  Graph1.m
//  sampleTabBar
//
//  Created by Wes Cratty on 1/2/15.
//  Copyright (c) 2015 Wes Cratty. All rights reserved.
//

#import "FirstViewController.h"
#import "AppDelegate.h"
#import <math.h>

@implementation NSArray (StaticArray)

+(NSMutableArray *)sharedInstance{
    
    static dispatch_once_t pred;
    static NSMutableArray *sharedArray = nil;
    dispatch_once(&pred, ^{ sharedArray = [[NSMutableArray alloc] init]; });
    return sharedArray;
}
@end


@interface FirstViewController ()
@property (nonatomic, retain) IBOutlet UILabel *label_a;
@property (nonatomic, retain) IBOutlet UILabel *label_b;
@property (nonatomic, retain) IBOutlet UILabel *label_c;
@property (nonatomic, retain) IBOutlet UILabel *label_d;

@property (weak, nonatomic) IBOutlet UILabel *gSwitchLabel;
@property (nonatomic, retain) IBOutlet UISlider *slider_a;
@property (nonatomic, retain) IBOutlet UISlider *slider_b;
@property (nonatomic, retain) IBOutlet UISlider *slider_c;
@property (nonatomic, retain) IBOutlet UISlider *slider_d;
@property (weak, nonatomic) IBOutlet UISlider *plotsNumSlider;
@property (weak, nonatomic) IBOutlet UILabel *plotsNumLabel;
@property (weak, nonatomic) IBOutlet UISwitch *gSwitch;

//@property (weak, nonatomic) IBOutlet UIView *MiniGraphView;
//
-(void) compareLines;
-(void) loadMainGraph;
-(void) loadSmallGraph;

- (IBAction)sliderListener:(id)sender;
- (IBAction)switchListener:(id)sender;

@end

@implementation FirstViewController

int sizeofMyarray = 0;
int records = 5;
int graphsMade =0;
int smallgraphsMade =0;
int plotsSliderNum =10;
bool switchIsOn = TRUE;
bool dontNeedHelp = FALSE;
bool compareGraphs = TRUE;

double A=-1;
double B=-2;
double C=2;
double D=5;
double tabItemIndex =0;

NSNumber *max =0;



//UIView *MiniGraphView;

CPTGraphHostingView* hostView;
CPTGraph* graph;
CPTGraph* graph2;
CPTScatterPlot* plot;
CPTScatterPlot* plot2;
CPTXYAxisSet *axisSet ;//= (CPTXYAxisSet *) hostView.hostedGraph.axisSet;
CPTXYAxis *y;
CPTXYAxis *x;


//===========================================================================

-(void) viewDidAppear:(BOOL)animated    {
   // NSLog(@"tab selected: %lu", (unsigned long)self.tabBarController.selectedIndex);
    tabItemIndex=self.tabBarController.selectedIndex;
    
    
    if(tabItemIndex==3)
    {
        if(!switchIsOn){
            [self.gSwitch setOn:NO animated:YES];
        }
        //if(gSwitchIsOn)
        if (smallgraphsMade>0) {
            [graph2 reloadData];
            
        }else{
            [self loadSmallGraph];
            //max = [NSNumber numberWithInt:7];
            //[self clientMessage];
        }
    }else if (tabItemIndex==0){
        printf("\n\n\nmade graph tab = 0 %d\n\n\n",graphsMade);
        
        
        if (graphsMade>0) {
            
            [self clearGraph];
            [self getArraySize];
            [graph reloadData];
            
            if (sizeofMyarray>2) {
                if(compareGraphs){
                    [self compareLines];
                    [self clientMessage];
                }
                
            }
            
        }else{
            
            if(dontNeedHelp){
                [self loadMainGraph];
                
            }else{
                max =[NSNumber numberWithDouble:-10.0];
                [self clientMessage];
            }
            //            [self loadMainGraph];
        }
    }
}

//        //NSLog(@"\nEnters on first");
////        if(!switchIsOn){
////            plotsSliderNum =0;
////        }
//        printf("\n\n\nmade graph tab = 0 %d\n\n\n",graphsMade);
//        tempplots =plotsSliderNum;
//        if (graphsMade>0) {
//            
//            plotsSliderNum = 0;
//            [graph reloadData];
//                        //axisSet = (CPTXYAxisSet *) self.hostView.axisSet;
////            axisSet.hidden = YES;
////            
////            y = axisSet.yAxis;
////            y.labelingPolicy = CPTAxisLabelingPolicyNone;
////            
////            x = axisSet.xAxis;
////            x.labelingPolicy = CPTAxisLabelingPolicyNone;
//            //[graph reloadData];
//           // [self loadMainGraph];
//            
//            [self getArraySize];
//            
//            if (sizeofMyarray>2) {
//                if(compareGraphs){
//                    [self compareLines];
//                    [self clientMessage];
//                }
//                
//            }
//            
//        }else{
//            plotsSliderNum = tempplots;
//            if(dontNeedHelp){
//                [self loadMainGraph];
//                
//            }else{
//                [self clientMessage];
//            }
////            [self loadMainGraph];
//        }
//    }
//}

//===========================================================================
// Finds differance between the two lines and stores in max
-(void) clearGraph
{
//    [graph.defaultPlotSpace scaleToFitPlots:[graph allPlots]];
    printf("\n\nsupposedly cleared graph%d\n\n",graphsMade);
    int tempplots = 0;
    tempplots =plotsSliderNum;
    plotsSliderNum = 0;
    [graph reloadData];
    [graph.defaultPlotSpace scaleToFitPlots:[graph allPlots]];
    if (compareGraphs) {
        plotsSliderNum = tempplots;
    }
    

}
//===========================================================================
// Finds differance between the two lines and stores in max
-(void) compareLines
{
    NSNumber *funct1 =0;
    NSNumber *location1 =0;
    NSNumber *difference=[NSNumber numberWithDouble:0.0];
    printf(" comparing lines");
    [self getArraySize];
    
    if (sizeofMyarray>0) {
        //check arrays for closeness to line.
        for (int i=0; i<sizeofMyarray; i++) {
            
//            funct1 =([NSNumber numberWithDouble: (((pow(i,A))+(pow(i,B))+i*C)+D)]);
//            funct1 =([NSNumber numberWithDouble: (A*(pow(i+B,C))+D)]);
            
            
            funct1 =[NSNumber numberWithInt: (A*(pow(i+B,C))+D)];
            if (funct1.intValue<0) {
                funct1=[NSNumber numberWithInt:0];
            }
//            return tempint;

            location1 =([NSNumber numberWithDouble: [[[NSArray sharedInstance] objectAtIndex:i]doubleValue]]);
            difference = [NSNumber numberWithDouble:([funct1 floatValue] - [location1 floatValue])];
            difference = [NSNumber numberWithDouble:fabs([difference doubleValue])];
//            NSLog(@"\ndifference is:%@",difference);
            
            if ([difference doubleValue ]>[max doubleValue]) {
                max= difference ;
            }
        }
        //NSLog(@"\nmax is:%@",max);
    }
}


//===========================================================================
// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
// Returns number of points to plot
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords {
    
    [self getArraySize];
    if (sizeofMyarray>1 ) {
        return sizeofMyarray;
    }else{
        return plotsSliderNum;
    }
    
    
}

//===========================================================================
// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
// Depending on which graph is needed it creates the x vals or returns x vals from array
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    
    int x = (int)index ;
    NSNumber  *tempint = 0;
    
    if ([[plot identifier] isEqual:@"plot"]&& switchIsOn)
    {
        if(fieldEnum == CPTScatterPlotFieldX)
        {
            return [NSNumber numberWithInt: x];
        } else {
//            return [NSNumber numberWithInt: (((pow(x,A))+(pow(x,B))+x*C)+D)];
            tempint =[NSNumber numberWithInt: (A*(pow(x+B,C))+D)];
            if (tempint.intValue<0) {
                tempint=[NSNumber numberWithInt:0];
            }
            return tempint;
        }
    }
    else if ([[plot identifier] isEqual:@"plot2"]&& [[NSArray sharedInstance] count]>1)//askedForResults)
    {
        if(fieldEnum == CPTScatterPlotFieldX)
        {
            return [NSNumber numberWithInt: x];
        } else {
            
//            return [NSNumber numberWithInt: [[[NSArray sharedInstance] objectAtIndex:index]doubleValue]];
            tempint =[NSNumber numberWithInt: [[[NSArray sharedInstance] objectAtIndex:index]doubleValue]];
            if (tempint.intValue<0) {
                tempint=[NSNumber numberWithInt:0];
            }
            return tempint;
        }
    }else{
        return 0;
    }
}

//===========================================================================
// Builds small graph to see what you are making
-(void) loadMainGraph
{
    int size = 0;
    printf("\n\n\nmade graph %d\n\n\n",graphsMade);
    [self getArraySize];
    if (sizeofMyarray>1 ) {
        size= sizeofMyarray;
    }else{
        size= plotsSliderNum;
    }

   // NSLog(@"\n Number of graphs made%d",graphsMade);
    graphsMade++;
    
    //------------- Sets up graph -----------------------------------------------------------
    // We need a hostview, you can create one in IB (and create an outlet) or just do this:
    hostView = [[CPTGraphHostingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview: hostView];
    graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    hostView.hostedGraph = graph;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    // Note that these CPTPlotRange are defined by START and LENGTH (not START and END) !!
    
    [plotSpace setYRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( -2 ) length:CPTDecimalFromFloat( 10 )]];
    [plotSpace setXRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( -1 ) length:CPTDecimalFromFloat( size )]];
    
    
    axisSet = (CPTXYAxisSet *) hostView.hostedGraph.axisSet;
    
    y = axisSet.yAxis;
    x = axisSet.xAxis;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:0];
    
    y.labelFormatter = formatter;
    x.labelFormatter = formatter;
    
    y.title = @"Speed";
    x.title = @"Time";
    //y.titleTextStyle = axisTitleStyle;
    x.titleOffset = 20.0f;
    y.titleOffset = 20.0f;
    
    [graph.plotAreaFrame setPaddingLeft:30.0f];
    [graph.plotAreaFrame setPaddingBottom:30.0f];
    // 5 - Enable user interactions for plot space
    plotSpace.allowsUserInteraction = YES;
    
    
    //-------------- plot ------------------------------
    // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
    plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    plot.interpolation = CPTScatterPlotInterpolationCurved;
    
    [plot setIdentifier:@"plot"];
    [plot setDelegate:self];
    
    
    // Let's keep it simple and let this class act as datasource (therefore we implemtn <CPTPlotDataSource>)
    plot.dataSource = self;
    
    // Finally, add the created plot to the default plot space of the CPTGraph object we created before
//if(switchIsOn){
    [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
//}
    
    CPTMutableLineStyle *mainPlotLineStyle = [[plot dataLineStyle] mutableCopy];
    [mainPlotLineStyle setLineWidth:2.0f];
    [mainPlotLineStyle setLineColor:[CPTColor colorWithCGColor:[[UIColor blackColor] CGColor]]];
    
    [plot setDataLineStyle:mainPlotLineStyle];
    //-------------- plot ------------------------------
    
    
    //-------------- plot2 ------------------------------
    // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
    CPTScatterPlot* plot2 = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    plot2.interpolation = CPTScatterPlotInterpolationCurved;

    
    [plot2 setIdentifier:@"plot2"];
    [plot2 setDelegate:self];
    
    // Let's keep it simple and let this class act as datasource (therefore we implemtn <CPTPlotDataSource>)
    plot2.dataSource = self;
    
    // Finally, add the created plot to the default plot space of the CPTGraph object we created before
    [graph addPlot:plot2 toPlotSpace:graph.defaultPlotSpace];
    
    
    //    CPTMutableLineStyle *mainPlotLineStyle2 = [[plot2 dataLineStyle] mutableCopy];
    //    [mainPlotLineStyle setLineWidth:2.0f];
    [mainPlotLineStyle setLineColor:[CPTColor colorWithCGColor:[[UIColor blueColor] CGColor]]];
    
    [plot2 setDataLineStyle:mainPlotLineStyle];
    //-------------- plot2 ------------------------------

}

//===========================================================================

-(void) loadSmallGraph
{
    smallgraphsMade++;
    hostView = [[CPTGraphHostingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview: hostView];
    graph2 = [[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    hostView.hostedGraph = graph2;
    
    //[[self chartHostingView] setFrame:CGRectMake(0, 0, chartWidth, chartHeight)];
    
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph2.defaultPlotSpace;
    
    // Note that these CPTPlotRange are defined by START and LENGTH (not START and END) !!
    [plotSpace setYRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( 0 ) length:CPTDecimalFromFloat( 10 )]];
    [plotSpace setXRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( 0 ) length:CPTDecimalFromFloat( 10 )]];
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) hostView.hostedGraph.axisSet;
    
    CPTXYAxis *y = axisSet.yAxis;
    CPTXYAxis *x = axisSet.xAxis;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:0];
    
    y.labelFormatter = formatter;
    x.labelFormatter = formatter;
    
    
    [graph2.plotAreaFrame setPaddingTop:100.0f];
    [graph2.plotAreaFrame setPaddingLeft:350.0f];
    [graph2.plotAreaFrame setPaddingBottom:100.0f];
    [graph2.plotAreaFrame setPaddingRight:100.0f];
    
    // 5 - Enable user interactions for plot space
    plotSpace.allowsUserInteraction = YES;
    
    
    //-------------- plot ------------------------------
    // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
    plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    plot.interpolation = CPTScatterPlotInterpolationCurved;
    
    [plot setIdentifier:@"plot"];
    [plot setDelegate:self];
    
    
    // Let's keep it simple and let this class act as datasource (therefore we implemtn <CPTPlotDataSource>)
    plot.dataSource = self;
    
    // Finally, add the created plot to the default plot space of the CPTGraph object we created before
    [graph2 addPlot:plot toPlotSpace:graph2.defaultPlotSpace];
    
    
    CPTMutableLineStyle *mainPlotLineStyle = [[plot dataLineStyle] mutableCopy];
    [mainPlotLineStyle setLineWidth:2.0f];
    [mainPlotLineStyle setLineColor:[CPTColor colorWithCGColor:[[UIColor redColor] CGColor]]];
    
    [plot setDataLineStyle:mainPlotLineStyle];
    //-------------- plot ------------------------------
    
    [self.view bringSubviewToFront:_slider_a];
    [self.view bringSubviewToFront:_slider_b];
    [self.view bringSubviewToFront:_slider_c];
    [self.view bringSubviewToFront:_slider_d];
    [self.view bringSubviewToFront:_plotsNumSlider];
    [self.view bringSubviewToFront:_gSwitch];
   
    

}

//===========================================================================
// Displays alert view of the diff betwen lines
-(void) clientMessage
{
    NSString *title;
    NSString *string;
    NSString *button1 =@"I don't know" ;
    NSString *button2 = @"Go my own way";
    NSString *button3 = @"Walk the line";
    
    switch ([max integerValue])
    {
        case -10:
        {
            title = @"What to do?";
            string =@"Pick a path! ";
            break;
        }
        case 0:
        {
            title = @"Perfect!";
            string =@"Best score possible ";
            button1=@"ok";
            button2 = nil;
            button3 = nil;
            break;
        }
        case 1:
        {
            title = @"Results";
            string =@"Nice work ";
            button1=@"ok";
            button2 = nil;
            button3 = nil;
            break;
        }
        case 2:
        {
            title = @"Results";
            string =@"Pretty good ";
            button1=@"ok";
            button2 = nil;
            button3 = nil;
            break;
        }
        case 3:
        {
            title = @"Results";
            string =@"Getting Closer";
            button1=@"ok";
            button2 = nil;
            button3 = nil;
            break;
        }
        case 4:
        {
            title = @"Results";
            string =@"So So ";
            button1=@"ok";
            button2 = nil;
            button3 = nil;
            break;
        }
        case 5:
        {
            title = @"Results";
            string =@"You could probably do better ";
            button1=@"ok";
            button2 = nil;
            button3 = nil;
            break;
        }
//        case 6:
//        {
//            title = @"Results";
//            string =@"Rookie ";
//            button1=@"ok";
//            button2 = nil;
//            button3 = nil;
//            break;
//        }
//        case 7:
//        {
//            title = @"How to";
//            string =@"Move the sliders to change the graph to somthing you think you can do ";
//            break;
//        }
//        case 8:
//        {
//            title = @"Instructions";
//            string =@" Proceed to Show Instructions ";
//            break;
//        }
//        case 9:
//        {
//            title = @"Instructions";
//            string =@" Proceed to Get Data ";
//
//            break;
//        }
        case -100:
        {
            title = @"Get ready";
            string =@" Study the line and then proceed to Get Data and try to match your speed to that of the graph or go to Select new graph and make your own.";
            button1=@"ok";
            button2 = nil;
            button3 = nil;
            max = [NSNumber numberWithDouble:-10.0];
            break;
        }
        default:{
            title = @"Results";
            string =@"Rookie ";
            button1=@"ok";
            button2 = nil;
            button3 = nil;
            break;
//            title = @"Results";
//            string = @"try again? ";
//            button1=@"All done";
//            button2 = @"Start over";
//            button3 = nil;
//            break;
        }
            
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: title
                                                   message: string
                                                  delegate: self
                                         cancelButtonTitle: button1
                                         otherButtonTitles:button2,button3,nil];
    [alert setTag:1];
    [alert show];
    title = @"Results";
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"I don't know"])
    {
        NSLog(@"I don't know was selected.");
        [self.tabBarController setSelectedIndex:2];
    }
    else if([title isEqualToString:@"Go my own way"])
    {
        NSLog(@"Go my own way was selected.");
        switchIsOn = FALSE;
        compareGraphs = FALSE;
        [self.tabBarController setSelectedIndex:1];

    }
    else if([title isEqualToString:@"Walk the line"])
    {
        NSLog(@"Walk the line was selected.");
        dontNeedHelp = TRUE;
        [self loadMainGraph];
        compareGraphs = TRUE;
        max = [NSNumber numberWithDouble:-100.0];
        [self clientMessage];
        
        //[self.tabBarController setSelectedIndex:1];
    }
    else if([title isEqualToString:@"Start over"])
    {
        NSLog(@"Start over was selected.");
        max = [NSNumber numberWithDouble:-10.0];
        [self clientMessage];
        
    }
    dontNeedHelp = TRUE;
}
//===========================================================================


- (IBAction)switchListener:(id)sender {
//   UISwitch * graphSwitch = (UISwitch *)sender;
    
    
    
//        printf("do something");
    
        if(self.gSwitch.on)
        {
            self.gSwitchLabel.text =@"Compare graphs \"On\"";
            switchIsOn= TRUE;
            compareGraphs = TRUE;
            printf("switched on\n");
            [self sliderListener: _plotsNumSlider];

        }else{
            self.gSwitchLabel.text =@"Compare graphs \"Off\"";
            switchIsOn= FALSE;
            compareGraphs = FALSE;
            printf("switched off\n");
            plotsSliderNum =0;
//            [graph reloadData];
            [self clearGraph];

                    }
    
}

- (IBAction)sliderListener:(id)sender {
    UISlider * slider = (UISlider *)sender;
   
    int c =0;
   
    if(switchIsOn){
    //NSLog(@"slider selected: %lu", (unsigned long)slider.tag);
    switch (slider.tag)
    {
        case 1:
        {
            A = slider.value;
            self.label_a.text = [NSString stringWithFormat:@"%.1f", A];
        }
            break;
        case 2:
        {
            B = slider.value;
            self.label_b.text = [NSString stringWithFormat:@"%.1f", B];
        }
            break;
        case 3:
        {
            C = slider.value;
            c = C/2;
            C = c;
            self.label_c.text = [NSString stringWithFormat:@"%.1d", c];
        }
            break;
        case 4:
        {
            D = slider.value;
            self.label_d.text = [NSString stringWithFormat:@"%.1f", D];
        }
            break;
        case 5:
        {
            plotsSliderNum = slider.value ;
            self.plotsNumLabel.text = [NSString stringWithFormat:@"%d", plotsSliderNum];
        }
            break;
    }
    
        [graph2 reloadData];
    }
}

//===========================================================================
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

//===========================================================================

-(void) getArraySize
{
    sizeofMyarray=(int)[[NSArray sharedInstance] count];
}

@end

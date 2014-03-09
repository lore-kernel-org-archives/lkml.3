Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaCICmo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 21:42:44 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:47771 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaCICmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 21:42:43 -0500
Date: Sat, 8 Mar 2014 21:42:39 -0500
From: Conrad Meyer <cemeyer@uw.edu>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Staging: comedi: Fix some raw printks with dev_warn()
Message-ID: <20140308214239.36a60185@m>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brought to you with the help of sed and manual clean-up after.

  $ sed -i -e 's|printk("\\n|dev_warn(dev->hw_dev,\n\t"|' \
    addi-data/hwdrv_apci1500.c

Since all of these printk()s were for invalid API inputs and most of
them returned -EINVAL, I fixed the rest of them to return -EINVAL as
well.

Signed-off-by: Conrad Meyer <cse.cem@gmail.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      | 166 +++++++++++++--------
 1 file changed, 107 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index 2628ac4..0ccf784 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -242,56 +242,58 @@ static int i_APCI1500_ConfigDigitalInputEvent(struct comedi_device *dev,
 	int i;
 
       /*************************************************/
 	/* Selects the master interrupt control register */
       /*************************************************/
 	outb(APCI1500_RW_MASTER_INTERRUPT_CONTROL,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
       /**********************************************/
 	/* Disables  the main interrupt on the board */
       /**********************************************/
 	outb(0x00, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 
 	if (data[0] == 1) {
 		i_MaxChannel = 8;
 	}			/*  if (data[0] == 1) */
 	else {
 		if (data[0] == 2) {
 			i_MaxChannel = 6;
 		}		/*  if(data[0]==2) */
 		else {
-			printk("\nThe specified port event  does not exist\n");
+			dev_warn(dev->hw_dev,
+				"The specified port event does not exist\n");
 			return -EINVAL;
 		}		/* else if(data[0]==2) */
 	}			/* else  if (data[0] == 1) */
 	switch (data[1]) {
 	case 0:
 		data[1] = APCI1500_AND;
 		break;
 	case 1:
 		data[1] = APCI1500_OR;
 		break;
 	case 2:
 		data[1] = APCI1500_OR_PRIORITY;
 		break;
 	default:
-		printk("\nThe specified interrupt logic does not exist\n");
+		dev_warn(dev->hw_dev,
+			"The specified interrupt logic does not exist\n");
 		return -EINVAL;
 	}			/* switch(data[1]); */
 
 	i_Logic = data[1];
 	for (i_Count = i_MaxChannel, i = 0; i_Count > 0; i_Count--, i++) {
 		i_EventMask = data[2 + i];
 		switch (i_EventMask) {
 		case 0:
 			i_PatternMask =
 				i_PatternMask | (1 << (i_MaxChannel - i_Count));
 			break;
 		case 1:
 			i_PatternMask =
 				i_PatternMask | (1 << (i_MaxChannel - i_Count));
 			i_PatternPolarity =
 				i_PatternPolarity | (1 << (i_MaxChannel -
 					i_Count));
 			break;
 		case 2:
 			i_PatternMask =
@@ -301,86 +303,83 @@ static int i_APCI1500_ConfigDigitalInputEvent(struct comedi_device *dev,
 					i_Count));
 			break;
 		case 3:
 			i_PatternMask =
 				i_PatternMask | (1 << (i_MaxChannel - i_Count));
 			i_PatternPolarity =
 				i_PatternPolarity | (1 << (i_MaxChannel -
 					i_Count));
 			i_PatternTransition =
 				i_PatternTransition | (1 << (i_MaxChannel -
 					i_Count));
 			break;
 		case 4:
 			i_PatternTransition =
 				i_PatternTransition | (1 << (i_MaxChannel -
 					i_Count));
 			break;
 		case 5:
 			break;
 		default:
-			printk("\nThe option indicated in the event mask does not exist\n");
+			dev_warn(dev->hw_dev,
+				"The option indicated in the event mask does not exist\n");
 			return -EINVAL;
 		}		/*  switch(i_EventMask) */
 	}			/* for (i_Count = i_MaxChannel; i_Count >0;i_Count --) */
 
 	if (data[0] == 1) {
 		    /****************************/
 		/* Test the interrupt logic */
 		    /****************************/
 
 		if (data[1] == APCI1500_AND ||
 			data[1] == APCI1500_OR ||
 			data[1] == APCI1500_OR_PRIORITY) {
 		       /**************************************/
 			/* Tests if a transition was declared */
 			/* for a OR PRIORITY logic            */
 		       /**************************************/
 
 			if (data[1] == APCI1500_OR_PRIORITY
 				&& i_PatternTransition != 0) {
-			      /********************************************/
-				/* Transition error on an OR PRIORITY logic */
-			      /********************************************/
-				printk("\nTransition error on an OR PRIORITY logic\n");
+				dev_warn(dev->hw_dev,
+					"Transition error on an OR PRIORITY logic\n");
 				return -EINVAL;
 			}	/*  if (data[1]== APCI1500_OR_PRIORITY && i_PatternTransition != 0) */
 
 		       /*************************************/
 			/* Tests if more than one transition */
 			/* was declared for an AND logic     */
 		       /*************************************/
 
 			if (data[1] == APCI1500_AND) {
 				for (i_Count = 0; i_Count < 8; i_Count++) {
 					i_PatternTransitionCount =
 						i_PatternTransitionCount +
 						((i_PatternTransition >>
 							i_Count) & 0x1);
 
 				}	/* for (i_Count = 0; i_Count < 8; i_Count++) */
 
 				if (i_PatternTransitionCount > 1) {
-				  /****************************************/
-					/* Transition error on an AND logic     */
-				  /****************************************/
-					printk("\n Transition error on an AND logic\n");
+					dev_warn(dev->hw_dev,
+						"Transition error on an AND logic\n");
 					return -EINVAL;
 				}	/*  if (i_PatternTransitionCount > 1) */
 			}	/*  if (data[1]== APCI1500_AND) */
 
 			    /*****************************************************************/
 			/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
 			    /*****************************************************************/
 			outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			/******************/
 			/* Disable Port A */
 			    /******************/
 			outb(0xF0,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			/**********************************************/
 			/* Selects the polarity register of port 1    */
 			    /**********************************************/
 			outb(APCI1500_RW_PORT_A_PATTERN_POLARITY,
@@ -440,41 +439,42 @@ static int i_APCI1500_ConfigDigitalInputEvent(struct comedi_device *dev,
 				APCI1500_Z8536_CONTROL_REGISTER);
 
 			i_Event1Status = 1;
 
 		      /*****************************************************************/
 			/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
 			  /*****************************************************************/
 
 			outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 		      /*****************/
 			/* Enable Port A */
 			  /*****************/
 			outb(0xF4,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 
 		}		/*  if(data[1]==APCI1500_AND||data[1]==APCI1500_OR||data[1]==APCI1500_OR_PRIORITY) */
 		else {
-			printk("\nThe choice for interrupt logic does not exist\n");
+			dev_warn(dev->hw_dev,
+				"The choice for interrupt logic does not exist\n");
 			return -EINVAL;
 		}		/*  else }// if(data[1]==APCI1500_AND||data[1]==APCI1500_OR||data[1]==APCI1500_OR_PRIORITY) */
 	}			/*    if (data[0]== 1) */
 
 		 /************************************/
 	/* Test if event setting for port 2 */
 		 /************************************/
 
 	if (data[0] == 2) {
 		    /************************/
 		/* Test the event logic */
 		    /************************/
 
 		if (data[1] == APCI1500_OR) {
 		       /*****************************************************************/
 			/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
 		       /*****************************************************************/
 			outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
@@ -568,41 +568,42 @@ static int i_APCI1500_ConfigDigitalInputEvent(struct comedi_device *dev,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 
 			i_Event2Status = 1;
 		       /*****************************************************************/
 			/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
 		       /*****************************************************************/
 
 			outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 		       /*****************/
 			/* Enable Port B */
 		       /*****************/
 
 			outb(0xF4,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 		}		/*   if (data[1] == APCI1500_OR) */
 		else {
-			printk("\nThe choice for interrupt logic does not exist\n");
+			dev_warn(dev->hw_dev,
+				"The choice for interrupt logic does not exist\n");
 			return -EINVAL;
 		}		/* elseif (data[1] == APCI1500_OR) */
 	}			/* if(data[0]==2) */
 
 	return insn->n;
 }
 
 /*
 +----------------------------------------------------------------------------+
 | Function   Name   : int i_APCI1500_StartStopInputEvent                     |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
 | Task              :  Allows or disallows a port event                      |
 +----------------------------------------------------------------------------+
 | Input Parameters  : struct comedi_device *dev      : Driver handle                |
 |		              unsigned int ui_Channel : Channel number to read       |
 |                     unsigned int *data          : Data Pointer to read status  |
 |                      data[0]                 :0 Start input event
 |                                               1 Stop input event
@@ -674,41 +675,42 @@ static int i_APCI1500_StartStopInputEvent(struct comedi_device *dev,
 					i_Event1InterruptStatus = 1;
 					outb(APCI1500_RW_PORT_A_SPECIFICATION,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 					i_RegValue =
 						inb(devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 
 					/* Selects the master interrupt control register */
 		       /*************************************************/
 					outb(APCI1500_RW_MASTER_INTERRUPT_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		       /**********************************************/
 					/* Authorizes the main interrupt on the board */
 		       /**********************************************/
 					outb(0xD0,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 
 				}	/*  if(i_Event1Status==1) */
 				else {
-					printk("\nEvent 1 not initialised\n");
+					dev_warn(dev->hw_dev,
+						"Event 1 not initialised\n");
 					return -EINVAL;
 				}	/* else if(i_Event1Status==1) */
 			}	/* if (data[1]==1) */
 			if (data[1] == 2) {
 
 				if (i_Event2Status == 1) {
 			    /*****************************************************************/
 					/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
 			    /*****************************************************************/
 					outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		       /******************/
 					/* Disable Port B */
 		       /******************/
 					outb(0x74,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 		       /***************************************************/
 					/* Selects the command and status register of      */
 					/* port 2                                          */
 		       /***************************************************/
@@ -725,47 +727,49 @@ static int i_APCI1500_StartStopInputEvent(struct comedi_device *dev,
 					outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		       /*****************/
 					/* Enable Port B */
 		       /*****************/
 					outb(0xF4,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 
 					/* Selects the master interrupt control register */
 		       /*************************************************/
 					outb(APCI1500_RW_MASTER_INTERRUPT_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		       /**********************************************/
 					/* Authorizes the main interrupt on the board */
 		       /**********************************************/
 					outb(0xD0,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 					i_Event2InterruptStatus = 1;
 				}	/*  if(i_Event2Status==1) */
 				else {
-					printk("\nEvent 2 not initialised\n");
+					dev_warn(dev->hw_dev,
+						"Event 2 not initialised\n");
 					return -EINVAL;
 				}	/* else if(i_Event2Status==1) */
 			}	/*  if(data[1]==2) */
 		}		/*  if (data[1] == 1 || data[0] == 2) */
 		else {
-			printk("\nThe port parameter is in error\n");
+			dev_warn(dev->hw_dev,
+				"The port parameter is in error\n");
 			return -EINVAL;
 		}		/* else if (data[1] == 1 || data[0] == 2) */
 
 		break;
 
 	case STOP:
 		  /*************************/
 		/* Tests the port number */
 		  /*************************/
 
 		if (data[1] == 1 || data[1] == 2) {
 		  /***************************/
 			/* Test if port 1 selected */
 		  /***************************/
 
 			if (data[1] == 1) {
 		    /*****************************/
 				/* Test if event initialised */
 		    /*****************************/
 				if (i_Event1Status == 1) {
@@ -786,41 +790,42 @@ static int i_APCI1500_StartStopInputEvent(struct comedi_device *dev,
 					outb(APCI1500_RW_PORT_A_COMMAND_AND_STATUS, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		       /*************************************/
 					/* Inhibits the pattern interrupt      */
 		       /*************************************/
 					outb(0xE0,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 		       /*****************************************************************/
 					/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
 		       /*****************************************************************/
 					outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		       /*****************/
 					/* Enable Port A */
 		       /*****************/
 					outb(0xF4,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 					i_Event1InterruptStatus = 0;
 				}	/*  if(i_Event1Status==1) */
 				else {
-					printk("\nEvent 1 not initialised\n");
+					dev_warn(dev->hw_dev,
+						"Event 1 not initialised\n");
 					return -EINVAL;
 				}	/* else if(i_Event1Status==1) */
 			}	/* if (data[1]==1) */
 			if (data[1] == 2) {
 			 /*****************************/
 				/* Test if event initialised */
 			 /*****************************/
 				if (i_Event2Status == 1) {
 			  /*****************************************************************/
 					/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
 			  /*****************************************************************/
 					outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 			  /******************/
 					/* Disable Port B */
 			  /******************/
 					outb(0x74,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 			  /***************************************************/
 					/* Selects the command and status register of      */
@@ -829,53 +834,56 @@ static int i_APCI1500_StartStopInputEvent(struct comedi_device *dev,
 					outb(APCI1500_RW_PORT_B_COMMAND_AND_STATUS, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		       /*************************************/
 					/* Inhibits the pattern interrupt      */
 		       /*************************************/
 					outb(0xE0,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 		       /*****************************************************************/
 					/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
 		       /*****************************************************************/
 					outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		       /*****************/
 					/* Enable Port B */
 		       /*****************/
 					outb(0xF4,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 					i_Event2InterruptStatus = 0;
 				}	/*  if(i_Event2Status==1) */
 				else {
-					printk("\nEvent 2 not initialised\n");
+					dev_warn(dev->hw_dev,
+						"Event 2 not initialised\n");
 					return -EINVAL;
 				}	/* else if(i_Event2Status==1) */
 			}	/* if(data[1]==2) */
 
 		}		/*  if (data[1] == 1 || data[1] == 2) */
 		else {
-			printk("\nThe port parameter is in error\n");
+			dev_warn(dev->hw_dev,
+				"The port parameter is in error\n");
 			return -EINVAL;
 		}		/* else if (data[1] == 1 || data[1] == 2) */
 		break;
 	default:
-		printk("\nThe option of START/STOP logic does not exist\n");
+		dev_warn(dev->hw_dev,
+			"The option of START/STOP logic does not exist\n");
 		return -EINVAL;
 	}			/* switch(data[0]) */
 
 	return insn->n;
 }
 
 /*
 +----------------------------------------------------------------------------+
 | Function   Name   : int i_APCI1500_Initialisation                          |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
 +----------------------------------------------------------------------------+
 | Task              : Return the status of the digital input                 |
 +----------------------------------------------------------------------------+
 | Input Parameters  : struct comedi_device *dev      : Driver handle                |
 |		              unsigned int ui_Channel : Channel number to read       |
 |                     unsigned int *data          : Data Pointer to read status  |
 +----------------------------------------------------------------------------+
 | Output Parameters :	--													 |
 +----------------------------------------------------------------------------+
@@ -1147,41 +1155,43 @@ static int i_APCI1500_WriteDigitalOutput(struct comedi_device *dev,
 					data[0] =
 						(data[0] << (8 *
 							data[2])) | ui_Temp;
 					break;
 
 				case 15:
 					data[0] = data[0] | ui_Temp;
 					break;
 
 				default:
 					comedi_error(dev, " chan spec wrong");
 					return -EINVAL;	/*  "sorry channel spec wrong " */
 
 				}	/* switch(ui_NoOfChannels) */
 
 				outw(data[0],
 					devpriv->i_IobaseAddon +
 					APCI1500_DIGITAL_OP);
 			}	/*  if(data[1]==1) */
 			else {
-				printk("\nSpecified channel not supported\n");
+				dev_warn(dev->hw_dev,
+					"Specified channel not supported\n");
+				return -EINVAL;
 			}	/* else if(data[1]==1) */
 		}		/* elseif(data[1]==0) */
 	}			/* if(data[3]==0) */
 	else {
 		if (data[3] == 1) {
 			if (data[1] == 0) {
 				data[0] = ~data[0] & 0x1;
 				ui_Temp1 = 1;
 				ui_Temp1 = ui_Temp1 << ui_NoOfChannel;
 				ui_Temp = ui_Temp | ui_Temp1;
 				data[0] =
 					(data[0] << ui_NoOfChannel) ^
 					0xffffffff;
 				data[0] = data[0] & ui_Temp;
 				outw(data[0],
 					devpriv->i_IobaseAddon +
 					APCI1500_DIGITAL_OP);
 			}	/* if(data[1]==0) */
 			else {
 				if (data[1] == 1) {
@@ -1224,46 +1234,49 @@ static int i_APCI1500_WriteDigitalOutput(struct comedi_device *dev,
 									data
 									[2])) ^
 							0xffffffff) & ui_Temp;
 						break;
 
 					case 15:
 						break;
 
 					default:
 						comedi_error(dev,
 							" chan spec wrong");
 						return -EINVAL;	/*  "sorry channel spec wrong " */
 
 					}	/* switch(ui_NoOfChannels) */
 
 					outw(data[0],
 						devpriv->i_IobaseAddon +
 						APCI1500_DIGITAL_OP);
 				}	/*  if(data[1]==1) */
 				else {
-					printk("\nSpecified channel not supported\n");
+					dev_warn(dev->hw_dev,
+						"Specified channel not supported\n");
+					return -EINVAL;
 				}	/* else if(data[1]==1) */
 			}	/* elseif(data[1]==0) */
 		}		/* if(data[3]==1); */
 		else {
-			printk("\nSpecified functionality does not exist\n");
+			dev_warn(dev->hw_dev,
+				"Specified functionality does not exist\n");
 			return -EINVAL;
 		}		/* if else data[3]==1) */
 	}			/* if else data[3]==0) */
 	ui_Temp = data[0];
 	return insn->n;
 }
 
 /*
 +----------------------------------------------------------------------------+
 | Function   Name   : int i_APCI1500_ConfigCounterTimerWatchdog(comedi_device
 |                   *dev,struct comedi_subdevice *s,struct comedi_insn *insn,unsigned int *data)|
 |				                                                     |
 +----------------------------------------------------------------------------+
 | Task              : Configures The Watchdog                                |
 +----------------------------------------------------------------------------+
 | Input Parameters  : struct comedi_device *dev      : Driver handle                |
 |                     struct comedi_subdevice *s,   :pointer to subdevice structure
 |                      struct comedi_insn *insn      :pointer to insn structure      |
 |                     unsigned int *data         : Data Pointer to read status                                                       data[0]                : 2     APCI1500_1_8_KHZ
 |                                              1     APCI1500_3_6_KHZ        |
@@ -1301,70 +1314,73 @@ static int i_APCI1500_WriteDigitalOutput(struct comedi_device *dev,
 |		            : FALSE : Error occur. Return the error          |
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
 static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 						 struct comedi_subdevice *s,
 						 struct comedi_insn *insn,
 						 unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	int i_TimerCounterMode, i_MasterConfiguration;
 
 	devpriv->tsk_Current = current;
 
 /* Selection of the input clock */
 	if (data[0] == 0 || data[0] == 1 || data[0] == 2) {
 		outw(data[0], devpriv->i_IobaseAddon + APCI1500_CLK_SELECT);
 	}			/*  if(data[0]==0||data[0]==1||data[0]==2) */
 	else {
 		if (data[0] != 3) {
-			printk("\nThe option for input clock selection does not exist\n");
+			dev_warn(dev->hw_dev,
+				"The option for input clock selection does not exist\n");
 			return -EINVAL;
 		}		/*  if(data[0]!=3) */
 	}			/* elseif(data[0]==0||data[0]==1||data[0]==2) */
 	/* Select the counter/timer */
 	switch (data[1]) {
 	case COUNTER1:
 		/* selecting counter or timer */
 		switch (data[2]) {
 		case 0:
 			data[2] = APCI1500_COUNTER;
 			break;
 		case 1:
 			data[2] = APCI1500_TIMER;
 			break;
 		default:
-			printk("\nThis choice is not a timer nor a counter\n");
+			dev_warn(dev->hw_dev,
+				"This choice is not a timer nor a counter\n");
 			return -EINVAL;
 		}		/*  switch(data[2]) */
 
 		/* Selecting  single or continuous mode */
 		switch (data[4]) {
 		case 0:
 			data[4] = APCI1500_CONTINUOUS;
 			break;
 		case 1:
 			data[4] = APCI1500_SINGLE;
 			break;
 		default:
-			printk("\nThis option for single/continuous mode does not exist\n");
+			dev_warn(dev->hw_dev,
+				"This option for single/continuous mode does not exist\n");
 			return -EINVAL;
 		}		/*  switch(data[4]) */
 
 		i_TimerCounterMode = data[2] | data[4] | 7;
 			 /*************************/
 		/* Test the reload value */
 			 /*************************/
 
 		if ((data[3] >= 0) && (data[3] <= 65535)) {
 			if (data[7] == APCI1500_ENABLE
 				|| data[7] == APCI1500_DISABLE) {
 
 				/************************************************/
 				/* Selects the mode register of timer/counter 1 */
 				/************************************************/
 				outb(APCI1500_RW_CPT_TMR1_MODE_SPECIFICATION,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 				/***********************/
 				/* Writes the new mode */
@@ -1457,101 +1473,107 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 
 				outb(0x0,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 					  /****************************************/
 				/* Selects the commands register of     */
 				/* timer/counter 1                      */
 					  /****************************************/
 				outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
 				      /***************************/
 				/* Trigger timer/counter 1 */
 				      /***************************/
 				outb(0x2,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 			}	/* if(data[7]== APCI1500_ENABLE ||data[7]== APCI1500_DISABLE) */
 			else {
-				printk("\nError in selection of interrupt enable or disable\n");
+				dev_warn(dev->hw_dev,
+					"Error in selection of interrupt enable or disable\n");
 				return -EINVAL;
 			}	/* elseif(data[7]== APCI1500_ENABLE ||data[7]== APCI1500_DISABLE) */
 		}		/*  if ((data[3]>= 0) && (data[3] <= 65535)) */
 		else {
-			printk("\nError in selection of reload value\n");
+			dev_warn(dev->hw_dev,
+				"Error in selection of reload value\n");
 			return -EINVAL;
 		}		/* else if ((data[3]>= 0) && (data[3] <= 65535)) */
 		i_TimerCounterWatchdogInterrupt = data[7];
 		i_TimerCounter1Init = 1;
 		break;
 
 	case COUNTER2:		/* selecting counter or timer */
 		switch (data[2]) {
 		case 0:
 			data[2] = APCI1500_COUNTER;
 			break;
 		case 1:
 			data[2] = APCI1500_TIMER;
 			break;
 		default:
-			printk("\nThis choice is not a timer nor a counter\n");
+			dev_warn(dev->hw_dev,
+				"This choice is not a timer nor a counter\n");
 			return -EINVAL;
 		}		/*  switch(data[2]) */
 
 		/* Selecting  single or continuous mode */
 		switch (data[4]) {
 		case 0:
 			data[4] = APCI1500_CONTINUOUS;
 			break;
 		case 1:
 			data[4] = APCI1500_SINGLE;
 			break;
 		default:
-			printk("\nThis option for single/continuous mode does not exist\n");
+			dev_warn(dev->hw_dev,
+				"This option for single/continuous mode does not exist\n");
 			return -EINVAL;
 		}		/*  switch(data[4]) */
 
 		/* Selecting  software or hardware trigger */
 		switch (data[5]) {
 		case 0:
 			data[5] = APCI1500_SOFTWARE_TRIGGER;
 			break;
 		case 1:
 			data[5] = APCI1500_HARDWARE_TRIGGER;
 			break;
 		default:
-			printk("\nThis choice for software or hardware trigger does not exist\n");
+			dev_warn(dev->hw_dev,
+				"This choice for software or hardware trigger does not exist\n");
 			return -EINVAL;
 		}		/*  switch(data[5]) */
 
 		/* Selecting  software or hardware gate */
 		switch (data[6]) {
 		case 0:
 			data[6] = APCI1500_SOFTWARE_GATE;
 			break;
 		case 1:
 			data[6] = APCI1500_HARDWARE_GATE;
 			break;
 		default:
-			printk("\nThis choice for software or hardware gate does not exist\n");
+			dev_warn(dev->hw_dev,
+				"This choice for software or hardware gate does not exist\n");
 			return -EINVAL;
 		}		/*  switch(data[6]) */
 
 		i_TimerCounterMode = data[2] | data[4] | data[5] | data[6] | 7;
 
 			     /*************************/
 		/* Test the reload value */
 			     /*************************/
 
 		if ((data[3] >= 0) && (data[3] <= 65535)) {
 			if (data[7] == APCI1500_ENABLE
 				|| data[7] == APCI1500_DISABLE) {
 
 				/************************************************/
 				/* Selects the mode register of timer/counter 2 */
 				/************************************************/
 				outb(APCI1500_RW_CPT_TMR2_MODE_SPECIFICATION,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 				/***********************/
@@ -1645,88 +1667,93 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 
 				outb(0x0,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 					  /****************************************/
 				/* Selects the commands register of     */
 				/* timer/counter 2                      */
 					  /****************************************/
 				outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
 				      /***************************/
 				/* Trigger timer/counter 1 */
 				      /***************************/
 				outb(0x2,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 			}	/* if(data[7]== APCI1500_ENABLE ||data[7]== APCI1500_DISABLE) */
 			else {
-				printk("\nError in selection of interrupt enable or disable\n");
+				dev_warn(dev->hw_dev,
+					"Error in selection of interrupt enable or disable\n");
 				return -EINVAL;
 			}	/* elseif(data[7]== APCI1500_ENABLE ||data[7]== APCI1500_DISABLE) */
 		}		/*  if ((data[3]>= 0) && (data[3] <= 65535)) */
 		else {
-			printk("\nError in selection of reload value\n");
+			dev_warn(dev->hw_dev,
+				"Error in selection of reload value\n");
 			return -EINVAL;
 		}		/* else if ((data[3]>= 0) && (data[3] <= 65535)) */
 		i_TimerCounterWatchdogInterrupt = data[7];
 		i_TimerCounter2Init = 1;
 		break;
 
 	case COUNTER3:		/* selecting counter or watchdog */
 		switch (data[2]) {
 		case 0:
 			data[2] = APCI1500_COUNTER;
 			break;
 		case 1:
 			data[2] = APCI1500_WATCHDOG;
 			break;
 		default:
-			printk("\nThis choice is not a watchdog nor a counter\n");
+			dev_warn(dev->hw_dev,
+				"This choice is not a watchdog nor a counter\n");
 			return -EINVAL;
 		}		/*  switch(data[2]) */
 
 		/* Selecting  single or continuous mode */
 		switch (data[4]) {
 		case 0:
 			data[4] = APCI1500_CONTINUOUS;
 			break;
 		case 1:
 			data[4] = APCI1500_SINGLE;
 			break;
 		default:
-			printk("\nThis option for single/continuous mode does not exist\n");
+			dev_warn(dev->hw_dev,
+				"This option for single/continuous mode does not exist\n");
 			return -EINVAL;
 		}		/*  switch(data[4]) */
 
 		/* Selecting  software or hardware gate */
 		switch (data[6]) {
 		case 0:
 			data[6] = APCI1500_SOFTWARE_GATE;
 			break;
 		case 1:
 			data[6] = APCI1500_HARDWARE_GATE;
 			break;
 		default:
-			printk("\nThis choice for software or hardware gate does not exist\n");
+			dev_warn(dev->hw_dev,
+				"This choice for software or hardware gate does not exist\n");
 			return -EINVAL;
 		}		/*  switch(data[6]) */
 
 		      /*****************************/
 		/* Test if used for watchdog */
 			  /*****************************/
 
 		if (data[2] == APCI1500_WATCHDOG) {
 			     /*****************************/
 			/* - Enables the output line */
 			/* - Enables retrigger       */
 			/* - Pulses output           */
 			     /*****************************/
 			i_TimerCounterMode = data[2] | data[4] | 0x54;
 		}		/* if (data[2] == APCI1500_WATCHDOG) */
 		else {
 			i_TimerCounterMode = data[2] | data[4] | data[6] | 7;
 		}		/* elseif (data[2] == APCI1500_WATCHDOG) */
 				 /*************************/
 		/* Test the reload value */
@@ -1840,54 +1867,58 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 
 					      /*************************************/
 					/* Selects the command register of   */
 					/* watchdog/counter 3                */
 						  /*************************************/
 
 					outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 					     /*************************************************/
 					/* Trigger the  watchdog/counter 3 and starts it */
 						 /*************************************************/
 					outb(0x2,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 
 				}	/* elseif(data[2]==APCI1500_COUNTER) */
 
 			}	/* if(data[7]== APCI1500_ENABLE ||data[7]== APCI1500_DISABLE) */
 			else {
-				printk("\nError in selection of interrupt enable or disable\n");
+				dev_warn(dev->hw_dev,
+					"Error in selection of interrupt enable or disable\n");
 				return -EINVAL;
 			}	/* elseif(data[7]== APCI1500_ENABLE ||data[7]== APCI1500_DISABLE) */
 		}		/*  if ((data[3]>= 0) && (data[3] <= 65535)) */
 		else {
-			printk("\nError in selection of reload value\n");
+			dev_warn(dev->hw_dev,
+				"Error in selection of reload value\n");
 			return -EINVAL;
 		}		/* else if ((data[3]>= 0) && (data[3] <= 65535)) */
 		i_TimerCounterWatchdogInterrupt = data[7];
 		i_WatchdogCounter3Init = 1;
 		break;
 
 	default:
-		printk("\nThe specified counter\timer option does not exist\n");
+		dev_warn(dev->hw_dev,
+			"The specified counter/timer option does not exist\n");
+		return -EINVAL;
 	}			/* switch(data[1]) */
 	i_CounterLogic = data[2];
 	return insn->n;
 }
 
 /*
 +----------------------------------------------------------------------------+
 | Function   Name   : int i_apci1500_timer_watchdog
 |				(struct comedi_device *dev,struct comedi_subdevice *s,
 |                         struct comedi_insn *insn,unsigned int *data);                  |
 +----------------------------------------------------------------------------+
 | Task              : Start / Stop or trigger the timer counter or Watchdog  |
 +----------------------------------------------------------------------------+
 | Input Parameters  : struct comedi_device *dev     : Driver handle                 |
 |                     struct comedi_subdevice *s,   :pointer to subdevice structure
 |                      struct comedi_insn *insn      :pointer to insn structure      |
 |                     unsigned int *data         : Data Pointer to read status   |
 |                      data[0]                : 0     Counter1/Timer1
 |                                               1     Counter2/Timer2
 |                                               2     Counter3/Watchdog
@@ -1920,41 +1951,42 @@ static int i_apci1500_timer_watchdog(struct comedi_device *dev,
 					i_CommandAndStatusValue = 0xC4;	/* Enable the interrupt */
 				}	/*  if(i_TimerCounterWatchdogInterrupt==1) */
 				else {
 					i_CommandAndStatusValue = 0xE4;	/* disable the interrupt */
 				}	/* elseif(i_TimerCounterWatchdogInterrupt==1) */
 					      /**************************/
 				/* Starts timer/counter 1 */
 					      /**************************/
 				i_TimerCounter1Enabled = 1;
 						/********************************************/
 				/* Selects the commands and status register */
 						/********************************************/
 				outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 				outb(i_CommandAndStatusValue,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 			}	/* if( i_TimerCounter1Init==1) */
 			else {
-				printk("\nCounter/Timer1 not configured\n");
+				dev_warn(dev->hw_dev,
+					"Counter/Timer1 not configured\n");
 				return -EINVAL;
 			}
 			break;
 
 		case STOP:
 
 					      /**************************/
 			/* Stop timer/counter 1 */
 					      /**************************/
 
 						/********************************************/
 			/* Selects the commands and status register */
 						/********************************************/
 			outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			outb(0x00,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			i_TimerCounter1Enabled = 0;
@@ -1971,77 +2003,80 @@ static int i_apci1500_timer_watchdog(struct comedi_device *dev,
 				}	/* if( i_TimerCounter1Enabled==1) */
 				else {
 						   /***************/
 					/* Set Trigger */
 						   /***************/
 
 					i_CommandAndStatusValue = 0x2;
 				}	/* elseif(i_TimerCounter1Enabled==1) */
 
 						/********************************************/
 				/* Selects the commands and status register */
 						/********************************************/
 				outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 				outb(i_CommandAndStatusValue,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 			}	/* if( i_TimerCounter1Init==1) */
 			else {
-				printk("\nCounter/Timer1 not configured\n");
+				dev_warn(dev->hw_dev,
+					"Counter/Timer1 not configured\n");
 				return -EINVAL;
 			}
 			break;
 
 		default:
-			printk("\nThe specified option for start/stop/trigger does not exist\n");
+			dev_warn(dev->hw_dev,
+				"The specified option for start/stop/trigger does not exist\n");
 			return -EINVAL;
 		}		/* switch(data[1]) */
 		break;
 
 	case COUNTER2:
 		switch (data[1]) {
 		case START:
 			if (i_TimerCounter2Init == 1) {
 				if (i_TimerCounterWatchdogInterrupt == 1) {
 					i_CommandAndStatusValue = 0xC4;	/* Enable the interrupt */
 				}	/*  if(i_TimerCounterWatchdogInterrupt==1) */
 				else {
 					i_CommandAndStatusValue = 0xE4;	/* disable the interrupt */
 				}	/* elseif(i_TimerCounterWatchdogInterrupt==1) */
 					      /**************************/
 				/* Starts timer/counter 2 */
 					      /**************************/
 				i_TimerCounter2Enabled = 1;
 						/********************************************/
 				/* Selects the commands and status register */
 						/********************************************/
 				outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 				outb(i_CommandAndStatusValue,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 			}	/* if( i_TimerCounter2Init==1) */
 			else {
-				printk("\nCounter/Timer2 not configured\n");
+				dev_warn(dev->hw_dev,
+					"Counter/Timer2 not configured\n");
 				return -EINVAL;
 			}
 			break;
 
 		case STOP:
 
 					      /**************************/
 			/* Stop timer/counter 2 */
 					      /**************************/
 
 						/********************************************/
 			/* Selects the commands and status register */
 						/********************************************/
 			outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			outb(0x00,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			i_TimerCounter2Enabled = 0;
@@ -2057,77 +2092,80 @@ static int i_apci1500_timer_watchdog(struct comedi_device *dev,
 				}	/* if( i_TimerCounter2Enabled==1) */
 				else {
 						   /***************/
 					/* Set Trigger */
 						   /***************/
 
 					i_CommandAndStatusValue = 0x2;
 				}	/* elseif(i_TimerCounter2Enabled==1) */
 
 						/********************************************/
 				/* Selects the commands and status register */
 						/********************************************/
 				outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 				outb(i_CommandAndStatusValue,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 			}	/* if( i_TimerCounter2Init==1) */
 			else {
-				printk("\nCounter/Timer2 not configured\n");
+				dev_warn(dev->hw_dev,
+					"Counter/Timer2 not configured\n");
 				return -EINVAL;
 			}
 			break;
 		default:
-			printk("\nThe specified option for start/stop/trigger does not exist\n");
+			dev_warn(dev->hw_dev,
+				"The specified option for start/stop/trigger does not exist\n");
 			return -EINVAL;
 		}		/* switch(data[1]) */
 		break;
 	case COUNTER3:
 		switch (data[1]) {
 		case START:
 			if (i_WatchdogCounter3Init == 1) {
 
 				if (i_TimerCounterWatchdogInterrupt == 1) {
 					i_CommandAndStatusValue = 0xC4;	/* Enable the interrupt */
 				}	/*  if(i_TimerCounterWatchdogInterrupt==1) */
 				else {
 					i_CommandAndStatusValue = 0xE4;	/* disable the interrupt */
 				}	/* elseif(i_TimerCounterWatchdogInterrupt==1) */
 					      /**************************/
 				/* Starts Watchdog/counter 3 */
 					      /**************************/
 				i_WatchdogCounter3Enabled = 1;
 						/********************************************/
 				/* Selects the commands and status register */
 						/********************************************/
 				outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 				outb(i_CommandAndStatusValue,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
 			}	/*  if( i_WatchdogCounter3init==1) */
 			else {
-				printk("\nWatchdog/Counter3 not configured\n");
+				dev_warn(dev->hw_dev,
+					"Watchdog/Counter3 not configured\n");
 				return -EINVAL;
 			}
 			break;
 
 		case STOP:
 
 					      /**************************/
 			/* Stop Watchdog/counter 3 */
 					      /**************************/
 
 						/********************************************/
 			/* Selects the commands and status register */
 						/********************************************/
 			outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			outb(0x00,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			i_WatchdogCounter3Enabled = 0;
@@ -2146,75 +2184,80 @@ static int i_apci1500_timer_watchdog(struct comedi_device *dev,
 					}	/* if( i_WatchdogCounter3Enabled==1) */
 					else {
 							   /***************/
 						/* Set Trigger */
 							   /***************/
 
 						i_CommandAndStatusValue = 0x2;
 					}	/* elseif(i_WatchdogCounter3Enabled==1) */
 
 						/********************************************/
 					/* Selects the commands and status register */
 						/********************************************/
 					outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 					outb(i_CommandAndStatusValue,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 				}	/* if( i_WatchdogCounter3Init==1) */
 				else {
-					printk("\nCounter3 not configured\n");
+					dev_warn(dev->hw_dev,
+						"Counter3 not configured\n");
 					return -EINVAL;
 				}
 				break;
 			case 1:
 				/* triggering Watchdog 3 */
 				if (i_WatchdogCounter3Init == 1) {
 
 						/********************************************/
 					/* Selects the commands and status register */
 						/********************************************/
 					outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 					outb(0x6,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 				}	/* if( i_WatchdogCounter3Init==1) */
 				else {
-					printk("\nWatchdog 3 not configured\n");
+					dev_warn(dev->hw_dev,
+						"Watchdog 3 not configured\n");
 					return -EINVAL;
 				}
 				break;
 			default:
-				printk("\nWrong choice of watchdog/counter3\n");
+				dev_warn(dev->hw_dev,
+					"Wrong choice of watchdog/counter3\n");
 				return -EINVAL;
 			}	/* switch(data[2]) */
 			break;
 		default:
-			printk("\nThe specified option for start/stop/trigger does not exist\n");
+			dev_warn(dev->hw_dev,
+				"The specified option for start/stop/trigger does not exist\n");
 			return -EINVAL;
 		}		/* switch(data[1]) */
 		break;
 	default:
-		printk("\nThe specified choice for counter/watchdog/timer does not exist\n");
+		dev_warn(dev->hw_dev,
+			"The specified choice for counter/watchdog/timer does not exist\n");
 		return -EINVAL;
 	}			/* switch(data[0]) */
 	return insn->n;
 }
 
 /*
 +----------------------------------------------------------------------------+
 | Function   Name   : int i_APCI1500_ReadCounterTimerWatchdog                |
 |			(struct comedi_device *dev,struct comedi_subdevice *s,struct comedi_insn *insn,
 |                    unsigned int *data); 	                                     |
 +----------------------------------------------------------------------------+
 | Task              : Read The Watchdog                                      |
 +----------------------------------------------------------------------------+
 | Input Parameters  :   struct comedi_device *dev      : Driver handle              |
 |                     struct comedi_subdevice *s,   :pointer to subdevice structure
 |                      struct comedi_insn *insn      :pointer to insn structure      |
 |                     unsigned int *data          : Data Pointer to read status  |
 |                      data[0]                : 0     Counter1/Timer1
 |                                               1     Counter2/Timer2
 |                                               2     Counter3/Watchdog
@@ -2266,41 +2309,42 @@ static int i_APCI1500_ReadCounterTimerWatchdog(struct comedi_device *dev,
 
 		 /***************************************/
 			/* Selects the counter register (high) */
 		 /***************************************/
 			outb(APCI1500_R_CPT_TMR1_VALUE_HIGH,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			data[0] =
 				inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			data[0] = data[0] << 8;
 			data[0] = data[0] & 0xff00;
 			outb(APCI1500_R_CPT_TMR1_VALUE_LOW,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			data[0] =
 				data[0] | inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 		}		/* if( i_TimerCounter1Init==1) */
 		else {
-			printk("\nTimer/Counter1 not configured\n");
+			dev_warn(dev->hw_dev,
+				"Timer/Counter1 not configured\n");
 			return -EINVAL;
 		}		/* elseif( i_TimerCounter1Init==1) */
 		break;
 	case COUNTER2:
 		/* Read counter/timer2 */
 		if (i_TimerCounter2Init == 1) {
 			if (i_TimerCounter2Enabled == 1) {
 		  /************************/
 				/* Set RCC and gate */
 		  /************************/
 
 				i_CommandAndStatusValue = 0xC;
 			}	/* if( i_TimerCounter2Init==1) */
 			else {
 		    /***************/
 				/* Set RCC */
 		    /***************/
 
 				i_CommandAndStatusValue = 0x8;
 			}	/* elseif(i_TimerCounter2Init==1) */
@@ -2317,41 +2361,42 @@ static int i_APCI1500_ReadCounterTimerWatchdog(struct comedi_device *dev,
 
 		 /***************************************/
 			/* Selects the counter register (high) */
 		 /***************************************/
 			outb(APCI1500_R_CPT_TMR2_VALUE_HIGH,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			data[0] =
 				inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			data[0] = data[0] << 8;
 			data[0] = data[0] & 0xff00;
 			outb(APCI1500_R_CPT_TMR2_VALUE_LOW,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			data[0] =
 				data[0] | inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 		}		/* if( i_TimerCounter2Init==1) */
 		else {
-			printk("\nTimer/Counter2 not configured\n");
+			dev_warn(dev->hw_dev,
+				"Timer/Counter2 not configured\n");
 			return -EINVAL;
 		}		/* elseif( i_TimerCounter2Init==1) */
 		break;
 	case COUNTER3:
 		/* Read counter/watchdog2 */
 		if (i_WatchdogCounter3Init == 1) {
 			if (i_WatchdogCounter3Enabled == 1) {
 		  /************************/
 				/* Set RCC and gate */
 		  /************************/
 
 				i_CommandAndStatusValue = 0xC;
 			}	/* if( i_TimerCounter2Init==1) */
 			else {
 		    /***************/
 				/* Set RCC */
 		    /***************/
 
 				i_CommandAndStatusValue = 0x8;
 			}	/* elseif(i_WatchdogCounter3Init==1) */
@@ -2368,46 +2413,48 @@ static int i_APCI1500_ReadCounterTimerWatchdog(struct comedi_device *dev,
 
 		 /***************************************/
 			/* Selects the counter register (high) */
 		 /***************************************/
 			outb(APCI1500_R_CPT_TMR3_VALUE_HIGH,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			data[0] =
 				inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			data[0] = data[0] << 8;
 			data[0] = data[0] & 0xff00;
 			outb(APCI1500_R_CPT_TMR3_VALUE_LOW,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			data[0] =
 				data[0] | inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 		}		/* if( i_WatchdogCounter3Init==1) */
 		else {
-			printk("\nWatchdogCounter3 not configured\n");
+			dev_warn(dev->hw_dev,
+				"WatchdogCounter3 not configured\n");
 			return -EINVAL;
 		}		/* elseif( i_WatchdogCounter3Init==1) */
 		break;
 	default:
-		printk("\nThe choice of timer/counter/watchdog does not exist\n");
+		dev_warn(dev->hw_dev,
+			"The choice of timer/counter/watchdog does not exist\n");
 		return -EINVAL;
 	}			/* switch(data[0]) */
 
 	return insn->n;
 }
 
 /*
 +----------------------------------------------------------------------------+
 | Function   Name   : int  i_APCI1500_ReadInterruptMask                      |
 |			(struct comedi_device *dev,struct comedi_subdevice *s,struct comedi_insn *insn,
 |                    unsigned int *data); 	                                     |
 +----------------------------------------------------------------------------+
 | Task              : Read the interrupt mask                                |
 +----------------------------------------------------------------------------+
 | Input Parameters  :   struct comedi_device *dev      : Driver handle              |
 |                     struct comedi_subdevice *s,   :pointer to subdevice structure
 |                      struct comedi_insn *insn      :pointer to insn structure      |
 |                     unsigned int *data          : Data Pointer to read status  |
 
 
@@ -2455,41 +2502,42 @@ static int i_APCI1500_ReadInterruptMask(struct comedi_device *dev,
 static int i_APCI1500_ConfigureInterrupt(struct comedi_device *dev,
 					 struct comedi_subdevice *s,
 					 struct comedi_insn *insn,
 					 unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	unsigned int ui_Status;
 	int i_RegValue;
 	int i_Constant;
 
 	devpriv->tsk_Current = current;
 	outl(0x0, devpriv->i_IobaseAmcc + 0x38);
 	if (data[0] == 1) {
 		i_Constant = 0xC0;
 	}			/* if(data[0]==1) */
 	else {
 		if (data[0] == 0) {
 			i_Constant = 0x00;
 		}		/* if{data[0]==0) */
 		else {
-			printk("\nThe parameter passed to driver is in error for enabling the voltage interrupt\n");
+			dev_warn(dev->hw_dev,
+				"The parameter passed to driver is in error for enabling the voltage interrupt\n");
 			return -EINVAL;
 		}		/* else if(data[0]==0) */
 	}			/* elseif(data[0]==1) */
 
 	 /*****************************************************/
 	/* Selects the mode specification register of port B */
 	 /*****************************************************/
 	outb(APCI1500_RW_PORT_B_SPECIFICATION,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	i_RegValue = inb(devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(APCI1500_RW_PORT_B_SPECIFICATION,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
       /*********************************************/
 	/* Writes the new configuration (APCI1500_OR) */
       /*********************************************/
 	i_RegValue = (i_RegValue & 0xF9) | APCI1500_OR;
 
 	outb(i_RegValue, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
        /*****************************************************/
 	/* Selects the command and status register of port B */
@@ -2713,41 +2761,40 @@ static void v_APCI1500_Interrupt(int irq, void *d)
 		/* Selects the command and status register of port B */
 	   /*****************************************************/
 		outb(APCI1500_RW_PORT_B_COMMAND_AND_STATUS,
 			devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		i_RegValue =
 			inb(devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		if ((i_RegValue & 0x60) == 0x60) {
 	     /*****************************************************/
 			/* Selects the command and status register of port B */
 	     /*****************************************************/
 			outb(APCI1500_RW_PORT_B_COMMAND_AND_STATUS,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 	     /***********************************/
 			/* Deletes the interrupt of port B */
 	     /***********************************/
 			i_RegValue = (i_RegValue & 0x0F) | 0x20;
 			outb(i_RegValue,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-			printk("\n\n\n");
 	     /****************/
 			/* Reads port B */
 	     /****************/
 			i_RegValue =
 				inb((unsigned int) devpriv->iobase +
 				APCI1500_Z8536_PORT_B);
 
 			i_RegValue = i_RegValue & 0xC0;
 	      /**************************************/
 			/* Tests if this is an external error */
 	      /**************************************/
 
 			if (i_RegValue) {
 				/* Disable the interrupt */
 		     /*****************************************************/
 				/* Selects the command and status register of port B */
 		     /*****************************************************/
 				outl(0x0, devpriv->i_IobaseAmcc + 0x38);
 
 				if (i_RegValue & 0x80) {
@@ -2840,41 +2887,42 @@ static void v_APCI1500_Interrupt(int irq, void *d)
 				i_InterruptMask = i_InterruptMask | 0x20;
 			}
 		}		/*  if ((i_RegValue & 0x60) == 0x60) */
 
 		send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
 	       /***********************/
 		/* Enable all Interrupts */
 	       /***********************/
 
 	       /*************************************************/
 		/* Selects the master interrupt control register */
 	       /*************************************************/
 		outb(APCI1500_RW_MASTER_INTERRUPT_CONTROL,
 			devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	       /**********************************************/
 		/* Authorizes the main interrupt on the board */
 	       /**********************************************/
 		outb(0xD0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	}			/*   if ((ui_InterruptStatus & 0x800000) == 0x800000) */
 	else {
-		printk("\nInterrupt from unknown source\n");
+		dev_warn(dev->hw_dev,
+			"Interrupt from unknown source\n");
 
 	}			/* else if ((ui_InterruptStatus & 0x800000) == 0x800000) */
 	return;
 }
 
 /*
 +----------------------------------------------------------------------------+
 | Function   Name   : int i_APCI1500_Reset(struct comedi_device *dev)               |                                                       |
 +----------------------------------------------------------------------------+
 | Task              :resets all the registers                                |
 +----------------------------------------------------------------------------+
 | Input Parameters  : struct comedi_device *dev
 +----------------------------------------------------------------------------+
 | Output Parameters :	--													 |
 +----------------------------------------------------------------------------+
 | Return Value      :                                                        |
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
 static int i_APCI1500_Reset(struct comedi_device *dev)
-- 
1.8.5.3

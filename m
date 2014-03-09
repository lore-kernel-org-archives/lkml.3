Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaCIQZC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 12:25:02 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:62092 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbaCIQY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 12:24:59 -0400
From: Conrad Meyer <cemeyer@uw.edu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Conrad Meyer <cse.cem@gmail.com>
Subject: [PATCH 2/2] Staging: comedi: Validate early to flatten code
Date: Sun,  9 Mar 2014 09:24:41 -0700
Message-Id: <1394382281-22712-2-git-send-email-cse.cem@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394382281-22712-1-git-send-email-cse.cem@gmail.com>
References: <1394382281-22712-1-git-send-email-cse.cem@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take advantage of -EINVAL returns to flatten code structure and
hopefully reduce the number of 80+ character lines.

Signed-off-by: Conrad Meyer <cse.cem@gmail.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      | 621 ++++++++++-----------
 1 file changed, 303 insertions(+), 318 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index e43db39..cdc6d3d 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -307,439 +307,424 @@ static int i_APCI1500_ConfigDigitalInputEvent(struct comedi_device *dev,
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
 			dev_warn(dev->hw_dev,
 				"The option indicated in the event mask does not exist\n");
 			return -EINVAL;
 		}
 	}
 
 	if (data[0] == 1) {
 		/* Test the interrupt logic */
 
-		if (data[1] == APCI1500_AND ||
-			data[1] == APCI1500_OR ||
-			data[1] == APCI1500_OR_PRIORITY) {
-			/* Tests if a transition was declared */
-			/* for a OR PRIORITY logic            */
-
-			if (data[1] == APCI1500_OR_PRIORITY
-				&& i_PatternTransition != 0) {
-				dev_warn(dev->hw_dev,
-					"Transition error on an OR PRIORITY logic\n");
-				return -EINVAL;
-			}
+		if (data[1] != APCI1500_AND && data[1] != APCI1500_OR &&
+			data[1] != APCI1500_OR_PRIORITY) {
+			dev_warn(dev->hw_dev,
+				"The choice for interrupt logic does not exist\n");
+			return -EINVAL;
+		}
 
-			/* Tests if more than one transition */
-			/* was declared for an AND logic     */
+		/* Tests if a transition was declared */
+		/* for a OR PRIORITY logic            */
 
-			if (data[1] == APCI1500_AND) {
-				for (i_Count = 0; i_Count < 8; i_Count++) {
-					i_PatternTransitionCount =
-						i_PatternTransitionCount +
-						((i_PatternTransition >>
-							i_Count) & 0x1);
+		if (data[1] == APCI1500_OR_PRIORITY
+			&& i_PatternTransition != 0) {
+			dev_warn(dev->hw_dev,
+				"Transition error on an OR PRIORITY logic\n");
+			return -EINVAL;
+		}
 
-				}
+		/* Tests if more than one transition */
+		/* was declared for an AND logic     */
 
-				if (i_PatternTransitionCount > 1) {
-					dev_warn(dev->hw_dev,
-						"Transition error on an AND logic\n");
-					return -EINVAL;
-				}
-			}
+		if (data[1] == APCI1500_AND) {
+			for (i_Count = 0; i_Count < 8; i_Count++) {
+				i_PatternTransitionCount =
+					i_PatternTransitionCount +
+					((i_PatternTransition >>
+						i_Count) & 0x1);
 
-			/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-			outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-			/* Disable Port A */
-			outb(0xF0,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-			/* Selects the polarity register of port 1    */
-			outb(APCI1500_RW_PORT_A_PATTERN_POLARITY,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-			outb(i_PatternPolarity,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-
-			/* Selects the pattern mask register of      */
-			/* port 1                                    */
-			outb(APCI1500_RW_PORT_A_PATTERN_MASK,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-			outb(i_PatternMask,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-			/* Selects the pattern transition register  */
-			/* of port 1                                */
-			outb(APCI1500_RW_PORT_A_PATTERN_TRANSITION,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-			outb(i_PatternTransition,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
+			}
 
-			/* Selects the mode specification mask    */
-			/* register of port 1                     */
-			outb(APCI1500_RW_PORT_A_SPECIFICATION,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-			i_RegValue =
-				inb(devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
+			if (i_PatternTransitionCount > 1) {
+				dev_warn(dev->hw_dev,
+					"Transition error on an AND logic\n");
+				return -EINVAL;
+			}
+		}
 
-			/* Selects the mode specification mask    */
-			/* register of port 1                     */
-			outb(APCI1500_RW_PORT_A_SPECIFICATION,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
+		/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
+		outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+		/* Disable Port A */
+		outb(0xF0,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+		/* Selects the polarity register of port 1    */
+		outb(APCI1500_RW_PORT_A_PATTERN_POLARITY,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+		outb(i_PatternPolarity,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+
+		/* Selects the pattern mask register of      */
+		/* port 1                                    */
+		outb(APCI1500_RW_PORT_A_PATTERN_MASK,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+		outb(i_PatternMask,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+		/* Selects the pattern transition register  */
+		/* of port 1                                */
+		outb(APCI1500_RW_PORT_A_PATTERN_TRANSITION,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+		outb(i_PatternTransition,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+
+		/* Selects the mode specification mask    */
+		/* register of port 1                     */
+		outb(APCI1500_RW_PORT_A_SPECIFICATION,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+		i_RegValue =
+			inb(devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
 
-			/* Port A new mode    */
+		/* Selects the mode specification mask    */
+		/* register of port 1                     */
+		outb(APCI1500_RW_PORT_A_SPECIFICATION,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
 
-			i_RegValue = (i_RegValue & 0xF9) | data[1] | 0x9;
-			outb(i_RegValue,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
+		/* Port A new mode    */
 
-			i_Event1Status = 1;
+		i_RegValue = (i_RegValue & 0xF9) | data[1] | 0x9;
+		outb(i_RegValue,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
 
-			/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
+		i_Event1Status = 1;
 
-			outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-			/* Enable Port A */
-			outb(0xF4,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
+		/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
 
-		} else {
-			dev_warn(dev->hw_dev,
-				"The choice for interrupt logic does not exist\n");
-			return -EINVAL;
-		}
+		outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+		/* Enable Port A */
+		outb(0xF4,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
 	}
 
 	/* Test if event setting for port 2 */
 
 	if (data[0] == 2) {
 		/* Test the event logic */
 
-		if (data[1] == APCI1500_OR) {
-			/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-			outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-			/* Disable Port B */
-			outb(0x74,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-			/* Selects the mode specification mask  */
-			/* register of port B                   */
-			outb(APCI1500_RW_PORT_B_SPECIFICATION,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-			i_RegValue =
-				inb(devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-
-			/* Selects the mode specification mask    */
-			/* register of port B                     */
-			outb(APCI1500_RW_PORT_B_SPECIFICATION,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-			i_RegValue = i_RegValue & 0xF9;
-			outb(i_RegValue,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-
-			/* Selects error channels 1 and 2 */
-
-			i_PatternMask = (i_PatternMask | 0xC0);
-			i_PatternPolarity = (i_PatternPolarity | 0xC0);
-			i_PatternTransition = (i_PatternTransition | 0xC0);
-
-			/* Selects the polarity register of port 2    */
-			outb(APCI1500_RW_PORT_B_PATTERN_POLARITY,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-			outb(i_PatternPolarity,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-			/* Selects the pattern transition register    */
-			/* of port 2                                  */
-			outb(APCI1500_RW_PORT_B_PATTERN_TRANSITION,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-			outb(i_PatternTransition,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-			/* Selects the pattern Mask register    */
-			/* of port 2                                  */
-
-			outb(APCI1500_RW_PORT_B_PATTERN_MASK,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-			outb(i_PatternMask,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-
-			/* Selects the mode specification mask    */
-			/* register of port 2                     */
-			outb(APCI1500_RW_PORT_B_SPECIFICATION,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-			i_RegValue =
-				inb(devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-			/* Selects the mode specification mask    */
-			/* register of port 2                     */
-			outb(APCI1500_RW_PORT_B_SPECIFICATION,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-			i_RegValue = (i_RegValue & 0xF9) | 4;
-			outb(i_RegValue,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-
-			i_Event2Status = 1;
-			/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-
-			outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-			/* Enable Port B */
-
-			outb(0xF4,
-				devpriv->iobase +
-				APCI1500_Z8536_CONTROL_REGISTER);
-		} else {
+		if (data[1] != APCI1500_OR) {
 			dev_warn(dev->hw_dev,
 				"The choice for interrupt logic does not exist\n");
 			return -EINVAL;
 		}
+
+		/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
+		outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+		/* Disable Port B */
+		outb(0x74,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+		/* Selects the mode specification mask  */
+		/* register of port B                   */
+		outb(APCI1500_RW_PORT_B_SPECIFICATION,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+		i_RegValue =
+			inb(devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+
+		/* Selects the mode specification mask    */
+		/* register of port B                     */
+		outb(APCI1500_RW_PORT_B_SPECIFICATION,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+		i_RegValue = i_RegValue & 0xF9;
+		outb(i_RegValue,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+
+		/* Selects error channels 1 and 2 */
+
+		i_PatternMask = (i_PatternMask | 0xC0);
+		i_PatternPolarity = (i_PatternPolarity | 0xC0);
+		i_PatternTransition = (i_PatternTransition | 0xC0);
+
+		/* Selects the polarity register of port 2    */
+		outb(APCI1500_RW_PORT_B_PATTERN_POLARITY,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+		outb(i_PatternPolarity,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+		/* Selects the pattern transition register    */
+		/* of port 2                                  */
+		outb(APCI1500_RW_PORT_B_PATTERN_TRANSITION,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+		outb(i_PatternTransition,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+		/* Selects the pattern Mask register    */
+		/* of port 2                                  */
+
+		outb(APCI1500_RW_PORT_B_PATTERN_MASK,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+		outb(i_PatternMask,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+
+		/* Selects the mode specification mask    */
+		/* register of port 2                     */
+		outb(APCI1500_RW_PORT_B_SPECIFICATION,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+		i_RegValue =
+			inb(devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+		/* Selects the mode specification mask    */
+		/* register of port 2                     */
+		outb(APCI1500_RW_PORT_B_SPECIFICATION,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+		i_RegValue = (i_RegValue & 0xF9) | 4;
+		outb(i_RegValue,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+
+		i_Event2Status = 1;
+		/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
+
+		outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
+		/* Enable Port B */
+
+		outb(0xF4,
+			devpriv->iobase +
+			APCI1500_Z8536_CONTROL_REGISTER);
 	}
 
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
 |                      data[1]                 :No of port (1 or 2)
 +----------------------------------------------------------------------------+
 | Output Parameters :	--													 |
 +----------------------------------------------------------------------------+
 | Return Value      : TRUE  : No error occur                                 |
 |		            : FALSE : Error occur. Return the error          |
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
 static int i_APCI1500_StartStopInputEvent(struct comedi_device *dev,
 					  struct comedi_subdevice *s,
 					  struct comedi_insn *insn,
 					  unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	int i_Event1InterruptStatus = 0, i_Event2InterruptStatus =
 		0, i_RegValue;
 
 	switch (data[0]) {
 	case START:
-		/* Tests the port number */
-
-		if (data[1] == 1 || data[1] == 2) {
-			/* Test if port 1 selected */
+		/* Test if port 1 selected */
+		if (data[1] == 1) {
+			/* Test if event initialised */
+			if (i_Event1Status != 1) {
+				dev_warn(dev->hw_dev,
+					"Event 1 not initialised\n");
+				return -EINVAL;
+			}
 
-			if (data[1] == 1) {
-				/* Test if event initialised */
-				if (i_Event1Status == 1) {
-					/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-					outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-					/* Disable Port A */
-					outb(0xF0,
-						devpriv->iobase +
-						APCI1500_Z8536_CONTROL_REGISTER);
-					/* Selects the command and status register of      */
-					/* port 1                                          */
-					outb(APCI1500_RW_PORT_A_COMMAND_AND_STATUS, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-					/* Allows the pattern interrupt      */
-					outb(0xC0,
-						devpriv->iobase +
-						APCI1500_Z8536_CONTROL_REGISTER);
-					/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-					outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-					/* Enable Port A */
-					outb(0xF4,
-						devpriv->iobase +
-						APCI1500_Z8536_CONTROL_REGISTER);
-					i_Event1InterruptStatus = 1;
-					outb(APCI1500_RW_PORT_A_SPECIFICATION,
-						devpriv->iobase +
-						APCI1500_Z8536_CONTROL_REGISTER);
-					i_RegValue =
-						inb(devpriv->iobase +
-						APCI1500_Z8536_CONTROL_REGISTER);
+			/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
+			outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
+			/* Disable Port A */
+			outb(0xF0,
+				devpriv->iobase +
+				APCI1500_Z8536_CONTROL_REGISTER);
+			/* Selects the command and status register of      */
+			/* port 1                                          */
+			outb(APCI1500_RW_PORT_A_COMMAND_AND_STATUS, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
+			/* Allows the pattern interrupt      */
+			outb(0xC0,
+				devpriv->iobase +
+				APCI1500_Z8536_CONTROL_REGISTER);
+			/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
+			outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
+			/* Enable Port A */
+			outb(0xF4,
+				devpriv->iobase +
+				APCI1500_Z8536_CONTROL_REGISTER);
+			i_Event1InterruptStatus = 1;
+			outb(APCI1500_RW_PORT_A_SPECIFICATION,
+				devpriv->iobase +
+				APCI1500_Z8536_CONTROL_REGISTER);
+			i_RegValue =
+				inb(devpriv->iobase +
+				APCI1500_Z8536_CONTROL_REGISTER);
 
-					/* Selects the master interrupt control register */
-					outb(APCI1500_RW_MASTER_INTERRUPT_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-					/* Authorizes the main interrupt on the board */
-					outb(0xD0,
-						devpriv->iobase +
-						APCI1500_Z8536_CONTROL_REGISTER);
+			/* Selects the master interrupt control register */
+			outb(APCI1500_RW_MASTER_INTERRUPT_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
+			/* Authorizes the main interrupt on the board */
+			outb(0xD0,
+				devpriv->iobase +
+				APCI1500_Z8536_CONTROL_REGISTER);
+		} else if (data[1] == 2) {
 
-				} else {
-					dev_warn(dev->hw_dev,
-						"Event 1 not initialised\n");
-					return -EINVAL;
-				}
+			if (i_Event2Status != 1) {
+				dev_warn(dev->hw_dev,
+					"Event 2 not initialised\n");
+				return -EINVAL;
 			}
-			if (data[1] == 2) {
 
-				if (i_Event2Status == 1) {
-					/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-					outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-					/* Disable Port B */
-					outb(0x74,
-						devpriv->iobase +
-						APCI1500_Z8536_CONTROL_REGISTER);
-					/* Selects the command and status register of      */
-					/* port 2                                          */
-					outb(APCI1500_RW_PORT_B_COMMAND_AND_STATUS, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-					/* Allows the pattern interrupt      */
-					outb(0xC0,
-						devpriv->iobase +
-						APCI1500_Z8536_CONTROL_REGISTER);
-					/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-					outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-					/* Enable Port B */
-					outb(0xF4,
-						devpriv->iobase +
-						APCI1500_Z8536_CONTROL_REGISTER);
+			/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
+			outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
+			/* Disable Port B */
+			outb(0x74,
+				devpriv->iobase +
+				APCI1500_Z8536_CONTROL_REGISTER);
+			/* Selects the command and status register of      */
+			/* port 2                                          */
+			outb(APCI1500_RW_PORT_B_COMMAND_AND_STATUS, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
+			/* Allows the pattern interrupt      */
+			outb(0xC0,
+				devpriv->iobase +
+				APCI1500_Z8536_CONTROL_REGISTER);
+			/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
+			outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
+			/* Enable Port B */
+			outb(0xF4,
+				devpriv->iobase +
+				APCI1500_Z8536_CONTROL_REGISTER);
 
-					/* Selects the master interrupt control register */
-					outb(APCI1500_RW_MASTER_INTERRUPT_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-					/* Authorizes the main interrupt on the board */
-					outb(0xD0,
-						devpriv->iobase +
-						APCI1500_Z8536_CONTROL_REGISTER);
-					i_Event2InterruptStatus = 1;
-				} else {
-					dev_warn(dev->hw_dev,
-						"Event 2 not initialised\n");
-					return -EINVAL;
-				}
-			}
+			/* Selects the master interrupt control register */
+			outb(APCI1500_RW_MASTER_INTERRUPT_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
+			/* Authorizes the main interrupt on the board */
+			outb(0xD0,
+				devpriv->iobase +
+				APCI1500_Z8536_CONTROL_REGISTER);
+			i_Event2InterruptStatus = 1;
 		} else {
 			dev_warn(dev->hw_dev,
 				"The port parameter is in error\n");
 			return -EINVAL;
 		}
 
 		break;
 
 	case STOP:
-		/* Tests the port number */
+		/* Test if port 1 selected */
 
-		if (data[1] == 1 || data[1] == 2) {
-			/* Test if port 1 selected */
-
-			if (data[1] == 1) {
-				/* Test if event initialised */
-				if (i_Event1Status == 1) {
-					/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-					outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-					/* Disable Port A */
-					outb(0xF0,
-						devpriv->iobase +
-						APCI1500_Z8536_CONTROL_REGISTER);
-					/* Selects the command and status register of      */
-					/* port 1                                          */
-					outb(APCI1500_RW_PORT_A_COMMAND_AND_STATUS, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-					/* Inhibits the pattern interrupt      */
-					outb(0xE0,
-						devpriv->iobase +
-						APCI1500_Z8536_CONTROL_REGISTER);
-					/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-					outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-					/* Enable Port A */
-					outb(0xF4,
-						devpriv->iobase +
-						APCI1500_Z8536_CONTROL_REGISTER);
-					i_Event1InterruptStatus = 0;
-				} else {
-					dev_warn(dev->hw_dev,
-						"Event 1 not initialised\n");
-					return -EINVAL;
-				}
+		if (data[1] == 1) {
+			/* Test if event initialised */
+			if (i_Event1Status != 1) {
+				dev_warn(dev->hw_dev,
+					"Event 1 not initialised\n");
+				return -EINVAL;
 			}
-			if (data[1] == 2) {
-				/* Test if event initialised */
-				if (i_Event2Status == 1) {
-					/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-					outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-					/* Disable Port B */
-					outb(0x74,
-						devpriv->iobase +
-						APCI1500_Z8536_CONTROL_REGISTER);
-					/* Selects the command and status register of      */
-					/* port 2                                         */
-					outb(APCI1500_RW_PORT_B_COMMAND_AND_STATUS, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-					/* Inhibits the pattern interrupt      */
-					outb(0xE0,
-						devpriv->iobase +
-						APCI1500_Z8536_CONTROL_REGISTER);
-					/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-					outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-					/* Enable Port B */
-					outb(0xF4,
-						devpriv->iobase +
-						APCI1500_Z8536_CONTROL_REGISTER);
-					i_Event2InterruptStatus = 0;
-				} else {
-					dev_warn(dev->hw_dev,
-						"Event 2 not initialised\n");
-					return -EINVAL;
-				}
+
+			/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
+			outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
+			/* Disable Port A */
+			outb(0xF0,
+				devpriv->iobase +
+				APCI1500_Z8536_CONTROL_REGISTER);
+			/* Selects the command and status register of      */
+			/* port 1                                          */
+			outb(APCI1500_RW_PORT_A_COMMAND_AND_STATUS, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
+			/* Inhibits the pattern interrupt      */
+			outb(0xE0,
+				devpriv->iobase +
+				APCI1500_Z8536_CONTROL_REGISTER);
+			/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
+			outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
+			/* Enable Port A */
+			outb(0xF4,
+				devpriv->iobase +
+				APCI1500_Z8536_CONTROL_REGISTER);
+			i_Event1InterruptStatus = 0;
+		} else if (data[1] == 2) {
+			/* Test if event initialised */
+			if (i_Event2Status != 1) {
+				dev_warn(dev->hw_dev,
+					"Event 2 not initialised\n");
+				return -EINVAL;
 			}
 
+			/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
+			outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
+			/* Disable Port B */
+			outb(0x74,
+				devpriv->iobase +
+				APCI1500_Z8536_CONTROL_REGISTER);
+			/* Selects the command and status register of      */
+			/* port 2                                         */
+			outb(APCI1500_RW_PORT_B_COMMAND_AND_STATUS, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
+			/* Inhibits the pattern interrupt      */
+			outb(0xE0,
+				devpriv->iobase +
+				APCI1500_Z8536_CONTROL_REGISTER);
+			/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
+			outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
+			/* Enable Port B */
+			outb(0xF4,
+				devpriv->iobase +
+				APCI1500_Z8536_CONTROL_REGISTER);
+			i_Event2InterruptStatus = 0;
 		} else {
 			dev_warn(dev->hw_dev,
 				"The port parameter is in error\n");
 			return -EINVAL;
 		}
 		break;
 	default:
 		dev_warn(dev->hw_dev,
 			"The option of START/STOP logic does not exist\n");
 		return -EINVAL;
 	}
 
 	return insn->n;
 }
 
 /*
 +----------------------------------------------------------------------------+
 | Function   Name   : int i_APCI1500_Initialisation                          |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
-- 
1.8.5.3


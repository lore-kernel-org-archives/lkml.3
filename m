Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaEXWZV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 18:25:21 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:61079 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaEXWZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 18:25:19 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 3/3] staging: comedi: addi_apci_1564: introduce apci1564_private struct
Date: Sat, 24 May 2014 17:25:07 -0500
Message-Id: <1400970307-21077-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1400970182-20196-1-git-send-email-chase.southwood@gmail.com>
References: <1400970182-20196-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The addi_private struct defined in addi-data/addi_common.h is very bloated
and contains many fields which addi_apci_1564 does not require.  In the
interest of eventually removing this driver's dependency on
addi_common.h, we can create a private data struct specifically for
addi_apci_1564 containing only the fields it will actually use.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
The idea behind this patch is that it will allow me to rewrite the
apci1564_cos_insn_config() function the same way that Hartley did for
addi_apci_1032.c, using new fields in this private struct.  As such, lots
of the fields currently in the struct (all but amcc_iobase, to be precise)
are just temporary, and more fields will be introduced in subsequent
patches as needed.  If this is not the best way to proceed then please
let me know and I will change my approach.

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 169 +++++++++++----------
 drivers/staging/comedi/drivers/addi_apci_1564.c    |  36 ++---
 2 files changed, 106 insertions(+), 99 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 847cf4c..1846638 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -49,7 +49,7 @@
 #define APCI1564_COUNTER4				3
 
 /*
- * devpriv->i_IobaseAmcc Register Map
+ * devpriv->amcc_iobase Register Map
  */
 #define APCI1564_DI_REG					0x04
 #define APCI1564_DI_INT_MODE1_REG			0x08
@@ -93,6 +93,13 @@
 static unsigned int ui_InterruptStatus_1564;
 static unsigned int ui_InterruptData, ui_Type;
 
+struct apci1564_private {
+	unsigned int amcc_iobase;	/* base of AMCC I/O registers */
+	unsigned char output_memory_status;
+	unsigned char timer_select_mode;
+	unsigned char mode_select_register;
+};
+
 /*
  * Configures the digital input Subdevice
  *
@@ -106,22 +113,22 @@ static int apci1564_cos_insn_config(struct comedi_device *dev,
 				    struct comedi_insn *insn,
 				    unsigned int *data)
 {
-	struct addi_private *devpriv = dev->private;
+	struct apci1564_private *devpriv = dev->private;
 
 	/* Set the digital input logic */
 	if (data[0] == ADDIDATA_ENABLE) {
 		data[2] = data[2] << 4;
 		data[3] = data[3] << 4;
-		outl(data[2], devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE1_REG);
-		outl(data[3], devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE2_REG);
+		outl(data[2], devpriv->amcc_iobase + APCI1564_DI_INT_MODE1_REG);
+		outl(data[3], devpriv->amcc_iobase + APCI1564_DI_INT_MODE2_REG);
 		if (data[1] == ADDIDATA_OR)
-			outl(0x4, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
+			outl(0x4, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
 		else
-			outl(0x6, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
+			outl(0x6, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
 	} else {
-		outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE1_REG);
-		outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE2_REG);
-		outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
+		outl(0x0, devpriv->amcc_iobase + APCI1564_DI_INT_MODE1_REG);
+		outl(0x0, devpriv->amcc_iobase + APCI1564_DI_INT_MODE2_REG);
+		outl(0x0, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
 	}
 
 	return insn->n;
@@ -138,7 +145,7 @@ static int apci1564_do_config(struct comedi_device *dev,
 			      struct comedi_insn *insn,
 			      unsigned int *data)
 {
-	struct addi_private *devpriv = dev->private;
+	struct apci1564_private *devpriv = dev->private;
 	unsigned int ul_Command = 0;
 
 	if ((data[0] != 0) && (data[0] != 1)) {
@@ -148,9 +155,9 @@ static int apci1564_do_config(struct comedi_device *dev,
 	}
 
 	if (data[0])
-		devpriv->b_OutputMemoryStatus = ADDIDATA_ENABLE;
+		devpriv->output_memory_status = ADDIDATA_ENABLE;
 	else
-		devpriv->b_OutputMemoryStatus = ADDIDATA_DISABLE;
+		devpriv->output_memory_status = ADDIDATA_DISABLE;
 
 	if (data[1] == ADDIDATA_ENABLE)
 		ul_Command = ul_Command | 0x1;
@@ -162,8 +169,8 @@ static int apci1564_do_config(struct comedi_device *dev,
 	else
 		ul_Command = ul_Command & 0xFFFFFFFD;
 
-	outl(ul_Command, devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
-	ui_InterruptData = inl(devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
+	outl(ul_Command, devpriv->amcc_iobase + APCI1564_DO_INT_CTRL_REG);
+	ui_InterruptData = inl(devpriv->amcc_iobase + APCI1564_DO_INT_CTRL_REG);
 	return insn->n;
 }
 
@@ -183,30 +190,30 @@ static int apci1564_timer_config(struct comedi_device *dev,
 				 struct comedi_insn *insn,
 				 unsigned int *data)
 {
-	struct addi_private *devpriv = dev->private;
+	struct apci1564_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0;
 
 	if (data[0] == ADDIDATA_WATCHDOG) {
-		devpriv->b_TimerSelectMode = ADDIDATA_WATCHDOG;
+		devpriv->timer_select_mode = ADDIDATA_WATCHDOG;
 
 		/* Disable the watchdog */
-		outl(0x0, devpriv->i_IobaseAmcc + APCI1564_WDOG_CTRL_REG);
+		outl(0x0, devpriv->amcc_iobase + APCI1564_WDOG_CTRL_REG);
 		/* Loading the Reload value */
-		outl(data[3], devpriv->i_IobaseAmcc + APCI1564_WDOG_RELOAD_REG);
+		outl(data[3], devpriv->amcc_iobase + APCI1564_WDOG_RELOAD_REG);
 	} else if (data[0] == ADDIDATA_TIMER) {
 		/* First Stop The Timer */
-		ul_Command1 = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
+		ul_Command1 = inl(devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
 		ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
 		/* Stop The Timer */
-		outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
+		outl(ul_Command1, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
 
-		devpriv->b_TimerSelectMode = ADDIDATA_TIMER;
+		devpriv->timer_select_mode = ADDIDATA_TIMER;
 		if (data[1] == 1) {
 			/* Enable TIMER int & DISABLE ALL THE OTHER int SOURCES */
-			outl(0x02, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
-			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
-			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_IRQ_REG);
-			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_WDOG_IRQ_REG);
+			outl(0x02, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
+			outl(0x0, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
+			outl(0x0, devpriv->amcc_iobase + APCI1564_DO_IRQ_REG);
+			outl(0x0, devpriv->amcc_iobase + APCI1564_WDOG_IRQ_REG);
 			outl(0x0,
 			     dev->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER1));
 			outl(0x0,
@@ -217,22 +224,22 @@ static int apci1564_timer_config(struct comedi_device *dev,
 			     dev->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER4));
 		} else {
 			/* disable Timer interrupt */
-			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
+			outl(0x0, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
 		}
 
 		/*  Loading Timebase */
-		outl(data[2], devpriv->i_IobaseAmcc + APCI1564_TIMER_TIMEBASE_REG);
+		outl(data[2], devpriv->amcc_iobase + APCI1564_TIMER_TIMEBASE_REG);
 
 		/* Loading the Reload value */
-		outl(data[3], devpriv->i_IobaseAmcc + APCI1564_TIMER_RELOAD_REG);
+		outl(data[3], devpriv->amcc_iobase + APCI1564_TIMER_RELOAD_REG);
 
-		ul_Command1 = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
+		ul_Command1 = inl(devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
 		ul_Command1 = (ul_Command1 & 0xFFF719E2UL) | 2UL << 13UL | 0x10UL;
 		/* mode 2 */
-		outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
+		outl(ul_Command1, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
 	} else if (data[0] == ADDIDATA_COUNTER) {
-		devpriv->b_TimerSelectMode = ADDIDATA_COUNTER;
-		devpriv->b_ModeSelectRegister = data[5];
+		devpriv->timer_select_mode = ADDIDATA_COUNTER;
+		devpriv->mode_select_register = data[5];
 
 		/* First Stop The Counter */
 		ul_Command1 = inl(dev->iobase + APCI1564_TCW_CTRL_REG(data[5] - 1));
@@ -281,45 +288,45 @@ static int apci1564_timer_write(struct comedi_device *dev,
 				struct comedi_insn *insn,
 				unsigned int *data)
 {
-	struct addi_private *devpriv = dev->private;
+	struct apci1564_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0;
 
-	if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
+	if (devpriv->timer_select_mode == ADDIDATA_WATCHDOG) {
 		switch (data[1]) {
 		case 0:	/* stop the watchdog */
 			/* disable the watchdog */
-			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_WDOG_CTRL_REG);
+			outl(0x0, devpriv->amcc_iobase + APCI1564_WDOG_CTRL_REG);
 			break;
 		case 1:	/* start the watchdog */
-			outl(0x0001, devpriv->i_IobaseAmcc + APCI1564_WDOG_CTRL_REG);
+			outl(0x0001, devpriv->amcc_iobase + APCI1564_WDOG_CTRL_REG);
 			break;
 		case 2:	/* Software trigger */
-			outl(0x0201, devpriv->i_IobaseAmcc + APCI1564_WDOG_CTRL_REG);
+			outl(0x0201, devpriv->amcc_iobase + APCI1564_WDOG_CTRL_REG);
 			break;
 		default:
 			dev_err(dev->class_dev, "Specified functionality does not exist.\n");
 			return -EINVAL;
 		}
 	}
-	if (devpriv->b_TimerSelectMode == ADDIDATA_TIMER) {
+	if (devpriv->timer_select_mode == ADDIDATA_TIMER) {
 		if (data[1] == 1) {
-			ul_Command1 = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
+			ul_Command1 = inl(devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
 			ul_Command1 = (ul_Command1 & 0xFFFFF9FFUL) | 0x1UL;
 
 			/* Enable the Timer */
-			outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
+			outl(ul_Command1, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
 		} else if (data[1] == 0) {
 			/* Stop The Timer */
 
-			ul_Command1 = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
+			ul_Command1 = inl(devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
 			ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
-			outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
+			outl(ul_Command1, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
 		}
 	}
-	if (devpriv->b_TimerSelectMode == ADDIDATA_COUNTER) {
+	if (devpriv->timer_select_mode == ADDIDATA_COUNTER) {
 		ul_Command1 =
 			inl(dev->iobase +
-			    APCI1564_TCW_CTRL_REG(devpriv->b_ModeSelectRegister - 1));
+			    APCI1564_TCW_CTRL_REG(devpriv->mode_select_register - 1));
 		if (data[1] == 1) {
 			/* Start the Counter subdevice */
 			ul_Command1 = (ul_Command1 & 0xFFFFF9FFUL) | 0x1UL;
@@ -332,7 +339,7 @@ static int apci1564_timer_write(struct comedi_device *dev,
 			ul_Command1 = (ul_Command1 & 0xFFFFF9FFUL) | 0x400;
 		}
 		outl(ul_Command1, dev->iobase +
-		     APCI1564_TCW_CTRL_REG(devpriv->b_ModeSelectRegister - 1));
+		     APCI1564_TCW_CTRL_REG(devpriv->mode_select_register - 1));
 	}
 	return insn->n;
 }
@@ -345,27 +352,27 @@ static int apci1564_timer_read(struct comedi_device *dev,
 			       struct comedi_insn *insn,
 			       unsigned int *data)
 {
-	struct addi_private *devpriv = dev->private;
+	struct apci1564_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0;
 
-	if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
+	if (devpriv->timer_select_mode == ADDIDATA_WATCHDOG) {
 		/*  Stores the status of the Watchdog */
-		data[0] = inl(devpriv->i_IobaseAmcc + APCI1564_WDOG_STATUS_REG) & 0x1;
-		data[1] = inl(devpriv->i_IobaseAmcc + APCI1564_WDOG_REG);
-	} else if (devpriv->b_TimerSelectMode == ADDIDATA_TIMER) {
+		data[0] = inl(devpriv->amcc_iobase + APCI1564_WDOG_STATUS_REG) & 0x1;
+		data[1] = inl(devpriv->amcc_iobase + APCI1564_WDOG_REG);
+	} else if (devpriv->timer_select_mode == ADDIDATA_TIMER) {
 		/*  Stores the status of the Timer */
-		data[0] = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER_STATUS_REG) & 0x1;
+		data[0] = inl(devpriv->amcc_iobase + APCI1564_TIMER_STATUS_REG) & 0x1;
 
 		/*  Stores the Actual value of the Timer */
-		data[1] = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER_REG);
-	} else if (devpriv->b_TimerSelectMode == ADDIDATA_COUNTER) {
+		data[1] = inl(devpriv->amcc_iobase + APCI1564_TIMER_REG);
+	} else if (devpriv->timer_select_mode == ADDIDATA_COUNTER) {
 		/*  Read the Counter Actual Value. */
 		data[0] =
 			inl(dev->iobase +
-			    APCI1564_TCW_REG(devpriv->b_ModeSelectRegister - 1));
+			    APCI1564_TCW_REG(devpriv->mode_select_register - 1));
 		ul_Command1 =
 			inl(dev->iobase +
-			    APCI1564_TCW_STATUS_REG(devpriv->b_ModeSelectRegister - 1));
+			    APCI1564_TCW_STATUS_REG(devpriv->mode_select_register - 1));
 
 		/* Get the software trigger status */
 		data[1] = (unsigned char) ((ul_Command1 >> 1) & 1);
@@ -378,9 +385,9 @@ static int apci1564_timer_read(struct comedi_device *dev,
 
 		/* Get the overflow status */
 		data[4] = (unsigned char) ((ul_Command1 >> 0) & 1);
-	} else if ((devpriv->b_TimerSelectMode != ADDIDATA_TIMER)
-		&& (devpriv->b_TimerSelectMode != ADDIDATA_WATCHDOG)
-		&& (devpriv->b_TimerSelectMode != ADDIDATA_COUNTER)) {
+	} else if ((devpriv->timer_select_mode != ADDIDATA_TIMER)
+		&& (devpriv->timer_select_mode != ADDIDATA_WATCHDOG)
+		&& (devpriv->timer_select_mode != ADDIDATA_COUNTER)) {
 		dev_err(dev->class_dev, "Invalid Subdevice!\n");
 	}
 	return insn->n;
@@ -404,15 +411,15 @@ static int apci1564_do_read(struct comedi_device *dev,
 static void apci1564_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
-	struct addi_private *devpriv = dev->private;
+	struct apci1564_private *devpriv = dev->private;
 	unsigned int ui_DO, ui_DI;
 	unsigned int ui_Timer;
 	unsigned int ui_C1, ui_C2, ui_C3, ui_C4;
 	unsigned int ul_Command2 = 0;
 
-	ui_DI = inl(devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG) & 0x01;
-	ui_DO = inl(devpriv->i_IobaseAmcc + APCI1564_DO_IRQ_REG) & 0x01;
-	ui_Timer = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER_IRQ_REG) & 0x01;
+	ui_DI = inl(devpriv->amcc_iobase + APCI1564_DI_IRQ_REG) & 0x01;
+	ui_DO = inl(devpriv->amcc_iobase + APCI1564_DO_IRQ_REG) & 0x01;
+	ui_Timer = inl(devpriv->amcc_iobase + APCI1564_TIMER_IRQ_REG) & 0x01;
 	ui_C1 =
 		inl(dev->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER1)) & 0x1;
 	ui_C2 =
@@ -427,13 +434,13 @@ static void apci1564_interrupt(int irq, void *d)
 	}
 
 	if (ui_DI == 1) {
-		ui_DI = inl(devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
-		outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
+		ui_DI = inl(devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
+		outl(0x0, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
 		ui_InterruptStatus_1564 =
-			inl(devpriv->i_IobaseAmcc + APCI1564_DI_INT_STATUS_REG);
+			inl(devpriv->amcc_iobase + APCI1564_DI_INT_STATUS_REG);
 		ui_InterruptStatus_1564 = ui_InterruptStatus_1564 & 0X000FFFF0;
 		/* enable the interrupt */
-		outl(ui_DI, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
+		outl(ui_DI, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
 		return;
 	}
 
@@ -441,29 +448,29 @@ static void apci1564_interrupt(int irq, void *d)
 		/* Check for Digital Output interrupt Type */
 		/* 1: VCC interrupt			   */
 		/* 2: CC interrupt			   */
-		ui_Type = inl(devpriv->i_IobaseAmcc + APCI1564_DO_INT_STATUS_REG) & 0x3;
+		ui_Type = inl(devpriv->amcc_iobase + APCI1564_DO_INT_STATUS_REG) & 0x3;
 		/* Disable the  Interrupt */
-		outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
+		outl(0x0, devpriv->amcc_iobase + APCI1564_DO_INT_CTRL_REG);
 
 	}
 
 	if (ui_Timer == 1) {
-		devpriv->b_TimerSelectMode = ADDIDATA_TIMER;
-		if (devpriv->b_TimerSelectMode) {
+		devpriv->timer_select_mode = ADDIDATA_TIMER;
+		if (devpriv->timer_select_mode) {
 
 			/*  Disable Timer Interrupt */
-			ul_Command2 = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
-			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
+			ul_Command2 = inl(devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
+			outl(0x0, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
 
 			/*  Enable Timer Interrupt */
 
-			outl(ul_Command2, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
+			outl(ul_Command2, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
 		}
 	}
 
 	if (ui_C1 == 1) {
-		devpriv->b_TimerSelectMode = ADDIDATA_COUNTER;
-		if (devpriv->b_TimerSelectMode) {
+		devpriv->timer_select_mode = ADDIDATA_COUNTER;
+		if (devpriv->timer_select_mode) {
 
 			/*  Disable Counter Interrupt */
 			ul_Command2 =
@@ -478,8 +485,8 @@ static void apci1564_interrupt(int irq, void *d)
 	}
 
 	if (ui_C2 == 1) {
-		devpriv->b_TimerSelectMode = ADDIDATA_COUNTER;
-		if (devpriv->b_TimerSelectMode) {
+		devpriv->timer_select_mode = ADDIDATA_COUNTER;
+		if (devpriv->timer_select_mode) {
 
 			/*  Disable Counter Interrupt */
 			ul_Command2 =
@@ -494,8 +501,8 @@ static void apci1564_interrupt(int irq, void *d)
 	}
 
 	if (ui_C3 == 1) {
-		devpriv->b_TimerSelectMode = ADDIDATA_COUNTER;
-		if (devpriv->b_TimerSelectMode) {
+		devpriv->timer_select_mode = ADDIDATA_COUNTER;
+		if (devpriv->timer_select_mode) {
 
 			/*  Disable Counter Interrupt */
 			ul_Command2 =
@@ -510,8 +517,8 @@ static void apci1564_interrupt(int irq, void *d)
 	}
 
 	if (ui_C4 == 1) {
-		devpriv->b_TimerSelectMode = ADDIDATA_COUNTER;
-		if (devpriv->b_TimerSelectMode) {
+		devpriv->timer_select_mode = ADDIDATA_COUNTER;
+		if (devpriv->timer_select_mode) {
 
 			/*  Disable Counter Interrupt */
 			ul_Command2 =
diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 6af1e4c..f81ccac 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -19,9 +19,9 @@ static int apci1564_di_insn_bits(struct comedi_device *dev,
 				 struct comedi_insn *insn,
 				 unsigned int *data)
 {
-	struct addi_private *devpriv = dev->private;
+	struct apci1564_private *devpriv = dev->private;
 
-	data[1] = inl(devpriv->i_IobaseAmcc + APCI1564_DI_REG);
+	data[1] = inl(devpriv->amcc_iobase + APCI1564_DI_REG);
 
 	return insn->n;
 }
@@ -31,12 +31,12 @@ static int apci1564_do_insn_bits(struct comedi_device *dev,
 				 struct comedi_insn *insn,
 				 unsigned int *data)
 {
-	struct addi_private *devpriv = dev->private;
+	struct apci1564_private *devpriv = dev->private;
 
-	s->state = inl(devpriv->i_IobaseAmcc + APCI1564_DO_REG);
+	s->state = inl(devpriv->amcc_iobase + APCI1564_DO_REG);
 
 	if (comedi_dio_update_state(s, data))
-		outl(s->state, devpriv->i_IobaseAmcc + APCI1564_DO_REG);
+		outl(s->state, devpriv->amcc_iobase + APCI1564_DO_REG);
 
 	data[1] = s->state;
 
@@ -45,26 +45,26 @@ static int apci1564_do_insn_bits(struct comedi_device *dev,
 
 static int apci1564_reset(struct comedi_device *dev)
 {
-	struct addi_private *devpriv = dev->private;
+	struct apci1564_private *devpriv = dev->private;
 
 	ui_Type = 0;
 
 	/* Disable the input interrupts and reset status register */
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
-	inl(devpriv->i_IobaseAmcc + APCI1564_DI_INT_STATUS_REG);
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE1_REG);
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE2_REG);
+	outl(0x0, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
+	inl(devpriv->amcc_iobase + APCI1564_DI_INT_STATUS_REG);
+	outl(0x0, devpriv->amcc_iobase + APCI1564_DI_INT_MODE1_REG);
+	outl(0x0, devpriv->amcc_iobase + APCI1564_DI_INT_MODE2_REG);
 
 	/* Reset the output channels and disable interrupts */
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_REG);
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
+	outl(0x0, devpriv->amcc_iobase + APCI1564_DO_REG);
+	outl(0x0, devpriv->amcc_iobase + APCI1564_DO_INT_CTRL_REG);
 
 	/* Reset the watchdog registers */
-	addi_watchdog_reset(devpriv->i_IobaseAmcc + APCI1564_WDOG_REG);
+	addi_watchdog_reset(devpriv->amcc_iobase + APCI1564_WDOG_REG);
 
 	/* Reset the timer registers */
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_RELOAD_REG);
+	outl(0x0, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
+	outl(0x0, devpriv->amcc_iobase + APCI1564_TIMER_RELOAD_REG);
 
 	/* Reset the counter registers */
 	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
@@ -79,7 +79,7 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 				      unsigned long context_unused)
 {
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
-	struct addi_private *devpriv;
+	struct apci1564_private *devpriv;
 	struct comedi_subdevice *s;
 	int ret;
 
@@ -94,7 +94,7 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 		return ret;
 
 	dev->iobase = pci_resource_start(pcidev, 1);
-	devpriv->i_IobaseAmcc = pci_resource_start(pcidev, 0);
+	devpriv->amcc_iobase = pci_resource_start(pcidev, 0);
 
 	apci1564_reset(dev);
 
@@ -163,7 +163,7 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 
 static void apci1564_detach(struct comedi_device *dev)
 {
-	struct addi_private *devpriv = dev->private;
+	struct apci1564_private *devpriv = dev->private;
 
 	if (devpriv) {
 		if (dev->iobase)
-- 
1.9.0


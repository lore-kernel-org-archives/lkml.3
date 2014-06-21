Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbaFUW0Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 18:26:16 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:35281 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbaFUW0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 18:26:14 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH v3 3/5] staging: comedi: addi_apci_1564: introduce apci1564_private struct
Date: Sat, 21 Jun 2014 17:25:43 -0500
Message-Id: <1403389543-20334-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403389429-19793-1-git-send-email-chase.southwood@gmail.com>
References: <1403389429-19793-1-git-send-email-chase.southwood@gmail.com>
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
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 182 ++++++++++-----------
 drivers/staging/comedi/drivers/addi_apci_1564.c    |  46 +++---
 2 files changed, 118 insertions(+), 110 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 95038f2..732f43c 100644
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
@@ -89,9 +89,6 @@
 #define APCI1564_TCW_WARN_TIMEVAL_REG(x)		(0x18 + ((x) * 0x20))
 #define APCI1564_TCW_WARN_TIMEBASE_REG(x)		(0x1c + ((x) * 0x20))
 
-/* Global variables */
-static unsigned int ui_Type;
-
 /*
  * Configures the digital input Subdevice
  *
@@ -105,24 +102,24 @@ static int apci1564_di_config(struct comedi_device *dev,
 			      struct comedi_insn *insn,
 			      unsigned int *data)
 {
-	struct addi_private *devpriv = dev->private;
+	struct apci1564_private *devpriv = dev->private;
 
-	devpriv->tsk_Current = current;
+	devpriv->tsk_current = current;
 
 	/* Set the digital input logic */
 	if (data[0] == 1) {
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
@@ -139,7 +136,7 @@ static int apci1564_do_config(struct comedi_device *dev,
 			      struct comedi_insn *insn,
 			      unsigned int *data)
 {
-	struct addi_private *devpriv = dev->private;
+	struct apci1564_private *devpriv = dev->private;
 	unsigned int ul_Command = 0;
 
 	if ((data[0] != 0) && (data[0] != 1)) {
@@ -158,8 +155,8 @@ static int apci1564_do_config(struct comedi_device *dev,
 	else
 		ul_Command = ul_Command & 0xFFFFFFFD;
 
-	outl(ul_Command, devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
-	devpriv->tsk_Current = current;
+	outl(ul_Command, devpriv->amcc_iobase + APCI1564_DO_INT_CTRL_REG);
+	devpriv->tsk_current = current;
 	return insn->n;
 }
 
@@ -179,31 +176,31 @@ static int apci1564_timer_config(struct comedi_device *dev,
 				 struct comedi_insn *insn,
 				 unsigned int *data)
 {
-	struct addi_private *devpriv = dev->private;
+	struct apci1564_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0;
 
-	devpriv->tsk_Current = current;
+	devpriv->tsk_current = current;
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
@@ -214,22 +211,22 @@ static int apci1564_timer_config(struct comedi_device *dev,
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
@@ -278,45 +275,45 @@ static int apci1564_timer_write(struct comedi_device *dev,
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
@@ -329,7 +326,7 @@ static int apci1564_timer_write(struct comedi_device *dev,
 			ul_Command1 = (ul_Command1 & 0xFFFFF9FFUL) | 0x400;
 		}
 		outl(ul_Command1, dev->iobase +
-		     APCI1564_TCW_CTRL_REG(devpriv->b_ModeSelectRegister - 1));
+		     APCI1564_TCW_CTRL_REG(devpriv->mode_select_register - 1));
 	}
 	return insn->n;
 }
@@ -342,27 +339,27 @@ static int apci1564_timer_read(struct comedi_device *dev,
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
@@ -375,9 +372,9 @@ static int apci1564_timer_read(struct comedi_device *dev,
 
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
@@ -391,7 +388,9 @@ static int apci1564_do_read(struct comedi_device *dev,
 			    struct comedi_insn *insn,
 			    unsigned int *data)
 {
-	*data = ui_Type;
+	struct apci1564_private *devpriv = dev->private;
+
+	*data = devpriv->do_int_type;
 	return insn->n;
 }
 
@@ -401,15 +400,15 @@ static int apci1564_do_read(struct comedi_device *dev,
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
@@ -424,12 +423,12 @@ static void apci1564_interrupt(int irq, void *d)
 	}
 
 	if (ui_DI == 1) {
-		ui_DI = inl(devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
-		outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
+		ui_DI = inl(devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
+		outl(0x0, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
 		/* send signal to the sample */
-		send_sig(SIGIO, devpriv->tsk_Current, 0);
+		send_sig(SIGIO, devpriv->tsk_current, 0);
 		/* enable the interrupt */
-		outl(ui_DI, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
+		outl(ui_DI, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
 		return;
 	}
 
@@ -437,34 +436,35 @@ static void apci1564_interrupt(int irq, void *d)
 		/* Check for Digital Output interrupt Type */
 		/* 1: VCC interrupt			   */
 		/* 2: CC interrupt			   */
-		ui_Type = inl(devpriv->i_IobaseAmcc + APCI1564_DO_INT_STATUS_REG) & 0x3;
+		devpriv->do_int_type = inl(devpriv->amcc_iobase +
+					  APCI1564_DO_INT_STATUS_REG) & 0x3;
 		/* Disable the  Interrupt */
-		outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
+		outl(0x0, devpriv->amcc_iobase + APCI1564_DO_INT_CTRL_REG);
 
 		/* Sends signal to user space */
-		send_sig(SIGIO, devpriv->tsk_Current, 0);
+		send_sig(SIGIO, devpriv->tsk_current, 0);
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
 
 			/* Send a signal to from kernel to user space */
-			send_sig(SIGIO, devpriv->tsk_Current, 0);
+			send_sig(SIGIO, devpriv->tsk_current, 0);
 
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
@@ -473,7 +473,7 @@ static void apci1564_interrupt(int irq, void *d)
 			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
 
 			/* Send a signal to from kernel to user space */
-			send_sig(SIGIO, devpriv->tsk_Current, 0);
+			send_sig(SIGIO, devpriv->tsk_current, 0);
 
 			/*  Enable Counter Interrupt */
 			outl(ul_Command2,
@@ -482,8 +482,8 @@ static void apci1564_interrupt(int irq, void *d)
 	}
 
 	if (ui_C2 == 1) {
-		devpriv->b_TimerSelectMode = ADDIDATA_COUNTER;
-		if (devpriv->b_TimerSelectMode) {
+		devpriv->timer_select_mode = ADDIDATA_COUNTER;
+		if (devpriv->timer_select_mode) {
 
 			/*  Disable Counter Interrupt */
 			ul_Command2 =
@@ -492,7 +492,7 @@ static void apci1564_interrupt(int irq, void *d)
 			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
 
 			/* Send a signal to from kernel to user space */
-			send_sig(SIGIO, devpriv->tsk_Current, 0);
+			send_sig(SIGIO, devpriv->tsk_current, 0);
 
 			/*  Enable Counter Interrupt */
 			outl(ul_Command2,
@@ -501,8 +501,8 @@ static void apci1564_interrupt(int irq, void *d)
 	}
 
 	if (ui_C3 == 1) {
-		devpriv->b_TimerSelectMode = ADDIDATA_COUNTER;
-		if (devpriv->b_TimerSelectMode) {
+		devpriv->timer_select_mode = ADDIDATA_COUNTER;
+		if (devpriv->timer_select_mode) {
 
 			/*  Disable Counter Interrupt */
 			ul_Command2 =
@@ -511,7 +511,7 @@ static void apci1564_interrupt(int irq, void *d)
 			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
 
 			/* Send a signal to from kernel to user space */
-			send_sig(SIGIO, devpriv->tsk_Current, 0);
+			send_sig(SIGIO, devpriv->tsk_current, 0);
 
 			/*  Enable Counter Interrupt */
 			outl(ul_Command2,
@@ -520,8 +520,8 @@ static void apci1564_interrupt(int irq, void *d)
 	}
 
 	if (ui_C4 == 1) {
-		devpriv->b_TimerSelectMode = ADDIDATA_COUNTER;
-		if (devpriv->b_TimerSelectMode) {
+		devpriv->timer_select_mode = ADDIDATA_COUNTER;
+		if (devpriv->timer_select_mode) {
 
 			/*  Disable Counter Interrupt */
 			ul_Command2 =
@@ -530,7 +530,7 @@ static void apci1564_interrupt(int irq, void *d)
 			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
 
 			/* Send a signal to from kernel to user space */
-			send_sig(SIGIO, devpriv->tsk_Current, 0);
+			send_sig(SIGIO, devpriv->tsk_current, 0);
 
 			/*  Enable Counter Interrupt */
 			outl(ul_Command2,
diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 13d9962..1971da3 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -6,6 +6,14 @@
 
 #include "addi-data/addi_common.h"
 
+struct apci1564_private {
+	unsigned int amcc_iobase;	/* base of AMCC I/O registers */
+	unsigned int do_int_type;
+	unsigned char timer_select_mode;
+	unsigned char mode_select_register;
+	struct task_struct *tsk_current;
+};
+
 #include "addi-data/hwdrv_apci1564.c"
 
 static irqreturn_t v_ADDI_Interrupt(int irq, void *d)
@@ -19,9 +27,9 @@ static int apci1564_di_insn_bits(struct comedi_device *dev,
 				 struct comedi_insn *insn,
 				 unsigned int *data)
 {
-	struct addi_private *devpriv = dev->private;
+	struct apci1564_private *devpriv = dev->private;
 
-	data[1] = inl(devpriv->i_IobaseAmcc + APCI1564_DI_REG);
+	data[1] = inl(devpriv->amcc_iobase + APCI1564_DI_REG);
 
 	return insn->n;
 }
@@ -31,12 +39,12 @@ static int apci1564_do_insn_bits(struct comedi_device *dev,
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
 
@@ -45,26 +53,26 @@ static int apci1564_do_insn_bits(struct comedi_device *dev,
 
 static int apci1564_reset(struct comedi_device *dev)
 {
-	struct addi_private *devpriv = dev->private;
+	struct apci1564_private *devpriv = dev->private;
 
-	ui_Type = 0;
+	devpriv->do_int_type = 0;
 
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
@@ -79,7 +87,7 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 				      unsigned long context_unused)
 {
 	struct pci_dev *pcidev = comedi_to_pci_dev(dev);
-	struct addi_private *devpriv;
+	struct apci1564_private *devpriv;
 	struct comedi_subdevice *s;
 	int ret;
 
@@ -94,7 +102,7 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 		return ret;
 
 	dev->iobase = pci_resource_start(pcidev, 1);
-	devpriv->i_IobaseAmcc = pci_resource_start(pcidev, 0);
+	devpriv->amcc_iobase = pci_resource_start(pcidev, 0);
 
 	apci1564_reset(dev);
 
@@ -149,7 +157,7 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 
 static void apci1564_detach(struct comedi_device *dev)
 {
-	struct addi_private *devpriv = dev->private;
+	struct apci1564_private *devpriv = dev->private;
 
 	if (devpriv) {
 		if (dev->iobase)
-- 
1.9.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbaE3EoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 00:44:05 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:52681 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365AbaE3EoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 00:44:03 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 6/6] staging: comedi: addi_apci_1564: cleanup v_ADDI_Interrupt()
Date: Thu, 29 May 2014 23:43:52 -0500
Message-Id: <1401425032-22721-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401424853-21683-1-git-send-email-chase.southwood@gmail.com>
References: <1401424853-21683-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the function apci1564_interrupt() from hwdrv_apci1564.c to
addi_apci_1564.c.  On moving, for now just strip out all of the
code for interrupts that the driver does not yet support at this
time.

Rename the variable ui_InterruptStatus_1564 to ctrl, and change the return
from IRQ_RETVAL(1) to IRQ_HANDLED.

We also check the device is asserting the shared interrupt line and check
that interrupts have been enabled.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---

Admittedly, I am not sure if what I have done in the interrupt handler is
quite sufficient.  Am I missing anything that should be there due to the
fact that the handler does not yet support all of the types of interrupt
that the board is capable of issuing (i.e. does the interrupt handler need
to clear the other interrupts just in case they get triggered, etc?)

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 130 ---------------------
 drivers/staging/comedi/drivers/addi_apci_1564.c    |  34 +++++-
 2 files changed, 30 insertions(+), 134 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 41aa889..ebd763b 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -90,7 +90,6 @@
 #define APCI1564_TCW_WARN_TIMEBASE_REG(x)		(0x1c + ((x) * 0x20))
 
 /* Global variables */
-static unsigned int ui_InterruptStatus_1564;
 static unsigned int ui_InterruptData, ui_Type;
 
 struct apci1564_private {
@@ -367,132 +366,3 @@ static int apci1564_do_read(struct comedi_device *dev,
 	*data = ui_Type;
 	return insn->n;
 }
-
-/*
- * Interrupt handler for the interruptible digital inputs
- */
-static void apci1564_interrupt(int irq, void *d)
-{
-	struct comedi_device *dev = d;
-	struct apci1564_private *devpriv = dev->private;
-	unsigned int ui_DO, ui_DI;
-	unsigned int ui_Timer;
-	unsigned int ui_C1, ui_C2, ui_C3, ui_C4;
-	unsigned int ul_Command2 = 0;
-
-	ui_DI = inl(devpriv->amcc_iobase + APCI1564_DI_IRQ_REG) & 0x01;
-	ui_DO = inl(devpriv->amcc_iobase + APCI1564_DO_IRQ_REG) & 0x01;
-	ui_Timer = inl(devpriv->amcc_iobase + APCI1564_TIMER_IRQ_REG) & 0x01;
-	ui_C1 =
-		inl(dev->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER1)) & 0x1;
-	ui_C2 =
-		inl(dev->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER2)) & 0x1;
-	ui_C3 =
-		inl(dev->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER3)) & 0x1;
-	ui_C4 =
-		inl(dev->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER4)) & 0x1;
-	if (ui_DI == 0 && ui_DO == 0 && ui_Timer == 0 && ui_C1 == 0
-		&& ui_C2 == 0 && ui_C3 == 0 && ui_C4 == 0) {
-		dev_err(dev->class_dev, "Interrupt from unknown source.\n");
-	}
-
-	if (ui_DI == 1) {
-		ui_DI = inl(devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
-		outl(0x0, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
-		ui_InterruptStatus_1564 =
-			inl(devpriv->amcc_iobase + APCI1564_DI_INT_STATUS_REG);
-		ui_InterruptStatus_1564 = ui_InterruptStatus_1564 & 0X000FFFF0;
-		/* enable the interrupt */
-		outl(ui_DI, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
-		return;
-	}
-
-	if (ui_DO == 1) {
-		/* Check for Digital Output interrupt Type */
-		/* 1: VCC interrupt			   */
-		/* 2: CC interrupt			   */
-		ui_Type = inl(devpriv->amcc_iobase + APCI1564_DO_INT_STATUS_REG) & 0x3;
-		/* Disable the  Interrupt */
-		outl(0x0, devpriv->amcc_iobase + APCI1564_DO_INT_CTRL_REG);
-
-	}
-
-	if (ui_Timer == 1) {
-		devpriv->timer_select_mode = ADDIDATA_TIMER;
-		if (devpriv->timer_select_mode) {
-
-			/*  Disable Timer Interrupt */
-			ul_Command2 = inl(devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
-			outl(0x0, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
-
-			/*  Enable Timer Interrupt */
-
-			outl(ul_Command2, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
-		}
-	}
-
-	if (ui_C1 == 1) {
-		devpriv->timer_select_mode = ADDIDATA_COUNTER;
-		if (devpriv->timer_select_mode) {
-
-			/*  Disable Counter Interrupt */
-			ul_Command2 =
-				inl(dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
-			outl(0x0,
-			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
-
-			/*  Enable Counter Interrupt */
-			outl(ul_Command2,
-			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
-		}
-	}
-
-	if (ui_C2 == 1) {
-		devpriv->timer_select_mode = ADDIDATA_COUNTER;
-		if (devpriv->timer_select_mode) {
-
-			/*  Disable Counter Interrupt */
-			ul_Command2 =
-				inl(dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
-			outl(0x0,
-			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
-
-			/*  Enable Counter Interrupt */
-			outl(ul_Command2,
-			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
-		}
-	}
-
-	if (ui_C3 == 1) {
-		devpriv->timer_select_mode = ADDIDATA_COUNTER;
-		if (devpriv->timer_select_mode) {
-
-			/*  Disable Counter Interrupt */
-			ul_Command2 =
-				inl(dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
-			outl(0x0,
-			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
-
-			/*  Enable Counter Interrupt */
-			outl(ul_Command2,
-			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
-		}
-	}
-
-	if (ui_C4 == 1) {
-		devpriv->timer_select_mode = ADDIDATA_COUNTER;
-		if (devpriv->timer_select_mode) {
-
-			/*  Disable Counter Interrupt */
-			ul_Command2 =
-				inl(dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
-			outl(0x0,
-			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
-
-			/*  Enable Counter Interrupt */
-			outl(ul_Command2,
-			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
-		}
-	}
-	return;
-}
diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index cf58f90..327441e 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -3,6 +3,7 @@
 
 #include "../comedidev.h"
 #include "comedi_fc.h"
+#include "amcc_s5933.h"
 
 #include "addi-data/addi_common.h"
 
@@ -44,10 +45,35 @@ static int apci1564_reset(struct comedi_device *dev)
 	return 0;
 }
 
-static irqreturn_t v_ADDI_Interrupt(int irq, void *d)
+static irqreturn_t apci1564_interrupt(int irq, void *d)
 {
-	apci1564_interrupt(irq, d);
-	return IRQ_RETVAL(1);
+	struct comedi_device *dev = d;
+	struct apci1564_private *devpriv = dev->private;
+	struct comedi_subdevice *s = dev->read_subdev;
+	unsigned int ctrl;
+
+	/* check interrupt is from this device */
+	if ((inl(devpriv->amcc_iobase + AMCC_OP_REG_INTCSR) &
+	     INTCSR_INTR_ASSERTED) == 0)
+		return IRQ_NONE;
+
+	/* check interrupt is enabled */
+	ctrl = inl(devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
+	if ((ctrl & APCI1564_CTRL_INT_ENA) == 0)
+		return IRQ_HANDLED;
+
+	/* disable the interrupt */
+	outl(ctrl & ~APCI1564_CTRL_INT_ENA, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
+
+	s->state = inl(dev->iobase + APCI1564_DI_INT_STATUS_REG) & 0xffff;
+	comedi_buf_put(s, s->state);
+	s->async->events |= COMEDI_CB_BLOCK | COMEDI_CB_EOS;
+	comedi_event(dev, s);
+
+	/* enable the interrupt */
+	outl(ctrl, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
+
+	return IRQ_HANDLED;
 }
 
 static int apci1564_di_insn_bits(struct comedi_device *dev,
@@ -281,7 +307,7 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 	apci1564_reset(dev);
 
 	if (pcidev->irq > 0) {
-		ret = request_irq(pcidev->irq, v_ADDI_Interrupt, IRQF_SHARED,
+		ret = request_irq(pcidev->irq, apci1564_interrupt, IRQF_SHARED,
 				  dev->board_name, dev);
 		if (ret == 0)
 			dev->irq = pcidev->irq;
-- 
1.9.3


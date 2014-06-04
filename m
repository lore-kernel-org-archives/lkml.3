Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbaFDCfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 22:35:22 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:55559 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbaFDCfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 22:35:17 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH v2 5/5] staging: comedi: addi_apci_1564: move apci1564_interrupt() into addi_apci_1564.c
Date: Tue,  3 Jun 2014 21:35:07 -0500
Message-Id: <1401849307-22255-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401849124-21347-1-git-send-email-chase.southwood@gmail.com>
References: <1401849124-21347-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On moving the function into the driver proper, also check the device is
asserting the shared interrupt line.

This patch also fixes the interrupt handling for the digital input
change-of-state interrupts.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---

Hartley,
I know that this interrupt handler still needs major tidying up, but I would like to do that in a follow-on patch once I know that I have fixed DI interrupt handling properly.  The cleanup itself will be a large task, hah.  At any rate, I am not sure if the below is correct, but I think overall this version is a big step in a better direction.  As usual, review is appreciated!!
Chase

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 146 -------------------
 drivers/staging/comedi/drivers/addi_apci_1564.c    | 157 ++++++++++++++++++++-
 2 files changed, 153 insertions(+), 150 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 697ee76..ef419b4 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -357,149 +357,3 @@ static int apci1564_do_read(struct comedi_device *dev,
 	*data = devpriv->do_int_type;
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
-		/* send signal to the sample */
-		send_sig(SIGIO, devpriv->tsk_current, 0);
-		/* enable the interrupt */
-		outl(ui_DI, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
-		return;
-	}
-
-	if (ui_DO == 1) {
-		/* Check for Digital Output interrupt Type */
-		/* 1: VCC interrupt			   */
-		/* 2: CC interrupt			   */
-		devpriv->do_int_type = inl(devpriv->amcc_iobase +
-					  APCI1564_DO_INT_STATUS_REG) & 0x3;
-		/* Disable the  Interrupt */
-		outl(0x0, devpriv->amcc_iobase + APCI1564_DO_INT_CTRL_REG);
-
-		/* Sends signal to user space */
-		send_sig(SIGIO, devpriv->tsk_current, 0);
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
-			/* Send a signal to from kernel to user space */
-			send_sig(SIGIO, devpriv->tsk_current, 0);
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
-			/* Send a signal to from kernel to user space */
-			send_sig(SIGIO, devpriv->tsk_current, 0);
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
-			/* Send a signal to from kernel to user space */
-			send_sig(SIGIO, devpriv->tsk_current, 0);
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
-			/* Send a signal to from kernel to user space */
-			send_sig(SIGIO, devpriv->tsk_current, 0);
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
-			/* Send a signal to from kernel to user space */
-			send_sig(SIGIO, devpriv->tsk_current, 0);
-
-			/*  Enable Counter Interrupt */
-			outl(ul_Command2,
-			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
-		}
-	}
-	return;
-}
diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index fec478c..f71ee02 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -3,6 +3,7 @@
 
 #include "../comedidev.h"
 #include "comedi_fc.h"
+#include "amcc_s5933.h"
 
 #include "addi-data/addi_common.h"
 
@@ -51,10 +52,158 @@ static int apci1564_reset(struct comedi_device *dev)
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
+	unsigned int ui_DO, ui_DI;
+	unsigned int ui_Timer;
+	unsigned int ui_C1, ui_C2, ui_C3, ui_C4;
+	unsigned int ul_Command2 = 0;
+
+	/* check interrupt is from this device */
+	if ((inl(devpriv->amcc_iobase + AMCC_OP_REG_INTCSR) &
+	     INTCSR_INTR_ASSERTED) == 0)
+		return IRQ_NONE;
+
+	/* check which interrupt was triggered */
+	ui_DI = inl(devpriv->amcc_iobase + APCI1564_DI_IRQ_REG) &
+		   APCI1564_DI_INT_ENABLE;
+	ui_DO = inl(devpriv->amcc_iobase + APCI1564_DO_IRQ_REG) & 0x01;
+	ui_Timer = inl(devpriv->amcc_iobase + APCI1564_TIMER_IRQ_REG) & 0x01;
+	ui_C1 =
+		inl(dev->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER1)) & 0x1;
+	ui_C2 =
+		inl(dev->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER2)) & 0x1;
+	ui_C3 =
+		inl(dev->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER3)) & 0x1;
+	ui_C4 =
+		inl(dev->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER4)) & 0x1;
+	if (ui_DI == 0 && ui_DO == 0 && ui_Timer == 0 && ui_C1 == 0
+		&& ui_C2 == 0 && ui_C3 == 0 && ui_C4 == 0) {
+		return IRQ_HANDLED;
+	}
+
+	if (ui_DI) {
+		/* disable the interrupt */
+		outl(ui_DI & APCI1564_DI_INT_DISABLE, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
+
+		s->state = inl(dev->iobase + APCI1564_DI_INT_STATUS_REG) & 0xffff;
+		comedi_buf_put(s, s->state);
+		s->async->events |= COMEDI_CB_BLOCK | COMEDI_CB_EOS;
+		comedi_event(dev, s);
+
+		/* enable the interrupt */
+		outl(ui_DI, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
+	}
+
+	if (ui_DO == 1) {
+		/* Check for Digital Output interrupt Type */
+		/* 1: VCC interrupt			   */
+		/* 2: CC interrupt			   */
+		devpriv->do_int_type = inl(devpriv->amcc_iobase +
+					  APCI1564_DO_INT_STATUS_REG) & 0x3;
+		/* Disable the  Interrupt */
+		outl(0x0, devpriv->amcc_iobase + APCI1564_DO_INT_CTRL_REG);
+
+		/* Sends signal to user space */
+		send_sig(SIGIO, devpriv->tsk_current, 0);
+	}
+
+	if (ui_Timer == 1) {
+		devpriv->timer_select_mode = ADDIDATA_TIMER;
+		if (devpriv->timer_select_mode) {
+
+			/*  Disable Timer Interrupt */
+			ul_Command2 = inl(devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
+			outl(0x0, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
+
+			/* Send a signal to from kernel to user space */
+			send_sig(SIGIO, devpriv->tsk_current, 0);
+
+			/*  Enable Timer Interrupt */
+
+			outl(ul_Command2, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
+		}
+	}
+
+	if (ui_C1 == 1) {
+		devpriv->timer_select_mode = ADDIDATA_COUNTER;
+		if (devpriv->timer_select_mode) {
+
+			/*  Disable Counter Interrupt */
+			ul_Command2 =
+				inl(dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
+			outl(0x0,
+			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
+
+			/* Send a signal to from kernel to user space */
+			send_sig(SIGIO, devpriv->tsk_current, 0);
+
+			/*  Enable Counter Interrupt */
+			outl(ul_Command2,
+			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
+		}
+	}
+
+	if (ui_C2 == 1) {
+		devpriv->timer_select_mode = ADDIDATA_COUNTER;
+		if (devpriv->timer_select_mode) {
+
+			/*  Disable Counter Interrupt */
+			ul_Command2 =
+				inl(dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
+			outl(0x0,
+			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
+
+			/* Send a signal to from kernel to user space */
+			send_sig(SIGIO, devpriv->tsk_current, 0);
+
+			/*  Enable Counter Interrupt */
+			outl(ul_Command2,
+			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
+		}
+	}
+
+	if (ui_C3 == 1) {
+		devpriv->timer_select_mode = ADDIDATA_COUNTER;
+		if (devpriv->timer_select_mode) {
+
+			/*  Disable Counter Interrupt */
+			ul_Command2 =
+				inl(dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
+			outl(0x0,
+			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
+
+			/* Send a signal to from kernel to user space */
+			send_sig(SIGIO, devpriv->tsk_current, 0);
+
+			/*  Enable Counter Interrupt */
+			outl(ul_Command2,
+			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
+		}
+	}
+
+	if (ui_C4 == 1) {
+		devpriv->timer_select_mode = ADDIDATA_COUNTER;
+		if (devpriv->timer_select_mode) {
+
+			/*  Disable Counter Interrupt */
+			ul_Command2 =
+				inl(dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
+			outl(0x0,
+			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
+
+			/* Send a signal to from kernel to user space */
+			send_sig(SIGIO, devpriv->tsk_current, 0);
+
+			/*  Enable Counter Interrupt */
+			outl(ul_Command2,
+			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
+		}
+	}
+	return IRQ_HANDLED;
 }
 
 static int apci1564_di_insn_bits(struct comedi_device *dev,
@@ -295,7 +444,7 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 	apci1564_reset(dev);
 
 	if (pcidev->irq > 0) {
-		ret = request_irq(pcidev->irq, v_ADDI_Interrupt, IRQF_SHARED,
+		ret = request_irq(pcidev->irq, apci1564_interrupt, IRQF_SHARED,
 				  dev->board_name, dev);
 		if (ret == 0)
 			dev->irq = pcidev->irq;
-- 
1.9.3


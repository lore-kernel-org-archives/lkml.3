Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbaGCCSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:18:00 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:44783 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbaGCCR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:17:58 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH v2 3/3] staging: comedi: addi_apci_1564: clean up apci1564_interrupt()
Date: Wed,  2 Jul 2014 21:17:21 -0500
Message-Id: <1404353841-29157-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404353739-28607-1-git-send-email-chase.southwood@gmail.com>
References: <1404353739-28607-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the checks for interrupts from unknown sources.  This situation
should never occur and the checks were doing nothing to help the
situation.

Also, the portion of the function for handling counter interrupts is
reapeated four times (once for each counter), but is completely identical
save for the register is is accessing, so we can handle all four counters
with a for loop.

Finally, the interrupt handler is incorrectly setting and then checking
devpriv->timer_select_mode before processing some of the triggered
interrupts, so just remove all occurrences of this.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi_apci_1564.c | 133 +++++-------------------
 1 file changed, 27 insertions(+), 106 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 0141ed9..5924421 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -58,48 +58,33 @@ static irqreturn_t apci1564_interrupt(int irq, void *d)
 	struct comedi_device *dev = d;
 	struct apci1564_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
-	unsigned int ui_DO, ui_DI;
-	unsigned int ui_Timer;
-	unsigned int ui_C1, ui_C2, ui_C3, ui_C4;
-	unsigned int ul_Command2 = 0;
+	unsigned int status;
+	unsigned int ctrl;
+	unsigned int chan;
 
 	/* check interrupt is from this device */
 	if ((inl(devpriv->amcc_iobase + AMCC_OP_REG_INTCSR) &
 	     INTCSR_INTR_ASSERTED) == 0)
 		return IRQ_NONE;
 
-	/* check which interrupt was triggered */
-	ui_DI = inl(devpriv->amcc_iobase + APCI1564_DI_IRQ_REG) &
-		   APCI1564_DI_INT_ENABLE;
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
-		return IRQ_HANDLED;
-	}
-
-	if (ui_DI) {
+	status = inl(devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
+	if (status & APCI1564_DI_INT_ENABLE) {
 		/* disable the interrupt */
-		outl(ui_DI & APCI1564_DI_INT_DISABLE, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
+		outl(status & APCI1564_DI_INT_DISABLE,
+		     devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
 
-		s->state = inl(dev->iobase + APCI1564_DI_INT_STATUS_REG) & 0xffff;
+		s->state = inl(dev->iobase + APCI1564_DI_INT_STATUS_REG)
+			       & 0xffff;
 		comedi_buf_put(s, s->state);
 		s->async->events |= COMEDI_CB_BLOCK | COMEDI_CB_EOS;
 		comedi_event(dev, s);
 
 		/* enable the interrupt */
-		outl(ui_DI, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
+		outl(status, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
 	}
 
-	if (ui_DO == 1) {
+	status = inl(devpriv->amcc_iobase + APCI1564_DO_IRQ_REG);
+	if (status & 0x01) {
 		/* Check for Digital Output interrupt Type */
 		/* 1: VCC interrupt			   */
 		/* 2: CC interrupt			   */
@@ -112,98 +97,34 @@ static irqreturn_t apci1564_interrupt(int irq, void *d)
 		send_sig(SIGIO, devpriv->tsk_current, 0);
 	}
 
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
+	status = inl(devpriv->amcc_iobase + APCI1564_TIMER_IRQ_REG);
+	if (status & 0x01) {
+		/*  Disable Timer Interrupt */
+		ctrl = inl(devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
+		outl(0x0, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
 
-			/*  Disable Counter Interrupt */
-			ul_Command2 =
-				inl(dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
-			outl(0x0,
-			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
-
-			/* Send a signal to from kernel to user space */
-			send_sig(SIGIO, devpriv->tsk_current, 0);
+		/* Send a signal to from kernel to user space */
+		send_sig(SIGIO, devpriv->tsk_current, 0);
 
-			/*  Enable Counter Interrupt */
-			outl(ul_Command2,
-			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
-		}
+		/*  Enable Timer Interrupt */
+		outl(ctrl, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
 	}
 
-	if (ui_C3 == 1) {
-		devpriv->timer_select_mode = ADDIDATA_COUNTER;
-		if (devpriv->timer_select_mode) {
-
+	for (chan = 0; chan < 4; chan++) {
+		status = inl(dev->iobase + APCI1564_TCW_IRQ_REG(chan));
+		if (status & 0x01) {
 			/*  Disable Counter Interrupt */
-			ul_Command2 =
-				inl(dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
-			outl(0x0,
-			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
+			ctrl = inl(dev->iobase + APCI1564_TCW_CTRL_REG(chan));
+			outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(chan));
 
 			/* Send a signal to from kernel to user space */
 			send_sig(SIGIO, devpriv->tsk_current, 0);
 
 			/*  Enable Counter Interrupt */
-			outl(ul_Command2,
-			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
+			outl(ctrl, dev->iobase + APCI1564_TCW_CTRL_REG(chan));
 		}
 	}
 
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
 	return IRQ_HANDLED;
 }
 
-- 
2.0.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaF1Eux (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 00:50:53 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:63195 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaF1Euw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 00:50:52 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 3/3] staging: comedi: addi_apci_1564: clean up apci1564_interrupt()
Date: Fri, 27 Jun 2014 23:50:10 -0500
Message-Id: <1403931010-28449-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1403930876-27678-1-git-send-email-chase.southwood@gmail.com>
References: <1403930876-27678-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code in apci1564_interrupt() for handling counter interrupts is currently
repeated four times; once for each counter.  This code is identical save for the
registers it is using, so just handle all four counters with a for loop.

Also, the interrupt function was doing a useless set-and-check of
devpriv->timer_select_mode before processing any triggered interrupts, remove
all occurrences of this.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
Hartley,
I remember that you mentioned that the counters could be handled using a for
loop here.  Is there a better way to go about that or am I on the right track
with this?

Thanks,
Chase

 drivers/staging/comedi/drivers/addi_apci_1564.c | 108 +++++-------------------
 1 file changed, 23 insertions(+), 85 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 0141ed9..f40910e 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -60,8 +60,9 @@ static irqreturn_t apci1564_interrupt(int irq, void *d)
 	struct comedi_subdevice *s = dev->read_subdev;
 	unsigned int ui_DO, ui_DI;
 	unsigned int ui_Timer;
-	unsigned int ui_C1, ui_C2, ui_C3, ui_C4;
+	unsigned int counters[4];
 	unsigned int ul_Command2 = 0;
+	int i;
 
 	/* check interrupt is from this device */
 	if ((inl(devpriv->amcc_iobase + AMCC_OP_REG_INTCSR) &
@@ -73,16 +74,17 @@ static irqreturn_t apci1564_interrupt(int irq, void *d)
 		   APCI1564_DI_INT_ENABLE;
 	ui_DO = inl(devpriv->amcc_iobase + APCI1564_DO_IRQ_REG) & 0x01;
 	ui_Timer = inl(devpriv->amcc_iobase + APCI1564_TIMER_IRQ_REG) & 0x01;
-	ui_C1 =
+	counters[0] =
 		inl(dev->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER1)) & 0x1;
-	ui_C2 =
+	counters[1] =
 		inl(dev->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER2)) & 0x1;
-	ui_C3 =
+	counters[2] =
 		inl(dev->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER3)) & 0x1;
-	ui_C4 =
+	counters[3] =
 		inl(dev->iobase + APCI1564_TCW_IRQ_REG(APCI1564_COUNTER4)) & 0x1;
-	if (ui_DI == 0 && ui_DO == 0 && ui_Timer == 0 && ui_C1 == 0
-		&& ui_C2 == 0 && ui_C3 == 0 && ui_C4 == 0) {
+	if (ui_DI == 0 && ui_DO == 0 && ui_Timer == 0 && counters[0] == 0
+		&& counters[1] == 0 && counters[2] == 0 && counters[3] == 0) {
+		dev_err(dev->class_dev, "Interrupt from unknown source.\n");
 		return IRQ_HANDLED;
 	}
 
@@ -113,95 +115,31 @@ static irqreturn_t apci1564_interrupt(int irq, void *d)
 	}
 
 	if (ui_Timer == 1) {
-		devpriv->timer_select_mode = ADDIDATA_TIMER;
-		if (devpriv->timer_select_mode) {
+		/*  Disable Timer Interrupt */
+		ul_Command2 = inl(devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
+		outl(0x0, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
 
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
+		/* Send a signal to from kernel to user space */
+		send_sig(SIGIO, devpriv->tsk_current, 0);
 
-			/*  Disable Counter Interrupt */
-			ul_Command2 =
-				inl(dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
-			outl(0x0,
-			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
+		/* Enable Timer Interrupt */
 
-			/* Send a signal to from kernel to user space */
-			send_sig(SIGIO, devpriv->tsk_current, 0);
-
-			/*  Enable Counter Interrupt */
-			outl(ul_Command2,
-			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
-		}
+		outl(ul_Command2, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
 	}
 
-	if (ui_C4 == 1) {
-		devpriv->timer_select_mode = ADDIDATA_COUNTER;
-		if (devpriv->timer_select_mode) {
-
+	for (i = 0; i <= 3; i++) {
+		if (counters[i] == 1) {
 			/*  Disable Counter Interrupt */
-			ul_Command2 =
-				inl(dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
-			outl(0x0,
-			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
+			ul_Command2 = inl(dev->iobase +
+					  APCI1564_TCW_CTRL_REG(i));
+			outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(i));
 
 			/* Send a signal to from kernel to user space */
 			send_sig(SIGIO, devpriv->tsk_current, 0);
 
 			/*  Enable Counter Interrupt */
-			outl(ul_Command2,
-			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
+			outl(ul_Command2, dev->iobase +
+			     APCI1564_TCW_CTRL_REG(i));
 		}
 	}
 	return IRQ_HANDLED;
-- 
2.0.1


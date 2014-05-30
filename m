Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbaE3EmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 00:42:14 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:42152 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaE3EmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 00:42:13 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 1/6] staging: comedi: addi_apci_1564: remove send_sig() use
Date: Thu, 29 May 2014 23:41:53 -0500
Message-Id: <1401424913-21859-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401424853-21683-1-git-send-email-chase.southwood@gmail.com>
References: <1401424853-21683-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The addi-data drivers use send_sig() to let the user know when an
interrupt has occurred. The "standard" way to do this in the comedi
subsystem is to have a subdevice that supports asynchronous commands
and use comedi_event() to signal the user.

Remove the send_sig() usage in this driver.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 23 ----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 0ba5385..be0e009 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -108,8 +108,6 @@ static int apci1564_di_config(struct comedi_device *dev,
 {
 	struct addi_private *devpriv = dev->private;
 
-	devpriv->tsk_Current = current;
-
 	/* Set the digital input logic */
 	if (data[0] == ADDIDATA_ENABLE) {
 		data[2] = data[2] << 4;
@@ -166,7 +164,6 @@ static int apci1564_do_config(struct comedi_device *dev,
 
 	outl(ul_Command, devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
 	ui_InterruptData = inl(devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
-	devpriv->tsk_Current = current;
 	return insn->n;
 }
 
@@ -189,7 +186,6 @@ static int apci1564_timer_config(struct comedi_device *dev,
 	struct addi_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0;
 
-	devpriv->tsk_Current = current;
 	if (data[0] == ADDIDATA_WATCHDOG) {
 		devpriv->b_TimerSelectMode = ADDIDATA_WATCHDOG;
 
@@ -436,8 +432,6 @@ static void apci1564_interrupt(int irq, void *d)
 		ui_InterruptStatus_1564 =
 			inl(devpriv->i_IobaseAmcc + APCI1564_DI_INT_STATUS_REG);
 		ui_InterruptStatus_1564 = ui_InterruptStatus_1564 & 0X000FFFF0;
-		/* send signal to the sample */
-		send_sig(SIGIO, devpriv->tsk_Current, 0);
 		/* enable the interrupt */
 		outl(ui_DI, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
 		return;
@@ -451,8 +445,6 @@ static void apci1564_interrupt(int irq, void *d)
 		/* Disable the  Interrupt */
 		outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
 
-		/* Sends signal to user space */
-		send_sig(SIGIO, devpriv->tsk_Current, 0);
 	}
 
 	if (ui_Timer == 1) {
@@ -463,9 +455,6 @@ static void apci1564_interrupt(int irq, void *d)
 			ul_Command2 = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
 			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
 
-			/* Send a signal to from kernel to user space */
-			send_sig(SIGIO, devpriv->tsk_Current, 0);
-
 			/*  Enable Timer Interrupt */
 
 			outl(ul_Command2, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
@@ -482,9 +471,6 @@ static void apci1564_interrupt(int irq, void *d)
 			outl(0x0,
 			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
 
-			/* Send a signal to from kernel to user space */
-			send_sig(SIGIO, devpriv->tsk_Current, 0);
-
 			/*  Enable Counter Interrupt */
 			outl(ul_Command2,
 			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
@@ -501,9 +487,6 @@ static void apci1564_interrupt(int irq, void *d)
 			outl(0x0,
 			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
 
-			/* Send a signal to from kernel to user space */
-			send_sig(SIGIO, devpriv->tsk_Current, 0);
-
 			/*  Enable Counter Interrupt */
 			outl(ul_Command2,
 			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
@@ -520,9 +503,6 @@ static void apci1564_interrupt(int irq, void *d)
 			outl(0x0,
 			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
 
-			/* Send a signal to from kernel to user space */
-			send_sig(SIGIO, devpriv->tsk_Current, 0);
-
 			/*  Enable Counter Interrupt */
 			outl(ul_Command2,
 			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
@@ -539,9 +519,6 @@ static void apci1564_interrupt(int irq, void *d)
 			outl(0x0,
 			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
 
-			/* Send a signal to from kernel to user space */
-			send_sig(SIGIO, devpriv->tsk_Current, 0);
-
 			/*  Enable Counter Interrupt */
 			outl(ul_Command2,
 			     dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
-- 
1.9.3


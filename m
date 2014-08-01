Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbaHAB5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 21:57:01 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:50288 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbaHAB5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 21:57:00 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 2/2] staging: comedi: addi_apci_1564: remove diagnostic interrupt support code
Date: Thu, 31 Jul 2014 20:56:47 -0500
Message-Id: <bd271c4aaff67886a835dad67a955a7a4948be1f.1406857380.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <cover.1406857380.git.chase.southwood@gmail.com>
References: <cover.1406857380.git.chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per Ian, at this point in time it is not worth implementing an async
command interface for diagnostic interrupts for this board.  As this is
the case, this patch removes the code which supports such interrupts as it
is now unused.

This includes removing apci1564_do_read(), which was the insn_read
operation for the digital output subdevice, since all it was doing was
reading the current diagnostic interrupt type and returning it in 'data'.
This doesn't follow the comedi API and this operation can be emulated by
the comedi core anyway since the insn_bits operation follows the comedi
API.  So it is safe to simply remove this function.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 .../staging/comedi/drivers/addi-data/hwdrv_apci1564.c  | 14 --------------
 drivers/staging/comedi/drivers/addi_apci_1564.c        | 18 ------------------
 2 files changed, 32 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index a1730e9..8a613ae 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -340,17 +340,3 @@ static int apci1564_timer_read(struct comedi_device *dev,
 	}
 	return insn->n;
 }
-
-/*
- * Reads the interrupt status register
- */
-static int apci1564_do_read(struct comedi_device *dev,
-			    struct comedi_subdevice *s,
-			    struct comedi_insn *insn,
-			    unsigned int *data)
-{
-	struct apci1564_private *devpriv = dev->private;
-
-	*data = devpriv->do_int_type;
-	return insn->n;
-}
diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 819255b..543cb07 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -13,7 +13,6 @@ struct apci1564_private {
 	unsigned int mode1;		/* riding-edge/high level channels */
 	unsigned int mode2;		/* falling-edge/low level channels */
 	unsigned int ctrl;		/* interrupt mode OR (edge) . AND (level) */
-	unsigned int do_int_type;
 	unsigned char timer_select_mode;
 	unsigned char mode_select_register;
 	struct task_struct *tsk_current;
@@ -25,8 +24,6 @@ static int apci1564_reset(struct comedi_device *dev)
 {
 	struct apci1564_private *devpriv = dev->private;
 
-	devpriv->do_int_type = 0;
-
 	/* Disable the input interrupts and reset status register */
 	outl(0x0, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
 	inl(devpriv->amcc_iobase + APCI1564_DI_INT_STATUS_REG);
@@ -83,20 +80,6 @@ static irqreturn_t apci1564_interrupt(int irq, void *d)
 		outl(status, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
 	}
 
-	status = inl(devpriv->amcc_iobase + APCI1564_DO_IRQ_REG);
-	if (status & 0x01) {
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
 	status = inl(devpriv->amcc_iobase + APCI1564_TIMER_IRQ_REG);
 	if (status & 0x01) {
 		/*  Disable Timer Interrupt */
@@ -407,7 +390,6 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 	s->range_table = &range_digital;
 	s->insn_config = apci1564_do_config;
 	s->insn_bits = apci1564_do_insn_bits;
-	s->insn_read = apci1564_do_read;
 
 	/* Change-Of-State (COS) interrupt subdevice */
 	s = &dev->subdevices[2];
-- 
2.0.3


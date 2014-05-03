Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaECH5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 03:57:19 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:58917 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbaECH5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 03:57:17 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 3/4] staging: comedi: addi_apci_1564: absorb apci1564_reset()
Date: Sat,  3 May 2014 02:57:01 -0500
Message-Id: <1399103821-15915-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399103661-14853-1-git-send-email-chase.southwood@gmail.com>
References: <1399103661-14853-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the only reset fuction used by this driver.  We can remove it from
the boardinfo and absorb the code from hwdrv_apci1564.c into the driver.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 32 -------------------
 drivers/staging/comedi/drivers/addi_apci_1564.c    | 36 ++++++++++++++++++----
 2 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 7976a22a..b3c3f60 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -578,35 +578,3 @@ static void apci1564_interrupt(int irq, void *d)
 	}
 	return;
 }
-
-static int apci1564_reset(struct comedi_device *dev)
-{
-	struct addi_private *devpriv = dev->private;
-
-	ui_Type = 0;
-
-	/* Disable the input interrupts and reset status register */
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
-	inl(devpriv->i_IobaseAmcc + APCI1564_DI_INT_STATUS_REG);
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE1_REG);
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE2_REG);
-
-	/* Reset the output channels and disable interrupts */
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_REG);
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
-
-	/* Reset the watchdog registers */
-	addi_watchdog_reset(devpriv->i_IobaseAmcc + APCI1564_WDOG_REG);
-
-	/* Reset the timer registers */
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_RELOAD_REG);
-
-	/* Reset the counter registers */
-	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
-	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
-	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
-	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
-
-	return 0;
-}
diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 31b687c..254889a 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -16,7 +16,6 @@ static const struct addi_board apci1564_boardtypes[] = {
 		.i_DoMaxdata		= 0xffffffff,
 		.i_Timer		= 1,
 		.interrupt		= apci1564_interrupt,
-		.reset			= apci1564_reset,
 		.timer_config		= apci1564_timer_config,
 		.timer_write		= apci1564_timer_write,
 		.timer_read		= apci1564_timer_read,
@@ -32,11 +31,35 @@ static irqreturn_t v_ADDI_Interrupt(int irq, void *d)
 	return IRQ_RETVAL(1);
 }
 
-static int i_ADDI_Reset(struct comedi_device *dev)
+static int apci1564_reset(struct comedi_device *dev)
 {
-	const struct addi_board *this_board = comedi_board(dev);
+	struct addi_private *devpriv = dev->private;
+
+	ui_Type = 0;
+
+	/* Disable the input interrupts and reset status register */
+	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
+	inl(devpriv->i_IobaseAmcc + APCI1564_DI_INT_STATUS_REG);
+	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE1_REG);
+	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE2_REG);
+
+	/* Reset the output channels and disable interrupts */
+	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_REG);
+	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
+
+	/* Reset the watchdog registers */
+	addi_watchdog_reset(devpriv->i_IobaseAmcc + APCI1564_WDOG_REG);
+
+	/* Reset the timer registers */
+	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_CTRL_REG);
+	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER_RELOAD_REG);
+
+	/* Reset the counter registers */
+	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
+	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
+	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
+	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
 
-	this_board->reset(dev);
 	return 0;
 }
 
@@ -62,6 +85,8 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 	dev->iobase = pci_resource_start(pcidev, 1);
 	devpriv->i_IobaseAmcc = pci_resource_start(pcidev, 0);
 
+	apci1564_reset(dev);
+
 	if (pcidev->irq > 0) {
 		ret = request_irq(pcidev->irq, v_ADDI_Interrupt, IRQF_SHARED,
 				  dev->board_name, dev);
@@ -114,7 +139,6 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	i_ADDI_Reset(dev);
 	return 0;
 }
 
@@ -124,7 +148,7 @@ static void apci1564_detach(struct comedi_device *dev)
 
 	if (devpriv) {
 		if (dev->iobase)
-			i_ADDI_Reset(dev);
+			apci1564_reset(dev);
 		if (dev->irq)
 			free_irq(dev->irq, dev);
 	}
-- 
1.9.0


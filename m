Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaHLCDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 22:03:42 -0400
Received: from mail-yk0-f171.google.com ([209.85.160.171]:64292 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbaHLCDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 22:03:40 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 2/3] staging: comedi: addi_apci_1564: Remove in-driver watchdog support code
Date: Mon, 11 Aug 2014 21:03:19 -0500
Message-Id: <b5d20f79b289d7ade9d89c2c8f3e28fafbd686fb.1407804777.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cover.1407804777.git.chase.southwood@gmail.com>
References: <cover.1407804777.git.chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting with commit 1496e5961113 ("staging: comedi: addi_apci_1564: use
addi_watchdog module to init watchdog subdevice"), this driver uses the
addi_watchdog module to provide support for the watchdog subdevice.  Any
remaining watchdog code in-driver can and should be removed.

This will also make future work on the timer and counter subdevices easier.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 54 +++++-----------------
 1 file changed, 12 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 0ce1deb..f8d8cc9 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -88,9 +88,9 @@
 #define APCI1564_TCW_WARN_TIMEBASE_REG(x)		(0x1c + ((x) * 0x20))
 
 /*
- * Configures The Timer, Counter or Watchdog
+ * Configures The Timer or Counter
  *
- * data[0] Configure as: 0 = Timer, 1 = Counter, 2 = Watchdog
+ * data[0] Configure as: 0 = Timer, 1 = Counter
  * data[1] 1 = Enable Interrupt, 0 = Disable Interrupt
  * data[2] Time Unit
  * data[3] Reload Value
@@ -107,14 +107,7 @@ static int apci1564_timer_config(struct comedi_device *dev,
 	unsigned int ul_Command1 = 0;
 
 	devpriv->tsk_current = current;
-	if (data[0] == ADDIDATA_WATCHDOG) {
-		devpriv->timer_select_mode = ADDIDATA_WATCHDOG;
-
-		/* Disable the watchdog */
-		outl(0x0, devpriv->amcc_iobase + APCI1564_WDOG_CTRL_REG);
-		/* Loading the Reload value */
-		outl(data[3], devpriv->amcc_iobase + APCI1564_WDOG_RELOAD_REG);
-	} else if (data[0] == ADDIDATA_TIMER) {
+	if (data[0] == ADDIDATA_TIMER) {
 		/* First Stop The Timer */
 		ul_Command1 = inl(devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
 		ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
@@ -187,14 +180,13 @@ static int apci1564_timer_config(struct comedi_device *dev,
 	} else {
 		dev_err(dev->class_dev, "Invalid subdevice.\n");
 	}
-
 	return insn->n;
 }
 
 /*
- * Start / Stop The Selected Timer, Counter or Watchdog
+ * Start / Stop The Selected Timer or Counter
  *
- * data[0] Configure as: 0 = Timer, 1 = Counter, 2 = Watchdog
+ * data[0] Configure as: 0 = Timer, 1 = Counter
  * data[1] 0 = Stop, 1 = Start, 2 = Trigger Clear (Only Counter)
  */
 static int apci1564_timer_write(struct comedi_device *dev,
@@ -205,23 +197,6 @@ static int apci1564_timer_write(struct comedi_device *dev,
 	struct apci1564_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0;
 
-	if (devpriv->timer_select_mode == ADDIDATA_WATCHDOG) {
-		switch (data[1]) {
-		case 0:	/* stop the watchdog */
-			/* disable the watchdog */
-			outl(0x0, devpriv->amcc_iobase + APCI1564_WDOG_CTRL_REG);
-			break;
-		case 1:	/* start the watchdog */
-			outl(0x0001, devpriv->amcc_iobase + APCI1564_WDOG_CTRL_REG);
-			break;
-		case 2:	/* Software trigger */
-			outl(0x0201, devpriv->amcc_iobase + APCI1564_WDOG_CTRL_REG);
-			break;
-		default:
-			dev_err(dev->class_dev, "Specified functionality does not exist.\n");
-			return -EINVAL;
-		}
-	}
 	if (devpriv->timer_select_mode == ADDIDATA_TIMER) {
 		if (data[1] == 1) {
 			ul_Command1 = inl(devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
@@ -236,8 +211,7 @@ static int apci1564_timer_write(struct comedi_device *dev,
 			ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
 			outl(ul_Command1, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
 		}
-	}
-	if (devpriv->timer_select_mode == ADDIDATA_COUNTER) {
+	} else if (devpriv->timer_select_mode == ADDIDATA_COUNTER) {
 		ul_Command1 =
 			inl(dev->iobase +
 			    APCI1564_TCW_CTRL_REG(devpriv->mode_select_register - 1));
@@ -254,12 +228,14 @@ static int apci1564_timer_write(struct comedi_device *dev,
 		}
 		outl(ul_Command1, dev->iobase +
 		     APCI1564_TCW_CTRL_REG(devpriv->mode_select_register - 1));
+	} else {
+		dev_err(dev->class_dev, "Invalid subdevice.\n");
 	}
 	return insn->n;
 }
 
 /*
- * Read The Selected Timer, Counter or Watchdog
+ * Read The Selected Timer or Counter
  */
 static int apci1564_timer_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
@@ -269,11 +245,7 @@ static int apci1564_timer_read(struct comedi_device *dev,
 	struct apci1564_private *devpriv = dev->private;
 	unsigned int ul_Command1 = 0;
 
-	if (devpriv->timer_select_mode == ADDIDATA_WATCHDOG) {
-		/*  Stores the status of the Watchdog */
-		data[0] = inl(devpriv->amcc_iobase + APCI1564_WDOG_STATUS_REG) & 0x1;
-		data[1] = inl(devpriv->amcc_iobase + APCI1564_WDOG_REG);
-	} else if (devpriv->timer_select_mode == ADDIDATA_TIMER) {
+	if (devpriv->timer_select_mode == ADDIDATA_TIMER) {
 		/*  Stores the status of the Timer */
 		data[0] = inl(devpriv->amcc_iobase + APCI1564_TIMER_STATUS_REG) & 0x1;
 
@@ -299,10 +271,8 @@ static int apci1564_timer_read(struct comedi_device *dev,
 
 		/* Get the overflow status */
 		data[4] = (unsigned char) ((ul_Command1 >> 0) & 1);
-	} else if ((devpriv->timer_select_mode != ADDIDATA_TIMER)
-		&& (devpriv->timer_select_mode != ADDIDATA_WATCHDOG)
-		&& (devpriv->timer_select_mode != ADDIDATA_COUNTER)) {
-		dev_err(dev->class_dev, "Invalid Subdevice!\n");
+	} else {
+		dev_err(dev->class_dev, "Invalid subdevice.\n");
 	}
 	return insn->n;
 }
-- 
2.0.4


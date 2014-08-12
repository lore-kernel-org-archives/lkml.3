Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbaHLCDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 22:03:22 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:42776 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbaHLCDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 22:03:10 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 1/3] staging: comedi: addi_apci_1564: remove apci1564_do_config
Date: Mon, 11 Aug 2014 21:02:58 -0500
Message-Id: <cdecb54bd9e8f66ded9c05e3a45efd9defa71dda.1407804777.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cover.1407804777.git.chase.southwood@gmail.com>
References: <cover.1407804777.git.chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DO config function served the purpose of configuring the diagnostic
interrupts for the board.  As the driver currently does not support
diagnostic interrupts, the digital output subdevice does not need an
insn_config operation and this function can be safely removed.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 34 ----------------------
 drivers/staging/comedi/drivers/addi_apci_1564.c    |  1 -
 2 files changed, 35 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 8a613ae..0ce1deb 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -88,40 +88,6 @@
 #define APCI1564_TCW_WARN_TIMEBASE_REG(x)		(0x1c + ((x) * 0x20))
 
 /*
- * Configures The Digital Output Subdevice.
- *
- * data[1] 0 = Disable VCC Interrupt, 1 = Enable VCC Interrupt
- * data[2] 0 = Disable CC Interrupt, 1 = Enable CC Interrupt
- */
-static int apci1564_do_config(struct comedi_device *dev,
-			      struct comedi_subdevice *s,
-			      struct comedi_insn *insn,
-			      unsigned int *data)
-{
-	struct apci1564_private *devpriv = dev->private;
-	unsigned int ul_Command = 0;
-
-	if ((data[0] != 0) && (data[0] != 1)) {
-		dev_err(dev->class_dev, "Data should be 1 or 0\n");
-		return -EINVAL;
-	}
-
-	if (data[1] == 1)
-		ul_Command = ul_Command | 0x1;
-	else
-		ul_Command = ul_Command & 0xFFFFFFFE;
-
-	if (data[2] == 1)
-		ul_Command = ul_Command | 0x2;
-	else
-		ul_Command = ul_Command & 0xFFFFFFFD;
-
-	outl(ul_Command, devpriv->amcc_iobase + APCI1564_DO_INT_CTRL_REG);
-	devpriv->tsk_current = current;
-	return insn->n;
-}
-
-/*
  * Configures The Timer, Counter or Watchdog
  *
  * data[0] Configure as: 0 = Timer, 1 = Counter, 2 = Watchdog
diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 543cb07..555e0a9 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -388,7 +388,6 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 	s->n_chan = 32;
 	s->maxdata = 1;
 	s->range_table = &range_digital;
-	s->insn_config = apci1564_do_config;
 	s->insn_bits = apci1564_do_insn_bits;
 
 	/* Change-Of-State (COS) interrupt subdevice */
-- 
2.0.4


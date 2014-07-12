Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaGLWou (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 18:44:50 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:43155 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaGLWos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 18:44:48 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 2/2] staging: comedi: addi_apci_1564: use addi_watchdog module to init watchdog subdevice
Date: Sat, 12 Jul 2014 17:44:09 -0500
Message-Id: <1405205049-1828-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1405204956-1559-1-git-send-email-chase.southwood@gmail.com>
References: <1405204956-1559-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the addi_watchdog module to provide support for the watchdog
subdevice.

Also, rearrange the subdevice init blocks so that the order makes sense.
Digital input/output subdevices and subdevices for DI/DO interrupt
support, followed by timer/counter/watchdog subdevices is the new order.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi_apci_1564.c | 34 +++++++++++++++----------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 16f3b69..190b026 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -373,7 +373,7 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 			dev->irq = pcidev->irq;
 	}
 
-	ret = comedi_alloc_subdevices(dev, 4);
+	ret = comedi_alloc_subdevices(dev, 5);
 	if (ret)
 		return ret;
 
@@ -397,20 +397,8 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 	s->insn_bits = apci1564_do_insn_bits;
 	s->insn_read = apci1564_do_read;
 
-	/*  Allocate and Initialise Timer Subdevice Structures */
-	s = &dev->subdevices[2];
-	s->type = COMEDI_SUBD_TIMER;
-	s->subdev_flags = SDF_WRITEABLE;
-	s->n_chan = 1;
-	s->maxdata = 0;
-	s->len_chanlist = 1;
-	s->range_table = &range_digital;
-	s->insn_write = apci1564_timer_write;
-	s->insn_read = apci1564_timer_read;
-	s->insn_config = apci1564_timer_config;
-
 	/* Change-Of-State (COS) interrupt subdevice */
-	s = &dev->subdevices[3];
+	s = &dev->subdevices[2];
 	if (dev->irq) {
 		dev->read_subdev = s;
 		s->type = COMEDI_SUBD_DI;
@@ -428,6 +416,24 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
+	/*  Allocate and Initialise Timer Subdevice Structures */
+	s = &dev->subdevices[3];
+	s->type = COMEDI_SUBD_TIMER;
+	s->subdev_flags = SDF_WRITEABLE;
+	s->n_chan = 1;
+	s->maxdata = 0;
+	s->len_chanlist = 1;
+	s->range_table = &range_digital;
+	s->insn_write = apci1564_timer_write;
+	s->insn_read = apci1564_timer_read;
+	s->insn_config = apci1564_timer_config;
+
+	/* Initialize the watchdog subdevice */
+	s = &dev->subdevices[4];
+	ret = addi_watchdog_init(s, devpriv->amcc_iobase + APCI1564_WDOG_REG);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
-- 
2.0.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaHAB4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 21:56:34 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:36097 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaHAB4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 21:56:33 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 1/2] staging: comedi: addi_apci_1564: add subdevice to check diagnostic status
Date: Thu, 31 Jul 2014 20:56:15 -0500
Message-Id: <7e824d483394e596c816ed60e027235011a667a1.1406857380.git.chase.southwood@gmail.com>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <cover.1406857380.git.chase.southwood@gmail.com>
References: <cover.1406857380.git.chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This board provides VCC/CC diagnostic information, and it also supports
diagnostic interrupts.  However, as per Ian, these interrupts aren't very
useful and it is enough to simply provide an interface for accessing the
diagnostic status on-demand.  This patch adds a 2-channel digital input
subdevice with an insn_bits handler to access this information.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---
 drivers/staging/comedi/drivers/addi_apci_1564.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 190b026..819255b 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -157,6 +157,18 @@ static int apci1564_do_insn_bits(struct comedi_device *dev,
 	return insn->n;
 }
 
+static int apci1564_diag_insn_bits(struct comedi_device *dev,
+				   struct comedi_subdevice *s,
+				   struct comedi_insn *insn,
+				   unsigned int *data)
+{
+	struct apci1564_private *devpriv = dev->private;
+
+	data[1] = inl(devpriv->amcc_iobase + APCI1564_DO_INT_STATUS_REG) & 3;
+
+	return insn->n;
+}
+
 /*
  * Change-Of-State (COS) interrupt configuration
  *
@@ -373,7 +385,7 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 			dev->irq = pcidev->irq;
 	}
 
-	ret = comedi_alloc_subdevices(dev, 5);
+	ret = comedi_alloc_subdevices(dev, 6);
 	if (ret)
 		return ret;
 
@@ -434,6 +446,15 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
+	/* Initialize the diagnostic status subdevice */
+	s = &dev->subdevices[5];
+	s->type = COMEDI_SUBD_DI;
+	s->subdev_flags = SDF_READABLE;
+	s->n_chan = 2;
+	s->maxdata = 1;
+	s->range_table = &range_digital;
+	s->insn_bits = apci1564_diag_insn_bits;
+
 	return 0;
 }
 
-- 
2.0.3


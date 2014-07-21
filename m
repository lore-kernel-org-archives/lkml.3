Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026AbaGUQ3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 12:29:22 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:59334 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932714AbaGUQ3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 12:29:19 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: comedi: ni_6527: support INSN_CONFIG_DIGITAL_TRIG
Date: Mon, 21 Jul 2014 17:29:05 +0100
Message-Id: <1405960146-8959-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1405960146-8959-1-git-send-email-abbotti@mev.co.uk>
References: <1405960146-8959-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "edge detection interrupt" subdevice supports the
`INSN_CONFIG_CHANGE_NOTIFY` comedi instruction which is only supported
by one other driver.  The `INSN_CONFIG_DIGITAL_TRIG` comedi instruction
is more flexible as it supports both edge and level detection, but is
not currently supported by this driver.

Add partial support for `INSN_CONFIG_DIGITAL_TRIG`, but only for edge
detection.  Make use of the `ni6527_set_edge_detection()` used for
`INSN_CONFIG_CHANGE_NOTIFY`, but add a parameter holding a mask of the
rising and falling edges to be updated and preserve the unmasked edges
when updating.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_6527.c | 72 +++++++++++++++++++++++++++-----
 1 file changed, 61 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_6527.c b/drivers/staging/comedi/drivers/ni_6527.c
index c8b1fa7..57d8d4c 100644
--- a/drivers/staging/comedi/drivers/ni_6527.c
+++ b/drivers/staging/comedi/drivers/ni_6527.c
@@ -299,21 +299,38 @@ static int ni6527_intr_insn_bits(struct comedi_device *dev,
 }
 
 static void ni6527_set_edge_detection(struct comedi_device *dev,
+				      unsigned int mask,
 				      unsigned int rising,
 				      unsigned int falling)
 {
 	struct ni6527_private *devpriv = dev->private;
 	void __iomem *mmio = devpriv->mmio_base;
-
-	/* enable rising-edge detection channels */
-	writeb(rising & 0xff, mmio + NI6527_RISING_EDGE_REG(0));
-	writeb((rising >> 8) & 0xff, mmio + NI6527_RISING_EDGE_REG(1));
-	writeb((rising >> 16) & 0xff, mmio + NI6527_RISING_EDGE_REG(2));
-
-	/* enable falling-edge detection channels */
-	writeb(falling & 0xff, mmio + NI6527_FALLING_EDGE_REG(0));
-	writeb((falling >> 8) & 0xff, mmio + NI6527_FALLING_EDGE_REG(1));
-	writeb((falling >> 16) & 0xff, mmio + NI6527_FALLING_EDGE_REG(2));
+	unsigned int i;
+
+	rising &= mask;
+	falling &= mask;
+	for (i = 0; i < 2; i++) {
+		if (mask & 0xff) {
+			if (~mask & 0xff) {
+				/* preserve rising-edge detection channels */
+				rising |= readb(mmio +
+						NI6527_RISING_EDGE_REG(i)) &
+					  (~mask & 0xff);
+				/* preserve falling-edge detection channels */
+				falling |= readb(mmio +
+						 NI6527_FALLING_EDGE_REG(i)) &
+					   (~mask & 0xff);
+			}
+			/* update rising-edge detection channels */
+			writeb(rising & 0xff, mmio + NI6527_RISING_EDGE_REG(i));
+			/* update falling-edge detection channels */
+			writeb(falling & 0xff,
+			       mmio + NI6527_FALLING_EDGE_REG(i));
+		}
+		rising >>= 8;
+		falling >>= 8;
+		mask >>= 8;
+	}
 }
 
 static int ni6527_intr_insn_config(struct comedi_device *dev,
@@ -321,12 +338,45 @@ static int ni6527_intr_insn_config(struct comedi_device *dev,
 				   struct comedi_insn *insn,
 				   unsigned int *data)
 {
+	unsigned int mask = 0xffffffff;
+	unsigned int rising, falling, shift;
+
 	switch (data[0]) {
 	case INSN_CONFIG_CHANGE_NOTIFY:
 		/* check_insn_config_length() does not check this instruction */
 		if (insn->n != 3)
 			return -EINVAL;
-		ni6527_set_edge_detection(dev, data[1], data[2]);
+		rising = data[1];
+		falling = data[2];
+		ni6527_set_edge_detection(dev, mask, rising, falling);
+		break;
+	case INSN_CONFIG_DIGITAL_TRIG:
+		/* check trigger number */
+		if (data[1] != 0)
+			return -EINVAL;
+		/* check digital trigger operation */
+		switch (data[2]) {
+		case COMEDI_DIGITAL_TRIG_DISABLE:
+			rising = 0;
+			falling = 0;
+			break;
+		case COMEDI_DIGITAL_TRIG_ENABLE_EDGES:
+			/* check shift amount */
+			shift = data[3];
+			if (shift >= s->n_chan) {
+				mask = 0;
+				rising = 0;
+				falling = 0;
+			} else {
+				mask <<= shift;
+				rising = data[4] << shift;
+				falling = data[5] << shift;
+			}
+			break;
+		default:
+			return -EINVAL;
+		}
+		ni6527_set_edge_detection(dev, mask, rising, falling);
 		break;
 	default:
 		return -EINVAL;
-- 
2.0.0


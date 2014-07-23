Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbaGWJlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:41:35 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:35901 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127AbaGWJld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:41:33 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] staging: comedi: ni_65xx: refactor edge detection configuration
Date: Wed, 23 Jul 2014 10:41:19 +0100
Message-Id: <1406108481-23910-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406108481-23910-1-git-send-email-abbotti@mev.co.uk>
References: <1406108481-23910-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the code that updates the rising and falling edge detection
registers into new function `ni_65xx_update_edge_detection()`.  This
updates the rising and falling edge detection registers for up to 32
channels starting at an arbitrary channel.  Call it from the code that
handles the `INSN_CONFIG_CHANGE_NOTIFY` instruction, which is limited to
the first 32 channels.

(For the purposes of edge detection, the channels are in the natural
port order of the board, 8 channels per port.  In practice, this is all
the digital I/O channels (if any), followed by all the digital input
channels (if any), followed by all the digital output channels (if any).

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_65xx.c | 71 ++++++++++++++++++++++----------
 1 file changed, 49 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index 0f9185e..f7566fe 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -317,6 +317,54 @@ static void ni_65xx_disable_input_filters(struct comedi_device *dev)
 	writel(0x00000000, devpriv->mmio + NI_65XX_FILTER_REG);
 }
 
+/* updates edge detection for base_chan to base_chan+31 */
+static void ni_65xx_update_edge_detection(struct comedi_device *dev,
+					  unsigned int base_chan,
+					  unsigned int rising,
+					  unsigned int falling)
+{
+	struct ni_65xx_private *devpriv = dev->private;
+	unsigned int num_ports = ni_65xx_num_ports(dev);
+	unsigned int port;
+
+	if (base_chan >= NI_65XX_PORT_TO_CHAN(num_ports))
+		return;
+
+	for (port = NI_65XX_CHAN_TO_PORT(base_chan); port < num_ports; port++) {
+		int bitshift = (int)(NI_65XX_PORT_TO_CHAN(port) - base_chan);
+		unsigned int port_mask, port_rising, port_falling;
+
+		if (bitshift >= 32)
+			break;
+
+		if (bitshift >= 0) {
+			port_mask = ~0U >> bitshift;
+			port_rising = rising >> bitshift;
+			port_falling = falling >> bitshift;
+		} else {
+			port_mask = ~0U << -bitshift;
+			port_rising = rising << -bitshift;
+			port_falling = falling << -bitshift;
+		}
+		if (port_mask & 0xff) {
+			if (~port_mask & 0xff) {
+				port_rising |=
+				    readb(devpriv->mmio +
+					  NI_65XX_RISE_EDGE_ENA_REG(port)) &
+				    ~port_mask;
+				port_falling |=
+				    readb(devpriv->mmio +
+					  NI_65XX_FALL_EDGE_ENA_REG(port)) &
+				    ~port_mask;
+			}
+			writeb(port_rising & 0xff,
+			       devpriv->mmio + NI_65XX_RISE_EDGE_ENA_REG(port));
+			writeb(port_falling & 0xff,
+			       devpriv->mmio + NI_65XX_FALL_EDGE_ENA_REG(port));
+		}
+	}
+}
+
 static int ni_65xx_dio_insn_config(struct comedi_device *dev,
 				   struct comedi_subdevice *s,
 				   struct comedi_insn *insn,
@@ -545,8 +593,6 @@ static int ni_65xx_intr_insn_config(struct comedi_device *dev,
 				    struct comedi_insn *insn,
 				    unsigned int *data)
 {
-	struct ni_65xx_private *devpriv = dev->private;
-
 	switch (data[0]) {
 	case INSN_CONFIG_CHANGE_NOTIFY:
 		/* add instruction to check_insn_config_length() */
@@ -556,26 +602,7 @@ static int ni_65xx_intr_insn_config(struct comedi_device *dev,
 		/*
 		 * This only works for the first 4 ports (32 channels)!
 		 */
-
-		/* set the channels to monitor for rising edges */
-		writeb(data[1] & 0xff,
-		       devpriv->mmio + NI_65XX_RISE_EDGE_ENA_REG(0));
-		writeb((data[1] >> 8) & 0xff,
-		       devpriv->mmio + NI_65XX_RISE_EDGE_ENA_REG(1));
-		writeb((data[1] >> 16) & 0xff,
-		       devpriv->mmio + NI_65XX_RISE_EDGE_ENA_REG(2));
-		writeb((data[1] >> 24) & 0xff,
-		       devpriv->mmio + NI_65XX_RISE_EDGE_ENA_REG(3));
-
-		/* set the channels to monitor for falling edges */
-		writeb(data[2] & 0xff,
-		       devpriv->mmio + NI_65XX_FALL_EDGE_ENA_REG(0));
-		writeb((data[2] >> 8) & 0xff,
-		       devpriv->mmio + NI_65XX_FALL_EDGE_ENA_REG(1));
-		writeb((data[2] >> 16) & 0xff,
-		       devpriv->mmio + NI_65XX_FALL_EDGE_ENA_REG(2));
-		writeb((data[2] >> 24) & 0xff,
-		       devpriv->mmio + NI_65XX_FALL_EDGE_ENA_REG(3));
+		ni_65xx_update_edge_detection(dev, 0, data[1], data[2]);
 		break;
 	default:
 		return -EINVAL;
-- 
2.0.0


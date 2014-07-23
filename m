Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbaGWJli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:41:38 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:35905 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757651AbaGWJld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:41:33 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] staging: comedi: ni_65xx: support INSN_CONFIG_DIGITAL_TRIG
Date: Wed, 23 Jul 2014 10:41:20 +0100
Message-Id: <1406108481-23910-4-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406108481-23910-1-git-send-email-abbotti@mev.co.uk>
References: <1406108481-23910-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "edge detection interrupt" subdevice supports the
`INSN_CONFIG_CHANGE_NOTIFY` comedi instruction which is only supported
by one other driver.  It is limited to the first 32 channels, but boards
supported by this driver support edge detection on all digital I/O,
digital input and digital output channels.  The
`INSN_CONFIG_DIGITAL_TRIG` comedi instruction is more flexible as it
supports more than 32 channels (with multiple instructions).  It can
also support level detection, but the hardware does not support that.

Add partial support for the `INSN_CONFIG_DIGITAL_TRIG` instruction, but
only for edge detection.

Since `INSN_CONFIG_CHANGE_NOTIFY` can only deal with 32 channels, make
it disable edge detection for any remaining channels.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_65xx.c | 39 +++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index f7566fe..ddf9135 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -365,6 +365,16 @@ static void ni_65xx_update_edge_detection(struct comedi_device *dev,
 	}
 }
 
+static void ni_65xx_disable_edge_detection(struct comedi_device *dev)
+{
+	/* clear edge detection for channels 0 to 31 */
+	ni_65xx_update_edge_detection(dev, 0, 0, 0);
+	/* clear edge detection for channels 32 to 63 */
+	ni_65xx_update_edge_detection(dev, 32, 0, 0);
+	/* clear edge detection for channels 64 to 95 */
+	ni_65xx_update_edge_detection(dev, 64, 0, 0);
+}
+
 static int ni_65xx_dio_insn_config(struct comedi_device *dev,
 				   struct comedi_subdevice *s,
 				   struct comedi_insn *insn,
@@ -599,10 +609,33 @@ static int ni_65xx_intr_insn_config(struct comedi_device *dev,
 		if (insn->n != 3)
 			return -EINVAL;
 
-		/*
-		 * This only works for the first 4 ports (32 channels)!
-		 */
+		/* update edge detection for channels 0 to 31 */
 		ni_65xx_update_edge_detection(dev, 0, data[1], data[2]);
+		/* clear edge detection for channels 32 to 63 */
+		ni_65xx_update_edge_detection(dev, 32, 0, 0);
+		/* clear edge detection for channels 64 to 95 */
+		ni_65xx_update_edge_detection(dev, 64, 0, 0);
+		break;
+	case INSN_CONFIG_DIGITAL_TRIG:
+		/* check trigger number */
+		if (data[1] != 0)
+			return -EINVAL;
+		/* check digital trigger operation */
+		switch (data[2]) {
+		case COMEDI_DIGITAL_TRIG_DISABLE:
+			ni_65xx_disable_edge_detection(dev);
+			break;
+		case COMEDI_DIGITAL_TRIG_ENABLE_EDGES:
+			/*
+			 * update edge detection for channels data[3]
+			 * to (data[3] + 31)
+			 */
+			ni_65xx_update_edge_detection(dev, data[3],
+						      data[4], data[5]);
+			break;
+		default:
+			return -EINVAL;
+		}
 		break;
 	default:
 		return -EINVAL;
-- 
2.0.0


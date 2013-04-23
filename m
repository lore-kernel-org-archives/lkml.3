Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab3DWWSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:18:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757389Ab3DWVwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:52:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 07/42] can: sja1000: fix handling on dt properties on little endian systems
Date: Tue, 23 Apr 2013 14:52:05 -0700
Message-Id: <20130423215206.306480534@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215205.523980967@linuxfoundation.org>
References: <20130423215205.523980967@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Fritz <chf.fritz@googlemail.com>

commit 0443de5fbf224abf41f688d8487b0c307dc5a4b4 upstream.

To get correct endianes on little endian cpus (like arm) while reading device
tree properties, this patch replaces of_get_property() with
of_property_read_u32(). While there use of_property_read_bool() for the
handling of the boolean "nxp,no-comparator-bypass" property.

Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/sja1000/sja1000_of_platform.c |   31 ++++++++++++--------------
 1 file changed, 15 insertions(+), 16 deletions(-)

--- a/drivers/net/can/sja1000/sja1000_of_platform.c
+++ b/drivers/net/can/sja1000/sja1000_of_platform.c
@@ -96,8 +96,8 @@ static int sja1000_ofp_probe(struct plat
 	struct net_device *dev;
 	struct sja1000_priv *priv;
 	struct resource res;
-	const u32 *prop;
-	int err, irq, res_size, prop_size;
+	u32 prop;
+	int err, irq, res_size;
 	void __iomem *base;
 
 	err = of_address_to_resource(np, 0, &res);
@@ -138,27 +138,27 @@ static int sja1000_ofp_probe(struct plat
 	priv->read_reg = sja1000_ofp_read_reg;
 	priv->write_reg = sja1000_ofp_write_reg;
 
-	prop = of_get_property(np, "nxp,external-clock-frequency", &prop_size);
-	if (prop && (prop_size ==  sizeof(u32)))
-		priv->can.clock.freq = *prop / 2;
+	err = of_property_read_u32(np, "nxp,external-clock-frequency", &prop);
+	if (!err)
+		priv->can.clock.freq = prop / 2;
 	else
 		priv->can.clock.freq = SJA1000_OFP_CAN_CLOCK; /* default */
 
-	prop = of_get_property(np, "nxp,tx-output-mode", &prop_size);
-	if (prop && (prop_size == sizeof(u32)))
-		priv->ocr |= *prop & OCR_MODE_MASK;
+	err = of_property_read_u32(np, "nxp,tx-output-mode", &prop);
+	if (!err)
+		priv->ocr |= prop & OCR_MODE_MASK;
 	else
 		priv->ocr |= OCR_MODE_NORMAL; /* default */
 
-	prop = of_get_property(np, "nxp,tx-output-config", &prop_size);
-	if (prop && (prop_size == sizeof(u32)))
-		priv->ocr |= (*prop << OCR_TX_SHIFT) & OCR_TX_MASK;
+	err = of_property_read_u32(np, "nxp,tx-output-config", &prop);
+	if (!err)
+		priv->ocr |= (prop << OCR_TX_SHIFT) & OCR_TX_MASK;
 	else
 		priv->ocr |= OCR_TX0_PULLDOWN; /* default */
 
-	prop = of_get_property(np, "nxp,clock-out-frequency", &prop_size);
-	if (prop && (prop_size == sizeof(u32)) && *prop) {
-		u32 divider = priv->can.clock.freq * 2 / *prop;
+	err = of_property_read_u32(np, "nxp,clock-out-frequency", &prop);
+	if (!err && prop) {
+		u32 divider = priv->can.clock.freq * 2 / prop;
 
 		if (divider > 1)
 			priv->cdr |= divider / 2 - 1;
@@ -168,8 +168,7 @@ static int sja1000_ofp_probe(struct plat
 		priv->cdr |= CDR_CLK_OFF; /* default */
 	}
 
-	prop = of_get_property(np, "nxp,no-comparator-bypass", NULL);
-	if (!prop)
+	if (!of_property_read_bool(np, "nxp,no-comparator-bypass"))
 		priv->cdr |= CDR_CBP; /* default */
 
 	priv->irq_flags = IRQF_SHARED;



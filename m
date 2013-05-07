Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab3EGO02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:26:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42025 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759217Ab3EGNkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoph Fritz <chf.fritz@googlemail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 004/118] can: sja1000: fix handling on dt properties on little endian systems
Date: Tue,  7 May 2013 14:37:30 +0100
Message-Id: <1367933964-1564-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Fritz <chf.fritz@googlemail.com>

commit 0443de5fbf224abf41f688d8487b0c307dc5a4b4 upstream.

To get correct endianes on little endian cpus (like arm) while reading device
tree properties, this patch replaces of_get_property() with
of_property_read_u32(). While there use of_property_read_bool() for the
handling of the boolean "nxp,no-comparator-bypass" property.

Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/sja1000/sja1000_of_platform.c | 31 +++++++++++++--------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000_of_platform.c b/drivers/net/can/sja1000/sja1000_of_platform.c
index f2683eb..c505b55 100644
--- a/drivers/net/can/sja1000/sja1000_of_platform.c
+++ b/drivers/net/can/sja1000/sja1000_of_platform.c
@@ -94,8 +94,8 @@ static int __devinit sja1000_ofp_probe(struct platform_device *ofdev)
 	struct net_device *dev;
 	struct sja1000_priv *priv;
 	struct resource res;
-	const u32 *prop;
-	int err, irq, res_size, prop_size;
+	u32 prop;
+	int err, irq, res_size;
 	void __iomem *base;
 
 	err = of_address_to_resource(np, 0, &res);
@@ -136,27 +136,27 @@ static int __devinit sja1000_ofp_probe(struct platform_device *ofdev)
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
@@ -166,8 +166,7 @@ static int __devinit sja1000_ofp_probe(struct platform_device *ofdev)
 		priv->cdr |= CDR_CLK_OFF; /* default */
 	}
 
-	prop = of_get_property(np, "nxp,no-comparator-bypass", NULL);
-	if (!prop)
+	if (!of_property_read_bool(np, "nxp,no-comparator-bypass"))
 		priv->cdr |= CDR_CBP; /* default */
 
 	priv->irq_flags = IRQF_SHARED;
-- 
1.8.1.2


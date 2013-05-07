Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab3EGE2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:28:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664Ab3EGEZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:59 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=buzJDzngyfAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=xAwr6dKmxQ0A:10 a=mK_AVkanAAAA:8 a=VwQbUJbxAAAA:8 a=Z9hppVypvsQCDiRzgicA:9 a=9xyTavCNlvEA:10 a=XNN-oNMjSfgA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035851.430590883@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Christoph Fritz <chf.fritz@googlemail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [063/126] can: sja1000: fix handling on dt properties on little endian systems
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0063-can-sja1000-fix-handling-on-dt-properties-on-little-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Christoph Fritz <chf.fritz@googlemail.com>

[ Upstream commit 0443de5fbf224abf41f688d8487b0c307dc5a4b4 ]

To get correct endianes on little endian cpus (like arm) while reading device
tree properties, this patch replaces of_get_property() with
of_property_read_u32(). While there use of_property_read_bool() for the
handling of the boolean "nxp,no-comparator-bypass" property.

Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/can/sja1000/sja1000_of_platform.c |   31 ++++++++++++-------------
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
1.7.10.4



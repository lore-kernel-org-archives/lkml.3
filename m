Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab3KHPKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:10:36 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:48360 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757714Ab3KHPKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:10:35 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, <herbert@gondor.hengli.com.au>,
        <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <eric@eukrea.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH RESEND 6/7] crypto: atmel-sha - add support for Device Tree
Date: Fri, 8 Nov 2013 16:08:15 +0100
Message-ID: <15ba31027b31357003a7802fd32beab8f2fd2cdb.1383922546.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1383922546.git.nicolas.ferre@atmel.com>
References: <cover.1383922546.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Device Tree and use of the DMA DT API to
get the channels if needed.
Documentation is added for these DT nodes.

Initial code by: Nicolas Royer and Eukrea.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 .../devicetree/bindings/crypto/atmel-crypto.txt    | 22 +++++
 drivers/crypto/atmel-sha.c                         | 99 ++++++++++++++++------
 2 files changed, 97 insertions(+), 24 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/atmel-crypto.txt b/Documentation/devicetree/bindings/crypto/atmel-crypto.txt
index 9a24fd9..f2aab3d 100644
--- a/Documentation/devicetree/bindings/crypto/atmel-crypto.txt
+++ b/Documentation/devicetree/bindings/crypto/atmel-crypto.txt
@@ -44,3 +44,25 @@ tdes@f803c000 {
 	       <&dma1 2 21>;
 	dma-names = "tx", "rx";
 };
+
+* Secure Hash Algorithm (SHA)
+
+Required properties:
+- compatible : Should be "atmel,at91sam9g46-sha".
+- reg: Should contain SHA registers location and length.
+- interrupts: Should contain the IRQ line for the SHA.
+
+Optional properties:
+- dmas: One DMA specifiers as described in
+        atmel-dma.txt and dma.txt files.
+- dma-names: Contains one identifier string for each DMA specifier
+             in the dmas property. Only one "tx" string needed.
+
+Example:
+sha@f8034000 {
+	compatible = "atmel,at91sam9g46-sha";
+	reg = <0xf8034000 0x100>;
+	interrupts = <42 4 0>;
+	dmas = <&dma1 2 17>;
+	dma-names = "tx";
+};
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index eaed8bf..ecfdf72 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -30,6 +30,7 @@
 #include <linux/irq.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
+#include <linux/of_device.h>
 #include <linux/delay.h>
 #include <linux/crypto.h>
 #include <linux/cryptohash.h>
@@ -1263,32 +1264,29 @@ static int atmel_sha_dma_init(struct atmel_sha_dev *dd,
 	int err = -ENOMEM;
 	dma_cap_mask_t mask_in;
 
-	if (pdata && pdata->dma_slave->rxdata.dma_dev) {
-		/* Try to grab DMA channel */
-		dma_cap_zero(mask_in);
-		dma_cap_set(DMA_SLAVE, mask_in);
+	/* Try to grab DMA channel */
+	dma_cap_zero(mask_in);
+	dma_cap_set(DMA_SLAVE, mask_in);
 
-		dd->dma_lch_in.chan = dma_request_channel(mask_in,
-				atmel_sha_filter, &pdata->dma_slave->rxdata);
-
-		if (!dd->dma_lch_in.chan)
-			return err;
-
-		dd->dma_lch_in.dma_conf.direction = DMA_MEM_TO_DEV;
-		dd->dma_lch_in.dma_conf.dst_addr = dd->phys_base +
-			SHA_REG_DIN(0);
-		dd->dma_lch_in.dma_conf.src_maxburst = 1;
-		dd->dma_lch_in.dma_conf.src_addr_width =
-			DMA_SLAVE_BUSWIDTH_4_BYTES;
-		dd->dma_lch_in.dma_conf.dst_maxburst = 1;
-		dd->dma_lch_in.dma_conf.dst_addr_width =
-			DMA_SLAVE_BUSWIDTH_4_BYTES;
-		dd->dma_lch_in.dma_conf.device_fc = false;
-
-		return 0;
+	dd->dma_lch_in.chan = dma_request_slave_channel_compat(mask_in,
+			atmel_sha_filter, &pdata->dma_slave->rxdata, dd->dev, "tx");
+	if (!dd->dma_lch_in.chan) {
+		dev_warn(dd->dev, "no DMA channel available\n");
+		return err;
 	}
 
-	return -ENODEV;
+	dd->dma_lch_in.dma_conf.direction = DMA_MEM_TO_DEV;
+	dd->dma_lch_in.dma_conf.dst_addr = dd->phys_base +
+		SHA_REG_DIN(0);
+	dd->dma_lch_in.dma_conf.src_maxburst = 1;
+	dd->dma_lch_in.dma_conf.src_addr_width =
+		DMA_SLAVE_BUSWIDTH_4_BYTES;
+	dd->dma_lch_in.dma_conf.dst_maxburst = 1;
+	dd->dma_lch_in.dma_conf.dst_addr_width =
+		DMA_SLAVE_BUSWIDTH_4_BYTES;
+	dd->dma_lch_in.dma_conf.device_fc = false;
+
+	return 0;
 }
 
 static void atmel_sha_dma_cleanup(struct atmel_sha_dev *dd)
@@ -1326,6 +1324,48 @@ static void atmel_sha_get_cap(struct atmel_sha_dev *dd)
 	}
 }
 
+#if defined(CONFIG_OF)
+static const struct of_device_id atmel_sha_dt_ids[] = {
+	{ .compatible = "atmel,at91sam9g46-sha" },
+	{ /* sentinel */ }
+};
+
+MODULE_DEVICE_TABLE(of, atmel_sha_dt_ids);
+
+static struct crypto_platform_data *atmel_sha_of_init(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct crypto_platform_data *pdata;
+
+	if (!np) {
+		dev_err(&pdev->dev, "device node not found\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		dev_err(&pdev->dev, "could not allocate memory for pdata\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	pdata->dma_slave = devm_kzalloc(&pdev->dev,
+					sizeof(*(pdata->dma_slave)),
+					GFP_KERNEL);
+	if (!pdata->dma_slave) {
+		dev_err(&pdev->dev, "could not allocate memory for dma_slave\n");
+		devm_kfree(&pdev->dev, pdata);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return pdata;
+}
+#else /* CONFIG_OF */
+static inline struct crypto_platform_data *atmel_sha_of_init(struct platform_device *dev)
+{
+	return ERR_PTR(-EINVAL);
+}
+#endif
+
 static int atmel_sha_probe(struct platform_device *pdev)
 {
 	struct atmel_sha_dev *sha_dd;
@@ -1402,13 +1442,23 @@ static int atmel_sha_probe(struct platform_device *pdev)
 	if (sha_dd->caps.has_dma) {
 		pdata = pdev->dev.platform_data;
 		if (!pdata) {
-			dev_err(&pdev->dev, "platform data not available\n");
+			pdata = atmel_sha_of_init(pdev);
+			if (IS_ERR(pdata)) {
+				dev_err(&pdev->dev, "platform data not available\n");
+				err = PTR_ERR(pdata);
+				goto err_pdata;
+			}
+		}
+		if (!pdata->dma_slave) {
 			err = -ENXIO;
 			goto err_pdata;
 		}
 		err = atmel_sha_dma_init(sha_dd, pdata);
 		if (err)
 			goto err_sha_dma;
+
+		dev_info(dev, "using %s for DMA transfers\n",
+				dma_chan_name(sha_dd->dma_lch_in.chan));
 	}
 
 	spin_lock(&atmel_sha.lock);
@@ -1483,6 +1533,7 @@ static struct platform_driver atmel_sha_driver = {
 	.driver		= {
 		.name	= "atmel_sha",
 		.owner	= THIS_MODULE,
+		.of_match_table	= of_match_ptr(atmel_sha_dt_ids),
 	},
 };
 
-- 
1.8.2.2


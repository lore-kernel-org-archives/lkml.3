Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab3KHPKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:10:14 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:48254 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471Ab3KHPKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:10:12 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, <herbert@gondor.hengli.com.au>,
        <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <eric@eukrea.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH RESEND 5/7] crypto: atmel-tdes - add support for Device Tree
Date: Fri, 8 Nov 2013 16:08:14 +0100
Message-ID: <a0fb62f3ceeb32f9e2cd0ab7ca75d2fb7d0608b5.1383922546.git.nicolas.ferre@atmel.com>
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
 .../devicetree/bindings/crypto/atmel-crypto.txt    |  23 ++++
 drivers/crypto/atmel-tdes.c                        | 143 ++++++++++++++-------
 2 files changed, 117 insertions(+), 49 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/atmel-crypto.txt b/Documentation/devicetree/bindings/crypto/atmel-crypto.txt
index d273f0b..9a24fd9 100644
--- a/Documentation/devicetree/bindings/crypto/atmel-crypto.txt
+++ b/Documentation/devicetree/bindings/crypto/atmel-crypto.txt
@@ -21,3 +21,26 @@ aes@f8038000 {
 	dmas = <&dma1 2 18>,
 	       <&dma1 2 19>;
 	dma-names = "tx", "rx";
+
+* Triple Data Encryption Standard (Triple DES)
+
+Required properties:
+- compatible : Should be "atmel,at91sam9g46-tdes".
+- reg: Should contain TDES registers location and length.
+- interrupts: Should contain the IRQ line for the TDES.
+
+Optional properties:
+- dmas: List of two DMA specifiers as described in
+        atmel-dma.txt and dma.txt files.
+- dma-names: Contains one identifier string for each DMA specifier
+             in the dmas property.
+
+Example:
+tdes@f803c000 {
+	compatible = "atmel,at91sam9g46-tdes";
+	reg = <0xf803c000 0x100>;
+	interrupts = <44 4 0>;
+	dmas = <&dma1 2 20>,
+	       <&dma1 2 21>;
+	dma-names = "tx", "rx";
+};
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 4a99564..6cde5b5 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -30,6 +30,7 @@
 #include <linux/irq.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
+#include <linux/of_device.h>
 #include <linux/delay.h>
 #include <linux/crypto.h>
 #include <linux/cryptohash.h>
@@ -716,59 +717,50 @@ static int atmel_tdes_dma_init(struct atmel_tdes_dev *dd,
 			struct crypto_platform_data *pdata)
 {
 	int err = -ENOMEM;
-	dma_cap_mask_t mask_in, mask_out;
+	dma_cap_mask_t mask;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+
+	/* Try to grab 2 DMA channels */
+	dd->dma_lch_in.chan = dma_request_slave_channel_compat(mask,
+			atmel_tdes_filter, &pdata->dma_slave->rxdata, dd->dev, "tx");
+	if (!dd->dma_lch_in.chan)
+		goto err_dma_in;
+
+	dd->dma_lch_in.dma_conf.direction = DMA_MEM_TO_DEV;
+	dd->dma_lch_in.dma_conf.dst_addr = dd->phys_base +
+		TDES_IDATA1R;
+	dd->dma_lch_in.dma_conf.src_maxburst = 1;
+	dd->dma_lch_in.dma_conf.src_addr_width =
+		DMA_SLAVE_BUSWIDTH_4_BYTES;
+	dd->dma_lch_in.dma_conf.dst_maxburst = 1;
+	dd->dma_lch_in.dma_conf.dst_addr_width =
+		DMA_SLAVE_BUSWIDTH_4_BYTES;
+	dd->dma_lch_in.dma_conf.device_fc = false;
+
+	dd->dma_lch_out.chan = dma_request_slave_channel_compat(mask,
+			atmel_tdes_filter, &pdata->dma_slave->txdata, dd->dev, "rx");
+	if (!dd->dma_lch_out.chan)
+		goto err_dma_out;
+
+	dd->dma_lch_out.dma_conf.direction = DMA_DEV_TO_MEM;
+	dd->dma_lch_out.dma_conf.src_addr = dd->phys_base +
+		TDES_ODATA1R;
+	dd->dma_lch_out.dma_conf.src_maxburst = 1;
+	dd->dma_lch_out.dma_conf.src_addr_width =
+		DMA_SLAVE_BUSWIDTH_4_BYTES;
+	dd->dma_lch_out.dma_conf.dst_maxburst = 1;
+	dd->dma_lch_out.dma_conf.dst_addr_width =
+		DMA_SLAVE_BUSWIDTH_4_BYTES;
+	dd->dma_lch_out.dma_conf.device_fc = false;
 
-	if (pdata && pdata->dma_slave->txdata.dma_dev &&
-		pdata->dma_slave->rxdata.dma_dev) {
-
-		/* Try to grab 2 DMA channels */
-		dma_cap_zero(mask_in);
-		dma_cap_set(DMA_SLAVE, mask_in);
-
-		dd->dma_lch_in.chan = dma_request_channel(mask_in,
-				atmel_tdes_filter, &pdata->dma_slave->rxdata);
-
-		if (!dd->dma_lch_in.chan)
-			goto err_dma_in;
-
-		dd->dma_lch_in.dma_conf.direction = DMA_MEM_TO_DEV;
-		dd->dma_lch_in.dma_conf.dst_addr = dd->phys_base +
-			TDES_IDATA1R;
-		dd->dma_lch_in.dma_conf.src_maxburst = 1;
-		dd->dma_lch_in.dma_conf.src_addr_width =
-			DMA_SLAVE_BUSWIDTH_4_BYTES;
-		dd->dma_lch_in.dma_conf.dst_maxburst = 1;
-		dd->dma_lch_in.dma_conf.dst_addr_width =
-			DMA_SLAVE_BUSWIDTH_4_BYTES;
-		dd->dma_lch_in.dma_conf.device_fc = false;
-
-		dma_cap_zero(mask_out);
-		dma_cap_set(DMA_SLAVE, mask_out);
-		dd->dma_lch_out.chan = dma_request_channel(mask_out,
-				atmel_tdes_filter, &pdata->dma_slave->txdata);
-
-		if (!dd->dma_lch_out.chan)
-			goto err_dma_out;
-
-		dd->dma_lch_out.dma_conf.direction = DMA_DEV_TO_MEM;
-		dd->dma_lch_out.dma_conf.src_addr = dd->phys_base +
-			TDES_ODATA1R;
-		dd->dma_lch_out.dma_conf.src_maxburst = 1;
-		dd->dma_lch_out.dma_conf.src_addr_width =
-			DMA_SLAVE_BUSWIDTH_4_BYTES;
-		dd->dma_lch_out.dma_conf.dst_maxburst = 1;
-		dd->dma_lch_out.dma_conf.dst_addr_width =
-			DMA_SLAVE_BUSWIDTH_4_BYTES;
-		dd->dma_lch_out.dma_conf.device_fc = false;
-
-		return 0;
-	} else {
-		return -ENODEV;
-	}
+	return 0;
 
 err_dma_out:
 	dma_release_channel(dd->dma_lch_in.chan);
 err_dma_in:
+	dev_warn(dd->dev, "no DMA channel available\n");
 	return err;
 }
 
@@ -1317,6 +1309,47 @@ static void atmel_tdes_get_cap(struct atmel_tdes_dev *dd)
 	}
 }
 
+#if defined(CONFIG_OF)
+static const struct of_device_id atmel_tdes_dt_ids[] = {
+	{ .compatible = "atmel,at91sam9g46-tdes" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, atmel_tdes_dt_ids);
+
+static struct crypto_platform_data *atmel_tdes_of_init(struct platform_device *pdev)
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
+static inline struct crypto_platform_data *atmel_tdes_of_init(struct platform_device *pdev)
+{
+	return ERR_PTR(-EINVAL);
+}
+#endif
+
 static int atmel_tdes_probe(struct platform_device *pdev)
 {
 	struct atmel_tdes_dev *tdes_dd;
@@ -1399,13 +1432,24 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 	if (tdes_dd->caps.has_dma) {
 		pdata = pdev->dev.platform_data;
 		if (!pdata) {
-			dev_err(&pdev->dev, "platform data not available\n");
+			pdata = atmel_tdes_of_init(pdev);
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
 		err = atmel_tdes_dma_init(tdes_dd, pdata);
 		if (err)
 			goto err_tdes_dma;
+
+		dev_info(dev, "using %s, %s for DMA transfers\n",
+				dma_chan_name(tdes_dd->dma_lch_in.chan),
+				dma_chan_name(tdes_dd->dma_lch_out.chan));
 	}
 
 	spin_lock(&atmel_tdes.lock);
@@ -1487,6 +1531,7 @@ static struct platform_driver atmel_tdes_driver = {
 	.driver		= {
 		.name	= "atmel_tdes",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(atmel_tdes_dt_ids),
 	},
 };
 
-- 
1.8.2.2


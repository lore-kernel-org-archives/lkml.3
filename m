Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab3KHPJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:09:50 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:48143 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161Ab3KHPJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:09:48 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>, <herbert@gondor.hengli.com.au>,
        <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <eric@eukrea.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH RESEND 4/7] crypto: atmel-aes - add support for Device Tree
Date: Fri, 8 Nov 2013 16:08:13 +0100
Message-ID: <334fd77d7cadb130e742c2bc6d2a0f431a4302e6.1383922546.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1383922546.git.nicolas.ferre@atmel.com>
References: <cover.1383922546.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Device Tree and use of the DMA DT API to
get the needed channels.
Documentation is added for these DT nodes.

Initial code by: Nicolas Royer and Eukrea.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 .../devicetree/bindings/crypto/atmel-crypto.txt    |  23 ++++
 drivers/crypto/atmel-aes.c                         | 143 ++++++++++++++-------
 2 files changed, 117 insertions(+), 49 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/atmel-crypto.txt

diff --git a/Documentation/devicetree/bindings/crypto/atmel-crypto.txt b/Documentation/devicetree/bindings/crypto/atmel-crypto.txt
new file mode 100644
index 0000000..d273f0b
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/atmel-crypto.txt
@@ -0,0 +1,23 @@
+* Atmel HW cryptographic accelerators
+
+These are the HW cryptographic accelerators found on some Atmel products.
+
+* Advanced Encryption Standard (AES)
+
+Required properties:
+- compatible : Should be "atmel,at91sam9g46-aes".
+- reg: Should contain AES registers location and length.
+- interrupts: Should contain the IRQ line for the AES.
+- dmas: List of two DMA specifiers as described in
+        atmel-dma.txt and dma.txt files.
+- dma-names: Contains one identifier string for each DMA specifier
+             in the dmas property.
+
+Example:
+aes@f8038000 {
+	compatible = "atmel,at91sam9g46-aes";
+	reg = <0xf8038000 0x100>;
+	interrupts = <43 4 0>;
+	dmas = <&dma1 2 18>,
+	       <&dma1 2 19>;
+	dma-names = "tx", "rx";
diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index c1efd91..d7c9e31 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -30,6 +30,7 @@
 #include <linux/irq.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
+#include <linux/of_device.h>
 #include <linux/delay.h>
 #include <linux/crypto.h>
 #include <linux/cryptohash.h>
@@ -39,6 +40,7 @@
 #include <crypto/hash.h>
 #include <crypto/internal/hash.h>
 #include <linux/platform_data/crypto-atmel.h>
+#include <dt-bindings/dma/at91.h>
 #include "atmel-aes-regs.h"
 
 #define CFB8_BLOCK_SIZE		1
@@ -747,59 +749,50 @@ static int atmel_aes_dma_init(struct atmel_aes_dev *dd,
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
+			atmel_aes_filter, &pdata->dma_slave->rxdata, dd->dev, "tx");
+	if (!dd->dma_lch_in.chan)
+		goto err_dma_in;
+
+	dd->dma_lch_in.dma_conf.direction = DMA_MEM_TO_DEV;
+	dd->dma_lch_in.dma_conf.dst_addr = dd->phys_base +
+		AES_IDATAR(0);
+	dd->dma_lch_in.dma_conf.src_maxburst = dd->caps.max_burst_size;
+	dd->dma_lch_in.dma_conf.src_addr_width =
+		DMA_SLAVE_BUSWIDTH_4_BYTES;
+	dd->dma_lch_in.dma_conf.dst_maxburst = dd->caps.max_burst_size;
+	dd->dma_lch_in.dma_conf.dst_addr_width =
+		DMA_SLAVE_BUSWIDTH_4_BYTES;
+	dd->dma_lch_in.dma_conf.device_fc = false;
+
+	dd->dma_lch_out.chan = dma_request_slave_channel_compat(mask,
+			atmel_aes_filter, &pdata->dma_slave->txdata, dd->dev, "rx");
+	if (!dd->dma_lch_out.chan)
+		goto err_dma_out;
+
+	dd->dma_lch_out.dma_conf.direction = DMA_DEV_TO_MEM;
+	dd->dma_lch_out.dma_conf.src_addr = dd->phys_base +
+		AES_ODATAR(0);
+	dd->dma_lch_out.dma_conf.src_maxburst = dd->caps.max_burst_size;
+	dd->dma_lch_out.dma_conf.src_addr_width =
+		DMA_SLAVE_BUSWIDTH_4_BYTES;
+	dd->dma_lch_out.dma_conf.dst_maxburst = dd->caps.max_burst_size;
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
-				atmel_aes_filter, &pdata->dma_slave->rxdata);
-
-		if (!dd->dma_lch_in.chan)
-			goto err_dma_in;
-
-		dd->dma_lch_in.dma_conf.direction = DMA_MEM_TO_DEV;
-		dd->dma_lch_in.dma_conf.dst_addr = dd->phys_base +
-			AES_IDATAR(0);
-		dd->dma_lch_in.dma_conf.src_maxburst = dd->caps.max_burst_size;
-		dd->dma_lch_in.dma_conf.src_addr_width =
-			DMA_SLAVE_BUSWIDTH_4_BYTES;
-		dd->dma_lch_in.dma_conf.dst_maxburst = dd->caps.max_burst_size;
-		dd->dma_lch_in.dma_conf.dst_addr_width =
-			DMA_SLAVE_BUSWIDTH_4_BYTES;
-		dd->dma_lch_in.dma_conf.device_fc = false;
-
-		dma_cap_zero(mask_out);
-		dma_cap_set(DMA_SLAVE, mask_out);
-		dd->dma_lch_out.chan = dma_request_channel(mask_out,
-				atmel_aes_filter, &pdata->dma_slave->txdata);
-
-		if (!dd->dma_lch_out.chan)
-			goto err_dma_out;
-
-		dd->dma_lch_out.dma_conf.direction = DMA_DEV_TO_MEM;
-		dd->dma_lch_out.dma_conf.src_addr = dd->phys_base +
-			AES_ODATAR(0);
-		dd->dma_lch_out.dma_conf.src_maxburst = dd->caps.max_burst_size;
-		dd->dma_lch_out.dma_conf.src_addr_width =
-			DMA_SLAVE_BUSWIDTH_4_BYTES;
-		dd->dma_lch_out.dma_conf.dst_maxburst = dd->caps.max_burst_size;
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
 
@@ -1261,6 +1254,47 @@ static void atmel_aes_get_cap(struct atmel_aes_dev *dd)
 	}
 }
 
+#if defined(CONFIG_OF)
+static const struct of_device_id atmel_aes_dt_ids[] = {
+	{ .compatible = "atmel,at91sam9g46-aes" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, atmel_aes_dt_ids);
+
+static struct crypto_platform_data *atmel_aes_of_init(struct platform_device *pdev)
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
+#else
+static inline struct crypto_platform_data *atmel_aes_of_init(struct platform_device *pdev)
+{
+	return ERR_PTR(-EINVAL);
+}
+#endif
+
 static int atmel_aes_probe(struct platform_device *pdev)
 {
 	struct atmel_aes_dev *aes_dd;
@@ -1272,6 +1306,14 @@ static int atmel_aes_probe(struct platform_device *pdev)
 
 	pdata = pdev->dev.platform_data;
 	if (!pdata) {
+		pdata = atmel_aes_of_init(pdev);
+		if (IS_ERR(pdata)) {
+			err = PTR_ERR(pdata);
+			goto aes_dd_err;
+		}
+	}
+
+	if (!pdata->dma_slave) {
 		err = -ENXIO;
 		goto aes_dd_err;
 	}
@@ -1358,7 +1400,9 @@ static int atmel_aes_probe(struct platform_device *pdev)
 	if (err)
 		goto err_algs;
 
-	dev_info(dev, "Atmel AES\n");
+	dev_info(dev, "Atmel AES - Using %s, %s for DMA transfers\n",
+			dma_chan_name(aes_dd->dma_lch_in.chan),
+			dma_chan_name(aes_dd->dma_lch_out.chan));
 
 	return 0;
 
@@ -1424,6 +1468,7 @@ static struct platform_driver atmel_aes_driver = {
 	.driver		= {
 		.name	= "atmel_aes",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(atmel_aes_dt_ids),
 	},
 };
 
-- 
1.8.2.2


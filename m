Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab3FBHHL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 03:07:11 -0400
Received: from mail.advaoptical.com ([91.217.199.15]:44771 "EHLO
	mail.advaoptical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3FBHHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 03:07:04 -0400
From: Oded Gabbay <ogabbay@advaoptical.com>
To: <gregkh@linuxfoundation.org>, <cjb@laptop.org>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] MMC: P2020 SDHC: Add support for 8-bit bus width connection. Kernel version 3.4.47 
Date: Sun, 2 Jun 2013 09:32:12 +0300
Message-ID: <1370154732-32582-1-git-send-email-ogabbay@advaoptical.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.179.55]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-06-02_02:2013-05-31,2013-06-02,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support of connecting an MMC media using an 8-bit 
bus width connection to Freescale's P2020 H/W SDHC controller. During 
the probe function, it detects if the processor is P2020 (by looking 
at device tree) and if so, it adds the MMC_CAP_8_BIT_DATA to the MMC 
caps 

Signed-off-by: Oded Gabbay <ogabbay@advaoptical.com>
---
 drivers/mmc/host/sdhci-esdhc.h    |  7 ++++++
 drivers/mmc/host/sdhci-of-esdhc.c | 49 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-esdhc.h b/drivers/mmc/host/sdhci-esdhc.h
index d25f9ab..6f9a018 100644
--- a/drivers/mmc/host/sdhci-esdhc.h
+++ b/drivers/mmc/host/sdhci-esdhc.h
@@ -36,6 +36,13 @@
 /* pltfm-specific */
 #define ESDHC_HOST_CONTROL_LE	0x20
 
+/*
+ * P2020 interpretation of the SDHCI_HOST_CONTROL register
+ */
+#define ESDHC_CTRL_4BITBUS          (0x1 << 1)
+#define ESDHC_CTRL_8BITBUS          (0x2 << 1)
+#define ESDHC_CTRL_BUSWIDTH_MASK    (0x3 << 1)
+
 /* OF-specific */
 #define ESDHC_DMA_SYSCTL	0x40c
 #define ESDHC_DMA_SNOOP		0x00000040
diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index f8eb1fb..6f433b8 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -13,6 +13,7 @@
  * your option) any later version.
  */
 
+#include <linux/err.h>
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/delay.h>
@@ -143,6 +144,31 @@ static void esdhc_of_resume(struct sdhci_host *host)
 }
 #endif
 
+static int esdhc_pltfm_bus_width(struct sdhci_host *host, int width)
+{
+	u32 ctrl;
+
+	switch (width) {
+	case MMC_BUS_WIDTH_8:
+		ctrl = ESDHC_CTRL_8BITBUS;
+		break;
+
+	case MMC_BUS_WIDTH_4:
+		ctrl = ESDHC_CTRL_4BITBUS;
+		break;
+
+	default:
+		ctrl = 0;
+		break;
+	}
+
+	clrsetbits_be32(host->ioaddr + SDHCI_HOST_CONTROL,
+			ESDHC_CTRL_BUSWIDTH_MASK, ctrl);
+
+	return 0;
+}
+
+
 static struct sdhci_ops sdhci_esdhc_ops = {
 	.read_l = sdhci_be32bs_readl,
 	.read_w = esdhc_readw,
@@ -158,6 +184,7 @@ static struct sdhci_ops sdhci_esdhc_ops = {
 	.platform_suspend = esdhc_of_suspend,
 	.platform_resume = esdhc_of_resume,
 #endif
+	.platform_8bit_width = esdhc_pltfm_bus_width
 };
 
 static struct sdhci_pltfm_data sdhci_esdhc_pdata = {
@@ -169,7 +196,27 @@ static struct sdhci_pltfm_data sdhci_esdhc_pdata = {
 
 static int __devinit sdhci_esdhc_probe(struct platform_device *pdev)
 {
-	return sdhci_pltfm_register(pdev, &sdhci_esdhc_pdata);
+	struct sdhci_host *host;
+	struct device_node *np;
+	int ret = 0;
+
+	host = sdhci_pltfm_init(pdev, &sdhci_esdhc_pdata);
+	if (IS_ERR(host))
+		return PTR_ERR(host);
+
+	sdhci_get_of_property(pdev);
+
+	np = pdev->dev.of_node;
+	if (of_device_is_compatible(np, "fsl,p2020-esdhc")) {
+		/* P2020 has capability of 8 bit bus width */
+		host->mmc->caps |= MMC_CAP_8_BIT_DATA;
+	}
+
+	ret = sdhci_add_host(host);
+	if (ret)
+		sdhci_pltfm_free(pdev);
+
+	return ret;
 }
 
 static int __devexit sdhci_esdhc_remove(struct platform_device *pdev)
-- 
1.7.11.7


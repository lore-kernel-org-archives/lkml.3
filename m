Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab3FLNxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 09:53:52 -0400
Received: from mail.advaoptical.com ([91.217.199.15]:33344 "EHLO
	mail.advaoptical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab3FLNxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 09:53:51 -0400
From: Oded Gabbay <ogabbay@advaoptical.com>
To: <cjb@laptop.org>, <ogabbay@advaoptical.com>, <shawn.guo@linaro.org>,
        <Chang-Ming.Huang@freescale.com>, <wfp5p@virginia.edu>,
        <gregkh@linuxfoundation.org>, <cbouatmailru@gmail.com>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] MMC: P2020 SDHC: Add support for 8-bit bus width and non-removable card
Date: Wed, 12 Jun 2013 16:53:25 +0300
Message-ID: <1371045205-3164-1-git-send-email-ogabbay@advaoptical.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.179.55]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-06-12_03:2013-06-12,2013-06-12,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support of connecting an MMC media using an 8-bit
bus width connection to Freescale's P2020 H/W SDHC controller. During
the probe function, the generic function mmc_of_parse is called to detect
whether the controller is configured with 8-bit bus width. Also, the generic
function detecs if the non-removable property is set in the device tree.
The function esdhc_pltfm_bus_width was added because the bus width configuration
is platform specific.

Signed-off-by: Oded Gabbay <ogabbay@advaoptical.com>
---
 drivers/mmc/host/sdhci-esdhc.h    |  7 +++++++
 drivers/mmc/host/sdhci-of-esdhc.c | 44 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 50 insertions(+), 1 deletion(-)

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
index 5e68adc..fd149a0 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -13,6 +13,7 @@
  * your option) any later version.
  */
 
+#include <linux/err.h>
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/delay.h>
@@ -230,6 +231,30 @@ static void esdhc_of_platform_init(struct sdhci_host *host)
 		host->quirks &= ~SDHCI_QUIRK_NO_BUSY_IRQ;
 }
 
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
 static const struct sdhci_ops sdhci_esdhc_ops = {
 	.read_l = esdhc_readl,
 	.read_w = esdhc_readw,
@@ -247,6 +272,7 @@ static const struct sdhci_ops sdhci_esdhc_ops = {
 	.platform_resume = esdhc_of_resume,
 #endif
 	.adma_workaround = esdhci_of_adma_workaround,
+	.platform_bus_width = esdhc_pltfm_bus_width,
 };
 
 static const struct sdhci_pltfm_data sdhci_esdhc_pdata = {
@@ -262,7 +288,23 @@ static const struct sdhci_pltfm_data sdhci_esdhc_pdata = {
 
 static int sdhci_esdhc_probe(struct platform_device *pdev)
 {
-	return sdhci_pltfm_register(pdev, &sdhci_esdhc_pdata);
+	struct sdhci_host *host;
+	int ret = 0;
+
+	host = sdhci_pltfm_init(pdev, &sdhci_esdhc_pdata);
+	if (IS_ERR(host))
+		return PTR_ERR(host);
+
+	sdhci_get_of_property(pdev);
+
+	/* call to generic mmc_of_parse to support additional capabilities */
+	mmc_of_parse(host->mmc);
+
+	ret = sdhci_add_host(host);
+	if (ret)
+		sdhci_pltfm_free(pdev);
+
+	return ret;
 }
 
 static int sdhci_esdhc_remove(struct platform_device *pdev)
-- 
1.8.3.1


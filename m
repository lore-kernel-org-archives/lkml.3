Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbaDPRSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:18:08 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:55322 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaDPRSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:18:06 -0400
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Daniel Mack <zonque@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, Mark Brown <broonie@linaro.org>,
        linux-mmc@vger.kernel.org
Subject: [PATCH v4 07/21] ARM: dts: parse DMA config in pxamci
Date: Wed, 16 Apr 2014 21:17:12 +0400
Message-Id: <1397668667-27328-1-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397668411-27162-7-git-send-email-ynvich@gmail.com>
References: <1397668411-27162-7-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing PXA MMC driver cannot get DMA channels in a proper
way from the respective device tree binding.

This patch provides temporary workaround which allows using the
existing driver in DT machines by pointing to the proper
dmaengine-based "marvell,pdma-1.0" DMA.

Even though the new DMA provider is not present we can parse device node
attributes manually and use channel numbers to acquire DMA channel
from the existing non-dmaengine provider.

When Daniel's DMA series is merged there will be no need to manually
parse for "dmas" and this patch can be safely reverted.

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
CC: Daniel Mack <zonque@gmail.com>
CC: Haojian Zhuang <haojian.zhuang@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>
---
   v3..v4
   * no changes

   v2..v3
   * split into good (PATCH 07/21) and temporary (this one) parts

   v1..v2
   * add binding for next-gen dma controller
   * use correct dma declararion
   * number changed from 5 to 3

 drivers/mmc/host/pxamci.c | 59 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 48 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 32fe113..6b67764 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -613,11 +613,46 @@ static int pxamci_of_init(struct platform_device *pdev)
 
         return 0;
 }
+
+static int pxamci_of_init_dma(struct platform_device *pdev,
+		struct pxamci_host *host)
+{
+	struct device_node *np = pdev->dev.of_node;
+	u32 tmp;
+	int i;
+	int ret;
+
+	i = of_property_match_string(np, "dma-names", "rx");
+	if (i < 0)
+		return i;
+
+	ret = of_property_read_u32_index(np, "dmas", 2 * i + 1, &tmp);
+	if (ret < 0)
+		return ret;
+	host->dma_drcmrrx = tmp;
+
+	i = of_property_match_string(np, "dma-names", "tx");
+	if (i < 0)
+		return i;
+
+	ret = of_property_read_u32_index(np, "dmas", 2 * i + 1, &tmp);
+	if (ret < 0)
+		return ret;
+	host->dma_drcmrtx = tmp;
+
+	return 0;
+}
 #else
 static int pxamci_of_init(struct platform_device *pdev)
 {
         return 0;
 }
+
+static int pxamci_of_init_dma(struct platform_device *pdev,
+		struct pxamci_host *host)
+{
+	return -ENODATA;
+}
 #endif
 
 static int pxamci_probe(struct platform_device *pdev)
@@ -741,19 +776,21 @@ static int pxamci_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, mmc);
 
-	dmarx = platform_get_resource(pdev, IORESOURCE_DMA, 0);
-	if (!dmarx) {
-		ret = -ENXIO;
-		goto out;
-	}
-	host->dma_drcmrrx = dmarx->start;
+	if (pxamci_of_init_dma(pdev, host) < 0) {
+		dmarx = platform_get_resource(pdev, IORESOURCE_DMA, 0);
+		if (!dmarx) {
+			ret = -ENXIO;
+			goto out;
+		}
+		host->dma_drcmrrx = dmarx->start;
 
-	dmatx = platform_get_resource(pdev, IORESOURCE_DMA, 1);
-	if (!dmatx) {
-		ret = -ENXIO;
-		goto out;
+		dmatx = platform_get_resource(pdev, IORESOURCE_DMA, 1);
+		if (!dmatx) {
+			ret = -ENXIO;
+			goto out;
+		}
+		host->dma_drcmrtx = dmatx->start;
 	}
-	host->dma_drcmrtx = dmatx->start;
 
 	if (host->pdata) {
 		gpio_cd = host->pdata->gpio_card_detect;
-- 
1.8.4.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173Ab3FNImi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 04:42:38 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:52256 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3FNImf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 04:42:35 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, lee.jones@linaro.org, sachin.kamat@linaro.org,
        Miguel Aguilar <miguel.aguilar@ridgerun.com>
Subject: =?UTF-8?q?=5BPATCH=20Resend=5D=20mfd=3A=20davinci=5Fvoicecodec=3A=20Convert=20to=20use=20devm=5F*=20APIs?=
Date: Fri, 14 Jun 2013 13:57:56 +0530
Message-Id: <1371198476-28373-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* APIs are device managed and make code simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Miguel Aguilar <miguel.aguilar@ridgerun.com>
---
Patch is based on mfd-next tree and compile tested.
This driver gives following compilation error (not introduced by this patch):
drivers/mfd/davinci_voicecodec.c:86:3: error: implicit declaration
of function ‘io_v2p’ [-Werror=implicit-function-declaration]
   (dma_addr_t)(io_v2p(davinci_vc->base) + DAVINCI_VC_WFIFO);

In order to test my changes I added the following to davinci_voicecodec.h file:
+#define IO_OFFSET      0xfd000000 /* Virtual IO = 0xfec00000 */
+#define io_v2p(va)     ((va) - IO_OFFSET)

I am not sure if these changes are right fix for the above error.
---

 drivers/mfd/davinci_voicecodec.c       |   48 +++++++-------------------------
 include/linux/mfd/davinci_voicecodec.h |    2 --
 2 files changed, 10 insertions(+), 40 deletions(-)

diff --git a/drivers/mfd/davinci_voicecodec.c b/drivers/mfd/davinci_voicecodec.c
index b6e2973..fb64398 100644
--- a/drivers/mfd/davinci_voicecodec.c
+++ b/drivers/mfd/davinci_voicecodec.c
@@ -46,7 +46,7 @@ void davinci_vc_write(struct davinci_vc *davinci_vc,
 static int __init davinci_vc_probe(struct platform_device *pdev)
 {
 	struct davinci_vc *davinci_vc;
-	struct resource *res, *mem;
+	struct resource *res;
 	struct mfd_cell *cell = NULL;
 	int ret;
 
@@ -58,7 +58,7 @@ static int __init davinci_vc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	davinci_vc->clk = clk_get(&pdev->dev, NULL);
+	davinci_vc->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(davinci_vc->clk)) {
 		dev_dbg(&pdev->dev,
 			    "could not get the clock for voice codec\n");
@@ -67,35 +67,18 @@ static int __init davinci_vc_probe(struct platform_device *pdev)
 	clk_enable(davinci_vc->clk);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "no mem resource\n");
-		ret = -ENODEV;
-		goto fail2;
-	}
-
-	davinci_vc->pbase = res->start;
-	davinci_vc->base_size = resource_size(res);
 
-	mem = request_mem_region(davinci_vc->pbase, davinci_vc->base_size,
-				 pdev->name);
-	if (!mem) {
-		dev_err(&pdev->dev, "VCIF region already claimed\n");
-		ret = -EBUSY;
-		goto fail2;
-	}
-
-	davinci_vc->base = ioremap(davinci_vc->pbase, davinci_vc->base_size);
-	if (!davinci_vc->base) {
-		dev_err(&pdev->dev, "can't ioremap mem resource.\n");
-		ret = -ENOMEM;
-		goto fail3;
+	davinci_vc->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(davinci_vc->base)) {
+		ret = PTR_ERR(davinci_vc->base);
+		goto fail;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "no DMA resource\n");
 		ret = -ENXIO;
-		goto fail4;
+		goto fail;
 	}
 
 	davinci_vc->davinci_vcif.dma_tx_channel = res->start;
@@ -106,7 +89,7 @@ static int __init davinci_vc_probe(struct platform_device *pdev)
 	if (!res) {
 		dev_err(&pdev->dev, "no DMA resource\n");
 		ret = -ENXIO;
-		goto fail4;
+		goto fail;
 	}
 
 	davinci_vc->davinci_vcif.dma_rx_channel = res->start;
@@ -132,19 +115,13 @@ static int __init davinci_vc_probe(struct platform_device *pdev)
 			      DAVINCI_VC_CELLS, NULL, 0, NULL);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "fail to register client devices\n");
-		goto fail4;
+		goto fail;
 	}
 
 	return 0;
 
-fail4:
-	iounmap(davinci_vc->base);
-fail3:
-	release_mem_region(davinci_vc->pbase, davinci_vc->base_size);
-fail2:
+fail:
 	clk_disable(davinci_vc->clk);
-	clk_put(davinci_vc->clk);
-	davinci_vc->clk = NULL;
 
 	return ret;
 }
@@ -155,12 +132,7 @@ static int davinci_vc_remove(struct platform_device *pdev)
 
 	mfd_remove_devices(&pdev->dev);
 
-	iounmap(davinci_vc->base);
-	release_mem_region(davinci_vc->pbase, davinci_vc->base_size);
-
 	clk_disable(davinci_vc->clk);
-	clk_put(davinci_vc->clk);
-	davinci_vc->clk = NULL;
 
 	return 0;
 }
diff --git a/include/linux/mfd/davinci_voicecodec.h b/include/linux/mfd/davinci_voicecodec.h
index 0ab6132..94c53d4 100644
--- a/include/linux/mfd/davinci_voicecodec.h
+++ b/include/linux/mfd/davinci_voicecodec.h
@@ -112,8 +112,6 @@ struct davinci_vc {
 
 	/* Memory resources */
 	void __iomem *base;
-	resource_size_t pbase;
-	size_t base_size;
 
 	/* MFD cells */
 	struct mfd_cell cells[DAVINCI_VC_CELLS];
-- 
1.7.9.5


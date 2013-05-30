Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967245Ab3E3Ecx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 00:32:53 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:46754 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab3E3Ecr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 00:32:47 -0400
MIME-Version: 1.0
Date: Thu, 30 May 2013 12:32:45 +0800
Message-ID: <CAPgLHd-gjJ6ju3HyhiQi98YFGojvU3aYSTn7SOe4NhQPY1r++w@mail.gmail.com>
Subject: [PATCH -next v2] dmaengine: ste_dma40: fix error return code in d40_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: srinidhi.kasagar@stericsson.com, linus.walleij@linaro.org,
        vinod.koul@intel.com, djbw@fb.com, grant.likely@linaro.org,
        rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In many of the error handling case, the return value 'ret' not set
and 0 will be return from d40_probe() even if error, but we should
return a negative error code instead in those error handling case.
This patch fixed them, and also removed useless variable 'err'.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
v1 -> v2: rebased on linux-next.git
---
 drivers/dma/ste_dma40.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 7f23d45..a241e25 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3506,7 +3506,6 @@ static int __init d40_probe(struct platform_device *pdev)
 {
 	struct stedma40_platform_data *plat_data = pdev->dev.platform_data;
 	struct device_node *np = pdev->dev.of_node;
-	int err;
 	int ret = -ENOENT;
 	struct d40_base *base = NULL;
 	struct resource *res = NULL;
@@ -3619,6 +3618,7 @@ static int __init d40_probe(struct platform_device *pdev)
 		if (IS_ERR(base->lcpa_regulator)) {
 			d40_err(&pdev->dev, "Failed to get lcpa_regulator\n");
 			base->lcpa_regulator = NULL;
+			ret = PTR_ERR(base->lcpa_regulator);
 			goto failure;
 		}
 
@@ -3633,13 +3633,13 @@ static int __init d40_probe(struct platform_device *pdev)
 	}
 
 	base->initialized = true;
-	err = d40_dmaengine_init(base, num_reserved_chans);
-	if (err)
+	ret = d40_dmaengine_init(base, num_reserved_chans);
+	if (ret)
 		goto failure;
 
 	base->dev->dma_parms = &base->dma_parms;
-	err = dma_set_max_seg_size(base->dev, STEDMA40_MAX_SEG_SIZE);
-	if (err) {
+	ret = dma_set_max_seg_size(base->dev, STEDMA40_MAX_SEG_SIZE);
+	if (ret) {
 		d40_err(&pdev->dev, "Failed to set dma max seg size\n");
 		goto failure;
 	}
@@ -3647,8 +3647,8 @@ static int __init d40_probe(struct platform_device *pdev)
 	d40_hw_init(base);
 
 	if (np) {
-		err = of_dma_controller_register(np, d40_xlate, NULL);
-		if (err && err != -ENODEV)
+		ret = of_dma_controller_register(np, d40_xlate, NULL);
+		if (ret && ret != -ENODEV)
 			dev_err(&pdev->dev,
 				"could not register of_dma_controller\n");
 	}


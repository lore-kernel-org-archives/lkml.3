Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab3FDT2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 15:28:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52399 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3FDTZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 15:25:41 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 05/12] msm: iommu: Convert to clk_prepare/unprepare
Date: Tue,  4 Jun 2013 12:25:31 -0700
Message-Id: <1370373938-32417-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc3.8.g5e49f30.dirty
In-Reply-To: <1370373938-32417-1-git-send-email-sboyd@codeaurora.org>
References: <1370373938-32417-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add calls to clk_prepare and unprepare so that MSM can migrate to
the common clock framework. We never unprepare the clocks until
driver remove because the clocks are enabled and disabled in irq
context. Finer grained power management is possible in the future
via runtime power management techniques.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/iommu/msm_iommu_dev.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/msm_iommu_dev.c b/drivers/iommu/msm_iommu_dev.c
index 8e8fb07..d344f6a 100644
--- a/drivers/iommu/msm_iommu_dev.c
+++ b/drivers/iommu/msm_iommu_dev.c
@@ -160,7 +160,7 @@ static int msm_iommu_probe(struct platform_device *pdev)
 		goto fail;
 	}
 
-	ret = clk_enable(iommu_pclk);
+	ret = clk_prepare_enable(iommu_pclk);
 	if (ret)
 		goto fail_enable;
 
@@ -170,7 +170,7 @@ static int msm_iommu_probe(struct platform_device *pdev)
 		if (clk_get_rate(iommu_clk) == 0)
 			clk_set_min_rate(iommu_clk, 1);
 
-		ret = clk_enable(iommu_clk);
+		ret = clk_prepare_enable(iommu_clk);
 		if (ret) {
 			clk_put(iommu_clk);
 			goto fail_pclk;
@@ -261,7 +261,7 @@ fail_clk:
 		clk_put(iommu_clk);
 	}
 fail_pclk:
-	clk_disable(iommu_pclk);
+	clk_disable_unprepare(iommu_pclk);
 fail_enable:
 	clk_put(iommu_pclk);
 fail:
@@ -275,8 +275,11 @@ static int msm_iommu_remove(struct platform_device *pdev)
 
 	drv = platform_get_drvdata(pdev);
 	if (drv) {
-		if (drv->clk)
+		if (drv->clk) {
+			clk_unprepare(drv->clk);
 			clk_put(drv->clk);
+		}
+		clk_unprepare(drv->pclk);
 		clk_put(drv->pclk);
 		memset(drv, 0, sizeof(*drv));
 		kfree(drv);
@@ -314,14 +317,14 @@ static int msm_iommu_ctx_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&ctx_drvdata->attached_elm);
 	platform_set_drvdata(pdev, ctx_drvdata);
 
-	ret = clk_enable(drvdata->pclk);
+	ret = clk_prepare_enable(drvdata->pclk);
 	if (ret)
 		goto fail;
 
 	if (drvdata->clk) {
-		ret = clk_enable(drvdata->clk);
+		ret = clk_prepare_enable(drvdata->clk);
 		if (ret) {
-			clk_disable(drvdata->pclk);
+			clk_disable_unprepare(drvdata->pclk);
 			goto fail;
 		}
 	}
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation


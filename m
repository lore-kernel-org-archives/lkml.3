Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab3IVFE0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 01:04:26 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:62755 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab3IVFEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 01:04:24 -0400
MIME-Version: 1.0
Date: Sun, 22 Sep 2013 13:04:23 +0800
Message-ID: <CAPgLHd9jKOp71tN43=oOUN4X_niTonuQExO1yMSy=3odoRqTcQ@mail.gmail.com>
Subject: [PATCH -next] drivers: CCI: fix the error handle in cci_pmu_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: grant.likely@linaro.org, rob.herring@calxeda.com, nico@linaro.org,
        will.deacon@arm.com, lorenzo.pieralisi@arm.com, dave.martin@linaro.org,
        sudeep.karkadanagesha@arm.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

This patch fix the error handle of function cci_pmu_probe():
- using IS_ERR() instead of NULL test for the return value of
  devm_ioremap_resource() since it nerver return NULL.
- remove kfree() for devm_kzalloc allocated memory
- remove dev_warn() since devm_ioremap_resource() has error message
  already.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/bus/arm-cci.c | 33 +++++++--------------------------
 1 file changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/bus/arm-cci.c b/drivers/bus/arm-cci.c
index dc6528e..edad26c 100644
--- a/drivers/bus/arm-cci.c
+++ b/drivers/bus/arm-cci.c
@@ -565,18 +565,9 @@ static int cci_pmu_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_warn(&pdev->dev, "Failed to get mem resource\n");
-		ret = -EINVAL;
-		goto memalloc_err;
-	};
-
 	pmu->base = devm_ioremap_resource(&pdev->dev, res);
-	if (!pmu->base) {
-		dev_warn(&pdev->dev, "Failed to ioremap\n");
-		ret = -ENOMEM;
-		goto memalloc_err;
-	}
+	if (IS_ERR(pmu->base))
+		return -ENOMEM;
 
 	/*
 	 * CCI PMU has 5 overflow signals - one per counter; but some may be tied
@@ -601,22 +592,18 @@ static int cci_pmu_probe(struct platform_device *pdev)
 	if (i < CCI_PMU_MAX_HW_EVENTS) {
 		dev_warn(&pdev->dev, "In-correct number of interrupts: %d, should be %d\n",
 			i, CCI_PMU_MAX_HW_EVENTS);
-		ret = -EINVAL;
-		goto memalloc_err;
+		return -EINVAL;
 	}
 
 	pmu->port_ranges = port_range_by_rev();
 	if (!pmu->port_ranges) {
 		dev_warn(&pdev->dev, "CCI PMU version not supported\n");
-		ret = -EINVAL;
-		goto memalloc_err;
+		return -EINVAL;
 	}
 
 	pmu->cci_pmu = devm_kzalloc(&pdev->dev, sizeof(*(pmu->cci_pmu)), GFP_KERNEL);
-	if (!pmu->cci_pmu) {
-		ret = -ENOMEM;
-		goto memalloc_err;
-	}
+	if (!pmu->cci_pmu)
+		return -ENOMEM;
 
 	pmu->hw_events.events = pmu->events;
 	pmu->hw_events.used_mask = pmu->used_mask;
@@ -624,15 +611,9 @@ static int cci_pmu_probe(struct platform_device *pdev)
 
 	ret = cci_pmu_init(pmu->cci_pmu, pdev);
 	if (ret)
-		goto pmuinit_err;
+		return ret;
 
 	return 0;
-
-pmuinit_err:
-	kfree(pmu->cci_pmu);
-memalloc_err:
-	kfree(pmu);
-	return ret;
 }
 
 static int cci_platform_probe(struct platform_device *pdev)


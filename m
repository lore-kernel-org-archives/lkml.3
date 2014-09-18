Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbaIRPaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:30:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47561 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298AbaIRPaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:30:21 -0400
X-AuditID: cbfee61b-f79f86d00000144c-19-541afa8befd2
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 28/33] thermal: exynos: remove TMU_SUPPORT_ADDRESS_MULTIPLE flag
Date: Thu, 18 Sep 2014 17:27:45 +0200
Message-id: <1411054070-25757-29-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jAd2eX1IhBm2MFg1XQyw2zljPanH3
	+WFGi/lXrrFanG16w27x5uFmRovLu+awWXzuPcJoMeP8PiaLJw/72By4PHbOusvusXjPSyaP
	vi2rGD0+b5ILYInisklJzcksSy3St0vgyli4fDdLwRyjim/fTzM1MJ7T6mLk5JAQMJHYvvQi
	I4QtJnHh3nq2LkYuDiGBRYwSrff2sUI4XUwSXyfcZgOpYhOwkpjYvgqsQ0RAS+LEpe1MIEXM
	AreYJF7fmAyWEBYIkLjdu4MFxGYRUJXomDSTCcTmFfCUOPWnmRVinaJE97MJYEM5geINtzax
	g9hCAh4SbVvuMk9g5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzjQnknvYFzVYHGI
	UYCDUYmH9wCvVIgQa2JZcWXuIUYJDmYlEd4/H4FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+2
	WgcKCaQnlqRmp6YWpBbBZJk4OKUaGHVWzpn9TeO1QUFPUdzNl3v+itmGTtl5ID1gf+03vitF
	F1KvaXyrcVPe/OB7WHnnz1lri9xU5a3+FPeIKO3SOZ1Sxx7Pv0fblqdgU0YmR/29hStm/gve
	cCrsl2fM04x7MxeZZaqLib/nuSUUvrHwB5OOjXPGBPn+1P6Dsy/wd/l7CVz99saWR4mlOCPR
	UIu5qDgRAD4TYjowAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace TMU_SUPPORT_ADDRESS_MULTIPLE flag check in exynos_map_dt_data()
by an explicit check for a SoC type (only Exynos5420 with TRIMINFO
quirk and Exynos5440 have TMU_SUPPORT_ADDRESS_MULTIPLE flag set in
their struct exynos_tmu_init_data instances).

Please note that this requires moving SoC type assignment and verification
from exynos_tmu_probe() to exynos_map_dt_data() so it happens earlier
(which is a good thing in itself).

There should be no functional changes caused by this patch.

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 72 +++++++++++++++----------------
 drivers/thermal/samsung/exynos_tmu.h      |  3 --
 drivers/thermal/samsung/exynos_tmu_data.c |  5 +--
 3 files changed, 38 insertions(+), 42 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index d31e541..367f4eb 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -488,7 +488,6 @@ static void exynos5440_tmu_set_emulation(struct exynos_tmu_data *data,
 static int exynos_tmu_set_emulation(void *drv_data, unsigned long temp)
 {
 	struct exynos_tmu_data *data = drv_data;
-	struct exynos_tmu_platform_data *pdata = data->pdata;
 	int ret = -EINVAL;
 
 	if (data->soc == SOC_ARCH_EXYNOS4210)
@@ -702,12 +701,47 @@ static int exynos_map_dt_data(struct platform_device *pdev)
 		dev_err(&pdev->dev, "No platform init data supplied.\n");
 		return -ENODEV;
 	}
+
 	data->pdata = pdata;
+	data->soc = pdata->type;
+
+	switch (data->soc) {
+	case SOC_ARCH_EXYNOS4210:
+		data->tmu_initialize = exynos4210_tmu_initialize;
+		data->tmu_control = exynos4210_tmu_control;
+		data->tmu_read = exynos4210_tmu_read;
+		data->tmu_clear_irqs = exynos4210_tmu_clear_irqs;
+		break;
+	case SOC_ARCH_EXYNOS3250:
+	case SOC_ARCH_EXYNOS4412:
+	case SOC_ARCH_EXYNOS5250:
+	case SOC_ARCH_EXYNOS5260:
+	case SOC_ARCH_EXYNOS5420:
+	case SOC_ARCH_EXYNOS5420_TRIMINFO:
+		data->tmu_initialize = exynos4412_tmu_initialize;
+		data->tmu_control = exynos4210_tmu_control;
+		data->tmu_read = exynos4412_tmu_read;
+		data->tmu_set_emulation = exynos4412_tmu_set_emulation;
+		data->tmu_clear_irqs = exynos4210_tmu_clear_irqs;
+		break;
+	case SOC_ARCH_EXYNOS5440:
+		data->tmu_initialize = exynos5440_tmu_initialize;
+		data->tmu_control = exynos5440_tmu_control;
+		data->tmu_read = exynos5440_tmu_read;
+		data->tmu_set_emulation = exynos5440_tmu_set_emulation;
+		data->tmu_clear_irqs = exynos5440_tmu_clear_irqs;
+		break;
+	default:
+		dev_err(&pdev->dev, "Platform not supported\n");
+		return -EINVAL;
+	}
+
 	/*
 	 * Check if the TMU shares some registers and then try to map the
 	 * memory of common registers.
 	 */
-	if (!TMU_SUPPORTS(pdata, ADDRESS_MULTIPLE))
+	if (data->soc != SOC_ARCH_EXYNOS5420_TRIMINFO &&
+	    data->soc != SOC_ARCH_EXYNOS5440)
 		return 0;
 
 	if (of_address_to_resource(pdev->dev.of_node, 1, &res)) {
@@ -774,40 +808,6 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 		goto err_clk_sec;
 	}
 
-	data->soc = pdata->type;
-
-	switch (data->soc) {
-	case SOC_ARCH_EXYNOS4210:
-		data->tmu_initialize = exynos4210_tmu_initialize;
-		data->tmu_control = exynos4210_tmu_control;
-		data->tmu_read = exynos4210_tmu_read;
-		data->tmu_clear_irqs = exynos4210_tmu_clear_irqs;
-		break;
-	case SOC_ARCH_EXYNOS3250:
-	case SOC_ARCH_EXYNOS4412:
-	case SOC_ARCH_EXYNOS5250:
-	case SOC_ARCH_EXYNOS5260:
-	case SOC_ARCH_EXYNOS5420:
-	case SOC_ARCH_EXYNOS5420_TRIMINFO:
-		data->tmu_initialize = exynos4412_tmu_initialize;
-		data->tmu_control = exynos4210_tmu_control;
-		data->tmu_read = exynos4412_tmu_read;
-		data->tmu_set_emulation = exynos4412_tmu_set_emulation;
-		data->tmu_clear_irqs = exynos4210_tmu_clear_irqs;
-		break;
-	case SOC_ARCH_EXYNOS5440:
-		data->tmu_initialize = exynos5440_tmu_initialize;
-		data->tmu_control = exynos5440_tmu_control;
-		data->tmu_read = exynos5440_tmu_read;
-		data->tmu_set_emulation = exynos5440_tmu_set_emulation;
-		data->tmu_clear_irqs = exynos5440_tmu_clear_irqs;
-		break;
-	default:
-		ret = -EINVAL;
-		dev_err(&pdev->dev, "Platform not supported\n");
-		goto err_clk;
-	}
-
 	ret = exynos_tmu_initialize(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to initialize TMU\n");
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 5ad3f3f..54f018d 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -49,12 +49,9 @@ enum soc_type {
  * EXYNOS TMU supported features.
  * TMU_SUPPORT_MULTI_INST - This features denotes that the soc
  *			has many instances of TMU.
- * TMU_SUPPORT_ADDRESS_MULTIPLE - This feature tells that the different TMU
- *			sensors shares some common registers.
  * TMU_SUPPORT - macro to compare the above features with the supplied.
  */
 #define TMU_SUPPORT_MULTI_INST			BIT(0)
-#define TMU_SUPPORT_ADDRESS_MULTIPLE		BIT(1)
 
 #define TMU_SUPPORTS(a, b)	(a->features & TMU_SUPPORT_ ## b)
 
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 4dd8d1c..13ac00b 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -275,8 +275,7 @@ struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
 
 #define EXYNOS5420_TMU_DATA_SHARED \
 	__EXYNOS5420_TMU_DATA \
-	.type = SOC_ARCH_EXYNOS5420_TRIMINFO, \
-	.features = TMU_SUPPORT_ADDRESS_MULTIPLE
+	.type = SOC_ARCH_EXYNOS5420_TRIMINFO
 
 struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
 	.tmu_data = {
@@ -310,7 +309,7 @@ struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
 	.second_point_trim = 70, \
 	.default_temp_offset = 25, \
 	.type = SOC_ARCH_EXYNOS5440, \
-	.features = (TMU_SUPPORT_MULTI_INST | TMU_SUPPORT_ADDRESS_MULTIPLE),
+	.features = TMU_SUPPORT_MULTI_INST,
 
 struct exynos_tmu_init_data const exynos5440_default_tmu_data = {
 	.tmu_data = {
-- 
1.8.2.3


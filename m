Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594AbaKMPG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:06:59 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:41160 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933261AbaKMPGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:06:55 -0500
X-AuditID: cbfee61a-f79c06d000004e71-0d-5464c90db236
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 28/33] thermal: exynos: remove TMU_SUPPORT_ADDRESS_MULTIPLE
 flag
Date: Thu, 13 Nov 2014 16:01:23 +0100
Message-id: <1415890888-8881-29-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQV3ekykhBtuO81g0XA2x2DhjPavF
	/CvXWC3ONr1ht3jzcDOjxeVdc9gsPvceYbSYcX4fk8WTh31sDpweO2fdZfdYvOclk0ffllWM
	Hp83yQWwRHHZpKTmZJalFunbJXBlTLplVPDMsGLu9IesDYzztLoYOTkkBEwk/qz/wAZhi0lc
	uLceyObiEBKYzihx/+xKFgini0nix7UL7CBVbAJWEhPbVzGC2CICWhInLm1nAiliFljGJHHp
	23wmkISwQKjEru2/wWwWAVWJmcfvsoDYvAIeEp1dm1kh1ilKdD+bALaaEyj+aupfsKFCAu4S
	1x69Y57AyLuAkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnB4PZPawbiyweIQowAHoxIP
	7wuWlBAh1sSy4srcQ4wSHMxKIrzeh4FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+0WgcKCaQn
	lqRmp6YWpBbBZJk4OKUaGGs2PvqzbXMm88xSlrD+gJ9ybp9izkzlkz5/eLPfutkPFWp63xxP
	y/ZYtytdUPXm03POYo3zPZNMpCYevRkRIrmqtt7+kkEsT9cJ84sFOZHzsmPO+mz/t95X5m7B
	TYWoc7eNxN9Hnv9RuMAi/M9lM71N08yLxJ7ETuC+svDSDo+oHq6pr/qP71ZiKc5INNRiLipO
	BADG3V8DKwIAAA==
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
index 51d8cc7..65eeecc 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -473,7 +473,6 @@ static void exynos5440_tmu_set_emulation(struct exynos_tmu_data *data,
 static int exynos_tmu_set_emulation(void *drv_data, unsigned long temp)
 {
 	struct exynos_tmu_data *data = drv_data;
-	struct exynos_tmu_platform_data *pdata = data->pdata;
 	int ret = -EINVAL;
 
 	if (data->soc == SOC_ARCH_EXYNOS4210)
@@ -696,12 +695,47 @@ static int exynos_map_dt_data(struct platform_device *pdev)
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
@@ -768,40 +802,6 @@ static int exynos_tmu_probe(struct platform_device *pdev)
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


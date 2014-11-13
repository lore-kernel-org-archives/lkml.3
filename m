Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572AbaKMPGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:06:50 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:50539 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933261AbaKMPGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:06:47 -0500
X-AuditID: cbfee61a-f79c06d000004e71-07-5464c90552ca
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 27/33] thermal: exynos: remove TMU_SUPPORT_EMULATION flag
Date: Thu, 13 Nov 2014 16:01:22 +0100
Message-id: <1415890888-8881-28-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t9jQV3WkykhBvf/SVo0XA2x2DhjPavF
	/CvXWC3ONr1ht3jzcDOjxeVdc9gsPvceYbSYcX4fk8WTh31sDpweO2fdZfdYvOclk0ffllWM
	Hp83yQWwRHHZpKTmZJalFunbJXBl/HmpULBAuWLNlfssDYxnZbsYOTkkBEwkdjXdYoSwxSQu
	3FvP1sXIxSEkMJ1R4vrJGcwQTheTxOnG3ewgVWwCVhIT21eBdYgIaEmcuLSdCaSIWWAZk8Sl
	b/OBHA4OYQEfib+tMiAmi4CqxPFZUSDlvAIeEnN2bWaDWKYo0f1sApjNCRR/NfUv2EghAXeJ
	a4/eMU9g5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzi0nkntYFzZYHGIUYCDUYmH
	9wVLSogQa2JZcWXuIUYJDmYlEV7vw0Ah3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOFBNIT
	S1KzU1MLUotgskwcnFINjNJfmvWifJYt+Sqz+Xp3gz2HjFR5blKOd5GymbDjjR0TWhRe9nJt
	4vsyW8jqD/ehW0JiO1uby+cs8TRwttnkOmnzkvvFArPni1x4f0HsikT+4s8Lp68+8V0n/xJH
	/YJ/X/1d0zcfer25n/vOxotHr9a93HX7g9kml08690uEL5a95syvDGk9/E+JpTgj0VCLuag4
	EQAZ7vixKQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace TMU_SUPPORT_EMULATION flag check in exynos_tmu_set_emulation()
by an explicit check for a SoC type (all SoC types except Exynos4210
have TMU_SUPPORT_EMULATION flag set in their struct exynos_tmu_init_data
instances).

There should be no functional changes caused by this patch.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      |  2 +-
 drivers/thermal/samsung/exynos_tmu.h      |  7 ++-----
 drivers/thermal/samsung/exynos_tmu_data.c | 17 ++++++-----------
 3 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 209221f..51d8cc7 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -476,7 +476,7 @@ static int exynos_tmu_set_emulation(void *drv_data, unsigned long temp)
 	struct exynos_tmu_platform_data *pdata = data->pdata;
 	int ret = -EINVAL;
 
-	if (!TMU_SUPPORTS(pdata, EMULATION))
+	if (data->soc == SOC_ARCH_EXYNOS4210)
 		goto out;
 
 	if (temp && temp < MCELSIUS)
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index d90852a..5ad3f3f 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -47,17 +47,14 @@ enum soc_type {
 
 /**
  * EXYNOS TMU supported features.
- * TMU_SUPPORT_EMULATION - This features is used to set user defined
- *			temperature to the TMU controller.
  * TMU_SUPPORT_MULTI_INST - This features denotes that the soc
  *			has many instances of TMU.
  * TMU_SUPPORT_ADDRESS_MULTIPLE - This feature tells that the different TMU
  *			sensors shares some common registers.
  * TMU_SUPPORT - macro to compare the above features with the supplied.
  */
-#define TMU_SUPPORT_EMULATION			BIT(0)
-#define TMU_SUPPORT_MULTI_INST			BIT(1)
-#define TMU_SUPPORT_ADDRESS_MULTIPLE		BIT(2)
+#define TMU_SUPPORT_MULTI_INST			BIT(0)
+#define TMU_SUPPORT_ADDRESS_MULTIPLE		BIT(1)
 
 #define TMU_SUPPORTS(a, b)	(a->features & TMU_SUPPORT_ ## b)
 
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 82f1cba..4dd8d1c 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -100,8 +100,7 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 		.freq_clip_max = 400 * 1000, \
 		.temp_level = 95, \
 	}, \
-	.freq_tab_count = 2, \
-	.features = TMU_SUPPORT_EMULATION
+	.freq_tab_count = 2
 #endif
 
 #if defined(CONFIG_SOC_EXYNOS3250)
@@ -152,8 +151,7 @@ struct exynos_tmu_init_data const exynos3250_default_tmu_data = {
 		.freq_clip_max = 400 * 1000, \
 		.temp_level = 95, \
 	}, \
-	.freq_tab_count = 2, \
-	.features = TMU_SUPPORT_EMULATION
+	.freq_tab_count = 2
 #endif
 
 #if defined(CONFIG_SOC_EXYNOS4412)
@@ -220,8 +218,7 @@ struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
 
 #define EXYNOS5260_TMU_DATA \
 	__EXYNOS5260_TMU_DATA \
-	.type = SOC_ARCH_EXYNOS5260, \
-	.features = TMU_SUPPORT_EMULATION
+	.type = SOC_ARCH_EXYNOS5260
 
 struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
 	.tmu_data = {
@@ -274,13 +271,12 @@ struct exynos_tmu_init_data const exynos5260_default_tmu_data = {
 
 #define EXYNOS5420_TMU_DATA \
 	__EXYNOS5420_TMU_DATA \
-	.type = SOC_ARCH_EXYNOS5420, \
-	.features = TMU_SUPPORT_EMULATION
+	.type = SOC_ARCH_EXYNOS5420
 
 #define EXYNOS5420_TMU_DATA_SHARED \
 	__EXYNOS5420_TMU_DATA \
 	.type = SOC_ARCH_EXYNOS5420_TRIMINFO, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_ADDRESS_MULTIPLE)
+	.features = TMU_SUPPORT_ADDRESS_MULTIPLE
 
 struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
 	.tmu_data = {
@@ -314,8 +310,7 @@ struct exynos_tmu_init_data const exynos5420_default_tmu_data = {
 	.second_point_trim = 70, \
 	.default_temp_offset = 25, \
 	.type = SOC_ARCH_EXYNOS5440, \
-	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_MULTI_INST | \
-			TMU_SUPPORT_ADDRESS_MULTIPLE),
+	.features = (TMU_SUPPORT_MULTI_INST | TMU_SUPPORT_ADDRESS_MULTIPLE),
 
 struct exynos_tmu_init_data const exynos5440_default_tmu_data = {
 	.tmu_data = {
-- 
1.8.2.3


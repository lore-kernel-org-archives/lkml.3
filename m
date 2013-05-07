Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab3EGNCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:02:55 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:49020 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605Ab3EGNCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:02:51 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V3 16/21] thermal: exynos: Add features to check instead of using SOC type
Date: Tue,  7 May 2013 18:31:06 +0530
Message-Id: <1367931671-3906-17-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com>
References: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds several features supported by TMU as bitfields.
This features varies across different SOC type and comparing
the features present in the TMU is more logical than comparing
the soc itself.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      |    6 +++---
 drivers/thermal/samsung/exynos_tmu.h      |   22 ++++++++++++++++++++++
 drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 94d6e8e..c1a8c5f 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -152,7 +152,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		goto out;
 	}
 
-	if (data->soc == SOC_ARCH_EXYNOS)
+	if (TMU_SUPPORTS(pdata, TRIM_RELOAD))
 		__raw_writel(1, data->base + reg->triminfo_ctrl);
 
 	/* Save trimming info in order to perform calibration */
@@ -261,7 +261,7 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 			pdata->trigger_enable[2] << reg->inten_rise2_shift |
 			pdata->trigger_enable[1] << reg->inten_rise1_shift |
 			pdata->trigger_enable[0] << reg->inten_rise0_shift;
-		if (pdata->threshold_falling)
+		if (TMU_SUPPORTS(pdata, FALLING_TRIP))
 			interrupt_en |=
 				interrupt_en << reg->inten_fall0_shift;
 	} else {
@@ -303,7 +303,7 @@ static int exynos_tmu_set_emulation(void *drv_data, unsigned long temp)
 	unsigned int val;
 	int ret = -EINVAL;
 
-	if (data->soc == SOC_ARCH_EXYNOS4210)
+	if (!TMU_SUPPORTS(pdata, EMULATION))
 		goto out;
 
 	if (temp && temp < MCELSIUS)
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 1e5e492..de1c342 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -46,6 +46,25 @@ enum soc_type {
 };
 
 /**
+ * EXYNOS TMU supported features.
+ * TMU_SUPPORT_EMULATION - This features is used to set user defined
+ *			temperature to the TMU controller.
+ * TMU_SUPPORT_MULTI_INST - This features denotes that the soc
+ *			has many instances of TMU.
+ * TMU_SUPPORT_TRIM_RELOAD - This features shows that trimming can
+ *			be reloaded.
+ * TMU_SUPPORT_FALLING_TRIP - This features shows that interrupt can
+ *			be registered for falling trips also.
+ * TMU_SUPPORT - macro to compare the above features with the supplied.
+ */
+#define TMU_SUPPORT_EMULATION			BIT(0)
+#define TMU_SUPPORT_MULTI_INST			BIT(1)
+#define TMU_SUPPORT_TRIM_RELOAD			BIT(2)
+#define TMU_SUPPORT_FALLING_TRIP		BIT(3)
+
+#define TMU_SUPPORTS(a, b)	(a->features & TMU_SUPPORT_ ## b)
+
+/**
  * struct exynos_tmu_register - register descriptors to access registers and
  * bitfields. The register validity, offsets and bitfield values may vary
  * slightly across different exynos SOC's.
@@ -166,6 +185,8 @@ struct exynos_tmu_registers {
  * @freq_clip_table: Table representing frequency reduction percentage.
  * @freq_tab_count: Count of the above table as frequency reduction may
  *	applicable to only some of the trigger levels.
+ * @features: a bitfield value indicating the features supported in SOC like
+ *	emulation, multi instance etc
  *
  * This structure is required for configuration of exynos_tmu driver.
  */
@@ -192,5 +213,6 @@ struct exynos_tmu_platform_data {
 	struct freq_clip_table freq_tab[4];
 	unsigned int freq_tab_count;
 	struct exynos_tmu_registers *registers;
+	unsigned int features;
 };
 #endif /* _LINUX_EXYNOS_THERMAL_H */
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 7322597..8a587d4 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -154,5 +154,7 @@ struct exynos_tmu_platform_data const exynos5250_default_tmu_data = {
 	.freq_tab_count = 2,
 	.type = SOC_ARCH_EXYNOS,
 	.registers = &exynos5250_tmu_registers,
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD |
+			TMU_SUPPORT_FALLING_TRIP),
 };
 #endif
-- 
1.7.1


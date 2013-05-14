Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab3ENKAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:00:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46918 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab3ENKAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:00:47 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V4 18/30] thermal: exynos: Add TMU features to check instead of using SOC type
Date: Tue, 14 May 2013 15:28:48 +0530
Message-Id: <1368525540-15034-19-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
References: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
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
 drivers/thermal/samsung/exynos_tmu.c      |   24 ++++++++++++++----------
 drivers/thermal/samsung/exynos_tmu.h      |   28 ++++++++++++++++++++++++++++
 drivers/thermal/samsung/exynos_tmu_data.c |    4 ++++
 3 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index a9c5d8b..de98312 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -142,13 +142,15 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	mutex_lock(&data->lock);
 	clk_enable(data->clk);
 
-	status = readb(data->base + reg->tmu_status);
-	if (!status) {
-		ret = -EBUSY;
-		goto out;
+	if (TMU_SUPPORTS(pdata, READY_STATUS)) {
+		status = readb(data->base + reg->tmu_status);
+		if (!status) {
+			ret = -EBUSY;
+			goto out;
+		}
 	}
 
-	if (data->soc == SOC_ARCH_EXYNOS)
+	if (TMU_SUPPORTS(pdata, TRIM_RELOAD))
 		__raw_writel(1, data->base + reg->triminfo_ctrl);
 
 	/* Save trimming info in order to perform calibration */
@@ -257,7 +259,7 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 			pdata->trigger_enable[2] << reg->inten_rise2_shift |
 			pdata->trigger_enable[1] << reg->inten_rise1_shift |
 			pdata->trigger_enable[0] << reg->inten_rise0_shift;
-		if (pdata->threshold_falling)
+		if (TMU_SUPPORTS(pdata, FALLING_TRIP))
 			interrupt_en |=
 				interrupt_en << reg->inten_fall0_shift;
 	} else {
@@ -299,7 +301,7 @@ static int exynos_tmu_set_emulation(void *drv_data, unsigned long temp)
 	unsigned int val;
 	int ret = -EINVAL;
 
-	if (data->soc == SOC_ARCH_EXYNOS4210)
+	if (!TMU_SUPPORTS(pdata, EMULATION))
 		goto out;
 
 	if (temp && temp < MCELSIUS)
@@ -313,9 +315,11 @@ static int exynos_tmu_set_emulation(void *drv_data, unsigned long temp)
 	if (temp) {
 		temp /= MCELSIUS;
 
-		val = (EXYNOS_EMUL_TIME << reg->emul_time_shift) |
-			(temp_to_code(data, temp)
-			 << reg->emul_temp_shift) | EXYNOS_EMUL_ENABLE;
+		if (TMU_SUPPORTS(pdata, EMUL_TIME))
+			val |= (EXYNOS_EMUL_TIME << reg->emul_time_shift);
+
+		val |= (temp_to_code(data, temp) << reg->emul_temp_shift) |
+			EXYNOS_EMUL_ENABLE;
 	} else {
 		val &= ~EXYNOS_EMUL_ENABLE;
 	}
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 5d80a32..65443d7 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -47,6 +47,31 @@ enum soc_type {
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
+ * TMU_SUPPORT_READY_STATUS - This feature tells that the TMU current
+ *			state(active/idle) can be checked.
+ * TMU_SUPPORT_EMUL_TIME - This features allows to set next temp emulation
+ *			sample time.
+ * TMU_SUPPORT - macro to compare the above features with the supplied.
+ */
+#define TMU_SUPPORT_EMULATION			BIT(0)
+#define TMU_SUPPORT_MULTI_INST			BIT(1)
+#define TMU_SUPPORT_TRIM_RELOAD			BIT(2)
+#define TMU_SUPPORT_FALLING_TRIP		BIT(3)
+#define TMU_SUPPORT_READY_STATUS		BIT(4)
+#define TMU_SUPPORT_EMUL_TIME			BIT(5)
+
+#define TMU_SUPPORTS(a, b)	(a->features & TMU_SUPPORT_ ## b)
+
+/**
  * struct exynos_tmu_register - register descriptors to access registers and
  * bitfields. The register validity, offsets and bitfield values may vary
  * slightly across different exynos SOC's.
@@ -224,6 +249,8 @@ struct exynos_tmu_registers {
  *	applicable to only some of the trigger levels.
  * @registers: Pointer to structure containing all the TMU controller registers
  *	and bitfields shifts and masks.
+ * @features: a bitfield value indicating the features supported in SOC like
+ *	emulation, multi instance etc
  *
  * This structure is required for configuration of exynos_tmu driver.
  */
@@ -250,5 +277,6 @@ struct exynos_tmu_platform_data {
 	struct freq_clip_table freq_tab[4];
 	unsigned int freq_tab_count;
 	const struct exynos_tmu_registers *registers;
+	unsigned int features;
 };
 #endif /* _EXYNOS_TMU_H */
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index bf01210..b4bfa61 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -79,6 +79,7 @@ struct exynos_tmu_platform_data const exynos4210_default_tmu_data = {
 	.freq_tab_count = 2,
 	.type = SOC_ARCH_EXYNOS4210,
 	.registers = &exynos4210_tmu_registers,
+	.features = TMU_SUPPORT_READY_STATUS,
 };
 #endif
 
@@ -154,5 +155,8 @@ struct exynos_tmu_platform_data const exynos5250_default_tmu_data = {
 	.freq_tab_count = 2,
 	.type = SOC_ARCH_EXYNOS,
 	.registers = &exynos5250_tmu_registers,
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD |
+			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS |
+			TMU_SUPPORT_EMUL_TIME),
 };
 #endif
-- 
1.7.1


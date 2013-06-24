Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab3FXK4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:56:11 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:52137 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab3FXKw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:52:29 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH V7 19/30] thermal: exynos: Add TMU features to check instead of using SOC type
Date: Mon, 24 Jun 2013 16:20:40 +0530
Message-Id: <1372071051-3167-20-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1372071051-3167-1-git-send-email-amit.daniel@samsung.com>
References: <1372071051-3167-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds several features supported by TMU as bitfields.
This features varies across different SOC type and comparing
the features present in the TMU is more logical than comparing
the soc itself.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      |   26 +++++++++++++++---------
 drivers/thermal/samsung/exynos_tmu.h      |   31 +++++++++++++++++++++++++++++
 drivers/thermal/samsung/exynos_tmu_data.c |    6 ++++-
 3 files changed, 52 insertions(+), 11 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 7f65fe0..05b95c6 100644
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
@@ -287,7 +289,7 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
 			pdata->trigger_enable[2] << reg->inten_rise2_shift |
 			pdata->trigger_enable[1] << reg->inten_rise1_shift |
 			pdata->trigger_enable[0] << reg->inten_rise0_shift;
-		if (pdata->threshold_falling)
+		if (TMU_SUPPORTS(pdata, FALLING_TRIP))
 			interrupt_en |=
 				interrupt_en << reg->inten_fall0_shift;
 	} else {
@@ -329,7 +331,7 @@ static int exynos_tmu_set_emulation(void *drv_data, unsigned long temp)
 	unsigned int val;
 	int ret = -EINVAL;
 
-	if (data->soc == SOC_ARCH_EXYNOS4210)
+	if (!TMU_SUPPORTS(pdata, EMULATION))
 		goto out;
 
 	if (temp && temp < MCELSIUS)
@@ -343,9 +345,13 @@ static int exynos_tmu_set_emulation(void *drv_data, unsigned long temp)
 	if (temp) {
 		temp /= MCELSIUS;
 
-		val = (EXYNOS_EMUL_TIME << reg->emul_time_shift) |
-			(temp_to_code(data, temp)
-			 << reg->emul_temp_shift) | EXYNOS_EMUL_ENABLE;
+		if (TMU_SUPPORTS(pdata, EMUL_TIME)) {
+			val &= ~(EXYNOS_EMUL_TIME_MASK << reg->emul_time_shift);
+			val |= (EXYNOS_EMUL_TIME << reg->emul_time_shift);
+		}
+		val &= ~(EXYNOS_EMUL_DATA_MASK << reg->emul_temp_shift);
+		val |= (temp_to_code(data, temp) << reg->emul_temp_shift) |
+			EXYNOS_EMUL_ENABLE;
 	} else {
 		val &= ~EXYNOS_EMUL_ENABLE;
 	}
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 53fa702..ff8844f 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -43,6 +43,34 @@ enum soc_type {
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
+ * TMU_SUPPORT_SHARED_MEMORY - This feature tells that the different TMU
+ *			sensors shares some common registers.
+ * TMU_SUPPORT - macro to compare the above features with the supplied.
+ */
+#define TMU_SUPPORT_EMULATION			BIT(0)
+#define TMU_SUPPORT_MULTI_INST			BIT(1)
+#define TMU_SUPPORT_TRIM_RELOAD			BIT(2)
+#define TMU_SUPPORT_FALLING_TRIP		BIT(3)
+#define TMU_SUPPORT_READY_STATUS		BIT(4)
+#define TMU_SUPPORT_EMUL_TIME			BIT(5)
+#define TMU_SUPPORT_SHARED_MEMORY		BIT(6)
+
+#define TMU_SUPPORTS(a, b)	(a->features & TMU_SUPPORT_ ## b)
+
+/**
  * struct exynos_tmu_register - register descriptors to access registers and
  * bitfields. The register validity, offsets and bitfield values may vary
  * slightly across different exynos SOC's.
@@ -222,6 +250,8 @@ struct exynos_tmu_registers {
  *	applicable to only some of the trigger levels.
  * @registers: Pointer to structure containing all the TMU controller registers
  *	and bitfields shifts and masks.
+ * @features: a bitfield value indicating the features supported in SOC like
+ *	emulation, multi instance etc
  *
  * This structure is required for configuration of exynos_tmu driver.
  */
@@ -249,6 +279,7 @@ struct exynos_tmu_platform_data {
 	struct freq_clip_table freq_tab[4];
 	unsigned int freq_tab_count;
 	const struct exynos_tmu_registers *registers;
+	unsigned int features;
 };
 
 /**
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index a5c25b4..2612b45 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -83,6 +83,7 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 		.freq_tab_count = 2,
 		.type = SOC_ARCH_EXYNOS4210,
 		.registers = &exynos4210_tmu_registers,
+		.features = TMU_SUPPORT_READY_STATUS,
 		},
 	},
 	.tmu_count = 1,
@@ -162,7 +163,10 @@ static const struct exynos_tmu_registers exynos5250_tmu_registers = {
 	}, \
 	.freq_tab_count = 2, \
 	.type = SOC_ARCH_EXYNOS, \
-	.registers = &exynos5250_tmu_registers,
+	.registers = &exynos5250_tmu_registers, \
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
+			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
+			TMU_SUPPORT_EMUL_TIME)
 
 struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
 	.tmu_data = {
-- 
1.7.1


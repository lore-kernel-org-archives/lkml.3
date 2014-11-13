Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565AbaKMPNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:13:13 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:61511 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbaKMPCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:02:34 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-9c-5464c80857f4
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 04/33] thermal: exynos: remove needless triminfo_ctrl
 abstraction
Date: Thu, 13 Nov 2014 16:00:59 +0100
Message-id: <1415890888-8881-5-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQV2OEykhBjdf81o0XA2x2DhjPavF
	/CvXWC3ONr1ht3jzcDOjxeVdc9gsPvceYbSYcX4fk8WTh31sDpweO2fdZfdYvOclk0ffllWM
	Hp83yQWwRHHZpKTmZJalFunbJXBlTLjVxl6w0rDi6LFJjA2MNzW7GDk5JARMJHpeTGSDsMUk
	LtxbD2YLCUxnlOi4ptPFyAVkdzFJnLi+gxUkwSZgJTGxfRUjiC0ioCVx4tJ2JpAiZoFlTBKX
	vs1nAkkIC4RJ/Lrczw5iswioSvRu+ArWwCvgLvFv8x5GiG2KEt3PJoBt4xTwkHg19S8jxGZ3
	iWuP3jFPYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4vJ5J72Bc1WBxiFGAg1GJ
	h/cFS0qIEGtiWXFl7iFGCQ5mJRFe78NAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHW60DhQTS
	E0tSs1NTC1KLYLJMHJxSDYxJG0T3pxi/khdhSzBgTeBcyjxp41H+Yxtb4wxPcP3P/ZQv1Bpd
	dD3nwpYpPq6hFW268w/rKrit38c2Xcdsa1ptVLtVTOQMt5dzgk2tildq8yz4H9d2trLYY23R
	MaOqkya5G20a/x1c+1b34OTQg8X7FA8FHdf0tw1kXPhkQ5SCXK3Epz27M5VYijMSDbWYi4oT
	Ad/A7iwrAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reg->triminfo_ctrl[] is used in only exynos_tmu_initialize() and
accessed only if TMU_SUPPORT_TRIM_RELOAD flag is set.  This flag
is set only on Exynos3250, Exynos4412 and Exynos5250 (other SoC
types don't even have triminfo_ctrl[] entries assigned in their
struct exynos_tmu_registers instances) so the register abstraction
is not needed and can be removed.

There should be no functional changes caused by this patch.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_thermal_common.h |  1 -
 drivers/thermal/samsung/exynos_tmu.c            | 15 +++++++--------
 drivers/thermal/samsung/exynos_tmu.h            |  7 -------
 drivers/thermal/samsung/exynos_tmu_data.c       |  8 --------
 4 files changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
index 158f5aa..cd44719 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.h
+++ b/drivers/thermal/samsung/exynos_thermal_common.h
@@ -27,7 +27,6 @@
 #define SENSOR_NAME_LEN	16
 #define MAX_TRIP_COUNT	8
 #define MAX_COOLING_DEVICE 4
-#define MAX_TRIMINFO_CTRL_REG	2
 
 #define ACTIVE_INTERVAL 500
 #define IDLE_INTERVAL 10000
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 12e6f16..160e7fa 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -162,15 +162,14 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	}
 
 	if (TMU_SUPPORTS(pdata, TRIM_RELOAD)) {
-		for (i = 0; i < reg->triminfo_ctrl_count; i++) {
-			if (pdata->triminfo_reload[i]) {
-				ctrl = readl(data->base +
-						reg->triminfo_ctrl[i]);
-				ctrl |= pdata->triminfo_reload[i];
-				writel(ctrl, data->base +
-						reg->triminfo_ctrl[i]);
-			}
+		if (data->soc == SOC_ARCH_EXYNOS3250) {
+			ctrl = readl(data->base + EXYNOS_TMU_TRIMINFO_CON1);
+			ctrl |= EXYNOS_TRIMINFO_RELOAD_ENABLE;
+			writel(ctrl, data->base + EXYNOS_TMU_TRIMINFO_CON1);
 		}
+		ctrl = readl(data->base + EXYNOS_TMU_TRIMINFO_CON2);
+		ctrl |= EXYNOS_TRIMINFO_RELOAD_ENABLE;
+		writel(ctrl, data->base + EXYNOS_TMU_TRIMINFO_CON2);
 	}
 
 	/* Save trimming info in order to perform calibration */
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index d693215..cee81a1 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -76,8 +76,6 @@ enum soc_type {
  * struct exynos_tmu_register - register descriptors to access registers and
  * bitfields. The register validity, offsets and bitfield values may vary
  * slightly across different exynos SOC's.
- * @triminfo_ctrl: trim info controller register.
- * @triminfo_ctrl_count: the number of trim info controller register.
  * @tmu_ctrl: TMU main controller register.
  * @test_mux_addr_shift: shift bits of test mux address.
  * @therm_trip_mode_shift: shift bits of tripping mode in tmu_ctrl register.
@@ -104,9 +102,6 @@ enum soc_type {
  * @tmu_pmin: register to get/set the Pmin value.
  */
 struct exynos_tmu_registers {
-	u32	triminfo_ctrl[MAX_TRIMINFO_CTRL_REG];
-	u32	triminfo_ctrl_count;
-
 	u32	tmu_ctrl;
 	u32     test_mux_addr_shift;
 	u32	therm_trip_mode_shift;
@@ -184,7 +179,6 @@ struct exynos_tmu_registers {
  * @second_point_trim: temp value of the second point trimming
  * @default_temp_offset: default temperature offset in case of no trimming
  * @test_mux; information if SoC supports test MUX
- * @triminfo_reload: reload value to read TRIMINFO register
  * @cal_type: calibration type for temperature
  * @freq_clip_table: Table representing frequency reduction percentage.
  * @freq_tab_count: Count of the above table as frequency reduction may
@@ -215,7 +209,6 @@ struct exynos_tmu_platform_data {
 	u8 second_point_trim;
 	u8 default_temp_offset;
 	u8 test_mux;
-	u8 triminfo_reload[MAX_TRIMINFO_CTRL_REG];
 
 	enum calibration_type cal_type;
 	enum soc_type type;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 8153c41..d4b9a68 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -82,9 +82,6 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 
 #if defined(CONFIG_SOC_EXYNOS3250)
 static const struct exynos_tmu_registers exynos3250_tmu_registers = {
-	.triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON1,
-	.triminfo_ctrl[1] = EXYNOS_TMU_TRIMINFO_CON2,
-	.triminfo_ctrl_count = 2,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
@@ -140,8 +137,6 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 		.temp_level = 95, \
 	}, \
 	.freq_tab_count = 2, \
-	.triminfo_reload[0] = EXYNOS_TRIMINFO_RELOAD_ENABLE, \
-	.triminfo_reload[1] = EXYNOS_TRIMINFO_RELOAD_ENABLE, \
 	.registers = &exynos3250_tmu_registers, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
 			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
@@ -163,8 +158,6 @@ struct exynos_tmu_init_data const exynos3250_default_tmu_data = {
 
 #if defined(CONFIG_SOC_EXYNOS4412) || defined(CONFIG_SOC_EXYNOS5250)
 static const struct exynos_tmu_registers exynos4412_tmu_registers = {
-	.triminfo_ctrl[0] = EXYNOS_TMU_TRIMINFO_CON2,
-	.triminfo_ctrl_count = 1,
 	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
 	.test_mux_addr_shift = EXYNOS4412_MUX_ADDR_SHIFT,
 	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
@@ -221,7 +214,6 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 		.temp_level = 95, \
 	}, \
 	.freq_tab_count = 2, \
-	.triminfo_reload[0] = EXYNOS_TRIMINFO_RELOAD_ENABLE, \
 	.registers = &exynos4412_tmu_registers, \
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
 			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
-- 
1.8.2.3


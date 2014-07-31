Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaGaRMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:12:45 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40411 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbaGaRLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:11:50 -0400
X-AuditID: cbfee61a-f79e46d00000134f-46-53da78d47798
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v3 6/8] thermal: exynos: cache non_hw_trigger_levels in pdata
Date: Thu, 31 Jul 2014 19:11:04 +0200
Message-id: <1406826667-2289-7-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1406826667-2289-1-git-send-email-b.zolnierkie@samsung.com>
References: <1406826667-2289-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t9jAd0rFbeCDZqv61k0XA2x2DhjPavF
	mv0/mSzONr1ht7i8aw6bxefeI4wWM87vY7I4c/oSq8WTh31sFutnvGZx4PJYvOclk8eWq+0s
	Hn1bVjF6HL+xncnj8ya5ANYoLpuU1JzMstQifbsEroxl5y4xFtzSqtjaP421gXGOchcjJ4eE
	gIlEV/cORghbTOLCvfVsXYxcHEICixgltn18BOV0MUmsf7KWCaSKTcBKYmL7KrAOEQE9iRsv
	njCBFDELHGeS+Pn7PBtIQljAV6L36xOwIhYBVYmmx9vZQWxeAXeJ5pWr2CHWKUp0P5sAVs8p
	4CFxoH0GmC0EVPN300nWCYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEB90zqR2M
	KxssDjEKcDAq8fDOCL8VLMSaWFZcmXuIUYKDWUmE16UcKMSbklhZlVqUH19UmpNafIhRmoNF
	SZz3QKt1oJBAemJJanZqakFqEUyWiYNTqoFxcb6gf8WvGbKLLIsXftrRIm6RYLh64QIpD8Ok
	gKo53/sqtUN6TJ1DpDZxCczZlWyZsO8Hzz6xk4/eaSW/kX7CyrktOmThfUetz25qB9wXP/Vj
	9mOt01IQWxqrw6H0t2uR9Bf3zb8mPFdQvVraEGhtvWFj30PVtunf8yZwyZyZJaq83FjbtEmJ
	pTgj0VCLuag4EQAFTDrsNgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cache number of non-hardware trigger levels in a new pdata field
(non_hw_trigger_levels) and convert code in exynos_tmu_initialize()
accordingly.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 16 +++-------------
 drivers/thermal/samsung/exynos_tmu.h      |  2 ++
 drivers/thermal/samsung/exynos_tmu_data.c |  6 ++++++
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index aa4d4fd..6bc8a20 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -129,7 +129,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	const struct exynos_tmu_registers *reg = pdata->registers;
 	unsigned int status, trim_info = 0, con;
 	unsigned int rising_threshold = 0, falling_threshold = 0;
-	int ret = 0, threshold_code, i, trigger_levs = 0;
+	int ret = 0, threshold_code, i;
 
 	mutex_lock(&data->lock);
 	clk_enable(data->clk);
@@ -187,15 +187,6 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 			(pdata->efuse_value >> reg->triminfo_85_shift) &
 			EXYNOS_TMU_TEMP_MASK;
 
-	for (i = 0; i < pdata->max_trigger_level; i++) {
-		if (!pdata->trigger_levels[i])
-			continue;
-
-		/* Count trigger levels except the HW trip*/
-		if (!(pdata->trigger_type[i] == HW_TRIP))
-			trigger_levs++;
-	}
-
 	rising_threshold = readl(data->base + reg->threshold_th0);
 
 	if (data->soc == SOC_ARCH_EXYNOS4210) {
@@ -203,15 +194,14 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		threshold_code = temp_to_code(data, pdata->threshold);
 		writeb(threshold_code,
 			data->base + reg->threshold_temp);
-		for (i = 0; i < trigger_levs; i++)
+		for (i = 0; i < pdata->non_hw_trigger_levels; i++)
 			writeb(pdata->trigger_levels[i], data->base +
 			reg->threshold_th0 + i * sizeof(reg->threshold_th0));
 
 		writel(reg->intclr_rise_mask, data->base + reg->tmu_intclear);
 	} else {
 		/* Write temperature code for rising and falling threshold */
-		for (i = 0;
-		i < trigger_levs && i < EXYNOS_MAX_TRIGGER_PER_REG; i++) {
+		for (i = 0; i < pdata->non_hw_trigger_levels; i++) {
 			threshold_code = temp_to_code(data,
 						pdata->trigger_levels[i]);
 			rising_threshold &= ~(0xff << 8 * i);
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 789a8f7..5514d68 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -199,6 +199,7 @@ struct exynos_tmu_registers {
  *	1 = enable trigger_level[] interrupt,
  *	0 = disable trigger_level[] interrupt
  * @max_trigger_level: max trigger level supported by the TMU
+ * @non_hw_trigger_levels: number of defined non-hardware trigger levels
  * @gain: gain of amplifier in the positive-TC generator block
  *	0 <= gain <= 15
  * @reference_voltage: reference voltage of amplifier
@@ -232,6 +233,7 @@ struct exynos_tmu_platform_data {
 	enum trigger_type trigger_type[MAX_TRIP_COUNT];
 	bool trigger_enable[MAX_TRIP_COUNT];
 	u8 max_trigger_level;
+	u8 non_hw_trigger_levels;
 	u8 gain;
 	u8 reference_voltage;
 	u8 noise_cancel_mode;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 1d05bf8..9c81515 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -64,6 +64,7 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 		.trigger_type[1] = THROTTLE_ACTIVE,
 		.trigger_type[2] = SW_TRIP,
 		.max_trigger_level = 4,
+		.non_hw_trigger_levels = 3,
 		.gain = 15,
 		.reference_voltage = 7,
 		.cal_type = TYPE_ONE_POINT_TRIMMING,
@@ -140,6 +141,7 @@ static const struct exynos_tmu_registers exynos3250_tmu_registers = {
 	.trigger_type[2] = SW_TRIP, \
 	.trigger_type[3] = HW_TRIP, \
 	.max_trigger_level = 4, \
+	.non_hw_trigger_levels = 3, \
 	.gain = 8, \
 	.reference_voltage = 16, \
 	.noise_cancel_mode = 4, \
@@ -230,6 +232,7 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.trigger_type[2] = SW_TRIP, \
 	.trigger_type[3] = HW_TRIP, \
 	.max_trigger_level = 4, \
+	.non_hw_trigger_levels = 3, \
 	.gain = 8, \
 	.reference_voltage = 16, \
 	.noise_cancel_mode = 4, \
@@ -331,6 +334,7 @@ static const struct exynos_tmu_registers exynos5260_tmu_registers = {
 	.trigger_type[2] = SW_TRIP, \
 	.trigger_type[3] = HW_TRIP, \
 	.max_trigger_level = 4, \
+	.non_hw_trigger_levels = 3, \
 	.gain = 8, \
 	.reference_voltage = 16, \
 	.noise_cancel_mode = 4, \
@@ -422,6 +426,7 @@ static const struct exynos_tmu_registers exynos5420_tmu_registers = {
 	.trigger_type[2] = SW_TRIP, \
 	.trigger_type[3] = HW_TRIP, \
 	.max_trigger_level = 4, \
+	.non_hw_trigger_levels = 3, \
 	.gain = 8, \
 	.reference_voltage = 16, \
 	.noise_cancel_mode = 4, \
@@ -514,6 +519,7 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.trigger_type[0] = SW_TRIP, \
 	.trigger_type[4] = HW_TRIP, \
 	.max_trigger_level = 5, \
+	.non_hw_trigger_levels = 1, \
 	.gain = 5, \
 	.reference_voltage = 16, \
 	.noise_cancel_mode = 4, \
-- 
1.8.2.3


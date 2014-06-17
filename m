Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965020AbaFQRa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:30:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25848 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964772AbaFQRax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:30:53 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-28-53a07b4b317d
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 7/9] thermal: exynos: cache non_hw_trigger_levels in pdata
Date: Tue, 17 Jun 2014 19:27:23 +0200
Message-id: <1403026045-16024-8-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
References: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrILMWRmVeSWpSXmKPExsVy+t9jQV3v6gXBBu09fBYNV0MsNs5Yz2qx
	Zv9PJouzTW/YLS7vmsNm8bn3CKPFjPP7mCzOnL7EavHkYR+bxfoZr1kcuDwW73nJ5LHlajuL
	R9+WVYwex29sZ/L4vEkugDWKyyYlNSezLLVI3y6BK6OpaTNTwTGNij+NJQ2MBxS7GDk5JARM
	JA537WOBsMUkLtxbz9bFyMUhJDCdUeLkukssEE4Xk8SSbUuYQarYBKwkJravYgSxRQT0JG68
	eMIEUsQscJxJ4ufv80DtHBzCAr4Si/sMQWpYBFQlljW/AOvlFfCQ+L16CjPENkWJ7mcT2EBs
	TgFPiRv3WsBsIaCa+Rc7mSYw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERxwz6R2
	MK5ssDjEKMDBqMTDy5G7IFiINbGsuDL3EKMEB7OSCO+5LKAQb0piZVVqUX58UWlOavEhRmkO
	FiVx3gOt1oFCAumJJanZqakFqUUwWSYOTqkGxqArVyfMY3mpNYnT47hshcnxkwmHjDIEkleI
	/M/ov23zyMjqYozq5lVbWL4905AulHn320DI+ObqlPVb4pe9a3nCnnA0PdyHhSVsf+fhI09N
	brncEVwo0ckt/nvF5Mrtwm7fr6046yvKVS3u8prr2N7ZWXksUbM0XL2945aLRh7c1f1cd/nK
	2UosxRmJhlrMRcWJAPArgGE0AgAA
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
 drivers/thermal/samsung/exynos_tmu_data.c |  5 +++++
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 34ac081..9455b23 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -91,7 +91,7 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	const struct exynos_tmu_registers *reg = pdata->registers;
 	unsigned int status, trim_info = 0, con;
 	unsigned int rising_threshold = 0, falling_threshold = 0;
-	int ret = 0, threshold_code, i, trigger_levs = 0;
+	int ret = 0, threshold_code, i;
 
 	mutex_lock(&data->lock);
 	clk_enable(data->clk);
@@ -142,15 +142,6 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 	    data->temp_error > pdata->max_efuse_value)
 		data->temp_error = pdata->efuse_value & EXYNOS_TMU_TEMP_MASK;
 
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
@@ -158,15 +149,14 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
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
index 60ecc61..b1c9f8d 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -186,6 +186,7 @@ struct exynos_tmu_registers {
  *	1 = enable trigger_level[] interrupt,
  *	0 = disable trigger_level[] interrupt
  * @max_trigger_level: max trigger level supported by the TMU
+ * @non_hw_trigger_levels: number of defined non-hardware trigger levels
  * @gain: gain of amplifier in the positive-TC generator block
  *	0 <= gain <= 15
  * @reference_voltage: reference voltage of amplifier
@@ -216,6 +217,7 @@ struct exynos_tmu_platform_data {
 	enum trigger_type trigger_type[MAX_TRIP_COUNT];
 	bool trigger_enable[MAX_TRIP_COUNT];
 	u8 max_trigger_level;
+	u8 non_hw_trigger_levels;
 	u8 gain;
 	u8 reference_voltage;
 	u8 noise_cancel_mode;
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 7a9cee5..4bc6b06 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -62,6 +62,7 @@ struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
 		.trigger_type[1] = THROTTLE_ACTIVE,
 		.trigger_type[2] = SW_TRIP,
 		.max_trigger_level = 4,
+		.non_hw_trigger_levels = 3,
 		.gain = 15,
 		.reference_voltage = 7,
 		.min_efuse_value = 40,
@@ -135,6 +136,7 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.trigger_type[2] = SW_TRIP, \
 	.trigger_type[3] = HW_TRIP, \
 	.max_trigger_level = 4, \
+	.non_hw_trigger_levels = 3, \
 	.gain = 8, \
 	.reference_voltage = 16, \
 	.noise_cancel_mode = 4, \
@@ -231,6 +233,7 @@ static const struct exynos_tmu_registers exynos5260_tmu_registers = {
 	.trigger_type[2] = SW_TRIP, \
 	.trigger_type[3] = HW_TRIP, \
 	.max_trigger_level = 4, \
+	.non_hw_trigger_levels = 3, \
 	.gain = 8, \
 	.reference_voltage = 16, \
 	.noise_cancel_mode = 4, \
@@ -317,6 +320,7 @@ static const struct exynos_tmu_registers exynos5420_tmu_registers = {
 	.trigger_type[2] = SW_TRIP, \
 	.trigger_type[3] = HW_TRIP, \
 	.max_trigger_level = 4, \
+	.non_hw_trigger_levels = 3, \
 	.gain = 8, \
 	.reference_voltage = 16, \
 	.noise_cancel_mode = 4, \
@@ -404,6 +408,7 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.trigger_type[0] = SW_TRIP, \
 	.trigger_type[4] = HW_TRIP, \
 	.max_trigger_level = 5, \
+	.non_hw_trigger_levels = 1, \
 	.gain = 5, \
 	.reference_voltage = 16, \
 	.noise_cancel_mode = 4, \
-- 
1.8.2.3


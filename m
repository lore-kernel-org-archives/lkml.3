Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761230AbaCURde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 13:33:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31755 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760899AbaCURcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 13:32:07 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-88-532c779628f8
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: cw00.choi@samsung.com, myungjoo.ham@samsung.com
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 1/4] devfreq: exynos4: use common PPMU code
Date: Fri, 21 Mar 2014 18:31:43 +0100
Message-id: <1395423106-30458-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1395423106-30458-1-git-send-email-b.zolnierkie@samsung.com>
References: <1395423106-30458-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t9jQd1p5TrBBov+sltsnLGe1eL6l+es
	Fmeb3rBbXN41h83ic+8RRosZ5/cxWdxuXMFm8XjFW3aL9TNeszhweize85LJo2/LKkaPz5vk
	ApijuGxSUnMyy1KL9O0SuDKufqst+OtS8aCviaWB8YR5FyMnh4SAicSDHyuZIWwxiQv31rN1
	MXJxCAlMZ5TY1jGXFcLpYpJYsbgNrIpNwEpiYvsqRhBbRMBY4tbjW2BFzALHGCXeTXjJCpIQ
	FrCWaH64hR3EZhFQlbjzdj8TiM0r4CFxctNsdoh1ihLdzyawgdicAp4Si7q6wIYKAdU8eT6F
	dQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwWH1TGoH48oGi0OMAhyMSjy8FZza
	wUKsiWXFlbmHGCU4mJVEeJtjdYKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4UEkhPLEnN
	Tk0tSC2CyTJxcEo1MGb+YdntxvdA8o9z2VO/Vpv2n0uaGl78mqrZ/enfjTPh1xYWK/hcNP9T
	sEe5bNpHyf9b1YXNbL2Mj1z60mW/iePWo07HP0syLt9avORWrJB64jTl8jXrGNLemHe5z7t+
	9vUKx+xyw0izasO16i4v0ifbqr7dUeh40SL73dzqWtUsre65PZ5Si5RYijMSDbWYi4oTAUcY
	Tv8nAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chanwoo Choi <cw00.choi@samsung.com>

This patch converts exynos4_bus driver to use common PPMU code
(exynos_ppmu.c) instead of individual functions related to PPC
because PPMU is integrated module with both PPC and Bus event
generator.  When using PPMU to get bus performance read/write
event exynos4_bus driver deson't need to consider memory type.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
[bzolnier: splitted out changes from the bigger patch]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/devfreq/exynos/Makefile      |   2 +-
 drivers/devfreq/exynos/exynos4_bus.c | 164 +++++++++++++----------------------
 2 files changed, 62 insertions(+), 104 deletions(-)

diff --git a/drivers/devfreq/exynos/Makefile b/drivers/devfreq/exynos/Makefile
index bfaaf5b..49bc917 100644
--- a/drivers/devfreq/exynos/Makefile
+++ b/drivers/devfreq/exynos/Makefile
@@ -1,3 +1,3 @@
 # Exynos DEVFREQ Drivers
-obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+= exynos4_bus.o
+obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+= exynos_ppmu.o exynos4_bus.o
 obj-$(CONFIG_ARM_EXYNOS5_BUS_DEVFREQ)	+= exynos_ppmu.o exynos5_bus.o
diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index 5a48d16..228c658 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -25,15 +25,16 @@
 #include <linux/regulator/consumer.h>
 #include <linux/module.h>
 
+#include <mach/map.h>
+
+#include "exynos_ppmu.h"
+#include "exynos4_bus.h"
+
 /* Exynos4 ASV has been in the mailing list, but not upstreamed, yet. */
 #ifdef CONFIG_EXYNOS_ASV
 extern unsigned int exynos_result_of_asv;
 #endif
 
-#include <mach/map.h>
-
-#include "exynos4_bus.h"
-
 #define MAX_SAFEVOLT	1200000 /* 1.2V */
 
 enum exynos4_busf_type {
@@ -44,22 +45,6 @@ enum exynos4_busf_type {
 /* Assume that the bus is saturated if the utilization is 40% */
 #define BUS_SATURATION_RATIO	40
 
-enum ppmu_counter {
-	PPMU_PMNCNT0 = 0,
-	PPMU_PMCCNT1,
-	PPMU_PMNCNT2,
-	PPMU_PMNCNT3,
-	PPMU_PMNCNT_MAX,
-};
-struct exynos4_ppmu {
-	void __iomem *hw_base;
-	unsigned int ccnt;
-	unsigned int event;
-	unsigned int count[PPMU_PMNCNT_MAX];
-	bool ccnt_overflow;
-	bool count_overflow[PPMU_PMNCNT_MAX];
-};
-
 enum busclk_level_idx {
 	LV_0 = 0,
 	LV_1,
@@ -68,6 +53,13 @@ enum busclk_level_idx {
 	LV_4,
 	_LV_END
 };
+
+enum exynos_ppmu_idx {
+	PPMU_DMC0,
+	PPMU_DMC1,
+	PPMU_END,
+};
+
 #define EX4210_LV_MAX	LV_2
 #define EX4x12_LV_MAX	LV_4
 #define EX4210_LV_NUM	(LV_2 + 1)
@@ -91,7 +83,7 @@ struct busfreq_data {
 	struct regulator *vdd_int;
 	struct regulator *vdd_mif; /* Exynos4412/4212 only */
 	struct busfreq_opp_info curr_oppinfo;
-	struct exynos4_ppmu dmc[2];
+	struct exynos_ppmu ppmu[PPMU_END];
 
 	struct notifier_block pm_notifier;
 	struct mutex lock;
@@ -101,12 +93,6 @@ struct busfreq_data {
 	unsigned int top_divtable[_LV_END];
 };
 
-struct bus_opp_table {
-	unsigned int idx;
-	unsigned long clk;
-	unsigned long volt;
-};
-
 /* 4210 controls clock of mif and voltage of int */
 static struct bus_opp_table exynos4210_busclk_table[] = {
 	{LV_0, 400000, 1150000},
@@ -524,27 +510,22 @@ static int exynos4x12_set_busclk(struct busfreq_data *data,
 	return 0;
 }
 
-
 static void busfreq_mon_reset(struct busfreq_data *data)
 {
 	unsigned int i;
 
-	for (i = 0; i < 2; i++) {
-		void __iomem *ppmu_base = data->dmc[i].hw_base;
+	for (i = 0; i < PPMU_END; i++) {
+		void __iomem *ppmu_base = data->ppmu[i].hw_base;
 
-		/* Reset PPMU */
-		__raw_writel(0x8000000f, ppmu_base + 0xf010);
-		__raw_writel(0x8000000f, ppmu_base + 0xf050);
-		__raw_writel(0x6, ppmu_base + 0xf000);
-		__raw_writel(0x0, ppmu_base + 0xf100);
+		/* Reset the performance and cycle counters */
+		exynos_ppmu_reset(ppmu_base);
 
-		/* Set PPMU Event */
-		data->dmc[i].event = 0x6;
-		__raw_writel(((data->dmc[i].event << 12) | 0x1),
-			     ppmu_base + 0xfc);
+		/* Setup count registers to monitor read/write transactions */
+		data->ppmu[i].event[PPMU_PMNCNT3] = RDWR_DATA_COUNT;
+		exynos_ppmu_setevent(ppmu_base, PPMU_PMNCNT3,
+					data->ppmu[i].event[PPMU_PMNCNT3]);
 
-		/* Start PPMU */
-		__raw_writel(0x1, ppmu_base + 0xf000);
+		exynos_ppmu_start(ppmu_base);
 	}
 }
 
@@ -552,23 +533,20 @@ static void exynos4_read_ppmu(struct busfreq_data *data)
 {
 	int i, j;
 
-	for (i = 0; i < 2; i++) {
-		void __iomem *ppmu_base = data->dmc[i].hw_base;
-		u32 overflow;
+	for (i = 0; i < PPMU_END; i++) {
+		void __iomem *ppmu_base = data->ppmu[i].hw_base;
 
-		/* Stop PPMU */
-		__raw_writel(0x0, ppmu_base + 0xf000);
+		exynos_ppmu_stop(ppmu_base);
 
 		/* Update local data from PPMU */
-		overflow = __raw_readl(ppmu_base + 0xf050);
-
-		data->dmc[i].ccnt = __raw_readl(ppmu_base + 0xf100);
-		data->dmc[i].ccnt_overflow = overflow & (1 << 31);
-
-		for (j = 0; j < PPMU_PMNCNT_MAX; j++) {
-			data->dmc[i].count[j] = __raw_readl(
-					ppmu_base + (0xf110 + (0x10 * j)));
-			data->dmc[i].count_overflow[j] = overflow & (1 << j);
+		data->ppmu[i].ccnt = __raw_readl(ppmu_base + PPMU_CCNT);
+
+		for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++) {
+			if (data->ppmu[i].event[j] == 0)
+				data->ppmu[i].count[j] = 0;
+			else
+				data->ppmu[i].count[j] =
+					exynos_ppmu_read(ppmu_base, j);
 		}
 	}
 
@@ -698,66 +676,42 @@ out:
 	return err;
 }
 
-static int exynos4_get_busier_dmc(struct busfreq_data *data)
+static int exynos4_get_busier_ppmu(struct busfreq_data *data)
 {
-	u64 p0 = data->dmc[0].count[0];
-	u64 p1 = data->dmc[1].count[0];
-
-	p0 *= data->dmc[1].ccnt;
-	p1 *= data->dmc[0].ccnt;
-
-	if (data->dmc[1].ccnt == 0)
-		return 0;
+	int i, j;
+	int busy = 0;
+	unsigned int temp = 0;
+
+	for (i = 0; i < PPMU_END; i++) {
+		for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++) {
+			if (data->ppmu[i].count[j] > temp) {
+				temp = data->ppmu[i].count[j];
+				busy = i;
+			}
+		}
+	}
 
-	if (p0 > p1)
-		return 0;
-	return 1;
+	return busy;
 }
 
 static int exynos4_bus_get_dev_status(struct device *dev,
 				      struct devfreq_dev_status *stat)
 {
 	struct busfreq_data *data = dev_get_drvdata(dev);
-	int busier_dmc;
-	int cycles_x2 = 2; /* 2 x cycles */
-	void __iomem *addr;
-	u32 timing;
-	u32 memctrl;
+	int busier;
 
 	exynos4_read_ppmu(data);
-	busier_dmc = exynos4_get_busier_dmc(data);
+	busier = exynos4_get_busier_ppmu(data);
 	stat->current_frequency = data->curr_oppinfo.rate;
 
-	if (busier_dmc)
-		addr = S5P_VA_DMC1;
-	else
-		addr = S5P_VA_DMC0;
-
-	memctrl = __raw_readl(addr + 0x04); /* one of DDR2/3/LPDDR2 */
-	timing = __raw_readl(addr + 0x38); /* CL or WL/RL values */
-
-	switch ((memctrl >> 8) & 0xf) {
-	case 0x4: /* DDR2 */
-		cycles_x2 = ((timing >> 16) & 0xf) * 2;
-		break;
-	case 0x5: /* LPDDR2 */
-	case 0x6: /* DDR3 */
-		cycles_x2 = ((timing >> 8) & 0xf) + ((timing >> 0) & 0xf);
-		break;
-	default:
-		pr_err("%s: Unknown Memory Type(%d).\n", __func__,
-		       (memctrl >> 8) & 0xf);
-		return -EINVAL;
-	}
-
 	/* Number of cycles spent on memory access */
-	stat->busy_time = data->dmc[busier_dmc].count[0] / 2 * (cycles_x2 + 2);
+	stat->busy_time = data->ppmu[busier].count[PPMU_PMNCNT3];
 	stat->busy_time *= 100 / BUS_SATURATION_RATIO;
-	stat->total_time = data->dmc[busier_dmc].ccnt;
+	stat->total_time = data->ppmu[busier].ccnt;
 
 	/* If the counters have overflown, retry */
-	if (data->dmc[busier_dmc].ccnt_overflow ||
-	    data->dmc[busier_dmc].count_overflow[0])
+	if (data->ppmu[busier].ccnt_overflow ||
+	    data->ppmu[busier].count_overflow[0])
 		return -EAGAIN;
 
 	return 0;
@@ -1023,8 +977,8 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 	}
 
 	data->type = pdev->id_entry->driver_data;
-	data->dmc[0].hw_base = S5P_VA_DMC0;
-	data->dmc[1].hw_base = S5P_VA_DMC1;
+	data->ppmu[PPMU_DMC0].hw_base = S5P_VA_DMC0;
+	data->ppmu[PPMU_DMC1].hw_base = S5P_VA_DMC1;
 	data->pm_notifier.notifier_call = exynos4_busfreq_pm_notifier_event;
 	data->dev = dev;
 	mutex_init(&data->lock);
@@ -1074,13 +1028,17 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, data);
 
-	busfreq_mon_reset(data);
-
 	data->devfreq = devfreq_add_device(dev, &exynos4_devfreq_profile,
 					   "simple_ondemand", NULL);
 	if (IS_ERR(data->devfreq))
 		return PTR_ERR(data->devfreq);
 
+	/*
+	 * Start PPMU (Performance Profiling Monitoring Unit) to check
+	 * utilization of each IP in the Exynos4 SoC.
+	 */
+	busfreq_mon_reset(data);
+
 	/* Register opp_notifier for Exynos4 busfreq */
 	err = devfreq_register_opp_notifier(dev, data->devfreq);
 	if (err < 0) {
-- 
1.8.2.3


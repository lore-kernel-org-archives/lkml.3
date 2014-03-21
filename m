Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761114AbaCURcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 13:32:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18617 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760986AbaCURcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 13:32:12 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-12-532c77998be8
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: cw00.choi@samsung.com, myungjoo.ham@samsung.com
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 2/4] devfreq: exynos4: introduce struct busfreq_ppmu_data
Date: Fri, 21 Mar 2014 18:31:44 +0100
Message-id: <1395423106-30458-3-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1395423106-30458-1-git-send-email-b.zolnierkie@samsung.com>
References: <1395423106-30458-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t9jQd2Z5TrBBq27DC02zljPanH9y3NW
	i7NNb9gtLu+aw2bxufcIo8WM8/uYLG43rmCzeLziLbvF+hmvWRw4PRbvecnk0bdlFaPH501y
	AcxRXDYpqTmZZalF+nYJXBlz7jxkK7hiVPF2xw+mBsYtml2MnBwSAiYSV69/YYWwxSQu3FvP
	1sXIxSEkMJ1RovfuDGYIp4tJ4tGlm0wgVWwCVhIT21cxgtgiAsYStx7fYgUpYhY4xijxbsJL
	sFHCAp4S359uBitiEVCVaNn1gL2LkYODV8BD4ukvG4htihLdzyawgdicQOWLurrAyoWASp48
	n8I6gZF3ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgsHomvYNxVYPFIUYBDkYlHt4K
	Tu1gIdbEsuLK3EOMEhzMSiK8zbE6wUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJpCeW
	pGanphakFsFkmTg4pRoY+9alTs5cMTvVUH+mPv+Sox7P8ySP+1jLz/j+YSZDjM1u67AV8xy2
	y3wW/dvDIRK8L6nQr+7GAqe19689/x565HHu3KO6ShM/bswIu9UhsvfX+jQf48vSducCctTq
	2jUFjx5xUC0yf/DpaJ6Z8hGv2M4tkpl+oip6Ruvtrvtc2dr28fuBPqlpSizFGYmGWsxFxYkA
	gyYImCcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation for making more PPMU code common for
EXYNOS devfreq drivers.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/devfreq/exynos/exynos4_bus.c | 74 ++++++++++++++++++++++--------------
 1 file changed, 46 insertions(+), 28 deletions(-)

diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index 228c658..d99ef9e 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -75,6 +75,11 @@ struct busfreq_opp_info {
 	unsigned long volt;
 };
 
+struct busfreq_ppmu_data {
+	struct exynos_ppmu *ppmu;
+	int ppmu_end;
+};
+
 struct busfreq_data {
 	enum exynos4_busf_type type;
 	struct device *dev;
@@ -83,7 +88,7 @@ struct busfreq_data {
 	struct regulator *vdd_int;
 	struct regulator *vdd_mif; /* Exynos4412/4212 only */
 	struct busfreq_opp_info curr_oppinfo;
-	struct exynos_ppmu ppmu[PPMU_END];
+	struct busfreq_ppmu_data ppmu_data;
 
 	struct notifier_block pm_notifier;
 	struct mutex lock;
@@ -510,47 +515,47 @@ static int exynos4x12_set_busclk(struct busfreq_data *data,
 	return 0;
 }
 
-static void busfreq_mon_reset(struct busfreq_data *data)
+static void busfreq_mon_reset(struct busfreq_ppmu_data *ppmu_data)
 {
 	unsigned int i;
 
-	for (i = 0; i < PPMU_END; i++) {
-		void __iomem *ppmu_base = data->ppmu[i].hw_base;
+	for (i = 0; i < ppmu_data->ppmu_end; i++) {
+		void __iomem *ppmu_base = ppmu_data->ppmu[i].hw_base;
 
 		/* Reset the performance and cycle counters */
 		exynos_ppmu_reset(ppmu_base);
 
 		/* Setup count registers to monitor read/write transactions */
-		data->ppmu[i].event[PPMU_PMNCNT3] = RDWR_DATA_COUNT;
+		ppmu_data->ppmu[i].event[PPMU_PMNCNT3] = RDWR_DATA_COUNT;
 		exynos_ppmu_setevent(ppmu_base, PPMU_PMNCNT3,
-					data->ppmu[i].event[PPMU_PMNCNT3]);
+				     ppmu_data->ppmu[i].event[PPMU_PMNCNT3]);
 
 		exynos_ppmu_start(ppmu_base);
 	}
 }
 
-static void exynos4_read_ppmu(struct busfreq_data *data)
+static void exynos4_read_ppmu(struct busfreq_ppmu_data *ppmu_data)
 {
 	int i, j;
 
-	for (i = 0; i < PPMU_END; i++) {
-		void __iomem *ppmu_base = data->ppmu[i].hw_base;
+	for (i = 0; i < ppmu_data->ppmu_end; i++) {
+		void __iomem *ppmu_base = ppmu_data->ppmu[i].hw_base;
 
 		exynos_ppmu_stop(ppmu_base);
 
 		/* Update local data from PPMU */
-		data->ppmu[i].ccnt = __raw_readl(ppmu_base + PPMU_CCNT);
+		ppmu_data->ppmu[i].ccnt = __raw_readl(ppmu_base + PPMU_CCNT);
 
 		for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++) {
-			if (data->ppmu[i].event[j] == 0)
-				data->ppmu[i].count[j] = 0;
+			if (ppmu_data->ppmu[i].event[j] == 0)
+				ppmu_data->ppmu[i].count[j] = 0;
 			else
-				data->ppmu[i].count[j] =
+				ppmu_data->ppmu[i].count[j] =
 					exynos_ppmu_read(ppmu_base, j);
 		}
 	}
 
-	busfreq_mon_reset(data);
+	busfreq_mon_reset(ppmu_data);
 }
 
 static int exynos4x12_get_intspec(unsigned long mifclk)
@@ -676,16 +681,16 @@ out:
 	return err;
 }
 
-static int exynos4_get_busier_ppmu(struct busfreq_data *data)
+static int exynos4_get_busier_ppmu(struct busfreq_ppmu_data *ppmu_data)
 {
 	int i, j;
 	int busy = 0;
 	unsigned int temp = 0;
 
-	for (i = 0; i < PPMU_END; i++) {
+	for (i = 0; i < ppmu_data->ppmu_end; i++) {
 		for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++) {
-			if (data->ppmu[i].count[j] > temp) {
-				temp = data->ppmu[i].count[j];
+			if (ppmu_data->ppmu[i].count[j] > temp) {
+				temp = ppmu_data->ppmu[i].count[j];
 				busy = i;
 			}
 		}
@@ -698,20 +703,21 @@ static int exynos4_bus_get_dev_status(struct device *dev,
 				      struct devfreq_dev_status *stat)
 {
 	struct busfreq_data *data = dev_get_drvdata(dev);
+	struct busfreq_ppmu_data *ppmu_data = &data->ppmu_data;
 	int busier;
 
-	exynos4_read_ppmu(data);
-	busier = exynos4_get_busier_ppmu(data);
+	exynos4_read_ppmu(ppmu_data);
+	busier = exynos4_get_busier_ppmu(ppmu_data);
 	stat->current_frequency = data->curr_oppinfo.rate;
 
 	/* Number of cycles spent on memory access */
-	stat->busy_time = data->ppmu[busier].count[PPMU_PMNCNT3];
+	stat->busy_time = ppmu_data->ppmu[busier].count[PPMU_PMNCNT3];
 	stat->busy_time *= 100 / BUS_SATURATION_RATIO;
-	stat->total_time = data->ppmu[busier].ccnt;
+	stat->total_time = ppmu_data->ppmu[busier].ccnt;
 
 	/* If the counters have overflown, retry */
-	if (data->ppmu[busier].ccnt_overflow ||
-	    data->ppmu[busier].count_overflow[0])
+	if (ppmu_data->ppmu[busier].ccnt_overflow ||
+	    ppmu_data->ppmu[busier].count_overflow[0])
 		return -EAGAIN;
 
 	return 0;
@@ -966,6 +972,7 @@ unlock:
 static int exynos4_busfreq_probe(struct platform_device *pdev)
 {
 	struct busfreq_data *data;
+	struct busfreq_ppmu_data *ppmu_data;
 	struct dev_pm_opp *opp;
 	struct device *dev = &pdev->dev;
 	int err = 0;
@@ -976,9 +983,19 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	ppmu_data = &data->ppmu_data;
+	ppmu_data->ppmu_end = PPMU_END;
+	ppmu_data->ppmu = devm_kzalloc(dev,
+				       sizeof(struct exynos_ppmu) * PPMU_END,
+				       GFP_KERNEL);
+	if (!ppmu_data->ppmu) {
+		dev_err(dev, "Failed to allocate memory for exynos_ppmu\n");
+		return -ENOMEM;
+	}
+
 	data->type = pdev->id_entry->driver_data;
-	data->ppmu[PPMU_DMC0].hw_base = S5P_VA_DMC0;
-	data->ppmu[PPMU_DMC1].hw_base = S5P_VA_DMC1;
+	ppmu_data->ppmu[PPMU_DMC0].hw_base = S5P_VA_DMC0;
+	ppmu_data->ppmu[PPMU_DMC1].hw_base = S5P_VA_DMC1;
 	data->pm_notifier.notifier_call = exynos4_busfreq_pm_notifier_event;
 	data->dev = dev;
 	mutex_init(&data->lock);
@@ -1037,7 +1054,7 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 	 * Start PPMU (Performance Profiling Monitoring Unit) to check
 	 * utilization of each IP in the Exynos4 SoC.
 	 */
-	busfreq_mon_reset(data);
+	busfreq_mon_reset(ppmu_data);
 
 	/* Register opp_notifier for Exynos4 busfreq */
 	err = devfreq_register_opp_notifier(dev, data->devfreq);
@@ -1081,8 +1098,9 @@ static int exynos4_busfreq_remove(struct platform_device *pdev)
 static int exynos4_busfreq_resume(struct device *dev)
 {
 	struct busfreq_data *data = dev_get_drvdata(dev);
+	struct busfreq_ppmu_data *ppmu_data = &data->ppmu_data;
 
-	busfreq_mon_reset(data);
+	busfreq_mon_reset(ppmu_data);
 	return 0;
 }
 #endif
-- 
1.8.2.3


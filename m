Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761157AbaCURcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 13:32:32 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31765 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbaCURcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 13:32:14 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-97-532c779d7687
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: cw00.choi@samsung.com, myungjoo.ham@samsung.com
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 3/4] devfreq: exynos5: introduce struct busfreq_ppmu_data
Date: Fri, 21 Mar 2014 18:31:45 +0100
Message-id: <1395423106-30458-4-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1395423106-30458-1-git-send-email-b.zolnierkie@samsung.com>
References: <1395423106-30458-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t9jQd255TrBBu9+yFpsnLGe1eL6l+es
	Fmeb3rBbXN41h83ic+8RRosZ5/cxWdxuXMFm8XjFW3aL9TNeszhweize85LJo2/LKkaPz5vk
	ApijuGxSUnMyy1KL9O0SuDLe33vKWtBjVHFhSloD41WNLkZODgkBE4nPBx4zQ9hiEhfurWfr
	YuTiEBKYziixfu0vKKeLSWLPpIuMIFVsAlYSE9tXgdkiAsYStx7fYgUpYhY4xijxbsJLIIeD
	Q1jAU+L15jKQGhYBVYmbD2+D1fMKeEhs+PObCWKbokT3swlsIDYnUPmiri6wGiGgmifPp7BO
	YORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4qJ5J7WBc2WBxiFGAg1GJh7eCUztY
	iDWxrLgy9xCjBAezkghvc6xOsBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6Yklqdmp
	qQWpRTBZJg5OqQbGyaV2EQK18SvOFJus1f/2WfgTx6wOxg01oX0b9JPfzT2rfULxq8Xpmmcy
	HPPyb74xfak+QXuSQ+zOY3u35TEFXvhwXq75y8TF71QubdzZu3PH2ts3xG2rNspt5uO/s9pv
	2o9rjxa4hyp/VPb9I3BdycnMncuss43lxwXRu4ZfDJqU9/652y1hpsRSnJFoqMVcVJwIAJ/X
	YSEmAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation for making more PPMU code common for
EXYNOS devfreq drivers.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/devfreq/exynos/exynos5_bus.c | 72 ++++++++++++++++++++++--------------
 1 file changed, 45 insertions(+), 27 deletions(-)

diff --git a/drivers/devfreq/exynos/exynos5_bus.c b/drivers/devfreq/exynos/exynos5_bus.c
index af6213f..b8ab32a 100644
--- a/drivers/devfreq/exynos/exynos5_bus.c
+++ b/drivers/devfreq/exynos/exynos5_bus.c
@@ -46,11 +46,16 @@ enum exynos_ppmu_list {
 	PPMU_END,
 };
 
+struct busfreq_ppmu_data {
+	struct exynos_ppmu *ppmu;
+	int ppmu_end;
+};
+
 struct busfreq_data_int {
 	struct device *dev;
 	struct devfreq *devfreq;
 	struct regulator *vdd_int;
-	struct exynos_ppmu ppmu[PPMU_END];
+	struct busfreq_ppmu_data ppmu_data;
 	unsigned long curr_freq;
 	bool disabled;
 
@@ -75,47 +80,47 @@ static struct int_bus_opp_table exynos5_int_opp_table[] = {
 	{0, 0, 0},
 };
 
-static void busfreq_mon_reset(struct busfreq_data_int *data)
+static void busfreq_mon_reset(struct busfreq_ppmu_data *ppmu_data)
 {
 	unsigned int i;
 
-	for (i = PPMU_RIGHT; i < PPMU_END; i++) {
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
 
-static void exynos5_read_ppmu(struct busfreq_data_int *data)
+static void exynos5_read_ppmu(struct busfreq_ppmu_data *ppmu_data)
 {
 	int i, j;
 
-	for (i = PPMU_RIGHT; i < PPMU_END; i++) {
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
 
 static int exynos5_int_setvolt(struct busfreq_data_int *data,
@@ -185,16 +190,16 @@ out:
 	return err;
 }
 
-static int exynos5_get_busier_dmc(struct busfreq_data_int *data)
+static int exynos5_get_busier_dmc(struct busfreq_ppmu_data *ppmu_data)
 {
 	int i, j;
 	int busy = 0;
 	unsigned int temp = 0;
 
-	for (i = PPMU_RIGHT; i < PPMU_END; i++) {
+	for (i = 0; i < ppmu_data->ppmu_end; i++) {
 		for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++) {
-			if (data->ppmu[i].count[j] > temp) {
-				temp = data->ppmu[i].count[j];
+			if (ppmu_data->ppmu[i].count[j] > temp) {
+				temp = ppmu_data->ppmu[i].count[j];
 				busy = i;
 			}
 		}
@@ -209,17 +214,18 @@ static int exynos5_int_get_dev_status(struct device *dev,
 	struct platform_device *pdev = container_of(dev, struct platform_device,
 						    dev);
 	struct busfreq_data_int *data = platform_get_drvdata(pdev);
+	struct busfreq_ppmu_data *ppmu_data = &data->ppmu_data;
 	int busier_dmc;
 
-	exynos5_read_ppmu(data);
-	busier_dmc = exynos5_get_busier_dmc(data);
+	exynos5_read_ppmu(ppmu_data);
+	busier_dmc = exynos5_get_busier_dmc(ppmu_data);
 
 	stat->current_frequency = data->curr_freq;
 
 	/* Number of cycles spent on memory access */
-	stat->busy_time = data->ppmu[busier_dmc].count[PPMU_PMNCNT3];
+	stat->busy_time = ppmu_data->ppmu[busier_dmc].count[PPMU_PMNCNT3];
 	stat->busy_time *= 100 / INT_BUS_SATURATION_RATIO;
-	stat->total_time = data->ppmu[busier_dmc].ccnt;
+	stat->total_time = ppmu_data->ppmu[busier_dmc].ccnt;
 
 	return 0;
 }
@@ -315,6 +321,7 @@ unlock:
 static int exynos5_busfreq_int_probe(struct platform_device *pdev)
 {
 	struct busfreq_data_int *data;
+	struct busfreq_ppmu_data *ppmu_data;
 	struct dev_pm_opp *opp;
 	struct device *dev = &pdev->dev;
 	struct device_node *np;
@@ -330,16 +337,26 @@ static int exynos5_busfreq_int_probe(struct platform_device *pdev)
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
 	np = of_find_compatible_node(NULL, NULL, "samsung,exynos5250-ppmu");
 	if (np == NULL) {
 		pr_err("Unable to find PPMU node\n");
 		return -ENOENT;
 	}
 
-	for (i = PPMU_RIGHT; i < PPMU_END; i++) {
+	for (i = 0; i < ppmu_data->ppmu_end; i++) {
 		/* map PPMU memory region */
-		data->ppmu[i].hw_base = of_iomap(np, i);
-		if (data->ppmu[i].hw_base == NULL) {
+		ppmu_data->ppmu[i].hw_base = of_iomap(np, i);
+		if (ppmu_data->ppmu[i].hw_base == NULL) {
 			dev_err(&pdev->dev, "failed to map memory region\n");
 			return -ENOMEM;
 		}
@@ -390,7 +407,7 @@ static int exynos5_busfreq_int_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, data);
 
-	busfreq_mon_reset(data);
+	busfreq_mon_reset(ppmu_data);
 
 	data->devfreq = devfreq_add_device(dev, &exynos5_devfreq_int_profile,
 					   "simple_ondemand", NULL);
@@ -435,8 +452,9 @@ static int exynos5_busfreq_int_resume(struct device *dev)
 	struct platform_device *pdev = container_of(dev, struct platform_device,
 						    dev);
 	struct busfreq_data_int *data = platform_get_drvdata(pdev);
+	struct busfreq_ppmu_data *ppmu_data = &data->ppmu_data;
 
-	busfreq_mon_reset(data);
+	busfreq_mon_reset(ppmu_data);
 	return 0;
 }
 static const struct dev_pm_ops exynos5_busfreq_int_pm = {
-- 
1.8.2.3


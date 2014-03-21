Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761195AbaCURdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 13:33:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18626 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761041AbaCURcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 13:32:18 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-1c-532c77a1b411
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: cw00.choi@samsung.com, myungjoo.ham@samsung.com
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 4/4] devfreq: exynos: make more PPMU code common
Date: Fri, 21 Mar 2014 18:31:46 +0100
Message-id: <1395423106-30458-5-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1395423106-30458-1-git-send-email-b.zolnierkie@samsung.com>
References: <1395423106-30458-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t9jQd2F5TrBBj1buSw2zljPanH9y3NW
	i7NNb9gtLu+aw2bxufcIo8WM8/uYLG43rmCzeLziLbvF+hmvWRw4PRbvecnk0bdlFaPH501y
	AcxRXDYpqTmZZalF+nYJXBlPJt5lL9jlWnHs8w72BsaPFl2MnBwSAiYSO97tYYSwxSQu3FvP
	1sXIxSEkMJ1R4vzBiWAJIYEuJomnezNBbDYBK4mJ7avA4iICxhK3Ht9iBWlgFjjGKPFuwktW
	kISwgIPElyd72EFsFgFViUmb37KB2LwCHhKbr79kh9imKNH9bAJYnFPAU2JRVxfUMg+JJ8+n
	sE5g5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzisnknvYFzVYHGIUYCDUYmHt4JT
	O1iINbGsuDL3EKMEB7OSCG9zrE6wEG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLpiSWp
	2ampBalFMFkmDk6pBkbHC4u3B71s6Wp8N7MqSby5wmnmduWGu53XajdWTlzjdTFAzFDkUvRO
	e5Yrx6d6Bxh6MizobpN9qctkWu73SrTMuT3Z0n1PWu7uGdMXFNWUPjiZFf54noKY9LXSc3cd
	di7e8TXzSY7NzdtNuo5BJbpa4VYpf65mcn73XVemYMJpYdMR5XmoQ4mlOCPRUIu5qDgRAHGc
	uvInAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move common PPMU code from exynos[45]_bus.c to exynos_ppmu.c.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/devfreq/exynos/exynos4_bus.c | 70 ++----------------------------------
 drivers/devfreq/exynos/exynos5_bus.c | 70 ++----------------------------------
 drivers/devfreq/exynos/exynos_ppmu.c | 60 +++++++++++++++++++++++++++++++
 drivers/devfreq/exynos/exynos_ppmu.h |  8 +++++
 4 files changed, 72 insertions(+), 136 deletions(-)

diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index d99ef9e..d257f1f 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -75,11 +75,6 @@ struct busfreq_opp_info {
 	unsigned long volt;
 };
 
-struct busfreq_ppmu_data {
-	struct exynos_ppmu *ppmu;
-	int ppmu_end;
-};
-
 struct busfreq_data {
 	enum exynos4_busf_type type;
 	struct device *dev;
@@ -515,49 +510,6 @@ static int exynos4x12_set_busclk(struct busfreq_data *data,
 	return 0;
 }
 
-static void busfreq_mon_reset(struct busfreq_ppmu_data *ppmu_data)
-{
-	unsigned int i;
-
-	for (i = 0; i < ppmu_data->ppmu_end; i++) {
-		void __iomem *ppmu_base = ppmu_data->ppmu[i].hw_base;
-
-		/* Reset the performance and cycle counters */
-		exynos_ppmu_reset(ppmu_base);
-
-		/* Setup count registers to monitor read/write transactions */
-		ppmu_data->ppmu[i].event[PPMU_PMNCNT3] = RDWR_DATA_COUNT;
-		exynos_ppmu_setevent(ppmu_base, PPMU_PMNCNT3,
-				     ppmu_data->ppmu[i].event[PPMU_PMNCNT3]);
-
-		exynos_ppmu_start(ppmu_base);
-	}
-}
-
-static void exynos4_read_ppmu(struct busfreq_ppmu_data *ppmu_data)
-{
-	int i, j;
-
-	for (i = 0; i < ppmu_data->ppmu_end; i++) {
-		void __iomem *ppmu_base = ppmu_data->ppmu[i].hw_base;
-
-		exynos_ppmu_stop(ppmu_base);
-
-		/* Update local data from PPMU */
-		ppmu_data->ppmu[i].ccnt = __raw_readl(ppmu_base + PPMU_CCNT);
-
-		for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++) {
-			if (ppmu_data->ppmu[i].event[j] == 0)
-				ppmu_data->ppmu[i].count[j] = 0;
-			else
-				ppmu_data->ppmu[i].count[j] =
-					exynos_ppmu_read(ppmu_base, j);
-		}
-	}
-
-	busfreq_mon_reset(ppmu_data);
-}
-
 static int exynos4x12_get_intspec(unsigned long mifclk)
 {
 	int i = 0;
@@ -681,24 +633,6 @@ out:
 	return err;
 }
 
-static int exynos4_get_busier_ppmu(struct busfreq_ppmu_data *ppmu_data)
-{
-	int i, j;
-	int busy = 0;
-	unsigned int temp = 0;
-
-	for (i = 0; i < ppmu_data->ppmu_end; i++) {
-		for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++) {
-			if (ppmu_data->ppmu[i].count[j] > temp) {
-				temp = ppmu_data->ppmu[i].count[j];
-				busy = i;
-			}
-		}
-	}
-
-	return busy;
-}
-
 static int exynos4_bus_get_dev_status(struct device *dev,
 				      struct devfreq_dev_status *stat)
 {
@@ -706,8 +640,8 @@ static int exynos4_bus_get_dev_status(struct device *dev,
 	struct busfreq_ppmu_data *ppmu_data = &data->ppmu_data;
 	int busier;
 
-	exynos4_read_ppmu(ppmu_data);
-	busier = exynos4_get_busier_ppmu(ppmu_data);
+	exynos_read_ppmu(ppmu_data);
+	busier = exynos_get_busier_ppmu(ppmu_data);
 	stat->current_frequency = data->curr_oppinfo.rate;
 
 	/* Number of cycles spent on memory access */
diff --git a/drivers/devfreq/exynos/exynos5_bus.c b/drivers/devfreq/exynos/exynos5_bus.c
index b8ab32a..ab54a69 100644
--- a/drivers/devfreq/exynos/exynos5_bus.c
+++ b/drivers/devfreq/exynos/exynos5_bus.c
@@ -46,11 +46,6 @@ enum exynos_ppmu_list {
 	PPMU_END,
 };
 
-struct busfreq_ppmu_data {
-	struct exynos_ppmu *ppmu;
-	int ppmu_end;
-};
-
 struct busfreq_data_int {
 	struct device *dev;
 	struct devfreq *devfreq;
@@ -80,49 +75,6 @@ static struct int_bus_opp_table exynos5_int_opp_table[] = {
 	{0, 0, 0},
 };
 
-static void busfreq_mon_reset(struct busfreq_ppmu_data *ppmu_data)
-{
-	unsigned int i;
-
-	for (i = 0; i < ppmu_data->ppmu_end; i++) {
-		void __iomem *ppmu_base = ppmu_data->ppmu[i].hw_base;
-
-		/* Reset the performance and cycle counters */
-		exynos_ppmu_reset(ppmu_base);
-
-		/* Setup count registers to monitor read/write transactions */
-		ppmu_data->ppmu[i].event[PPMU_PMNCNT3] = RDWR_DATA_COUNT;
-		exynos_ppmu_setevent(ppmu_base, PPMU_PMNCNT3,
-				     ppmu_data->ppmu[i].event[PPMU_PMNCNT3]);
-
-		exynos_ppmu_start(ppmu_base);
-	}
-}
-
-static void exynos5_read_ppmu(struct busfreq_ppmu_data *ppmu_data)
-{
-	int i, j;
-
-	for (i = 0; i < ppmu_data->ppmu_end; i++) {
-		void __iomem *ppmu_base = ppmu_data->ppmu[i].hw_base;
-
-		exynos_ppmu_stop(ppmu_base);
-
-		/* Update local data from PPMU */
-		ppmu_data->ppmu[i].ccnt = __raw_readl(ppmu_base + PPMU_CCNT);
-
-		for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++) {
-			if (ppmu_data->ppmu[i].event[j] == 0)
-				ppmu_data->ppmu[i].count[j] = 0;
-			else
-				ppmu_data->ppmu[i].count[j] =
-					exynos_ppmu_read(ppmu_base, j);
-		}
-	}
-
-	busfreq_mon_reset(ppmu_data);
-}
-
 static int exynos5_int_setvolt(struct busfreq_data_int *data,
 				unsigned long volt)
 {
@@ -190,24 +142,6 @@ out:
 	return err;
 }
 
-static int exynos5_get_busier_dmc(struct busfreq_ppmu_data *ppmu_data)
-{
-	int i, j;
-	int busy = 0;
-	unsigned int temp = 0;
-
-	for (i = 0; i < ppmu_data->ppmu_end; i++) {
-		for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++) {
-			if (ppmu_data->ppmu[i].count[j] > temp) {
-				temp = ppmu_data->ppmu[i].count[j];
-				busy = i;
-			}
-		}
-	}
-
-	return busy;
-}
-
 static int exynos5_int_get_dev_status(struct device *dev,
 				      struct devfreq_dev_status *stat)
 {
@@ -217,8 +151,8 @@ static int exynos5_int_get_dev_status(struct device *dev,
 	struct busfreq_ppmu_data *ppmu_data = &data->ppmu_data;
 	int busier_dmc;
 
-	exynos5_read_ppmu(ppmu_data);
-	busier_dmc = exynos5_get_busier_dmc(ppmu_data);
+	exynos_read_ppmu(ppmu_data);
+	busier_dmc = exynos_get_busier_ppmu(ppmu_data);
 
 	stat->current_frequency = data->curr_freq;
 
diff --git a/drivers/devfreq/exynos/exynos_ppmu.c b/drivers/devfreq/exynos/exynos_ppmu.c
index 85fc5ac..75fcc51 100644
--- a/drivers/devfreq/exynos/exynos_ppmu.c
+++ b/drivers/devfreq/exynos/exynos_ppmu.c
@@ -54,3 +54,63 @@ unsigned int exynos_ppmu_read(void __iomem *ppmu_base, unsigned int ch)
 
 	return total;
 }
+
+void busfreq_mon_reset(struct busfreq_ppmu_data *ppmu_data)
+{
+	unsigned int i;
+
+	for (i = 0; i < ppmu_data->ppmu_end; i++) {
+		void __iomem *ppmu_base = ppmu_data->ppmu[i].hw_base;
+
+		/* Reset the performance and cycle counters */
+		exynos_ppmu_reset(ppmu_base);
+
+		/* Setup count registers to monitor read/write transactions */
+		ppmu_data->ppmu[i].event[PPMU_PMNCNT3] = RDWR_DATA_COUNT;
+		exynos_ppmu_setevent(ppmu_base, PPMU_PMNCNT3,
+					ppmu_data->ppmu[i].event[PPMU_PMNCNT3]);
+
+		exynos_ppmu_start(ppmu_base);
+	}
+}
+
+void exynos_read_ppmu(struct busfreq_ppmu_data *ppmu_data)
+{
+	int i, j;
+
+	for (i = 0; i < ppmu_data->ppmu_end; i++) {
+		void __iomem *ppmu_base = ppmu_data->ppmu[i].hw_base;
+
+		exynos_ppmu_stop(ppmu_base);
+
+		/* Update local data from PPMU */
+		ppmu_data->ppmu[i].ccnt = __raw_readl(ppmu_base + PPMU_CCNT);
+
+		for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++) {
+			if (ppmu_data->ppmu[i].event[j] == 0)
+				ppmu_data->ppmu[i].count[j] = 0;
+			else
+				ppmu_data->ppmu[i].count[j] =
+					exynos_ppmu_read(ppmu_base, j);
+		}
+	}
+
+	busfreq_mon_reset(ppmu_data);
+}
+
+int exynos_get_busier_ppmu(struct busfreq_ppmu_data *ppmu_data)
+{
+	unsigned int count = 0;
+	int i, j, busy = 0;
+
+	for (i = 0; i < ppmu_data->ppmu_end; i++) {
+		for (j = PPMU_PMNCNT0; j < PPMU_PMNCNT_MAX; j++) {
+			if (ppmu_data->ppmu[i].count[j] > count) {
+				count = ppmu_data->ppmu[i].count[j];
+				busy = i;
+			}
+		}
+	}
+
+	return busy;
+}
diff --git a/drivers/devfreq/exynos/exynos_ppmu.h b/drivers/devfreq/exynos/exynos_ppmu.h
index 7dfb221..71f17ba 100644
--- a/drivers/devfreq/exynos/exynos_ppmu.h
+++ b/drivers/devfreq/exynos/exynos_ppmu.h
@@ -69,10 +69,18 @@ struct exynos_ppmu {
 	bool count_overflow[PPMU_PMNCNT_MAX];
 };
 
+struct busfreq_ppmu_data {
+	struct exynos_ppmu *ppmu;
+	int ppmu_end;
+};
+
 void exynos_ppmu_reset(void __iomem *ppmu_base);
 void exynos_ppmu_setevent(void __iomem *ppmu_base, unsigned int ch,
 			unsigned int evt);
 void exynos_ppmu_start(void __iomem *ppmu_base);
 void exynos_ppmu_stop(void __iomem *ppmu_base);
 unsigned int exynos_ppmu_read(void __iomem *ppmu_base, unsigned int ch);
+void busfreq_mon_reset(struct busfreq_ppmu_data *ppmu_data);
+void exynos_read_ppmu(struct busfreq_ppmu_data *ppmu_data);
+int exynos_get_busier_ppmu(struct busfreq_ppmu_data *ppmu_data);
 #endif /* __DEVFREQ_EXYNOS_PPMU_H */
-- 
1.8.2.3


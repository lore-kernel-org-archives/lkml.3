Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbaCaOmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:42:11 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16370 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbaCaOmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:42:08 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-7d-53397ebe2662
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: cw00.choi@samsung.com, myungjoo.ham@samsung.com
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 5/4] devfreq: exynos: make some code internal to exynos_ppmu.c
Date: Mon, 31 Mar 2014 16:41:37 +0200
Message-id: <2118594.6P3SUkHF65@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t9jAd19dZbBBrt3SVlsnLGe1eL6l+es
	Fmeb3rBbXN41h83ic+8RRosZ5/cxWdxuXMFm8XjFW3aL9TNeszhweize85LJo2/LKkaPz5vk
	ApijuGxSUnMyy1KL9O0SuDJmLSkuOK1S8ergJsYGxqNyXYycHBICJhIf3m5ig7DFJC7cWw9k
	c3EICSxilFj39jo7hNPCJDG/ex4rSBWbgJXExPZVjCC2iICxxK3Ht1hBipgFjjFKvJvwEqxI
	WMBP4tWWNWA2i4CqRP+DfrAGXgFNiVmHt4LFRQU8JXZsX8kGEReU+DH5HguIzSwgL7Fv/1RW
	CFtLYv3O40wTGPlmISmbhaRsFpKyBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCw/aZ
	1A7GlQ0WhxgFOBiVeHgtyi2DhVgTy4orcw8xSnAwK4nwZpUChXhTEiurUovy44tKc1KLDzFK
	c7AoifMeaLUOFBJITyxJzU5NLUgtgskycXBKNTDm+K23uVAharFYk927yPnOAsNbaa6RLLx8
	ix5cr8mczbPlYp7IydVGzjlhDx+8iAmJCGTb9aBu9SqZ67PZAvxm678TWcUdPWuxGYtId+Vs
	U8H5aWsLmHg1T95ic+GaYWBQs3h3wNp/e/c/9r7atnEz83qTypvafes+NiQy9DT9vdd2btXz
	DzVKLMUZiYZazEXFiQAVkIDhVwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* make exynos_ppmu_[reset,setevent,start,stop,read]() static
* move defines from exynos_ppmu.h to exynos_ppmu.c
* remove unused PPMU_[FLAG,CCNT_OVERFLOW] and [RD,WR]_DATA_COUNT defines

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
This patch depends on https://lkml.org/lkml/2014/3/21/347 patch series.

 drivers/devfreq/exynos/exynos_ppmu.c |   36 ++++++++++++++++++++++++++++++-----
 drivers/devfreq/exynos/exynos_ppmu.h |   36 -----------------------------------
 2 files changed, 31 insertions(+), 41 deletions(-)

Index: b/drivers/devfreq/exynos/exynos_ppmu.c
===================================================================
--- a/drivers/devfreq/exynos/exynos_ppmu.c	2014-03-31 16:19:55.295766529 +0200
+++ b/drivers/devfreq/exynos/exynos_ppmu.c	2014-03-31 16:20:48.051765631 +0200
@@ -15,7 +15,33 @@
 
 #include "exynos_ppmu.h"
 
-void exynos_ppmu_reset(void __iomem *ppmu_base)
+/* For PPMU Control */
+#define PPMU_ENABLE             BIT(0)
+#define PPMU_DISABLE            0x0
+#define PPMU_CYCLE_RESET        BIT(1)
+#define PPMU_COUNTER_RESET      BIT(2)
+
+#define PPMU_ENABLE_COUNT0      BIT(0)
+#define PPMU_ENABLE_COUNT1      BIT(1)
+#define PPMU_ENABLE_COUNT2      BIT(2)
+#define PPMU_ENABLE_COUNT3      BIT(3)
+#define PPMU_ENABLE_CYCLE       BIT(31)
+
+#define PPMU_CNTENS		0x10
+#define PPMU_CCNT		0x100
+
+#define PPMU_PMCNT0		0x110
+#define PPMU_PMCNT_OFFSET	0x10
+#define PMCNT_OFFSET(x)		(PPMU_PMCNT0 + (PPMU_PMCNT_OFFSET * x))
+
+#define PPMU_BEVT0SEL		0x1000
+#define PPMU_BEVTSEL_OFFSET	0x100
+#define PPMU_BEVTSEL(x)		(PPMU_BEVT0SEL + (ch * PPMU_BEVTSEL_OFFSET))
+
+/* For Event Selection */
+#define RDWR_DATA_COUNT		0x7
+
+static void exynos_ppmu_reset(void __iomem *ppmu_base)
 {
 	__raw_writel(PPMU_CYCLE_RESET | PPMU_COUNTER_RESET, ppmu_base);
 	__raw_writel(PPMU_ENABLE_CYCLE  |
@@ -26,23 +52,23 @@ void exynos_ppmu_reset(void __iomem *ppm
 		     ppmu_base + PPMU_CNTENS);
 }
 
-void exynos_ppmu_setevent(void __iomem *ppmu_base, unsigned int ch,
+static void exynos_ppmu_setevent(void __iomem *ppmu_base, unsigned int ch,
 			unsigned int evt)
 {
 	__raw_writel(evt, ppmu_base + PPMU_BEVTSEL(ch));
 }
 
-void exynos_ppmu_start(void __iomem *ppmu_base)
+static void exynos_ppmu_start(void __iomem *ppmu_base)
 {
 	__raw_writel(PPMU_ENABLE, ppmu_base);
 }
 
-void exynos_ppmu_stop(void __iomem *ppmu_base)
+static void exynos_ppmu_stop(void __iomem *ppmu_base)
 {
 	__raw_writel(PPMU_DISABLE, ppmu_base);
 }
 
-unsigned int exynos_ppmu_read(void __iomem *ppmu_base, unsigned int ch)
+static unsigned int exynos_ppmu_read(void __iomem *ppmu_base, unsigned int ch)
 {
 	unsigned int total;
 
Index: b/drivers/devfreq/exynos/exynos_ppmu.h
===================================================================
--- a/drivers/devfreq/exynos/exynos_ppmu.h	2014-03-31 16:19:55.263766531 +0200
+++ b/drivers/devfreq/exynos/exynos_ppmu.h	2014-03-31 16:20:21.175766089 +0200
@@ -14,36 +14,6 @@
 
 #include <linux/ktime.h>
 
-/* For PPMU Control */
-#define PPMU_ENABLE             BIT(0)
-#define PPMU_DISABLE            0x0
-#define PPMU_CYCLE_RESET        BIT(1)
-#define PPMU_COUNTER_RESET      BIT(2)
-
-#define PPMU_ENABLE_COUNT0      BIT(0)
-#define PPMU_ENABLE_COUNT1      BIT(1)
-#define PPMU_ENABLE_COUNT2      BIT(2)
-#define PPMU_ENABLE_COUNT3      BIT(3)
-#define PPMU_ENABLE_CYCLE       BIT(31)
-
-#define PPMU_CNTENS		0x10
-#define PPMU_FLAG		0x50
-#define PPMU_CCNT_OVERFLOW	BIT(31)
-#define PPMU_CCNT		0x100
-
-#define PPMU_PMCNT0		0x110
-#define PPMU_PMCNT_OFFSET	0x10
-#define PMCNT_OFFSET(x)		(PPMU_PMCNT0 + (PPMU_PMCNT_OFFSET * x))
-
-#define PPMU_BEVT0SEL		0x1000
-#define PPMU_BEVTSEL_OFFSET	0x100
-#define PPMU_BEVTSEL(x)		(PPMU_BEVT0SEL + (ch * PPMU_BEVTSEL_OFFSET))
-
-/* For Event Selection */
-#define RD_DATA_COUNT		0x5
-#define WR_DATA_COUNT		0x6
-#define RDWR_DATA_COUNT		0x7
-
 enum ppmu_counter {
 	PPMU_PMNCNT0,
 	PPMU_PMCCNT1,
@@ -74,12 +44,6 @@ struct busfreq_ppmu_data {
 	int ppmu_end;
 };
 
-void exynos_ppmu_reset(void __iomem *ppmu_base);
-void exynos_ppmu_setevent(void __iomem *ppmu_base, unsigned int ch,
-			unsigned int evt);
-void exynos_ppmu_start(void __iomem *ppmu_base);
-void exynos_ppmu_stop(void __iomem *ppmu_base);
-unsigned int exynos_ppmu_read(void __iomem *ppmu_base, unsigned int ch);
 void busfreq_mon_reset(struct busfreq_ppmu_data *ppmu_data);
 void exynos_read_ppmu(struct busfreq_ppmu_data *ppmu_data);
 int exynos_get_busier_ppmu(struct busfreq_ppmu_data *ppmu_data);


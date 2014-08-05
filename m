Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbaHENfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:35:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32014 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbaHENe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:34:58 -0400
X-AuditID: cbfee61a-f79e46d00000134f-a4-53e0dd80917b
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v5 4/5] ARM: EXYNOS: PM: fix register setup for AFTR mode code
Date: Tue, 05 Aug 2014 15:34:25 +0200
Message-id: <1407245666-20016-5-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1407245666-20016-1-git-send-email-b.zolnierkie@samsung.com>
References: <1407245666-20016-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jAd2Guw+CDdZNF7XYOGM9q8W8z7IW
	vQuuslmcbXrDbvH+0DNmi02Pr7FaXN41h83ic+8RRosZ5/cxWZw5fYnV4uSfXkaL9TNes1hs
	/OrhwOtx59oeNo/NS+o9bv97zOyx5Wo7i0ffllWMHp83yQWwRXHZpKTmZJalFunbJXBlHD7S
	xFywibdi1qwG9gbGhdxdjBwcEgImEncWanQxcgKZYhIX7q1n62Lk4hASWMQosablDiuE08Uk
	cW/aLTaQKjYBK4mJ7asYQWwRATWJnsVbGUGKmAX2Mkss7d7EDpIQFvCT6N63lxFkA4uAqsTy
	FheQMK+Ah8T1q9+ZILYpSnQ/mwA2k1PAU6Lx2jNmEFsIqGbzld1MExh5FzAyrGIUTS1ILihO
	Ss811CtOzC0uzUvXS87P3cQIDspnUjsYVzZYHGIU4GBU4uEVULsfLMSaWFZcmXuIUYKDWUmE
	l/32g2Ah3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOFBNITS1KzU1MLUotgskwcnFINjFby
	wlIc0UImuiJqD9UOJnaYhQtdv3Rjh6yv3TWVZPF403Tn5E17znx68jngmWnmffkjW8Vakqer
	zd7cdFr8dOSppknOd9OrtQrfZ2zc1x6/aul0tYbGpz8rji+dnN7OqHQkKED54JY3rvEeRlNX
	+rGFtm+9OqHl8q+d8+4xcv2p79Le12AnpsRSnJFoqMVcVJwIANj0ilVGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add S5P_CENTRAL_SEQ_OPTION register setup to cpuidle AFTR mode code
by moving the relevant code from exynos_pm_suspend() (used only by
suspend) to exynos_pm_central_suspend() (used by both suspend and
AFTR).  Without this setup AFTR mode doesn't show any benefit over
WFI one (at least on Exynos4412 SoC).  When this setup is applied
AFTR mode reduces power consumption by ~12% (as measured on Trats2
board).

This change is a preparation for adding secure firmware support to
EXYNOS cpuidle driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/pm.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index e0b6885..3cee123 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -169,6 +169,10 @@ static void exynos_pm_central_suspend(void)
 	tmp = pmu_raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
 	tmp &= ~S5P_CENTRAL_LOWPWR_CFG;
 	pmu_raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
+
+	/* Setting SEQ_OPTION register */
+	pmu_raw_writel(S5P_USE_STANDBY_WFI0 | S5P_USE_STANDBY_WFE0,
+		       S5P_CENTRAL_SEQ_OPTION);
 }
 
 static int exynos_pm_central_resume(void)
@@ -291,15 +295,8 @@ static void exynos_pm_prepare(void)
 
 static int exynos_pm_suspend(void)
 {
-	unsigned long tmp;
-
 	exynos_pm_central_suspend();
 
-	/* Setting SEQ_OPTION register */
-
-	tmp = (S5P_USE_STANDBY_WFI0 | S5P_USE_STANDBY_WFE0);
-	pmu_raw_writel(tmp, S5P_CENTRAL_SEQ_OPTION);
-
 	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9)
 		exynos_cpu_save_register();
 
-- 
1.8.2.3


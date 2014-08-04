Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaHDRqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:46:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36698 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaHDRqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 13:46:17 -0400
X-AuditID: cbfee61a-f79e46d00000134f-48-53dfc6e76dfa
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
Subject: [PATCH v4 4/5] ARM: EXYNOS: PM: fix register setup for AFTR mode code
Date: Mon, 04 Aug 2014 19:45:44 +0200
Message-id: <1407174345-31213-5-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1407174345-31213-1-git-send-email-b.zolnierkie@samsung.com>
References: <1407174345-31213-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t9jAd0Xx+4HG6xjtNg4Yz2rxbzPsha9
	C66yWZxtesNu8f7QM2aLTY+vsVpc3jWHzeJz7xFGixnn9zFZnDl9idXi5J9eRov1M16zWGz8
	6uHA63Hn2h42j81L6j1u/3vM7LHlajuLR9+WVYwenzfJBbBFcdmkpOZklqUW6dslcGX82DiL
	rWATb8XtGWkNjAu5uxg5OSQETCRe/1nACGGLSVy4t56ti5GLQ0hgEaPEnkPTWSGcLiaJab1f
	2UCq2ASsJCa2rwLrEBFQk+hZvJURpIhZYC+zxNLuTexdjBwcwgJ+Ep3nwDawCKhKbDj4nBEk
	zCvgIXFnZSLEMkWJ7mcTwEZyCnhK/DjyC8wWAirpPrSccQIj7wJGhlWMoqkFyQXFSem5hnrF
	ibnFpXnpesn5uZsYwQH5TGoH48oGi0OMAhyMSjy8Amr3g4VYE8uKK3MPMUpwMCuJ8NYdAArx
	piRWVqUW5ccXleakFh9ilOZgURLnPdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpgFN2aO0X57W9H
	FvOFH1l9wo5efKx15MMP67L5OpySvDycC9x9WDRPh6eev2QTF/Q2Ye3u1bmvTqW+3/qnMTpe
	P1fgp9eSR7+3+yUrnHKuj6+vyJ00gfXZYulvOy6Ft1qWv+bd8kf0gemDlL1ZvNX10+Pq+vT+
	asfVvS/+oxEg7pdQ0qTf4rJMiaU4I9FQi7moOBEAWVeow0QCAAA=
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
index a61b85c..4e32cc6 100644
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


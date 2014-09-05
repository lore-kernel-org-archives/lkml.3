Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbaIENwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:52:36 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35537 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559AbaIENwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:52:33 -0400
X-AuditID: cbfee61b-f79f86d00000144c-0c-5409c01f94e6
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v6 4/5] ARM: EXYNOS: PM: fix register setup for AFTR mode code
Date: Fri, 05 Sep 2014 15:51:27 +0200
Message-id: <1409925088-4705-5-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1409925088-4705-1-git-send-email-b.zolnierkie@samsung.com>
References: <1409925088-4705-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t9jAV35A5whBqt/W1psnLGe1WLeZ1mL
	3gVX2SzONr1ht3h/6BmzxabH11gtLu+aw2bxufcIo8WM8/uYLM6cvsRqcfJPL6PFxq8eDjwe
	d67tYfPYvKTe4/a/x8weW662s3j0bVnF6PF5k1wAWxSXTUpqTmZZapG+XQJXxqIJuQXHeSuu
	rfrE3sC4jruLkYNDQsBEov1nYRcjJ5ApJnHh3no2EFtIYBGjxJSnVl2MXEB2F5PElK1TWEES
	bAJWEhPbVzGC2CICahI9i7cyghQxC8xmlnj18AELyFBhAT+JtZPkQGpYBFQlJhx5zgRi8wq4
	S/R03GCGWKYo0f1sAtgyTgEPiSkPvjBDLHaX2Nl9k2UCI+8CRoZVjKKpBckFxUnpuUZ6xYm5
	xaV56XrJ+bmbGMFh+Ex6B+OqBotDjAIcjEo8vAs+c4QIsSaWFVfmHmKU4GBWEuG13c0ZIsSb
	klhZlVqUH19UmpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyWiYNTqoGxWklz15b4pAlm
	3uyC7P9M7UL2SpRl7d30Iaip/lShssh62RunvXc4FDFZPVgvefrH0/RkrdC2Wxal9yuyt/ye
	0N5x7Wd22NLfVxoD/hioVIUbvXnXe+NwZ4hr1S+/mSwrGV9PZk1S7jglelXra9quvRNyPv94
	Xn1q6x6D+wvY3j2u2DInQuSNEktxRqKhFnNRcSIA/jgjeT8CAAA=
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
v6:
- no changes

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


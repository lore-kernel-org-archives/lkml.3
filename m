Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaIXMZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:25:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11647 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbaIXMZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:25:42 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-c4-5422b843aa33
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v7 4/5] ARM: EXYNOS: PM: fix register setup for AFTR mode code
Date: Wed, 24 Sep 2014 14:24:47 +0200
Message-id: <1411561488-1739-5-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411561488-1739-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411561488-1739-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t9jQV3nHUohBjc/m1lsnLGe1WLeZ1mL
	3gVX2SzONr1ht3h/6BmzxabH11gtLu+aw2bxufcIo8WM8/uYLDq/zGKzuH2Z1+LM6UusFif/
	9DJavDrYxmLxc9c8FotVu/4wWmz86uEg6NHS3MPmsXPWXXaPO9f2sHlsXlLvcfvfY2aPLVfb
	WTz6tqxi9Pi8Sc5j49zQAM4oLpuU1JzMstQifbsErow//cvYC47zVtw8sYetgXEddxcjJ4eE
	gInEof1v2SBsMYkL99YD2VwcQgLTGSU61/1hgnC6mCT2rmtgB6liE7CSmNi+ihHEFhFQk+hZ
	vBXMZha4zSLRcD0CxBYW8JN492AfE4jNIqAq8e/1c7BeXgF3icMHVzFDbFOU6H42AWwzp4CH
	xIv7PWA1QkA1x05eYZ3AyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnBgP5Pewbiq
	weIQowAHoxIPb8cypRAh1sSy4srcQ4wSHMxKIrxW24BCvCmJlVWpRfnxRaU5qcWHGKU5WJTE
	eQ+2WgcKCaQnlqRmp6YWpBbBZJk4OKUaGMv2hN2beV5SNvfd51Wn+Y4c5Uu//Sd7ZxGbxKnc
	+fP/SLtbJE2aNHPB7rA/p5vf3rHtTboizZDhoRyz8GJuwstjr+RX1Rd9/Mv7wrVPPSqU7/Pn
	maoeiponEqrPH76Q/2BRtoLxM57yFAEHjaJ398+z+Wc7TfiVtGluqchiQ47a7jO3Vm+LElNi
	Kc5INNRiLipOBACOuIpJaAIAAA==
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
v7:
- no changes

 arch/arm/mach-exynos/pm.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 6796fce..16c5c32 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -196,6 +196,10 @@ static void exynos_pm_central_suspend(void)
 	tmp = pmu_raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
 	tmp &= ~S5P_CENTRAL_LOWPWR_CFG;
 	pmu_raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
+
+	/* Setting SEQ_OPTION register */
+	pmu_raw_writel(S5P_USE_STANDBY_WFI0 | S5P_USE_STANDBY_WFE0,
+		       S5P_CENTRAL_SEQ_OPTION);
 }
 
 static int exynos_pm_central_resume(void)
@@ -321,15 +325,8 @@ static void exynos_pm_prepare(void)
 
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaK0Qvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:51:48 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:45727 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaK0Qvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:51:44 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-78-5477569e10b6
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Colin Cross <ccross@google.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v2 1/2] ARM: EXYNOS: apply S5P_CENTRAL_SEQ_OPTION fix only when
 necessary
Date: Thu, 27 Nov 2014 17:51:24 +0100
Message-id: <1417107085-26159-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1417107085-26159-1-git-send-email-b.zolnierkie@samsung.com>
References: <1417107085-26159-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t9jAd15YeUhBnOa1C02zljParFgRjuz
	xbzPshavXxha9C64ymZxtukNu8X7Q8+YLS7vmsNm8bn3CKPFjPP7mCxW7frD6MDtsXPWXXaP
	BZtKPe5c28PmcfvfY2aPvi2rGD0+b5ILYIvisklJzcksSy3St0vgyph9o4+5YK9wxe5bz1ga
	GHcIdDFyckgImEjs7ZvBBGGLSVy4t56ti5GLQ0hgEaPEjyNLGCGcLiaJOx82s4NUsQlYSUxs
	X8UIYosIqEn0LN4KVsQs8JZJYvurR2CjhAWiJX4cfAzWwCKgKnHlwD1mEJtXwEPiXfMcZoh1
	ihLdzyawgdicAp4Su3YsZwGxhYBqNm+YxDaBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k
	/NxNjOAgfCa9g3FVg8UhRgEORiUeXosDZSFCrIllxZW5hxglOJiVRHibbMtDhHhTEiurUovy
	44tKc1KLDzFKc7AoifPeuJkbIiSQnliSmp2aWpBaBJNl4uCUamDsK9m8Unb1lN+rLHm2sLxi
	WiRxJIKLuX7Duk+HtnUrnpQ717ZFzuv5jKOJ73ufLltVIHbELPTQ0xkzVX9tdZkUWyH4Lqrr
	UEUOp+SaIL+t73/Z/HeaevvOZJlXRy8mHZv1yrNjecp0Vg/3I9tNpJpqJWcmXr8ZIum2TvmA
	d+IU7bjr7w0OHD+zRImlOCPRUIu5qDgRAFVhWOA+AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c2dd114d2486 ("ARM: EXYNOS: fix register setup for AFTR mode
code") added S5P_CENTRAL_SEQ_OPTION register setup fix for all
Exynos SoCs to AFTR mode code-path.  It turned out that for coupled
cpuidle AFTR mode on Exynos4210 (added by the next patch) applying
this fix causes lockup so enable it in the AFTR mode code-path only
on SoCs that require it (in the suspend code-path it can be always
applied like it was before commit c2dd114d2486).

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Colin Cross <ccross@google.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v2:
- no changes

 arch/arm/mach-exynos/pm.c      | 11 +++++++----
 arch/arm/mach-exynos/suspend.c |  4 ++++
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 86f3ecd8..159eb4c 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -97,10 +97,6 @@ void exynos_pm_central_suspend(void)
 	tmp = pmu_raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
 	tmp &= ~S5P_CENTRAL_LOWPWR_CFG;
 	pmu_raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
-
-	/* Setting SEQ_OPTION register */
-	pmu_raw_writel(S5P_USE_STANDBY_WFI0 | S5P_USE_STANDBY_WFE0,
-		       S5P_CENTRAL_SEQ_OPTION);
 }
 
 int exynos_pm_central_resume(void)
@@ -164,6 +160,13 @@ void exynos_enter_aftr(void)
 
 	exynos_pm_central_suspend();
 
+	if (of_machine_is_compatible("samsung,exynos4212") ||
+	    of_machine_is_compatible("samsung,exynos4412")) {
+		/* Setting SEQ_OPTION register */
+		pmu_raw_writel(S5P_USE_STANDBY_WFI0 | S5P_USE_STANDBY_WFE0,
+			       S5P_CENTRAL_SEQ_OPTION);
+	}
+
 	cpu_suspend(0, exynos_aftr_finisher);
 
 	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9) {
diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
index f8e7dcd..9c67a15 100644
--- a/arch/arm/mach-exynos/suspend.c
+++ b/arch/arm/mach-exynos/suspend.c
@@ -282,6 +282,10 @@ static int exynos_pm_suspend(void)
 {
 	exynos_pm_central_suspend();
 
+	/* Setting SEQ_OPTION register */
+	pmu_raw_writel(S5P_USE_STANDBY_WFI0 | S5P_USE_STANDBY_WFE0,
+		       S5P_CENTRAL_SEQ_OPTION);
+
 	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9)
 		exynos_cpu_save_register();
 
-- 
1.8.2.3


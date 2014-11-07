Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaKGSB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:01:26 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26594 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaKGSBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:01:22 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-a8-545d08f0557b
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Colin Cross <ccross@google.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH 1/2] ARM: EXYNOS: apply S5P_CENTRAL_SEQ_OPTION fix only when
 necessary
Date: Fri, 07 Nov 2014 19:00:50 +0100
Message-id: <1415383252-20118-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415383252-20118-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415383252-20118-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t9jQd0PHLEhBis36VtsnLGe1WLBjHZm
	i3mfZS1evzC06F1wlc3ibNMbdov3h54xW1zeNYfN4nPvEUaLGef3MVms2vWH0YHbY+esu+we
	CzaVety5tofN4/a/x8wefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlfH3wUG2guXCFQuWHGZr
	YFwl0MXIySEhYCLx5VAHK4QtJnHh3nq2LkYuDiGB6YwSn3q6WCCcLiaJf01LmEGq2ASsJCa2
	r2IEsUUE1CR6Fm9lBCliFnjLJLH91SOmLkYODmGBCImPz8BqWARUJSa9bwazeQU8JCb8/8sO
	sU1RovvZBDYQm1PAU+LP3WlgcSGgmqNPzjJPYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10v
	OT93EyM4BJ9J72Bc1WBxiFGAg1GJh/cGb0yIEGtiWXFl7iFGCQ5mJRFec9bYECHelMTKqtSi
	/Pii0pzU4kOM0hwsSuK8B1utA4UE0hNLUrNTUwtSi2CyTBycUg2MunFPe6c/37vhhOX7k11c
	HXP9sjkeTcvtd/ye7ukyZwXXmvlLe7dcYpjzePJTC9/Y/3Mufiv8yt6gJ+K3k0l2Ykfg671/
	p+Qr68yoc5wvfOuroZHKnXYTTeG86c1Kk/ee2H+dx6P/Se/v1PzVza/S5PhVz9wJORly55E/
	y+ag3Ira38EnRLX3K7EUZyQaajEXFScCAAVJRnw9AgAA
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
 arch/arm/mach-exynos/pm.c      | 11 +++++++----
 arch/arm/mach-exynos/suspend.c |  4 ++++
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 4f10fa6..4b36ab5 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -96,10 +96,6 @@ void exynos_pm_central_suspend(void)
 	tmp = pmu_raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
 	tmp &= ~S5P_CENTRAL_LOWPWR_CFG;
 	pmu_raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
-
-	/* Setting SEQ_OPTION register */
-	pmu_raw_writel(S5P_USE_STANDBY_WFI0 | S5P_USE_STANDBY_WFE0,
-		       S5P_CENTRAL_SEQ_OPTION);
 }
 
 int exynos_pm_central_resume(void)
@@ -163,6 +159,13 @@ void exynos_enter_aftr(void)
 
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
index f5d9773..ec6b04d 100644
--- a/arch/arm/mach-exynos/suspend.c
+++ b/arch/arm/mach-exynos/suspend.c
@@ -178,6 +178,10 @@ static int exynos_pm_suspend(void)
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbbAWQ0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:26:01 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:55272 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbbAWQZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:25:19 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-5d-54c275ed5647
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Kukjin Kim <kgene@kernel.org>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Colin Cross <ccross@google.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v3 1/2] ARM: EXYNOS: apply S5P_CENTRAL_SEQ_OPTION fix only when
 necessary
Date: Fri, 23 Jan 2015 17:24:53 +0100
Message-id: <1422030294-20925-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1422030294-20925-1-git-send-email-b.zolnierkie@samsung.com>
References: <1422030294-20925-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t9jAd13pYdCDG5EWGycsZ7VYsGMdmaL
	eZ9lLV6/MLToXXCVzaL/8Wtmi7NNb9gt3h96xmxxedccNovPvUcYLWac38dksWrXH0YHHo+d
	s+6yeyzYVOqxaVUnm8eda3vYPG7/e8zs0bdlFaPH501yAexRXDYpqTmZZalF+nYJXBlrXqQX
	LBeu+LPxNUsD4yqBLkYODgkBE4kD7QFdjJxAppjEhXvr2boYuTiEBBYxSmxbOoMJwulikrj0
	eC4zSBWbgJXExPZVjCC2iICaRM/irYwgRcwCPcwSHetngSWEBaIllvxdzAZiswioSqy8u5wR
	ZBuvgIfEi31RENsUJbqfTQAr4RTwlFizYicriC0EVPKs+QLjBEbeBYwMqxhFUwuSC4qT0nON
	9IoTc4tL89L1kvNzNzGCA/KZ9A7GVQ0WhxgFOBiVeHgbthwMEWJNLCuuzD3EKMHBrCTCm5Fy
	KESINyWxsiq1KD++qDQntfgQozQHi5I4r5J9W4iQQHpiSWp2ampBahFMlomDU6qB0b1fuOFU
	6lzZnaei/23d2ZvoJ9H0puDDTMVlp6Qv3HdzWC3bzbjmY8YhIWunJRMOPeW+fc+L0VCdUePr
	htlXD7p4H50wTcdhY1XfJ0U3GU3p+Q/ntcc5LO5teTlPMPRVyMev39Qbjq+5tOT28am9hyU/
	xJh61ldVThFus1IWqjKbnXrjG9PrFiWW4oxEQy3mouJEAGB8xtBEAgAA
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
index dfc8594..1a7454d 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -98,10 +98,6 @@ void exynos_pm_central_suspend(void)
 	tmp = pmu_raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
 	tmp &= ~S5P_CENTRAL_LOWPWR_CFG;
 	pmu_raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
-
-	/* Setting SEQ_OPTION register */
-	pmu_raw_writel(S5P_USE_STANDBY_WFI0 | S5P_USE_STANDBY_WFE0,
-		       S5P_CENTRAL_SEQ_OPTION);
 }
 
 int exynos_pm_central_resume(void)
@@ -165,6 +161,13 @@ void exynos_enter_aftr(void)
 
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
index 82e6b6f..666ec3e 100644
--- a/arch/arm/mach-exynos/suspend.c
+++ b/arch/arm/mach-exynos/suspend.c
@@ -319,6 +319,10 @@ static int exynos_pm_suspend(void)
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


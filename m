Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab3ETKzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:55:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56480 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab3ETKyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:54:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Inderpal Singh <inderpal.singh@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 114/115] ARM: EXYNOS5: Fix kernel dump in AFTR idle mode
Date: Mon, 20 May 2013 11:51:54 +0100
Message-Id: <1369047116-9378-115-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Inderpal Singh <inderpal.singh@linaro.org>

commit 088584618836b159947bc4ab5011a5cf1f081a62 upstream.

The kernel crashes while resuming from AFTR idle mode. It happens
because L2 cache was not going into retention state.

This patch configures the USE_RETENTION bit of ARM_L2_OPTION register
so that it does not depend on MANUAL_L2RSTDISABLE_CONTROL of
ARM_COMMON_OPTION register for L2RSTDISABLE signal.

Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
Tested-by: Chander Kashyap <chander.kashyap@linaro.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-exynos/include/mach/regs-pmu.h | 1 +
 arch/arm/mach-exynos/pmu.c                   | 5 ++---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-exynos/include/mach/regs-pmu.h b/arch/arm/mach-exynos/include/mach/regs-pmu.h
index 43a99e6..20a43be 100644
--- a/arch/arm/mach-exynos/include/mach/regs-pmu.h
+++ b/arch/arm/mach-exynos/include/mach/regs-pmu.h
@@ -337,6 +337,7 @@
 #define EXYNOS5_FSYS_ARM_OPTION					S5P_PMUREG(0x2208)
 #define EXYNOS5_ISP_ARM_OPTION					S5P_PMUREG(0x2288)
 #define EXYNOS5_ARM_COMMON_OPTION				S5P_PMUREG(0x2408)
+#define EXYNOS5_ARM_L2_OPTION					S5P_PMUREG(0x2608)
 #define EXYNOS5_TOP_PWR_OPTION					S5P_PMUREG(0x2C48)
 #define EXYNOS5_TOP_PWR_SYSMEM_OPTION				S5P_PMUREG(0x2CC8)
 #define EXYNOS5_JPEG_MEM_OPTION					S5P_PMUREG(0x2F48)
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index 4aacb66..d054f16 100644
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -227,6 +227,7 @@ static struct exynos_pmu_conf exynos5250_pmu_config[] = {
 	{ EXYNOS5_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
 	{ EXYNOS5_ARM_COMMON_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
 	{ EXYNOS5_ARM_L2_SYS_PWR_REG,			{ 0x3, 0x3, 0x3} },
+	{ EXYNOS5_ARM_L2_OPTION,			{ 0x10, 0x10, 0x0 } },
 	{ EXYNOS5_CMU_ACLKSTOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
 	{ EXYNOS5_CMU_SCLKSTOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
 	{ EXYNOS5_CMU_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
@@ -352,11 +353,9 @@ static void exynos5_init_pmu(void)
 
 	/*
 	 * SKIP_DEACTIVATE_ACEACP_IN_PWDN_BITFIELD Enable
-	 * MANUAL_L2RSTDISABLE_CONTROL_BITFIELD Enable
 	 */
 	tmp = __raw_readl(EXYNOS5_ARM_COMMON_OPTION);
-	tmp |= (EXYNOS5_MANUAL_L2RSTDISABLE_CONTROL |
-		EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN);
+	tmp |= EXYNOS5_SKIP_DEACTIVATE_ACEACP_IN_PWDN;
 	__raw_writel(tmp, EXYNOS5_ARM_COMMON_OPTION);
 
 	/*
-- 
1.8.1.2


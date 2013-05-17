Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab3EQVof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:44:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757236Ab3EQVhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Inderpal Singh <inderpal.singh@linaro.org>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 081/102] ARM: EXYNOS5: Fix kernel dump in AFTR idle mode
Date: Fri, 17 May 2013 14:36:36 -0700
Message-Id: <20130517213252.840765999@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-exynos/include/mach/regs-pmu.h |    1 +
 arch/arm/mach-exynos/pmu.c                   |    5 ++---
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/mach-exynos/include/mach/regs-pmu.h
+++ b/arch/arm/mach-exynos/include/mach/regs-pmu.h
@@ -344,6 +344,7 @@
 #define EXYNOS5_FSYS_ARM_OPTION					S5P_PMUREG(0x2208)
 #define EXYNOS5_ISP_ARM_OPTION					S5P_PMUREG(0x2288)
 #define EXYNOS5_ARM_COMMON_OPTION				S5P_PMUREG(0x2408)
+#define EXYNOS5_ARM_L2_OPTION					S5P_PMUREG(0x2608)
 #define EXYNOS5_TOP_PWR_OPTION					S5P_PMUREG(0x2C48)
 #define EXYNOS5_TOP_PWR_SYSMEM_OPTION				S5P_PMUREG(0x2CC8)
 #define EXYNOS5_JPEG_MEM_OPTION					S5P_PMUREG(0x2F48)
--- a/arch/arm/mach-exynos/pmu.c
+++ b/arch/arm/mach-exynos/pmu.c
@@ -228,6 +228,7 @@ static struct exynos_pmu_conf exynos5250
 	{ EXYNOS5_DIS_IRQ_ISP_ARM_CENTRAL_SYS_PWR_REG,	{ 0x0, 0x0, 0x0} },
 	{ EXYNOS5_ARM_COMMON_SYS_PWR_REG,		{ 0x0, 0x0, 0x2} },
 	{ EXYNOS5_ARM_L2_SYS_PWR_REG,			{ 0x3, 0x3, 0x3} },
+	{ EXYNOS5_ARM_L2_OPTION,			{ 0x10, 0x10, 0x0 } },
 	{ EXYNOS5_CMU_ACLKSTOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
 	{ EXYNOS5_CMU_SCLKSTOP_SYS_PWR_REG,		{ 0x1, 0x0, 0x1} },
 	{ EXYNOS5_CMU_RESET_SYS_PWR_REG,		{ 0x1, 0x1, 0x0} },
@@ -353,11 +354,9 @@ static void exynos5_init_pmu(void)
 
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



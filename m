Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302Ab3FCWNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:13:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30555 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759134Ab3FCWMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:44 -0400
X-Authority-Analysis: v=2.0 cv=Et5QXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=9nay_dFR0dgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=oAn56Dz6tywA:10 a=KKAkSRfTAAAA:8 a=6zb38KopAAAA:8 a=vmGD27vEwLNAEJJ72J0A:9 a=WwgC8nHKvroA:10 a=D-PNlr3aaKoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221200.311551186@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:11:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Inderpal Singh <inderpal.singh@linaro.org>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Olof Johansson <olof@lixom.net>
Subject: [47/65] ARM: EXYNOS5: Fix kernel dump in AFTR idle mode
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0047-ARM-EXYNOS5-Fix-kernel-dump-in-AFTR-idle-mode.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Inderpal Singh <inderpal.singh@linaro.org>

[ Upstream commit 088584618836b159947bc4ab5011a5cf1f081a62 ]

The kernel crashes while resuming from AFTR idle mode. It happens
because L2 cache was not going into retention state.

This patch configures the USE_RETENTION bit of ARM_L2_OPTION register
so that it does not depend on MANUAL_L2RSTDISABLE_CONTROL of
ARM_COMMON_OPTION register for L2RSTDISABLE signal.

Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
Tested-by: Chander Kashyap <chander.kashyap@linaro.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/mach-exynos/include/mach/regs-pmu.h |    1 +
 arch/arm/mach-exynos/pmu.c                   |    5 ++---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-exynos/include/mach/regs-pmu.h b/arch/arm/mach-exynos/include/mach/regs-pmu.h
index d4e392b..ad3c020 100644
--- a/arch/arm/mach-exynos/include/mach/regs-pmu.h
+++ b/arch/arm/mach-exynos/include/mach/regs-pmu.h
@@ -342,6 +342,7 @@
 #define EXYNOS5_FSYS_ARM_OPTION					S5P_PMUREG(0x2208)
 #define EXYNOS5_ISP_ARM_OPTION					S5P_PMUREG(0x2288)
 #define EXYNOS5_ARM_COMMON_OPTION				S5P_PMUREG(0x2408)
+#define EXYNOS5_ARM_L2_OPTION					S5P_PMUREG(0x2608)
 #define EXYNOS5_TOP_PWR_OPTION					S5P_PMUREG(0x2C48)
 #define EXYNOS5_TOP_PWR_SYSMEM_OPTION				S5P_PMUREG(0x2CC8)
 #define EXYNOS5_JPEG_MEM_OPTION					S5P_PMUREG(0x2F48)
diff --git a/arch/arm/mach-exynos/pmu.c b/arch/arm/mach-exynos/pmu.c
index 3a48c85..76691b3 100644
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
1.7.10.4



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbbAOLBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:01:03 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:38585 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbbAOLBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:01:00 -0500
From: Dmitry Osipenko <digetx@gmail.com>
To: digetx@gmail.com, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] ARM: tegra: Store tegra_resume() address in IRAM
Date: Thu, 15 Jan 2015 13:58:58 +0300
Message-Id: <1421319545-23920-3-git-send-email-digetx@gmail.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421319545-23920-1-git-send-email-digetx@gmail.com>
References: <1421319545-23920-1-git-send-email-digetx@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7232398abc6a ("ARM: tegra: Convert PMC to a driver") changed tegra_resume()
location storing from late to early and, as a result, broke suspend on Tegra20.
PMC scratch register 41 is used by tegra LP1 resume code for retrieving stored
physical memory address of common resume function and in the same time used by
tegra20_cpu_shutdown() (shared by Tegra20 cpuidle driver and platform SMP code),
which is storing CPU1 "resettable" status. It implies strict order of scratch
register usage, otherwise resume function address is lost on Tegra20 after
disabling non-boot CPU's on suspend. Fix it by storing tegra_resume() physical
address in IRAM instead of PMC scratch register.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Fixes: 7232398abc6a (ARM: tegra: Convert PMC to a driver)
Cc: <stable@vger.kernel.org> # v3.17+
---
 arch/arm/mach-tegra/pm.c            |  3 +++
 arch/arm/mach-tegra/reset-handler.S |  4 ++++
 arch/arm/mach-tegra/reset.h         |  4 ++++
 arch/arm/mach-tegra/sleep-tegra20.S |  7 ++++---
 arch/arm/mach-tegra/sleep-tegra30.S |  7 ++++---
 drivers/soc/tegra/pmc.c             | 19 -------------------
 6 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/arch/arm/mach-tegra/pm.c b/arch/arm/mach-tegra/pm.c
index b0f48a3..f11e129 100644
--- a/arch/arm/mach-tegra/pm.c
+++ b/arch/arm/mach-tegra/pm.c
@@ -395,6 +395,9 @@ void __init tegra_init_suspend(void)
 		break;
 	}
 
+	/* Store common resume function physical address in IRAM */
+	writel_relaxed(virt_to_phys(tegra_resume), tegra_resume_func_phys_addr);
+
 	suspend_set_ops(&tegra_suspend_ops);
 }
 #endif
diff --git a/arch/arm/mach-tegra/reset-handler.S b/arch/arm/mach-tegra/reset-handler.S
index 7b2baab..659557b 100644
--- a/arch/arm/mach-tegra/reset-handler.S
+++ b/arch/arm/mach-tegra/reset-handler.S
@@ -280,6 +280,10 @@ __tegra_cpu_reset_handler_data:
 	.rept	TEGRA_RESET_DATA_SIZE
 	.long	0
 	.endr
+	.globl	__tegra_resume_func_addr_offset
+	.equ	__tegra_resume_func_addr_offset, \
+					. - __tegra_cpu_reset_handler_start
+	.long	0
 	.align L1_CACHE_SHIFT
 
 ENTRY(__tegra_cpu_reset_handler_end)
diff --git a/arch/arm/mach-tegra/reset.h b/arch/arm/mach-tegra/reset.h
index 76a9343..1b43f19 100644
--- a/arch/arm/mach-tegra/reset.h
+++ b/arch/arm/mach-tegra/reset.h
@@ -36,6 +36,7 @@ extern unsigned long __tegra_cpu_reset_handler_data[TEGRA_RESET_DATA_SIZE];
 void __tegra_cpu_reset_handler_start(void);
 void __tegra_cpu_reset_handler(void);
 void __tegra_cpu_reset_handler_end(void);
+void __tegra_resume_func_addr_offset(void);
 void tegra_secondary_startup(void);
 
 #ifdef CONFIG_PM_SLEEP
@@ -47,6 +48,9 @@ void tegra_secondary_startup(void);
 	(IO_ADDRESS(TEGRA_IRAM_BASE + TEGRA_IRAM_RESET_HANDLER_OFFSET + \
 	((u32)&__tegra_cpu_reset_handler_data[TEGRA_RESET_MASK_LP2] - \
 	 (u32)__tegra_cpu_reset_handler_start)))
+#define tegra_resume_func_phys_addr \
+	(IO_ADDRESS(TEGRA_IRAM_BASE + TEGRA_IRAM_RESET_HANDLER_OFFSET + \
+	 (u32)__tegra_resume_func_addr_offset))
 #endif
 
 #define tegra_cpu_reset_handler_offset \
diff --git a/arch/arm/mach-tegra/sleep-tegra20.S b/arch/arm/mach-tegra/sleep-tegra20.S
index be4bc5f..bea484f8 100644
--- a/arch/arm/mach-tegra/sleep-tegra20.S
+++ b/arch/arm/mach-tegra/sleep-tegra20.S
@@ -327,7 +327,7 @@ tegra20_iram_start:
  * system clock running on the same PLL that it suspended at), and
  * jumps to tegra_resume to restore virtual addressing and PLLX.
  * The physical address of tegra_resume expected to be stored in
- * PMC_SCRATCH41.
+ * IRAM reset handler area.
  *
  * NOTE: THIS *MUST* BE RELOCATED TO TEGRA_IRAM_LPx_RESUME_AREA.
  */
@@ -400,8 +400,9 @@ exit_selfrefresh_loop:
 	mov	r1, #0			@ unstall all transactions
 	str	r1, [r0, #EMC_REQ_CTRL]
 
-	mov32	r0, TEGRA_PMC_BASE
-	ldr	r0, [r0, #PMC_SCRATCH41]
+	mov32	r0, TEGRA_IRAM_BASE + TEGRA_IRAM_RESET_HANDLER_OFFSET
+	ldr 	r1, =__tegra_resume_func_addr_offset
+	ldr	r0, [r0, r1]
 	ret	r0			@ jump to tegra_resume
 ENDPROC(tegra20_lp1_reset)
 
diff --git a/arch/arm/mach-tegra/sleep-tegra30.S b/arch/arm/mach-tegra/sleep-tegra30.S
index 5d8d13a..b05f22c 100644
--- a/arch/arm/mach-tegra/sleep-tegra30.S
+++ b/arch/arm/mach-tegra/sleep-tegra30.S
@@ -314,7 +314,7 @@ tegra30_iram_start:
  * system clock running on the same PLL that it suspended at), and
  * jumps to tegra_resume to restore virtual addressing.
  * The physical address of tegra_resume expected to be stored in
- * PMC_SCRATCH41.
+ * IRAM reset handler area.
  *
  * NOTE: THIS *MUST* BE RELOCATED TO TEGRA_IRAM_LPx_RESUME_AREA.
  */
@@ -528,8 +528,9 @@ zcal_done:
 	bne	exit_self_refresh
 __no_dual_emc_chanl:
 
-	mov32	r0, TEGRA_PMC_BASE
-	ldr	r0, [r0, #PMC_SCRATCH41]
+	mov32	r0, TEGRA_IRAM_BASE + TEGRA_IRAM_RESET_HANDLER_OFFSET
+	ldr 	r1, =__tegra_resume_func_addr_offset
+	ldr	r0, [r0, r1]
 	ret	r0			@ jump to tegra_resume
 ENDPROC(tegra30_lp1_reset)
 
diff --git a/drivers/soc/tegra/pmc.c b/drivers/soc/tegra/pmc.c
index a2c0ceb..b87ead2 100644
--- a/drivers/soc/tegra/pmc.c
+++ b/drivers/soc/tegra/pmc.c
@@ -739,24 +739,6 @@ static int tegra_pmc_probe(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
-static int tegra_pmc_suspend(struct device *dev)
-{
-	tegra_pmc_writel(virt_to_phys(tegra_resume), PMC_SCRATCH41);
-
-	return 0;
-}
-
-static int tegra_pmc_resume(struct device *dev)
-{
-	tegra_pmc_writel(0x0, PMC_SCRATCH41);
-
-	return 0;
-}
-#endif
-
-static SIMPLE_DEV_PM_OPS(tegra_pmc_pm_ops, tegra_pmc_suspend, tegra_pmc_resume);
-
 static const char * const tegra20_powergates[] = {
 	[TEGRA_POWERGATE_CPU] = "cpu",
 	[TEGRA_POWERGATE_3D] = "3d",
@@ -894,7 +876,6 @@ static struct platform_driver tegra_pmc_driver = {
 		.name = "tegra-pmc",
 		.suppress_bind_attrs = true,
 		.of_match_table = tegra_pmc_match,
-		.pm = &tegra_pmc_pm_ops,
 	},
 	.probe = tegra_pmc_probe,
 };
-- 
2.2.1


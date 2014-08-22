Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbaHVODD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:03:03 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43959 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756523AbaHVOC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:02:59 -0400
From: Nishanth Menon <nm@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 05/10] ARM: OMAP5 / DRA7: PM: Avoid all SAR saves
Date: Fri, 22 Aug 2014 09:02:29 -0500
Message-ID: <1408716154-26101-6-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408716154-26101-1-git-send-email-nm@ti.com>
References: <1408716154-26101-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajendra Nayak <rnayak@ti.com>

Get rid of all assumptions about always having a sar base on *all*
OMAP4+ platforms. We dont need one on DRA7 and it is not necessary at
this point for OMAP5 either.

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
[nm@ti.com: Split and optimize]
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/omap-mpuss-lowpower.c |   55 ++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-omap2/omap-mpuss-lowpower.c b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
index fad6e8c..53d8de5 100644
--- a/arch/arm/mach-omap2/omap-mpuss-lowpower.c
+++ b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
@@ -118,7 +118,8 @@ static inline void set_cpu_wakeup_addr(unsigned int cpu_id, u32 addr)
 {
 	struct omap4_cpu_pm_info *pm_info = &per_cpu(omap4_pm_info, cpu_id);
 
-	writel_relaxed(addr, pm_info->wkup_sar_addr);
+	if (pm_info->wkup_sar_addr)
+		writel_relaxed(addr, pm_info->wkup_sar_addr);
 }
 
 /*
@@ -143,7 +144,8 @@ static void scu_pwrst_prepare(unsigned int cpu_id, unsigned int cpu_state)
 		break;
 	}
 
-	writel_relaxed(scu_pwr_st, pm_info->scu_sar_addr);
+	if (pm_info->scu_sar_addr)
+		writel_relaxed(scu_pwr_st, pm_info->scu_sar_addr);
 }
 
 /* Helper functions for MPUSS OSWR */
@@ -181,7 +183,8 @@ static void l2x0_pwrst_prepare(unsigned int cpu_id, unsigned int save_state)
 {
 	struct omap4_cpu_pm_info *pm_info = &per_cpu(omap4_pm_info, cpu_id);
 
-	writel_relaxed(save_state, pm_info->l2x0_sar_addr);
+	if (pm_info->l2x0_sar_addr)
+		writel_relaxed(save_state, pm_info->l2x0_sar_addr);
 }
 
 /*
@@ -191,10 +194,14 @@ static void l2x0_pwrst_prepare(unsigned int cpu_id, unsigned int save_state)
 #ifdef CONFIG_CACHE_L2X0
 static void __init save_l2x0_context(void)
 {
-	writel_relaxed(l2x0_saved_regs.aux_ctrl,
-		     sar_base + L2X0_AUXCTRL_OFFSET);
-	writel_relaxed(l2x0_saved_regs.prefetch_ctrl,
-		     sar_base + L2X0_PREFETCH_CTRL_OFFSET);
+	void __iomem *l2x0_base = omap4_get_l2cache_base();
+
+	if (l2x0_base && sar_base) {
+		writel_relaxed(l2x0_saved_regs.aux_ctrl,
+			       sar_base + L2X0_AUXCTRL_OFFSET);
+		writel_relaxed(l2x0_saved_regs.prefetch_ctrl,
+			       sar_base + L2X0_PREFETCH_CTRL_OFFSET);
+	}
 }
 #else
 static void __init save_l2x0_context(void)
@@ -347,13 +354,17 @@ int __init omap4_mpuss_init(void)
 		return -ENODEV;
 	}
 
-	sar_base = omap4_get_sar_ram_base();
+	if (cpu_is_omap44xx())
+		sar_base = omap4_get_sar_ram_base();
 
 	/* Initilaise per CPU PM information */
 	pm_info = &per_cpu(omap4_pm_info, 0x0);
-	pm_info->scu_sar_addr = sar_base + SCU_OFFSET0;
-	pm_info->wkup_sar_addr = sar_base + CPU0_WAKEUP_NS_PA_ADDR_OFFSET;
-	pm_info->l2x0_sar_addr = sar_base + L2X0_SAVE_OFFSET0;
+	if (sar_base) {
+		pm_info->scu_sar_addr = sar_base + SCU_OFFSET0;
+		pm_info->wkup_sar_addr = sar_base +
+					CPU0_WAKEUP_NS_PA_ADDR_OFFSET;
+		pm_info->l2x0_sar_addr = sar_base + L2X0_SAVE_OFFSET0;
+	}
 	pm_info->pwrdm = pwrdm_lookup("cpu0_pwrdm");
 	if (!pm_info->pwrdm) {
 		pr_err("Lookup failed for CPU0 pwrdm\n");
@@ -368,9 +379,12 @@ int __init omap4_mpuss_init(void)
 	pwrdm_set_next_pwrst(pm_info->pwrdm, PWRDM_POWER_ON);
 
 	pm_info = &per_cpu(omap4_pm_info, 0x1);
-	pm_info->scu_sar_addr = sar_base + SCU_OFFSET1;
-	pm_info->wkup_sar_addr = sar_base + CPU1_WAKEUP_NS_PA_ADDR_OFFSET;
-	pm_info->l2x0_sar_addr = sar_base + L2X0_SAVE_OFFSET1;
+	if (sar_base) {
+		pm_info->scu_sar_addr = sar_base + SCU_OFFSET1;
+		pm_info->wkup_sar_addr = sar_base +
+					CPU1_WAKEUP_NS_PA_ADDR_OFFSET;
+		pm_info->l2x0_sar_addr = sar_base + L2X0_SAVE_OFFSET1;
+	}
 	if (cpu_is_omap446x())
 		pm_info->secondary_startup = omap4460_secondary_startup;
 	else
@@ -397,13 +411,12 @@ int __init omap4_mpuss_init(void)
 	pwrdm_clear_all_prev_pwrst(mpuss_pd);
 	mpuss_clear_prev_logic_pwrst();
 
-	/* Save device type on scratchpad for low level code to use */
-	if (omap_type() != OMAP2_DEVICE_TYPE_GP)
-		writel_relaxed(1, sar_base + OMAP_TYPE_OFFSET);
-	else
-		writel_relaxed(0, sar_base + OMAP_TYPE_OFFSET);
-
-	save_l2x0_context();
+	if (sar_base) {
+		/* Save device type on scratchpad for low level code to use */
+		writel_relaxed((omap_type() != OMAP2_DEVICE_TYPE_GP) ? 1 : 0,
+			       sar_base + OMAP_TYPE_OFFSET);
+		save_l2x0_context();
+	}
 
 	if (cpu_is_omap44xx()) {
 		omap_pm_ops.finish_suspend = omap4_finish_suspend;
-- 
1.7.9.5


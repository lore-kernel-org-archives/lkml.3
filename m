Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbaFJXPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:15:51 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:37012 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbaFJXPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:15:48 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Jason Cooper <jason@lakedaemon.net>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [RFC] irqchip: gic: always mask interrupts during suspend
Date: Tue, 10 Jun 2014 16:14:58 -0700
Message-Id: <1402442098-21093-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core kernel IRQ code will disable all non-wakeup interrupts before
suspend, but because the GIC uses lazy masking (i.e., it doesn't mask
interrupts, but only disables them logically), we still might be
processing interrupts after the last call for interrupts
(check_wakeup_irqs()). This can cause various problems, so let's just
always mask our interrupts before suspend.

Several platforms already tweak the GIC irqchip flags to do this (and
I'm working on bringing up another platform that needs this), so let's
just set IRQCHIP_MASK_ON_SUSPEND by default.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org
---
This is just an RFC. If it is acceptable, I'll need to break it up for
application to each sub-arch tree.

I really don't like the gic_arch_extn approach to customizing the GIC driver,
so I thought this was one opportunity to unify some platform code. If this
approach isn't accpetable, I can simply add this flag to my own machine init
code. But I thought this was a good starting place for discussion about this
odd piece of code.

Other random thought: it seems like any irqchip driver which does lazy IRQ
masking ought to use IRQCHIP_MASK_ON_SUSPEND. So maybe the IRQ core should just
do something like:

	if (!chip->irq_disable)
		chip->flags |= IRQCHIP_MASK_ON_SUSPEND;
		
 arch/arm/mach-omap2/omap-wakeupgen.c | 2 +-
 arch/arm/mach-tegra/irq.c            | 1 -
 arch/arm/mach-ux500/cpu.c            | 2 +-
 arch/arm/mach-zynq/common.c          | 2 +-
 drivers/irqchip/irq-gic.c            | 1 +
 5 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/omap-wakeupgen.c b/arch/arm/mach-omap2/omap-wakeupgen.c
index 37843a7d3639..c9c12ea6dd09 100644
--- a/arch/arm/mach-omap2/omap-wakeupgen.c
+++ b/arch/arm/mach-omap2/omap-wakeupgen.c
@@ -440,7 +440,7 @@ int __init omap_wakeupgen_init(void)
 	 */
 	gic_arch_extn.irq_mask = wakeupgen_mask;
 	gic_arch_extn.irq_unmask = wakeupgen_unmask;
-	gic_arch_extn.flags = IRQCHIP_MASK_ON_SUSPEND | IRQCHIP_SKIP_SET_WAKE;
+	gic_arch_extn.flags = IRQCHIP_SKIP_SET_WAKE;
 
 	/*
 	 * FIXME: Add support to set_smp_affinity() once the core
diff --git a/arch/arm/mach-tegra/irq.c b/arch/arm/mach-tegra/irq.c
index 1a74d562dca1..6f0529021520 100644
--- a/arch/arm/mach-tegra/irq.c
+++ b/arch/arm/mach-tegra/irq.c
@@ -281,7 +281,6 @@ void __init tegra_init_irq(void)
 	gic_arch_extn.irq_unmask = tegra_unmask;
 	gic_arch_extn.irq_retrigger = tegra_retrigger;
 	gic_arch_extn.irq_set_wake = tegra_set_wake;
-	gic_arch_extn.flags = IRQCHIP_MASK_ON_SUSPEND;
 
 	/*
 	 * Check if there is a devicetree present, since the GIC will be
diff --git a/arch/arm/mach-ux500/cpu.c b/arch/arm/mach-ux500/cpu.c
index db16b5a04ad5..ce2bfe39dd82 100644
--- a/arch/arm/mach-ux500/cpu.c
+++ b/arch/arm/mach-ux500/cpu.c
@@ -52,7 +52,7 @@ void ux500_restart(enum reboot_mode mode, const char *cmd)
 */
 void __init ux500_init_irq(void)
 {
-	gic_arch_extn.flags = IRQCHIP_SKIP_SET_WAKE | IRQCHIP_MASK_ON_SUSPEND;
+	gic_arch_extn.flags = IRQCHIP_SKIP_SET_WAKE;
 	irqchip_init();
 
 	/*
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 31a6fa40ba37..6defcea545d6 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -182,7 +182,7 @@ static void __init zynq_map_io(void)
 
 static void __init zynq_irq_init(void)
 {
-	gic_arch_extn.flags = IRQCHIP_SKIP_SET_WAKE | IRQCHIP_MASK_ON_SUSPEND;
+	gic_arch_extn.flags = IRQCHIP_SKIP_SET_WAKE;
 	irqchip_init();
 }
 
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 7e11c9d6ae8c..0117e36a3bbd 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -1032,6 +1032,7 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 	}
 
 	gic_chip.flags |= gic_arch_extn.flags;
+	gic_chip.flags |= IRQCHIP_MASK_ON_SUSPEND;
 	gic_dist_init(gic);
 	gic_cpu_init(gic);
 	gic_pm_init(gic);
-- 
1.9.1


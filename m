Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaLCNoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:44:03 -0500
Received: from laurent.telenet-ops.be ([195.130.137.89]:53284 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbaLCNl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:41:58 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v6 5/7] ARM: shmobile: R-Mobile: Add DT support for PM domains
Date: Wed,  3 Dec 2014 14:41:45 +0100
Message-Id: <1417614107-5985-6-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417614107-5985-1-git-send-email-geert+renesas@glider.be>
References: <1417614107-5985-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Populate the PM domains from DT, and provide support to hook up devices
to their respective PM domain.

The always-on power area (e.g. C5 on r8a7740) is created as a PM domain
without software control, to allow Run-Time management of module clocks
for hardware blocks inside this area.

Special cases like PM domains containing CPUs, the console device, or
Coresight-ETM, are handled by scanning the DT topology.

As long as the ARM debug/perf code doesn't use resource management with
runtime PM support, the power area containing Coresight-ETM (e.g. D4 on
r8a7740) must be kept powered to avoid a crash during resume from s2ram
(dbg_cpu_pm_notify() calls reset_ctrl_regs() unconditionally, causing an
undefined instruction oops).

Initialization is done from core_initcall(), as the
"renesas,intc-irqpin" driver uses postcore_initcall().

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v6:
  - Drop support for PM domain power-on/off latencies, as they're put on
    hold,
v5:
  - No changes,
v4:
  - Always keep D4 powered, until the new Coresight code handles runtime
    PM,
v3:
  - Remove limitations, as fixes for the interrupt storm (A4MP) and
    crash (D4) are available,
  - Scan DT topology to identify special PM domains,
  - Add dependency on chosen/stdout-path,
v2:
  - Fix typo "CPU is _not_ in use",
  - Include build glue,
  - Remove paragraph about missing functionality compared to the legacy
    case, as it is no longer missing (runtime management of module
    clocks, device latencies).
---
 arch/arm/mach-shmobile/Kconfig      |   3 +-
 arch/arm/mach-shmobile/pm-rmobile.c | 215 +++++++++++++++++++++++++++++++++++-
 arch/arm/mach-shmobile/pm-rmobile.h |   2 +-
 3 files changed, 216 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
index 1b4fafe524ffeb41..76b80e512f7a8ebb 100644
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@ -7,6 +7,7 @@ config PM_RCAR
 
 config PM_RMOBILE
 	bool
+	select PM_GENERIC_DOMAINS
 
 config ARCH_RCAR_GEN1
 	bool
@@ -23,7 +24,7 @@ config ARCH_RCAR_GEN2
 
 config ARCH_RMOBILE
 	bool
-	select PM_RMOBILE if PM && !ARCH_SHMOBILE_MULTI
+	select PM_RMOBILE if PM
 	select SYS_SUPPORTS_SH_CMT
 	select SYS_SUPPORTS_SH_TMU
 
diff --git a/arch/arm/mach-shmobile/pm-rmobile.c b/arch/arm/mach-shmobile/pm-rmobile.c
index 0258b00aacc94c8f..f540096c05f6eabd 100644
--- a/arch/arm/mach-shmobile/pm-rmobile.c
+++ b/arch/arm/mach-shmobile/pm-rmobile.c
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2012  Renesas Solutions Corp.
  * Copyright (C) 2012  Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
+ * Copyright (C) 2014  Glider bvba
  *
  * based on pm-sh7372.c
  *  Copyright (C) 2011 Magnus Damm
@@ -13,10 +14,16 @@
  */
 #include <linux/console.h>
 #include <linux/delay.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/pm_clock.h>
+#include <linux/slab.h>
+
 #include <asm/io.h>
+
 #include "pm-rmobile.h"
 
 /* SYSC */
@@ -30,8 +37,12 @@
 static int rmobile_pd_power_down(struct generic_pm_domain *genpd)
 {
 	struct rmobile_pm_domain *rmobile_pd = to_rmobile_pd(genpd);
-	unsigned int mask = 1 << rmobile_pd->bit_shift;
+	unsigned int mask;
+
+	if (rmobile_pd->bit_shift == ~0)
+		return -EBUSY;
 
+	mask = 1 << rmobile_pd->bit_shift;
 	if (rmobile_pd->suspend) {
 		int ret = rmobile_pd->suspend();
 
@@ -61,10 +72,14 @@ static int rmobile_pd_power_down(struct generic_pm_domain *genpd)
 static int __rmobile_pd_power_up(struct rmobile_pm_domain *rmobile_pd,
 				 bool do_resume)
 {
-	unsigned int mask = 1 << rmobile_pd->bit_shift;
+	unsigned int mask;
 	unsigned int retry_count;
 	int ret = 0;
 
+	if (rmobile_pd->bit_shift == ~0)
+		return 0;
+
+	mask = 1 << rmobile_pd->bit_shift;
 	if (__raw_readl(rmobile_pd->base + PSTR) & mask)
 		goto out;
 
@@ -157,6 +172,8 @@ static void rmobile_init_pm_domain(struct rmobile_pm_domain *rmobile_pd)
 	__rmobile_pd_power_up(rmobile_pd, false);
 }
 
+#ifdef CONFIG_ARCH_SHMOBILE_LEGACY
+
 void rmobile_init_domains(struct rmobile_pm_domain domains[], int num)
 {
 	int j;
@@ -189,3 +206,197 @@ void rmobile_add_devices_to_domains(struct pm_domain_device data[],
 		rmobile_add_device_to_domain_td(data[j].domain_name,
 						data[j].pdev, &latencies);
 }
+
+#else /* !CONFIG_ARCH_SHMOBILE_LEGACY */
+
+static int rmobile_pd_suspend_cpu(void)
+{
+	/*
+	 * This domain contains the CPU core and therefore it should
+	 * only be turned off if the CPU is not in use.
+	 */
+	return -EBUSY;
+}
+
+static int rmobile_pd_suspend_console(void)
+{
+	/*
+	 * Serial consoles make use of SCIF hardware located in this domain,
+	 * hence keep the power domain on if "no_console_suspend" is set.
+	 */
+	return console_suspend_enabled ? 0 : -EBUSY;
+}
+
+static int rmobile_pd_suspend_debug(void)
+{
+	/*
+	 * This domain contains the Coresight-ETM hardware block and
+	 * therefore it should only be turned off if the debug module is
+	 * not in use.
+	 */
+	return -EBUSY;
+}
+
+#define MAX_NUM_CPU_PDS		8
+
+static unsigned int num_cpu_pds __initdata;
+static struct device_node *cpu_pds[MAX_NUM_CPU_PDS] __initdata;
+static struct device_node *console_pd __initdata;
+static struct device_node *debug_pd __initdata;
+
+static void __init get_special_pds(void)
+{
+	struct device_node *np, *pd;
+	unsigned int i;
+
+	/* PM domains containing CPUs */
+	for_each_node_by_type(np, "cpu") {
+		pd = of_parse_phandle(np, "power-domains", 0);
+		if (!pd)
+			continue;
+
+		for (i = 0; i < num_cpu_pds; i++)
+			if (pd == cpu_pds[i])
+				break;
+
+		if (i < num_cpu_pds) {
+			of_node_put(pd);
+			continue;
+		}
+
+		if (num_cpu_pds == MAX_NUM_CPU_PDS) {
+			pr_warn("Too many CPU PM domains\n");
+			of_node_put(pd);
+			continue;
+		}
+
+		cpu_pds[num_cpu_pds++] = pd;
+	}
+
+	/* PM domain containing console */
+	if (of_stdout)
+		console_pd = of_parse_phandle(of_stdout, "power-domains", 0);
+
+	/* PM domain containing Coresight-ETM */
+	np = of_find_compatible_node(NULL, NULL, "arm,coresight-etm3x");
+	if (np)
+		debug_pd = of_parse_phandle(np, "power-domains", 0);
+}
+
+static void __init put_special_pds(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < num_cpu_pds; i++)
+		of_node_put(cpu_pds[i]);
+	of_node_put(console_pd);
+	of_node_put(debug_pd);
+}
+
+static bool __init pd_contains_cpu(const struct device_node *pd)
+{
+	unsigned int i;
+
+	for (i = 0; i < num_cpu_pds; i++)
+		if (pd == cpu_pds[i])
+			return true;
+
+	return false;
+}
+
+static void __init rmobile_setup_pm_domain(struct device_node *np,
+					   struct rmobile_pm_domain *pd)
+{
+	const char *name = pd->genpd.name;
+
+	if (pd_contains_cpu(np)) {
+		pr_debug("PM domain %s contains CPU\n", name);
+		pd->gov = &pm_domain_always_on_gov;
+		pd->suspend = rmobile_pd_suspend_cpu;
+	} else if (np == console_pd) {
+		pr_debug("PM domain %s contains serial console\n", name);
+		pd->gov = &pm_domain_always_on_gov;
+		pd->suspend = rmobile_pd_suspend_console;
+	} else if (np == debug_pd) {
+		pr_debug("PM domain %s contains Coresight-ETM\n", name);
+		pd->gov = &pm_domain_always_on_gov;
+		pd->suspend = rmobile_pd_suspend_debug;
+	}
+
+	rmobile_init_pm_domain(pd);
+}
+
+static int __init rmobile_add_pm_domains(void __iomem *base,
+					 struct device_node *parent,
+					 struct generic_pm_domain *genpd_parent)
+{
+	struct device_node *np;
+
+	for_each_child_of_node(parent, np) {
+		struct rmobile_pm_domain *pd;
+		u32 idx = ~0;
+
+		if (of_property_read_u32(np, "reg", &idx)) {
+			/* always-on domain */
+		}
+
+		pd = kzalloc(sizeof(*pd), GFP_KERNEL);
+		if (!pd)
+			return -ENOMEM;
+
+		pd->genpd.name = np->name;
+		pd->base = base;
+		pd->bit_shift = idx;
+
+		rmobile_setup_pm_domain(np, pd);
+		if (genpd_parent)
+			pm_genpd_add_subdomain(genpd_parent, &pd->genpd);
+		of_genpd_add_provider_simple(np, &pd->genpd);
+
+		rmobile_add_pm_domains(base, np, &pd->genpd);
+	}
+	return 0;
+}
+
+static int __init rmobile_init_pm_domains(void)
+{
+	struct device_node *np, *pmd;
+	bool scanned = false;
+	void __iomem *base;
+	int ret = 0;
+
+	for_each_compatible_node(np, NULL, "renesas,sysc-rmobile") {
+		base = of_iomap(np, 0);
+		if (!base) {
+			pr_warn("%s cannot map reg 0\n", np->full_name);
+			continue;
+		}
+
+		pmd = of_find_node_by_name(np, "pm-domains");
+		if (!pmd) {
+			pr_warn("%s lacks pm-domains node\n", np->full_name);
+			continue;
+		}
+
+		if (!scanned) {
+			/* Find PM domains containing special blocks */
+			get_special_pds();
+			scanned = true;
+		}
+
+		ret = rmobile_add_pm_domains(base, pmd, NULL);
+		of_node_put(pmd);
+		if (ret) {
+			of_node_put(np);
+			break;
+		}
+	}
+
+	put_special_pds();
+
+	return ret;
+}
+
+core_initcall(rmobile_init_pm_domains);
+
+#endif /* !CONFIG_ARCH_SHMOBILE_LEGACY */
diff --git a/arch/arm/mach-shmobile/pm-rmobile.h b/arch/arm/mach-shmobile/pm-rmobile.h
index 0602130bb260c31d..53219786f539fa24 100644
--- a/arch/arm/mach-shmobile/pm-rmobile.h
+++ b/arch/arm/mach-shmobile/pm-rmobile.h
@@ -37,7 +37,7 @@ struct pm_domain_device {
 	struct platform_device *pdev;
 };
 
-#ifdef CONFIG_PM_RMOBILE
+#if defined(CONFIG_PM_RMOBILE) && defined(CONFIG_ARCH_SHMOBILE_LEGACY)
 extern void rmobile_init_domains(struct rmobile_pm_domain domains[], int num);
 extern void rmobile_add_device_to_domain_td(const char *domain_name,
 					    struct platform_device *pdev,
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbaIHNgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:36:37 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:58868 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbaIHNgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:36:00 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH/RFC 4/5] ARM: shmobile: R-Mobile: Add DT support for PM domains
Date: Mon,  8 Sep 2014 15:35:43 +0200
Message-Id: <1410183344-14756-5-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410183344-14756-1-git-send-email-geert+renesas@glider.be>
References: <1410183344-14756-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Populate the PM domains from DT, and provide support to hook up devices
to their respective PM domain.

The always-on power area (e.g. C5 on r8a7740) is created as a PM domain
without software control, to allow Run-Time management of module clocks
for hardware blocks inside this area in the future.
Power-on/off latencies are supported.

Limitations and special cases in the non-DT case are handled through
rmobile_pm_quirks(). Checks for hardcoded PM domain indices should be
replaced by the analysis of relations between devices and PM domains in
DT.

Initialization is done from core_initcall(), as the
"renesas,intc-irqpin" driver uses postcore_initcall().

This is functionally almost equivalent to the non-DT case. Missing are
Run-Time management of the module clocks (pm_clk_*()), and device
latencies.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm/mach-shmobile/Kconfig      |   3 +-
 arch/arm/mach-shmobile/pm-rmobile.c | 145 +++++++++++++++++++++++++++++++++++-
 2 files changed, 145 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
index 21f457b56c01..ad007d3b384f 100644
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@ -6,6 +6,7 @@ config PM_RCAR
 
 config PM_RMOBILE
 	bool
+	select PM_GENERIC_DOMAINS
 
 config ARCH_RCAR_GEN1
 	bool
@@ -21,7 +22,7 @@ config ARCH_RCAR_GEN2
 
 config ARCH_RMOBILE
 	bool
-	select PM_RMOBILE if PM && !ARCH_SHMOBILE_MULTI
+	select PM_RMOBILE if PM
 	select SYS_SUPPORTS_SH_CMT
 	select SYS_SUPPORTS_SH_TMU
 
diff --git a/arch/arm/mach-shmobile/pm-rmobile.c b/arch/arm/mach-shmobile/pm-rmobile.c
index 578446af6e7b..5628bf2b0cb7 100644
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
@@ -13,9 +14,13 @@
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
 #include <asm/io.h>
 #include "pm-rmobile.h"
 
@@ -30,8 +35,12 @@
 static int rmobile_pd_power_down(struct generic_pm_domain *genpd)
 {
 	struct rmobile_pm_domain *rmobile_pd = to_rmobile_pd(genpd);
-	unsigned int mask = 1 << rmobile_pd->bit_shift;
+	unsigned int mask;
 
+	if (rmobile_pd->bit_shift == ~0)
+		return -EBUSY;
+
+	mask = 1 << rmobile_pd->bit_shift;
 	if (rmobile_pd->suspend) {
 		int ret = rmobile_pd->suspend();
 
@@ -61,10 +70,14 @@ static int rmobile_pd_power_down(struct generic_pm_domain *genpd)
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
 
@@ -117,6 +130,8 @@ static void rmobile_init_pm_domain(struct rmobile_pm_domain *rmobile_pd)
 	__rmobile_pd_power_up(rmobile_pd, false);
 }
 
+#ifdef CONFIG_ARCH_SHMOBILE_LEGACY
+
 void rmobile_init_domains(struct rmobile_pm_domain domains[], int num)
 {
 	int j;
@@ -132,6 +147,7 @@ void rmobile_add_device_to_domain_td(const char *domain_name,
 	struct device *dev = &pdev->dev;
 
 	__pm_genpd_name_add_device(domain_name, dev, td);
+	// FIXME Not yet done from DT
 	if (pm_clk_no_clocks(dev))
 		pm_clk_add(dev, NULL);
 }
@@ -139,6 +155,7 @@ void rmobile_add_device_to_domain_td(const char *domain_name,
 void rmobile_add_devices_to_domains(struct pm_domain_device data[],
 				    int size)
 {
+	// FIXME Not yet done from DT
 	struct gpd_timing_data latencies = {
 		.stop_latency_ns = DEFAULT_DEV_LATENCY_NS,
 		.start_latency_ns = DEFAULT_DEV_LATENCY_NS,
@@ -151,3 +168,127 @@ void rmobile_add_devices_to_domains(struct pm_domain_device data[],
 		rmobile_add_device_to_domain_td(data[j].domain_name,
 						data[j].pdev, &latencies);
 }
+
+#else /* !CONFIG_ARCH_SHMOBILE_LEGACY */
+
+static int r8a7740_pd_a4s_suspend(void)
+{
+	/*
+	 * The A4S domain contains the CPU core and therefore it should
+	 * only be turned off if the CPU is in use.
+	 */
+	return -EBUSY;
+}
+
+static int r8a7740_pd_a3sp_suspend(void)
+{
+	/*
+	 * Serial consoles make use of SCIF hardware located in A3SP,
+	 * keep such power domain on if "no_console_suspend" is set.
+	 */
+	return console_suspend_enabled ? 0 : -EBUSY;
+}
+
+// FIXME Quirks
+static bool rmobile_pm_quirks(struct rmobile_pm_domain *pd)
+{
+	unsigned int idx = pd->bit_shift;
+	const char *name = pd->genpd.name;
+
+	if (idx == 2 || idx == 3) {
+		// Do not enable
+		pr_info("Skipping pm domain %s\n", name);
+		return false;
+	}
+	if (idx == 10) {
+		pr_info("%s is parent of CPU domain\n", name);
+		pd->gov = &pm_domain_always_on_gov;
+		pd->suspend = r8a7740_pd_a4s_suspend;
+	}
+	if (idx == 11) {
+		pr_info("%s contains serial console\n", name);
+		pd->gov = &pm_domain_always_on_gov;
+		pd->suspend = r8a7740_pd_a3sp_suspend;
+	}
+	if (idx == 12) {
+		pr_info("%s contains CPU\n", name);
+		pd->gov = &pm_domain_always_on_gov;
+	}
+
+	return true;
+}
+
+static int rmobile_add_pm_domains(void __iomem *base,
+				  struct device_node *parent,
+				  struct generic_pm_domain *genpd_parent)
+{
+	struct device_node *np;
+
+	for_each_child_of_node(parent, np) {
+		struct rmobile_pm_domain *pd;
+		u32 idx = ~0;
+		u32 latency;
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
+		if (!of_property_read_u32(np, "power-on-latency", &latency))
+			pd->genpd.power_on_latency_ns = latency;
+		if (!of_property_read_u32(np, "power-off-latency", &latency))
+			pd->genpd.power_off_latency_ns = latency;
+		pd->base = base;
+		pd->bit_shift = idx;
+
+		if (!rmobile_pm_quirks(pd)) {
+			kfree(pd);
+			continue;
+		}
+
+		rmobile_init_pm_domain(pd);
+		if (genpd_parent)
+			pm_genpd_add_subdomain(genpd_parent, &pd->genpd);
+
+		of_genpd_add_provider_simple(np, &pd->genpd);
+
+		rmobile_add_pm_domains(base, np, &pd->genpd);
+	}
+	return 0;
+}
+
+static __init int rmobile_init_pm_domains(void)
+{
+	struct device_node *np, *pmd;
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
+		ret = rmobile_add_pm_domains(base, pmd, NULL);
+		of_node_put(pmd);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
+core_initcall(rmobile_init_pm_domains);
+
+#endif /* !CONFIG_ARCH_SHMOBILE_LEGACY */
-- 
1.9.1


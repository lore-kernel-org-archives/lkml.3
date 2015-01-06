Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbbAFQix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:38:53 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:33489 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbbAFQhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:37:55 -0500
From: mathieu.poirier@linaro.org
To: liviu.dudau@arm.com, sudeep.holla@arm.com, lorenzo.pieralisi@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org, patches@linaro.org
Subject: [PATCH 7/9] ARM: vexpress/TC2: Add generic power domain awareness to scp driver
Date: Tue,  6 Jan 2015 09:37:11 -0700
Message-Id: <1420562233-2015-8-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420562233-2015-1-git-send-email-mathieu.poirier@linaro.org>
References: <1420562233-2015-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

This patch makes use of the generic power domain API to model the
power domains associated to the A7 and A15 clusters.  From there
any IP block (like coresight tracers) that are part of those domains
can register with the runtime pm core to guarantee that other
components won't inadvertently switch off the power while they are
being used.

The logic associated to the generic power domains doesn't take
care of swithing off the clusters - it simply monitors when other
components need the clusters to remain powered.  Proceeding this
way costs just a little more power but the system is already in
diagnostic mode (coresight), making the argument irrelevant.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 arch/arm/mach-vexpress/Kconfig |   1 +
 arch/arm/mach-vexpress/spc.c   | 124 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 124 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-vexpress/Kconfig b/arch/arm/mach-vexpress/Kconfig
index d6b16d9a7838..f90809bbdaa7 100644
--- a/arch/arm/mach-vexpress/Kconfig
+++ b/arch/arm/mach-vexpress/Kconfig
@@ -21,6 +21,7 @@ menuconfig ARCH_VEXPRESS
 	select VEXPRESS_CONFIG
 	select VEXPRESS_SYSCFG
 	select MFD_VEXPRESS_SYSREG
+	select PM_GENERIC_DOMAINS if PM
 	help
 	  This option enables support for systems using Cortex processor based
 	  ARM core and logic (FPGA) tiles on the Versatile Express motherboard,
diff --git a/arch/arm/mach-vexpress/spc.c b/arch/arm/mach-vexpress/spc.c
index f61158c6ce71..4ff1009f2d16 100644
--- a/arch/arm/mach-vexpress/spc.c
+++ b/arch/arm/mach-vexpress/spc.c
@@ -28,6 +28,8 @@
 #include <linux/pm_opp.h>
 #include <linux/slab.h>
 #include <linux/semaphore.h>
+#include <linux/of_platform.h>
+#include <linux/pm_domain.h>
 
 #include <asm/cacheflush.h>
 
@@ -92,6 +94,9 @@
 #define STAT_ERR(type)		((1 << 1) << (type << 2))
 #define RESPONSE_MASK(type)	(STAT_COMPLETE(type) | STAT_ERR(type))
 
+static atomic_t gpd_A7_cluster_on = ATOMIC_INIT(0);
+static atomic_t gpd_A15_cluster_on = ATOMIC_INIT(0);
+
 struct ve_spc_opp {
 	unsigned long freq;
 	unsigned long u_volt;
@@ -209,12 +214,19 @@ void ve_spc_set_resume_addr(u32 cluster, u32 cpu, u32 addr)
  */
 void ve_spc_powerdown(u32 cluster, bool enable)
 {
+	bool is_a15;
 	u32 pwdrn_reg;
 
 	if (cluster >= MAX_CLUSTERS)
 		return;
 
-	pwdrn_reg = cluster_is_a15(cluster) ? A15_PWRDN_EN : A7_PWRDN_EN;
+	is_a15 = cluster_is_a15(cluster);
+	if (is_a15 && atomic_read(&gpd_A15_cluster_on))
+		return;
+	else if (!is_a15 && atomic_read(&gpd_A7_cluster_on))
+		return;
+
+	pwdrn_reg = is_a15 ? A15_PWRDN_EN : A7_PWRDN_EN;
 	writel_relaxed(enable, info->baseaddr + pwdrn_reg);
 }
 
@@ -447,6 +459,116 @@ static int ve_init_opp_table(struct device *cpu_dev)
 	return ret;
 }
 
+#ifdef CONFIG_PM_GENERIC_DOMAINS_OF
+static int scp_power_on_pd_A7(struct generic_pm_domain *domain)
+{
+	/*
+	 * Simply tell mcpm we need power.  Nothing else needs to be done
+	 * as CPUs in the cluster are already powered when we reach this point.
+	 */
+	atomic_set(&gpd_A7_cluster_on, 1);
+	return 0;
+}
+
+static int scp_power_off_pd_A7(struct generic_pm_domain *domain)
+{
+	atomic_set(&gpd_A7_cluster_on, 0);
+	return 0;
+}
+
+static int scp_power_on_pd_A15(struct generic_pm_domain *domain)
+{
+	/*
+	 * Simply tell mcpm we need power.  Nothing else needs to be done
+	 * as CPUs in the cluster are already powered when we reach this point.
+	 */
+	atomic_set(&gpd_A15_cluster_on, 1);
+	return 0;
+}
+
+static int scp_power_off_pd_A15(struct generic_pm_domain *domain)
+{
+	atomic_set(&gpd_A15_cluster_on, 0);
+	return 0;
+}
+
+static int (*const scp_power_fct[MAX_CLUSTERS * 2])
+		(struct generic_pm_domain *domain) = {
+		scp_power_on_pd_A15, scp_power_off_pd_A15,
+		scp_power_on_pd_A7, scp_power_off_pd_A7};
+
+static void scp_init_pd(struct generic_pm_domain *pd,
+			    struct device_node *np,
+			    struct platform_device *pdev, int cluster)
+{
+	char name[50];
+	int index = cluster * 2;
+
+	snprintf(name, sizeof(name), "%s-%d", np->name, cluster);
+
+	pd->name = kstrdup(name, GFP_KERNEL);
+	pd->power_on = scp_power_fct[index];
+	pd->power_off =  scp_power_fct[index + 1];
+	platform_set_drvdata(pdev, pd);
+
+	pm_genpd_init(pd, NULL, true);
+	pm_genpd_poweron(pd);
+}
+
+static __init int ve_spc_gpd_init(void)
+{
+	struct genpd_onecell_data *data;
+	struct generic_pm_domain *pd, **cluster_pds;
+	struct platform_device *pdev;
+	struct device *dev;
+	struct device_node *np;
+	int count;
+
+	np = of_find_compatible_node(NULL, NULL,
+				     "arm,vexpress-power-controller");
+	if (!np)
+		return -EINVAL;
+
+	cluster_pds = kzalloc(sizeof(struct generic_pm_domain *) * MAX_CLUSTERS,
+			      GFP_KERNEL);
+	if (!cluster_pds)
+		goto err_cluster_kzalloc;
+
+	data = kzalloc(sizeof(struct genpd_onecell_data), GFP_KERNEL);
+	if (!data)
+		goto err_data;
+
+	pdev = of_find_device_by_node(np);
+	dev = &pdev->dev;
+
+	for (count = 0; count < MAX_CLUSTERS; count++) {
+		pd = kzalloc(sizeof(struct generic_pm_domain), GFP_KERNEL);
+		if (!pd)
+			goto err_pd_kzalloc;
+		scp_init_pd(pd, np, pdev, count);
+		cluster_pds[count] = pd;
+	}
+
+	data->num_domains = count;
+	data->domains = cluster_pds;
+
+	of_genpd_add_provider_onecell(np, data);
+	return 0;
+
+err_pd_kzalloc:
+	while (--count >= 0)
+		kfree(cluster_pds[count]);
+
+err_cluster_kzalloc:
+	of_node_put(np);
+err_data:
+	kfree(cluster_pds);
+	return -ENOMEM;
+
+}
+arch_initcall(ve_spc_gpd_init);
+#endif
+
 int __init ve_spc_init(void __iomem *baseaddr, u32 a15_clusid, int irq)
 {
 	int ret;
-- 
1.9.1


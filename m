Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaKLWBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:01:53 -0500
Received: from regular1.263xmail.com ([211.150.99.133]:44323 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaKLWBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:01:46 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: linus.walleij@linaro.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <5f157db1275e7cc529acc6bd0c104f93>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, dianders@chromium.org,
        linux-rockchip@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, fzf@rock-chips.com,
        cf@rock-chips.com, caesar.wang@rock-chips.com,
        Jack Dai <jack.dai@rock-chips.com>,
        "jinkun.hong" <jinkun.hong@rock-chips.com>
Subject: [PATCH v11 2/3] power-domain: rockchip: add power doamin driver
Date: Thu, 13 Nov 2014 06:01:29 +0800
Message-Id: <1415829690-20236-3-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415829690-20236-1-git-send-email-caesar.wang@rock-chips.com>
References: <1415829690-20236-1-git-send-email-caesar.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to meet high performance and low power requirements, a power
management unit is designed or saving power when RK3288 in low power mode.
The RK3288 PMU is dedicated for managing the power ot the whole chip.

Signed-off-by: Jack Dai <jack.dai@rock-chips.com>
Signed-off-by: jinkun.hong <jinkun.hong@rock-chips.com>
Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>

---

Changes in v11:
    - fix pm_genpd_init(&pd->genpd, NULL, false);

Changes in v10:
    - this switches over domain infos to use masks instead of recomputing
      them each time and also gets rid of custom domain translator and
      uses standard onecell on.

Changes in v9:
    - fix v8 changes as follows:
    - This reconciles the v2 and v7 code so that we power domain have
      lists of clocks they toggle on and off during power transitions and
      independently from power domains clocks we attach clocks to devices
      comprising power domain and prepare them so they are turn on and off
      by runtime PM.
    - add rockchip_pm_add_one_domain() to control domains.
    - add pd_start/pd_stop interface to control clocks

Changes in v8:
    - This reconciles the v2 and v7 code so that we power domain have
      lists of clocks they toggle on and off during power transitions and
      independently from power domains clocks we attach clocks to devices
      comprising power domain and prepare them so they are turn on and off
      by runtime PM.

Changes in v7:
    - Delete unused variables

Changes in v6:
    - delete pmu_lock
    - modify dev_lock using mutex
    - pm_clk_resume(pd->dev) change to pm_clk_resume(ed->dev)
    - pm_clk_suspend(pd->dev) change to pm_clk_suspend(ed->dev)
    - add devm_kfree(pd->dev, de) in rockchip_pm_domain_detach_dev

Changes in v5:
    - delete idle_lock
    - add timeout in rockchip_pmu_set_idle_request()

Changes in v4:
    - use list storage dev

Changes in v3:
    - change use pm_clk_resume() and pm_clk_suspend()

Changes in v2:
    - remove the "pd->pd.of_node = np"

 arch/arm/mach-rockchip/Kconfig            |   1 +
 arch/arm/mach-rockchip/Makefile           |   1 +
 arch/arm/mach-rockchip/pm_domains.c       | 471 ++++++++++++++++++++++++++++++
 include/dt-bindings/power-domain/rk3288.h |  11 +
 4 files changed, 484 insertions(+)
 create mode 100644 arch/arm/mach-rockchip/pm_domains.c
 create mode 100644 include/dt-bindings/power-domain/rk3288.h

diff --git a/arch/arm/mach-rockchip/Kconfig b/arch/arm/mach-rockchip/Kconfig
index ac5803c..d033993 100644
--- a/arch/arm/mach-rockchip/Kconfig
+++ b/arch/arm/mach-rockchip/Kconfig
@@ -13,6 +13,7 @@ config ARCH_ROCKCHIP
 	select DW_APB_TIMER_OF
 	select ARM_GLOBAL_TIMER
 	select CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
+	select PM_GENERIC_DOMAINS if PM
 	help
 	  Support for Rockchip's Cortex-A9 Single-to-Quad-Core-SoCs
 	  containing the RK2928, RK30xx and RK31xx series.
diff --git a/arch/arm/mach-rockchip/Makefile b/arch/arm/mach-rockchip/Makefile
index b29d8ea..17ea082 100644
--- a/arch/arm/mach-rockchip/Makefile
+++ b/arch/arm/mach-rockchip/Makefile
@@ -1,4 +1,5 @@
 CFLAGS_platsmp.o := -march=armv7-a
 
 obj-$(CONFIG_ARCH_ROCKCHIP) += rockchip.o
+obj-$(CONFIG_PM_GENERIC_DOMAINS) += pm_domains.o
 obj-$(CONFIG_SMP) += headsmp.o platsmp.o
diff --git a/arch/arm/mach-rockchip/pm_domains.c b/arch/arm/mach-rockchip/pm_domains.c
new file mode 100644
index 0000000..00730eb
--- /dev/null
+++ b/arch/arm/mach-rockchip/pm_domains.c
@@ -0,0 +1,471 @@
+/*
+ * Rockchip Generic power domain support.
+ *
+ * Copyright (c) 2014 ROCKCHIP, Co. Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/pm_clock.h>
+#include <linux/pm_domain.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/regmap.h>
+#include <linux/mfd/syscon.h>
+#include <dt-bindings/power-domain/rk3288.h>
+
+struct rockchip_domain_info {
+	int pwr_mask;
+	int status_mask;
+	int req_mask;
+	int idle_mask;
+	int ack_mask;
+};
+
+struct rockchip_pmu_info {
+	u32 pwr_offset;
+	u32 status_offset;
+	u32 req_offset;
+	u32 idle_offset;
+	u32 ack_offset;
+
+	int num_domains;
+	const struct rockchip_domain_info *domain_info;
+};
+
+struct rockchip_pm_domain {
+	struct generic_pm_domain genpd;
+	const struct rockchip_domain_info *info;
+	struct rockchip_pmu *pmu;
+	int num_clks;
+	struct clk *clks[];
+};
+
+struct rockchip_pmu {
+	struct device *dev;
+	struct regmap *regmap;
+	const struct rockchip_pmu_info *info;
+	struct mutex mutex; /* mutex lock for pmu */
+	struct genpd_onecell_data genpd_data;
+	struct generic_pm_domain *domains[];
+};
+
+#define to_rockchip_pd(gpd) container_of(gpd, struct rockchip_pm_domain, genpd)
+
+#define DOMAIN(pwr, status, req, idle, ack)	\
+{						\
+	.pwr_mask = BIT(pwr),			\
+	.status_mask = BIT(status),		\
+	.req_mask = BIT(req),			\
+	.idle_mask = BIT(idle),			\
+	.ack_mask = BIT(ack),			\
+}
+
+#define DOMAIN_RK3288(pwr, status, req)		\
+	DOMAIN(pwr, status, req, req, (req) + 16)
+
+static bool rockchip_pmu_domain_is_idle(struct rockchip_pm_domain *pd)
+{
+	struct rockchip_pmu *pmu = pd->pmu;
+	const struct rockchip_domain_info *pd_info = pd->info;
+	unsigned int val;
+
+	regmap_read(pmu->regmap, pmu->info->idle_offset, &val);
+	return (val & pd_info->idle_mask) == pd_info->idle_mask;
+}
+
+static int rockchip_pmu_set_idle_request(struct rockchip_pm_domain *pd,
+					 bool idle)
+{
+	const struct rockchip_domain_info *pd_info = pd->info;
+	struct rockchip_pmu *pmu = pd->pmu;
+	unsigned int val;
+
+	regmap_update_bits(pmu->regmap, pmu->info->req_offset,
+			   pd_info->req_mask, idle ? -1U : 0);
+
+	dsb();
+
+	do {
+		regmap_read(pmu->regmap, pmu->info->ack_offset, &val);
+	} while ((val & pd_info->ack_mask) != (idle ? pd_info->ack_mask : 0));
+
+	while (rockchip_pmu_domain_is_idle(pd) != idle)
+		cpu_relax();
+
+	return 0;
+}
+
+static bool rockchip_pmu_domain_is_on(struct rockchip_pm_domain *pd)
+{
+	struct rockchip_pmu *pmu = pd->pmu;
+	unsigned int val;
+
+	regmap_read(pmu->regmap, pmu->info->status_offset, &val);
+
+	/* 1'b0: power on, 1'b1: power off */
+	return !(val & pd->info->status_mask);
+}
+
+static void rockchip_do_pmu_set_power_domain(struct rockchip_pm_domain *pd,
+					     bool on)
+{
+	struct rockchip_pmu *pmu = pd->pmu;
+
+	regmap_update_bits(pmu->regmap, pmu->info->pwr_offset,
+			   pd->info->pwr_mask, on ? 0 : -1U);
+
+	dsb();
+
+	while (rockchip_pmu_domain_is_on(pd) != on)
+		cpu_relax();
+}
+
+static int rockchip_pd_power(struct rockchip_pm_domain *pd, bool power_on)
+{
+	int i;
+
+	mutex_lock(&pd->pmu->mutex);
+
+	if (rockchip_pmu_domain_is_on(pd) != power_on) {
+		for (i = 0; i < pd->num_clks; i++)
+			clk_enable(pd->clks[i]);
+
+		if (!power_on) {
+			/* FIXME: add code to save AXI_QOS */
+
+			/* if powering down, idle request to NIU first */
+			rockchip_pmu_set_idle_request(pd, true);
+		}
+
+		rockchip_do_pmu_set_power_domain(pd, power_on);
+
+		if (power_on) {
+			/* if powering up, leave idle mode */
+			rockchip_pmu_set_idle_request(pd, false);
+
+			/* FIXME: add code to restore AXI_QOS */
+		}
+
+		for (i = pd->num_clks - 1; i >= 0; i--)
+			clk_disable(pd->clks[i]);
+	}
+
+	mutex_unlock(&pd->pmu->mutex);
+	return 0;
+}
+
+static int rockchip_pd_power_on(struct generic_pm_domain *domain)
+{
+	struct rockchip_pm_domain *pd = to_rockchip_pd(domain);
+
+	return rockchip_pd_power(pd, true);
+}
+
+static int rockchip_pd_power_off(struct generic_pm_domain *domain)
+{
+	struct rockchip_pm_domain *pd = to_rockchip_pd(domain);
+
+	return rockchip_pd_power(pd, false);
+}
+
+static void rockchip_pd_attach_dev(struct device *dev)
+{
+	struct generic_pm_domain *genpd = pd_to_genpd(dev->pm_domain);
+	struct clk *clk;
+	int i;
+	int error;
+
+	dev_dbg(dev, "attaching to power domain '%s'\n", genpd->name);
+
+	error = pm_clk_create(dev);
+	if (error) {
+		dev_err(dev, "pm_clk_create failed %d\n", error);
+		return;
+	}
+
+	while ((clk = of_clk_get(dev->of_node, i++)) && !IS_ERR(clk)) {
+		error = pm_clk_add_clk(dev, clk);
+		clk_put(clk);
+		if (error) {
+			dev_err(dev, "pm_clk_add_clk failed %d\n", error);
+			pm_clk_destroy(dev);
+			return;
+		}
+		dev_dbg(dev, "added clock '%s' to list of PM clocks\n",
+			__clk_get_name(clk));
+	}
+}
+
+static void rockchip_pd_detach_dev(struct device *dev)
+{
+	struct generic_pm_domain *genpd = pd_to_genpd(dev->pm_domain);
+
+	dev_dbg(dev, "detaching from power domain %s\n", genpd->name);
+
+	pm_clk_destroy(dev);
+}
+
+static int rockchip_pd_start_dev(struct device *dev)
+{
+	struct generic_pm_domain *genpd = pd_to_genpd(dev->pm_domain);
+
+	dev_dbg(dev, "starting device in power domain '%s'\n", genpd->name);
+
+	return pm_clk_resume(dev);
+}
+
+static int rockchip_pd_stop_dev(struct device *dev)
+{
+	struct generic_pm_domain *genpd = pd_to_genpd(dev->pm_domain);
+
+	dev_dbg(dev, "stopping device in power domain '%s'\n", genpd->name);
+
+	return pm_clk_suspend(dev);
+}
+
+static int rockchip_pm_add_one_domain(struct rockchip_pmu *pmu,
+				      struct device_node *node)
+{
+	const struct rockchip_domain_info *pd_info;
+	struct rockchip_pm_domain *pd;
+	struct clk *clk;
+	int clk_cnt;
+	int i;
+	u32 id;
+	bool is_on;
+	int error;
+
+	error = of_property_read_u32(node, "reg", &id);
+	if (error) {
+		dev_err(pmu->dev,
+			"%s: failed to retrieve domain id (reg): %d\n",
+			node->name, error);
+		return -EINVAL;
+	}
+
+	if (id >= pmu->info->num_domains) {
+		dev_err(pmu->dev, "%s: invalid domain id %d\n",
+			node->name, id);
+		return -EINVAL;
+	}
+
+	pd_info = &pmu->info->domain_info[id];
+	if (!pd_info) {
+		dev_err(pmu->dev, "%s: undefined domain id %d\n",
+			node->name, id);
+		return -EINVAL;
+	}
+
+	clk_cnt = of_count_phandle_with_args(node, "clocks", "#clock-cells");
+	pd = devm_kzalloc(pmu->dev,
+			  sizeof(*pd) + clk_cnt * sizeof(pd->clks[0]),
+			  GFP_KERNEL);
+	if (!pd)
+		return -ENOMEM;
+
+	pd->genpd.name = node->name;
+	pd->genpd.power_off = rockchip_pd_power_off;
+	pd->genpd.power_on = rockchip_pd_power_on;
+	pd->genpd.attach_dev = rockchip_pd_attach_dev;
+	pd->genpd.detach_dev = rockchip_pd_detach_dev;
+	pd->genpd.dev_ops.start = rockchip_pd_start_dev;
+	pd->genpd.dev_ops.stop = rockchip_pd_stop_dev;
+
+	pd->info = pd_info;
+	pd->pmu = pmu;
+	pd->num_clks = clk_cnt;
+
+	is_on = rockchip_pmu_domain_is_on(pd);
+	pm_genpd_init(&pd->genpd, NULL, !is_on);
+
+	for (i = 0; i < clk_cnt; i++) {
+		clk = of_clk_get(node, i);
+		if (IS_ERR(clk)) {
+			error = PTR_ERR(clk);
+			dev_err(pmu->dev,
+				"%s: failed to get clk %s (index %d): %d\n",
+				node->name, __clk_get_name(clk), i, error);
+			goto err_out;
+		}
+
+		error = clk_prepare(clk);
+		if (error) {
+			dev_err(pmu->dev,
+				"%s: failed to prepare clk %s (index %d): %d\n",
+				node->name, __clk_get_name(clk), i, error);
+			clk_put(clk);
+			goto err_out;
+		}
+
+		pd->clks[i] = clk;
+
+		dev_dbg(pmu->dev, "added clock '%s' to domain '%s'\n",
+			__clk_get_name(clk), node->name);
+	}
+
+	pmu->genpd_data.domains[id] = &pd->genpd;
+	return 0;
+
+err_out:
+	while (--i >= 0) {
+		clk_unprepare(pd->clks[i]);
+		clk_put(pd->clks[i]);
+	}
+	return error;
+}
+
+static void rockchip_pm_remove_one_domain(struct rockchip_pm_domain *pd)
+{
+	int i;
+
+	for (i = 0; i < pd->num_clks; i++) {
+		clk_unprepare(pd->clks[i]);
+		clk_put(pd->clks[i]);
+	}
+
+	/* devm will free our memory */
+}
+
+static void rockchip_pm_domain_cleanup(struct rockchip_pmu *pmu)
+{
+	struct generic_pm_domain *genpd;
+	struct rockchip_pm_domain *pd;
+	int i;
+
+	for (i = 0; i < pmu->genpd_data.num_domains; i++) {
+		genpd = pmu->genpd_data.domains[i];
+		if (genpd) {
+			pd = to_rockchip_pd(genpd);
+			rockchip_pm_remove_one_domain(pd);
+		}
+	}
+
+	/* devm will free our memory */
+}
+
+static int rockchip_pm_domain_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct device_node *node;
+	struct rockchip_pmu *pmu;
+	const struct of_device_id *match;
+	const struct rockchip_pmu_info *pmu_info;
+	int error;
+
+	if (!np) {
+		dev_err(dev, "device tree node not found\n");
+		return -ENXIO;
+	}
+
+	match = of_match_device(dev->driver->of_match_table, dev);
+	if (!match || !match->data) {
+		dev_err(dev, "missing pmu data\n");
+		return -EINVAL;
+	}
+
+	pmu_info = match->data;
+
+	pmu = devm_kzalloc(dev,
+			   sizeof(*pmu) +
+				pmu_info->num_domains * sizeof(pmu->domains[0]),
+			   GFP_KERNEL);
+	if (!pmu)
+		return -ENOMEM;
+
+	pmu->dev = &pdev->dev;
+	mutex_init(&pmu->mutex);
+
+	pmu->info = pmu_info;
+
+	pmu->genpd_data.domains = pmu->domains;
+	pmu->genpd_data.num_domains = pmu_info->num_domains;
+
+	node = of_parse_phandle(np, "rockchip,pmu", 0);
+	pmu->regmap = syscon_node_to_regmap(node);
+	of_node_put(node);
+	if (IS_ERR(pmu->regmap)) {
+		error = PTR_ERR(pmu->regmap);
+		dev_err(dev, "failed to get PMU regmap: %d\n", error);
+		return error;
+	}
+
+	error = -ENXIO;
+
+	for_each_available_child_of_node(np, node) {
+		error = rockchip_pm_add_one_domain(pmu, node);
+		if (error) {
+			dev_err(dev, "failed to handle node %s: %d\n",
+				node->name, error);
+			goto err_out;
+		}
+	}
+
+	if (error) {
+		dev_dbg(dev, "no power domains defined\n");
+		goto err_out;
+	}
+
+	of_genpd_add_provider_onecell(np, &pmu->genpd_data);
+
+	return 0;
+
+err_out:
+	rockchip_pm_domain_cleanup(pmu);
+	return error;
+}
+
+static const struct rockchip_domain_info rk3288_pm_domains[] = {
+	[RK3288_PD_GPU]		= DOMAIN_RK3288(9, 9, 2),
+	[RK3288_PD_VIO]		= DOMAIN_RK3288(7, 7, 4),
+	[RK3288_PD_VIDEO]	= DOMAIN_RK3288(8, 8, 3),
+	[RK3288_PD_HEVC]	= DOMAIN_RK3288(14, 10, 9),
+};
+
+static const struct rockchip_pmu_info rk3288_pmu = {
+	.pwr_offset = 0x08,
+	.status_offset = 0x0c,
+	.req_offset = 0x10,
+	.idle_offset = 0x14,
+	.ack_offset = 0x14,
+	.num_domains = ARRAY_SIZE(rk3288_pm_domains),
+	.domain_info = rk3288_pm_domains,
+};
+
+static const struct of_device_id rockchip_pm_domain_dt_match[] = {
+	{
+		.compatible = "rockchip,rk3288-power-controller",
+		.data = (void *)&rk3288_pmu,
+	},
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, rockchip_pm_domain_dt_match);
+
+static struct platform_driver rockchip_pm_domain_driver = {
+	.probe = rockchip_pm_domain_probe,
+	.driver = {
+		.name   = "rockchip-pm-domain",
+		.owner  = THIS_MODULE,
+		.of_match_table = rockchip_pm_domain_dt_match,
+		/*
+		 * We can't forcibly eject devices form power domain,
+		 * so we can't really remove power domains once they
+		 * were added.
+		 */
+		.suppress_bind_attrs = true,
+	},
+};
+
+static int __init rockchip_pm_domain_drv_register(void)
+{
+	return platform_driver_register(&rockchip_pm_domain_driver);
+}
+postcore_initcall(rockchip_pm_domain_drv_register);
diff --git a/include/dt-bindings/power-domain/rk3288.h b/include/dt-bindings/power-domain/rk3288.h
new file mode 100644
index 0000000..ca68c11
--- /dev/null
+++ b/include/dt-bindings/power-domain/rk3288.h
@@ -0,0 +1,11 @@
+#ifndef __DT_BINDINGS_POWER_DOMAIN_RK3288_H__
+#define __DT_BINDINGS_POWER_DOMAIN_RK3288_H__
+
+/* RK3288 power domain index */
+#define RK3288_PD_GPU          0
+#define RK3288_PD_VIO          1
+#define RK3288_PD_VIDEO        2
+#define RK3288_PD_HEVC         3
+#define RK3288_PD_PERI         4
+
+#endif
-- 
1.9.1



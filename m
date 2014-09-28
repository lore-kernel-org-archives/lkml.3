Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaI1KXj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 06:23:39 -0400
Received: from mail-pa0-f68.google.com ([209.85.220.68]:42884 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbaI1KXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 06:23:36 -0400
From: "jinkun.hong" <jinkun.hong@rock-chips.com>
To: Russell King <linux@arm.linux.org.uk>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, dianders@chromium.org,
        Heiko Stuebner <heiko@sntech.de>
Cc: linux-rockchip@lists.infradead.org,
        "jinkun.hong" <jinkun.hong@rock-chips.com>,
        Jack Dai <jack.dai@rock-chips.com>
Subject: [PATCH v2 1/3] power-domain: add power domain drivers for Rockchip platform
Date: Sun, 28 Sep 2014 03:22:52 -0700
Message-Id: <1411899774-8484-2-git-send-email-jinkun.hong@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411899774-8484-1-git-send-email-jinkun.hong@rock-chips.com>
References: <1411899774-8484-1-git-send-email-jinkun.hong@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "jinkun.hong" <jinkun.hong@rock-chips.com>

Add power domain drivers based on generic power domain for Rockchip platform,
and support RK3288.

Signed-off-by: Jack Dai <jack.dai@rock-chips.com>
Signed-off-by: jinkun.hong <jinkun.hong@rock-chips.com>

---

Changes in v2:
- remove the "pd->pd.of_node = np"

 arch/arm/mach-rockchip/Kconfig            |    1 +
 arch/arm/mach-rockchip/Makefile           |    1 +
 arch/arm/mach-rockchip/pm_domains.c       |  371 +++++++++++++++++++++++++++++
 include/dt-bindings/power-domain/rk3288.h |   11 +
 4 files changed, 384 insertions(+)
 create mode 100644 arch/arm/mach-rockchip/pm_domains.c
 create mode 100644 include/dt-bindings/power-domain/rk3288.h

diff --git a/arch/arm/mach-rockchip/Kconfig b/arch/arm/mach-rockchip/Kconfig
index cfe5037..02ec129 100644
--- a/arch/arm/mach-rockchip/Kconfig
+++ b/arch/arm/mach-rockchip/Kconfig
@@ -16,6 +16,7 @@ config ARCH_ROCKCHIP
 	select DW_APB_TIMER_OF
 	select ARM_GLOBAL_TIMER
 	select CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
+	select PM_GENERIC_DOMAINS if PM
 	help
 	  Support for Rockchip's Cortex-A9 Single-to-Quad-Core-SoCs
 	  containing the RK2928, RK30xx and RK31xx series.
diff --git a/arch/arm/mach-rockchip/Makefile b/arch/arm/mach-rockchip/Makefile
index 4377a14..2a47343 100644
--- a/arch/arm/mach-rockchip/Makefile
+++ b/arch/arm/mach-rockchip/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_ARCH_ROCKCHIP) += rockchip.o
 obj-$(CONFIG_SMP) += headsmp.o platsmp.o
+obj-$(CONFIG_PM_GENERIC_DOMAINS) += pm_domains.o
diff --git a/arch/arm/mach-rockchip/pm_domains.c b/arch/arm/mach-rockchip/pm_domains.c
new file mode 100644
index 0000000..6d1f5eb
--- /dev/null
+++ b/arch/arm/mach-rockchip/pm_domains.c
@@ -0,0 +1,371 @@
+/*
+ * Rockchip Generic power domain support.
+ *
+ * Copyright (c) 2014 ROCKCHIP, Co. Ltd.
+ * Author: Jack Dai <jack.dai@rock-chips.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/pm_domain.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/sched.h>
+#include <linux/clk.h>
+#include <linux/regmap.h>
+#include <linux/mfd/syscon.h>
+#include <linux/spinlock.h>
+#include <dt-bindings/power-domain/rk3288.h>
+
+struct rockchip_pm_domain {
+	u32				id;
+	int				pwr_shift;
+	int				status_shift;
+	int				req_shift;
+	int				idle_shift;
+	int				ack_shift;
+	u8				num_clks;
+	struct clk			**clks;
+	struct generic_pm_domain	pd;
+	struct rockchip_pmu		*pmu;
+};
+
+struct rockchip_pmu {
+	struct regmap			*regmap_pmu;
+	u32				pwr_offset;
+	u32				status_offset;
+	u32				req_offset;
+	u32				idle_offset;
+	u32				ack_offset;
+	u8				num_pds;
+	struct rockchip_pm_domain	*pds;
+	spinlock_t			idle_lock;
+	spinlock_t			pmu_lock;
+};
+
+#define to_rockchip_pd(_gpd) container_of(_gpd, struct rockchip_pm_domain, pd)
+
+#define DOMAIN(_id, _pwr_s, _status_s, _req_s, _idle_s, _ack_s)	\
+{								\
+	.id = _id,						\
+	.pwr_shift = _pwr_s,					\
+	.status_shift = _status_s,				\
+	.req_shift = _req_s,					\
+	.idle_shift = _idle_s,					\
+	.ack_shift = _ack_s,					\
+}
+
+#define DOMAIN_RK3288(_id, _pwr_s, _status_s, _req_s) \
+	DOMAIN(_id, _pwr_s, _status_s, _req_s, _req_s, (_req_s+16))
+
+static struct rockchip_pm_domain *rockchip_pd_id_to_pd(struct rockchip_pmu *pmu,
+						       u32 id)
+{
+	int i;
+
+	for (i = 0; i < pmu->num_pds; i++) {
+		if (pmu->pds[i].id == id)
+			return &pmu->pds[i];
+	}
+
+	return ERR_PTR(-EINVAL);
+}
+
+static int rockchip_pmu_set_idle_request(struct rockchip_pm_domain *pd,
+					 bool idle)
+{
+	u32 idle_mask = BIT(pd->idle_shift);
+	u32 idle_target = idle << (pd->idle_shift);
+	u32 ack_mask = BIT(pd->ack_shift);
+	u32 ack_target = idle << (pd->ack_shift);
+	unsigned int mask = BIT(pd->req_shift);
+	unsigned int val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pd->pmu->idle_lock, flags);
+
+	val = (idle) ? mask : 0;
+	regmap_update_bits(pd->pmu->regmap_pmu, pd->pmu->req_offset, mask, val);
+
+	dsb();
+
+	do {
+		regmap_read(pd->pmu->regmap_pmu, pd->pmu->ack_offset, &val);
+	} while ((val & ack_mask) != ack_target);
+
+	do {
+		regmap_read(pd->pmu->regmap_pmu, pd->pmu->idle_offset, &val);
+	} while ((val & idle_mask) != idle_target);
+
+	spin_unlock_irqrestore(&pd->pmu->idle_lock, flags);
+
+	return 0;
+}
+
+static bool rockchip_pmu_power_domain_is_on(struct rockchip_pm_domain *pd)
+{
+	unsigned int val;
+
+	regmap_read(pd->pmu->regmap_pmu, pd->pmu->status_offset, &val);
+
+	/* 1'b0: power on, 1'b1: power off */
+	return !(val & BIT(pd->status_shift));
+}
+
+static void rockchip_do_pmu_set_power_domain(
+		struct rockchip_pm_domain *pd, bool on)
+{
+	unsigned int mask = BIT(pd->pwr_shift);
+	unsigned int val;
+
+	val = (on) ? 0 : mask;
+	regmap_update_bits(pd->pmu->regmap_pmu, pd->pmu->pwr_offset, mask, val);
+
+	dsb();
+
+	do {
+		regmap_read(pd->pmu->regmap_pmu, pd->pmu->status_offset, &val);
+	} while ((val & BIT(pd->status_shift)) == on);
+}
+
+static int rockchip_pmu_set_power_domain(struct rockchip_pm_domain *pd,
+					 bool on)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&pd->pmu->pmu_lock, flags);
+
+	if (rockchip_pmu_power_domain_is_on(pd) == on)
+		goto out;
+
+	if (!on) {
+		/* FIXME: add code to save AXI_QOS */
+		/* if power down, idle request to NIU first */
+		rockchip_pmu_set_idle_request(pd, true);
+	}
+
+	rockchip_do_pmu_set_power_domain(pd, on);
+
+	if (on) {
+		/* if power up, idle request release to NIU */
+		rockchip_pmu_set_idle_request(pd, false);
+		/* FIXME: add code to restore AXI_QOS */
+	}
+
+out:
+	spin_unlock_irqrestore(&pd->pmu->pmu_lock, flags);
+	return 0;
+}
+
+static int rockchip_pd_power(struct rockchip_pm_domain *pd, bool power_on)
+{
+	int i, ret;
+
+	for (i = 0; i < pd->num_clks; i++)
+		if (pd->clks[i])
+			clk_enable(pd->clks[i]);
+
+	ret = rockchip_pmu_set_power_domain(pd, power_on);
+
+	for (i = 0; i < pd->num_clks; i++)
+		if (pd->clks[i])
+			clk_disable(pd->clks[i]);
+
+	return ret;
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
+static void rockchip_allclk_disable_unprepare(struct rockchip_pmu *pmu)
+{
+	int i, j;
+	struct rockchip_pm_domain *pd;
+
+	for (i = 0; i < pmu->num_pds; i++) {
+		pd = rockchip_pd_id_to_pd(pmu, i);
+
+		for (j = 0; j < pd->num_clks; j++)
+			if (pd->clks[j])
+				clk_disable_unprepare(pd->clks[j]);
+	}
+}
+
+struct generic_pm_domain *of_rockchip_pd_xlate(
+					struct of_phandle_args *spec,
+					void *data)
+{
+	struct rockchip_pmu *pmu = (struct rockchip_pmu *)data;
+	struct rockchip_pm_domain *pd;
+	u32 id = spec->args[0];
+
+	if (spec->args_count != 1)
+		return ERR_PTR(-EINVAL);
+
+	pd = rockchip_pd_id_to_pd(pmu, id);
+	if (IS_ERR(pd)) {
+		pr_err("%s: invalid pd index %d\n", __func__, id);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return &pd->pd;
+}
+
+static const struct of_device_id rockchip_pm_domain_dt_match[];
+
+static int rockchip_pm_domain_remove(struct platform_device *pdev)
+{
+	struct rockchip_pmu *pmu;
+	const struct of_device_id *match;
+	struct device_node *np = pdev->dev.of_node;
+
+	of_genpd_del_provider(np);
+
+	match = of_match_node(rockchip_pm_domain_dt_match, np);
+	pmu = (struct rockchip_pmu *)match->data;
+
+	rockchip_allclk_disable_unprepare(pmu);
+	return 0;
+}
+
+static int rockchip_pm_domain_probe(struct platform_device *pdev)
+{
+	struct rockchip_pmu *pmu;
+	struct rockchip_pm_domain *pd;
+	int on, cnt, i, ret;
+	struct clk *clk;
+	struct regmap *regmap_pmu;
+	struct device_node *np = pdev->dev.of_node, *node;
+	const struct of_device_id *match;
+	u32 id;
+
+	if (!np) {
+		pr_err("device tree node not found\n");
+		return -ENODEV;
+	}
+
+	match = of_match_node(rockchip_pm_domain_dt_match, np);
+	pmu = (struct rockchip_pmu *)match->data;
+
+	node = of_parse_phandle(np, "rockchip,pmu", 0);
+	regmap_pmu = syscon_node_to_regmap(node);
+	of_node_put(node);
+	if (IS_ERR(regmap_pmu)) {
+		pr_err("%s: failed to get regmap_pmu", __func__);
+		return PTR_ERR(regmap_pmu);
+	}
+	pmu->regmap_pmu = regmap_pmu;
+	spin_lock_init(&pmu->idle_lock);
+	spin_lock_init(&pmu->pmu_lock);
+
+	for_each_available_child_of_node(np, node) {
+		ret = of_property_read_u32(node, "reg", &id);
+		if (ret != 0) {
+			pr_err("%s: failed to get id\n", __func__);
+			return -ENOMEM;
+		}
+
+		pd = rockchip_pd_id_to_pd(pmu, id);
+		if (IS_ERR(pd)) {
+			pr_err("%s: invalid pd index %d\n", __func__, id);
+			return -ENOMEM;
+		}
+
+		pd->pmu = pmu;
+
+		cnt = of_count_phandle_with_args(node, "clocks",
+						 "#clock-cells");
+		if (cnt > 0) {
+			pd->clks = devm_kcalloc(&pdev->dev, cnt,
+					sizeof(struct clk *), GFP_KERNEL);
+			if (!pd->clks) {
+				pr_err("%s: failed to allocate memory for clks\n",
+				       __func__);
+				return -ENOMEM;
+			}
+
+			pd->num_clks = cnt;
+
+			for (i = 0; i < cnt; i++) {
+				clk = of_clk_get(node, i);
+				if (IS_ERR(clk)) {
+					pr_err("%s: failed to get clk(index %d)\n",
+					       __func__, i);
+					rockchip_allclk_disable_unprepare(pmu);
+					return -ENOMEM;
+				}
+				pd->clks[i] = clk;
+				clk_prepare_enable(clk);
+			}
+		}
+
+		pd->pd.name = node->name;
+		pd->pd.power_off = rockchip_pd_power_off;
+		pd->pd.power_on = rockchip_pd_power_on;
+
+		/*FIXME*/
+		on = true;
+
+		pm_genpd_init(&pd->pd, NULL, !on);
+	}
+
+	__of_genpd_add_provider(np, of_rockchip_pd_xlate, pmu);
+
+	return 0;
+}
+
+struct rockchip_pm_domain rk3288_pm_domains[] = {
+	DOMAIN_RK3288(RK3288_PD_GPU, 9, 9, 2),
+	DOMAIN_RK3288(RK3288_PD_VIO, 7, 7, 4),
+	DOMAIN_RK3288(RK3288_PD_VIDEO, 8, 8, 3),
+	DOMAIN_RK3288(RK3288_PD_HEVC, 14, 10, 9),
+};
+
+struct rockchip_pmu rk3288_pmu = {
+	.pwr_offset = 0x08,
+	.status_offset = 0x0c,
+	.req_offset = 0x10,
+	.idle_offset = 0x14,
+	.ack_offset = 0x14,
+	.num_pds = ARRAY_SIZE(rk3288_pm_domains),
+	.pds = rk3288_pm_domains,
+};
+
+static const struct of_device_id rockchip_pm_domain_dt_match[] = {
+	{ .compatible = "rockchip,rk3288-power-controller",
+		.data = (void *)&rk3288_pmu},
+	{},
+};
+MODULE_DEVICE_TABLE(of, rockchip_pm_domain_dt_match);
+
+static struct platform_driver rockchip_pm_domain_driver = {
+	.probe = rockchip_pm_domain_probe,
+	.remove = rockchip_pm_domain_remove,
+	.driver = {
+		.name   = "rockchip-pm-domain",
+		.owner  = THIS_MODULE,
+		.of_match_table = rockchip_pm_domain_dt_match,
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
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab3GHBow (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 21:44:52 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41736 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab3GHBou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 21:44:50 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH RFC 1/3] clk: notifier handler for dynamic voltage scaling
Date: Sun,  7 Jul 2013 18:44:26 -0700
Message-Id: <1373247868-21444-2-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373247868-21444-1-git-send-email-mturquette@linaro.org>
References: <1373247868-21444-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides helper functions for drivers that wish to scale
voltage through the clock rate-change notifiers. The approach taken is
that the driver does not care about the details of the OPP table, nor
does it care about handling the voltage regulator directly. The driver
only has a pointer to the struct clk object; the other details are
hidden in the helper functions.

The assumptions about DT structure mostly come from the cpufreq-cpu0
binding. Since this is a helper function it does not have a binding
document of its own.

A similar patch using platform data instead of DT was proposed in
February[1].

[1] http://patches.linaro.org/15128/

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/Makefile               |   1 +
 drivers/clk/clk-voltage-notifier.c | 135 +++++++++++++++++++++++++++++++++++++
 include/linux/clk.h                |   7 +-
 3 files changed, 142 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/clk-voltage-notifier.c

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index d3c3733..beb39f1 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_COMMON_CLK)	+= clk-fixed-rate.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-gate.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-mux.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-composite.o
+obj-$(CONFIG_COMMON_CLK)	+= clk-voltage-notifier.o
 
 # SoCs specific
 obj-$(CONFIG_ARCH_BCM2835)	+= clk-bcm2835.o
diff --git a/drivers/clk/clk-voltage-notifier.c b/drivers/clk/clk-voltage-notifier.c
new file mode 100644
index 0000000..cb6b85f
--- /dev/null
+++ b/drivers/clk/clk-voltage-notifier.c
@@ -0,0 +1,135 @@
+/*
+ * Copyright (C) 2013 Linaro Ltd <mturquette@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Helper functions for registering clock rate-change notifier handlers
+ * that scale voltage when a clock changes its output frequency.
+ */
+
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
+#include <linux/of.h>
+#include <linux/opp.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+
+struct volt_scale_data {
+	struct device *dev;
+	struct clk *clk;
+	struct regulator *reg;
+	int tol;
+	struct notifier_block nb;
+};
+
+#define to_volt_scale_data(_nb) container_of(_nb, \
+		struct volt_scale_data, nb)
+
+static int clk_volt_notifier_handler(struct notifier_block *nb,
+		unsigned long flags, void *data)
+{
+	struct clk_notifier_data *cnd = data;
+	struct volt_scale_data *vsd = to_volt_scale_data(nb);
+	int ret, new_volt, old_volt, tol;
+	struct opp *opp;
+	unsigned long old_rate = cnd->old_rate;
+	unsigned long new_rate = cnd->new_rate;
+
+	rcu_read_lock();
+	opp = opp_find_freq_ceil(vsd->dev, &new_rate);
+	if (IS_ERR(opp)) {
+		rcu_read_unlock();
+		dev_err(vsd->dev, "%s: failed to find OPP for %lu\n",
+				__func__, new_rate);
+		return notifier_from_errno(PTR_ERR(opp));
+	}
+	new_volt = opp_get_voltage(opp);
+	rcu_read_unlock();
+
+	tol = new_volt * vsd->tol / 100;
+	old_volt = regulator_get_voltage(vsd->reg);
+
+	/* scaling up? scale voltage before frequency */
+	if (new_rate > old_rate) {
+		ret = regulator_set_voltage_tol(vsd->reg, new_volt, tol);
+		if (ret) {
+			dev_err(vsd->dev, "%s: failed to scale voltage up: %d\n",
+					__func__, ret);
+			return notifier_from_errno(ret);
+		}
+	}
+
+	/* scaling down? scale voltage after frequency */
+	if (new_rate < old_rate) {
+		ret = regulator_set_voltage_tol(vsd->reg, new_volt, tol);
+		if (ret) {
+			dev_err(vsd->dev, "%s: failed to scale voltage down: %d\n",
+					__func__, ret);
+			return notifier_from_errno(ret);
+		}
+	}
+
+	return NOTIFY_OK;
+}
+
+/**
+ * of_clk_volt_notifier_register - register clock notifier to scale voltage
+ * @dev: device that scales clock and voltage regulator
+ * @np: pointer to DeviceTree node
+ * @supply: regulator id string
+ */
+struct notifier_block *of_clk_volt_notifier_register(struct device *dev,
+		struct device_node *np, struct clk *clk, const char *supply,
+		int *voltage_latency)
+{
+	struct volt_scale_data *vsd;
+	int ret;
+
+	vsd = kzalloc(sizeof(struct volt_scale_data), GFP_KERNEL);
+	if (!vsd)
+		return ERR_PTR(-ENOMEM);
+
+	vsd->dev = dev;
+	vsd->clk = clk;
+	vsd->nb.notifier_call = clk_volt_notifier_handler;
+
+	vsd->reg = devm_regulator_get(dev, supply);
+	if (IS_ERR(vsd->reg)) {
+		ret = PTR_ERR(vsd->reg);
+		goto err_free_vsd;
+	}
+
+	of_property_read_u32(np, "voltage-tolerance", &vsd->tol);
+
+	ret = of_init_opp_table(dev);
+	if (ret) {
+		pr_err("%s: failed to init OPP table: %d\n", __func__, ret);
+		goto err_free_vsd;
+	}
+
+	ret = clk_notifier_register(clk, &vsd->nb);
+
+	if (ret)
+		goto err_free_vsd;
+
+	return &vsd->nb;
+
+err_free_vsd:
+	kfree(vsd);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(of_clk_volt_notifier_register);
+
+void of_clk_volt_notifier_unregister(struct notifier_block *nb)
+{
+	struct volt_scale_data *vsd = to_volt_scale_data(nb);
+	struct clk *clk = vsd->clk;
+
+	clk_notifier_unregister(clk, nb);
+	kfree(vsd);
+}
+EXPORT_SYMBOL_GPL(of_clk_volt_notifier_unregister);
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 9a6d045..85ea520 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -15,6 +15,8 @@
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/notifier.h>
+#include <linux/cpufreq.h>
+#include <linux/device.h>
 
 struct device;
 
@@ -79,8 +81,11 @@ struct clk_notifier_data {
 };
 
 int clk_notifier_register(struct clk *clk, struct notifier_block *nb);
-
 int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb);
+struct notifier_block *of_clk_volt_notifier_register(struct device *dev,
+		struct device_node *np, struct clk *clk, const char *supply,
+		int *voltage_latency);
+void of_clk_volt_notifier_unregister(struct notifier_block *nb);
 
 #endif
 
-- 
1.8.1.2


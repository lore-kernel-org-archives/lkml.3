Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334AbaGAQds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:33:48 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64740 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306AbaGAQdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:33:44 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net, shawn.guo@linaro.org
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        sboyd@codeaurora.org, linux-arm-msm@vger.kernel.org,
        spk.linux@gmail.com, thomas.ab@samsung.com, nm@ti.com,
        t.figa@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 02/14] clk: Create of_clk_shared_by_cpus()
Date: Tue,  1 Jul 2014 22:02:31 +0530
Message-Id: <5f7164d789e87c62d722b575980c92dfd0504334.1404231535.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a new routine of_clk_shared_by_cpus() that finds if clock lines are
shared between two CPUs. This is verified by comparing "clocks" property from
CPU's DT node.

Returns 1 if clock line is shared between them, 0 if clock isn't shared and
return appropriate errors in case nodes/properties are missing.

Cc: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/clk/clk.c   | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk.h |  6 ++++++
 2 files changed, 62 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 8b73ede..497735c 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/clk-private.h>
+#include <linux/cpu.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
@@ -2528,6 +2529,61 @@ const char *of_clk_get_parent_name(struct device_node *np, int index)
 }
 EXPORT_SYMBOL_GPL(of_clk_get_parent_name);
 
+/**
+ * of_clk_shared_by_cpus - Finds if clock line is shared between CPUs
+ * @cpu1, cpu2: CPU numbers
+ *
+ * Finds if clock lines are shared by two CPUs. This is verified by comparing
+ * "clocks" property from CPU's DT node.
+ *
+ * Returns 1 if clock line is shared between them, 0 if clock isn't shared.
+ * Return appropriate errors in case some requirements aren't met.
+ */
+int of_clk_shared_by_cpus(int cpu1, int cpu2)
+{
+	struct device *cpu1_dev, *cpu2_dev;
+	struct device_node *np1, *np2;
+	int ret;
+
+	cpu1_dev = get_cpu_device(cpu1);
+	if (!cpu1_dev) {
+		pr_err("%s: failed to get cpu_dev for cpu%d\n", __func__, cpu1);
+		return -ENODEV;
+	}
+
+	cpu2_dev = get_cpu_device(cpu2);
+	if (!cpu2_dev) {
+		pr_err("%s: failed to get cpu_dev for cpu%d\n", __func__, cpu2);
+		return -ENODEV;
+	}
+
+	np1 = of_node_get(cpu1_dev->of_node);
+	if (!np1) {
+		pr_err("%s: failed to find of_node for cpu%d\n", __func__,
+		       cpu1);
+		return -ENODEV;
+	}
+
+	np2 = of_node_get(cpu2_dev->of_node);
+	if (!np2) {
+		pr_err("%s: failed to find of_node for cpu%d\n", __func__,
+		       cpu2);
+		ret = -ENODEV;
+		goto put_np1;
+	}
+
+	/* Match "clocks" property */
+	ret = of_property_match(np1, np2, "clocks");
+
+	of_node_put(np2);
+
+put_np1:
+	of_node_put(np1);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(of_clk_shared_by_cpus);
+
 struct clock_provider {
 	of_clk_init_cb_t clk_init_cb;
 	struct device_node *np;
diff --git a/include/linux/clk.h b/include/linux/clk.h
index fb5e097..58e281a 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -399,6 +399,7 @@ struct of_phandle_args;
 struct clk *of_clk_get(struct device_node *np, int index);
 struct clk *of_clk_get_by_name(struct device_node *np, const char *name);
 struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec);
+int of_clk_shared_by_cpus(int cpu1, int cpu2);
 #else
 static inline struct clk *of_clk_get(struct device_node *np, int index)
 {
@@ -409,6 +410,11 @@ static inline struct clk *of_clk_get_by_name(struct device_node *np,
 {
 	return ERR_PTR(-ENOENT);
 }
+
+static inline int of_clk_shared_by_cpus(int cpu1, int cpu2)
+{
+	return -ENOSYS;
+}
 #endif
 
 #endif
-- 
2.0.0.rc2


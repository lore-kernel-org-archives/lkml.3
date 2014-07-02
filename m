Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbaGBEDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 00:03:51 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:39757 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaGBEDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 00:03:49 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net, shawn.guo@linaro.org
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        sboyd@codeaurora.org, linux-arm-msm@vger.kernel.org,
        spk.linux@gmail.com, thomas.ab@samsung.com, nm@ti.com,
        t.figa@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>,
        devicetree@vger.kernel.org
Subject: [PATCH V2 Resend 12/14] cpufreq: cpu0: Extend support beyond CPU0
Date: Wed,  2 Jul 2014 09:33:24 +0530
Message-Id: <3644ffb33bc8f4f5aac56f553c228361a9934d79.1404273178.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <e0680f66383f71400f0caa7032620b82c7b3af83.1404273178.git.viresh.kumar@linaro.org>
References: <e0680f66383f71400f0caa7032620b82c7b3af83.1404273178.git.viresh.kumar@linaro.org>
In-Reply-To: <89da404a3b8f545774f5782d901b8381caf02c07.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the infrastructure is in place now, with only little left. How to find
siblings ?

Stephen Boyd suggested to compare "clocks" properties from CPU's DT node and
siblings should match. This patch adds another routine find_siblings() which
calls of_property_match() to find if CPUs share clock line or not.

If of_property_match() returns error, we fallback to all CPUs sharing clock line
assumption as existing platforms don't have "clocks" property in all CPU nodes
and would fail from of_property_match().

Cc: devicetree@vger.kernel.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V2 Resend: Use of_property_match() directly instead of of_clk_shared_by_cpus()
which would be dropped now.

 .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   | 72 ++++++++++++++++++++--
 drivers/cpufreq/cpufreq-cpu0.c                     | 62 ++++++++++++++++++-
 2 files changed, 128 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
index 366690c..9d65799 100644
--- a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
+++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
@@ -1,11 +1,11 @@
-Generic CPU0 cpufreq driver
+Generic cpufreq driver
 
-It is a generic cpufreq driver for CPU0 frequency management.  It
+It is a generic cpufreq driver for frequency management.  It
 supports both uniprocessor (UP) and symmetric multiprocessor (SMP)
-systems which share clock and voltage across all CPUs.
+systems which may or maynot share clock and voltage across all CPUs.
 
 Both required and optional properties listed below must be defined
-under node /cpus/cpu@0.
+under node /cpus/cpu@x. Where x is the first cpu inside a cluster.
 
 Required properties:
 - None
@@ -21,9 +21,16 @@ Optional properties:
 - cooling-min-level:
 - cooling-max-level:
      Please refer to Documentation/devicetree/bindings/thermal/thermal.txt.
+- clocks: If CPU clock is populated from DT, "clocks" property must be copied to
+  every cpu node sharing clock with cpu@x. Generic cpufreq driver compares
+  "clocks" to find siblings, i.e. to see which CPUs share clock/voltages. If
+  only cpu@0 contains "clocks" property it is assumed that all CPUs share clock
+  line.
 
 Examples:
 
+1. All CPUs share clock/voltages
+
 cpus {
 	#address-cells = <1>;
 	#size-cells = <0>;
@@ -38,6 +45,8 @@ cpus {
 			396000  950000
 			198000  850000
 		>;
+		clocks = <&clock CLK_ARM_CLK>;
+		clock-names = "cpu";
 		clock-latency = <61036>; /* two CLK32 periods */
 		#cooling-cells = <2>;
 		cooling-min-level = <0>;
@@ -48,17 +57,72 @@ cpus {
 		compatible = "arm,cortex-a9";
 		reg = <1>;
 		next-level-cache = <&L2>;
+		clocks = <&clock CLK_ARM_CLK>;
 	};
 
 	cpu@2 {
 		compatible = "arm,cortex-a9";
 		reg = <2>;
 		next-level-cache = <&L2>;
+		clocks = <&clock CLK_ARM_CLK>;
 	};
 
 	cpu@3 {
 		compatible = "arm,cortex-a9";
 		reg = <3>;
 		next-level-cache = <&L2>;
+		clocks = <&clock CLK_ARM_CLK>;
+	};
+};
+
+
+2. All CPUs inside a cluster share clock/voltages, there are multiple clusters.
+
+cpus {
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	cpu@0 {
+		compatible = "arm,cortex-a15";
+		reg = <0>;
+		next-level-cache = <&L2>;
+		operating-points = <
+			/* kHz    uV */
+			792000  1100000
+			396000  950000
+			198000  850000
+		>;
+		clocks = <&clock CLK_ARM1_CLK>;
+		clock-names = "cpu";
+		clock-latency = <61036>; /* two CLK32 periods */
+	};
+
+	cpu@1 {
+		compatible = "arm,cortex-a15";
+		reg = <1>;
+		next-level-cache = <&L2>;
+		clocks = <&clock CLK_ARM1_CLK>;
+	};
+
+	cpu@100 {
+		compatible = "arm,cortex-a7";
+		reg = <100>;
+		next-level-cache = <&L2>;
+		operating-points = <
+			/* kHz    uV */
+			792000  950000
+			396000  750000
+			198000  450000
+		>;
+		clocks = <&clock CLK_ARM2_CLK>;
+		clock-names = "cpu";
+		clock-latency = <61036>; /* two CLK32 periods */
+	};
+
+	cpu@101 {
+		compatible = "arm,cortex-a7";
+		reg = <101>;
+		next-level-cache = <&L2>;
+		clocks = <&clock CLK_ARM2_CLK>;
 	};
 };
diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 44633f6..0f2fe76 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -177,6 +177,57 @@ try_again:
 	return ret;
 }
 
+/*
+ * Sets all CPUs as sibling if any cpu doesn't have a "clocks" property,
+ * Otherwise it matches "clocks" property to find siblings.
+ */
+static void find_siblings(struct cpufreq_policy *policy)
+{
+	struct private_data *priv = policy->driver_data;
+	struct device *cpu1_dev = priv->cpu_dev, *cpu2_dev;
+	struct device_node *np1, *np2;
+	int cpu, ret, set_all = 1;
+
+	np1 = of_node_get(cpu1_dev->of_node);
+
+	for_each_possible_cpu(cpu) {
+		if (cpu == policy->cpu)
+			continue;
+
+		cpu2_dev = get_cpu_device(cpu);
+		if (!cpu2_dev) {
+			dev_err(cpu1_dev, "%s: failed to cpu_dev for cpu%d\n",
+				__func__, cpu);
+			goto out_set_all;
+		}
+
+		np2 = of_node_get(cpu2_dev->of_node);
+		if (!np2) {
+			dev_err(cpu1_dev, "failed to find cpu%d node\n", cpu);
+			goto out_set_all;
+		}
+
+		ret = of_property_match(np1, np2, "clocks");
+		of_node_put(np2);
+
+		/* Error while parsing nodes, fallback to set-all */
+		if (ret < 0)
+			goto out_set_all;
+		else if (ret == 1)
+			cpumask_set_cpu(cpu, policy->cpus);
+	}
+
+	/* All processors don't share clock and voltage */
+	set_all = 0;
+
+out_set_all:
+	/* All processors share clock and voltage */
+	if (set_all)
+		cpumask_setall(policy->cpus);
+
+	of_node_put(np1);
+}
+
 static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
 {
 	struct cpufreq_frequency_table *freq_table;
@@ -266,9 +317,16 @@ static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
 	policy->driver_data = priv;
 
 	policy->clk = cpu_clk;
-	ret = cpufreq_generic_init(policy, freq_table, transition_latency);
-	if (ret)
+
+	find_siblings(policy);
+	ret = cpufreq_table_validate_and_show(policy, freq_table);
+	if (ret) {
+		dev_err(cpu_dev, "%s: invalid frequency table: %d\n", __func__,
+			ret);
 		goto out_cooling_unregister;
+	}
+
+	policy->cpuinfo.transition_latency = transition_latency;
 
 	return 0;
 
-- 
2.0.0.rc2


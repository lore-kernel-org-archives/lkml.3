Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3I0DPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 23:15:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42000 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab3I0DPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 23:15:45 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>
CC: <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>, <cpufreq@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCHv4 06/18] cpufreq: cpufreq-cpu0: add dt node parsing for cooling device properties
Date: Thu, 26 Sep 2013 23:13:13 -0400
Message-ID: <1380251605-3804-7-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1380251605-3804-1-git-send-email-eduardo.valentin@ti.com>
References: <1380251605-3804-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the cpufreq-cpu0 driver to consider if
a cpu needs cooling (with cpufreq). In case the cooling is needed,
the cpu0 device tree node needs to be properly configured
with cooling device properties.

In case these properties are present,, the driver will
load a cpufreq cooling device in the system. The cpufreq-cpu0
driver is not interested in determining how the system should
be using the cooling device. The driver is responsible
only of loading the cooling device.

Describing how the cooling device will be used can be
accomplished by setting up a thermal zone that references
and is composed by the cpufreq cooling device.

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: cpufreq@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt         |  7 +++++++
 drivers/cpufreq/Kconfig                                  |  2 +-
 drivers/cpufreq/cpufreq-cpu0.c                           | 16 ++++++++++++++++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
index 051f764..f055515 100644
--- a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
+++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
@@ -15,6 +15,10 @@ Optional properties:
 - clock-latency: Specify the possible maximum transition latency for clock,
   in unit of nanoseconds.
 - voltage-tolerance: Specify the CPU voltage tolerance in percentage.
+- #cooling-cells:
+- cooling-min-level:
+- cooling-max-level:
+     Please refer to Documentation/devicetree/bindings/thermal/thermal.txt.
 
 Examples:
 
@@ -33,6 +37,9 @@ cpus {
 			198000  850000
 		>;
 		clock-latency = <61036>; /* two CLK32 periods */
+		#cooling-cells = <2>;
+		cooling-min-level = <0>;
+		cooling-max-level = <2>;
 	};
 
 	cpu@1 {
diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 534fcb8..fc1e9a5 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -186,7 +186,7 @@ config CPU_FREQ_GOV_CONSERVATIVE
 
 config GENERIC_CPUFREQ_CPU0
 	tristate "Generic CPU0 cpufreq driver"
-	depends on HAVE_CLK && REGULATOR && PM_OPP && OF
+	depends on HAVE_CLK && REGULATOR && PM_OPP && OF && THERMAL && CPU_THERMAL
 	select CPU_FREQ_TABLE
 	help
 	  This adds a generic cpufreq driver for CPU0 frequency management.
diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 78c49d8..fd707b8 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -13,7 +13,9 @@
 
 #include <linux/clk.h>
 #include <linux/cpu.h>
+#include <linux/cpu_cooling.h>
 #include <linux/cpufreq.h>
+#include <linux/cpumask.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -21,6 +23,7 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
+#include <linux/thermal.h>
 
 static unsigned int transition_latency;
 static unsigned int voltage_tolerance; /* in percentage */
@@ -29,6 +32,7 @@ static struct device *cpu_dev;
 static struct clk *cpu_clk;
 static struct regulator *cpu_reg;
 static struct cpufreq_frequency_table *freq_table;
+static struct thermal_cooling_device *cdev;
 
 static int cpu0_verify_speed(struct cpufreq_policy *policy)
 {
@@ -260,6 +264,17 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 		goto out_free_table;
 	}
 
+	/*
+	 * For now, just loading the cooling device;
+	 * thermal DT code takes care of matching them.
+	 */
+	if (of_find_property(np, "#cooling-cells", NULL)) {
+		cdev = of_cpufreq_cooling_register(np, cpu_present_mask);
+		if (IS_ERR(cdev))
+			pr_err("running cpufreq without cooling device: %ld\n",
+			       PTR_ERR(cdev));
+	}
+
 	of_node_put(np);
 	return 0;
 
@@ -272,6 +287,7 @@ out_put_node:
 
 static int cpu0_cpufreq_remove(struct platform_device *pdev)
 {
+	cpufreq_cooling_unregister(cdev);
 	cpufreq_unregister_driver(&cpu0_cpufreq_driver);
 	opp_free_cpufreq_table(cpu_dev, &freq_table);
 
-- 
1.8.2.1.342.gfa7285d


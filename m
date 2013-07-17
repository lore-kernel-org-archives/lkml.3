Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab3GQPKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:10:04 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33552 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab3GQPEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:04:23 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>
CC: <wni@nvidia.com>, <l.stach@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <lm-sensors@lm-sensors.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, <cpufreq@vger.kernel.org>
Subject: [PATCH 1/9] cpufreq: cpufreq-cpu0: add dt node parsing for 'needs-cooling'
Date: Wed, 17 Jul 2013 11:02:37 -0400
Message-ID: <1374073374-30946-2-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1374073374-30946-1-git-send-email-eduardo.valentin@ti.com>
References: <1374073374-30946-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the cpufreq-cpu0 driver to consider if
a cpu needs cooling (with cpufreq). In case the cooling is needed,
it can be flagged at the cpu0 device tree node, with the boolean
property 'needs-cooling'.

In case this boolean is present, the driver will
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
 Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt | 3 +++
 drivers/cpufreq/cpufreq-cpu0.c                             | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
index 051f764..e8ff916 100644
--- a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
+++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
@@ -15,6 +15,8 @@ Optional properties:
 - clock-latency: Specify the possible maximum transition latency for clock,
   in unit of nanoseconds.
 - voltage-tolerance: Specify the CPU voltage tolerance in percentage.
+- needs-cooling: The generic cpu cooling (freq clipping) is loaded by the
+generic cpufreq-cpu0 driver in case the device tree node has this boolean.
 
 Examples:
 
@@ -33,6 +35,7 @@ cpus {
 			198000  850000
 		>;
 		clock-latency = <61036>; /* two CLK32 periods */
+		needs-cooling;
 	};
 
 	cpu@1 {
diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index ad1fde2..4a8747a 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -20,6 +20,9 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
+#include <linux/thermal.h>
+#include <linux/cpu_cooling.h>
+#include <linux/cpumask.h>
 
 static unsigned int transition_latency;
 static unsigned int voltage_tolerance; /* in percentage */
@@ -28,6 +31,7 @@ static struct device *cpu_dev;
 static struct clk *cpu_clk;
 static struct regulator *cpu_reg;
 static struct cpufreq_frequency_table *freq_table;
+static struct thermal_cooling_device *cdev;
 
 static int cpu0_verify_speed(struct cpufreq_policy *policy)
 {
@@ -268,6 +272,9 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 		goto out_free_table;
 	}
 
+	if (of_property_read_bool(np, "needs-cooling"))
+		cdev = cpufreq_cooling_register(cpu_present_mask);
+
 	of_node_put(np);
 	of_node_put(parent);
 	return 0;
@@ -283,6 +290,7 @@ out_put_parent:
 
 static int cpu0_cpufreq_remove(struct platform_device *pdev)
 {
+	cpufreq_cooling_unregister(cdev);
 	cpufreq_unregister_driver(&cpu0_cpufreq_driver);
 	opp_free_cpufreq_table(cpu_dev, &freq_table);
 
-- 
1.8.2.1.342.gfa7285d


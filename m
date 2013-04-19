Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030289Ab3DSMCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:02:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40988 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968123Ab3DSMCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:02:06 -0400
From: Taras Kondratiuk <taras@ti.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <rjw@sisk.pl>,
        <viresh.kumar@linaro.org>, <shawn.guo@linaro.org>
CC: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Taras Kondratiuk <taras@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [RFC PATCH 2/2] cpufreq: cpufreq-cpu0: Limit minimum voltage only
Date: Fri, 19 Apr 2013 14:55:54 +0300
Message-ID: <1366372554-20866-3-git-send-email-taras@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366372554-20866-1-git-send-email-taras@ti.com>
References: <1366372554-20866-1-git-send-email-taras@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq-cpu0 uses regulator_set_voltage_tol() API
to set CPU regulator voltage to some narrow range around OPP voltage.
It creates an issue if CPU regulator device has other consumers,
because their request doesn't overlap with cpufreq's one.
Normally cpufreq should constrain only lower voltage limit,
so other consumers have a chance to set their own constraints.

Use regulator_set_voltage_min() API to limit minimum voltage.
Remove a voltage tolerance parameter as redundant.

Signed-off-by: Taras Kondratiuk <taras@ti.com>
---
 drivers/cpufreq/cpufreq-cpu0.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 37d23a0..e494a97 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -22,7 +22,6 @@
 #include <linux/slab.h>
 
 static unsigned int transition_latency;
-static unsigned int voltage_tolerance; /* in percentage */
 
 static struct device *cpu_dev;
 static struct clk *cpu_clk;
@@ -44,7 +43,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 {
 	struct cpufreq_freqs freqs;
 	struct opp *opp;
-	unsigned long freq_Hz, volt = 0, volt_old = 0, tol = 0;
+	unsigned long freq_Hz, volt = 0, volt_old = 0;
 	unsigned int index, cpu;
 	int ret;
 
@@ -80,7 +79,6 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 		}
 		volt = opp_get_voltage(opp);
 		rcu_read_unlock();
-		tol = volt * voltage_tolerance / 100;
 		volt_old = regulator_get_voltage(cpu_reg);
 	}
 
@@ -90,7 +88,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 
 	/* scaling up?  scale voltage before frequency */
 	if (cpu_reg && freqs.new > freqs.old) {
-		ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
+		ret = regulator_set_voltage_min(cpu_reg, volt);
 		if (ret) {
 			pr_err("failed to scale voltage up: %d\n", ret);
 			freqs.new = freqs.old;
@@ -102,13 +100,13 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 	if (ret) {
 		pr_err("failed to set clock rate: %d\n", ret);
 		if (cpu_reg)
-			regulator_set_voltage_tol(cpu_reg, volt_old, tol);
+			regulator_set_voltage_min(cpu_reg, volt_old);
 		return ret;
 	}
 
 	/* scaling down?  scale voltage after frequency */
 	if (cpu_reg && freqs.new < freqs.old) {
-		ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
+		ret = regulator_set_voltage_min(cpu_reg, volt);
 		if (ret) {
 			pr_err("failed to scale voltage down: %d\n", ret);
 			clk_set_rate(cpu_clk, freqs.old * 1000);
@@ -225,8 +223,6 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 		goto out_put_node;
 	}
 
-	of_property_read_u32(np, "voltage-tolerance", &voltage_tolerance);
-
 	if (of_property_read_u32(np, "clock-latency", &transition_latency))
 		transition_latency = CPUFREQ_ETERNAL;
 
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab3JXSIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 14:08:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42926 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552Ab3JXSIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 14:08:13 -0400
From: Nishanth Menon <nm@ti.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [RFC PATCH] cpufreq: cpufreq-cpu0: do not allow transitions with regulators suspended
Date: Thu, 24 Oct 2013 13:08:07 -0500
Message-ID: <1382638087-32054-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For platforms where regulators are used, regulator access tends to be
disabled as part of the suspend path. In SMP systems such as OMAP,
CPU1 is disabled as post suspend_noirq. This results in the following
tail end sequence of actions:
cpufreq_cpu_callback gets called with CPU_POST_DEAD
	__cpufreq_remove_dev_finish is invoked as a result
		__cpufreq_governor(policy, CPUFREQ_GOV_START) is
		triggered

At this point, with ondemand governor, if the cpu entered suspend path
at a lower OPP, this triggers a transition request. However, since
irqs are disabled, typically, regulator control using I2C operations
are not possible either, regulator operations will naturally fail
(even though clk_set_rate might succeed depending on the platform).

Unfortunately, cpufreq_driver->suspend|resume is too late as well, since
they are invoked as part of syscore_ops (after CPU1 is hotplugged out).

The proposal here is to use pm notifier suspend to disable any
requests to target, as we may very well expect this to fail at a later
suspend sequence.

Reported-by: J Keerthy <j-keerthy@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
based on: v3.12-rc6
Tested on v3.12-rc6 vendor forked tree which supports suspend
Platform: OMAP5uEVM

Sample of the stack with i2c failure: http://pastebin.com/m5KxnB7a
With i2c failure fixed: http://pastebin.com/8AfX4e7r

I am open to alternative proposals if any - one option might be to
introduce a similar behavior at cpufreq level as allowing cpufreq
transitions in suspend path is probably not necessary.

If folks think that respinning this patch such that there is no
dependency on regulator to set is_suspended, it is fine with me as
well.

 drivers/cpufreq/cpufreq-cpu0.c |   47 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index c522a95..401d975 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -21,6 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
+#include <linux/suspend.h>
 
 static unsigned int transition_latency;
 static unsigned int voltage_tolerance; /* in percentage */
@@ -29,6 +30,8 @@ static struct device *cpu_dev;
 static struct clk *cpu_clk;
 static struct regulator *cpu_reg;
 static struct cpufreq_frequency_table *freq_table;
+static DEFINE_MUTEX(cpu_lock);
+static bool is_suspended;
 
 static int cpu0_verify_speed(struct cpufreq_policy *policy)
 {
@@ -50,12 +53,19 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 	unsigned int index;
 	int ret;
 
+	mutex_lock(&cpu_lock);
+
+	if (is_suspended) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	ret = cpufreq_frequency_table_target(policy, freq_table, target_freq,
 					     relation, &index);
 	if (ret) {
 		pr_err("failed to match target freqency %d: %d\n",
 		       target_freq, ret);
-		return ret;
+		goto out;
 	}
 
 	freq_Hz = clk_round_rate(cpu_clk, freq_table[index].frequency * 1000);
@@ -65,8 +75,10 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 	freqs.new = freq_Hz / 1000;
 	freqs.old = clk_get_rate(cpu_clk) / 1000;
 
-	if (freqs.old == freqs.new)
-		return 0;
+	if (freqs.old == freqs.new) {
+		ret = 0;
+		goto out;
+	}
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
@@ -122,9 +134,32 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 post_notify:
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 
+out:
+	mutex_unlock(&cpu_lock);
 	return ret;
 }
 
+static int cpu0_pm_notify(struct notifier_block *nb, unsigned long event,
+	void *dummy)
+{
+	mutex_lock(&cpu_lock);
+	switch (event) {
+	case PM_SUSPEND_PREPARE:
+		is_suspended = true;
+		break;
+	case PM_POST_SUSPEND:
+		is_suspended = false;
+		break;
+	}
+	mutex_unlock(&cpu_lock);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block cpu_pm_notifier = {
+	.notifier_call = cpu0_pm_notify,
+};
+
 static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
 {
 	int ret;
@@ -147,11 +182,17 @@ static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
 
 	cpufreq_frequency_table_get_attr(freq_table, policy->cpu);
 
+	if (!IS_ERR(cpu_reg))
+		register_pm_notifier(&cpu_pm_notifier);
+
 	return 0;
 }
 
 static int cpu0_cpufreq_exit(struct cpufreq_policy *policy)
 {
+	if (!IS_ERR(cpu_reg))
+		unregister_pm_notifier(&cpu_pm_notifier);
+
 	cpufreq_frequency_table_put_attr(policy->cpu);
 
 	return 0;
-- 
1.7.9.5


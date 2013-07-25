Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab3GYQgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:36:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51433 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab3GYQeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:34:12 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-94-51f1538257ac
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com
Subject: [PATCH v6 3/8] cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to
 work with common boost solution
Date: Thu, 25 Jul 2013 18:33:26 +0200
Message-id: <1374770011-22171-4-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9jQd2m4I+BBg33pC02zljPavG06Qe7
	xbzPshZ9P68wW6zZ/5PJovPsE2aL3gVX2SzePOK2ePNwM6PF5V1z2Cw+9x5htLjduILNon9h
	L5PFk4d9bBYbv3o48Hss3vOSyePOtT1sHuumvWX26NuyitHj0eIWRo/jN7YzeXzeJBfAHsVl
	k5Kak1mWWqRvl8CVseOQScFiw4rZba9YGhgXaHQxcnJICJhIHF69hQnCFpO4cG89WxcjF4eQ
	wHRGid99hxhBEkICXUwSW25wgdhsAnoSn+8+BWsQEZjDKHHnqDtIA7PAA2aJxd+/gDUIC+RK
	7L15kw3EZhFQlXg2axYriM0r4CaxcsJeqG3yEk/v94HVcAq4S0yYPIURYnMTo8S/G3eZJzDy
	LmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHLTPpHYwrmywOMQowMGoxMOr4PQxUIg1
	say4MvcQowQHs5IIr7klUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS1OzU1ILU
	IpgsEwenVAPjUrl7wqHR2Vf/u62RUHC98yruntUd5f//2ad/2Fmyg+nj2VWie0MYdG+oMm77
	fufrwUBtteI4/jmzrvimfNzo9aP34bwfMS1+NWvOcM3JyJ0QGBD/vbw28XdAE48Y763w77Od
	ZA7znmNONEne7rmzo/tn3vNzE/hr5A/XOjVfOiXz8VzgvmI/JZbijERDLeai4kQAC7VD/lYC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel's hardware based boost solution driver has been changed to cooperate with
common cpufreq boost framework.

The global sysfs boost attribute entry code (/sys/devices/system/cpu/cpufreq/boost)
has been moved to a core cpufreq code. This attribute is now only visible,
when cpufreq driver supports it.

The _store_boost() function has been redesigned to be used as set_boost
callback.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

---
Changes for v6:
- Perform acpi_cpufreq_boost_init initialization before cpufreq_driver
  registration
- Compile store_boost() only when CONFIG_X86_ACPI_CPUFREQ_CPB defined
- Use boost_enabled flag defined at acpi_cpufreq_driver to store information
  about boost state
- Instead of using cpufreq_set_boost_enabled(), modify the boost_enable in
  the acpi driver code

Changes for v5:
- Remove acpi-cpufreq's boost_enabled global flag and reuse one defined at
  cpufreq core

Changes for v4:
- add _store_boost to acpi_cpufreq_driver structure

Changes for v3:
- Bring back boost_enabled as a global flag
- Move boost_supported to cpufreq_driver structure

Changes for v2:
- Replace boost_enabled and boost_supported global flags with proper entries
  at struct cpufreq_driver.
- Removal of struct cpufreq_boost

 drivers/cpufreq/acpi-cpufreq.c |   87 ++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 57 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 3926402..509764c 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -81,7 +81,6 @@ static struct acpi_processor_performance __percpu *acpi_perf_data;
 static struct cpufreq_driver acpi_cpufreq_driver;
 
 static unsigned int acpi_pstate_strict;
-static bool boost_enabled, boost_supported;
 static struct msr __percpu *msrs;
 
 static bool boost_state(unsigned int cpu)
@@ -134,49 +133,16 @@ static void boost_set_msrs(bool enable, const struct cpumask *cpumask)
 	wrmsr_on_cpus(cpumask, msr_addr, msrs);
 }
 
-static ssize_t _store_boost(const char *buf, size_t count)
+static int _store_boost(int val)
 {
-	int ret;
-	unsigned long val = 0;
-
-	if (!boost_supported)
-		return -EINVAL;
-
-	ret = kstrtoul(buf, 10, &val);
-	if (ret || (val > 1))
-		return -EINVAL;
-
-	if ((val && boost_enabled) || (!val && !boost_enabled))
-		return count;
-
 	get_online_cpus();
-
 	boost_set_msrs(val, cpu_online_mask);
-
 	put_online_cpus();
-
-	boost_enabled = val;
 	pr_debug("Core Boosting %sabled.\n", val ? "en" : "dis");
 
-	return count;
-}
-
-static ssize_t store_global_boost(struct kobject *kobj, struct attribute *attr,
-				  const char *buf, size_t count)
-{
-	return _store_boost(buf, count);
-}
-
-static ssize_t show_global_boost(struct kobject *kobj,
-				 struct attribute *attr, char *buf)
-{
-	return sprintf(buf, "%u\n", boost_enabled);
+	return 0;
 }
 
-static struct global_attr global_boost = __ATTR(boost, 0644,
-						show_global_boost,
-						store_global_boost);
-
 static ssize_t show_freqdomain_cpus(struct cpufreq_policy *policy, char *buf)
 {
 	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, policy->cpu);
@@ -187,15 +153,32 @@ static ssize_t show_freqdomain_cpus(struct cpufreq_policy *policy, char *buf)
 cpufreq_freq_attr_ro(freqdomain_cpus);
 
 #ifdef CONFIG_X86_ACPI_CPUFREQ_CPB
+static ssize_t store_boost(const char *buf, size_t count)
+{
+	int ret;
+	unsigned long val = 0;
+
+	if (!acpi_cpufreq_driver.boost_supported)
+		return -EINVAL;
+
+	ret = kstrtoul(buf, 10, &val);
+	if (ret || (val > 1))
+		return -EINVAL;
+
+	_store_boost((int) val);
+
+	return count;
+}
+
 static ssize_t store_cpb(struct cpufreq_policy *policy, const char *buf,
 			 size_t count)
 {
-	return _store_boost(buf, count);
+	return store_boost(buf, count);
 }
 
 static ssize_t show_cpb(struct cpufreq_policy *policy, char *buf)
 {
-	return sprintf(buf, "%u\n", boost_enabled);
+	return sprintf(buf, "%u\n", acpi_cpufreq_driver.boost_enabled);
 }
 
 static struct freq_attr cpb = __ATTR(cpb, 0644, show_cpb, store_cpb);
@@ -583,7 +566,7 @@ static int boost_notify(struct notifier_block *nb, unsigned long action,
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		boost_set_msrs(boost_enabled, cpumask);
+		boost_set_msrs(acpi_cpufreq_driver.boost_enabled, cpumask);
 		break;
 
 	case CPU_DOWN_PREPARE:
@@ -943,43 +926,34 @@ static struct cpufreq_driver acpi_cpufreq_driver = {
 	.name		= "acpi-cpufreq",
 	.owner		= THIS_MODULE,
 	.attr		= acpi_cpufreq_attr,
+	.set_boost      = _store_boost,
 };
 
 static void __init acpi_cpufreq_boost_init(void)
 {
+	acpi_cpufreq_driver.boost_supported = false;
 	if (boot_cpu_has(X86_FEATURE_CPB) || boot_cpu_has(X86_FEATURE_IDA)) {
 		msrs = msrs_alloc();
 
 		if (!msrs)
 			return;
 
-		boost_supported = true;
-		boost_enabled = boost_state(0);
-
+		acpi_cpufreq_driver.boost_supported = true;
+		acpi_cpufreq_driver.boost_enabled = boost_state(0);
 		get_online_cpus();
 
 		/* Force all MSRs to the same value */
-		boost_set_msrs(boost_enabled, cpu_online_mask);
+		boost_set_msrs(acpi_cpufreq_driver.boost_enabled,
+			       cpu_online_mask);
 
 		register_cpu_notifier(&boost_nb);
 
 		put_online_cpus();
-	} else
-		global_boost.attr.mode = 0444;
-
-	/* We create the boost file in any case, though for systems without
-	 * hardware support it will be read-only and hardwired to return 0.
-	 */
-	if (cpufreq_sysfs_create_file(&(global_boost.attr)))
-		pr_warn(PFX "could not register global boost sysfs file\n");
-	else
-		pr_debug("registered global boost sysfs file\n");
+	}
 }
 
 static void __exit acpi_cpufreq_boost_exit(void)
 {
-	cpufreq_sysfs_remove_file(&(global_boost.attr));
-
 	if (msrs) {
 		unregister_cpu_notifier(&boost_nb);
 
@@ -1021,12 +995,11 @@ static int __init acpi_cpufreq_init(void)
 			*iter = &cpb;
 	}
 #endif
+	acpi_cpufreq_boost_init();
 
 	ret = cpufreq_register_driver(&acpi_cpufreq_driver);
 	if (ret)
 		free_acpi_perf_data();
-	else
-		acpi_cpufreq_boost_init();
 
 	return ret;
 }
-- 
1.7.10.4


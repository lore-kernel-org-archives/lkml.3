Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964880Ab3GDIvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 04:51:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34848 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933705Ab3GDIvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 04:51:13 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-74-51d537791cb9
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v5 3/7] cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to
 work with common boost solution
Date: Thu, 04 Jul 2013 10:50:26 +0200
Message-id: <1372927830-2949-4-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t9jAd1K86uBBg2zxCz+vF3OavG06Qe7
	xbzPshZr9v9ksug8+4TZonfBVTaLN4+4Ld483MxocXnXHDaLz71HGC1uN65gs+hf2Mtk8eRh
	H5vFxq8eDnwei/e8ZPK4c20Pm8e6aW+ZPfq2rGL0eLS4hdHj+I3tTB6fN8kFsEdx2aSk5mSW
	pRbp2yVwZVx9O42poEGrYseE9UwNjHuUuhg5OSQETCSapjUyQdhiEhfurWfrYuTiEBJYxCix
	5ekpZgini0mi9c0XdpAqNgE9ic93n4J1iAjMYZS4c9QdxGYWWMkscaLREcQWFsiV6L2zlBnE
	ZhFQlZh0byJYPa+Aq8S9KY2sENvkJZ7e72MDsTkF3CQuX+hhgljWyCixoeMDywRG3gWMDKsY
	RVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgoP1mdQOxpUNFocYBTgYlXh4JayuBAqxJpYVV+Ye
	YpTgYFYS4XXiuBooxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdAq3WgkEB6YklqdmpqQWoRTJaJ
	g1OqgdFS5e/bV18qZ4Z/y/u9V/RvfdT8ifdqrP0vqX4N4uGYEL1fXOC5zcJFN1hVDnQtmvnH
	MW1yk/3Tb2pCs0K2tLx7Garae6VjVVZbyZ59Wm3Hbdg5OB5VrOG7HCuuKbemxTvh1rvzKsy5
	haVaf9clnLr9cF7h7vSzniLFpyqFDl++cu5/h8N99nQlluKMREMt5qLiRAAJCm0zUgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel's hardware based boost solution driver has been changed to cooperate with
common cpufreq boost framework.

The global sysfs boost attribute entry code (/sys/devices/system/cpu/cpufreq/boost)
has been moved to a core cpufreq code. This attribute is now only visible,
when cpufreq driver supports it.

The _store_boost() function has been redesigned to be used as set_boost_freq
callback.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

---
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

 drivers/cpufreq/acpi-cpufreq.c |   69 ++++++++++++----------------------------
 1 file changed, 21 insertions(+), 48 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 3926402..113a928 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -81,7 +81,6 @@ static struct acpi_processor_performance __percpu *acpi_perf_data;
 static struct cpufreq_driver acpi_cpufreq_driver;
 
 static unsigned int acpi_pstate_strict;
-static bool boost_enabled, boost_supported;
 static struct msr __percpu *msrs;
 
 static bool boost_state(unsigned int cpu)
@@ -134,49 +133,33 @@ static void boost_set_msrs(bool enable, const struct cpumask *cpumask)
 	wrmsr_on_cpus(cpumask, msr_addr, msrs);
 }
 
-static ssize_t _store_boost(const char *buf, size_t count)
+static int _store_boost(int val)
+{
+	get_online_cpus();
+	boost_set_msrs(val, cpu_online_mask);
+	put_online_cpus();
+	pr_debug("Core Boosting %sabled.\n", val ? "en" : "dis");
+
+	return 0;
+}
+
+static ssize_t store_boost(const char *buf, size_t count)
 {
 	int ret;
 	unsigned long val = 0;
 
-	if (!boost_supported)
+	if (!acpi_cpufreq_driver.boost_supported)
 		return -EINVAL;
 
 	ret = kstrtoul(buf, 10, &val);
 	if (ret || (val > 1))
 		return -EINVAL;
 
-	if ((val && boost_enabled) || (!val && !boost_enabled))
-		return count;
-
-	get_online_cpus();
-
-	boost_set_msrs(val, cpu_online_mask);
-
-	put_online_cpus();
-
-	boost_enabled = val;
-	pr_debug("Core Boosting %sabled.\n", val ? "en" : "dis");
+	_store_boost((int) val);
 
 	return count;
 }
 
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
-}
-
-static struct global_attr global_boost = __ATTR(boost, 0644,
-						show_global_boost,
-						store_global_boost);
-
 static ssize_t show_freqdomain_cpus(struct cpufreq_policy *policy, char *buf)
 {
 	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, policy->cpu);
@@ -190,12 +173,12 @@ cpufreq_freq_attr_ro(freqdomain_cpus);
 static ssize_t store_cpb(struct cpufreq_policy *policy, const char *buf,
 			 size_t count)
 {
-	return _store_boost(buf, count);
+	return store_boost(buf, count);
 }
 
 static ssize_t show_cpb(struct cpufreq_policy *policy, char *buf)
 {
-	return sprintf(buf, "%u\n", boost_enabled);
+	return sprintf(buf, "%u\n", cpufreq_boost_enabled());
 }
 
 static struct freq_attr cpb = __ATTR(cpb, 0644, show_cpb, store_cpb);
@@ -583,7 +566,7 @@ static int boost_notify(struct notifier_block *nb, unsigned long action,
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		boost_set_msrs(boost_enabled, cpumask);
+		boost_set_msrs(cpufreq_boost_enabled(), cpumask);
 		break;
 
 	case CPU_DOWN_PREPARE:
@@ -943,6 +926,7 @@ static struct cpufreq_driver acpi_cpufreq_driver = {
 	.name		= "acpi-cpufreq",
 	.owner		= THIS_MODULE,
 	.attr		= acpi_cpufreq_attr,
+	.enable_boost   = _store_boost,
 };
 
 static void __init acpi_cpufreq_boost_init(void)
@@ -953,33 +937,22 @@ static void __init acpi_cpufreq_boost_init(void)
 		if (!msrs)
 			return;
 
-		boost_supported = true;
-		boost_enabled = boost_state(0);
+		cpufreq_set_boost_enabled(boost_state(0));
+		acpi_cpufreq_driver.boost_supported = true;
 
 		get_online_cpus();
 
 		/* Force all MSRs to the same value */
-		boost_set_msrs(boost_enabled, cpu_online_mask);
+		boost_set_msrs(cpufreq_boost_enabled(), cpu_online_mask);
 
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
 
-- 
1.7.10.4


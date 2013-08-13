Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab3HMKIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 06:08:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10957 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab3HMKIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 06:08:50 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-7e-520a05b1dbb2
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
Subject: [PATCH v7 2/7] cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to
 work with common boost solution
Date: Tue, 13 Aug 2013 12:08:20 +0200
Message-id: <1376388505-30233-3-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1376388505-30233-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1376388505-30233-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t9jAd2NrFxBBituK1tsnLGe1eJp0w92
	i3mfZS36fl5htliz/yeTRefZJ8wWvQuuslm8ecRt8ebhZkaLy7vmsFl87j3CaHG7cQWbRf/C
	XiaLJw/72Cw2fvVw4PdYvOclk8eda3vYPNZNe8vs0bdlFaPHo8UtjB7Hb2xn8vi8SS6APYrL
	JiU1J7MstUjfLoEr4+aHqywF5wwr2leeZ21gPKXRxcjJISFgItH24RYLhC0mceHeerYuRi4O
	IYFFjBJLe3tZIZwuJonWb//YQarYBPQkPt99ygRiiwjMYZS4c9QdpIhZ4AGzxOLvXxhBEsIC
	uRLTJz8Ca2ARUJXouTWXFcTmFXCTWD9jPzvEOnmJp/f72EBsTgF3idX/W6BWNzFKdBw7zDaB
	kXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjODAfSa1g3Flg8UhRgEORiUeXoH3HEFC
	rIllxZW5hxglOJiVRHjjGLmChHhTEiurUovy44tKc1KLDzFKc7AoifMeaLUOFBJITyxJzU5N
	LUgtgskycXBKNTAW2YWbuVdU7FM1DkvO23ftqI7IB2dbV9PIzKIHQmUZU8rPF7/89VPmbbj5
	6i1LvkaZ192cJBL/YSr36+oWuwMTP7/iM373fF7s/Ie7b5wKeLSjbj2LINP59+kuhTOSeSID
	646uCAtVj/j8tP9rkYHJF38T+wOWZ5LTnt82vzSrNONm27zWxjglluKMREMt5qLiRAA6VGzf
	WAIAAA==
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
Changes for v7:
- Remove superfluous acpi_cpufreq_driver.boost_supported = false at
  acpi_cpufreq_boost_init()

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

 drivers/cpufreq/acpi-cpufreq.c |   86 ++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 57 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 9b5d1b1..4400b89 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -80,7 +80,6 @@ static struct acpi_processor_performance __percpu *acpi_perf_data;
 static struct cpufreq_driver acpi_cpufreq_driver;
 
 static unsigned int acpi_pstate_strict;
-static bool boost_enabled, boost_supported;
 static struct msr __percpu *msrs;
 
 static bool boost_state(unsigned int cpu)
@@ -133,49 +132,16 @@ static void boost_set_msrs(bool enable, const struct cpumask *cpumask)
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
@@ -186,15 +152,32 @@ static ssize_t show_freqdomain_cpus(struct cpufreq_policy *policy, char *buf)
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
@@ -582,7 +565,7 @@ static int boost_notify(struct notifier_block *nb, unsigned long action,
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		boost_set_msrs(boost_enabled, cpumask);
+		boost_set_msrs(acpi_cpufreq_driver.boost_enabled, cpumask);
 		break;
 
 	case CPU_DOWN_PREPARE:
@@ -937,6 +920,7 @@ static struct cpufreq_driver acpi_cpufreq_driver = {
 	.resume		= acpi_cpufreq_resume,
 	.name		= "acpi-cpufreq",
 	.attr		= acpi_cpufreq_attr,
+	.set_boost      = _store_boost,
 };
 
 static void __init acpi_cpufreq_boost_init(void)
@@ -947,33 +931,22 @@ static void __init acpi_cpufreq_boost_init(void)
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
 
@@ -1015,12 +988,11 @@ static int __init acpi_cpufreq_init(void)
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


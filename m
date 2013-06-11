Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab3FKJFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 05:05:17 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:17086 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab3FKJFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 05:05:07 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-93-51b6e8421d82
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocky" <rjw@sisk.pl>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH v2 2/3] cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to
 work with common boost solution
Date: Tue, 11 Jun 2013 11:03:27 +0200
Message-id: <1370941408-29304-3-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1370941408-29304-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1370941408-29304-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t9jQV2nF9sCDXbv57b483Y5q8XTph/s
	FvM+y1p0nn3CbNG74CqbxZtH3BZvHm5mtLi8aw6bxefeI4wWtxtXsFn0L+xlsug48o3ZYuNX
	DwdejzvX9rB5rJv2ltmjb8sqRo9Hi1sYPT5vkgtgjeKySUnNySxLLdK3S+DK2H/gF1vBLvWK
	1qNPWBsY1yt0MXJySAiYSEx4eYgNwhaTuHBvPZDNxSEkMJ1RYsHRh4wQTheTxLpvu5hBqtgE
	9CQ+333KBGKLCPhK9Cw7xARSxCzwllni28K/YAlhgVyJyaubwMayCKhK/J39jxHE5hVwk3hy
	cw4TxDp5iaf3+8BqOAXcJR6/3gVmCwk0MUrs/JIzgZF3ASPDKkbR1ILkguKk9FxDveLE3OLS
	vHS95PzcTYzgcHwmtYNxZYPFIUYBDkYlHt4Exm2BQqyJZcWVuYcYJTiYlUR4TbcDhXhTEiur
	Uovy44tKc1KLDzFKc7AoifMeaLUOFBJITyxJzU5NLUgtgskycXBKNTAyqLpmfvV4JPPRfOvl
	vv2fFqjs9X6tETtj0nm5U+9+Ln9QGC3y2THo3ZJjnh+2ZDCujCkTvc4V8panz2GxkGFasKvZ
	9OSXxUImy6duiGaWO9O3L/Cypvx8uR3qeit7tZ1Epj41/rT3Z66op9iO/l2PYyOmfrPzctzX
	b1bVKei+YI3Z2209QtVKLMUZiYZazEXFiQA2vR8WQwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel's hardware based boost solution driver has been changed to cooperate with
common cpufreq boost framework.

The global sysfs boost attribute entry code (/sys/devices/system/cpu/cpufreq/boost)
has been moved to a core cpufreq code. This attribute is now only visible,
when cpufreq driver supports it.
Global flags (boost_enabled and boost_supported) were replaced with boost_en
flag and low_level_boost pointer presence at cpufreq driver structure.

The _store_boost() function has been redesigned to be used as low_level_boost
callback.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

---
Changes for v2:
- Replace boost_enabled and boost_supported global flags with proper entries
at struct cpufreq_driver.
- Removal of struct cpufreq_boost
---
 drivers/cpufreq/acpi-cpufreq.c |   72 +++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 46 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 11b8b4b..a15c999 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -80,7 +80,6 @@ static struct acpi_processor_performance __percpu *acpi_perf_data;
 static struct cpufreq_driver acpi_cpufreq_driver;
 
 static unsigned int acpi_pstate_strict;
-static bool boost_enabled, boost_supported;
 static struct msr __percpu *msrs;
 
 static bool boost_state(unsigned int cpu)
@@ -133,20 +132,11 @@ static void boost_set_msrs(bool enable, const struct cpumask *cpumask)
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
+	if ((val && acpi_cpufreq_driver.boost_en) ||
+	    (!val && !acpi_cpufreq_driver.boost_en))
+		return 0;
 
 	get_online_cpus();
 
@@ -154,38 +144,39 @@ static ssize_t _store_boost(const char *buf, size_t count)
 
 	put_online_cpus();
 
-	boost_enabled = val;
+	acpi_cpufreq_driver.boost_en = val;
 	pr_debug("Core Boosting %sabled.\n", val ? "en" : "dis");
 
-	return count;
+	return 0;
 }
 
-static ssize_t store_global_boost(struct kobject *kobj, struct attribute *attr,
-				  const char *buf, size_t count)
+static ssize_t store_boost(const char *buf, size_t count)
 {
-	return _store_boost(buf, count);
-}
+	int ret;
+	unsigned long val = 0;
 
-static ssize_t show_global_boost(struct kobject *kobj,
-				 struct attribute *attr, char *buf)
-{
-	return sprintf(buf, "%u\n", boost_enabled);
-}
+	if (!acpi_cpufreq_driver.low_level_boost)
+		return -EINVAL;
+
+	ret = kstrtoul(buf, 10, &val);
+	if (ret || (val > 1))
+		return -EINVAL;
 
-static struct global_attr global_boost = __ATTR(boost, 0644,
-						show_global_boost,
-						store_global_boost);
+	_store_boost((int) val);
+
+	return count;
+}
 
 #ifdef CONFIG_X86_ACPI_CPUFREQ_CPB
 static ssize_t store_cpb(struct cpufreq_policy *policy, const char *buf,
 			 size_t count)
 {
-	return _store_boost(buf, count);
+	return store_boost(buf, count);
 }
 
 static ssize_t show_cpb(struct cpufreq_policy *policy, char *buf)
 {
-	return sprintf(buf, "%u\n", boost_enabled);
+	return sprintf(buf, "%u\n", acpi_cpufreq_driver.boost_en);
 }
 
 static struct freq_attr cpb = __ATTR(cpb, 0644, show_cpb, store_cpb);
@@ -571,7 +562,7 @@ static int boost_notify(struct notifier_block *nb, unsigned long action,
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		boost_set_msrs(boost_enabled, cpumask);
+		boost_set_msrs(acpi_cpufreq_driver.boost_en, cpumask);
 		break;
 
 	case CPU_DOWN_PREPARE:
@@ -930,33 +921,22 @@ static void __init acpi_cpufreq_boost_init(void)
 		if (!msrs)
 			return;
 
-		boost_supported = true;
-		boost_enabled = boost_state(0);
+		acpi_cpufreq_driver.low_level_boost = &_store_boost;
+		acpi_cpufreq_driver.boost_en = boost_state(0);
 
 		get_online_cpus();
 
 		/* Force all MSRs to the same value */
-		boost_set_msrs(boost_enabled, cpu_online_mask);
+		boost_set_msrs(acpi_cpufreq_driver.boost_en, cpu_online_mask);
 
 		register_cpu_notifier(&boost_nb);
 
 		put_online_cpus();
-	} else
-		global_boost.attr.mode = 0444;
-
-	/* We create the boost file in any case, though for systems without
-	 * hardware support it will be read-only and hardwired to return 0.
-	 */
-	if (sysfs_create_file(cpufreq_global_kobject, &(global_boost.attr)))
-		pr_warn(PFX "could not register global boost sysfs file\n");
-	else
-		pr_debug("registered global boost sysfs file\n");
+	}
 }
 
 static void __exit acpi_cpufreq_boost_exit(void)
 {
-	sysfs_remove_file(cpufreq_global_kobject, &(global_boost.attr));
-
 	if (msrs) {
 		unregister_cpu_notifier(&boost_nb);
 
-- 
1.7.10.4


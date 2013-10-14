Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab3JNMTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 08:19:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61854 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065Ab3JNMSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:18:46 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-d7-525be125ea21
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com
Subject: [PATCH v9 2/7] cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to
 work with common boost solution
Date: Mon, 14 Oct 2013 14:17:45 +0200
Message-id: <1381753070-2853-3-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1381753070-2853-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1381753070-2853-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t9jAV3Vh9FBBhfOiFlsnLGe1eJp0w92
	i76fV5gt1uz/yWTRefYJs8WbR9wWbx5uZrS4vGsOm8Xn3iOMFrcbV7BZnDl9idXiycM+NouN
	Xz0ceD0W73nJ5HHn2h42j3XT3jJ7bLnazuLRt2UVo8fxG9uZPD5vkgtgj+KySUnNySxLLdK3
	S+DKWPzRuaDbqGLNqr3MDYw/NLoYOTkkBEwkru4+zgxhi0lcuLeeDcQWEljEKDF5U0oXIxeQ
	3cUk0fh/GgtIgk1AT+Lz3adMIAkRgSWMEq+bFrCCOMwCPcwSx69vB2rn4BAWyJV41msD0sAi
	oCqx6eUjVhCbV8BVYkPDNyaIbfIST+/3gW3jFHCTOLVtAzPEtkZGiW3nNrBOYORdwMiwilE0
	tSC5oDgpPddQrzgxt7g0L10vOT93EyM4RJ9J7WBc2WBxiFGAg1GJh1fAKTpIiDWxrLgy9xCj
	BAezkgjvx6tAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHWq0DhQTSE0tSs1NTC1KLYLJMHJxS
	DYwFO5yfmLNu+5vGYrFy2UvznusfwgMu6mw6MfFDUKd7Jq/xtqwjYQaxl35NcM+7Hcy7PF1p
	zQer2R+SCxgyNj4T/xu9WPTKHbEvk99pMeiv6zv978gyw2UBzx/eMqlR1pRtm5Dr4TDpcYfu
	siQznoaO/wJd+wOzjymHB38zi1DY4KTPo2Lx+6oSS3FGoqEWc1FxIgCwL+VxTQIAAA==
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
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

---
Changes for v9:
- None

Changes for v8:
- None

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
index a8dac7b..6a92530 100644
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
 
 cpufreq_freq_attr_rw(cpb);
@@ -573,7 +556,7 @@ static int boost_notify(struct notifier_block *nb, unsigned long action,
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		boost_set_msrs(boost_enabled, cpumask);
+		boost_set_msrs(acpi_cpufreq_driver.boost_enabled, cpumask);
 		break;
 
 	case CPU_DOWN_PREPARE:
@@ -925,6 +908,7 @@ static struct cpufreq_driver acpi_cpufreq_driver = {
 	.resume		= acpi_cpufreq_resume,
 	.name		= "acpi-cpufreq",
 	.attr		= acpi_cpufreq_attr,
+	.set_boost      = _store_boost,
 };
 
 static void __init acpi_cpufreq_boost_init(void)
@@ -935,33 +919,22 @@ static void __init acpi_cpufreq_boost_init(void)
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
 
@@ -1007,12 +980,11 @@ static int __init acpi_cpufreq_init(void)
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


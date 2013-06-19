Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935032Ab3FSROp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:14:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23462 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934978Ab3FSRNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:13:18 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-51-51c1e6acac3f
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
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH v4 3/7] cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to
 work with common boost solution
Date: Wed, 19 Jun 2013 19:12:44 +0200
Message-id: <1371661969-7660-4-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t9jQd01zw4GGuz/L2bx5+1yVounTT/Y
	LeZ9lrVYs/8nk0Xn2SfMFr0LrrJZvHnEbfHm4WZGi8u75rBZfO49wmhxu3EFm0X/wl4miycP
	+9gsOo58Y7bY+NXDgd9j8Z6XTB53ru1h81g37S2zR9+WVYwejxa3MHocv7GdyePzJrkA9igu
	m5TUnMyy1CJ9uwSujMXt35gLpqhU7Fv1g62BcadsFyMnh4SAicSRSc9ZIWwxiQv31rN1MXJx
	CAlMZ5Q4/3UqK4TTxSRxoPs8E0gVm4CexOe7T8FsEQFfiZ5lh5hAipgF9rFITP3WATZKWCBX
	4veyrWwgNouAqsSWG4eBijg4eAVcJSbO1YLYJi/x9H4fWAmngJvE8W9dUJsbGSXWbnjAPIGR
	dwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4LB9Jr2DcVWDxSFGAQ5GJR5ejcsHA4VY
	E8uKK3MPMUpwMCuJ8C49ChTiTUmsrEotyo8vKs1JLT7EKM3BoiTOe7DVOlBIID2xJDU7NbUg
	tQgmy8TBKdXAqMriYfN1cvSmBum5Jg7l86Tu/LgkFVUUlj/FQ7Rth1T68rU3DzT9mZ+S4ffX
	SN6tYXbF8nWq/XF6QYbey5eelT93adPOtYKd1zgmTFT7E/jRpNN34urbigZxNz8cS910gcVF
	e5rdklwXX/UTN3y5P+z/33Vk74LmZ07vPQp9D+0Mmf7nPq/CcSWW4oxEQy3mouJEAL/EynlX	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel's hardware based boost solution driver has been changed to cooperate with
common cpufreq boost framework.

The global sysfs boost attribute entry code (/sys/devices/system/cpu/cpufreq/boost)
has been moved to a core cpufreq code. This attribute is always visible.
When cpufreq driver doesn't support boost, it is read only.
The boost supported global flag was replaced with the one defined at acpi's
cpufreq driver.

The _store_boost() function has been redesigned to be used as set_boost_freq
callback.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

Changes for v4:
- add _store_boost to acpi_cpufreq_driver structure

Changes for v3:
- Bring back boost_enabled as a global flag
- Move boost_supported to cpufreq_driver structure

Changes for v2:
- Replace boost_enabled and boost_supported global flags with proper entries
at struct cpufreq_driver.
- Removal of struct cpufreq_boost
---
 drivers/cpufreq/acpi-cpufreq.c |   61 ++++++++++++++--------------------------
 1 file changed, 21 insertions(+), 40 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 2845566..f33a3c9 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -80,7 +80,7 @@ static struct acpi_processor_performance __percpu *acpi_perf_data;
 static struct cpufreq_driver acpi_cpufreq_driver;
 
 static unsigned int acpi_pstate_strict;
-static bool boost_enabled, boost_supported;
+static bool boost_enabled;
 static struct msr __percpu *msrs;
 
 static bool boost_state(unsigned int cpu)
@@ -133,20 +133,10 @@ static void boost_set_msrs(bool enable, const struct cpumask *cpumask)
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
 	if ((val && boost_enabled) || (!val && !boost_enabled))
-		return count;
+		return 0;
 
 	get_online_cpus();
 
@@ -157,30 +147,31 @@ static ssize_t _store_boost(const char *buf, size_t count)
 	boost_enabled = val;
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
+	if (!acpi_cpufreq_driver.boost_supported)
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
@@ -920,6 +911,7 @@ static struct cpufreq_driver acpi_cpufreq_driver = {
 	.name		= "acpi-cpufreq",
 	.owner		= THIS_MODULE,
 	.attr		= acpi_cpufreq_attr,
+	.enable_boost   = _store_boost,
 };
 
 static void __init acpi_cpufreq_boost_init(void)
@@ -930,8 +922,8 @@ static void __init acpi_cpufreq_boost_init(void)
 		if (!msrs)
 			return;
 
-		boost_supported = true;
 		boost_enabled = boost_state(0);
+		acpi_cpufreq_driver.boost_supported = true;
 
 		get_online_cpus();
 
@@ -941,22 +933,11 @@ static void __init acpi_cpufreq_boost_init(void)
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


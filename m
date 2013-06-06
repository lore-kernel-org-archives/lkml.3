Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab3FFHJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 03:09:39 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11251 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab3FFHJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 03:09:28 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-5a-51b035a7e90e
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
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 3/5] cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to work
 with common boost solution
Date: Thu, 06 Jun 2013 09:07:50 +0200
Message-id: <1370502472-7249-4-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jQd3lphsCDVr+8ln8ebuc1eJp0w92
	i3mfZS06zz5htnjziNvizcPNjBaXd81hs/jce4TR4nbjCjaL/oW9TBYdR74xW2z86uHA43Hn
	2h42j3XT3jJ79G1ZxejxaHELo8fnTXIBrFFcNimpOZllqUX6dglcGT27L7AV3JSr+H/qImMD
	42uJLkZODgkBE4kHm/pZIGwxiQv31rN1MXJxCAlMZ5RYfvMcI4TTxSRx+XYLM0gVm4CexOe7
	T5lAbBEBX4meZYfAbGaBk8wSd48FdjFycAgLZEmcnyILEmYRUJX48ecdO4jNK+AqsfDfViaI
	ZfIST+/3sYHYnAJuEnM/vQCzhYBqbn5YyTKBkXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k
	/NxNjOAAfCa1g3Flg8UhRgEORiUeXomA9YFCrIllxZW5hxglOJiVRHhjRTYECvGmJFZWpRbl
	xxeV5qQWH2KU5mBREuc90GodKCSQnliSmp2aWpBaBJNl4uCUamA0M++8m3fv4DXWkn8rlk36
	NfPk8cIfjzL4G+R0L3xpa0p1Pq+iZbu/o2mZTOz+xDUB91drz0tJ1J2mHHr03+bobReYdtr7
	BUxOyjrl0/33/A125vPb+Cu8eBozXeUiq2u/34ktzhQ/t+Lngk3Jv9RKd+Ut1auzOJPIeXj7
	ig9zLTaFt0W06wsrsRRnJBpqMRcVJwIAA4PQNzwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel's HW based boost solution needs to cooperate with common cpufreq
boost.

For this reason the sysfs handling code (/sys/devices/system/cpu/cpufreq/boost)
has been moved to a core cpufreq.c code.

The _store_boost() function has been redesigned to be used as low_level_boost
callback.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/cpufreq/acpi-cpufreq.c |   64 ++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 38 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 11b8b4b..2c95540 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -133,20 +133,10 @@ static void boost_set_msrs(bool enable, const struct cpumask *cpumask)
 	wrmsr_on_cpus(cpumask, msr_addr, msrs);
 }
 
-static ssize_t _store_boost(const char *buf, size_t count)
+static int _store_boost(struct cpufreq_policy *policy, int val)
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
+	if (!boost_supported)
+		return -EINVAL;
 
-static struct global_attr global_boost = __ATTR(boost, 0644,
-						show_global_boost,
-						store_global_boost);
+	ret = kstrtoul(buf, 10, &val);
+	if (ret || (val > 1))
+		return -EINVAL;
+
+	_store_boost(NULL, (int) val);
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
@@ -910,6 +901,11 @@ static struct freq_attr *acpi_cpufreq_attr[] = {
 	NULL,
 };
 
+static struct cpufreq_boost acpi_boost = {
+	.low_level_boost        = _store_boost,
+	.policies               = LIST_HEAD_INIT(acpi_boost.policies),
+};
+
 static struct cpufreq_driver acpi_cpufreq_driver = {
 	.verify		= acpi_cpufreq_verify,
 	.target		= acpi_cpufreq_target,
@@ -920,6 +916,9 @@ static struct cpufreq_driver acpi_cpufreq_driver = {
 	.name		= "acpi-cpufreq",
 	.owner		= THIS_MODULE,
 	.attr		= acpi_cpufreq_attr,
+#ifdef CONFIG_CPU_FREQ_BOOST
+	.boost		= &acpi_boost,
+#endif
 };
 
 static void __init acpi_cpufreq_boost_init(void)
@@ -941,22 +940,11 @@ static void __init acpi_cpufreq_boost_init(void)
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


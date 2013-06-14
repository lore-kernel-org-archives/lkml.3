Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab3FNHjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 03:39:39 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26622 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab3FNHjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 03:39:36 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-3e-51bac8b606a6
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
Subject: [PATCH v3 2/3] cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to
 work with common boost solution
Date: Fri, 14 Jun 2013 09:38:59 +0200
Message-id: <1371195540-2991-3-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1371195540-2991-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371195540-2991-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t9jQd1tJ3YFGkz7p2Hx5+1yVounTT/Y
	LeZ9lrXoPPuE2aJ3wVU2izePuC3ePNzMaHF51xw2i8+9RxgtbjeuYLPoX9jLZNFx5Buzxcav
	Hg68Hneu7WHzWDftLbNH35ZVjB6PFrcwenzeJBfAGsVlk5Kak1mWWqRvl8CV0TLpJWvBDsWK
	3+c/MjUwzpfuYuTkkBAwkTh/6AwLhC0mceHeerYuRi4OIYHpjBIruicwQzhdTBIPV84Gq2IT
	0JP4fPcpE4gtIuAr0bPsEBNIEbPAW2aJbwv/giWEBXIlPrdNZASxWQRUJXbPbWQHsXkFXCU+
	T57MCrFOXuLp/T42EJtTwE1i2o6HLBDbGhklnh95xzSBkXcBI8MqRtHUguSC4qT0XCO94sTc
	4tK8dL3k/NxNjOCAfCa9g3FVg8UhRgEORiUe3oQLOwOFWBPLiitzDzFKcDArifCG/wUK8aYk
	VlalFuXHF5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYORXV7hgreibuJfn
	NxP3wpWZq0+XRk44GHjm/tpjM/z3bOHZ0fc7of7Rcmv5n9mTZfbM1Ev9ck9Wqn6GzS6e70yz
	D29bupT7neN345CY3a3Oytmf+D1Cc2LfG25bv9Y4yK/iVVTDi3zfjIP5zEkr05dMD9iVxsiV
	b2H62mCPh7ror86fD5oVO5RYijMSDbWYi4oTAUFpFuxEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel's hardware based boost solution driver has been changed to cooperate with
common cpufreq boost framework.

The global sysfs boost attribute entry code (/sys/devices/system/cpu/cpufreq/boost)
has been moved to a core cpufreq code. This attribute is now only visible,
when cpufreq driver supports it.
The boost supported global flag was replaced with the one defined at acpi's
cpufreq driver.

The _store_boost() function has been redesigned to be used as set_boost_freq
callback.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

Changes for v2:
- Replace boost_enabled and boost_supported global flags with proper entries
at struct cpufreq_driver.
- Removal of struct cpufreq_boost

Changes for v3:
- Bring back boost_enabled as a global flag
- Move boost_supported to cpufreq_driver structure

---
 drivers/cpufreq/acpi-cpufreq.c |   60 ++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 40 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index abca529..9cd528e 100644
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
@@ -930,8 +921,8 @@ static void __init acpi_cpufreq_boost_init(void)
 		if (!msrs)
 			return;
 
-		boost_supported = true;
 		boost_enabled = boost_state(0);
+		acpi_cpufreq_driver.boost_supported = true;
 
 		get_online_cpus();
 
@@ -941,22 +932,11 @@ static void __init acpi_cpufreq_boost_init(void)
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


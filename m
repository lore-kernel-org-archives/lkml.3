Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab3CDHia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:38:30 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:54675 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab3CDHi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:38:28 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V3 3/4] cpufreq: Get rid of "struct global_attr"
Date: Mon,  4 Mar 2013 15:37:55 +0800
Message-Id: <c884b346d52c1421fb05583f4eeb0b11ccebbddf.1362381470.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1362381470.git.viresh.kumar@linaro.org>
References: <cover.1362381470.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1362381470.git.viresh.kumar@linaro.org>
References: <cover.1362381470.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to keep two structures for file attributes, global_attr and
freq_attr. Lets use freq_attr only for cpufreq core and drivers.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/acpi-cpufreq.c |  9 ++++-----
 drivers/cpufreq/intel_pstate.c | 20 ++++++++++----------
 include/linux/cpufreq.h        | 16 ----------------
 3 files changed, 14 insertions(+), 31 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index 937bc28..14219c3 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -160,19 +160,18 @@ static ssize_t _store_boost(const char *buf, size_t count)
 	return count;
 }
 
-static ssize_t store_global_boost(struct kobject *kobj, struct attribute *attr,
-				  const char *buf, size_t count)
+static ssize_t store_global_boost(struct cpufreq_policy *policy,
+		const char *buf, size_t count)
 {
 	return _store_boost(buf, count);
 }
 
-static ssize_t show_global_boost(struct kobject *kobj,
-				 struct attribute *attr, char *buf)
+static ssize_t show_global_boost(struct cpufreq_policy *policy, char *buf)
 {
 	return sprintf(buf, "%u\n", boost_enabled);
 }
 
-static struct global_attr global_boost = __ATTR(boost, 0644,
+static struct freq_attr global_boost = __ATTR(boost, 0644,
 						show_global_boost,
 						store_global_boost);
 
diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 096fde0..49846b9 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -275,13 +275,13 @@ static void intel_pstate_debug_expose_params(void)
 /************************** sysfs begin ************************/
 #define show_one(file_name, object)					\
 	static ssize_t show_##file_name					\
-	(struct kobject *kobj, struct attribute *attr, char *buf)	\
+	(struct cpufreq_policy *policy, char *buf)			\
 	{								\
 		return sprintf(buf, "%u\n", limits.object);		\
 	}
 
-static ssize_t store_no_turbo(struct kobject *a, struct attribute *b,
-				const char *buf, size_t count)
+static ssize_t store_no_turbo(struct cpufreq_policy *policy, const char *buf,
+		size_t count)
 {
 	unsigned int input;
 	int ret;
@@ -293,8 +293,8 @@ static ssize_t store_no_turbo(struct kobject *a, struct attribute *b,
 	return count;
 }
 
-static ssize_t store_max_perf_pct(struct kobject *a, struct attribute *b,
-				const char *buf, size_t count)
+static ssize_t store_max_perf_pct(struct cpufreq_policy *policy,
+		const char *buf, size_t count)
 {
 	unsigned int input;
 	int ret;
@@ -307,8 +307,8 @@ static ssize_t store_max_perf_pct(struct kobject *a, struct attribute *b,
 	return count;
 }
 
-static ssize_t store_min_perf_pct(struct kobject *a, struct attribute *b,
-				const char *buf, size_t count)
+static ssize_t store_min_perf_pct(struct cpufreq_policy *policy,
+		const char *buf, size_t count)
 {
 	unsigned int input;
 	int ret;
@@ -325,9 +325,9 @@ show_one(no_turbo, no_turbo);
 show_one(max_perf_pct, max_perf_pct);
 show_one(min_perf_pct, min_perf_pct);
 
-define_one_global_rw(no_turbo);
-define_one_global_rw(max_perf_pct);
-define_one_global_rw(min_perf_pct);
+cpufreq_freq_attr_rw(no_turbo);
+cpufreq_freq_attr_rw(max_perf_pct);
+cpufreq_freq_attr_rw(min_perf_pct);
 
 static struct attribute *intel_pstate_attributes[] = {
 	&no_turbo.attr,
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index c5ac9a5..6e1abd2 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -320,22 +320,6 @@ __ATTR(_name, _perm, show_##_name, NULL)
 static struct freq_attr _name =			\
 __ATTR(_name, 0644, show_##_name, store_##_name)
 
-struct global_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct kobject *kobj,
-			struct attribute *attr, char *buf);
-	ssize_t (*store)(struct kobject *a, struct attribute *b,
-			 const char *c, size_t count);
-};
-
-#define define_one_global_ro(_name)		\
-static struct global_attr _name =		\
-__ATTR(_name, 0444, show_##_name, NULL)
-
-#define define_one_global_rw(_name)		\
-static struct global_attr _name =		\
-__ATTR(_name, 0644, show_##_name, store_##_name)
-
 struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu);
 void cpufreq_cpu_put(struct cpufreq_policy *data);
 const char *cpufreq_get_current_driver(void);
-- 
1.7.12.rc2.18.g61b472e


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab3IMNDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:03:54 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:63182 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab3IMNDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:03:50 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 007/228] cpufreq: use cpufreq_driver->flags to mark CPUFREQ_HAVE_GOVERNOR_PER_POLICY
Date: Fri, 13 Sep 2013 18:29:13 +0530
Message-Id: <c59eed157c2a80a1b3b5325238c874c7d06c5384.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets use cpufreq_driver->flags to mark CPUFREQ_HAVE_GOVERNOR_PER_POLICY instead
of a separate field within cpufreq_driver. This will save some bytes for us.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/arm_big_little.c   |  4 ++--
 drivers/cpufreq/cpufreq.c          |  2 +-
 drivers/cpufreq/cpufreq_governor.h |  5 ++++-
 include/linux/cpufreq.h            | 15 ++++++++-------
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index 3549f07..768aa9c 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -214,13 +214,13 @@ static struct freq_attr *bL_cpufreq_attr[] = {
 
 static struct cpufreq_driver bL_cpufreq_driver = {
 	.name			= "arm-big-little",
-	.flags			= CPUFREQ_STICKY,
+	.flags			= CPUFREQ_STICKY |
+					CPUFREQ_HAVE_GOVERNOR_PER_POLICY,
 	.verify			= bL_cpufreq_verify_policy,
 	.target			= bL_cpufreq_set_target,
 	.get			= bL_cpufreq_get,
 	.init			= bL_cpufreq_init,
 	.exit			= bL_cpufreq_exit,
-	.have_governor_per_policy = true,
 	.attr			= bL_cpufreq_attr,
 };
 
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index d5fb343..c7274e6 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -135,7 +135,7 @@ static DEFINE_MUTEX(cpufreq_governor_mutex);
 
 bool have_governor_per_policy(void)
 {
-	return cpufreq_driver->have_governor_per_policy;
+	return !!(cpufreq_driver->flags & CPUFREQ_HAVE_GOVERNOR_PER_POLICY);
 }
 EXPORT_SYMBOL_GPL(have_governor_per_policy);
 
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index 88cd39f..b5f2b86 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -191,7 +191,10 @@ struct common_dbs_data {
 	struct attribute_group *attr_group_gov_sys; /* one governor - system */
 	struct attribute_group *attr_group_gov_pol; /* one governor - policy */
 
-	/* Common data for platforms that don't set have_governor_per_policy */
+	/*
+	 * Common data for platforms that don't set
+	 * CPUFREQ_HAVE_GOVERNOR_PER_POLICY
+	 */
 	struct dbs_data *gdbs_data;
 
 	struct cpu_dbs_common_info *(*get_cpu_cdbs)(int cpu);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 0eda235..fef5f3c 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -181,13 +181,6 @@ __ATTR(_name, 0644, show_##_name, store_##_name)
 struct cpufreq_driver {
 	char			name[CPUFREQ_NAME_LEN];
 	u8			flags;
-	/*
-	 * This should be set by platforms having multiple clock-domains, i.e.
-	 * supporting multiple policies. With this sysfs directories of governor
-	 * would be created in cpu/cpu<num>/cpufreq/ directory and so they can
-	 * use the same governor with different tunables for different clusters.
-	 */
-	bool			have_governor_per_policy;
 
 	/* needed by all drivers */
 	int	(*init)		(struct cpufreq_policy *policy);
@@ -227,6 +220,14 @@ struct cpufreq_driver {
  */
 #define CPUFREQ_ASYNC_NOTIFICATION	(1 << 3)
 
+/*
+ * This should be set by platforms having multiple clock-domains, i.e.
+ * supporting multiple policies. With this sysfs directories of governor would
+ * be created in cpu/cpu<num>/cpufreq/ directory and so they can use the same
+ * governor with different tunables for different clusters.
+ */
+#define CPUFREQ_HAVE_GOVERNOR_PER_POLICY (1 << 4)
+
 int cpufreq_register_driver(struct cpufreq_driver *driver_data);
 int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
 
-- 
1.7.12.rc2.18.g61b472e


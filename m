Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab3EPFKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 01:10:38 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:45362 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab3EPFKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 01:10:33 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/3] cpufreq: governors: Move get_governor_parent_kobj() to cpufreq.c
Date: Thu, 16 May 2013 10:39:57 +0530
Message-Id: <62124facb77c79553e2ff7c5b69029094029a31c.1368679353.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1368679353.git.viresh.kumar@linaro.org>
References: <cover.1368679353.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1368679353.git.viresh.kumar@linaro.org>
References: <cover.1368679353.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_governor_parent_kobj() can be used by any governor, generic cpufreq
governors or platform specific ones and so must be present in cpufreq.c instead
of cpufreq_governor.c.

This patch moves it to cpufreq.c. This also adds
EXPORT_SYMBOL_GPL(get_governor_parent_kobj) so that modules can use this
function too.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c          | 9 +++++++++
 drivers/cpufreq/cpufreq_governor.c | 8 --------
 include/linux/cpufreq.h            | 1 +
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 21a7fb0..cb0f723 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -134,6 +134,15 @@ bool have_governor_per_policy(void)
 }
 EXPORT_SYMBOL_GPL(have_governor_per_policy);
 
+struct kobject *get_governor_parent_kobj(struct cpufreq_policy *policy)
+{
+	if (have_governor_per_policy())
+		return &policy->kobj;
+	else
+		return cpufreq_global_kobject;
+}
+EXPORT_SYMBOL_GPL(get_governor_parent_kobj);
+
 static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
 {
 	struct cpufreq_policy *data;
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 5af40ad..d1421b4 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -29,14 +29,6 @@
 
 #include "cpufreq_governor.h"
 
-static struct kobject *get_governor_parent_kobj(struct cpufreq_policy *policy)
-{
-	if (have_governor_per_policy())
-		return &policy->kobj;
-	else
-		return cpufreq_global_kobject;
-}
-
 static struct attribute_group *get_sysfs_attr(struct dbs_data *dbs_data)
 {
 	if (have_governor_per_policy())
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index aa0c2a3..7ffb4d5 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -340,6 +340,7 @@ const char *cpufreq_get_current_driver(void);
 int cpufreq_get_policy(struct cpufreq_policy *policy, unsigned int cpu);
 int cpufreq_update_policy(unsigned int cpu);
 bool have_governor_per_policy(void);
+struct kobject *get_governor_parent_kobj(struct cpufreq_policy *policy);
 
 #ifdef CONFIG_CPU_FREQ
 /* query the current CPU frequency (in kHz). If zero, cpufreq couldn't detect it */
-- 
1.7.12.rc2.18.g61b472e


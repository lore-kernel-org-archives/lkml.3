Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab3EQL1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:27:04 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:53207 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab3EQL1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:27:02 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/2] cpufreq: Don't create empty /sys/devices/system/cpu/cpufreq directory
Date: Fri, 17 May 2013 16:56:33 +0530
Message-Id: <1b08f7e4657818e4a00ea7ebb137998223834dd5.1368789952.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <8bf03cb4a42864802800188fde78adf9b498455f.1368789952.git.viresh.kumar@linaro.org>
References: <8bf03cb4a42864802800188fde78adf9b498455f.1368789952.git.viresh.kumar@linaro.org>
In-Reply-To: <8bf03cb4a42864802800188fde78adf9b498455f.1368789952.git.viresh.kumar@linaro.org>
References: <8bf03cb4a42864802800188fde78adf9b498455f.1368789952.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we don't have any file in cpu/cpufreq directory we shouldn't create it.
Specially with the introduction of per-policy governor instance patchset, even
governors are moved to cpu/cpu*/cpufreq/governor-name directory and so this
directory is just not required.

Lets have it only when required.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/acpi-cpufreq.c     |  4 ++--
 drivers/cpufreq/cpufreq.c          | 48 ++++++++++++++++++++++++++++++++++----
 drivers/cpufreq/cpufreq_governor.c |  6 +++++
 include/linux/cpufreq.h            |  4 ++++
 4 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index ce28c34..ae0918d 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -947,7 +947,7 @@ static void __init acpi_cpufreq_boost_init(void)
 	/* We create the boost file in any case, though for systems without
 	 * hardware support it will be read-only and hardwired to return 0.
 	 */
-	if (sysfs_create_file(cpufreq_global_kobject, &(global_boost.attr)))
+	if (cpufreq_sysfs_create_file(&(global_boost.attr)))
 		pr_warn(PFX "could not register global boost sysfs file\n");
 	else
 		pr_debug("registered global boost sysfs file\n");
@@ -955,7 +955,7 @@ static void __init acpi_cpufreq_boost_init(void)
 
 static void __exit acpi_cpufreq_boost_exit(void)
 {
-	sysfs_remove_file(cpufreq_global_kobject, &(global_boost.attr));
+	cpufreq_sysfs_remove_file(&(global_boost.attr));
 
 	if (msrs) {
 		unregister_cpu_notifier(&boost_nb);
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index e3d7112..2e18b3d 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -678,9 +678,6 @@ static struct attribute *default_attrs[] = {
 	NULL
 };
 
-struct kobject *cpufreq_global_kobject;
-EXPORT_SYMBOL(cpufreq_global_kobject);
-
 #define to_policy(k) container_of(k, struct cpufreq_policy, kobj)
 #define to_attr(a) container_of(a, struct freq_attr, attr)
 
@@ -751,6 +748,49 @@ static struct kobj_type ktype_cpufreq = {
 	.release	= cpufreq_sysfs_release,
 };
 
+struct kobject *cpufreq_global_kobject;
+EXPORT_SYMBOL(cpufreq_global_kobject);
+
+static int cpufreq_global_kobject_usage;
+
+int get_cpufreq_global_kobject(void)
+{
+	if (!cpufreq_global_kobject_usage++)
+		return kobject_add(cpufreq_global_kobject,
+				&cpu_subsys.dev_root->kobj, "%s", "cpufreq");
+
+	return 0;
+}
+EXPORT_SYMBOL(get_cpufreq_global_kobject);
+
+void put_cpufreq_global_kobject(void)
+{
+	if (!--cpufreq_global_kobject_usage)
+		kobject_del(cpufreq_global_kobject);
+}
+EXPORT_SYMBOL(put_cpufreq_global_kobject);
+
+int cpufreq_sysfs_create_file(const struct attribute *attr)
+{
+	int ret = get_cpufreq_global_kobject();
+
+	if (!ret) {
+		ret = sysfs_create_file(cpufreq_global_kobject, attr);
+		if (ret)
+			put_cpufreq_global_kobject();
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(cpufreq_sysfs_create_file);
+
+void cpufreq_sysfs_remove_file(const struct attribute *attr)
+{
+	sysfs_remove_file(cpufreq_global_kobject, attr);
+	put_cpufreq_global_kobject();
+}
+EXPORT_SYMBOL(cpufreq_sysfs_remove_file);
+
 /* symlink affected CPUs */
 static int cpufreq_add_dev_symlink(unsigned int cpu,
 				   struct cpufreq_policy *policy)
@@ -2022,7 +2062,7 @@ static int __init cpufreq_core_init(void)
 		init_rwsem(&per_cpu(cpu_policy_rwsem, cpu));
 	}
 
-	cpufreq_global_kobject = kobject_create_and_add("cpufreq", &cpu_subsys.dev_root->kobj);
+	cpufreq_global_kobject = kobject_create();
 	BUG_ON(!cpufreq_global_kobject);
 	register_syscore_ops(&cpufreq_syscore_ops);
 
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index b6cfd55..09a86f3 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -231,6 +231,9 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 			return rc;
 		}
 
+		if (!have_governor_per_policy())
+			WARN_ON(get_cpufreq_global_kobject());
+
 		rc = sysfs_create_group(get_governor_parent_kobj(policy),
 				get_sysfs_attr(dbs_data));
 		if (rc) {
@@ -269,6 +272,9 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 			sysfs_remove_group(get_governor_parent_kobj(policy),
 					get_sysfs_attr(dbs_data));
 
+			if (!have_governor_per_policy())
+				put_cpufreq_global_kobject();
+
 			if ((dbs_data->cdata->governor == GOV_CONSERVATIVE) &&
 				(policy->governor->initialized == 1)) {
 				struct cs_ops *cs_ops = dbs_data->cdata->gov_ops;
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index cbdf5a4..77a73c9 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -71,6 +71,10 @@ struct cpufreq_governor;
 
 /* /sys/devices/system/cpu/cpufreq: entry point for global variables */
 extern struct kobject *cpufreq_global_kobject;
+int get_cpufreq_global_kobject(void);
+void put_cpufreq_global_kobject(void);
+int cpufreq_sysfs_create_file(const struct attribute *attr);
+void cpufreq_sysfs_remove_file(const struct attribute *attr);
 
 #define CPUFREQ_ETERNAL			(-1)
 struct cpufreq_cpuinfo {
-- 
1.7.12.rc2.18.g61b472e


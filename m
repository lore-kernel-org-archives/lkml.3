Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab3G2W6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 18:58:43 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47217 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab3G2W6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 18:58:40 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 5/7] cpufreq: Introduce a flag ('frozen') to separate full
 vs temporary init/teardown
To: rjw@sisk.pl, viresh.kumar@linaro.org, toralf.foerster@gmx.de,
        robert.jarzmik@intel.com, durgadoss.r@intel.com, tianyu.lan@intel.com,
        lantianyu1986@gmail.com, dirk.brandewie@gmail.com
Cc: stern@rowland.harvard.edu, srivatsa.bhat@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 30 Jul 2013 04:24:49 +0530
Message-ID: <20130729225442.20863.91421.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130729225213.20863.56722.stgit@srivatsabhat.in.ibm.com>
References: <20130729225213.20863.56722.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072922-6102-0000-0000-000003F00FE8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During suspend/resume we would like to do a light-weight init/teardown of
CPUs in the cpufreq subsystem and preserve certain things such as sysfs files
etc across suspend/resume transitions. Add a flag called 'frozen' to help
distinguish the full init/teardown sequence from the light-weight one.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---

 drivers/cpufreq/cpufreq.c |   76 +++++++++++++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 27 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 32b3ce7..92b833f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -903,7 +903,7 @@ static void cpufreq_init_policy(struct cpufreq_policy *policy)
 
 #ifdef CONFIG_HOTPLUG_CPU
 static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
-				  struct device *dev)
+				  struct device *dev, bool frozen)
 {
 	struct cpufreq_policy *policy;
 	int ret = 0, has_target = !!cpufreq_driver->target;
@@ -931,13 +931,18 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
 		__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
 	}
 
-	ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
-	if (ret) {
+	/* Don't touch sysfs links during light-weight init */
+	if (frozen) {
+		/* Drop the extra refcount that we took above */
 		cpufreq_cpu_put(policy);
-		return ret;
+		return 0;
 	}
 
-	return 0;
+	ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
+	if (ret)
+		cpufreq_cpu_put(policy);
+
+	return ret;
 }
 #endif
 
@@ -972,16 +977,8 @@ static void cpufreq_policy_free(struct cpufreq_policy *policy)
 	kfree(policy);
 }
 
-/**
- * cpufreq_add_dev - add a CPU device
- *
- * Adds the cpufreq interface for a CPU device.
- *
- * The Oracle says: try running cpufreq registration/unregistration concurrently
- * with with cpu hotplugging and all hell will break loose. Tried to clean this
- * mess up, but more thorough testing is needed. - Mathieu
- */
-static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
+static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
+			     bool frozen)
 {
 	unsigned int j, cpu = dev->id;
 	int ret = -ENOMEM;
@@ -1013,7 +1010,8 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 		struct cpufreq_policy *cp = per_cpu(cpufreq_cpu_data, sibling);
 		if (cp && cpumask_test_cpu(cpu, cp->related_cpus)) {
 			read_unlock_irqrestore(&cpufreq_driver_lock, flags);
-			return cpufreq_add_policy_cpu(cpu, sibling, dev);
+			return cpufreq_add_policy_cpu(cpu, sibling, dev,
+						      frozen);
 		}
 	}
 	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
@@ -1079,9 +1077,11 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	}
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-	ret = cpufreq_add_dev_interface(cpu, policy, dev);
-	if (ret)
-		goto err_out_unregister;
+	if (!frozen) {
+		ret = cpufreq_add_dev_interface(cpu, policy, dev);
+		if (ret)
+			goto err_out_unregister;
+	}
 
 	cpufreq_init_policy(policy);
 
@@ -1112,6 +1112,20 @@ module_out:
 	return ret;
 }
 
+/**
+ * cpufreq_add_dev - add a CPU device
+ *
+ * Adds the cpufreq interface for a CPU device.
+ *
+ * The Oracle says: try running cpufreq registration/unregistration concurrently
+ * with with cpu hotplugging and all hell will break loose. Tried to clean this
+ * mess up, but more thorough testing is needed. - Mathieu
+ */
+static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
+{
+	return __cpufreq_add_dev(dev, sif, false);
+}
+
 static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
 {
 	int j;
@@ -1130,7 +1144,7 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
 }
 
 static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *data,
-					   unsigned int old_cpu)
+					   unsigned int old_cpu, bool frozen)
 {
 	struct device *cpu_dev;
 	unsigned long flags;
@@ -1138,6 +1152,11 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *data,
 
 	/* first sibling now owns the new sysfs dir */
 	cpu_dev = get_cpu_device(cpumask_first(data->cpus));
+
+	/* Don't touch sysfs files during light-weight tear-down */
+	if (frozen)
+		return cpu_dev->id;
+
 	sysfs_remove_link(&cpu_dev->kobj, "cpufreq");
 	ret = kobject_move(&data->kobj, &cpu_dev->kobj);
 	if (ret) {
@@ -1169,7 +1188,7 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *data,
  * This routine frees the rwsem before returning.
  */
 static int __cpufreq_remove_dev(struct device *dev,
-		struct subsys_interface *sif)
+				struct subsys_interface *sif, bool frozen)
 {
 	unsigned int cpu = dev->id, cpus;
 	int new_cpu;
@@ -1208,17 +1227,20 @@ static int __cpufreq_remove_dev(struct device *dev,
 		cpumask_clear_cpu(cpu, data->cpus);
 	unlock_policy_rwsem_write(cpu);
 
-	if (cpu != data->cpu) {
+	if (cpu != data->cpu && !frozen) {
 		sysfs_remove_link(&dev->kobj, "cpufreq");
 	} else if (cpus > 1) {
 
-		new_cpu = cpufreq_nominate_new_policy_cpu(data, cpu);
+		new_cpu = cpufreq_nominate_new_policy_cpu(data, cpu, frozen);
 		if (new_cpu >= 0) {
 			WARN_ON(lock_policy_rwsem_write(cpu));
 			update_policy_cpu(data, new_cpu);
 			unlock_policy_rwsem_write(cpu);
-			pr_debug("%s: policy Kobject moved to cpu: %d "
-				 "from: %d\n",__func__, new_cpu, cpu);
+
+			if (!frozen) {
+				pr_debug("%s: policy Kobject moved to cpu: %d "
+					 "from: %d\n",__func__, new_cpu, cpu);
+			}
 		}
 	}
 
@@ -1266,7 +1288,7 @@ static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 	if (cpu_is_offline(cpu))
 		return 0;
 
-	retval = __cpufreq_remove_dev(dev, sif);
+	retval = __cpufreq_remove_dev(dev, sif, false);
 	return retval;
 }
 
@@ -1980,7 +2002,7 @@ static int cpufreq_cpu_callback(struct notifier_block *nfb,
 			break;
 		case CPU_DOWN_PREPARE:
 		case CPU_DOWN_PREPARE_FROZEN:
-			__cpufreq_remove_dev(dev, NULL);
+			__cpufreq_remove_dev(dev, NULL, false);
 			break;
 		case CPU_DOWN_FAILED:
 		case CPU_DOWN_FAILED_FROZEN:


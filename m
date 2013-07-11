Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab3GKWUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:20:31 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:32883 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab3GKWU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:20:28 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 6/8] cpufreq: Introduce a flag ('frozen') to separate full vs
 temporary init/teardown
To: rjw@sisk.pl, viresh.kumar@linaro.org, toralf.foerster@gmx.de,
        robert.jarzmik@intel.com, durgadoss.r@intel.com, tianyu.lan@intel.com,
        lantianyu1986@gmail.com, dirk.brandewie@gmail.com
Cc: stern@rowland.harvard.edu,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Jul 2013 03:46:59 +0530
Message-ID: <20130711221657.547.2293.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071122-8878-0000-0000-000007EA444A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During suspend/resume we would like to do a light-weight init/teardown of
CPUs in the cpufreq subsystem and preserve certain things such as sysfs files
etc across suspend/resume transitions. Add a flag called 'frozen' to help
distinguish the full init/teardown sequence from the light-weight one.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpufreq/cpufreq.c |   66 ++++++++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 25 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index efdb607..1128753 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -902,7 +902,7 @@ static void cpufreq_init_policy(struct cpufreq_policy *policy)
 
 #ifdef CONFIG_HOTPLUG_CPU
 static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
-				  struct device *dev)
+				  struct device *dev, bool frozen)
 {
 	struct cpufreq_policy *policy;
 	int ret = 0, has_target = !!cpufreq_driver->target;
@@ -930,13 +930,15 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
 		__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
 	}
 
+	/* Don't touch sysfs links during light-weight init */
+	if (frozen)
+		return 0;
+
 	ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
-	if (ret) {
+	if (ret)
 		cpufreq_cpu_put(policy);
-		return ret;
-	}
 
-	return 0;
+	return ret;
 }
 #endif
 
@@ -971,16 +973,8 @@ static void cpufreq_policy_free(struct cpufreq_policy *policy)
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
@@ -1012,7 +1006,8 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 		struct cpufreq_policy *cp = per_cpu(cpufreq_cpu_data, sibling);
 		if (cp && cpumask_test_cpu(cpu, cp->related_cpus)) {
 			read_unlock_irqrestore(&cpufreq_driver_lock, flags);
-			return cpufreq_add_policy_cpu(cpu, sibling, dev);
+			return cpufreq_add_policy_cpu(cpu, sibling, dev,
+						      frozen);
 		}
 	}
 	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
@@ -1078,9 +1073,11 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
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
 
@@ -1111,6 +1108,20 @@ module_out:
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
@@ -1129,7 +1140,7 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
 }
 
 static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *data,
-					   unsigned int old_cpu)
+					   unsigned int old_cpu, bool frozen)
 {
 	struct device *cpu_dev;
 	unsigned long flags;
@@ -1137,6 +1148,11 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *data,
 
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
@@ -1168,7 +1184,7 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *data,
  * This routine frees the rwsem before returning.
  */
 static int __cpufreq_remove_dev(struct device *dev,
-		struct subsys_interface *sif)
+				struct subsys_interface *sif, bool frozen)
 {
 	unsigned int cpu = dev->id, cpus, new_cpu;
 	unsigned long flags;
@@ -1206,11 +1222,11 @@ static int __cpufreq_remove_dev(struct device *dev,
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
@@ -1264,7 +1280,7 @@ static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 	if (cpu_is_offline(cpu))
 		return 0;
 
-	retval = __cpufreq_remove_dev(dev, sif);
+	retval = __cpufreq_remove_dev(dev, sif, false);
 	return retval;
 }
 
@@ -1990,7 +2006,7 @@ static int __cpuinit cpufreq_cpu_callback(struct notifier_block *nfb,
 			break;
 		case CPU_DOWN_PREPARE:
 		case CPU_DOWN_PREPARE_FROZEN:
-			__cpufreq_remove_dev(dev, NULL);
+			__cpufreq_remove_dev(dev, NULL, false);
 			break;
 		case CPU_DOWN_FAILED:
 		case CPU_DOWN_FAILED_FROZEN:


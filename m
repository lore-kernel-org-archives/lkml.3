Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab3G2W6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 18:58:19 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:43020 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab3G2W6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 18:58:15 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 4/7] cpufreq: Extract the handover of policy cpu to a
 helper function
To: rjw@sisk.pl, viresh.kumar@linaro.org, toralf.foerster@gmx.de,
        robert.jarzmik@intel.com, durgadoss.r@intel.com, tianyu.lan@intel.com,
        lantianyu1986@gmail.com, dirk.brandewie@gmail.com
Cc: stern@rowland.harvard.edu, srivatsa.bhat@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 30 Jul 2013 04:24:36 +0530
Message-ID: <20130729225432.20863.54824.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130729225213.20863.56722.stgit@srivatsabhat.in.ibm.com>
References: <20130729225213.20863.56722.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072922-3864-0000-0000-000009508BAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During cpu offline, when the policy->cpu is going down, some other CPU
present in the policy->cpus mask is nominated as the new policy->cpu.
Extract this functionality from __cpufreq_remove_dev() and implement
it in a helper function. This helps in upcoming code reorganization.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---

 drivers/cpufreq/cpufreq.c |   63 ++++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 24 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 39bda8f..32b3ce7 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1129,6 +1129,38 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
 			CPUFREQ_UPDATE_POLICY_CPU, policy);
 }
 
+static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *data,
+					   unsigned int old_cpu)
+{
+	struct device *cpu_dev;
+	unsigned long flags;
+	int ret;
+
+	/* first sibling now owns the new sysfs dir */
+	cpu_dev = get_cpu_device(cpumask_first(data->cpus));
+	sysfs_remove_link(&cpu_dev->kobj, "cpufreq");
+	ret = kobject_move(&data->kobj, &cpu_dev->kobj);
+	if (ret) {
+		pr_err("%s: Failed to move kobj: %d", __func__, ret);
+
+		WARN_ON(lock_policy_rwsem_write(old_cpu));
+		cpumask_set_cpu(old_cpu, data->cpus);
+
+		write_lock_irqsave(&cpufreq_driver_lock, flags);
+		per_cpu(cpufreq_cpu_data, old_cpu) = data;
+		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
+		unlock_policy_rwsem_write(old_cpu);
+
+		ret = sysfs_create_link(&cpu_dev->kobj, &data->kobj,
+					"cpufreq");
+
+		return -EINVAL;
+	}
+
+	return cpu_dev->id;
+}
+
 /**
  * __cpufreq_remove_dev - remove a CPU device
  *
@@ -1139,12 +1171,12 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
 static int __cpufreq_remove_dev(struct device *dev,
 		struct subsys_interface *sif)
 {
-	unsigned int cpu = dev->id, ret, cpus;
+	unsigned int cpu = dev->id, cpus;
+	int new_cpu;
 	unsigned long flags;
 	struct cpufreq_policy *data;
 	struct kobject *kobj;
 	struct completion *cmp;
-	struct device *cpu_dev;
 
 	pr_debug("%s: unregistering CPU %u\n", __func__, cpu);
 
@@ -1179,32 +1211,15 @@ static int __cpufreq_remove_dev(struct device *dev,
 	if (cpu != data->cpu) {
 		sysfs_remove_link(&dev->kobj, "cpufreq");
 	} else if (cpus > 1) {
-		/* first sibling now owns the new sysfs dir */
-		cpu_dev = get_cpu_device(cpumask_first(data->cpus));
-		sysfs_remove_link(&cpu_dev->kobj, "cpufreq");
-		ret = kobject_move(&data->kobj, &cpu_dev->kobj);
-		if (ret) {
-			pr_err("%s: Failed to move kobj: %d", __func__, ret);
 
+		new_cpu = cpufreq_nominate_new_policy_cpu(data, cpu);
+		if (new_cpu >= 0) {
 			WARN_ON(lock_policy_rwsem_write(cpu));
-			cpumask_set_cpu(cpu, data->cpus);
-
-			write_lock_irqsave(&cpufreq_driver_lock, flags);
-			per_cpu(cpufreq_cpu_data, cpu) = data;
-			write_unlock_irqrestore(&cpufreq_driver_lock, flags);
-
+			update_policy_cpu(data, new_cpu);
 			unlock_policy_rwsem_write(cpu);
-
-			ret = sysfs_create_link(&cpu_dev->kobj, &data->kobj,
-					"cpufreq");
-			return -EINVAL;
+			pr_debug("%s: policy Kobject moved to cpu: %d "
+				 "from: %d\n",__func__, new_cpu, cpu);
 		}
-
-		WARN_ON(lock_policy_rwsem_write(cpu));
-		update_policy_cpu(data, cpu_dev->id);
-		unlock_policy_rwsem_write(cpu);
-		pr_debug("%s: policy Kobject moved to cpu: %d from: %d\n",
-				__func__, cpu_dev->id, cpu);
 	}
 
 	/* If cpu is last user of policy, free policy */


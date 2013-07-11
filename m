Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab3GKWUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:20:21 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:39991 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab3GKWUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:20:19 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 5/8] cpufreq: Extract the handover of policy cpu to a helper
 function
To: rjw@sisk.pl, viresh.kumar@linaro.org, toralf.foerster@gmx.de,
        robert.jarzmik@intel.com, durgadoss.r@intel.com, tianyu.lan@intel.com,
        lantianyu1986@gmail.com, dirk.brandewie@gmail.com
Cc: stern@rowland.harvard.edu,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Jul 2013 03:46:47 +0530
Message-ID: <20130711221644.547.74786.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071122-1618-0000-0000-0000043FF88C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During cpu offline, when the policy->cpu is going down, some other CPU
present in the policy->cpus mask is nominated as the new policy->cpu.
Extract this functionality from __cpufreq_remove_dev() and implement
it in a helper function. This helps in upcoming code reorganization.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpufreq/cpufreq.c |   62 ++++++++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 24 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2ab39f3..efdb607 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1128,6 +1128,38 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
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
@@ -1138,12 +1170,11 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
 static int __cpufreq_remove_dev(struct device *dev,
 		struct subsys_interface *sif)
 {
-	unsigned int cpu = dev->id, ret, cpus;
+	unsigned int cpu = dev->id, cpus, new_cpu;
 	unsigned long flags;
 	struct cpufreq_policy *data;
 	struct kobject *kobj;
 	struct completion *cmp;
-	struct device *cpu_dev;
 
 	pr_debug("%s: unregistering CPU %u\n", __func__, cpu);
 
@@ -1178,32 +1209,15 @@ static int __cpufreq_remove_dev(struct device *dev,
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
 
 	if ((cpus == 1) && (cpufreq_driver->target))


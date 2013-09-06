Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab3IFT5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 15:57:12 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46473 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab3IFT5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 15:57:10 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 1/5] cpufreq: Split __cpufreq_remove_dev() into 2 parts (kobj
 cleanup & the rest)
To: rjw@sisk.pl, sboyd@codeaurora.org, viresh.kumar@linaro.org
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 07 Sep 2013 01:23:09 +0530
Message-ID: <20130906195259.26919.98754.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130906195206.26919.20884.stgit@srivatsabhat.in.ibm.com>
References: <20130906195206.26919.20884.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090619-7182-0000-0000-000008533BD3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During CPU offline, the cpufreq core invokes __cpufreq_remove_dev() to
perform work such as stopping the cpufreq governor, clearing the CPU from
the policy structure etc, and finally cleaning up the kobject.

There are certain subtle issues related to the kobject cleanup, and it would
be much easier to deal with them if we separate that part from the rest of
the cleanup-work in the CPU offline phase. So split the __cpufreq_remove_dev()
function into 2 parts: one that handles the kobject cleanup, and the other
that handles the rest of the work.

Reported-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpufreq/cpufreq.c |   65 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 53 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index ecc55d1..3e5aeb6 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1164,22 +1164,14 @@ static int cpufreq_nominate_new_policy_cpu(struct cpufreq_policy *policy,
 	return cpu_dev->id;
 }
 
-/**
- * __cpufreq_remove_dev - remove a CPU device
- *
- * Removes the cpufreq interface for a CPU device.
- * Caller should already have policy_rwsem in write mode for this CPU.
- * This routine frees the rwsem before returning.
- */
-static int __cpufreq_remove_dev(struct device *dev,
-				struct subsys_interface *sif, bool frozen)
+static int __cpufreq_remove_dev_prepare(struct device *dev,
+					struct subsys_interface *sif,
+					bool frozen)
 {
 	unsigned int cpu = dev->id, cpus;
 	int new_cpu, ret;
 	unsigned long flags;
 	struct cpufreq_policy *policy;
-	struct kobject *kobj;
-	struct completion *cmp;
 
 	pr_debug("%s: unregistering CPU %u\n", __func__, cpu);
 
@@ -1236,6 +1228,33 @@ static int __cpufreq_remove_dev(struct device *dev,
 		}
 	}
 
+	return 0;
+}
+
+static int __cpufreq_remove_dev_finish(struct device *dev,
+				       struct subsys_interface *sif,
+				       bool frozen)
+{
+	unsigned int cpu = dev->id, cpus;
+	int ret;
+	unsigned long flags;
+	struct cpufreq_policy *policy;
+	struct kobject *kobj;
+	struct completion *cmp;
+
+	read_lock_irqsave(&cpufreq_driver_lock, flags);
+	policy = per_cpu(cpufreq_cpu_data, cpu);
+	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
+	if (!policy) {
+		pr_debug("%s: No cpu_data found\n", __func__);
+		return -EINVAL;
+	}
+
+	lock_policy_rwsem_read(cpu);
+	cpus = cpumask_weight(policy->cpus);
+	unlock_policy_rwsem_read(cpu);
+
 	/* If cpu is last user of policy, free policy */
 	if (cpus == 1) {
 		if (cpufreq_driver->target) {
@@ -1295,6 +1314,27 @@ static int __cpufreq_remove_dev(struct device *dev,
 	return 0;
 }
 
+/**
+ * __cpufreq_remove_dev - remove a CPU device
+ *
+ * Removes the cpufreq interface for a CPU device.
+ * Caller should already have policy_rwsem in write mode for this CPU.
+ * This routine frees the rwsem before returning.
+ */
+static inline int __cpufreq_remove_dev(struct device *dev,
+				       struct subsys_interface *sif,
+				       bool frozen)
+{
+	int ret;
+
+	ret = __cpufreq_remove_dev_prepare(dev, sif, frozen);
+
+	if (!ret)
+		ret = __cpufreq_remove_dev_finish(dev, sif, frozen);
+
+	return ret;
+}
+
 static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 {
 	unsigned int cpu = dev->id;
@@ -2044,7 +2084,8 @@ static int cpufreq_cpu_callback(struct notifier_block *nfb,
 			break;
 
 		case CPU_DOWN_PREPARE:
-			__cpufreq_remove_dev(dev, NULL, frozen);
+			__cpufreq_remove_dev_prepare(dev, NULL, frozen);
+			__cpufreq_remove_dev_finish(dev, NULL, frozen);
 			break;
 
 		case CPU_DOWN_FAILED:


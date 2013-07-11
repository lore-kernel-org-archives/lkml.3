Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab3GKWUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:20:50 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:56091 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab3GKWUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:20:39 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 7/8] cpufreq: Preserve policy structure across suspend/resume
To: rjw@sisk.pl, viresh.kumar@linaro.org, toralf.foerster@gmx.de,
        robert.jarzmik@intel.com, durgadoss.r@intel.com, tianyu.lan@intel.com,
        lantianyu1986@gmail.com, dirk.brandewie@gmail.com
Cc: stern@rowland.harvard.edu,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Jul 2013 03:47:08 +0530
Message-ID: <20130711221704.547.64296.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071122-5140-0000-0000-00000381CAB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To perform light-weight cpu-init and teardown in the cpufreq subsystem
during suspend/resume, we need to separate out the 2 main functionalities
of the cpufreq CPU hotplug callbacks, as outlined below:

1. Init/tear-down of core cpufreq and CPU-specific components, which are
   critical to the correct functioning of the cpufreq subsystem.

2. Init/tear-down of cpufreq sysfs files during suspend/resume.

The first part requires accurate updates to the policy structure such as
its ->cpus and ->related_cpus masks, whereas the second part requires that
the policy->kobj structure is not released or re-initialized during
suspend/resume.

To handle both these requirements, we need to allow updates to the policy
structure throughout suspend/resume, but prevent the structure from getting
freed up. Also, we must have a mechanism by which the cpu-up callbacks can
restore the policy structure, without allocating things afresh. (That also
helps avoid memory leaks).

To achieve this, we use 2 schemes:
a. Use a fallback per-cpu storage area for preserving the policy structures
   during suspend, so that they can be restored during resume appropriately.

b. Use the 'frozen' flag to determine when to free or allocate the policy
   structure vs when to restore the policy from the saved fallback storage.
   Thus we can successfully preserve the structure across suspend/resume.

Effectively, this helps us complete the separation of the 'light-weight'
and the 'full' init/tear-down sequences in the cpufreq subsystem, so that
this can be made use of in the suspend/resume scenario.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpufreq/cpufreq.c |   69 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 52 insertions(+), 17 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 1128753..15ced5f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -44,6 +44,7 @@
  */
 static struct cpufreq_driver *cpufreq_driver;
 static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
+static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data_fallback);
 static DEFINE_RWLOCK(cpufreq_driver_lock);
 static DEFINE_MUTEX(cpufreq_governor_lock);
 
@@ -942,6 +943,20 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
 }
 #endif
 
+static struct cpufreq_policy *cpufreq_policy_restore(unsigned int cpu)
+{
+	struct cpufreq_policy *policy;
+	unsigned long flags;
+
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
+
+	policy = per_cpu(cpufreq_cpu_data_fallback, cpu);
+
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
+	return policy;
+}
+
 static struct cpufreq_policy *cpufreq_policy_alloc(void)
 {
 	struct cpufreq_policy *policy;
@@ -1019,7 +1034,12 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 		goto module_out;
 	}
 
-	policy = cpufreq_policy_alloc();
+	if (frozen)
+		/* Restore the saved policy when doing light-weight init */
+		policy = cpufreq_policy_restore(cpu);
+	else
+		policy = cpufreq_policy_alloc();
+
 	if (!policy)
 		goto nomem_out;
 
@@ -1199,6 +1219,10 @@ static int __cpufreq_remove_dev(struct device *dev,
 	data = per_cpu(cpufreq_cpu_data, cpu);
 	per_cpu(cpufreq_cpu_data, cpu) = NULL;
 
+	/* Save the policy somewhere when doing a light-weight tear-down */
+	if (frozen)
+		per_cpu(cpufreq_cpu_data_fallback, cpu) = data;
+
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	if (!data) {
@@ -1239,29 +1263,40 @@ static int __cpufreq_remove_dev(struct device *dev,
 	if ((cpus == 1) && (cpufreq_driver->target))
 		__cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
 
-	pr_debug("%s: removing link, cpu: %d\n", __func__, cpu);
-	cpufreq_cpu_put(data);
+	if (!frozen) {
+		pr_debug("%s: removing link, cpu: %d\n", __func__, cpu);
+		cpufreq_cpu_put(data);
+	}
 
 	/* If cpu is last user of policy, free policy */
 	if (cpus == 1) {
-		lock_policy_rwsem_read(cpu);
-		kobj = &data->kobj;
-		cmp = &data->kobj_unregister;
-		unlock_policy_rwsem_read(cpu);
-		kobject_put(kobj);
-
-		/* we need to make sure that the underlying kobj is actually
-		 * not referenced anymore by anybody before we proceed with
-		 * unloading.
-		 */
-		pr_debug("waiting for dropping of refcount\n");
-		wait_for_completion(cmp);
-		pr_debug("wait complete\n");
+		if (!frozen) {
+			lock_policy_rwsem_read(cpu);
+			kobj = &data->kobj;
+			cmp = &data->kobj_unregister;
+			unlock_policy_rwsem_read(cpu);
+			kobject_put(kobj);
+
+			/*
+			 * We need to make sure that the underlying kobj is
+			 * actually not referenced anymore by anybody before we
+			 * proceed with unloading.
+			 */
+			pr_debug("waiting for dropping of refcount\n");
+			wait_for_completion(cmp);
+			pr_debug("wait complete\n");
+		}
 
+		/*
+		 * Perform the ->exit() even during light-weight tear-down,
+		 * since this is a core component, and is essential for the
+		 * the subsequent light-weight ->init() to succeed.
+		 */
 		if (cpufreq_driver->exit)
 			cpufreq_driver->exit(data);
 
-		cpufreq_policy_free(data);
+		if (!frozen)
+			cpufreq_policy_free(data);
 
 	} else if (cpufreq_driver->target) {
 		__cpufreq_governor(data, CPUFREQ_GOV_START);


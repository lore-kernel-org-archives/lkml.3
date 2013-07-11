Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab3GKWYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:24:16 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:49033 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757079Ab3GKWUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:20:06 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 4/8] cpufreq: Extract non-interface related stuff from
 cpufreq_add_dev_interface
To: rjw@sisk.pl, viresh.kumar@linaro.org, toralf.foerster@gmx.de,
        robert.jarzmik@intel.com, durgadoss.r@intel.com, tianyu.lan@intel.com,
        lantianyu1986@gmail.com, dirk.brandewie@gmail.com
Cc: stern@rowland.harvard.edu,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Jul 2013 03:46:29 +0530
Message-ID: <20130711221623.547.5846.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071122-6102-0000-0000-000003D7B34C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq_add_dev_interface() includes the work of exposing the interface
to the device, as well as a lot of unrelated stuff. Move the latter to
cpufreq_add_dev(), where it is more appropriate.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpufreq/cpufreq.c |   43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index ca14dc2..2ab39f3 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -834,11 +834,8 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 				     struct cpufreq_policy *policy,
 				     struct device *dev)
 {
-	struct cpufreq_policy new_policy;
 	struct freq_attr **drv_attr;
-	unsigned long flags;
 	int ret = 0;
-	unsigned int j;
 
 	/* prepare interface data */
 	ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
@@ -870,17 +867,23 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 			goto err_out_kobj_put;
 	}
 
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu(j, policy->cpus) {
-		per_cpu(cpufreq_cpu_data, j) = policy;
-		per_cpu(cpufreq_policy_cpu, j) = policy->cpu;
-	}
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
-
 	ret = cpufreq_add_dev_symlink(cpu, policy);
 	if (ret)
 		goto err_out_kobj_put;
 
+	return ret;
+
+err_out_kobj_put:
+	kobject_put(&policy->kobj);
+	wait_for_completion(&policy->kobj_unregister);
+	return ret;
+}
+
+static void cpufreq_init_policy(struct cpufreq_policy *policy)
+{
+	struct cpufreq_policy new_policy;
+	int ret = 0;
+
 	memcpy(&new_policy, policy, sizeof(struct cpufreq_policy));
 	/* assure that the starting sequence is run in __cpufreq_set_policy */
 	policy->governor = NULL;
@@ -895,12 +898,6 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 		if (cpufreq_driver->exit)
 			cpufreq_driver->exit(policy);
 	}
-	return ret;
-
-err_out_kobj_put:
-	kobject_put(&policy->kobj);
-	wait_for_completion(&policy->kobj_unregister);
-	return ret;
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -1074,10 +1071,19 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	}
 #endif
 
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	for_each_cpu(j, policy->cpus) {
+		per_cpu(cpufreq_cpu_data, j) = policy;
+		per_cpu(cpufreq_policy_cpu, j) = policy->cpu;
+	}
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
 	ret = cpufreq_add_dev_interface(cpu, policy, dev);
 	if (ret)
 		goto err_out_unregister;
 
+	cpufreq_init_policy(policy);
+
 	kobject_uevent(&policy->kobj, KOBJ_ADD);
 	module_put(cpufreq_driver->owner);
 	pr_debug("initialization complete\n");
@@ -1086,8 +1092,11 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 
 err_out_unregister:
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu(j, policy->cpus)
+	for_each_cpu(j, policy->cpus) {
 		per_cpu(cpufreq_cpu_data, j) = NULL;
+		if (j != cpu)
+			per_cpu(cpufreq_policy_cpu, j) = -1;
+	}
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	kobject_put(&policy->kobj);


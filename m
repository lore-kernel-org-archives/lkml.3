Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab3G2W6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 18:58:11 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:56371 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab3G2W6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 18:58:08 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 3/7] cpufreq: Extract non-interface related stuff from
 cpufreq_add_dev_interface
To: rjw@sisk.pl, viresh.kumar@linaro.org, toralf.foerster@gmx.de,
        robert.jarzmik@intel.com, durgadoss.r@intel.com, tianyu.lan@intel.com,
        lantianyu1986@gmail.com, dirk.brandewie@gmail.com
Cc: stern@rowland.harvard.edu, srivatsa.bhat@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 30 Jul 2013 04:24:23 +0530
Message-ID: <20130729225417.20863.4747.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130729225213.20863.56722.stgit@srivatsabhat.in.ibm.com>
References: <20130729225213.20863.56722.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072922-5140-0000-0000-000003988D14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq_add_dev_interface() includes the work of exposing the interface
to the device, as well as a lot of unrelated stuff. Move the latter to
cpufreq_add_dev(), where it is more appropriate.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---

 drivers/cpufreq/cpufreq.c |   43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 0ce9e9d..39bda8f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -835,11 +835,8 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
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
@@ -871,17 +868,23 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
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
@@ -896,12 +899,6 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
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
@@ -1075,10 +1072,19 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
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
@@ -1087,8 +1093,11 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 
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


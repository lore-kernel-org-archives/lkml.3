Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab3GKWTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:19:46 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:39593 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034Ab3GKWTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:19:45 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 3/8] cpufreq: Add helper to perform alloc/free of policy
 structure
To: rjw@sisk.pl, viresh.kumar@linaro.org, toralf.foerster@gmx.de,
        robert.jarzmik@intel.com, durgadoss.r@intel.com, tianyu.lan@intel.com,
        lantianyu1986@gmail.com, dirk.brandewie@gmail.com
Cc: stern@rowland.harvard.edu,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Jul 2013 03:46:07 +0530
Message-ID: <20130711221605.547.69988.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
References: <20130711221419.547.69781.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071122-7014-0000-0000-0000034E7BA3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out the allocation of the cpufreq policy structure (along with
its error handling) to a helper function. This makes the code easier to
read and also helps with some upcoming code reorganization.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpufreq/cpufreq.c |   50 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 15 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index f8c3100..ca14dc2 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -943,6 +943,37 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
 }
 #endif
 
+static struct cpufreq_policy *cpufreq_policy_alloc(void)
+{
+	struct cpufreq_policy *policy;
+
+	policy = kzalloc(sizeof(struct cpufreq_policy), GFP_KERNEL);
+	if (!policy)
+		return NULL;
+
+	if (!alloc_cpumask_var(&policy->cpus, GFP_KERNEL))
+		goto err_free_policy;
+
+	if (!zalloc_cpumask_var(&policy->related_cpus, GFP_KERNEL))
+		goto err_free_cpumask;
+
+	return policy;
+
+err_free_cpumask:
+	free_cpumask_var(policy->cpus);
+err_free_policy:
+	kfree(policy);
+
+	return NULL;
+}
+
+static void cpufreq_policy_free(struct cpufreq_policy *policy)
+{
+	free_cpumask_var(policy->related_cpus);
+	free_cpumask_var(policy->cpus);
+	kfree(policy);
+}
+
 /**
  * cpufreq_add_dev - add a CPU device
  *
@@ -996,16 +1027,10 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 		goto module_out;
 	}
 
-	policy = kzalloc(sizeof(struct cpufreq_policy), GFP_KERNEL);
+	policy = cpufreq_policy_alloc();
 	if (!policy)
 		goto nomem_out;
 
-	if (!alloc_cpumask_var(&policy->cpus, GFP_KERNEL))
-		goto err_free_policy;
-
-	if (!zalloc_cpumask_var(&policy->related_cpus, GFP_KERNEL))
-		goto err_free_cpumask;
-
 	policy->cpu = cpu;
 	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	cpumask_copy(policy->cpus, cpumask_of(cpu));
@@ -1070,11 +1095,7 @@ err_out_unregister:
 
 err_set_policy_cpu:
 	per_cpu(cpufreq_policy_cpu, cpu) = -1;
-	free_cpumask_var(policy->related_cpus);
-err_free_cpumask:
-	free_cpumask_var(policy->cpus);
-err_free_policy:
-	kfree(policy);
+	cpufreq_policy_free(policy);
 nomem_out:
 	module_put(cpufreq_driver->owner);
 module_out:
@@ -1201,9 +1222,8 @@ static int __cpufreq_remove_dev(struct device *dev,
 		if (cpufreq_driver->exit)
 			cpufreq_driver->exit(data);
 
-		free_cpumask_var(data->related_cpus);
-		free_cpumask_var(data->cpus);
-		kfree(data);
+		cpufreq_policy_free(data);
+
 	} else if (cpufreq_driver->target) {
 		__cpufreq_governor(data, CPUFREQ_GOV_START);
 		__cpufreq_governor(data, CPUFREQ_GOV_LIMITS);


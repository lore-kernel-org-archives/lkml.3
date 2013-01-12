Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab3ALFPN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 00:15:13 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:42454 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab3ALFPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 00:15:11 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/5] cpufreq: Don't use cpu removed during cpufreq_driver_unregister
Date: Sat, 12 Jan 2013 10:44:40 +0530
Message-Id: <3960872935b76f177a4169cb6ce135b54d30bc50.1357967566.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1357967566.git.viresh.kumar@linaro.org>
References: <cover.1357967566.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1357967566.git.viresh.kumar@linaro.org>
References: <cover.1357967566.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is how the core works:
cpufreq_driver_unregister()
 - subsys_interface_unregister()
   - for_each_cpu() call cpufreq_remove_dev(), i.e. 0,1,2,3,4 when we
     unregister.

cpufreq_remove_dev():
 - Remove policy node
 - Call cpufreq_add_dev() for next cpu, sharing mask with removed cpu.
   i.e. When cpu 0 is removed, we call it for cpu 1. And when called for cpu 2,
   we call it for cpu 3.
   - cpufreq_add_dev() would call cpufreq_driver->init()
   - init would return mask as AND of 2, 3 and 4 for cluster A7.
   - cpufreq core would do online_cpu && policy->cpus
     Here is the BUG(). Because cpu hasn't died but we have just unregistered
     the cpufreq driver, online cpu would still have cpu 2 in it. And so thing
     go bad again.

Solution: Keep cpumask of cpus that are registered with cpufreq core and clear
	  cpus when we get a call from subsys_interface_unregister() via
	  cpufreq_remove_dev().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index a0a33bd..034d183 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -47,6 +47,9 @@ static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
 #endif
 static DEFINE_SPINLOCK(cpufreq_driver_lock);
 
+/* Used when we unregister cpufreq driver */
+static struct cpumask cpufreq_online_mask;
+
 /*
  * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
  * all cpufreq/hotplug/workqueue/etc related lock issues.
@@ -981,6 +984,7 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	 * managing offline cpus here.
 	 */
 	cpumask_and(policy->cpus, policy->cpus, cpu_online_mask);
+	cpumask_and(policy->cpus, policy->cpus, &cpufreq_online_mask);
 
 	policy->user_policy.min = policy->min;
 	policy->user_policy.max = policy->max;
@@ -1064,7 +1068,6 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 	}
 	per_cpu(cpufreq_cpu_data, cpu) = NULL;
 
-
 #ifdef CONFIG_SMP
 	/* if this isn't the CPU which is the parent of the kobj, we
 	 * only need to unlink, put and exit
@@ -1185,6 +1188,7 @@ static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 	if (unlikely(lock_policy_rwsem_write(cpu)))
 		BUG();
 
+	cpumask_clear_cpu(cpu, &cpufreq_online_mask);
 	retval = __cpufreq_remove_dev(dev, sif);
 	return retval;
 }
@@ -1903,6 +1907,8 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	cpufreq_driver = driver_data;
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
+	cpumask_setall(&cpufreq_online_mask);
+
 	ret = subsys_interface_register(&cpufreq_interface);
 	if (ret)
 		goto err_null_driver;
-- 
1.7.12.rc2.18.g61b472e


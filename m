Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3H1C5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 22:57:25 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37707 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab3H1C5X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 22:57:23 -0400
Date: Tue, 27 Aug 2013 19:57:21 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: mutex warning in cpufreq + RFC patch
Message-ID: <20130828025721.GA19754@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm running this simple test code in a shell on my 3.10 kernel and running
into this warning rather quickly.

	cd /sys/devices/system/cpu/cpu1
	while true
	do
	echo 0 > online
	echo 1 > online
	done &
	while true
	do
	echo 300000 > cpufreq/scaling_min_freq
	echo 1000000 > cpufreq/scaling_min_freq
	done

(Note you should place valid values for min/max freq in the example
above.)

WARNING: at kernel/mutex.c:341 __mutex_lock_slowpath+0x14c/0x410()              DEBUG_LOCKS_WARN_ON(l->magic != l)
Modules linked in:                                                              CPU: 0 PID: 1960 Comm: sh Tainted: G        W    3.10.0 #32                     [<c010c178>] (unwind_backtrace+0x0/0x11c) from [<c0109dec>] (show_stack+0x10/0x14)                                                                              [<c0109dec>] (show_stack+0x10/0x14) from [<c01904cc>] (warn_slowpath_common+0x4c/0x6c)                                                                          [<c01904cc>] (warn_slowpath_common+0x4c/0x6c) from [<c019056c>] (warn_slowpath_fmt+0x2c/0x3c)                                                                   [<c019056c>] (warn_slowpath_fmt+0x2c/0x3c) from [<c08a0334>] (__mutex_lock_slowpath+0x14c/0x410)                                                                [<c08a0334>] (__mutex_lock_slowpath+0x14c/0x410) from [<c08a0618>] (mutex_lock+0x20/0x3c)                                                                       [<c08a0618>] (mutex_lock+0x20/0x3c) from [<c0636114>] (cpufreq_governor_dbs+0x568/0x5f8)                                                                        [<c0636114>] (cpufreq_governor_dbs+0x568/0x5f8) from [<c06325b0>] (__cpufreq_governor+0xdc/0x1a4)                                                               [<c06325b0>] (__cpufreq_governor+0xdc/0x1a4) from [<c06328f0>] (__cpufreq_set_policy+0x278/0x2c0)                                                               [<c06328f0>] (__cpufreq_set_policy+0x278/0x2c0) from [<c0632ea0>] (store_scaling_min_freq+0x80/0x9c)                                                            [<c0632ea0>] (store_scaling_min_freq+0x80/0x9c) from [<c0633ae4>] (store+0x58/0x90)                                                                             [<c0633ae4>] (store+0x58/0x90) from [<c02a69d4>] (sysfs_write_file+0x100/0x148)
[<c02a69d4>] (sysfs_write_file+0x100/0x148) from [<c0255c18>] (vfs_write+0xcc/0x174)
[<c0255c18>] (vfs_write+0xcc/0x174) from [<c0255f70>] (SyS_write+0x38/0x64)     [<c0255f70>] (SyS_write+0x38/0x64) from [<c0106120>] (ret_fast_syscall+0x0/0x30)

This is happening because the governor is stopped via hotplug and
while we're in the middle of touching the scaling_min_freq file.
When the governor is stopped we destroy the timer_mutex that the
scaling_min_freq thread is just about to acquire. From what I can
tell, we shouldn't be stopping the governor until after the
kobjects go away or we should start and stop the governor while
holding the policy semaphore otherwise userspace can come in and
use uninitialized things. I have this hack which seems to mostly
work. Thoughts?

----8<----
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index cbfe3c1..134004b 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -823,11 +823,11 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
 	policy = cpufreq_cpu_get(sibling);
 	WARN_ON(!policy);
 
+	lock_policy_rwsem_write(sibling);
+
 	if (has_target)
 		__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
 
-	lock_policy_rwsem_write(sibling);
-
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 
 	cpumask_set_cpu(cpu, policy->cpus);
@@ -835,12 +835,11 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
 	per_cpu(cpufreq_cpu_data, cpu) = policy;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-	unlock_policy_rwsem_write(sibling);
-
 	if (has_target) {
 		__cpufreq_governor(policy, CPUFREQ_GOV_START);
 		__cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
 	}
+	unlock_policy_rwsem_write(sibling);
 
 	ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
 	if (ret) {
@@ -1037,9 +1036,6 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 		return -EINVAL;
 	}
 
-	if (cpufreq_driver->target)
-		__cpufreq_governor(data, CPUFREQ_GOV_STOP);
-
 #ifdef CONFIG_HOTPLUG_CPU
 	if (!cpufreq_driver->setpolicy)
 		strncpy(per_cpu(cpufreq_cpu_governor, cpu),
@@ -1048,9 +1044,6 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 
 	WARN_ON(lock_policy_rwsem_write(cpu));
 	cpus = cpumask_weight(data->cpus);
-
-	if (cpus > 1)
-		cpumask_clear_cpu(cpu, data->cpus);
 	unlock_policy_rwsem_write(cpu);
 
 	if (cpu != data->cpu) {
@@ -1086,9 +1079,6 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 
 	/* If cpu is last user of policy, free policy */
 	if (cpus == 1) {
-		if (cpufreq_driver->target)
-			__cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
-
 		lock_policy_rwsem_read(cpu);
 		kobj = &data->kobj;
 		cmp = &data->kobj_unregister;
@@ -1103,6 +1093,11 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 		wait_for_completion(cmp);
 		pr_debug("wait complete\n");
 
+		if (cpufreq_driver->target) {
+			__cpufreq_governor(data, CPUFREQ_GOV_STOP);
+			__cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
+		}
+
 		if (cpufreq_driver->exit)
 			cpufreq_driver->exit(data);
 
@@ -1113,8 +1108,13 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
 		pr_debug("%s: removing link, cpu: %d\n", __func__, cpu);
 		cpufreq_cpu_put(data);
 		if (cpufreq_driver->target) {
+			WARN_ON(lock_policy_rwsem_write(cpu));
+			__cpufreq_governor(data, CPUFREQ_GOV_STOP);
+			if (cpus > 1)
+				cpumask_clear_cpu(cpu, data->cpus);
 			__cpufreq_governor(data, CPUFREQ_GOV_START);
 			__cpufreq_governor(data, CPUFREQ_GOV_LIMITS);
+			unlock_policy_rwsem_write(cpu);
 		}
 	}
 

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

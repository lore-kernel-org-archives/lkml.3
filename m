Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaBXG6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 01:58:05 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:56410 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaBXG6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 01:58:02 -0500
From: Saravana Kannan <skannan@codeaurora.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Saravana Kannan" <skannan@codeaurora.org>
Subject: [PATCH] cpufreq: Set policy to non-NULL only after all hotplug online work is done
Date: Sun, 23 Feb 2014 22:57:52 -0800
Message-Id: <1393225072-3997-1-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing code sets the per CPU policy to a non-NULL value before all
the steps performed during the hotplug online path is done. Specifically,
this is done before the policy min/max, governors, etc are initialized for
the policy.  This in turn means that calls to cpufreq_cpu_get() return a
non-NULL policy before the policy/CPU is ready to be used.

To fix this, move the update of per CPU policy to a valid value after all
the initialization steps for the policy are completed.

Example kernel panic without this fix:
[  512.146185] Unable to handle kernel NULL pointer dereference at virtual address 00000020
[  512.146195] pgd = c0003000
[  512.146213] [00000020] *pgd=80000000004003, *pmd=00000000
[  512.146228] Internal error: Oops: 206 [#1] PREEMPT SMP ARM
<snip>
[  512.146297] PC is at __cpufreq_governor+0x10/0x1ac
[  512.146312] LR is at cpufreq_update_policy+0x114/0x150
<snip>
[  512.149740] ---[ end trace f23a8defea6cd706 ]---
[  512.149761] Kernel panic - not syncing: Fatal exception
[  513.152016] CPU0: stopping
[  513.154710] CPU: 0 PID: 7136 Comm: mpdecision Tainted: G      D W    3.10.0-gd727407-00074-g979ede8 #396
<snip>
[  513.317224] [<c0afe180>] (notifier_call_chain+0x40/0x68) from [<c02a23ac>] (__blocking_notifier_call_chain+0x40/0x58)
[  513.327809] [<c02a23ac>] (__blocking_notifier_call_chain+0x40/0x58) from [<c02a23d8>] (blocking_notifier_call_chain+0x14/0x1c)
[  513.339182] [<c02a23d8>] (blocking_notifier_call_chain+0x14/0x1c) from [<c0803c68>] (cpufreq_set_policy+0xd4/0x2b8)
[  513.349594] [<c0803c68>] (cpufreq_set_policy+0xd4/0x2b8) from [<c0803e7c>] (cpufreq_init_policy+0x30/0x98)
[  513.359231] [<c0803e7c>] (cpufreq_init_policy+0x30/0x98) from [<c0805a18>] (__cpufreq_add_dev.isra.17+0x4dc/0x7a4)
[  513.369560] [<c0805a18>] (__cpufreq_add_dev.isra.17+0x4dc/0x7a4) from [<c0805d38>] (cpufreq_cpu_callback+0x58/0x84)
[  513.379978] [<c0805d38>] (cpufreq_cpu_callback+0x58/0x84) from [<c0afe180>] (notifier_call_chain+0x40/0x68)
[  513.389704] [<c0afe180>] (notifier_call_chain+0x40/0x68) from [<c02812dc>] (__cpu_notify+0x28/0x44)
[  513.398728] [<c02812dc>] (__cpu_notify+0x28/0x44) from [<c0aeed90>] (_cpu_up+0xf4/0x1dc)
[  513.406797] [<c0aeed90>] (_cpu_up+0xf4/0x1dc) from [<c0aeeed4>] (cpu_up+0x5c/0x78)
[  513.414357] [<c0aeeed4>] (cpu_up+0x5c/0x78) from [<c0aec808>] (store_online+0x44/0x74)
[  513.422253] [<c0aec808>] (store_online+0x44/0x74) from [<c03a40f4>] (sysfs_write_file+0x108/0x14c)
[  513.431195] [<c03a40f4>] (sysfs_write_file+0x108/0x14c) from [<c03517d4>] (vfs_write+0xd0/0x180)
[  513.439958] [<c03517d4>] (vfs_write+0xd0/0x180) from [<c0351ca8>] (SyS_write+0x38/0x68)
[  513.447947] [<c0351ca8>] (SyS_write+0x38/0x68) from [<c0205de0>] (ret_fast_syscall+0x0/0x30)

In this specific case, CPU0 set's CPU1's policy->governor in
cpufreq_init_policy() to NULL while CPU1 is using the policy->governor in
__cpufreq_governor().

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 drivers/cpufreq/cpufreq.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index cb003a6..d5ceb43 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1109,11 +1109,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 		goto err_set_policy_cpu;
 	}
 
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu(j, policy->cpus)
-		per_cpu(cpufreq_cpu_data, j) = policy;
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
-
 	if (cpufreq_driver->get) {
 		policy->cur = cpufreq_driver->get(policy->cpu);
 		if (!policy->cur) {
@@ -1207,6 +1202,11 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 		policy->user_policy.governor = policy->governor;
 	}
 
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	for_each_cpu(j, policy->cpus)
+		per_cpu(cpufreq_cpu_data, j) = policy;
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
 	kobject_uevent(&policy->kobj, KOBJ_ADD);
 	up_read(&cpufreq_rwsem);
 
-- 
1.8.2.1

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

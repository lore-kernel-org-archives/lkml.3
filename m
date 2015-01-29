Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbbA2Gle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:41:34 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26568 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbbA2Glb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:41:31 -0500
From: Ethan Zhao <ethan.zhao@oracle.com>
To: rjw@rjwysocki.net, viresh.kumar@linaro.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ethan.kernel@gmail.com, Ethan Zhao <ethan.zhao@oracle.com>
Subject: [PATCH] cpufreq: fix another race between PPC notification and vcpu_hotplug()
Date: Thu, 29 Jan 2015 15:42:41 +0900
Message-Id: <1422513761-8230-1-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is race observed between PPC changed notification handler worker thread
and vcpu_hotplug() called within xenbus_thread() context.
It is shown as following WARNING:

 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 4 at include/linux/kref.h:47
 kobject_get+0x41/0x50()
 Modules linked in: acpi_cpufreq(+) nfsd auth_rpcgss nfs_acl
 lockd grace sunrpc xfs libcrc32c sd_mod ixgbe igb mdio ahci hwmon
 ...
 [   14.003548] CPU: 0 PID: 4 Comm: kworker/0:0 Not tainted
 ...
 [   14.003553] Workqueue: kacpi_notify acpi_os_execute_deferred
 [   14.003554]  0000000000000000 000000008c76682c ffff88094c793af8
 ffffffff81661b14
 [   14.003556]  0000000000000000 0000000000000000 ffff88094c793b38
 ffffffff81072b61
 [   14.003558]  ffff88094c793bd8 ffff8812491f8800 0000000000000292
 0000000000000000
 [   14.003560] Call Trace:
 [   14.003567]  [<ffffffff81661b14>] dump_stack+0x46/0x58
 [   14.003571]  [<ffffffff81072b61>] warn_slowpath_common+0x81/0xa0
 [   14.003572]  [<ffffffff81072c7a>] warn_slowpath_null+0x1a/0x20
 [   14.003574]  [<ffffffff812e16d1>] kobject_get+0x41/0x50
 [   14.003579]  [<ffffffff815262a5>] cpufreq_cpu_get+0x75/0xc0
 [   14.003581]  [<ffffffff81527c3e>] cpufreq_update_policy+0x2e/0x1f0
 [   14.003586]  [<ffffffff810b8cb2>] ? up+0x32/0x50
 [   14.003589]  [<ffffffff81381aa9>] ? acpi_ns_get_node+0xcb/0xf2
 [   14.003591]  [<ffffffff81381efd>] ? acpi_evaluate_object+0x22c/0x252
 [   14.003593]  [<ffffffff813824f6>] ? acpi_get_handle+0x95/0xc0
 [   14.003596]  [<ffffffff81360967>] ? acpi_has_method+0x25/0x40
 [   14.003601]  [<ffffffff81391e08>] acpi_processor_ppc_has_changed+0x77/0x82
 [   14.003604]  [<ffffffff81089566>] ? move_linked_works+0x66/0x90
 [   14.003606]  [<ffffffff8138e8ed>] acpi_processor_notify+0x58/0xe7
 [   14.003609]  [<ffffffff8137410c>] acpi_ev_notify_dispatch+0x44/0x5c
 [   14.003611]  [<ffffffff8135f293>] acpi_os_execute_deferred+0x15/0x22
 [   14.003614]  [<ffffffff8108c910>] process_one_work+0x160/0x410
 [   14.003616]  [<ffffffff8108d05b>] worker_thread+0x11b/0x520
 [   14.003617]  [<ffffffff8108cf40>] ? rescuer_thread+0x380/0x380
 [   14.003621]  [<ffffffff81092421>] kthread+0xe1/0x100
 [   14.003623]  [<ffffffff81092340>] ? kthread_create_on_node+0x1b0/0x1b0
 [   14.003628]  [<ffffffff81669ebc>] ret_from_fork+0x7c/0xb0
 [   14.003630]  [<ffffffff81092340>] ? kthread_create_on_node+0x1b0/0x1b0
 [   14.003631] ---[ end trace 89e66eb9795efdf7 ]---

 Thread A: Workqueue: kacpi_notify

 acpi_processor_notify()
   acpi_processor_ppc_has_changed()
	 cpufreq_update_policy()
	   cpufreq_cpu_get()
             kobject_get()

 Thread B: xenbus_thread()

 xenbus_thread()
   msg->u.watch.handle->callback()
     handle_vcpu_hotplug_event()
       vcpu_hotplug()
         cpu_down()
           __cpu_notify(CPU_DOWN_PREPARE..)
             cpufreq_cpu_callback()
               __cpufreq_remove_dev_prepare()
                 update_policy_cpu()
                   kobject_move()

To avoid this race, cpufreq_cpu_get() should check the cpu is offline or not
and move the kobject_move() after up_write(&policy->rwsem) in function
update_policy_cpu() to be sure the updating to the policy was done in another
thread. 

But seems it is not complete fix because of some functions would schedule out
we could couldn't move them into sections proteced by rwsem directly, such as
the move_object().

Only passed buidling with v3.19-rc6.

Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
---
 drivers/cpufreq/cpufreq.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 46bed4f..b5e2bb8 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -202,7 +202,7 @@ struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu)
 	struct cpufreq_policy *policy = NULL;
 	unsigned long flags;
 
-	if (cpufreq_disabled() || (cpu >= nr_cpu_ids))
+	if (cpufreq_disabled() || cpu_is_offline(cpu))
 		return NULL;
 
 	if (!down_read_trylock(&cpufreq_rwsem))
@@ -214,10 +214,18 @@ struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu)
 	if (cpufreq_driver) {
 		/* get the CPU */
 		policy = per_cpu(cpufreq_cpu_data, cpu);
-		if (policy)
-			kobject_get(&policy->kobj);
+		if (!policy)
+			goto out;
+
+		if (policy->cpu != cpu) {
+			policy = NULL;
+			goto out;
+		}
+
+		kobject_get(&policy->kobj);
 	}
 
+out:
 	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	if (!policy)
@@ -1083,13 +1091,6 @@ static int update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu,
 	if (WARN_ON(cpu == policy->cpu))
 		return 0;
 
-	/* Move kobject to the new policy->cpu */
-	ret = kobject_move(&policy->kobj, &cpu_dev->kobj);
-	if (ret) {
-		pr_err("%s: Failed to move kobj: %d\n", __func__, ret);
-		return ret;
-	}
-
 	down_write(&policy->rwsem);
 
 	policy->last_cpu = policy->cpu;
@@ -1097,6 +1098,13 @@ static int update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu,
 
 	up_write(&policy->rwsem);
 
+	/* Move kobject to the new policy->cpu */
+	ret = kobject_move(&policy->kobj, &cpu_dev->kobj);
+	if (ret) {
+		pr_err("%s: Failed to move kobj: %d\n", __func__, ret);
+		return ret;
+	}
+
 	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
 			CPUFREQ_UPDATE_POLICY_CPU, policy);
 
-- 
1.8.3.1


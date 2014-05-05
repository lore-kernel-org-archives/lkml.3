Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbaEER2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:28:32 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:13392 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756AbaEER2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:28:31 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoEJAPLJZ1NbsEtU/2dsb2JhbABZgwarUQcBAgUBmgyBFxd0glMTHCMYgQIkE4hFAcwGhVaIfIRGAQOPGooZAYp+h3aDNjsw
Date: Mon, 5 May 2014 19:28:28 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/cpu.c: convert printk to pr_foo()
Message-Id: <20140505192828.597ae8e304ed849a46d5f70e@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no level printk converted to pr_warn (if err)
no level printk converted to pr_info (disabling non-boot cpus)
Other printk converted to respective level.

Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/cpu.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index a9e710e..c4a146d 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -283,8 +283,7 @@ static inline void check_for_tasks(int cpu)
 		task_cputime(p, &utime, &stime);
 		if (task_cpu(p) == cpu && p->state == TASK_RUNNING &&
 		    (utime || stime))
-			printk(KERN_WARNING "Task %s (pid = %d) is on cpu %d "
-				"(state = %ld, flags = %x)\n",
+			pr_warn("Task %s (pid = %d) is on cpu %d (state = %ld, flags = %x)\n",
 				p->comm, task_pid_nr(p), cpu,
 				p->state, p->flags);
 	}
@@ -336,8 +335,8 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	if (err) {
 		nr_calls--;
 		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
-		printk("%s: attempt to take down CPU %u failed\n",
-				__func__, cpu);
+		pr_warn("%s: attempt to take down CPU %u failed\n",
+			__func__, cpu);
 		goto out_release;
 	}
 
@@ -444,8 +443,8 @@ static int _cpu_up(unsigned int cpu, int tasks_frozen)
 	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (ret) {
 		nr_calls--;
-		printk(KERN_WARNING "%s: attempt to bring up CPU %u failed\n",
-				__func__, cpu);
+		pr_warn("%s: attempt to bring up CPU %u failed\n",
+			__func__, cpu);
 		goto out_notify;
 	}
 
@@ -475,11 +474,10 @@ int cpu_up(unsigned int cpu)
 	int err = 0;
 
 	if (!cpu_possible(cpu)) {
-		printk(KERN_ERR "can't online cpu %d because it is not "
-			"configured as may-hotadd at boot time\n", cpu);
+		pr_err("can't online cpu %d because it is not configured as may-hotadd at boot time\n",
+		       cpu);
 #if defined(CONFIG_IA64)
-		printk(KERN_ERR "please check additional_cpus= boot "
-				"parameter\n");
+		pr_err("please check additional_cpus= boot parameter\n");
 #endif
 		return -EINVAL;
 	}
@@ -518,7 +516,7 @@ int disable_nonboot_cpus(void)
 	 */
 	cpumask_clear(frozen_cpus);
 
-	printk("Disabling non-boot CPUs ...\n");
+	pr_info("Disabling non-boot CPUs ...\n");
 	for_each_online_cpu(cpu) {
 		if (cpu == first_cpu)
 			continue;
@@ -526,8 +524,7 @@ int disable_nonboot_cpus(void)
 		if (!error)
 			cpumask_set_cpu(cpu, frozen_cpus);
 		else {
-			printk(KERN_ERR "Error taking CPU%d down: %d\n",
-				cpu, error);
+			pr_err("Error taking CPU%d down: %d\n", cpu, error);
 			break;
 		}
 	}
@@ -537,7 +534,7 @@ int disable_nonboot_cpus(void)
 		/* Make sure the CPUs won't be enabled by someone else */
 		cpu_hotplug_disabled = 1;
 	} else {
-		printk(KERN_ERR "Non-boot CPUs are not disabled\n");
+		pr_err("Non-boot CPUs are not disabled\n");
 	}
 	cpu_maps_update_done();
 	return error;
@@ -561,17 +558,17 @@ void __ref enable_nonboot_cpus(void)
 	if (cpumask_empty(frozen_cpus))
 		goto out;
 
-	printk(KERN_INFO "Enabling non-boot CPUs ...\n");
+	pr_info("Enabling non-boot CPUs ...\n");
 
 	arch_enable_nonboot_cpus_begin();
 
 	for_each_cpu(cpu, frozen_cpus) {
 		error = _cpu_up(cpu, 1);
 		if (!error) {
-			printk(KERN_INFO "CPU%d is up\n", cpu);
+			pr_info("CPU%d is up\n", cpu);
 			continue;
 		}
-		printk(KERN_WARNING "Error taking CPU%d up: %d\n", cpu, error);
+		pr_warn("Error taking CPU%d up: %d\n", cpu, error);
 	}
 
 	arch_enable_nonboot_cpus_end();
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936415Ab3DQSnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 14:43:32 -0400
Received: from relay3.sgi.com ([192.48.152.1]:46414 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757572Ab3DQSn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 14:43:29 -0400
From: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russ Anderson <rja@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: [PATCH -v5 2/5] Migrate shutdown/reboot to boot cpu.
Date: Wed, 17 Apr 2013 13:43:15 -0500
Message-Id: <1366224198-49485-3-git-send-email-holt@sgi.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366224198-49485-1-git-send-email-holt@sgi.com>
References: <1366224198-49485-1-git-send-email-holt@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We recently noticed that reboot of a 1024 cpu machine takes approx 16
minutes of just stopping the cpus.  The slowdown was tracked to commit
f96972f.

The current implementation does all the work of hot removing the cpus
before halting the system.  We are switching to just migrating to the
boot cpu and then continuing with shutdown/reboot.

This also has the effect of not breaking x86's command line parameter for
specifying the reboot cpu.  Note, this code was shamelessly copied from
arch/x86/kernel/reboot.c with bits removed pertaining to the reboot_cpu
command line parameter.

Signed-off-by: Robin Holt <holt@sgi.com>
Tested-by: Shawn Guo <shawn.guo@linaro.org>
To: Ingo Molnar <mingo@redhat.com>
To: Russ Anderson <rja@sgi.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robin Holt <holt@sgi.com>
Cc: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>

---

Changes since -v4.
 - Integrated comments from Srivatsa S. Bhat

 - Used new cpu_hotplug_disable() function.

 - Added 'static' to new function.

Changes since -v1.
 - Set PF_THREAD_BOUND before migrating to eliminate potential race.

 - Modified kernel_power_off to also migrate instead of using
   disable_nonboot_cpus().
---
 kernel/sys.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 0da73cf..232214e 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -357,6 +357,24 @@ int unregister_reboot_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
+static void migrate_to_reboot_cpu(void)
+{
+	/* The boot cpu is always logical cpu 0 */
+	int reboot_cpu_id = 0;
+
+	cpu_hotplug_disable();
+
+	/* Make certain the cpu I'm about to reboot on is online */
+	if (!cpu_online(reboot_cpu_id))
+		reboot_cpu_id = cpumask_first(cpu_online_mask);
+
+	/* Prevent races with other tasks migrating this task */
+	current->flags |= PF_THREAD_BOUND;
+
+	/* Make certain I only run on the appropriate processor */
+	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
+}
+
 /**
  *	kernel_restart - reboot the system
  *	@cmd: pointer to buffer containing command to execute for restart
@@ -368,7 +386,7 @@ EXPORT_SYMBOL(unregister_reboot_notifier);
 void kernel_restart(char *cmd)
 {
 	kernel_restart_prepare(cmd);
-	disable_nonboot_cpus();
+	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	if (!cmd)
 		printk(KERN_EMERG "Restarting system.\n");
@@ -395,7 +413,7 @@ static void kernel_shutdown_prepare(enum system_states state)
 void kernel_halt(void)
 {
 	kernel_shutdown_prepare(SYSTEM_HALT);
-	disable_nonboot_cpus();
+	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	printk(KERN_EMERG "System halted.\n");
 	kmsg_dump(KMSG_DUMP_HALT);
@@ -414,7 +432,7 @@ void kernel_power_off(void)
 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
 	if (pm_power_off_prepare)
 		pm_power_off_prepare();
-	disable_nonboot_cpus();
+	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	printk(KERN_EMERG "Power down.\n");
 	kmsg_dump(KMSG_DUMP_POWEROFF);
-- 
1.8.1.2


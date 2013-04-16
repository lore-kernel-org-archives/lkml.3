Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935158Ab3DPJ6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:58:30 -0400
Received: from relay2.sgi.com ([192.48.179.30]:41193 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752956Ab3DPJ63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:58:29 -0400
Date: Tue, 16 Apr 2013 04:58:27 -0500
From: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@redhat.com>, Russ Anderson <rja@sgi.com>,
        Shawn Guo <shawn.guo@linaro.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, Robin Holt <holt@sgi.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [Patch -v4 1/4] Migrate shutdown/reboot to boot cpu.
Message-ID: <20130416095827.GJ3672@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
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

Changes since -v1.
- Set PF_THREAD_BOUND before migrating to eliminate potential race.
- Modified kernel_power_off to also migrate instead of using
  disable_nonboot_cpus().
---
 kernel/sys.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 0da73cf..5ef7aa2 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -357,6 +357,22 @@ int unregister_reboot_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
+void migrate_to_reboot_cpu(void)
+{
+	/* The boot cpu is always logical cpu 0 */
+	int reboot_cpu_id = 0;
+
+	/* Make certain the cpu I'm about to reboot on is online */
+	if (!cpu_online(reboot_cpu_id))
+		reboot_cpu_id = smp_processor_id();
+
+	/* Prevent races with other tasks migrating this task. */
+	current->flags |= PF_THREAD_BOUND;
+
+	/* Make certain I only run on the appropriate processor */
+	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
+}
+
 /**
  *	kernel_restart - reboot the system
  *	@cmd: pointer to buffer containing command to execute for restart
@@ -368,7 +384,7 @@ EXPORT_SYMBOL(unregister_reboot_notifier);
 void kernel_restart(char *cmd)
 {
 	kernel_restart_prepare(cmd);
-	disable_nonboot_cpus();
+	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	if (!cmd)
 		printk(KERN_EMERG "Restarting system.\n");
@@ -395,7 +411,7 @@ static void kernel_shutdown_prepare(enum system_states state)
 void kernel_halt(void)
 {
 	kernel_shutdown_prepare(SYSTEM_HALT);
-	disable_nonboot_cpus();
+	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	printk(KERN_EMERG "System halted.\n");
 	kmsg_dump(KMSG_DUMP_HALT);
@@ -414,7 +430,7 @@ void kernel_power_off(void)
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab3FQRha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:37:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50800 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab3FQRh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:37:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Robin Holt <holt@sgi.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Russ Anderson <rja@sgi.com>,
        Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 74/84] reboot: rigrate shutdown/reboot to boot cpu
Date: Mon, 17 Jun 2013 10:31:18 -0700
Message-Id: <1371490288-23167-75-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Holt <holt@sgi.com>

commit cf7df378aa4ff7da3a44769b7ff6e9eef1a9f3db upstream.

We recently noticed that reboot of a 1024 cpu machine takes approx 16
minutes of just stopping the cpus.  The slowdown was tracked to commit
f96972f2dc63 ("kernel/sys.c: call disable_nonboot_cpus() in
kernel_restart()").

The current implementation does all the work of hot removing the cpus
before halting the system.  We are switching to just migrating to the
boot cpu and then continuing with shutdown/reboot.

This also has the effect of not breaking x86's command line parameter
for specifying the reboot cpu.  Note, this code was shamelessly copied
from arch/x86/kernel/reboot.c with bits removed pertaining to the
reboot_cpu command line parameter.

Signed-off-by: Robin Holt <holt@sgi.com>
Tested-by: Shawn Guo <shawn.guo@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/sys.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 47f1d1b..6855153 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -356,6 +356,29 @@ int unregister_reboot_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
+/* Add backwards compatibility for stable trees. */
+#ifndef PF_NO_SETAFFINITY
+#define PF_NO_SETAFFINITY		PF_THREAD_BOUND
+#endif
+
+static void migrate_to_reboot_cpu(void)
+{
+	/* The boot cpu is always logical cpu 0 */
+	int cpu = 0;
+
+	cpu_hotplug_disable();
+
+	/* Make certain the cpu I'm about to reboot on is online */
+	if (!cpu_online(cpu))
+		cpu = cpumask_first(cpu_online_mask);
+
+	/* Prevent races with other tasks migrating this task */
+	current->flags |= PF_NO_SETAFFINITY;
+
+	/* Make certain I only run on the appropriate processor */
+	set_cpus_allowed_ptr(current, cpumask_of(cpu));
+}
+
 /**
  *	kernel_restart - reboot the system
  *	@cmd: pointer to buffer containing command to execute for restart
@@ -367,7 +390,7 @@ EXPORT_SYMBOL(unregister_reboot_notifier);
 void kernel_restart(char *cmd)
 {
 	kernel_restart_prepare(cmd);
-	disable_nonboot_cpus();
+	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	if (!cmd)
 		printk(KERN_EMERG "Restarting system.\n");
@@ -394,7 +417,7 @@ static void kernel_shutdown_prepare(enum system_states state)
 void kernel_halt(void)
 {
 	kernel_shutdown_prepare(SYSTEM_HALT);
-	disable_nonboot_cpus();
+	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	printk(KERN_EMERG "System halted.\n");
 	kmsg_dump(KMSG_DUMP_HALT);
@@ -413,7 +436,7 @@ void kernel_power_off(void)
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


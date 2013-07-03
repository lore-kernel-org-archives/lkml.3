Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965310Ab3GCTPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:15:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20493 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933605Ab3GCTAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:16 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=DlI48GDKGB8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=aVraY7yGGhkA:10 a=eJfxgxciAAAA:8 a=KKAkSRfTAAAA:8 a=VnNF1IyMAAAA:8 a=oGMlB6cnAAAA:8 a=drOt6m5kAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=tHiOMhtqIPGLwIqUsLwA:9 a=W39ifWXXhksA:10 a=WwgC8nHKvroA:10 a=CY6gl2JlH4YA:10 a=Zh68SRI7RUMA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184107.139178049@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:41:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Robin Holt <holt@sgi.com>, Shawn Guo <shawn.guo@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Russ Anderson <rja@sgi.com>,
        Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [123/141] reboot: rigrate shutdown/reboot to boot cpu
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0123-reboot-rigrate-shutdown-reboot-to-boot-cpu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Robin Holt <holt@sgi.com>

[ Upstream commit cf7df378aa4ff7da3a44769b7ff6e9eef1a9f3db ]

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sys.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 61c086b7..7ce45e1 100644
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
1.7.10.4



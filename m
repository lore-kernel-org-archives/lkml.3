Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367Ab3DQSoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 14:44:23 -0400
Received: from relay3.sgi.com ([192.48.152.1]:46418 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936277Ab3DQSn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 14:43:29 -0400
From: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Russ Anderson <rja@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: [PATCH -v5 5/5] Make reboot_cpuid a kernel parameter.
Date: Wed, 17 Apr 2013 13:43:18 -0500
Message-Id: <1366224198-49485-6-git-send-email-holt@sgi.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366224198-49485-1-git-send-email-holt@sgi.com>
References: <1366224198-49485-1-git-send-email-holt@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving the reboot=s<##> parameter for x86 to a kernel parameter
proper.  I did not find any other arch that was specifying the
reboot cpu.

I left a compatibility mode in there.  The new parameter always
takes precedence.  I also fixed up the current code to support
up to cpuid's up to the current max of 4096.

Signed-off-by: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
To: Russ Anderson <rja@sgi.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Oleg Nesterov <oleg@redhat.com>
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
---
 Documentation/kernel-parameters.txt |  2 ++
 arch/x86/kernel/reboot.c            | 39 +++++++++++++------------------------
 kernel/reboot.c                     |  6 +++++-
 3 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..11ebb48 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2597,6 +2597,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Format: <reboot_mode>[,<reboot_mode2>[,...]]
 			See arch/*/kernel/reboot.c or arch/*/kernel/process.c
 
+	reboot_cpuid=	[KNL] cpuid to use for reboot/halt, etc operations.
+
 	relax_domain_level=
 			[KNL, SMP] Set scheduler's default relax_domain_level.
 			See Documentation/cgroups/cpusets.txt.
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 76fa1e9..cdcf28f 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -49,10 +49,6 @@ int reboot_force;
  */
 static int reboot_default = 1;
 
-#ifdef CONFIG_SMP
-static int reboot_cpu = -1;
-#endif
-
 /*
  * This is set if we need to go through the 'emergency' path.
  * When machine_emergency_restart() is called, we may be on
@@ -63,6 +59,8 @@ static int reboot_emergency;
 /* This is set by the PCI code if either type 1 or type 2 PCI is detected */
 bool port_cf9_safe = false;
 
+extern int reboot_cpuid;
+
 /*
  * reboot=b[ios] | s[mp] | t[riple] | k[bd] | e[fi] [, [w]arm | [c]old] | p[ci]
  * warm   Don't set the cold reboot flag
@@ -97,10 +95,14 @@ static int __init reboot_setup(char *str)
 
 #ifdef CONFIG_SMP
 		case 's':
-			if (isdigit(*(str+1))) {
-				reboot_cpu = (int) (*(str+1) - '0');
-				if (isdigit(*(str+2)))
-					reboot_cpu = reboot_cpu*10 + (int)(*(str+2) - '0');
+			if (reboot_cpuid < 0) {
+				int coffset;
+
+				reboot_cpuid = 0;
+				for (coffset = 1; isdigit(*(str + coffset)); coffset++) {
+					reboot_cpuid *= 10;
+					reboot_cpuid += (int)(*(str+2) - '0');
+				}
 			}
 			/*
 			 * We will leave sorting out the final value
@@ -615,25 +617,10 @@ void native_machine_shutdown(void)
 	/* Stop the cpus and apics */
 #ifdef CONFIG_SMP
 
-	/* The boot cpu is always logical cpu 0 */
-	int reboot_cpu_id = 0;
-
-	/* See if there has been given a command line override */
-	if ((reboot_cpu != -1) && (reboot_cpu < nr_cpu_ids) &&
-		cpu_online(reboot_cpu))
-		reboot_cpu_id = reboot_cpu;
-
-	/* Make certain the cpu I'm about to reboot on is online */
-	if (!cpu_online(reboot_cpu_id))
-		reboot_cpu_id = smp_processor_id();
-
-	/* Make certain I only run on the appropriate processor */
-	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
-
 	/*
-	 * O.K Now that I'm on the appropriate processor, stop all of the
-	 * others. Also disable the local irq to not receive the per-cpu
-	 * timer interrupt which may trigger scheduler's load balance.
+	 * Stop all of the others. Also disable the local irq to
+	 * not receive the per-cpu timer interrupt which may trigger
+	 * scheduler's load balance.
 	 */
 	local_irq_disable();
 	stop_other_cpus();
diff --git a/kernel/reboot.c b/kernel/reboot.c
index c4eb2a4..04a162a 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -10,6 +10,7 @@
 #include <linux/kexec.h>
 #include <linux/kmod.h>
 #include <linux/kmsg_dump.h>
+#include <linux/moduleparam.h>
 #include <linux/reboot.h>
 #include <linux/suspend.h>
 #include <linux/syscalls.h>
@@ -69,10 +70,13 @@ int unregister_reboot_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
+int reboot_cpuid = -1;
+core_param(reboot_cpuid, reboot_cpuid, int, 0644);
+
 static void migrate_to_reboot_cpu(void)
 {
 	/* The boot cpu is always logical cpu 0 */
-	int reboot_cpu_id = 0;
+	int reboot_cpu_id = reboot_cpuid;
 
 	cpu_hotplug_disable();
 
-- 
1.8.1.2


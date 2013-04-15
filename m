Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab3DORsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:48:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59300 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756153Ab3DORs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:48:29 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130415173324.GD3658@sgi.com>
References: <20130415171225.GC3658@sgi.com> <20130415171635.GI3672@sgi.com> <71f0c948-cdea-4e8e-86a3-088d306388b9@email.android.com> <20130415173324.GD3658@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch -v3 4/4] Make reboot_cpuid a kernel parameter.
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 15 Apr 2013 10:47:49 -0700
To: Robin Holt <holt@sgi.com>
CC: Ingo Molnar <mingo@redhat.com>, Russ Anderson <rja@sgi.com>,
        Shawn Guo <shawn.guo@linaro.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Message-ID: <0d5a866d-3d40-4592-bb9d-d938fb3312e2@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We usually don't break working user setups as a matter if policy.  Only if it can't be avoided.

Robin Holt <holt@sgi.com> wrote:

>On Mon, Apr 15, 2013 at 10:18:31AM -0700, H. Peter Anvin wrote:
>> Um... doesn't this break anyone who currently depends on this?
>
>Yes.  That is also why I kept this separate and not tagged for
>stable. They would need to start using the more general kernel
>parameter
>to get the same functionality.  Should I have done it differently?
>
>Robin
>
>> 
>> Robin Holt <holt@sgi.com> wrote:
>> 
>> >
>> >Moving the reboot=s<##> parameter for x86 to a kernel parameter
>> >proper.  I did not find any other arch that was specifying the
>> >reboot cpu.
>> >
>> >Signed-off-by: Robin Holt <holt@sgi.com>
>> >To: Ingo Molnar <mingo@redhat.com>
>> >To: Russ Anderson <rja@sgi.com>
>> >Cc: Shawn Guo <shawn.guo@linaro.org>
>> >Cc: Oleg Nesterov <oleg@redhat.com>
>> >Cc: Andrew Morton <akpm@linux-foundation.org>
>> >Cc: "H. Peter Anvin" <hpa@zytor.com>
>> >Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
>> >Cc: Linus Torvalds <torvalds@linux-foundation.org>
>> >Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
>> >Cc: Michel Lespinasse <walken@google.com>
>> >Cc: Oleg Nesterov <oleg@redhat.com>
>> >Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>> >Cc: Paul Mackerras <paulus@samba.org>
>> >Cc: Peter Zijlstra <peterz@infradead.org>
>> >Cc: Robin Holt <holt@sgi.com>
>> >Cc: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
>> >Cc: Tejun Heo <tj@kernel.org>
>> >Cc: the arch/x86 maintainers <x86@kernel.org>
>> >Cc: Thomas Gleixner <tglx@linutronix.de>
>> >---
>> > Documentation/kernel-parameters.txt |  2 ++
>> >arch/x86/kernel/reboot.c            | 44
>> >++++---------------------------------
>> > kernel/reboot.c                     |  8 ++++++-
>> > 3 files changed, 13 insertions(+), 41 deletions(-)
>> >
>> >diff --git a/Documentation/kernel-parameters.txt
>> >b/Documentation/kernel-parameters.txt
>> >index 4609e81..11ebb48 100644
>> >--- a/Documentation/kernel-parameters.txt
>> >+++ b/Documentation/kernel-parameters.txt
>> >@@ -2597,6 +2597,8 @@ bytes respectively. Such letter suffixes can
>also
>> >be entirely omitted.
>> > 			Format: <reboot_mode>[,<reboot_mode2>[,...]]
>> > 			See arch/*/kernel/reboot.c or arch/*/kernel/process.c
>> > 
>> >+	reboot_cpuid=	[KNL] cpuid to use for reboot/halt, etc operations.
>> >+
>> > 	relax_domain_level=
>> > 			[KNL, SMP] Set scheduler's default relax_domain_level.
>> > 			See Documentation/cgroups/cpusets.txt.
>> >diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
>> >index 76fa1e9..39af130 100644
>> >--- a/arch/x86/kernel/reboot.c
>> >+++ b/arch/x86/kernel/reboot.c
>> >@@ -49,10 +49,6 @@ int reboot_force;
>> >  */
>> > static int reboot_default = 1;
>> > 
>> >-#ifdef CONFIG_SMP
>> >-static int reboot_cpu = -1;
>> >-#endif
>> >-
>> > /*
>> >  * This is set if we need to go through the 'emergency' path.
>> >  * When machine_emergency_restart() is called, we may be on
>> >@@ -64,11 +60,10 @@ static int reboot_emergency;
>> > bool port_cf9_safe = false;
>> > 
>> > /*
>> >- * reboot=b[ios] | s[mp] | t[riple] | k[bd] | e[fi] [, [w]arm |
>> >[c]old] | p[ci]
>> >+ * reboot=b[ios] | t[riple] | k[bd] | e[fi] [, [w]arm | [c]old] |
>> >p[ci]
>> >  * warm   Don't set the cold reboot flag
>> >  * cold   Set the cold reboot flag
>> >  * bios   Reboot by jumping through the BIOS
>> >- * smp    Reboot by executing reset on BSP or other CPU
>> >  * triple Force a triple fault (init)
>> >  * kbd    Use the keyboard controller. cold reset (default)
>> >  * acpi   Use the RESET_REG in the FADT
>> >@@ -95,21 +90,6 @@ static int __init reboot_setup(char *str)
>> > 			reboot_mode = 0;
>> > 			break;
>> > 
>> >-#ifdef CONFIG_SMP
>> >-		case 's':
>> >-			if (isdigit(*(str+1))) {
>> >-				reboot_cpu = (int) (*(str+1) - '0');
>> >-				if (isdigit(*(str+2)))
>> >-					reboot_cpu = reboot_cpu*10 + (int)(*(str+2) - '0');
>> >-			}
>> >-			/*
>> >-			 * We will leave sorting out the final value
>> >-			 * when we are ready to reboot, since we might not
>> >-			 * have detected BSP APIC ID or smp_num_cpu
>> >-			 */
>> >-			break;
>> >-#endif /* CONFIG_SMP */
>> >-
>> > 		case 'b':
>> > 		case 'a':
>> > 		case 'k':
>> >@@ -614,26 +594,10 @@ void native_machine_shutdown(void)
>> > {
>> > 	/* Stop the cpus and apics */
>> > #ifdef CONFIG_SMP
>> >-
>> >-	/* The boot cpu is always logical cpu 0 */
>> >-	int reboot_cpu_id = 0;
>> >-
>> >-	/* See if there has been given a command line override */
>> >-	if ((reboot_cpu != -1) && (reboot_cpu < nr_cpu_ids) &&
>> >-		cpu_online(reboot_cpu))
>> >-		reboot_cpu_id = reboot_cpu;
>> >-
>> >-	/* Make certain the cpu I'm about to reboot on is online */
>> >-	if (!cpu_online(reboot_cpu_id))
>> >-		reboot_cpu_id = smp_processor_id();
>> >-
>> >-	/* Make certain I only run on the appropriate processor */
>> >-	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
>> >-
>> > 	/*
>> >-	 * O.K Now that I'm on the appropriate processor, stop all of the
>> >-	 * others. Also disable the local irq to not receive the per-cpu
>> >-	 * timer interrupt which may trigger scheduler's load balance.
>> >+	 * Stop all of the others. Also disable the local irq to
>> >+	 * not receive the per-cpu timer interrupt which may trigger
>> >+	 * scheduler's load balance.
>> > 	 */
>> > 	local_irq_disable();
>> > 	stop_other_cpus();
>> >diff --git a/kernel/reboot.c b/kernel/reboot.c
>> >index 187a0d8..9fbab07 100644
>> >--- a/kernel/reboot.c
>> >+++ b/kernel/reboot.c
>> >@@ -8,6 +8,7 @@
>> > #include <linux/kexec.h>
>> > #include <linux/kmod.h>
>> > #include <linux/kmsg_dump.h>
>> >+#include <linux/moduleparam.h>
>> > #include <linux/reboot.h>
>> > #include <linux/syscalls.h>
>> > #include <linux/syscore_ops.h>
>> >@@ -66,13 +67,18 @@ int unregister_reboot_notifier(struct
>> >notifier_block *nb)
>> > }
>> > EXPORT_SYMBOL(unregister_reboot_notifier);
>> > 
>> >+int reboot_cpuid;
>> >+core_param(reboot_cpuid, reboot_cpuid, int, 0644);
>> >+
>> > void migrate_to_reboot_cpu(void)
>> > {
>> > 	/* The boot cpu is always logical cpu 0 */
>> >-	int reboot_cpu_id = 0;
>> >+	int reboot_cpu_id = reboot_cpuid;
>> > 
>> > 	/* Make certain the cpu I'm about to reboot on is online */
>> > 	if (!cpu_online(reboot_cpu_id))
>> >+		reboot_cpu_id = 0;
>> >+	if (!cpu_online(reboot_cpu_id))
>> > 		reboot_cpu_id = smp_processor_id();
>> > 
>> > 	/* Prevent races with other tasks migrating this task. */
>> 
>> -- 
>> Sent from my mobile phone. Please excuse brevity and lack of
>formatting.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.

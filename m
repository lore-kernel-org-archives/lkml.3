Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab3ELLjP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 07:39:15 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:56845 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab3ELLjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 07:39:13 -0400
Date: Sun, 12 May 2013 04:39:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
Subject: Re: [v3.10-rc1] WARNING: at kernel/rcutree.c:502
Message-ID: <20130512113905.GH3648@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <87ip2opntp.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ip2opntp.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051211-7408-0000-0000-000010169742
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 11:08:50AM +0200, Bjørn Mork wrote:
> Hello,
> 
> got the splat below when running powertop on plain v3.10-rc1
> (i.e. without my previously mentioned revert patch or any other extra
> patches).  Config attached.

OK, it looks like you have context-tracking enabled, so you might be
hitting a bug that Steven Rostedt found a few days ago.  Could you
please try out his fix below?

							Thanx, Paul

------------------------------------------------------------------------


I started testing the new NOHZ_FULL in the kernel and had some issues,
so I started function tracing and this bug report came out:


[23446.458073] ------------[ cut here ]------------
[23446.461028] WARNING:
at /home/rostedt/work/git/linux-trace.git/kernel/rcutree.c:388
rcu_eqs_enter+0x4b/0x89()
[23446.466096] Modules linked in: ebtables ipt_MASQUERADE sunrpc bridge
stp llc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter
ip6_tables ipv6 uinput snd_hda_codec_id
t snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm
kvm_intel snd_timer snd kvm soundcore shpchp snd_page_alloc microcode
i2c_i801 pata_acpi firewire_ohci firewi
re_core crc_itu_t ata_generic i915 drm_kms_helper drm i2c_algo_bit
i2c_core video
[23446.466096] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.9.0-test+ #11
[23446.466096] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./To be filled by O.E.M., BIOS SDBLI944.86P 05/08/2007
[23446.466096]  ffffffff814879f0 ffffffff81004fa6 ffffffff810337af
ffff88007d400000
[23446.466096]  0000000000000000 0000000000000000 ffff88007d40d900
ffffffff81a01f00
[23446.466096]  ffffffff81acba00 ffff88007d6495c0 ffffffff810a1f36
0000000000000a28
[23446.466096] Call Trace:
[23446.466096]  [<ffffffff814879f0>] ? dump_stack+0xd/0x17
[23446.466096]  [<ffffffff81004fa6>] ? show_stack+0x5/0x3e
[23446.466096]  [<ffffffff810337af>] ? warn_slowpath_common+0x64/0x7c
[23446.466096]  [<ffffffff810a1f36>] ? rcu_eqs_enter+0x4b/0x89
[23446.466096]  [<ffffffff810a1f8e>] ? rcu_idle_enter+0x1a/0x30
[23446.466096]  [<ffffffff81491bc5>] ? ftrace_graph_caller+0x85/0x85
[23446.466096]  [<ffffffff810707f3>] cpu_startup_entry+0xb3/0x11c
[23446.466096]  [<ffffffff81ae9d2e>] ? start_kernel+0x41a/0x425
[23446.466096]  [<ffffffff81ae972d>] ? repair_env_string+0x54/0x54
[23446.466096] ---[ end trace ddbb69ae2a0f6687 ]---
[23446.466096] ------------[ cut here ]------------

This is caused by an imbalance of rcu_eqs_enter() and rcu_eqs_exit().
Adding more tracing, I also discovered that there seemed to be an
imbalance in user_exit() and user_enter(). Specifically, I found that
user_enter() was called, and then a migration happened and user_exit()
was never called before the schedule. Then I had noticed this in my
trace:

run-isol-11546   1.N.. 37363.637641: function:             schedule_user <-- retint_careful
run-isol-11546   1.N.. 37363.637641: function:             __schedule <-- preempt_schedule

The funny part here is that schedule_user does not call
preempt_schedule. But then I also noticed the flags of the call to
schedule_user(): "1.N..". This shows that it was running on cpu 1 with
NEED_RESCHED set (N), but both interrupts and preemption are enabled. If
an interrupt came in here we can schedule out again, but that would call
preempt_schedule_irq, which has code to check if its in "user context
(according to dynamic_ticks)" and would do the user_exit() too. But
something didn't seem right here.

Then I realized that it was actually the function tracer itself, as for
every function it traces, it calls preempt_disable() and
preempt_enable() to record the data on a per_cpu buffer. That
preempt_enable() noticed the NEED_RESCHED set and since preemption is
enabled, it kindly called preempt_schedule() for us!

All this before schedule_user() was able to call user_exit() and take us
out of dynamic tick user context.

I then looked at the code in entry_64.S, and noticed that the calls to
SCHEDULE_USER were all encompassed with ENABLE_INTERRUPTS and
DISABLE_INTERRUPTS before calling schedule. And the SCHEDULE_USER macro
is different if we have CONTEXT_TRACKING enabled or not.

I created a new schedule_irq_disabled() which is similar to
schedule_preempt_disable()  and works like preempt_schedule_irq(), where
it includes the exception_enter() and exit() routines that take care of
the accounting of dynamic ticks when interrupting user mode or not. It
also takes care of it before enabling interrupts, so we don't need to
worry about any preemption happening at the wrong time.

Now the code always calls schedule_irq_disabled() whether or not
CONTEXT_TRACKING is configured, which cleans up entry_64.S and removes
the need of the context_tracking.h header file in asm.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-trace.git/arch/x86/include/asm/context_tracking.h
===================================================================
--- linux-trace.git.orig/arch/x86/include/asm/context_tracking.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef _ASM_X86_CONTEXT_TRACKING_H
-#define _ASM_X86_CONTEXT_TRACKING_H
-
-#ifdef CONFIG_CONTEXT_TRACKING
-# define SCHEDULE_USER call schedule_user
-#else
-# define SCHEDULE_USER call schedule
-#endif
-
-#endif
Index: linux-trace.git/arch/x86/kernel/entry_64.S
===================================================================
--- linux-trace.git.orig/arch/x86/kernel/entry_64.S
+++ linux-trace.git/arch/x86/kernel/entry_64.S
@@ -56,7 +56,6 @@
 #include <asm/ftrace.h>
 #include <asm/percpu.h>
 #include <asm/asm.h>
-#include <asm/context_tracking.h>
 #include <asm/smap.h>
 #include <linux/err.h>

@@ -654,6 +653,7 @@ sysret_check:
 	LOCKDEP_SYS_EXIT
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
+sysret_check_irqsoff:
 	movl TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET),%edx
 	andl %edi,%edx
 	jnz  sysret_careful
@@ -675,12 +675,10 @@ sysret_check:
 sysret_careful:
 	bt $TIF_NEED_RESCHED,%edx
 	jnc sysret_signal
-	TRACE_IRQS_ON
-	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq_cfi %rdi
-	SCHEDULE_USER
+	call schedule_irq_disabled
 	popq_cfi %rdi
-	jmp sysret_check
+	jmp sysret_check_irqsoff

 	/* Handle a signal */
 sysret_signal:
@@ -788,13 +786,9 @@ GLOBAL(int_with_check)
 int_careful:
 	bt $TIF_NEED_RESCHED,%edx
 	jnc  int_very_careful
-	TRACE_IRQS_ON
-	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq_cfi %rdi
-	SCHEDULE_USER
+	call schedule_irq_disabled
 	popq_cfi %rdi
-	DISABLE_INTERRUPTS(CLBR_NONE)
-	TRACE_IRQS_OFF
 	jmp int_with_check

 	/* handle signals and tracing -- both require a full stack frame */
@@ -1088,14 +1082,10 @@ retint_careful:
 	CFI_RESTORE_STATE
 	bt    $TIF_NEED_RESCHED,%edx
 	jnc   retint_signal
-	TRACE_IRQS_ON
-	ENABLE_INTERRUPTS(CLBR_NONE)
 	pushq_cfi %rdi
-	SCHEDULE_USER
+	call schedule_irq_disabled
 	popq_cfi %rdi
 	GET_THREAD_INFO(%rcx)
-	DISABLE_INTERRUPTS(CLBR_NONE)
-	TRACE_IRQS_OFF
 	jmp retint_check

 retint_signal:
@@ -1534,11 +1524,7 @@ paranoid_userspace:
 	TRACE_IRQS_OFF
 	jmp paranoid_userspace
 paranoid_schedule:
-	TRACE_IRQS_ON
-	ENABLE_INTERRUPTS(CLBR_ANY)
-	SCHEDULE_USER
-	DISABLE_INTERRUPTS(CLBR_ANY)
-	TRACE_IRQS_OFF
+	call schedule_irq_disabled
 	jmp paranoid_userspace
 	CFI_ENDPROC
 END(paranoid_exit)
Index: linux-trace.git/kernel/sched/core.c
===================================================================
--- linux-trace.git.orig/kernel/sched/core.c
+++ linux-trace.git/kernel/sched/core.c
@@ -3034,21 +3034,6 @@ asmlinkage void __sched schedule(void)
 }
 EXPORT_SYMBOL(schedule);

-#ifdef CONFIG_CONTEXT_TRACKING
-asmlinkage void __sched schedule_user(void)
-{
-	/*
-	 * If we come here after a random call to set_need_resched(),
-	 * or we have been woken up remotely but the IPI has not yet arrived,
-	 * we haven't yet exited the RCU idle mode. Do it here manually until
-	 * we find a better solution.
-	 */
-	user_exit();
-	schedule();
-	user_enter();
-}
-#endif
-
 /**
  * schedule_preempt_disabled - called with preemption disabled
  *
@@ -3127,6 +3112,24 @@ asmlinkage void __sched preempt_schedule

 #endif /* CONFIG_PREEMPT */

+/*
+ * this is the entry point to schedule() from kernel irq off context.
+ * Note, that this is called and return with irqs disabled. This will
+ * protect us against recursive calling from irq.
+ */
+asmlinkage void __sched schedule_irq_disabled(void)
+{
+	enum ctx_state prev_state;
+
+	prev_state = exception_enter();
+
+	local_irq_enable();
+	__schedule();
+	local_irq_disable();
+
+	exception_exit(prev_state);
+}
+
 int default_wake_function(wait_queue_t *curr, unsigned mode, int wake_flags,
 			  void *key)
 {




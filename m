Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab3EJVTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 17:19:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11839 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab3EJVS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 17:18:27 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=0ts6dBIOsdIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=CwexLI1iYHoA:10 a=SWP42pAv5RbSkkFH0IkA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130510211825.341015861@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 17:12:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/3] x86/sched/context_tracking: Call new schedule_preempt_user() from entry_64.S
References: <20130510211225.594959788@goodmis.org>
Content-Disposition: inline; filename=fix-user-exit-preempt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

I even verified this by adding a:

  preempt_disable();
  preempt_enable();

just before the user_exit() and ran a test without doing any tracing and
was able to easily hit this bug.

I then looked at the code in entry_64.S, and noticed that the calls to
SCHEDULE_USER were all encompassed with ENABLE_INTERRUPTS and
DISABLE_INTERRUPTS before calling schedule. And the SCHEDULE_USER macro
is different if we have CONTEXT_TRACKING enabled or not.

I created a new schedule_preempt_user() which is similar to
schedule_preempt_disable()  and works like preempt_schedule_irq(), where
it includes the exception_enter() and exit() routines that take care of
the accounting of dynamic ticks when interrupting user mode or not. It
also takes care of it before enabling interrupts, so we don't need to
worry about any preemption happening at the wrong time.

Now the code always calls schedule_preempt_user() whether or not
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
+	call schedule_preempt_user
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
+	call schedule_preempt_user
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
+	call schedule_preempt_user
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
+	call schedule_preempt_user
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
+ * This is a entry point to the scheduler() just before going
+ * back to user space. This is called with irqs disabled
+ * which prevents races with the CONTEXT_TRACKING updates.
+ */
+asmlinkage void __sched schedule_preempt_user(void)
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


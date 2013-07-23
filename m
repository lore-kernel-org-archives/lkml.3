Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab3GWIKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:10:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57086 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362Ab3GWIJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:09:34 -0400
Date: Tue, 23 Jul 2013 10:09:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org
Subject: Re: Re: [PATCH -tip/x86/jumplabel] x86: call out into int3 handler
 directly instead of using notifier
In-Reply-To: <20130723074505.GA15255@gmail.com>
Message-ID: <alpine.LNX.2.00.1307231007490.14024@pobox.suse.cz>
References: <20130720131226.GA13893@localhost> <alpine.LNX.2.00.1307221307280.23128@pobox.suse.cz> <51ED9BC0.6020206@linux.intel.com> <alpine.LNX.2.00.1307222256120.14024@pobox.suse.cz> <51EDDB4B.6030609@hitachi.com> <20130723074505.GA15255@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jul 2013, Ingo Molnar wrote:

> > > it's x86/jumplabel branch, as a followup to commit 
> > > fd4363fff3d96 ("x86: Introduce int3 (breakpoint)-based instruction 
> > > patching") sitting there.
> > 
> > AFAICS, tip/master already merged Jiri's works on tip/x86/jumplabel.
> > Thus both branches need this. (especially, since this is actual
> > bugfix, it should go into tip/master.)
> 
> I resolved it yesterday by keeping the kprobes patches in perf/core - just 
> forgot to push it all out.
> 
> I've pushed it out now, so perf/core should be a baseline: it merges in 
> x86/jumplabel and then applies the kprobes patches (historically in 
> perf/core).

Ok, thanks Ingo. Rebased fix below.




From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] x86: call out into int3 handler directly instead of using notifier

In fd4363fff3d96 ("x86: Introduce int3 (breakpoint)-based instruction
patching"), the mechanism that was introduced for notifying alternatives
code from int3 exception handler that and exception occured was
die_notifier.

This is however problematic, as early code might be using jump labels even
before the notifier registration has been performed, which will then lead
to an oops due to unhandled exception. One of such occurences has been
encountered by Fengguang:

 int3: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
 Modules linked in:
 CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.11.0-rc1-01429-g04bf576 #8
 task: ffff88000da1b040 ti: ffff88000da1c000 task.ti: ffff88000da1c000
 RIP: 0010:[<ffffffff811098cc>]  [<ffffffff811098cc>] ttwu_do_wakeup+0x28/0x225
 RSP: 0000:ffff88000dd03f10  EFLAGS: 00000006
 RAX: 0000000000000000 RBX: ffff88000dd12940 RCX: ffffffff81769c40
 RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000001
 RBP: ffff88000dd03f28 R08: ffffffff8176a8c0 R09: 0000000000000002
 R10: ffffffff810ff484 R11: ffff88000dd129e8 R12: ffff88000dbc90c0
 R13: ffff88000dbc90c0 R14: ffff88000da1dfd8 R15: ffff88000da1dfd8
 FS:  0000000000000000(0000) GS:ffff88000dd00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 00000000ffffffff CR3: 0000000001c88000 CR4: 00000000000006e0
 Stack:
  ffff88000dd12940 ffff88000dbc90c0 ffff88000da1dfd8 ffff88000dd03f48
  ffffffff81109e2b ffff88000dd12940 0000000000000000 ffff88000dd03f68
  ffffffff81109e9e 0000000000000000 0000000000012940 ffff88000dd03f98
 Call Trace:
  <IRQ>
  [<ffffffff81109e2b>] ttwu_do_activate.constprop.56+0x6d/0x79
  [<ffffffff81109e9e>] sched_ttwu_pending+0x67/0x84
  [<ffffffff8110c845>] scheduler_ipi+0x15a/0x2b0
  [<ffffffff8104dfb4>] smp_reschedule_interrupt+0x38/0x41
  [<ffffffff8173bf5d>] reschedule_interrupt+0x6d/0x80
  <EOI>
  [<ffffffff810ff484>] ? __atomic_notifier_call_chain+0x5/0xc1
  [<ffffffff8105cc30>] ? native_safe_halt+0xd/0x16
  [<ffffffff81015f10>] default_idle+0x147/0x282
  [<ffffffff81017026>] arch_cpu_idle+0x3d/0x5d
  [<ffffffff81127d6a>] cpu_idle_loop+0x46d/0x5db
  [<ffffffff81127f5c>] cpu_startup_entry+0x84/0x84
  [<ffffffff8104f4f8>] start_secondary+0x3c8/0x3d5
 Code: 5c 5d c3 e8 d7 0f 63 00 55 48 ff 05 1f 5d 1e 01 48 89 e5 41 55 49 89 f5 41 54 53 48 89 fb e8 8d fe ff ff 48
 01 cc <1f> 44 00 00 31 c0 eb 0c 48 ff 05 05 5d 1e 01 b8 01 00 00 00 48
 RIP  [<ffffffff811098cc>] ttwu_do_wakeup+0x28/0x225
  RSP <ffff88000dd03f10>
 ---[ end trace 0d3288a047152a17 ]---

Fix this by directly calling poke_int3_handler() from the int3 exception
handler (analogically to what ftrace has been doing already), instead of
relying on notifier, registration of which might not have yet been
finalized by the time of the first trap.

Reported-and-tested-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 arch/x86/include/asm/alternative.h |    2 ++
 arch/x86/kernel/alternative.c      |   31 ++++++++-----------------------
 arch/x86/kernel/traps.c            |    4 ++++
 kernel/kprobes.c                   |    2 +-
 4 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 4daf8c5..0a3f9c9 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -5,6 +5,7 @@
 #include <linux/stddef.h>
 #include <linux/stringify.h>
 #include <asm/asm.h>
+#include <asm/ptrace.h>
 
 /*
  * Alternative inline assembly for SMP.
@@ -224,6 +225,7 @@ extern void *text_poke_early(void *addr, const void *opcode, size_t len);
  * inconsistent instruction while you patch.
  */
 extern void *text_poke(void *addr, const void *opcode, size_t len);
+extern int poke_int3_handler(struct pt_regs *regs);
 extern void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler);
 
 #endif /* _ASM_X86_ALTERNATIVE_H */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 5d8782e..15e8563 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -605,26 +605,24 @@ static void do_sync_core(void *info)
 static bool bp_patching_in_progress;
 static void *bp_int3_handler, *bp_int3_addr;
 
-static int int3_notify(struct notifier_block *self, unsigned long val, void *data)
+int poke_int3_handler(struct pt_regs *regs)
 {
-	struct die_args *args = data;
-
 	/* bp_patching_in_progress */
 	smp_rmb();
 
 	if (likely(!bp_patching_in_progress))
-		return NOTIFY_DONE;
+		return 0;
 
-	/* we are not interested in non-int3 faults and ring > 0 faults */
-	if (val != DIE_INT3 || !args->regs || user_mode_vm(args->regs)
-			    || args->regs->ip != (unsigned long)bp_int3_addr)
-		return NOTIFY_DONE;
+	if (user_mode_vm(regs) || regs->ip != (unsigned long)bp_int3_addr)
+		return 0;
 
 	/* set up the specified breakpoint handler */
-	args->regs->ip = (unsigned long) bp_int3_handler;
+	regs->ip = (unsigned long) bp_int3_handler;
+
+	return 1;
 
-	return NOTIFY_STOP;
 }
+
 /**
  * text_poke_bp() -- update instructions on live kernel on SMP
  * @addr:	address to patch
@@ -689,16 +687,3 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 	return addr;
 }
 
-/* this one needs to run before anything else handles it as a
- * regular exception */
-static struct notifier_block int3_nb = {
-	.priority = 0x7fffffff,
-	.notifier_call = int3_notify
-};
-
-static int __init int3_init(void)
-{
-	return register_die_notifier(&int3_nb);
-}
-
-arch_initcall(int3_init);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 1b23a1c..8c8093b 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -58,6 +58,7 @@
 #include <asm/mce.h>
 #include <asm/fixmap.h>
 #include <asm/mach_traps.h>
+#include <asm/alternative.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/x86_init.h>
@@ -327,6 +328,9 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
 	    ftrace_int3_handler(regs))
 		return;
 #endif
+	if (poke_int3_handler(regs))
+		return;
+
 	prev_state = exception_enter();
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
 	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index b58b490..6e33498 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1709,7 +1709,7 @@ EXPORT_SYMBOL_GPL(unregister_kprobes);
 
 static struct notifier_block kprobe_exceptions_nb = {
 	.notifier_call = kprobe_exceptions_notify,
-	.priority = 0x7ffffff0 /* High priority, but not first.  */
+	.priority = 0x7fffffff /* we need to be notified first */
 };
 
 unsigned long __weak arch_deref_entry_point(void *entry)

-- 
Jiri Kosina
SUSE Labs

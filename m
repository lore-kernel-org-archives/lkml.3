Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab3GUIa5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 04:30:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab3GUIat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 04:30:49 -0400
Date: Sun, 21 Jul 2013 10:30:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [x86] Kernel panic - not syncing: Fatal exception in interrupt
In-Reply-To: <51EB29FD.60508@zytor.com>
Message-ID: <alpine.LNX.2.00.1307211004100.31632@pobox.suse.cz>
References: <20130720131226.GA13893@localhost> <51EB29FD.60508@zytor.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Jul 2013, H. Peter Anvin wrote:

> > [    0.212429] devtmpfs: initialized
> > [    0.236027] int3: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> > [    0.237157] Modules linked in:
> > [    0.237765] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.11.0-rc1-01429-g04bf576 #8
> > [    0.239129] task: ffff88000da1b040 ti: ffff88000da1c000 task.ti: ffff88000da1c000
> > [    0.240000] RIP: 0010:[<ffffffff811098cc>]  [<ffffffff811098cc>] ttwu_do_wakeup+0x28/0x225
> > [    0.240000] RSP: 0000:ffff88000dd03f10  EFLAGS: 00000006
> > [    0.240000] RAX: 0000000000000000 RBX: ffff88000dd12940 RCX: ffffffff81769c40
> > [    0.240000] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000001
> > [    0.240000] RBP: ffff88000dd03f28 R08: ffffffff8176a8c0 R09: 0000000000000002
> > [    0.240000] R10: ffffffff810ff484 R11: ffff88000dd129e8 R12: ffff88000dbc90c0
> > [    0.240000] R13: ffff88000dbc90c0 R14: ffff88000da1dfd8 R15: ffff88000da1dfd8
> > [    0.240000] FS:  0000000000000000(0000) GS:ffff88000dd00000(0000) knlGS:0000000000000000
> > [    0.240000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [    0.240000] CR2: 00000000ffffffff CR3: 0000000001c88000 CR4: 00000000000006e0
> > [    0.240000] Stack:
> > [    0.240000]  ffff88000dd12940 ffff88000dbc90c0 ffff88000da1dfd8 ffff88000dd03f48
> > [    0.240000]  ffffffff81109e2b ffff88000dd12940 0000000000000000 ffff88000dd03f68
> > [    0.240000]  ffffffff81109e9e 0000000000000000 0000000000012940 ffff88000dd03f98
> > [    0.240000] Call Trace:
> > [    0.240000]  <IRQ> 
> > [    0.240000]  [<ffffffff81109e2b>] ttwu_do_activate.constprop.56+0x6d/0x79
> > [    0.240000]  [<ffffffff81109e9e>] sched_ttwu_pending+0x67/0x84
> > [    0.240000]  [<ffffffff8110c845>] scheduler_ipi+0x15a/0x2b0
> > [    0.240000]  [<ffffffff8104dfb4>] smp_reschedule_interrupt+0x38/0x41
> > [    0.240000]  [<ffffffff8173bf5d>] reschedule_interrupt+0x6d/0x80
> > [    0.240000]  <EOI> 
> > [    0.240000]  [<ffffffff810ff484>] ? __atomic_notifier_call_chain+0x5/0xc1
> > [    0.240000]  [<ffffffff8105cc30>] ? native_safe_halt+0xd/0x16
> 
> Well, it is definitely easy to see what happened here.
> 
> We took a breakpoint fault that the kernel didn't expect.  This
> shouldn't happen... the breakpoint handler should have said "oh, this is
> an instruction being patched" and resumed, but that didn't happen.
> 
> Jiri, I'm wondering if by any chance we have more than one CPU inside
> text_poke_bp() at the same time.  The global variables in text_poke_bp()
> don't seem to be protected against reentrancy at all.

That shouldn't happen, because:


- text_poke_bp() should always be called under text_mutex (and 
  arch_jump_label_transform() does that properly)

- correctness between int3_notify() and texp_poke_bp() wrt. global 
  variables is achieved through barrier

So we should be safe here afaics.

What I am however wondering whether can't be case here is that the jump 
label was used before int3_notifier has been registered.
I am thinking about ways around this, but we'll probably have to do the 
same ftrace is doing, i.e. hook into do_int3() directly instead of relying 
on the notifier to be registered in time.

Fengguang, as I am not able to reproduce this bug locally, could you do me 
a favor and test whether the patch below works the problem around, just 
for the sake of testing the hypothesis?

Thanks.


From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] x86: call out into int3 handler directly instead of using notifier

---
 arch/x86/include/asm/alternative.h |    2 ++
 arch/x86/kernel/alternative.c      |   22 +++++++++++++++++++++-
 arch/x86/kernel/traps.c            |    4 ++++
 3 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 3abf8dd..c22a41d 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -5,6 +5,7 @@
 #include <linux/stddef.h>
 #include <linux/stringify.h>
 #include <asm/asm.h>
+#include <asm/ptrace.h>
 
 /*
  * Alternative inline assembly for SMP.
@@ -232,6 +233,7 @@ struct text_poke_param {
 	size_t len;
 };
 
+extern int poke_bp_int3_handler(struct pt_regs *regs);
 extern void *text_poke(void *addr, const void *opcode, size_t len);
 extern void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler);
 extern void *text_poke_smp(void *addr, const void *opcode, size_t len);
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 0ab4936..e1088f2 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -605,6 +605,24 @@ static void do_sync_core(void *info)
 static bool bp_patching_in_progress;
 static void *bp_int3_handler, *bp_int3_addr;
 
+int poke_bp_int3_handler(struct pt_regs *regs)
+{
+	/* bp_patching_in_progress */
+	smp_rmb();
+
+	if (likely(!bp_patching_in_progress))
+		return 0;
+
+	if (user_mode_vm(regs) || regs->ip != (unsigned long)bp_int3_addr)
+		return 0;
+
+	/* set up the specified breakpoint handler */
+	regs->ip = (unsigned long) bp_int3_handler;
+
+	return 1;
+
+}
+
 static int int3_notify(struct notifier_block *self, unsigned long val, void *data)
 {
 	struct die_args *args = data;
@@ -689,6 +707,7 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 	return addr;
 }
 
+#if 0
 /* this one needs to run before anything else handles it as a
  * regular exception */
 static struct notifier_block int3_nb = {
@@ -700,8 +719,9 @@ static int __init int3_init(void)
 {
 	return register_die_notifier(&int3_nb);
 }
-
 arch_initcall(int3_init);
+#endif
+
 /*
  * Cross-modifying kernel text with stop_machine().
  * This code originally comes from immediate value.
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 772e2a8..e464764 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -58,6 +58,7 @@
 #include <asm/mce.h>
 #include <asm/fixmap.h>
 #include <asm/mach_traps.h>
+#include <asm/alternative.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/x86_init.h>
@@ -324,6 +325,9 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
 	    ftrace_int3_handler(regs))
 		return;
 #endif
+	if (poke_bp_int3_handler(regs))
+		return;
+
 	prev_state = exception_enter();
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
 	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,

-- 
Jiri Kosina
SUSE Labs

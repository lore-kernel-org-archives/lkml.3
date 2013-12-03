Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3LCNY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:24:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab3LCNYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:24:23 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v5 7/8] x86: patch all traced function calls using the int3-based framework
Date: Tue,  3 Dec 2013 14:21:26 +0100
Message-Id: <1386076887-2655-8-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386076887-2655-1-git-send-email-pmladek@suse.cz>
References: <1386076887-2655-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's continue with replacing the existing Int3-based framework in ftrace with
the new generic function introduced by the commit fd4363fff3d9 (x86: Introduce
int3 (breakpoint)-based instruction patching)

This time use it in ftrace_replace_code that modifies all the watched function
calls.

If we use text_poke_bp in ftrace_make_nop, ftrace_make_call, ftrace_modify_call,
it would be possible to get rid of the x86-specific ftrace_replace_code
implementation and use the generic code.

This would be really lovely change. Unfortunately, the code would be slow
because syncing on each CPU is relatively expensive operation. For example,
I tried to switch between 7 tracers: blk, branch, function_graph, wakeup_rt,
irqsoff, function, and nop. Every tracer has also been enabled and disabled.
With 500 cycles, I got these times with the original code:

    real    16m14.390s    16m15.200s    16m19.632s
    user    0m0.028s      0m0.024s      0m0.028s
    sys     0m23.788s     0m23.812s     0m23.804s

It slowed down after using text_poke_bp for each record separately:

    real    29m45.785s    29m47.504s    29m44.016
    user    0m0.004s      0m0.004s      0m0.004s
    sys     0m15.776s     0m16.088s     0m16.192s

Hence, we implemented the more complex text_poke_bp_iter. When we use it,
we get the times:

    real    17m19.055s    17m29.200s    17m27.456
    user    0m0.052s      0m0.056s      0m0.052s
    sys     0m20.236s     0m20.068s     0m20.264s

It is slightly slower than the ftrace-specific code. Well, this is the
cost for using a generic API that can be used also in other locations.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 arch/x86/kernel/alternative.c |  14 +-
 arch/x86/kernel/ftrace.c      | 428 +++++++-----------------------------------
 arch/x86/kernel/traps.c       |  10 -
 include/linux/ftrace.h        |   6 -
 4 files changed, 80 insertions(+), 378 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 9f8dd4f9e852..488f06d78cf1 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -616,7 +616,7 @@ int __kprobes text_poke(void *addr, const void *opcode, size_t len)
  * responsible for setting the patched code read-write. This is more effective
  * only when you patch many addresses at the same time.
  */
-static int text_poke_part(void *addr, const void *opcode, size_t len)
+static int notrace text_poke_part(void *addr, const void *opcode, size_t len)
 {
 	int ret;
 
@@ -665,7 +665,7 @@ static void *bp_int3_handler, *bp_int3_addr;
 static size_t bp_int3_len;
 static void *(*bp_int3_is_handled)(const unsigned long ip);
 
-int poke_int3_handler(struct pt_regs *regs)
+int notrace poke_int3_handler(struct pt_regs *regs)
 {
 	/* bp_patching_in_progress */
 	smp_rmb();
@@ -764,7 +764,7 @@ fail:
 	return ret;
 }
 
-static int text_poke_check(void *addr, const void *opcode, size_t len)
+static int notrace text_poke_check(void *addr, const void *opcode, size_t len)
 {
 	unsigned char actual[MAX_PATCH_LEN];
 	int ret;
@@ -780,7 +780,7 @@ static int text_poke_check(void *addr, const void *opcode, size_t len)
 	return 0;
 }
 
-static int add_iter_breakpoint(struct text_poke_bp_iter *iterator,
+static int notrace add_iter_breakpoint(struct text_poke_bp_iter *iterator,
 				       void *iter)
 {
 	void *addr;
@@ -802,7 +802,7 @@ static int add_iter_breakpoint(struct text_poke_bp_iter *iterator,
 	return ret;
 }
 
-static int update_iter_code(struct text_poke_bp_iter *iterator,
+static int notrace update_iter_code(struct text_poke_bp_iter *iterator,
 				   void *iter)
 {
 	void *addr;
@@ -820,7 +820,7 @@ static int update_iter_code(struct text_poke_bp_iter *iterator,
 			      bp_int3_len - sizeof(bp_int3));
 }
 
-static int finish_iter_update(struct text_poke_bp_iter *iterator,
+static int notrace finish_iter_update(struct text_poke_bp_iter *iterator,
 				      void *iter)
 {
 	void *addr;
@@ -841,7 +841,7 @@ static int finish_iter_update(struct text_poke_bp_iter *iterator,
 	return ret;
 }
 
-static void recover_iter(struct text_poke_bp_iter *iterator,
+static void notrace recover_iter(struct text_poke_bp_iter *iterator,
 				void *iter)
 {
 	void *addr;
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 5ade40e4a175..92fe8cac0802 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -127,23 +127,6 @@ static const unsigned char *ftrace_nop_replace(void)
 }
 
 static int
-ftrace_modify_code_direct(unsigned long ip, unsigned const char *old_code,
-		   unsigned const char *new_code)
-{
-	int ret;
-
-	ret = ftrace_check_code(ip, old_code);
-
-	/* replace the text with the new text */
-	if (!ret && do_ftrace_mod_code(ip, new_code))
-		return -EPERM;
-
-	sync_core();
-
-	return 0;
-}
-
-static int
 ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
 		   unsigned const char *new_code)
 {
@@ -168,20 +151,7 @@ int ftrace_make_nop(struct module *mod,
 	old = ftrace_call_replace(ip, addr);
 	new = ftrace_nop_replace();
 
-	/*
-	 * On boot up, and when modules are loaded, the MCOUNT_ADDR
-	 * is converted to a nop, and will never become MCOUNT_ADDR
-	 * again. This code is either running before SMP (on boot up)
-	 * or before the code will ever be executed (module load).
-	 * We do not want to use the breakpoint version in this case,
-	 * just modify the code directly.
-	 */
-	if (addr == MCOUNT_ADDR)
-		return ftrace_modify_code_direct(rec->ip, old, new);
-
-	/* Normal cases use add_brk_on_nop */
-	WARN_ONCE(1, "invalid use of ftrace_make_nop");
-	return -EINVAL;
+	return ftrace_modify_code(ip, old, new);
 }
 
 int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
@@ -192,44 +162,10 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	old = ftrace_nop_replace();
 	new = ftrace_call_replace(ip, addr);
 
-	/* Should only be called when module is loaded */
-	return ftrace_modify_code_direct(rec->ip, old, new);
+	return ftrace_modify_code(ip, old, new);
 }
 
 /*
- * The modifying_ftrace_code is used to tell the breakpoint
- * handler to call ftrace_int3_handler(). If it fails to
- * call this handler for a breakpoint added by ftrace, then
- * the kernel may crash.
- *
- * As atomic_writes on x86 do not need a barrier, we do not
- * need to add smp_mb()s for this to work. It is also considered
- * that we can not read the modifying_ftrace_code before
- * executing the breakpoint. That would be quite remarkable if
- * it could do that. Here's the flow that is required:
- *
- *   CPU-0                          CPU-1
- *
- * atomic_inc(mfc);
- * write int3s
- *				<trap-int3> // implicit (r)mb
- *				if (atomic_read(mfc))
- *					call ftrace_int3_handler()
- *
- * Then when we are finished:
- *
- * atomic_dec(mfc);
- *
- * If we hit a breakpoint that was not set by ftrace, it does not
- * matter if ftrace_int3_handler() is called or not. It will
- * simply be ignored. But it is crucial that a ftrace nop/caller
- * breakpoint is handled. No other user should ever place a
- * breakpoint on an ftrace nop/caller location. It must only
- * be done by this code.
- */
-atomic_t modifying_ftrace_code __read_mostly;
-
-/*
  * Should never be called:
  *  As it is only called by __ftrace_replace_code() which is called by
  *  ftrace_replace_code() that x86 overrides, and by ftrace_update_code()
@@ -267,80 +203,6 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 }
 
 /*
- * A breakpoint was added to the code address we are about to
- * modify, and this is the handle that will just skip over it.
- * We are either changing a nop into a trace call, or a trace
- * call to a nop. While the change is taking place, we treat
- * it just like it was a nop.
- */
-int ftrace_int3_handler(struct pt_regs *regs)
-{
-	if (WARN_ON_ONCE(!regs))
-		return 0;
-
-	if (!ftrace_location(regs->ip - 1))
-		return 0;
-
-	regs->ip += MCOUNT_INSN_SIZE - 1;
-
-	return 1;
-}
-
-static int ftrace_write(unsigned long ip, const char *val, int size)
-{
-	/*
-	 * On x86_64, kernel text mappings are mapped read-only with
-	 * CONFIG_DEBUG_RODATA. So we use the kernel identity mapping instead
-	 * of the kernel text mapping to modify the kernel text.
-	 *
-	 * For 32bit kernels, these mappings are same and we can use
-	 * kernel identity mapping to modify code.
-	 */
-	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
-		ip = (unsigned long)__va(__pa_symbol(ip));
-
-	return probe_kernel_write((void *)ip, val, size);
-}
-
-static int add_break(unsigned long ip, const char *old)
-{
-	unsigned char replaced[MCOUNT_INSN_SIZE];
-	unsigned char brk = BREAKPOINT_INSTRUCTION;
-
-	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
-		return -EFAULT;
-
-	/* Make sure it is what we expect it to be */
-	if (memcmp(replaced, old, MCOUNT_INSN_SIZE) != 0)
-		return -EINVAL;
-
-	if (ftrace_write(ip, &brk, 1))
-		return -EPERM;
-
-	return 0;
-}
-
-static int add_brk_on_call(struct dyn_ftrace *rec, unsigned long addr)
-{
-	unsigned const char *old;
-	unsigned long ip = rec->ip;
-
-	old = ftrace_call_replace(ip, addr);
-
-	return add_break(rec->ip, old);
-}
-
-
-static int add_brk_on_nop(struct dyn_ftrace *rec)
-{
-	unsigned const char *old;
-
-	old = ftrace_nop_replace();
-
-	return add_break(rec->ip, old);
-}
-
-/*
  * If the record has the FTRACE_FL_REGS set, that means that it
  * wants to convert to a callback that saves all regs. If FTRACE_FL_REGS
  * is not not set, then it wants to convert to the normal callback.
@@ -366,275 +228,131 @@ static unsigned long get_ftrace_old_addr(struct dyn_ftrace *rec)
 		return (unsigned long)FTRACE_ADDR;
 }
 
-static int add_breakpoints(struct dyn_ftrace *rec, int enable)
-{
-	unsigned long ftrace_addr;
-	int ret;
-
-	ret = ftrace_test_record(rec, enable);
-
-	ftrace_addr = get_ftrace_addr(rec);
-
-	switch (ret) {
-	case FTRACE_UPDATE_IGNORE:
-		return 0;
-
-	case FTRACE_UPDATE_MAKE_CALL:
-		/* converting nop to call */
-		return add_brk_on_nop(rec);
-
-	case FTRACE_UPDATE_MODIFY_CALL_REGS:
-	case FTRACE_UPDATE_MODIFY_CALL:
-		ftrace_addr = get_ftrace_old_addr(rec);
-		/* fall through */
-	case FTRACE_UPDATE_MAKE_NOP:
-		/* converting a call to a nop */
-		return add_brk_on_call(rec, ftrace_addr);
-	}
-	return 0;
-}
+struct ftrace_tp_iter {
+	struct ftrace_rec_iter *rec_iter;
+	struct dyn_ftrace *rec;
+	int enable;
+};
 
-/*
- * On error, we need to remove breakpoints. This needs to
- * be done caefully. If the address does not currently have a
- * breakpoint, we know we are done. Otherwise, we look at the
- * remaining 4 bytes of the instruction. If it matches a nop
- * we replace the breakpoint with the nop. Otherwise we replace
- * it with the call instruction.
- */
-static int remove_breakpoint(struct dyn_ftrace *rec)
+static struct ftrace_tp_iter *ftrace_tp_set_record(struct ftrace_tp_iter *tp_iter)
 {
-	unsigned char ins[MCOUNT_INSN_SIZE];
-	unsigned char brk = BREAKPOINT_INSTRUCTION;
-	const unsigned char *nop;
-	unsigned long ftrace_addr;
-	unsigned long ip = rec->ip;
-
-	/* If we fail the read, just give up */
-	if (probe_kernel_read(ins, (void *)ip, MCOUNT_INSN_SIZE))
-		return -EFAULT;
+	if (!tp_iter->rec_iter)
+		return NULL;
 
-	/* If this does not have a breakpoint, we are done */
-	if (ins[0] != brk)
-		return -1;
-
-	nop = ftrace_nop_replace();
-
-	/*
-	 * If the last 4 bytes of the instruction do not match
-	 * a nop, then we assume that this is a call to ftrace_addr.
-	 */
-	if (memcmp(&ins[1], &nop[1], MCOUNT_INSN_SIZE - 1) != 0) {
-		/*
-		 * For extra paranoidism, we check if the breakpoint is on
-		 * a call that would actually jump to the ftrace_addr.
-		 * If not, don't touch the breakpoint, we make just create
-		 * a disaster.
-		 */
-		ftrace_addr = get_ftrace_addr(rec);
-		nop = ftrace_call_replace(ip, ftrace_addr);
-
-		if (memcmp(&ins[1], &nop[1], MCOUNT_INSN_SIZE - 1) == 0)
-			goto update;
-
-		/* Check both ftrace_addr and ftrace_old_addr */
-		ftrace_addr = get_ftrace_old_addr(rec);
-		nop = ftrace_call_replace(ip, ftrace_addr);
-
-		if (memcmp(&ins[1], &nop[1], MCOUNT_INSN_SIZE - 1) != 0)
-			return -EINVAL;
-	}
-
- update:
-	return probe_kernel_write((void *)ip, &nop[0], 1);
+	tp_iter->rec = ftrace_rec_iter_record(tp_iter->rec_iter);
+	return tp_iter;
 }
 
-static int add_update_code(unsigned long ip, unsigned const char *new)
+void *ftrace_tp_iter_start(void *init)
 {
-	/* skip breakpoint */
-	ip++;
-	new++;
-	if (ftrace_write(ip, new, MCOUNT_INSN_SIZE - 1))
-		return -EPERM;
-	return 0;
+	struct ftrace_tp_iter *tp_iter = init;
+
+	tp_iter->rec_iter = ftrace_rec_iter_start();
+	return ftrace_tp_set_record(tp_iter);
 }
 
-static int add_update_call(struct dyn_ftrace *rec, unsigned long addr)
+void *ftrace_tp_iter_next(void *cur)
 {
-	unsigned long ip = rec->ip;
-	unsigned const char *new;
+	struct ftrace_tp_iter *tp_iter = cur;
 
-	new = ftrace_call_replace(ip, addr);
-	return add_update_code(ip, new);
+	tp_iter->rec_iter = ftrace_rec_iter_next(tp_iter->rec_iter);
+	return ftrace_tp_set_record(tp_iter);
 }
 
-static int add_update_nop(struct dyn_ftrace *rec)
+void *ftrace_tp_iter_get_addr(void *cur)
 {
-	unsigned long ip = rec->ip;
-	unsigned const char *new;
+	struct ftrace_tp_iter *tp_iter = cur;
 
-	new = ftrace_nop_replace();
-	return add_update_code(ip, new);
+	return (void *)(tp_iter->rec->ip);
 }
 
-static int add_update(struct dyn_ftrace *rec, int enable)
+const void *ftrace_tp_iter_get_opcode(void *cur)
 {
-	unsigned long ftrace_addr;
+	struct ftrace_tp_iter *tp_iter = cur;
+	unsigned long addr;
 	int ret;
 
-	ret = ftrace_test_record(rec, enable);
-
-	ftrace_addr  = get_ftrace_addr(rec);
+	ret = ftrace_test_record(tp_iter->rec, tp_iter->enable);
 
 	switch (ret) {
-	case FTRACE_UPDATE_IGNORE:
-		return 0;
+	case FTRACE_UPDATE_MAKE_NOP:
+		return ftrace_nop_replace();
 
-	case FTRACE_UPDATE_MODIFY_CALL_REGS:
-	case FTRACE_UPDATE_MODIFY_CALL:
 	case FTRACE_UPDATE_MAKE_CALL:
-		/* converting nop to call */
-		return add_update_call(rec, ftrace_addr);
+	case FTRACE_UPDATE_MODIFY_CALL:
+	case FTRACE_UPDATE_MODIFY_CALL_REGS:
+		addr = get_ftrace_addr(tp_iter->rec);
+		return ftrace_call_replace(tp_iter->rec->ip, addr);
 
-	case FTRACE_UPDATE_MAKE_NOP:
-		/* converting a call to a nop */
-		return add_update_nop(rec);
+	case FTRACE_UPDATE_IGNORE:
+	default:			/* unknown ftrace bug */
+		return NULL;
 	}
-
-	return 0;
-}
-
-static int finish_update_call(struct dyn_ftrace *rec, unsigned long addr)
-{
-	unsigned long ip = rec->ip;
-	unsigned const char *new;
-
-	new = ftrace_call_replace(ip, addr);
-
-	if (ftrace_write(ip, new, 1))
-		return -EPERM;
-
-	return 0;
-}
-
-static int finish_update_nop(struct dyn_ftrace *rec)
-{
-	unsigned long ip = rec->ip;
-	unsigned const char *new;
-
-	new = ftrace_nop_replace();
-
-	if (ftrace_write(ip, new, 1))
-		return -EPERM;
-	return 0;
 }
 
-static int finish_update(struct dyn_ftrace *rec, int enable)
+const void *ftrace_tp_iter_get_old_opcode(void *cur)
 {
-	unsigned long ftrace_addr;
+	struct ftrace_tp_iter *tp_iter = cur;
+	unsigned long old_addr;
 	int ret;
 
-	ret = ftrace_update_record(rec, enable);
-
-	ftrace_addr = get_ftrace_addr(rec);
+	ret = ftrace_test_record(tp_iter->rec, tp_iter->enable);
 
 	switch (ret) {
-	case FTRACE_UPDATE_IGNORE:
-		return 0;
-
-	case FTRACE_UPDATE_MODIFY_CALL_REGS:
-	case FTRACE_UPDATE_MODIFY_CALL:
 	case FTRACE_UPDATE_MAKE_CALL:
-		/* converting nop to call */
-		return finish_update_call(rec, ftrace_addr);
+		return ftrace_nop_replace();
 
 	case FTRACE_UPDATE_MAKE_NOP:
-		/* converting a call to a nop */
-		return finish_update_nop(rec);
-	}
+	case FTRACE_UPDATE_MODIFY_CALL:
+	case FTRACE_UPDATE_MODIFY_CALL_REGS:
+		old_addr = get_ftrace_old_addr(tp_iter->rec);
+		return ftrace_call_replace(tp_iter->rec->ip, old_addr);
 
-	return 0;
+	case FTRACE_UPDATE_IGNORE:
+	default:			/* unknown ftrace bug */
+		return NULL;
+	}
 }
 
-static void do_sync_core(void *data)
+int ftrace_tp_iter_finish(void *cur)
 {
-	sync_core();
-}
+	struct ftrace_tp_iter *tp_iter = cur;
 
-static void run_sync(void)
-{
-	int enable_irqs = irqs_disabled();
-
-	/* We may be called with interrupts disbled (on bootup). */
-	if (enable_irqs)
-		local_irq_enable();
-	on_each_cpu(do_sync_core, NULL, 1);
-	if (enable_irqs)
-		local_irq_disable();
+	ftrace_update_record(tp_iter->rec, tp_iter->enable);
+	return 0;
 }
 
 void ftrace_replace_code(int enable)
 {
-	struct ftrace_rec_iter *iter;
-	struct dyn_ftrace *rec;
-	const char *report = "adding breakpoints";
-	int count = 0;
+	struct text_poke_bp_iter tp_bp_iter;
+	struct ftrace_tp_iter tp_iter;
 	int ret;
 
-	for_ftrace_rec_iter(iter) {
-		rec = ftrace_rec_iter_record(iter);
-
-		ret = add_breakpoints(rec, enable);
-		if (ret)
-			goto remove_breakpoints;
-		count++;
-	}
-
-	run_sync();
-
-	report = "updating code";
-
-	for_ftrace_rec_iter(iter) {
-		rec = ftrace_rec_iter_record(iter);
-
-		ret = add_update(rec, enable);
-		if (ret)
-			goto remove_breakpoints;
-	}
+	tp_iter.enable = enable;
 
-	run_sync();
+	tp_bp_iter.init = (void *)&tp_iter;
+	tp_bp_iter.len = MCOUNT_INSN_SIZE;
+	tp_bp_iter.start = ftrace_tp_iter_start;
+	tp_bp_iter.next = ftrace_tp_iter_next;
+	tp_bp_iter.get_addr = ftrace_tp_iter_get_addr;
+	tp_bp_iter.get_opcode = ftrace_tp_iter_get_opcode;
+	tp_bp_iter.get_old_opcode = ftrace_tp_iter_get_old_opcode;
+	tp_bp_iter.finish = ftrace_tp_iter_finish;
+	tp_bp_iter.is_handled = (void *(*)(const unsigned long))ftrace_location;
 
-	report = "removing breakpoints";
+	ret = text_poke_bp_list(&tp_bp_iter);
 
-	for_ftrace_rec_iter(iter) {
-		rec = ftrace_rec_iter_record(iter);
-
-		ret = finish_update(rec, enable);
-		if (ret)
-			goto remove_breakpoints;
-	}
-
-	run_sync();
-
-	return;
-
- remove_breakpoints:
-	ftrace_bug(ret, rec ? rec->ip : 0);
-	printk(KERN_WARNING "Failed on %s (%d):\n", report, count);
-	for_ftrace_rec_iter(iter) {
-		rec = ftrace_rec_iter_record(iter);
-		remove_breakpoint(rec);
-	}
+	if (ret)
+		ftrace_bug(ret, (unsigned long)(tp_bp_iter.fail_addr));
 }
 
+/*
+ * The code is modified using Int3 guard,
+ * so we do not need to call the stop machine
+ */
 void arch_ftrace_update_code(int command)
 {
-	/* See comment above by declaration of modifying_ftrace_code */
-	atomic_inc(&modifying_ftrace_code);
-
 	ftrace_modify_all_code(command);
-
-	atomic_dec(&modifying_ftrace_code);
 }
 
 int __init ftrace_dyn_arch_init(void *data)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b857ed890b4c..69ad8cf8b7f0 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -50,7 +50,6 @@
 #include <asm/processor.h>
 #include <asm/debugreg.h>
 #include <linux/atomic.h>
-#include <asm/ftrace.h>
 #include <asm/traps.h>
 #include <asm/desc.h>
 #include <asm/i387.h>
@@ -319,15 +318,6 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
 {
 	enum ctx_state prev_state;
 
-#ifdef CONFIG_DYNAMIC_FTRACE
-	/*
-	 * ftrace must be first, everything else may cause a recursive crash.
-	 * See note by declaration of modifying_ftrace_code in ftrace.c
-	 */
-	if (unlikely(atomic_read(&modifying_ftrace_code)) &&
-	    ftrace_int3_handler(regs))
-		return;
-#endif
 	if (poke_int3_handler(regs))
 		return;
 
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 31ea4b428360..fe50347cf18e 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -383,12 +383,6 @@ struct ftrace_rec_iter *ftrace_rec_iter_start(void);
 struct ftrace_rec_iter *ftrace_rec_iter_next(struct ftrace_rec_iter *iter);
 struct dyn_ftrace *ftrace_rec_iter_record(struct ftrace_rec_iter *iter);
 
-#define for_ftrace_rec_iter(iter)		\
-	for (iter = ftrace_rec_iter_start();	\
-	     iter;				\
-	     iter = ftrace_rec_iter_next(iter))
-
-
 int ftrace_update_record(struct dyn_ftrace *rec, int enable);
 int ftrace_test_record(struct dyn_ftrace *rec, int enable);
 void ftrace_run_stop_machine(int command);
-- 
1.8.4


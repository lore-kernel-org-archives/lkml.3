Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab3JRO1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:27:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab3JRO1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:27:31 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 5/6] x86: patch all traced function calls using the int3-based framework
Date: Fri, 18 Oct 2013 16:27:24 +0200
Message-Id: <1382106445-31468-6-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's continue with replacing the existing Int3-based framewok in ftrace with
the new generic function introduced by the commit fd4363fff3d9 (x86: Introduce
int3 (breakpoint)-based instruction patching)

This time use it in ftrace_replace_code that modifies all the watched function
calls.

If we use text_poke_bp in ftrace_make_nop, ftrace_make_call, ftrace_modify_call,
it would be possible to get rid of the x86-specific ftrace_replace_code
implementation and use the generic code.

This would be really lovely change. Unfortunately, the code would be slow
because syncing on each CPU is relatively expensive operation. For example,
I tried to modify the ftrace function, enable, and disable the tracer
in a cycle. With 9 different trace functions and 500 cycles,
I got these times:

	original code:                  text_poke_bp for single address:

	real    19m51.667s		real    33m29.456s
	user    0m0.004s		user    0m0.008s
	sys     0m27.124s		sys     0m27.620s

Hence, we still need the custom ftrace_replace_code and fill the buffers
for text_poke_bp. Anyway, it still allows to remove lots of custom code.

It is even slightly faster. With the test metnioned above, I got:

	original code:                  text_poke_bp for batched addresses:
					(this patch)

	real    20m8.123s		real    18m47.042s
	user    0m0.004s		user    0m0.008s
	sys     0m28.400s		sys     0m42.760s

	real    19m59.777s		real    18m41.668s
	user    0m0.004s		user    0m0.000s
	sys     0m28.344s		sys     0m43.576s

	real    19m57.598s		real    18m38.203s
	user    0m0.004s		user    0m0.004s
	sys     0m28.728s		sys     0m43.104s

It faster because it checks the modified code only once. It removes usage of
the relatively complex "ftrace_test_record". Also it reduces iterations
over the list of records. All this should be safe because other manipulations
with the list are quarded by "ftrace_lock". This cover also adding and removing
modules.

In addition, the int3 handler is faster as well. It could use bsearch on
all patched addresses. While ftrace_location uses bsearch only for functions
from core or the same module.

Another win might be that we modify the calls in batches while keeping the CPU
syncing on low level. The result should be reduced usage of the relatively slow
int3 handler. It might especially help on busy systems where the performance
is more important. By other words, saving several int3 handler calls should
be worth the few extra sync calls. Well, this is just speculation because
I do not have real numbers here. They are not easy to get as they depend on
the type of system load.

Note that we need to add notrace for all functions that are called by
text_poke_bp and poke_int3_handler. Otherwise, we get either infinite loop
or too many operations going through the relatively slow handler.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 arch/x86/kernel/alternative.c |   6 +-
 arch/x86/kernel/ftrace.c      | 461 +++++++++---------------------------------
 arch/x86/kernel/traps.c       |  10 -
 lib/bsearch.c                 |   2 +-
 4 files changed, 97 insertions(+), 382 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 0eb8250..45d7922 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -603,7 +603,7 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
  *
  * Note: Must be called under text_mutex.
  */
-static void *text_poke_part(void *addr, const void *opcode, size_t len)
+static void *notrace text_poke_part(void *addr, const void *opcode, size_t len)
 {
 	/*
 	 * On x86_64, kernel text mappings are mapped read-only with
@@ -649,7 +649,7 @@ static void **bp_int3_handler, **bp_int3_addr;
 static size_t bp_int3_len;		/* length of the modified instruction */
 static unsigned int bp_int3_count;	/* number of modified instructions */
 
-static int poke_int3_cmp(const void *a, const void *b)
+static int notrace poke_int3_cmp(const void *a, const void *b)
 {
 	unsigned long key = (unsigned long)a;
 	unsigned long addr = *(unsigned long *)b;
@@ -657,7 +657,7 @@ static int poke_int3_cmp(const void *a, const void *b)
 	return key - addr;
 }
 
-int poke_int3_handler(struct pt_regs *regs)
+int notrace poke_int3_handler(struct pt_regs *regs)
 {
 	void *found;
 	unsigned long index;
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index f96dbcc..f3c5f3a 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -17,6 +17,7 @@
 #include <linux/ftrace.h>
 #include <linux/percpu.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -127,23 +128,6 @@ static const unsigned char *ftrace_nop_replace(void)
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
@@ -167,20 +151,7 @@ int ftrace_make_nop(struct module *mod,
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
@@ -191,44 +162,10 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
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
@@ -266,80 +203,6 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
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
@@ -365,275 +228,137 @@ static unsigned long get_ftrace_old_addr(struct dyn_ftrace *rec)
 		return (unsigned long)FTRACE_ADDR;
 }
 
-static int add_breakpoints(struct dyn_ftrace *rec, int enable)
+static const unsigned char *ftrace_new_code(struct dyn_ftrace *rec, int enable)
 {
-	unsigned long ftrace_addr;
+	unsigned long old_addr, addr, ip;
+	const unsigned char *old, *new;
 	int ret;
 
-	ret = ftrace_test_record(rec, enable);
+	/* get old address before we update the record */
+	old_addr = get_ftrace_old_addr(rec);
+	ip = rec->ip;
 
-	ftrace_addr = get_ftrace_addr(rec);
+	ret = ftrace_update_record(rec, enable);
 
 	switch (ret) {
-	case FTRACE_UPDATE_IGNORE:
-		return 0;
+	case FTRACE_UPDATE_MAKE_NOP:
+		old = ftrace_call_replace(ip, old_addr);
+		new = ftrace_nop_replace();
+		break;
 
 	case FTRACE_UPDATE_MAKE_CALL:
-		/* converting nop to call */
-		return add_brk_on_nop(rec);
+		old = ftrace_nop_replace();
+		addr = get_ftrace_addr(rec);
+		new = ftrace_call_replace(ip, addr);
+		break;
 
 	case FTRACE_UPDATE_MODIFY_CALL_REGS:
 	case FTRACE_UPDATE_MODIFY_CALL:
-		ftrace_addr = get_ftrace_old_addr(rec);
-		/* fall through */
-	case FTRACE_UPDATE_MAKE_NOP:
-		/* converting a call to a nop */
-		return add_brk_on_call(rec, ftrace_addr);
-	}
-	return 0;
-}
-
-/*
- * On error, we need to remove breakpoints. This needs to
- * be done caefully. If the address does not currently have a
- * breakpoint, we know we are done. Otherwise, we look at the
- * remaining 4 bytes of the instruction. If it matches a nop
- * we replace the breakpoint with the nop. Otherwise we replace
- * it with the call instruction.
- */
-static int remove_breakpoint(struct dyn_ftrace *rec)
-{
-	unsigned char ins[MCOUNT_INSN_SIZE];
-	unsigned char brk = BREAKPOINT_INSTRUCTION;
-	const unsigned char *nop;
-	unsigned long ftrace_addr;
-	unsigned long ip = rec->ip;
-
-	/* If we fail the read, just give up */
-	if (probe_kernel_read(ins, (void *)ip, MCOUNT_INSN_SIZE))
-		return -EFAULT;
-
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
-}
-
-static int add_update_code(unsigned long ip, unsigned const char *new)
-{
-	/* skip breakpoint */
-	ip++;
-	new++;
-	if (ftrace_write(ip, new, MCOUNT_INSN_SIZE - 1))
-		return -EPERM;
-	return 0;
-}
-
-static int add_update_call(struct dyn_ftrace *rec, unsigned long addr)
-{
-	unsigned long ip = rec->ip;
-	unsigned const char *new;
-
-	new = ftrace_call_replace(ip, addr);
-	return add_update_code(ip, new);
-}
+		old = ftrace_call_replace(ip, old_addr);
+		addr = get_ftrace_addr(rec);
+		new = ftrace_call_replace(ip, addr);
+		break;
 
-static int add_update_nop(struct dyn_ftrace *rec)
-{
-	unsigned long ip = rec->ip;
-	unsigned const char *new;
-
-	new = ftrace_nop_replace();
-	return add_update_code(ip, new);
-}
-
-static int add_update(struct dyn_ftrace *rec, int enable)
-{
-	unsigned long ftrace_addr;
-	int ret;
-
-	ret = ftrace_test_record(rec, enable);
-
-	ftrace_addr  = get_ftrace_addr(rec);
-
-	switch (ret) {
 	case FTRACE_UPDATE_IGNORE:
-		return 0;
-
-	case FTRACE_UPDATE_MODIFY_CALL_REGS:
-	case FTRACE_UPDATE_MODIFY_CALL:
-	case FTRACE_UPDATE_MAKE_CALL:
-		/* converting nop to call */
-		return add_update_call(rec, ftrace_addr);
-
-	case FTRACE_UPDATE_MAKE_NOP:
-		/* converting a call to a nop */
-		return add_update_nop(rec);
+	default:			/* unknow ftrace bug */
+		return NULL;
 	}
 
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
+	if (ftrace_check_code(ip, old))
+		/* error reported by ftrace_check_code; ignore new code here */
+		return NULL;
 
-	return 0;
+	return new;
 }
 
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
-}
+/*
+ * We do not want to replace ftrace calls one by one because syncing all CPUs
+ * is quite expensive.
+ *
+ * On the other hand, we do not want to modify all calls at once because
+ * the buffers for text_poke_bp might be quite huge. Also we do not want
+ * to count the number of records before the allocation.
+ *
+ * Let's modify the call in batches defined by this define.
+ */
+#define FTRACE_MAX_RECS_PATCH 8192
 
-static int finish_update(struct dyn_ftrace *rec, int enable)
+static int ftrace_allocate_replace_buffers(unsigned long **addr, void **opcode)
 {
-	unsigned long ftrace_addr;
-	int ret;
-
-	ret = ftrace_update_record(rec, enable);
-
-	ftrace_addr = get_ftrace_addr(rec);
-
-	switch (ret) {
-	case FTRACE_UPDATE_IGNORE:
-		return 0;
-
-	case FTRACE_UPDATE_MODIFY_CALL_REGS:
-	case FTRACE_UPDATE_MODIFY_CALL:
-	case FTRACE_UPDATE_MAKE_CALL:
-		/* converting nop to call */
-		return finish_update_call(rec, ftrace_addr);
+	*addr = kmalloc_array(FTRACE_MAX_RECS_PATCH,
+			      sizeof(*addr), GFP_KERNEL);
+	if (!addr) {
+		printk(KERN_ERR
+		       "ftrace_replace_code: cannot allocate addr buffer\n");
+		return -ENOMEM;
+	}
 
-	case FTRACE_UPDATE_MAKE_NOP:
-		/* converting a call to a nop */
-		return finish_update_nop(rec);
+	*opcode = kmalloc_array(FTRACE_MAX_RECS_PATCH,
+				MCOUNT_INSN_SIZE, GFP_KERNEL);
+	if (!opcode) {
+		printk(KERN_ERR
+		       "ftrace_replace_code: cannot allocate codes buffer\n");
+		return -ENOMEM;
 	}
 
 	return 0;
 }
 
-static void do_sync_core(void *data)
-{
-	sync_core();
-}
-
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
-}
-
 void ftrace_replace_code(int enable)
 {
 	struct ftrace_rec_iter *iter;
 	struct dyn_ftrace *rec;
-	const char *report = "adding breakpoints";
-	int count = 0;
-	int ret;
+	unsigned long *addr = NULL;
+	void *opcode = NULL, *op = NULL;
+	const unsigned char *new;
+	size_t count = 0;
 
 	for_ftrace_rec_iter(iter) {
 		rec = ftrace_rec_iter_record(iter);
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
+		new = ftrace_new_code(rec, enable);
+
+		/* check next record if there is no new code for this one */
+		if (!new)
+			continue;
+
+		/* allocate buffers only when there will be a change */
+		if (unlikely(!addr)) {
+			if (ftrace_allocate_replace_buffers(&addr, &opcode))
+				goto out;
+			op = opcode;
+			count = 0;
+		}
+
+		/* fill buffers */
+		addr[count++] = rec->ip;
+		memcpy(op, new, MCOUNT_INSN_SIZE);
+		op += MCOUNT_INSN_SIZE;
+
+		/* write buffers if they are full */
+		if (count == FTRACE_MAX_RECS_PATCH) {
+			text_poke_bp((void **)addr, opcode,
+				     MCOUNT_INSN_SIZE, count, NULL);
+			op = opcode;
+			count = 0;
+		}
 	}
 
-	run_sync();
-
-	report = "removing breakpoints";
-
-	for_ftrace_rec_iter(iter) {
-		rec = ftrace_rec_iter_record(iter);
+	if (count)
+		text_poke_bp((void **)addr, opcode,
+			     MCOUNT_INSN_SIZE, count, NULL);
 
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
+out:
+	kfree(addr);
+	kfree(opcode);
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
index 729aa77..16bf450 100644
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
 
diff --git a/lib/bsearch.c b/lib/bsearch.c
index e33c179..edb383c 100644
--- a/lib/bsearch.c
+++ b/lib/bsearch.c
@@ -30,7 +30,7 @@
  * the key and elements in the array are of the same type, you can use
  * the same comparison function for both sort() and bsearch().
  */
-void *bsearch(const void *key, const void *base, size_t num, size_t size,
+void *notrace bsearch(const void *key, const void *base, size_t num, size_t size,
 	      int (*cmp)(const void *key, const void *elt))
 {
 	size_t start = 0, end = num;
-- 
1.8.4


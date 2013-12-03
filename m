Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab3LCNXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:23:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33112 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab3LCNXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:23:01 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v5 3/8] x86: add generic function to modify more calls using int3 framework
Date: Tue,  3 Dec 2013 14:21:22 +0100
Message-Id: <1386076887-2655-4-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386076887-2655-1-git-send-email-pmladek@suse.cz>
References: <1386076887-2655-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit fd4363fff3d9 (x86: Introduce int3 (breakpoint)-based instruction
patching) uses the same technique that has been used in ftrace since 08d636b
("ftrace/x86: Have arch x86_64 use breakpoints instead of stop machine")

When trying to use text_poke_bp in dynamic ftrace, the process was significantly
slower than the original code. For example, I tried to switch between 7 tracers:
blk, branch, function_graph, wakeup_rt, irqsoff, function, and nop. Every tracer
has also been enabled and disabled. With 500 cycles, I got these times with the
original code:

    real    16m14.390s    16m15.200s    16m19.632s
    user    0m0.028s      0m0.024s	0m0.028s
    sys     0m23.788s     0m23.812s	0m23.804s

and with text_poke_bp:

    real    29m45.785s    29m47.504s    29m44.016
    user    0m0.004s      0m0.004s	0m0.004s
    sys     0m15.776s     0m16.088s     0m16.192s

It turned out that most of the extra time was spent in the call:

   on_each_cpu(do_sync_core, NULL, 1)

It is needed to reset the speculative queue of decoded instructions on each CPU.
It is relatively expensive operation. The original code reduced the usage by
patching all instructions in parallel.

This commits adds text_poke_bp_iter that provides generic interface for patching
more instructions in parallel. It is basically a mix of text_poke_bp and
ftrace_replace_code. The list of addresses and opcodes is passed via
an iterator and callbacks.

We need to iterate several times but we do not need both opcodes and the address
in all stages. They are passed via callback to avoid an unnecessary computation.

The function checks the current code before patching. It might be possible to
leave this check in the ftrace code but such paranoia is useful in general.
It helps to keep the system consistent. And the old opcode is needed anyway.
When something goes wrong, it is used to get back to a valid state. Note
that an error might happen even when adding interrupt to a particular address.

The optional "finish" callback can be used to update state of the patched entry.
For example, it is needed to update the related ftrace record.

Some opcodes might already be in the final state and do not need patching.
It would be possible to detect this by comparing the old and new opcode but
there might be more a effective way. For example, ftrace could tell this by
ftrace_test_record. We pass this information via the get_opcode callbacks.
They return a valid opcode when a change is needed and NULL otherwise. Note
that we should call the "finish" callback even then the code is not really
modified.

Finally, ftrace wants to know more information about a potential failure.
The error code is passed via the return value. The failing address and
the number of the failed record is passed via the iterator structure.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 arch/x86/include/asm/alternative.h |  36 ++++++
 arch/x86/kernel/alternative.c      | 256 +++++++++++++++++++++++++++++++++++--
 2 files changed, 279 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index a23a860a208d..400b0059570a 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -229,4 +229,40 @@ extern int poke_int3_handler(struct pt_regs *regs);
 extern int text_poke_bp(void *addr, const void *opcode, size_t len,
 			void *handler);
 
+struct text_poke_bp_iter {
+	/* information used to start iteration from the beginning */
+	void *init;
+	/* length of the patched instruction */
+	size_t len;
+	/* details about failure if any */
+	int fail_count;
+	void *fail_addr;
+	/* iteration over entries */
+	void *(*start)(void *init);
+	void *(*next)(void *prev);
+	/* callback to get patched address */
+	void *(*get_addr)(void *cur);
+	/*
+	 * Callbacks to get the patched code. They could return NULL if no
+	 * patching is needed; This is useful for example in ftrace.
+	 */
+	const void *(*get_opcode)(void *cur);
+	const void *(*get_old_opcode)(void *cur);
+	/*
+	 * Optional function that is called when the patching of the given
+	 * has finished. It might be NULL if no postprocess is needed.
+	 */
+	int (*finish)(void *cur);
+	/*
+	 * Helper function for int3 handler. It decides whether the given IP
+	 * is being patched or not.
+	 *
+	 * Try to implement it as fast as possible. It affects performance
+	 * of the system when the patching is in progress.
+	 */
+	void *(*is_handled)(const unsigned long ip);
+};
+
+extern int text_poke_bp_list(struct text_poke_bp_iter *iter);
+
 #endif /* _ASM_X86_ALTERNATIVE_H */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 2e47107b9055..2f6088282724 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -7,6 +7,7 @@
 #include <linux/stringify.h>
 #include <linux/kprobes.h>
 #include <linux/mm.h>
+#include <linux/uaccess.h>
 #include <linux/vmalloc.h>
 #include <linux/memory.h>
 #include <linux/stop_machine.h>
@@ -613,8 +614,11 @@ static void run_sync(void)
 		on_each_cpu(do_sync_core, NULL, 1);
 }
 
+static char bp_int3;
 static bool bp_patching_in_progress;
 static void *bp_int3_handler, *bp_int3_addr;
+static size_t bp_int3_len;
+static void *(*bp_int3_is_handled)(const unsigned long ip);
 
 int poke_int3_handler(struct pt_regs *regs)
 {
@@ -624,14 +628,23 @@ int poke_int3_handler(struct pt_regs *regs)
 	if (likely(!bp_patching_in_progress))
 		return 0;
 
-	if (user_mode_vm(regs) || regs->ip != (unsigned long)bp_int3_addr)
+	if (user_mode_vm(regs))
 		return 0;
 
-	/* set up the specified breakpoint handler */
-	regs->ip = (unsigned long) bp_int3_handler;
+	/* Check if address is handled by text_poke_bp */
+	if (bp_int3_handler && regs->ip == (unsigned long)bp_int3_addr) {
+		regs->ip = (unsigned long)bp_int3_handler;
+		return 1;
+	}
 
-	return 1;
+	/* Check if address is handled by text_poke_bp_list */
+	if (bp_int3_is_handled && bp_int3_is_handled(regs->ip)) {
+		/* just skip the instruction */
+		regs->ip += bp_int3_len - 1;
+		return 1;
+	}
 
+	return 0;
 }
 
 /**
@@ -658,11 +671,13 @@ int poke_int3_handler(struct pt_regs *regs)
  */
 int text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 {
-	unsigned char int3 = 0xcc;
-	int ret = 0;
+	int ret;
 
+	bp_int3 = 0xcc;
 	bp_int3_handler = handler;
-	bp_int3_addr = (u8 *)addr + sizeof(int3);
+	bp_int3_addr = (u8 *)addr + sizeof(bp_int3);
+	bp_int3_len = len;
+	bp_int3_is_handled = NULL;
 	bp_patching_in_progress = true;
 	/*
 	 * Corresponding read barrier in int3 notifier for
@@ -671,17 +686,17 @@ int text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 	 */
 	smp_wmb();
 
-	ret = text_poke(addr, &int3, sizeof(int3));
+	ret = text_poke(addr, &bp_int3, sizeof(bp_int3));
 	if (unlikely(ret))
 		goto fail;
 
 	run_sync();
 
-	if (len - sizeof(int3) > 0) {
+	if (len - sizeof(bp_int3) > 0) {
 		/* patch all but the first byte */
-		ret = text_poke((char *)addr + sizeof(int3),
-			       (const char *) opcode + sizeof(int3),
-			       len - sizeof(int3));
+		ret = text_poke((char *)addr + sizeof(bp_int3),
+				(const char *) opcode + sizeof(bp_int3),
+				len - sizeof(bp_int3));
 		BUG_ON(ret);
 		/*
 		 * According to Intel, this core syncing is very likely
@@ -692,7 +707,7 @@ int text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 	}
 
 	/* patch the first byte */
-	ret = text_poke(addr, opcode, sizeof(int3));
+	ret = text_poke(addr, opcode, sizeof(bp_int3));
 	BUG_ON(ret);
 
 	run_sync();
@@ -704,3 +719,218 @@ fail:
 	return ret;
 }
 
+static int text_poke_check(void *addr, const void *opcode, size_t len)
+{
+	unsigned char actual[MAX_PATCH_LEN];
+	int ret;
+
+	ret = probe_kernel_read(actual, addr, len);
+	if (unlikely(ret))
+		return -EFAULT;
+
+	ret = memcmp(actual, opcode, len);
+	if (unlikely(ret))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int add_iter_breakpoint(struct text_poke_bp_iter *iterator,
+				       void *iter)
+{
+	void *addr;
+	const void *old_opcode;
+	int ret = 0;
+
+	/* nope if the code is not defined */
+	old_opcode = iterator->get_old_opcode(iter);
+	if (!old_opcode)
+		return 0;
+
+	addr = iterator->get_addr(iter);
+	ret = text_poke_check(addr, old_opcode, bp_int3_len);
+
+	if (likely(!ret))
+		/* write the breakpoint */
+		ret = text_poke(addr, &bp_int3, sizeof(bp_int3));
+
+	return ret;
+}
+
+static int update_iter_code(struct text_poke_bp_iter *iterator,
+				   void *iter)
+{
+	void *addr;
+	const void *opcode;
+
+	/* nope if the code is not defined */
+	opcode = iterator->get_opcode(iter);
+	if (!opcode)
+		return 0;
+
+	/* write all but the first byte */
+	addr = iterator->get_addr(iter);
+	return text_poke(addr + sizeof(bp_int3),
+			 opcode + sizeof(bp_int3),
+			 bp_int3_len - sizeof(bp_int3));
+}
+
+static int finish_iter_update(struct text_poke_bp_iter *iterator,
+				      void *iter)
+{
+	void *addr;
+	const void *opcode;
+	int ret = 0;
+
+	opcode = iterator->get_opcode(iter);
+	if (opcode) {
+		/* write the first byte if defined */
+		addr = iterator->get_addr(iter);
+		ret = text_poke(addr, opcode, sizeof(bp_int3));
+	}
+
+	/* Patching has finished. Let's update the status flag if any. */
+	if (!ret && iterator->finish)
+		ret = iterator->finish(iter);
+
+	return ret;
+}
+
+static void recover_iter(struct text_poke_bp_iter *iterator,
+				void *iter)
+{
+	void *addr;
+	const void *old_opcode;
+	unsigned char actual[MAX_PATCH_LEN];
+	int err;
+
+	/* If opcode is not defined, we did not change this address at all */
+	old_opcode = iterator->get_old_opcode(iter);
+	if(!old_opcode)
+		return;
+
+	addr = iterator->get_addr(iter);
+	err = probe_kernel_read(actual, addr, bp_int3_len);
+	/* There is no way to recover the system if we even can not read */
+	BUG_ON(err);
+
+	/* We are done if there is no interrupt */
+	if (actual[0] != bp_int3)
+		return;
+
+	/* Put the old code back behind the interrupt if it is not there */
+	if (memcmp(actual + sizeof(bp_int3),
+		   old_opcode + sizeof(bp_int3),
+		   bp_int3_len - sizeof(bp_int3)) != 0) {
+		err = text_poke(addr + sizeof(bp_int3),
+				old_opcode + sizeof(bp_int3),
+				bp_int3_len - sizeof(bp_int3));
+		/* we should not continue if recovering has failed */
+		BUG_ON(err);
+		/*
+		 * It is not optimal to sync for each repaired address.
+		 * But this is a corner case and we are in bad state anyway.
+		 * Note that this is not needed on Intel, see text_poke_bp
+		 */
+		run_sync();
+	}
+
+	/* Finally, put back the first byte from the old code */
+	err = text_poke(addr, old_opcode, sizeof(bp_int3));
+	/* we can not continue if the interrupt is still there */
+	BUG_ON(err);
+}
+
+#define for_text_poke_bp_iter(iterator,iter)	     \
+	for (iter = iterator->start(iterator->init); \
+	     iter;				     \
+	     iter = iterator->next(iter))
+
+/**
+ * text_poke_bp_list() -- update instructions on live kernel on SMP
+ * @iterator:	structure that allows to iterate over the patched addressed
+ * 		and get all the needed information
+ *
+ * Modify several instructions by using int3 breakpoint on SMP in parallel.
+ * The principle is the same as in text_poke_bp. But synchronization of all CPUs
+ * is relatively slow operation, so we need to reduce it. Hence we add interrupt
+ * for all instructions before we modify the other bytes, etc.
+ *
+ * The operation wants to keep a consistent state. If anything goes wrong,
+ * it does the best effort to restore the original state. The only exception
+ * are addresses where the patching has finished. But the caller can be informed
+ * about this via the finish callback.
+ *
+ * It is a bit more paranoid than text_poke_bp because it checks the actual
+ * code before patching. This is a good practice proposed by the ftrace code.
+ *
+ * Note: This function must be called under text_mutex.
+ */
+int text_poke_bp_list(struct text_poke_bp_iter *iterator)
+{
+	void *iter;
+	const char *report = "adding breakpoints";
+	int count = 0;
+	int ret = 0;
+
+	bp_int3 = 0xcc;
+	bp_int3_addr = NULL;
+	bp_int3_len = iterator->len;
+	bp_int3_handler = NULL;
+	bp_int3_is_handled = iterator->is_handled;
+	bp_patching_in_progress = true;
+
+	smp_wmb();
+
+	/* add interrupts */
+	for_text_poke_bp_iter(iterator, iter) {
+		ret = add_iter_breakpoint(iterator, iter);
+		if (ret)
+			goto fail;
+		count++;
+	}
+	run_sync();
+
+	report = "updating code";
+	if (bp_int3_len - sizeof(bp_int3) > 0) {
+		count = 0;
+		/* patch all but the first byte */
+		for_text_poke_bp_iter(iterator, iter) {
+			ret = update_iter_code(iterator, iter);
+			if (ret)
+				goto fail;
+			count++;
+		}
+		run_sync();
+	}
+
+	/* patch the first byte */
+	report = "finishing update";
+	count = 0;
+	for_text_poke_bp_iter(iterator, iter) {
+		ret = finish_iter_update(iterator, iter);
+		if (ret)
+			goto fail;
+		count++;
+	}
+	run_sync();
+
+fail:
+	if (unlikely(ret)) {
+		printk(KERN_WARNING "text_poke_bp_iter failed on %s (%d):\n",
+		       report, count);
+		/* save information about the failure */
+		iterator->fail_count = count;
+		iterator->fail_addr = iterator->get_addr(iter);
+		/* try to recover the old state */
+		for_text_poke_bp_iter(iterator, iter) {
+			recover_iter(iterator, iter);
+		}
+		run_sync();
+	}
+
+	bp_patching_in_progress = false;
+	smp_wmb();
+
+	return ret;
+}
-- 
1.8.4


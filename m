Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab3JRO2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:28:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327Ab3JRO1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:27:30 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 3/6] x86: allow to modify more instructions in one text_poke_bp call
Date: Fri, 18 Oct 2013 16:27:22 +0200
Message-Id: <1382106445-31468-4-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying to use text_poke_bp in dynamic ftrace, the process
was significantly slower than the original code. For example,
I tried to modify the ftrace function, enable, and disable the
tracer in a cycle. With 9 different trace functions and 500
cycles, I got these times:

	original code:			with text_poke_bp:

	real    19m51.667s		real    33m29.456s
	user    0m0.004s		user    0m0.008s
	sys     0m27.124s		sys     0m27.620s

It turned out that most of the extra time was spent in the call:

	on_each_cpu(do_sync_core, NULL, 1)

It is needed to reset the speculative queue of decoded instructions
on each CPU. It is relatively expensive operation. The original code
reduced the usage by patching all instructions in parallel.

If we want to share the code and keep the effectivity, we need to
extend text_poke_bp and allow to modify more instructions at once as well.
It might be useful in more situations, for example, in arch_optimize_kprobes.

Note that the list of modified addresses has to be sorted. Otherwise,
the int3 handler would be too slow.

Also note that "addr" and "handler" are arays of pointers (IPs). While "opcode"
is a plain array of bytes, new instructions of the same length. text_poke_bp
might be used to patch different length of instructions but there will
be the same type of intructions for each call. It would be waste of memory
if we pass instructions via an array of pointers.

Finally, the list of handlers is optional. ftrace and jump labels
pretend that there are nops. Hence. the int3 handler could calculate
the next IP address from the lenght of the patched instruction.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 arch/x86/include/asm/alternative.h |  3 +-
 arch/x86/kernel/alternative.c      | 74 ++++++++++++++++++++++++++++++--------
 arch/x86/kernel/jump_label.c       |  3 +-
 arch/x86/kernel/kprobes/opt.c      |  8 ++---
 4 files changed, 67 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 0a3f9c9..9038f32 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -226,6 +226,7 @@ extern void *text_poke_early(void *addr, const void *opcode, size_t len);
  */
 extern void *text_poke(void *addr, const void *opcode, size_t len);
 extern int poke_int3_handler(struct pt_regs *regs);
-extern void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler);
+extern void *text_poke_bp(void *addr[], const void *opcode, size_t len,
+			  unsigned int count, void *handler[]);
 
 #endif /* _ASM_X86_ALTERNATIVE_H */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 13cae15..0eb8250 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -4,6 +4,7 @@
 #include <linux/sched.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
+#include <linux/bsearch.h>
 #include <linux/stringify.h>
 #include <linux/kprobes.h>
 #include <linux/mm.h>
@@ -644,32 +645,61 @@ static void run_sync(void)
 }
 
 static bool bp_patching_in_progress;
-static void *bp_int3_handler, *bp_int3_addr;
+static void **bp_int3_handler, **bp_int3_addr;
+static size_t bp_int3_len;		/* length of the modified instruction */
+static unsigned int bp_int3_count;	/* number of modified instructions */
+
+static int poke_int3_cmp(const void *a, const void *b)
+{
+	unsigned long key = (unsigned long)a;
+	unsigned long addr = *(unsigned long *)b;
+
+	return key - addr;
+}
 
 int poke_int3_handler(struct pt_regs *regs)
 {
+	void *found;
+	unsigned long index;
+
 	/* bp_patching_in_progress */
 	smp_rmb();
 
 	if (likely(!bp_patching_in_progress))
 		return 0;
 
-	if (user_mode_vm(regs) || regs->ip != (unsigned long)bp_int3_addr)
+	if (user_mode_vm(regs))
+		return 0;
+
+	/* search if this address should be handled here */
+	found = bsearch((void *)(regs->ip - 1), bp_int3_addr, bp_int3_count,
+			sizeof(*bp_int3_addr), poke_int3_cmp);
+
+	if (!found)
 		return 0;
 
 	/* set up the specified breakpoint handler */
-	regs->ip = (unsigned long) bp_int3_handler;
+	if (bp_int3_handler) {
+		/* handler is on the same index as the found address */
+		index = (void**)found - bp_int3_addr;
+		regs->ip = (unsigned long)*(bp_int3_handler + index);
+	} else {
+		/* just skip the instruction if the handler is not defined */
+		regs->ip += bp_int3_len - 1;
+	}
 
 	return 1;
-
 }
 
 /**
  * text_poke_bp() -- update instructions on live kernel on SMP
- * @addr:	address to patch
- * @opcode:	opcode of new instruction
+ * @addr:	addresses to patch
+ * @opcode:	opcodes of new instructions
  * @len:	length to copy
- * @handler:	address to jump to when the temporary breakpoint is hit
+ * @count:	number of patched addresses
+ * @handler:	addresses to jump to when the temporary breakpoint is hit;
+ *		the value is optional; if the array is NULL, it jupms right
+ *		after the related instruction
  *
  * Modify multi-byte instruction by using int3 breakpoint on SMP.
  * We completely avoid stop_machine() here, and achieve the
@@ -686,13 +716,19 @@ int poke_int3_handler(struct pt_regs *regs)
  *
  * Note: must be called under text_mutex.
  */
-void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
+void *text_poke_bp(void *addr[], const void *opcode, size_t len,
+			   unsigned int count, void *handler[])
 {
 	unsigned char int3 = 0xcc;
+	const void *op;
+	unsigned int i;
 
+	bp_int3_addr = addr;
+	bp_int3_len = len;
+	bp_int3_count = count;
 	bp_int3_handler = handler;
-	bp_int3_addr = (u8 *)addr + sizeof(int3);
 	bp_patching_in_progress = true;
+
 	/*
 	 * Corresponding read barrier in int3 notifier for
 	 * making sure the in_progress flags is correctly ordered wrt.
@@ -700,15 +736,21 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 	 */
 	smp_wmb();
 
-	text_poke_part(addr, &int3, sizeof(int3));
+	/* add interupts */
+	for (i = 0; i < count; i++)
+		text_poke_part(addr[i], &int3, sizeof(int3));
 
 	run_sync();
 
 	if (len - sizeof(int3) > 0) {
 		/* patch all but the first byte */
-		text_poke_part((char *)addr + sizeof(int3),
-			       (const char *) opcode + sizeof(int3),
-			       len - sizeof(int3));
+		op = opcode + sizeof(int3);
+		for (i = 0; i < count; i++) {
+			text_poke_part(addr[i] + sizeof(int3), op,
+				       len - sizeof(int3));
+			op += len;
+		}
+
 		/*
 		 * According to Intel, this core syncing is very likely
 		 * not necessary and we'd be safe even without it. But
@@ -718,7 +760,11 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 	}
 
 	/* patch the first byte */
-	text_poke_part(addr, opcode, sizeof(int3));
+	op = opcode;
+	for (i = 0; i < count; i++) {
+		text_poke_part(addr[i], op, sizeof(int3));
+		op += len;
+	}
 
 	run_sync();
 
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index ee11b7d..b472d4f 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -87,8 +87,7 @@ static void __jump_label_transform(struct jump_entry *entry,
 	if (poker)
 		(*poker)((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
 	else
-		text_poke_bp((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE,
-			     (void *)entry->code + JUMP_LABEL_NOP_SIZE);
+		text_poke_bp((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE, 1, NULL);
 }
 
 void arch_jump_label_transform(struct jump_entry *entry,
diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index 898160b..b08e8df 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -390,8 +390,8 @@ void __kprobes arch_optimize_kprobes(struct list_head *oplist)
 		insn_buf[0] = RELATIVEJUMP_OPCODE;
 		*(s32 *)(&insn_buf[1]) = rel;
 
-		text_poke_bp(op->kp.addr, insn_buf, RELATIVEJUMP_SIZE,
-			     op->optinsn.insn);
+		text_poke_bp((void **)&(op->kp.addr), insn_buf, RELATIVEJUMP_SIZE, 1,
+			     (void **)&(op->optinsn.insn));
 
 		list_del_init(&op->list);
 	}
@@ -405,8 +405,8 @@ void __kprobes arch_unoptimize_kprobe(struct optimized_kprobe *op)
 	/* Set int3 to first byte for kprobes */
 	insn_buf[0] = BREAKPOINT_INSTRUCTION;
 	memcpy(insn_buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
-	text_poke_bp(op->kp.addr, insn_buf, RELATIVEJUMP_SIZE,
-		     op->optinsn.insn);
+	text_poke_bp((void **)&(op->kp.addr), insn_buf, RELATIVEJUMP_SIZE, 1,
+		     (void **)&(op->optinsn.insn));
 }
 
 /*
-- 
1.8.4


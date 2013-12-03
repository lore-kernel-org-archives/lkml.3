Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab3LCNWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:22:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab3LCNWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:22:20 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v5 1/8] x86: allow to handle errors in text_poke function family
Date: Tue,  3 Dec 2013 14:21:20 +0100
Message-Id: <1386076887-2655-2-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386076887-2655-1-git-send-email-pmladek@suse.cz>
References: <1386076887-2655-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The text_poke functions called BUG() in case of error. This was too strict.
There are situations when the system is still usable even when the patching
has failed, for example when enabling the dynamic ftrace.

This commit modifies text_poke, text_poke_early, and text_poke_bp functions
to return an error code instead calling BUG(). The code is returned instead
of the patched address. The address was just copied from the first parameter,
so it was no extra information. It has not been used anywhere yet.

The commit also modifies the few locations where text_poke functions were used
and the error code has to be handled now. It just passes the error code if
there already is an existing error handling, for example in
kgdb_arch_set_breakpoint. It calls BUG() in the other locations.

Note that BUG() still need to be called in text_poke_bp when the code already is
partially modified but the operation can not be finished.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 arch/x86/include/asm/alternative.h |  7 +++--
 arch/x86/kernel/alternative.c      | 59 ++++++++++++++++++++++++--------------
 arch/x86/kernel/jump_label.c       | 11 ++++---
 arch/x86/kernel/kgdb.c             | 11 +++++--
 arch/x86/kernel/kprobes/core.c     | 10 +++++--
 arch/x86/kernel/kprobes/opt.c      |  8 ++++--
 6 files changed, 71 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 0a3f9c9f98d5..a23a860a208d 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -208,7 +208,7 @@ static inline void apply_paravirt(struct paravirt_patch_site *start,
 #define __parainstructions_end	NULL
 #endif
 
-extern void *text_poke_early(void *addr, const void *opcode, size_t len);
+extern int text_poke_early(void *addr, const void *opcode, size_t len);
 
 /*
  * Clear and restore the kernel write-protection flag on the local CPU.
@@ -224,8 +224,9 @@ extern void *text_poke_early(void *addr, const void *opcode, size_t len);
  * On the local CPU you need to be protected again NMI or MCE handlers seeing an
  * inconsistent instruction while you patch.
  */
-extern void *text_poke(void *addr, const void *opcode, size_t len);
+extern int text_poke(void *addr, const void *opcode, size_t len);
 extern int poke_int3_handler(struct pt_regs *regs);
-extern void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler);
+extern int text_poke_bp(void *addr, const void *opcode, size_t len,
+			void *handler);
 
 #endif /* _ASM_X86_ALTERNATIVE_H */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index df94598ad05a..10a7ec0c66f9 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -242,7 +242,7 @@ static void __init_or_module add_nops(void *insns, unsigned int len)
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern s32 __smp_locks[], __smp_locks_end[];
-void *text_poke_early(void *addr, const void *opcode, size_t len);
+int text_poke_early(void *addr, const void *opcode, size_t len);
 
 /* Replace instructions with better alternatives for this CPU type.
    This runs before SMP is initialized to avoid SMP problems with
@@ -256,6 +256,7 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 	struct alt_instr *a;
 	u8 *instr, *replacement;
 	u8 insnbuf[MAX_PATCH_LEN];
+	int err;
 
 	DPRINTK("%s: alt table %p -> %p\n", __func__, start, end);
 	/*
@@ -285,7 +286,8 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 		add_nops(insnbuf + a->replacementlen,
 			 a->instrlen - a->replacementlen);
 
-		text_poke_early(instr, insnbuf, a->instrlen);
+		err = text_poke_early(instr, insnbuf, a->instrlen);
+		BUG_ON(err);
 	}
 }
 
@@ -295,6 +297,7 @@ static void alternatives_smp_lock(const s32 *start, const s32 *end,
 				  u8 *text, u8 *text_end)
 {
 	const s32 *poff;
+	int err;
 
 	mutex_lock(&text_mutex);
 	for (poff = start; poff < end; poff++) {
@@ -303,8 +306,10 @@ static void alternatives_smp_lock(const s32 *start, const s32 *end,
 		if (!*poff || ptr < text || ptr >= text_end)
 			continue;
 		/* turn DS segment override prefix into lock prefix */
-		if (*ptr == 0x3e)
-			text_poke(ptr, ((unsigned char []){0xf0}), 1);
+		if (*ptr == 0x3e) {
+			err = text_poke(ptr, ((unsigned char []){0xf0}), 1);
+			BUG_ON(err);
+		}
 	}
 	mutex_unlock(&text_mutex);
 }
@@ -313,6 +318,7 @@ static void alternatives_smp_unlock(const s32 *start, const s32 *end,
 				    u8 *text, u8 *text_end)
 {
 	const s32 *poff;
+	int err;
 
 	mutex_lock(&text_mutex);
 	for (poff = start; poff < end; poff++) {
@@ -321,8 +327,10 @@ static void alternatives_smp_unlock(const s32 *start, const s32 *end,
 		if (!*poff || ptr < text || ptr >= text_end)
 			continue;
 		/* turn lock prefix into DS segment override prefix */
-		if (*ptr == 0xf0)
-			text_poke(ptr, ((unsigned char []){0x3E}), 1);
+		if (*ptr == 0xf0) {
+			err = text_poke(ptr, ((unsigned char []){0x3E}), 1);
+			BUG_ON(err);
+		}
 	}
 	mutex_unlock(&text_mutex);
 }
@@ -449,6 +457,7 @@ void __init_or_module apply_paravirt(struct paravirt_patch_site *start,
 {
 	struct paravirt_patch_site *p;
 	char insnbuf[MAX_PATCH_LEN];
+	int err;
 
 	if (noreplace_paravirt)
 		return;
@@ -466,7 +475,8 @@ void __init_or_module apply_paravirt(struct paravirt_patch_site *start,
 
 		/* Pad the rest with nops */
 		add_nops(insnbuf + used, p->len - used);
-		text_poke_early(p->instr, insnbuf, p->len);
+		err = text_poke_early(p->instr, insnbuf, p->len);
+		BUG_ON(err);
 	}
 }
 extern struct paravirt_patch_site __start_parainstructions[],
@@ -522,10 +532,10 @@ void __init alternative_instructions(void)
  * When you use this code to patch more than one byte of an instruction
  * you need to make sure that other CPUs cannot execute this code in parallel.
  * Also no thread must be currently preempted in the middle of these
- * instructions. And on the local CPU you need to be protected again NMI or MCE
- * handlers seeing an inconsistent instruction while you patch.
+ * instructions. And on the local CPU you need to protect NMI and MCE
+ * handlers against seeing an inconsistent instruction while you patch.
  */
-void *__init_or_module text_poke_early(void *addr, const void *opcode,
+int __init_or_module text_poke_early(void *addr, const void *opcode,
 					      size_t len)
 {
 	unsigned long flags;
@@ -535,7 +545,7 @@ void *__init_or_module text_poke_early(void *addr, const void *opcode,
 	local_irq_restore(flags);
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but
 	   that causes hangs on some VIA CPUs. */
-	return addr;
+	return 0;
 }
 
 /**
@@ -551,7 +561,7 @@ void *__init_or_module text_poke_early(void *addr, const void *opcode,
  *
  * Note: Must be called under text_mutex.
  */
-void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
+int __kprobes text_poke(void *addr, const void *opcode, size_t len)
 {
 	unsigned long flags;
 	char *vaddr;
@@ -566,7 +576,8 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 		WARN_ON(!PageReserved(pages[0]));
 		pages[1] = virt_to_page(addr + PAGE_SIZE);
 	}
-	BUG_ON(!pages[0]);
+	if (unlikely(!pages[0]))
+		return -EFAULT;
 	local_irq_save(flags);
 	set_fixmap(FIX_TEXT_POKE0, page_to_phys(pages[0]));
 	if (pages[1])
@@ -583,7 +594,7 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 	for (i = 0; i < len; i++)
 		BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);
 	local_irq_restore(flags);
-	return addr;
+	return 0;
 }
 
 static void do_sync_core(void *info)
@@ -634,9 +645,10 @@ int poke_int3_handler(struct pt_regs *regs)
  *
  * Note: must be called under text_mutex.
  */
-void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
+int text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 {
 	unsigned char int3 = 0xcc;
+	int ret = 0;
 
 	bp_int3_handler = handler;
 	bp_int3_addr = (u8 *)addr + sizeof(int3);
@@ -648,15 +660,18 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 	 */
 	smp_wmb();
 
-	text_poke(addr, &int3, sizeof(int3));
+	ret = text_poke(addr, &int3, sizeof(int3));
+	if (unlikely(ret))
+		goto fail;
 
 	on_each_cpu(do_sync_core, NULL, 1);
 
 	if (len - sizeof(int3) > 0) {
 		/* patch all but the first byte */
-		text_poke((char *)addr + sizeof(int3),
-			  (const char *) opcode + sizeof(int3),
-			  len - sizeof(int3));
+		ret = text_poke((char *)addr + sizeof(int3),
+			       (const char *) opcode + sizeof(int3),
+			       len - sizeof(int3));
+		BUG_ON(ret);
 		/*
 		 * According to Intel, this core syncing is very likely
 		 * not necessary and we'd be safe even without it. But
@@ -666,13 +681,15 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 	}
 
 	/* patch the first byte */
-	text_poke(addr, opcode, sizeof(int3));
+	ret = text_poke(addr, opcode, sizeof(int3));
+	BUG_ON(ret);
 
 	on_each_cpu(do_sync_core, NULL, 1);
 
+fail:
 	bp_patching_in_progress = false;
 	smp_wmb();
 
-	return addr;
+	return ret;
 }
 
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 26d5a55a2736..802cda1574a4 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -38,12 +38,13 @@ static void bug_at(unsigned char *ip, int line)
 
 static void __jump_label_transform(struct jump_entry *entry,
 				   enum jump_label_type type,
-				   void *(*poker)(void *, const void *, size_t),
+				   int (*poker)(void *, const void *, size_t),
 				   int init)
 {
 	union jump_code_union code;
 	const unsigned char default_nop[] = { STATIC_KEY_INIT_NOP };
 	const unsigned char *ideal_nop = ideal_nops[NOP_ATOMIC5];
+	int err;
 
 	if (type == JUMP_LABEL_ENABLE) {
 		if (init) {
@@ -96,10 +97,12 @@ static void __jump_label_transform(struct jump_entry *entry,
 	 *
 	 */
 	if (poker)
-		(*poker)((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
+		err = (*poker)((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
 	else
-		text_poke_bp((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE,
-			     (void *)entry->code + JUMP_LABEL_NOP_SIZE);
+		err = text_poke_bp((void *)entry->code, &code,
+				   JUMP_LABEL_NOP_SIZE,
+				   (void *)entry->code + JUMP_LABEL_NOP_SIZE);
+	BUG_ON(err);
 }
 
 void arch_jump_label_transform(struct jump_entry *entry,
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 836f8322960e..ce542b5fa55a 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -766,8 +766,10 @@ int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 	 */
 	if (mutex_is_locked(&text_mutex))
 		return -EBUSY;
-	text_poke((void *)bpt->bpt_addr, arch_kgdb_ops.gdb_bpt_instr,
-		  BREAK_INSTR_SIZE);
+	err = text_poke((void *)bpt->bpt_addr, arch_kgdb_ops.gdb_bpt_instr,
+			BREAK_INSTR_SIZE);
+	if (err)
+		return err;
 	err = probe_kernel_read(opc, (char *)bpt->bpt_addr, BREAK_INSTR_SIZE);
 	if (err)
 		return err;
@@ -792,7 +794,10 @@ int kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt)
 	 */
 	if (mutex_is_locked(&text_mutex))
 		goto knl_write;
-	text_poke((void *)bpt->bpt_addr, bpt->saved_instr, BREAK_INSTR_SIZE);
+	err = text_poke((void *)bpt->bpt_addr, bpt->saved_instr,
+			BREAK_INSTR_SIZE);
+	if (err)
+		goto knl_write;
 	err = probe_kernel_read(opc, (char *)bpt->bpt_addr, BREAK_INSTR_SIZE);
 	if (err || memcmp(opc, bpt->saved_instr, BREAK_INSTR_SIZE))
 		goto knl_write;
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 79a3f9682871..f4a4d15fa129 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -409,12 +409,18 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
-	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
+	int ret;
+
+	ret = text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
+	BUG_ON(ret);
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	text_poke(p->addr, &p->opcode, 1);
+	int ret;
+
+	ret = text_poke(p->addr, &p->opcode, 1);
+	BUG_ON(ret);
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index 898160b42e43..1e4c062e9ea8 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -376,6 +376,7 @@ void __kprobes arch_optimize_kprobes(struct list_head *oplist)
 {
 	struct optimized_kprobe *op, *tmp;
 	u8 insn_buf[RELATIVEJUMP_SIZE];
+	int err;
 
 	list_for_each_entry_safe(op, tmp, oplist, list) {
 		s32 rel = (s32)((long)op->optinsn.insn -
@@ -390,8 +391,9 @@ void __kprobes arch_optimize_kprobes(struct list_head *oplist)
 		insn_buf[0] = RELATIVEJUMP_OPCODE;
 		*(s32 *)(&insn_buf[1]) = rel;
 
-		text_poke_bp(op->kp.addr, insn_buf, RELATIVEJUMP_SIZE,
+		err = text_poke_bp(op->kp.addr, insn_buf, RELATIVEJUMP_SIZE,
 			     op->optinsn.insn);
+		BUG_ON(err);
 
 		list_del_init(&op->list);
 	}
@@ -401,12 +403,14 @@ void __kprobes arch_optimize_kprobes(struct list_head *oplist)
 void __kprobes arch_unoptimize_kprobe(struct optimized_kprobe *op)
 {
 	u8 insn_buf[RELATIVEJUMP_SIZE];
+	int err;
 
 	/* Set int3 to first byte for kprobes */
 	insn_buf[0] = BREAKPOINT_INSTRUCTION;
 	memcpy(insn_buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
-	text_poke_bp(op->kp.addr, insn_buf, RELATIVEJUMP_SIZE,
+	err = text_poke_bp(op->kp.addr, insn_buf, RELATIVEJUMP_SIZE,
 		     op->optinsn.insn);
+	BUG_ON(err);
 }
 
 /*
-- 
1.8.4


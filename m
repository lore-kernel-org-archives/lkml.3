Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3LJPmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:42:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab3LJPmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:42:49 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v6 1/8] x86: allow to handle errors in text_poke function family
Date: Tue, 10 Dec 2013 16:42:13 +0100
Message-Id: <1386690140-19941-2-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386690140-19941-1-git-send-email-pmladek@suse.cz>
References: <1386690140-19941-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The text_poke functions called BUG() in case of error. This was too strict.
There are situations when the system is still usable even when the patching
has failed, for example when enabling the dynamic ftrace.

This commit modifies text_poke and text_poke_bp functions to return an error
code instead of calling BUG(). They used to return the patched address. But
the address was just copied from the first parameter. It was no extra
information and it has not been used anywhere yet.

There are some situations where it is hard to recover from an error. Masami
Hiramatsu <masami.hiramatsu.pt@hitachi.com> suggested to create
text_poke*_or_die() variants for this purpose.

Last but not least, we modify return value of the text_poke_early() function.
It is not capable of returning an error code. Let's return void to make
it clear.

Finally, we also need to modify the few locations where text_poke functions
were used and the error code has to be handled now.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 arch/x86/include/asm/alternative.h | 10 +++++--
 arch/x86/kernel/alternative.c      | 61 ++++++++++++++++++++++++++------------
 arch/x86/kernel/jump_label.c       |  7 +++--
 arch/x86/kernel/kgdb.c             | 11 +++++--
 arch/x86/kernel/kprobes/core.c     |  5 ++--
 arch/x86/kernel/kprobes/opt.c      |  8 ++---
 6 files changed, 68 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 0a3f9c9f98d5..586747f5f41d 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -208,7 +208,7 @@ static inline void apply_paravirt(struct paravirt_patch_site *start,
 #define __parainstructions_end	NULL
 #endif
 
-extern void *text_poke_early(void *addr, const void *opcode, size_t len);
+extern void text_poke_early(void *addr, const void *opcode, size_t len);
 
 /*
  * Clear and restore the kernel write-protection flag on the local CPU.
@@ -224,8 +224,12 @@ extern void *text_poke_early(void *addr, const void *opcode, size_t len);
  * On the local CPU you need to be protected again NMI or MCE handlers seeing an
  * inconsistent instruction while you patch.
  */
-extern void *text_poke(void *addr, const void *opcode, size_t len);
+extern int text_poke(void *addr, const void *opcode, size_t len);
+extern void text_poke_or_die(void *addr, const void *opcode, size_t len);
 extern int poke_int3_handler(struct pt_regs *regs);
-extern void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler);
+extern int text_poke_bp(void *addr, const void *opcode, size_t len,
+			void *handler);
+extern void text_poke_bp_or_die(void *addr, const void *opcode, size_t len,
+				void *handler);
 
 #endif /* _ASM_X86_ALTERNATIVE_H */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index df94598ad05a..eabed9326d2a 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -242,7 +242,7 @@ static void __init_or_module add_nops(void *insns, unsigned int len)
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern s32 __smp_locks[], __smp_locks_end[];
-void *text_poke_early(void *addr, const void *opcode, size_t len);
+void text_poke_early(void *addr, const void *opcode, size_t len);
 
 /* Replace instructions with better alternatives for this CPU type.
    This runs before SMP is initialized to avoid SMP problems with
@@ -304,7 +304,7 @@ static void alternatives_smp_lock(const s32 *start, const s32 *end,
 			continue;
 		/* turn DS segment override prefix into lock prefix */
 		if (*ptr == 0x3e)
-			text_poke(ptr, ((unsigned char []){0xf0}), 1);
+			text_poke_or_die(ptr, ((unsigned char []){0xf0}), 1);
 	}
 	mutex_unlock(&text_mutex);
 }
@@ -322,7 +322,7 @@ static void alternatives_smp_unlock(const s32 *start, const s32 *end,
 			continue;
 		/* turn lock prefix into DS segment override prefix */
 		if (*ptr == 0xf0)
-			text_poke(ptr, ((unsigned char []){0x3E}), 1);
+			text_poke_or_die(ptr, ((unsigned char []){0x3E}), 1);
 	}
 	mutex_unlock(&text_mutex);
 }
@@ -522,10 +522,10 @@ void __init alternative_instructions(void)
  * When you use this code to patch more than one byte of an instruction
  * you need to make sure that other CPUs cannot execute this code in parallel.
  * Also no thread must be currently preempted in the middle of these
- * instructions. And on the local CPU you need to be protected again NMI or MCE
- * handlers seeing an inconsistent instruction while you patch.
+ * instructions. And on the local CPU you need to protect NMI and MCE
+ * handlers against seeing an inconsistent instruction while you patch.
  */
-void *__init_or_module text_poke_early(void *addr, const void *opcode,
+void __init_or_module text_poke_early(void *addr, const void *opcode,
 					      size_t len)
 {
 	unsigned long flags;
@@ -535,7 +535,6 @@ void *__init_or_module text_poke_early(void *addr, const void *opcode,
 	local_irq_restore(flags);
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but
 	   that causes hangs on some VIA CPUs. */
-	return addr;
 }
 
 /**
@@ -551,7 +550,7 @@ void *__init_or_module text_poke_early(void *addr, const void *opcode,
  *
  * Note: Must be called under text_mutex.
  */
-void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
+int __kprobes text_poke(void *addr, const void *opcode, size_t len)
 {
 	unsigned long flags;
 	char *vaddr;
@@ -566,7 +565,8 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 		WARN_ON(!PageReserved(pages[0]));
 		pages[1] = virt_to_page(addr + PAGE_SIZE);
 	}
-	BUG_ON(!pages[0]);
+	if (unlikely(!pages[0]))
+		return -EFAULT;
 	local_irq_save(flags);
 	set_fixmap(FIX_TEXT_POKE0, page_to_phys(pages[0]));
 	if (pages[1])
@@ -583,7 +583,15 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 	for (i = 0; i < len; i++)
 		BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);
 	local_irq_restore(flags);
-	return addr;
+	return 0;
+}
+
+void __kprobes text_poke_or_die(void *addr, const void *opcode, size_t len)
+{
+	int err;
+
+	err = text_poke(addr, opcode, len);
+	BUG_ON(err);
 }
 
 static void do_sync_core(void *info)
@@ -634,9 +642,10 @@ int poke_int3_handler(struct pt_regs *regs)
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
@@ -648,15 +657,20 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 	 */
 	smp_wmb();
 
-	text_poke(addr, &int3, sizeof(int3));
+	ret = text_poke(addr, &int3, sizeof(int3));
+	if (unlikely(ret))
+		goto fail;
 
 	on_each_cpu(do_sync_core, NULL, 1);
 
 	if (len - sizeof(int3) > 0) {
-		/* patch all but the first byte */
-		text_poke((char *)addr + sizeof(int3),
-			  (const char *) opcode + sizeof(int3),
-			  len - sizeof(int3));
+		/*
+		 * Patch all but the first byte. We do not know how to recover
+		 * from an error at this stage.
+		 */
+		text_poke_or_die((char *)addr + sizeof(int3),
+				 (const char *) opcode + sizeof(int3),
+				 len - sizeof(int3));
 		/*
 		 * According to Intel, this core syncing is very likely
 		 * not necessary and we'd be safe even without it. But
@@ -665,14 +679,23 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 		on_each_cpu(do_sync_core, NULL, 1);
 	}
 
-	/* patch the first byte */
-	text_poke(addr, opcode, sizeof(int3));
+	/* Patch the first byte. We do not know how to recover from an error. */
+	text_poke_or_die(addr, opcode, sizeof(int3));
 
 	on_each_cpu(do_sync_core, NULL, 1);
 
+fail:
 	bp_patching_in_progress = false;
 	smp_wmb();
 
-	return addr;
+	return ret;
 }
 
+void text_poke_bp_or_die(void *addr, const void *opcode, size_t len,
+			 void *handler)
+{
+	int err;
+
+	err = text_poke_bp(addr, opcode, len, handler);
+	BUG_ON(err);
+}
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 26d5a55a2736..d87b2946a121 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -38,7 +38,7 @@ static void bug_at(unsigned char *ip, int line)
 
 static void __jump_label_transform(struct jump_entry *entry,
 				   enum jump_label_type type,
-				   void *(*poker)(void *, const void *, size_t),
+				   void (*poker)(void *, const void *, size_t),
 				   int init)
 {
 	union jump_code_union code;
@@ -98,8 +98,9 @@ static void __jump_label_transform(struct jump_entry *entry,
 	if (poker)
 		(*poker)((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
 	else
-		text_poke_bp((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE,
-			     (void *)entry->code + JUMP_LABEL_NOP_SIZE);
+		text_poke_bp_or_die((void *)entry->code, &code,
+				    JUMP_LABEL_NOP_SIZE,
+				    (void *)entry->code + JUMP_LABEL_NOP_SIZE);
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
index 79a3f9682871..8cb9b709661b 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -409,12 +409,13 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
-	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
+	text_poke_or_die(p->addr,
+			 ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	text_poke(p->addr, &p->opcode, 1);
+	text_poke_or_die(p->addr, &p->opcode, 1);
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index 898160b42e43..1e4fee746517 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -390,8 +390,8 @@ void __kprobes arch_optimize_kprobes(struct list_head *oplist)
 		insn_buf[0] = RELATIVEJUMP_OPCODE;
 		*(s32 *)(&insn_buf[1]) = rel;
 
-		text_poke_bp(op->kp.addr, insn_buf, RELATIVEJUMP_SIZE,
-			     op->optinsn.insn);
+		text_poke_bp_or_die(op->kp.addr, insn_buf, RELATIVEJUMP_SIZE,
+				    op->optinsn.insn);
 
 		list_del_init(&op->list);
 	}
@@ -405,8 +405,8 @@ void __kprobes arch_unoptimize_kprobe(struct optimized_kprobe *op)
 	/* Set int3 to first byte for kprobes */
 	insn_buf[0] = BREAKPOINT_INSTRUCTION;
 	memcpy(insn_buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
-	text_poke_bp(op->kp.addr, insn_buf, RELATIVEJUMP_SIZE,
-		     op->optinsn.insn);
+	text_poke_bp_or_die(op->kp.addr, insn_buf, RELATIVEJUMP_SIZE,
+			    op->optinsn.insn);
 }
 
 /*
-- 
1.8.4


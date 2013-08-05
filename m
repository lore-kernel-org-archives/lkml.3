Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab3HEWDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:03:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:64992 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984Ab3HEWC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:02:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,821,1367996400"; 
   d="scan'208";a="382341517"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        ananth@in.ibm.com
Subject: [PATCH 07/16] x86, asmlinkage: Make kprobes code visible and fix assembler code
Date: Mon,  5 Aug 2013 15:02:41 -0700
Message-Id: <1375740170-7446-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

- Make all the external assembler template symbols __visible
- Move the templates inline assembler code into a top level
assembler statement, not inside a function. This avoids it being
optimized away or cloned.

Cc: ananth@in.ibm.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/kprobes.h | 10 +++++-----
 arch/x86/kernel/kprobes/core.c |  2 +-
 arch/x86/kernel/kprobes/opt.c  |  5 +----
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 5a6d287..9454c16 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -49,10 +49,10 @@ typedef u8 kprobe_opcode_t;
 #define flush_insn_slot(p)	do { } while (0)
 
 /* optinsn template addresses */
-extern kprobe_opcode_t optprobe_template_entry;
-extern kprobe_opcode_t optprobe_template_val;
-extern kprobe_opcode_t optprobe_template_call;
-extern kprobe_opcode_t optprobe_template_end;
+extern __visible kprobe_opcode_t optprobe_template_entry;
+extern __visible kprobe_opcode_t optprobe_template_val;
+extern __visible kprobe_opcode_t optprobe_template_call;
+extern __visible kprobe_opcode_t optprobe_template_end;
 #define MAX_OPTIMIZED_LENGTH (MAX_INSN_SIZE + RELATIVE_ADDR_SIZE)
 #define MAX_OPTINSN_SIZE 				\
 	(((unsigned long)&optprobe_template_end -	\
@@ -62,7 +62,7 @@ extern kprobe_opcode_t optprobe_template_end;
 extern const int kretprobe_blacklist_size;
 
 void arch_remove_kprobe(struct kprobe *p);
-void kretprobe_trampoline(void);
+asmlinkage void kretprobe_trampoline(void);
 
 /* Architecture specific copy of original instruction*/
 struct arch_specific_insn {
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 211bce4..048852d 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -661,7 +661,7 @@ static void __used __kprobes kretprobe_trampoline_holder(void)
 /*
  * Called from kretprobe_trampoline
  */
-static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
+__visible __used __kprobes void *trampoline_handler(struct pt_regs *regs)
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index 76dc6f0..2c1ac28 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -88,9 +88,7 @@ static void __kprobes synthesize_set_arg1(kprobe_opcode_t *addr, unsigned long v
 	*(unsigned long *)addr = val;
 }
 
-static void __used __kprobes kprobes_optinsn_template_holder(void)
-{
-	asm volatile (
+asm (
 			".global optprobe_template_entry\n"
 			"optprobe_template_entry:\n"
 #ifdef CONFIG_X86_64
@@ -129,7 +127,6 @@ static void __used __kprobes kprobes_optinsn_template_holder(void)
 #endif
 			".global optprobe_template_end\n"
 			"optprobe_template_end:\n");
-}
 
 #define TMPL_MOVE_IDX \
 	((long)&optprobe_template_val - (long)&optprobe_template_entry)
-- 
1.8.3.1


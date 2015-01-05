Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbbAEPBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:01:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51565 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453AbbAEPAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:00:18 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 4/4] alternatives: Make JMPs more robust
Date: Mon,  5 Jan 2015 16:00:13 +0100
Message-Id: <1420470013-26413-5-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.2.0.33.gc18b867
In-Reply-To: <1420470013-26413-1-git-send-email-bp@alien8.de>
References: <1420470013-26413-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Up until now we had to pay attention to relative JMPs in alternatives
about how their relative offset gets computed so that the jump target
is still correct. Or, as it is the case for near CALLs (opcode e8), we
still have to go and readjust the offset at patching time.

What is more, the static_cpu_has_safe() facility had to force 4-byte
JMPs since we couldn't rely on the compiler to generate proper ones,
and, worse than that, generate a replacement JMP which is longer than
the original one, thus overwriting the beginning of the next instruction
at patching time.

So, in order to alleviate all that and make using JMPs more
straight-forward we go and pad the original instruction in an
alternative block with NOPs should the replacement(s) be longer. This
way, alternatives users shouldn't pay special attention so that original
and replacement instruction sizes are fine but the assembler would
simply add padding where needed and not do anything otherwise.

As a second aspect, we go and recompute JMPs at patching time so that we
can try to make 5-byte JMPs into two-byte ones if possible. If not, we
still have to recompute the offsets as the replacement JMP gets put far
away in the .altinstr_replacement section leading to a wrong offset if
copied verbatim.

For example, on a locally generated kernel image

old insn VA: 0xffffffff810014bd, CPU feat: X86_FEATURE_ALWAYS, size: 2
__switch_to:
 ffffffff810014bd:      eb 21                   jmp ffffffff810014e0
repl insn: size: 5
ffffffff81d0b23c:       e9 b1 62 2f ff          jmpq ffffffff810014f2

gets corrected to a 2-byte JMP:

apply_alternatives: feat: 3*32+21, old: (ffffffff810014bd, len: 2), repl: (ffffffff81d0b23c, len: 5)
alt_insn: e9 b1 62 2f ff
recompute_jumps: next_rip: ffffffff81d0b241, tgt_rip: ffffffff810014f2, new_displ: 0x00000033, ret len: 2
converted to: eb 33 90 90 90

and a 5-byte JMP:

old insn VA: 0xffffffff81001516, CPU feat: X86_FEATURE_ALWAYS, size: 2
__switch_to:
 ffffffff81001516:      eb 30                   jmp ffffffff81001548
repl insn: size: 5
 ffffffff81d0b241:      e9 10 63 2f ff          jmpq ffffffff81001556

gets shortened into a two-byte one:

apply_alternatives: feat: 3*32+21, old: (ffffffff81001516, len: 2), repl: (ffffffff81d0b241, len: 5)
alt_insn: e9 10 63 2f ff
recompute_jumps: next_rip: ffffffff81d0b246, tgt_rip: ffffffff81001556, new_displ: 0x0000003e, ret len: 2
converted to: eb 3e 90 90 90

... and so on.

This leads to a net win of 126 bytes of I$ on an AMD guest which
means some savings of precious instruction cache bandwidth. The
padding to the shorter 2-byte JMPs are single-byte NOPs which on smart
microarchitectures means discarding NOPs at decode time and thus freeing
up execution bandwidth.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/alternative-asm.h | 38 +++++++++++++++
 arch/x86/include/asm/cpufeature.h      | 10 +---
 arch/x86/kernel/alternative.c          | 85 ++++++++++++++++++++++++++++++++--
 arch/x86/lib/copy_page_64.S            | 34 +++++++-------
 arch/x86/lib/copy_user_64.S            | 39 ++++------------
 5 files changed, 146 insertions(+), 60 deletions(-)

diff --git a/arch/x86/include/asm/alternative-asm.h b/arch/x86/include/asm/alternative-asm.h
index 372231c22a47..c407705524c0 100644
--- a/arch/x86/include/asm/alternative-asm.h
+++ b/arch/x86/include/asm/alternative-asm.h
@@ -26,6 +26,44 @@
 	.byte \alt_len
 .endm
 
+.macro ALTERNATIVE feat, orig, alt
+0:
+	\orig
+1:
+	.skip -(((3f-2f)-(1b-0b)) > 0) * ((3f-2f)-(1b-0b)),0x90
+
+	.pushsection .altinstructions,"a"
+	altinstruction_entry 0b,2f,\feat,1b-0b,3f-2f
+	.popsection
+
+	.pushsection .altinstr_replacement,"ax"
+2:
+	\alt
+3:
+	.popsection
+.endm
+
+.macro ALTERNATIVE_2 feat1, feat2, orig, alt1, alt2
+0:
+	\orig
+1:
+	.skip -(((3f-2f)-(1b-0b)) > 0) * ((3f-2f)-(1b-0b)),0x90
+	.skip -(((4f-3f)-(3f-2f)) > 0) * ((4f-3f)-(3f-2f)),0x90
+
+	.pushsection .altinstructions,"a"
+	altinstruction_entry 0b,2f,\feat1,1b-0b,3f-2f
+	altinstruction_entry 0b,3f,\feat2,1b-0b,4f-3f
+	.popsection
+
+	.pushsection .altinstr_replacement,"ax"
+2:
+	\alt1
+3:
+	\alt2
+4:
+	.popsection
+.endm
+
 #endif  /*  __ASSEMBLY__  */
 
 #endif /* _ASM_X86_ALTERNATIVE_ASM_H */
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 1db37780a344..b9ea801bd3ed 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -481,13 +481,7 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 static __always_inline __pure bool _static_cpu_has_safe(u16 bit)
 {
 #ifdef CC_HAVE_ASM_GOTO
-/*
- * We need to spell the jumps to the compiler because, depending on the offset,
- * the replacement jump can be bigger than the original jump, and this we cannot
- * have. Thus, we force the jump to the widest, 4-byte, signed relative
- * offset even though the last would often fit in less bytes.
- */
-		asm_volatile_goto("1: .byte 0xe9\n .long %l[t_dynamic] - 2f\n"
+		asm_volatile_goto("1: jmp %l[t_dynamic]\n"
 			 "2:\n"
 			 ".skip -(((4f-3f) - (2b-1b)) > 0) * "
 			         "((4f-3f) - (2b-1b)),0x90\n"
@@ -499,7 +493,7 @@ static __always_inline __pure bool _static_cpu_has_safe(u16 bit)
 			 " .byte 4f - 3f\n"		/* repl len */
 			 ".previous\n"
 			 ".section .altinstr_replacement,\"ax\"\n"
-			 "3: .byte 0xe9\n .long %l[t_no] - 2b\n"
+			 "3: jmp %l[t_no]\n"
 			 "4:\n"
 			 ".previous\n"
 			 ".section .altinstructions,\"a\"\n"
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index c99b0f13a90e..974602c1e20d 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -244,6 +244,80 @@ extern s32 __smp_locks[], __smp_locks_end[];
 void *text_poke_early(void *addr, const void *opcode, size_t len);
 
 /*
+ * Are we looking at a near JMP with a 1,2, or 4-byte displacement.
+ */
+static inline bool is_jmp(const u8 opcode)
+{
+	return opcode == 0xeb || opcode == 0xe9;
+}
+
+static size_t __init_or_module recompute_jumps(struct alt_instr *a, u8 *insnbuf)
+{
+	u8 *next_rip, *tgt_rip;
+	s32 displ, new_displ;
+	size_t ret = 0;
+
+	if (debug_alternative) {
+		int i;
+
+		printk(KERN_DEBUG "alt_insn: ");
+		for (i = 0; i < a->replacementlen; i++)
+			printk(KERN_CONT "%02hhx ", insnbuf[i]);
+		printk(KERN_CONT "\n");
+	}
+
+	/* Already a two-byte JMP */
+	if (a->replacementlen == 2)
+		return ret;
+
+	WARN(a->replacementlen != 5, "WTF replacementlen: %d\n", a->replacementlen);
+
+	/* JMP rel32off */
+	displ = *(s32 *)(insnbuf + 1);
+
+	/*
+	 * Clear out the old instruction in case we end up pasting in a shorter
+	 * one and remnants from the old instruction would confuse us.
+	 */
+	memset(insnbuf, 0x90, a->replacementlen);
+
+	/* next rIP of replacement insn */
+	next_rip  = (u8 *)&a->repl_offset + a->repl_offset + a->replacementlen;
+	/* target rIP of replacement insn */
+	tgt_rip	  = next_rip + displ;
+	/* new displacement */
+	new_displ = tgt_rip - ((u8 *)&a->instr_offset + a->instr_offset);
+
+	if (-128 <= new_displ && new_displ <= 127) {
+		ret = 2;
+		new_displ -= 2;
+
+		insnbuf[0] = 0xeb;
+		insnbuf[1] = (s8)new_displ;
+	} else {
+		ret = 5;
+		new_displ -= 5;
+
+		insnbuf[0] = 0xe9;
+		*(s32 *)&insnbuf[1] = new_displ;
+	}
+
+	DPRINTK("next_rip: %p, tgt_rip: %p, new_displ: 0x%08x, ret len: %ld",
+		next_rip, tgt_rip, new_displ, ret);
+
+	if (debug_alternative) {
+		int i;
+
+		printk(KERN_DEBUG "converted to: ");
+		for (i = 0; i < a->replacementlen; i++)
+			printk(KERN_CONT "%02hhx ", insnbuf[i]);
+		printk(KERN_CONT "\n");
+	}
+
+	return ret;
+}
+
+/*
  * Replace instructions with better alternatives for this CPU type. This runs
  * before SMP is initialized to avoid SMP problems with self modifying code.
  * This implies that asymmetric systems where APs have less capabilities than
@@ -268,6 +342,8 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 	 * order.
 	 */
 	for (a = start; a < end; a++) {
+		size_t insnbuf_len = 0;
+
 		instr = (u8 *)&a->instr_offset + a->instr_offset;
 		replacement = (u8 *)&a->repl_offset + a->repl_offset;
 		BUG_ON(a->instrlen > sizeof(insnbuf));
@@ -289,16 +365,19 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 			DPRINTK("Fix CALL offset: 0x%x", *(s32 *)(insnbuf + 1));
 		}
 
+		if (is_jmp(instr[0]) && is_jmp(replacement[0]))
+			insnbuf_len = recompute_jumps(a, insnbuf);
+
 		if (a->instrlen > a->replacementlen)
 			add_nops(insnbuf + a->replacementlen,
 				 a->instrlen - a->replacementlen);
 
-		text_poke_early(instr, insnbuf, a->instrlen);
+		text_poke_early(instr, insnbuf,
+				(insnbuf_len > 0 ? insnbuf_len : a->instrlen));
 	}
 }
 
 #ifdef CONFIG_SMP
-
 static void alternatives_smp_lock(const s32 *start, const s32 *end,
 				  u8 *text, u8 *text_end)
 {
@@ -449,7 +528,7 @@ int alternatives_text_reserved(void *start, void *end)
 
 	return 0;
 }
-#endif
+#endif /* CONFIG_SMP */
 
 #ifdef CONFIG_PARAVIRT
 void __init_or_module apply_paravirt(struct paravirt_patch_site *start,
diff --git a/arch/x86/lib/copy_page_64.S b/arch/x86/lib/copy_page_64.S
index 176cca67212b..9d8b1b8da251 100644
--- a/arch/x86/lib/copy_page_64.S
+++ b/arch/x86/lib/copy_page_64.S
@@ -2,23 +2,35 @@
 
 #include <linux/linkage.h>
 #include <asm/dwarf2.h>
+#include <asm/cpufeature.h>
 #include <asm/alternative-asm.h>
 
+/*
+ * Some CPUs run faster using the string copy instructions. It is also a lot
+ * simpler. Use this when possible
+ */
+
+ENTRY(copy_page)
+	CFI_STARTPROC
+	ALTERNATIVE X86_FEATURE_REP_GOOD, "jmp _copy_page", "jmp _copy_page_rep"
+	CFI_ENDPROC
+ENDPROC(copy_page)
+
 	ALIGN
-copy_page_rep:
+ENTRY(_copy_page_rep)
 	CFI_STARTPROC
 	movl	$4096/8, %ecx
 	rep	movsq
 	ret
 	CFI_ENDPROC
-ENDPROC(copy_page_rep)
+ENDPROC(_copy_page_rep)
 
 /*
  *  Don't use streaming copy unless the CPU indicates X86_FEATURE_REP_GOOD.
  *  Could vary the prefetch distance based on SMP/UP.
 */
 
-ENTRY(copy_page)
+ENTRY(_copy_page)
 	CFI_STARTPROC
 	subq	$2*8,	%rsp
 	CFI_ADJUST_CFA_OFFSET 2*8
@@ -90,21 +102,7 @@ ENTRY(copy_page)
 	addq	$2*8, %rsp
 	CFI_ADJUST_CFA_OFFSET -2*8
 	ret
-.Lcopy_page_end:
 	CFI_ENDPROC
-ENDPROC(copy_page)
-
-	/* Some CPUs run faster using the string copy instructions.
-	   It is also a lot simpler. Use this when possible */
+ENDPROC(_copy_page)
 
-#include <asm/cpufeature.h>
 
-	.section .altinstr_replacement,"ax"
-1:	.byte 0xeb					/* jmp <disp8> */
-	.byte (copy_page_rep - copy_page) - (2f - 1b)	/* offset */
-2:
-	.previous
-	.section .altinstructions,"a"
-	altinstruction_entry copy_page, 1b, X86_FEATURE_REP_GOOD,	\
-		.Lcopy_page_end-copy_page, 2b-1b
-	.previous
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 1530ec2c1b12..3de90e9c9de1 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -16,31 +16,6 @@
 #include <asm/asm.h>
 #include <asm/smap.h>
 
-/*
- * By placing feature2 after feature1 in altinstructions section, we logically
- * implement:
- * If CPU has feature2, jmp to alt2 is used
- * else if CPU has feature1, jmp to alt1 is used
- * else jmp to orig is used.
- */
-	.macro ALTERNATIVE_JUMP feature1,feature2,orig,alt1,alt2
-0:
-	.byte 0xe9	/* 32bit jump */
-	.long \orig-1f	/* by default jump to orig */
-1:
-	.section .altinstr_replacement,"ax"
-2:	.byte 0xe9			/* near jump with 32bit immediate */
-	.long \alt1-1b /* offset */   /* or alternatively to alt1 */
-3:	.byte 0xe9			/* near jump with 32bit immediate */
-	.long \alt2-1b /* offset */   /* or alternatively to alt2 */
-	.previous
-
-	.section .altinstructions,"a"
-	altinstruction_entry 0b,2b,\feature1,5,5
-	altinstruction_entry 0b,3b,\feature2,5,5
-	.previous
-	.endm
-
 	.macro ALIGN_DESTINATION
 	/* check for bad alignment of destination */
 	movl %edi,%ecx
@@ -74,9 +49,10 @@ ENTRY(_copy_to_user)
 	jc bad_to_user
 	cmpq TI_addr_limit(%rax),%rcx
 	ja bad_to_user
-	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,X86_FEATURE_ERMS,	\
-		copy_user_generic_unrolled,copy_user_generic_string,	\
-		copy_user_enhanced_fast_string
+	ALTERNATIVE_2 X86_FEATURE_REP_GOOD,X86_FEATURE_ERMS,	\
+		"jmp copy_user_generic_unrolled",		\
+		"jmp copy_user_generic_string",			\
+		"jmp copy_user_enhanced_fast_string"
 	CFI_ENDPROC
 ENDPROC(_copy_to_user)
 
@@ -89,9 +65,10 @@ ENTRY(_copy_from_user)
 	jc bad_from_user
 	cmpq TI_addr_limit(%rax),%rcx
 	ja bad_from_user
-	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,X86_FEATURE_ERMS,	\
-		copy_user_generic_unrolled,copy_user_generic_string,	\
-		copy_user_enhanced_fast_string
+	ALTERNATIVE_2 X86_FEATURE_REP_GOOD,X86_FEATURE_ERMS,	\
+		"jmp copy_user_generic_unrolled",		\
+		"jmp copy_user_generic_string",			\
+		"jmp copy_user_enhanced_fast_string"
 	CFI_ENDPROC
 ENDPROC(_copy_from_user)
 
-- 
2.2.0.33.gc18b867


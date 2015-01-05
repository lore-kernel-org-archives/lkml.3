Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbbAEPBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:01:48 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51563 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbbAEPAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:00:17 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 3/4] alternatives: Add instruction padding
Date: Mon,  5 Jan 2015 16:00:12 +0100
Message-Id: <1420470013-26413-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.2.0.33.gc18b867
In-Reply-To: <1420470013-26413-1-git-send-email-bp@alien8.de>
References: <1420470013-26413-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Up until now we have always paid attention to make sure the length of
the new instruction replacing the old one is at least less or equal to
the length of the old instruction. If the new instruction is longer, at
the time it replaces the old instruction it will overwrite the beginning
of the next instruction in the kernel image and cause your pants to
catch fire.

So instead of having to pay attention, teach the alternatives framework
to pad shorter old instructions with NOPs at buildtime - but only in the
case when

len(old instruction(s)) < len(new instruction(s))

and add nothing in the >= case. (In that case we do add_nops() when
patching).

This way the alternatives user shouldn't have to care about instruction
sizes and simply use the macros.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/alternative.h | 34 ++++++++++++++++++----------------
 arch/x86/include/asm/cpufeature.h  |  2 ++
 arch/x86/kernel/alternative.c      |  6 +++---
 3 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 473bdbee378a..2b08c417e357 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -76,13 +76,25 @@ static inline int alternatives_text_reserved(void *start, void *end)
 }
 #endif	/* CONFIG_SMP */
 
-#define OLDINSTR(oldinstr)	"661:\n\t" oldinstr "\n662:\n"
-
 #define b_replacement(number)	"663"#number
 #define e_replacement(number)	"664"#number
 
-#define alt_slen "662b-661b"
-#define alt_rlen(number) e_replacement(number)"f-"b_replacement(number)"f"
+#define alt_slen		 "662b-661b"
+#define alt_rlen(number)	e_replacement(number)"f-"b_replacement(number)"f"
+
+#define OLDINSTR(oldinstr, num)						\
+	"661:\n\t" oldinstr "\n662:\n"					\
+	".skip -(((" alt_rlen(num) ")-(" alt_slen ")) > 0) * "		\
+		"((" alt_rlen(num) ")-(" alt_slen ")),0x90\n"
+
+/*
+ * Pad the second replacement alternative with additional NOPs if it is
+ * additionally longer than the first replacement alternative.
+ */
+#define OLDINSTR_2(oldinstr, num1, num2)				\
+	OLDINSTR(oldinstr, num1)					\
+	".skip -(((" alt_rlen(num2) ")-(" alt_rlen(num1) ")) > 0) * "	\
+		"((" alt_rlen(num2) ")-(" alt_rlen(num1) ")),0x90\n"
 
 #define ALTINSTR_ENTRY(feature, number)					      \
 	" .long 661b - .\n"				/* label           */ \
@@ -91,35 +103,25 @@ static inline int alternatives_text_reserved(void *start, void *end)
 	" .byte " alt_slen "\n"				/* source len      */ \
 	" .byte " alt_rlen(number) "\n"			/* replacement len */
 
-#define DISCARD_ENTRY(number)				/* rlen <= slen */    \
-	" .byte 0xff + (" alt_rlen(number) ") - (" alt_slen ")\n"
-
 #define ALTINSTR_REPLACEMENT(newinstr, feature, number)	/* replacement */     \
 	b_replacement(number)":\n\t" newinstr "\n" e_replacement(number) ":\n\t"
 
 /* alternative assembly primitive: */
 #define ALTERNATIVE(oldinstr, newinstr, feature)			\
-	OLDINSTR(oldinstr)						\
+	OLDINSTR(oldinstr, 1)						\
 	".pushsection .altinstructions,\"a\"\n"				\
 	ALTINSTR_ENTRY(feature, 1)					\
 	".popsection\n"							\
-	".pushsection .discard,\"aw\",@progbits\n"			\
-	DISCARD_ENTRY(1)						\
-	".popsection\n"							\
 	".pushsection .altinstr_replacement, \"ax\"\n"			\
 	ALTINSTR_REPLACEMENT(newinstr, feature, 1)			\
 	".popsection"
 
 #define ALTERNATIVE_2(oldinstr, newinstr1, feature1, newinstr2, feature2)\
-	OLDINSTR(oldinstr)						\
+	OLDINSTR_2(oldinstr, 1, 2)					\
 	".pushsection .altinstructions,\"a\"\n"				\
 	ALTINSTR_ENTRY(feature1, 1)					\
 	ALTINSTR_ENTRY(feature2, 2)					\
 	".popsection\n"							\
-	".pushsection .discard,\"aw\",@progbits\n"			\
-	DISCARD_ENTRY(1)						\
-	DISCARD_ENTRY(2)						\
-	".popsection\n"							\
 	".pushsection .altinstr_replacement, \"ax\"\n"			\
 	ALTINSTR_REPLACEMENT(newinstr1, feature1, 1)			\
 	ALTINSTR_REPLACEMENT(newinstr2, feature2, 2)			\
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index aede2c347bde..1db37780a344 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -489,6 +489,8 @@ static __always_inline __pure bool _static_cpu_has_safe(u16 bit)
  */
 		asm_volatile_goto("1: .byte 0xe9\n .long %l[t_dynamic] - 2f\n"
 			 "2:\n"
+			 ".skip -(((4f-3f) - (2b-1b)) > 0) * "
+			         "((4f-3f) - (2b-1b)),0x90\n"
 			 ".section .altinstructions,\"a\"\n"
 			 " .long 1b - .\n"		/* src offset */
 			 " .long 3f - .\n"		/* repl offset */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 1e86e85bcf58..c99b0f13a90e 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -270,7 +270,6 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 	for (a = start; a < end; a++) {
 		instr = (u8 *)&a->instr_offset + a->instr_offset;
 		replacement = (u8 *)&a->repl_offset + a->repl_offset;
-		BUG_ON(a->replacementlen > a->instrlen);
 		BUG_ON(a->instrlen > sizeof(insnbuf));
 		BUG_ON(a->cpuid >= (NCAPINTS + NBUGINTS) * 32);
 		if (!boot_cpu_has(a->cpuid))
@@ -290,8 +289,9 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 			DPRINTK("Fix CALL offset: 0x%x", *(s32 *)(insnbuf + 1));
 		}
 
-		add_nops(insnbuf + a->replacementlen,
-			 a->instrlen - a->replacementlen);
+		if (a->instrlen > a->replacementlen)
+			add_nops(insnbuf + a->replacementlen,
+				 a->instrlen - a->replacementlen);
 
 		text_poke_early(instr, insnbuf, a->instrlen);
 	}
-- 
2.2.0.33.gc18b867


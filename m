Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030944Ab3HITve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:51:34 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:62759 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030877Ab3HITvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:51:32 -0400
Message-ID: <201308091951.r79JpVoM030988@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 9 Aug 2013 15:38:43 -0400
Subject: [PATCH] tile: use proper .align directives on __ex_table sections
To: <linux-kernel@vger.kernel.org>
CC: Simon Marchi <simon.marchi@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This may fix a reported bug where an R_TILEGX_64 in a module was not
pointing to an aligned address.

Reported-by: Simon Marchi <simon.marchi@polymtl.ca>
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/futex.h   | 1 +
 arch/tile/include/asm/uaccess.h | 6 ++++++
 arch/tile/lib/atomic_asm_32.S   | 1 +
 arch/tile/lib/memcpy_32.S       | 2 ++
 arch/tile/lib/memcpy_user_64.c  | 2 ++
 arch/tile/lib/usercopy_32.S     | 6 ++++++
 arch/tile/lib/usercopy_64.S     | 6 ++++++
 7 files changed, 24 insertions(+)

diff --git a/arch/tile/include/asm/futex.h b/arch/tile/include/asm/futex.h
index 5909ac3..1a6ef1b 100644
--- a/arch/tile/include/asm/futex.h
+++ b/arch/tile/include/asm/futex.h
@@ -43,6 +43,7 @@
 	    ".pushsection .fixup,\"ax\"\n"			\
 	    "0: { movei %0, %5; j 9f }\n"			\
 	    ".section __ex_table,\"a\"\n"			\
+	    ".align 8\n"					\
 	    ".quad 1b, 0b\n"					\
 	    ".popsection\n"					\
 	    "9:"						\
diff --git a/arch/tile/include/asm/uaccess.h b/arch/tile/include/asm/uaccess.h
index f68503f..b6cde32 100644
--- a/arch/tile/include/asm/uaccess.h
+++ b/arch/tile/include/asm/uaccess.h
@@ -127,8 +127,10 @@ extern int fixup_exception(struct pt_regs *regs);
 
 #ifdef __LP64__
 #define _ASM_PTR	".quad"
+#define _ASM_ALIGN	".align 8"
 #else
 #define _ASM_PTR	".long"
+#define _ASM_ALIGN	".align 4"
 #endif
 
 #define __get_user_asm(OP, x, ptr, ret)					\
@@ -137,6 +139,7 @@ extern int fixup_exception(struct pt_regs *regs);
 		     "0: { movei %1, 0; movei %0, %3 }\n"		\
 		     "j 9f\n"						\
 		     ".section __ex_table,\"a\"\n"			\
+		     _ASM_ALIGN "\n"					\
 		     _ASM_PTR " 1b, 0b\n"				\
 		     ".popsection\n"					\
 		     "9:"						\
@@ -168,6 +171,7 @@ extern int fixup_exception(struct pt_regs *regs);
 			     "0: { movei %1, 0; movei %2, 0 }\n"	\
 			     "{ movei %0, %4; j 9f }\n"			\
 			     ".section __ex_table,\"a\"\n"		\
+			     ".align 4\n"				\
 			     ".word 1b, 0b\n"				\
 			     ".word 2b, 0b\n"				\
 			     ".popsection\n"				\
@@ -224,6 +228,7 @@ extern int __get_user_bad(void)
 		     ".pushsection .fixup,\"ax\"\n"			\
 		     "0: { movei %0, %3; j 9f }\n"			\
 		     ".section __ex_table,\"a\"\n"			\
+		     _ASM_ALIGN "\n"					\
 		     _ASM_PTR " 1b, 0b\n"				\
 		     ".popsection\n"					\
 		     "9:"						\
@@ -248,6 +253,7 @@ extern int __get_user_bad(void)
 			     ".pushsection .fixup,\"ax\"\n"		\
 			     "0: { movei %0, %4; j 9f }\n"		\
 			     ".section __ex_table,\"a\"\n"		\
+			     ".align 4\n"				\
 			     ".word 1b, 0b\n"				\
 			     ".word 2b, 0b\n"				\
 			     ".popsection\n"				\
diff --git a/arch/tile/lib/atomic_asm_32.S b/arch/tile/lib/atomic_asm_32.S
index 3063804..6bda313 100644
--- a/arch/tile/lib/atomic_asm_32.S
+++ b/arch/tile/lib/atomic_asm_32.S
@@ -164,6 +164,7 @@ STD_ENTRY_SECTION(__atomic\name, .text.atomic)
 	STD_ENDPROC(__atomic\name)
 	.ifc \bitwidth,32
 	.pushsection __ex_table,"a"
+	.align  4
 	.word   1b, __atomic\name
 	.word   2b, __atomic\name
 	.word   __atomic\name, __atomic_bad_address
diff --git a/arch/tile/lib/memcpy_32.S b/arch/tile/lib/memcpy_32.S
index 2a419a6..8ba7626 100644
--- a/arch/tile/lib/memcpy_32.S
+++ b/arch/tile/lib/memcpy_32.S
@@ -44,6 +44,7 @@
  */
 #define EX \
 	.pushsection __ex_table, "a"; \
+	.align 4; \
 	.word 9f, memcpy_common_fixup; \
 	.popsection; \
 	9
@@ -614,5 +615,6 @@ memcpy_fixup_loop:
 	.size memcpy_common_fixup, . - memcpy_common_fixup
 
 	.section __ex_table,"a"
+	.align 4
 	.word .Lcfu, .Lcopy_from_user_fixup_zero_remainder
 	.word .Lctu, .Lcopy_to_user_fixup_done
diff --git a/arch/tile/lib/memcpy_user_64.c b/arch/tile/lib/memcpy_user_64.c
index 37440ca..88c7016 100644
--- a/arch/tile/lib/memcpy_user_64.c
+++ b/arch/tile/lib/memcpy_user_64.c
@@ -31,6 +31,7 @@
 		    ".pushsection .coldtext.memcpy,\"ax\";"	\
 		    "2: { move r0, %2; jrp lr };"		\
 		    ".section __ex_table,\"a\";"		\
+		    ".align 8;"					\
 		    ".quad 1b, 2b;"				\
 		    ".popsection"				\
 		    : "=m" (*(p)) : "r" (v), "r" (n));		\
@@ -43,6 +44,7 @@
 		    ".pushsection .coldtext.memcpy,\"ax\";"	\
 		    "2: { move r0, %2; jrp lr };"		\
 		    ".section __ex_table,\"a\";"		\
+		    ".align 8;"					\
 		    ".quad 1b, 2b;"				\
 		    ".popsection"				\
 		    : "=r" (__v) : "m" (*(p)), "r" (n));	\
diff --git a/arch/tile/lib/usercopy_32.S b/arch/tile/lib/usercopy_32.S
index 21ffa88..bb4c127b 100644
--- a/arch/tile/lib/usercopy_32.S
+++ b/arch/tile/lib/usercopy_32.S
@@ -36,6 +36,7 @@ strnlen_user_fault:
 	{ move r0, zero; jrp lr }
 	ENDPROC(strnlen_user_fault)
 	.section __ex_table,"a"
+	.align 4
 	.word 1b, strnlen_user_fault
 	.popsection
 
@@ -59,6 +60,7 @@ strncpy_from_user_fault:
 	{ movei r0, -EFAULT; jrp lr }
 	ENDPROC(strncpy_from_user_fault)
 	.section __ex_table,"a"
+	.align 4
 	.word 1b, strncpy_from_user_fault
 	.popsection
 
@@ -77,6 +79,7 @@ STD_ENTRY(clear_user_asm)
 	bnzt r1, 1b
 2:      { move r0, r1; jrp lr }
 	.pushsection __ex_table,"a"
+	.align 4
 	.word 1b, 2b
 	.popsection
 
@@ -86,6 +89,7 @@ STD_ENTRY(clear_user_asm)
 2:      { move r0, r1; jrp lr }
 	STD_ENDPROC(clear_user_asm)
 	.pushsection __ex_table,"a"
+	.align 4
 	.word 1b, 2b
 	.popsection
 
@@ -105,6 +109,7 @@ STD_ENTRY(flush_user_asm)
 2:      { move r0, r1; jrp lr }
 	STD_ENDPROC(flush_user_asm)
 	.pushsection __ex_table,"a"
+	.align 4
 	.word 1b, 2b
 	.popsection
 
@@ -124,5 +129,6 @@ STD_ENTRY(finv_user_asm)
 2:      { move r0, r1; jrp lr }
 	STD_ENDPROC(finv_user_asm)
 	.pushsection __ex_table,"a"
+	.align 4
 	.word 1b, 2b
 	.popsection
diff --git a/arch/tile/lib/usercopy_64.S b/arch/tile/lib/usercopy_64.S
index f248d31..0d94844e 100644
--- a/arch/tile/lib/usercopy_64.S
+++ b/arch/tile/lib/usercopy_64.S
@@ -36,6 +36,7 @@ strnlen_user_fault:
 	{ move r0, zero; jrp lr }
 	ENDPROC(strnlen_user_fault)
 	.section __ex_table,"a"
+	.align 8
 	.quad 1b, strnlen_user_fault
 	.popsection
 
@@ -59,6 +60,7 @@ strncpy_from_user_fault:
 	{ movei r0, -EFAULT; jrp lr }
 	ENDPROC(strncpy_from_user_fault)
 	.section __ex_table,"a"
+	.align 8
 	.quad 1b, strncpy_from_user_fault
 	.popsection
 
@@ -77,6 +79,7 @@ STD_ENTRY(clear_user_asm)
 	bnezt r1, 1b
 2:      { move r0, r1; jrp lr }
 	.pushsection __ex_table,"a"
+	.align 8
 	.quad 1b, 2b
 	.popsection
 
@@ -86,6 +89,7 @@ STD_ENTRY(clear_user_asm)
 2:      { move r0, r1; jrp lr }
 	STD_ENDPROC(clear_user_asm)
 	.pushsection __ex_table,"a"
+	.align 8
 	.quad 1b, 2b
 	.popsection
 
@@ -105,6 +109,7 @@ STD_ENTRY(flush_user_asm)
 2:      { move r0, r1; jrp lr }
 	STD_ENDPROC(flush_user_asm)
 	.pushsection __ex_table,"a"
+	.align 8
 	.quad 1b, 2b
 	.popsection
 
@@ -124,5 +129,6 @@ STD_ENTRY(finv_user_asm)
 2:      { move r0, r1; jrp lr }
 	STD_ENDPROC(finv_user_asm)
 	.pushsection __ex_table,"a"
+	.align 8
 	.quad 1b, 2b
 	.popsection
-- 
1.8.3.1


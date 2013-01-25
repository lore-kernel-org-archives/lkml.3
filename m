Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab3AYKlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:41:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40846 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab3AYKlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:41:45 -0500
Date: Fri, 25 Jan 2013 02:41:25 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-e8f6e3f8a14bae98197c6d9f280cd23d22eb1a33@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, jbeulich@suse.com, JBeulich@suse.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, JBeulich@suse.com, jbeulich@suse.com,
        tglx@linutronix.de
In-Reply-To: <5093E47602000078000A615B@nat28.tlf.novell.com>
References: <5093E47602000078000A615B@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86/xor: Unify SSE-base xor-block routines
Git-Commit-ID: e8f6e3f8a14bae98197c6d9f280cd23d22eb1a33
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 02:41:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e8f6e3f8a14bae98197c6d9f280cd23d22eb1a33
Gitweb:     http://git.kernel.org/tip/e8f6e3f8a14bae98197c6d9f280cd23d22eb1a33
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 2 Nov 2012 14:19:18 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 25 Jan 2013 09:23:50 +0100

x86/xor: Unify SSE-base xor-block routines

Besides folding duplicate code, this has the advantage of fixing
x86-64's failure to use proper (para-virtualizable) accessors
for dealing with CR0.TS.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/5093E47602000078000A615B@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/xor.h    | 319 +++++++++++++++++++++++++++++++++++++++++-
 arch/x86/include/asm/xor_32.h | 286 +------------------------------------
 arch/x86/include/asm/xor_64.h | 295 --------------------------------------
 3 files changed, 319 insertions(+), 581 deletions(-)

diff --git a/arch/x86/include/asm/xor.h b/arch/x86/include/asm/xor.h
index f8fde90..c661571 100644
--- a/arch/x86/include/asm/xor.h
+++ b/arch/x86/include/asm/xor.h
@@ -1,10 +1,327 @@
 #ifdef CONFIG_KMEMCHECK
 /* kmemcheck doesn't handle MMX/SSE/SSE2 instructions */
 # include <asm-generic/xor.h>
+#elif !defined(_ASM_X86_XOR_H)
+#define _ASM_X86_XOR_H
+
+/*
+ * Optimized RAID-5 checksumming functions for SSE.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * You should have received a copy of the GNU General Public License
+ * (for example /usr/src/linux/COPYING); if not, write to the Free
+ * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+/*
+ * Cache avoiding checksumming functions utilizing KNI instructions
+ * Copyright (C) 1999 Zach Brown (with obvious credit due Ingo)
+ */
+
+/*
+ * Based on
+ * High-speed RAID5 checksumming functions utilizing SSE instructions.
+ * Copyright (C) 1998 Ingo Molnar.
+ */
+
+/*
+ * x86-64 changes / gcc fixes from Andi Kleen.
+ * Copyright 2002 Andi Kleen, SuSE Labs.
+ *
+ * This hasn't been optimized for the hammer yet, but there are likely
+ * no advantages to be gotten from x86-64 here anyways.
+ */
+
+#include <asm/i387.h>
+
+#ifdef CONFIG_X86_32
+/* reduce register pressure */
+# define XOR_CONSTANT_CONSTRAINT "i"
 #else
+# define XOR_CONSTANT_CONSTRAINT "re"
+#endif
+
+#define OFFS(x)		"16*("#x")"
+#define PF_OFFS(x)	"256+16*("#x")"
+#define PF0(x)		"	prefetchnta "PF_OFFS(x)"(%[p1])		;\n"
+#define LD(x, y)	"	movaps "OFFS(x)"(%[p1]), %%xmm"#y"	;\n"
+#define ST(x, y)	"	movaps %%xmm"#y", "OFFS(x)"(%[p1])	;\n"
+#define PF1(x)		"	prefetchnta "PF_OFFS(x)"(%[p2])		;\n"
+#define PF2(x)		"	prefetchnta "PF_OFFS(x)"(%[p3])		;\n"
+#define PF3(x)		"	prefetchnta "PF_OFFS(x)"(%[p4])		;\n"
+#define PF4(x)		"	prefetchnta "PF_OFFS(x)"(%[p5])		;\n"
+#define XO1(x, y)	"	xorps "OFFS(x)"(%[p2]), %%xmm"#y"	;\n"
+#define XO2(x, y)	"	xorps "OFFS(x)"(%[p3]), %%xmm"#y"	;\n"
+#define XO3(x, y)	"	xorps "OFFS(x)"(%[p4]), %%xmm"#y"	;\n"
+#define XO4(x, y)	"	xorps "OFFS(x)"(%[p5]), %%xmm"#y"	;\n"
+
+static void
+xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i)					\
+		LD(i, 0)				\
+			LD(i + 1, 1)			\
+		PF1(i)					\
+				PF1(i + 2)		\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
+		XO1(i, 0)				\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
+		ST(i, 0)				\
+			ST(i + 1, 1)			\
+				ST(i + 2, 2)		\
+					ST(i + 3, 3)	\
+
+
+		PF0(0)
+				PF0(2)
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines),
+	  [p1] "+r" (p1), [p2] "+r" (p2)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	kernel_fpu_end();
+}
+
+static void
+xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
+	  unsigned long *p3)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i) \
+		PF1(i)					\
+				PF1(i + 2)		\
+		LD(i, 0)				\
+			LD(i + 1, 1)			\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
+		PF2(i)					\
+				PF2(i + 2)		\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
+		XO1(i, 0)				\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
+		XO2(i, 0)				\
+			XO2(i + 1, 1)			\
+				XO2(i + 2, 2)		\
+					XO2(i + 3, 3)	\
+		ST(i, 0)				\
+			ST(i + 1, 1)			\
+				ST(i + 2, 2)		\
+					ST(i + 3, 3)	\
+
+
+		PF0(0)
+				PF0(2)
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       add %[inc], %[p3]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines),
+	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	kernel_fpu_end();
+}
+
+static void
+xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
+	  unsigned long *p3, unsigned long *p4)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i) \
+		PF1(i)					\
+				PF1(i + 2)		\
+		LD(i, 0)				\
+			LD(i + 1, 1)			\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
+		PF2(i)					\
+				PF2(i + 2)		\
+		XO1(i, 0)				\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
+		PF3(i)					\
+				PF3(i + 2)		\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
+		XO2(i, 0)				\
+			XO2(i + 1, 1)			\
+				XO2(i + 2, 2)		\
+					XO2(i + 3, 3)	\
+		XO3(i, 0)				\
+			XO3(i + 1, 1)			\
+				XO3(i + 2, 2)		\
+					XO3(i + 3, 3)	\
+		ST(i, 0)				\
+			ST(i + 1, 1)			\
+				ST(i + 2, 2)		\
+					ST(i + 3, 3)	\
+
+
+		PF0(0)
+				PF0(2)
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       add %[inc], %[p3]       ;\n"
+	"       add %[inc], %[p4]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines), [p1] "+r" (p1),
+	  [p2] "+r" (p2), [p3] "+r" (p3), [p4] "+r" (p4)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	kernel_fpu_end();
+}
+
+static void
+xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
+	  unsigned long *p3, unsigned long *p4, unsigned long *p5)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i) \
+		PF1(i)					\
+				PF1(i + 2)		\
+		LD(i, 0)				\
+			LD(i + 1, 1)			\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
+		PF2(i)					\
+				PF2(i + 2)		\
+		XO1(i, 0)				\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
+		PF3(i)					\
+				PF3(i + 2)		\
+		XO2(i, 0)				\
+			XO2(i + 1, 1)			\
+				XO2(i + 2, 2)		\
+					XO2(i + 3, 3)	\
+		PF4(i)					\
+				PF4(i + 2)		\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
+		XO3(i, 0)				\
+			XO3(i + 1, 1)			\
+				XO3(i + 2, 2)		\
+					XO3(i + 3, 3)	\
+		XO4(i, 0)				\
+			XO4(i + 1, 1)			\
+				XO4(i + 2, 2)		\
+					XO4(i + 3, 3)	\
+		ST(i, 0)				\
+			ST(i + 1, 1)			\
+				ST(i + 2, 2)		\
+					ST(i + 3, 3)	\
+
+
+		PF0(0)
+				PF0(2)
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       add %[inc], %[p3]       ;\n"
+	"       add %[inc], %[p4]       ;\n"
+	"       add %[inc], %[p5]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines), [p1] "+r" (p1), [p2] "+r" (p2),
+	  [p3] "+r" (p3), [p4] "+r" (p4), [p5] "+r" (p5)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	kernel_fpu_end();
+}
+
+#undef LD
+#undef XO1
+#undef XO2
+#undef XO3
+#undef XO4
+#undef ST
+#undef BLOCK
+
+#undef XOR_CONSTANT_CONSTRAINT
+
 #ifdef CONFIG_X86_32
 # include <asm/xor_32.h>
 #else
 # include <asm/xor_64.h>
 #endif
-#endif
+
+#endif /* _ASM_X86_XOR_H */
diff --git a/arch/x86/include/asm/xor_32.h b/arch/x86/include/asm/xor_32.h
index f79cb7e..b85dc87 100644
--- a/arch/x86/include/asm/xor_32.h
+++ b/arch/x86/include/asm/xor_32.h
@@ -2,7 +2,7 @@
 #define _ASM_X86_XOR_32_H
 
 /*
- * Optimized RAID-5 checksumming functions for MMX and SSE.
+ * Optimized RAID-5 checksumming functions for MMX.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -529,290 +529,6 @@ static struct xor_block_template xor_block_p5_mmx = {
 	.do_5 = xor_p5_mmx_5,
 };
 
-/*
- * Cache avoiding checksumming functions utilizing KNI instructions
- * Copyright (C) 1999 Zach Brown (with obvious credit due Ingo)
- */
-
-#define OFFS(x)		"16*("#x")"
-#define PF_OFFS(x)	"256+16*("#x")"
-#define	PF0(x)		"	prefetchnta "PF_OFFS(x)"(%1)		;\n"
-#define LD(x, y)	"       movaps   "OFFS(x)"(%1), %%xmm"#y"	;\n"
-#define ST(x, y)	"       movaps %%xmm"#y",   "OFFS(x)"(%1)	;\n"
-#define PF1(x)		"	prefetchnta "PF_OFFS(x)"(%2)		;\n"
-#define PF2(x)		"	prefetchnta "PF_OFFS(x)"(%3)		;\n"
-#define PF3(x)		"	prefetchnta "PF_OFFS(x)"(%4)		;\n"
-#define PF4(x)		"	prefetchnta "PF_OFFS(x)"(%5)		;\n"
-#define PF5(x)		"	prefetchnta "PF_OFFS(x)"(%6)		;\n"
-#define XO1(x, y)	"       xorps   "OFFS(x)"(%2), %%xmm"#y"	;\n"
-#define XO2(x, y)	"       xorps   "OFFS(x)"(%3), %%xmm"#y"	;\n"
-#define XO3(x, y)	"       xorps   "OFFS(x)"(%4), %%xmm"#y"	;\n"
-#define XO4(x, y)	"       xorps   "OFFS(x)"(%5), %%xmm"#y"	;\n"
-#define XO5(x, y)	"       xorps   "OFFS(x)"(%6), %%xmm"#y"	;\n"
-
-
-static void
-xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
-{
-	unsigned long lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i)					\
-		LD(i, 0)				\
-			LD(i + 1, 1)			\
-		PF1(i)					\
-				PF1(i + 2)		\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO1(i, 0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		ST(i, 0)				\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addl $256, %1           ;\n"
-	"       addl $256, %2           ;\n"
-	"       decl %0                 ;\n"
-	"       jnz 1b                  ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2)
-	:
-	: "memory");
-
-	kernel_fpu_end();
-}
-
-static void
-xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
-	  unsigned long *p3)
-{
-	unsigned long lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		PF1(i)					\
-				PF1(i + 2)		\
-		LD(i,0)					\
-			LD(i + 1, 1)			\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF2(i)					\
-				PF2(i + 2)		\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO1(i,0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		XO2(i,0)				\
-			XO2(i + 1, 1)			\
-				XO2(i + 2, 2)		\
-					XO2(i + 3, 3)	\
-		ST(i,0)					\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addl $256, %1           ;\n"
-	"       addl $256, %2           ;\n"
-	"       addl $256, %3           ;\n"
-	"       decl %0                 ;\n"
-	"       jnz 1b                  ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r"(p2), "+r"(p3)
-	:
-	: "memory" );
-
-	kernel_fpu_end();
-}
-
-static void
-xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
-	  unsigned long *p3, unsigned long *p4)
-{
-	unsigned long lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		PF1(i)					\
-				PF1(i + 2)		\
-		LD(i,0)					\
-			LD(i + 1, 1)			\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF2(i)					\
-				PF2(i + 2)		\
-		XO1(i,0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		PF3(i)					\
-				PF3(i + 2)		\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO2(i,0)				\
-			XO2(i + 1, 1)			\
-				XO2(i + 2, 2)		\
-					XO2(i + 3, 3)	\
-		XO3(i,0)				\
-			XO3(i + 1, 1)			\
-				XO3(i + 2, 2)		\
-					XO3(i + 3, 3)	\
-		ST(i,0)					\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addl $256, %1           ;\n"
-	"       addl $256, %2           ;\n"
-	"       addl $256, %3           ;\n"
-	"       addl $256, %4           ;\n"
-	"       decl %0                 ;\n"
-	"       jnz 1b                  ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2), "+r" (p3), "+r" (p4)
-	:
-	: "memory" );
-
-	kernel_fpu_end();
-}
-
-static void
-xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
-	  unsigned long *p3, unsigned long *p4, unsigned long *p5)
-{
-	unsigned long lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	/* Make sure GCC forgets anything it knows about p4 or p5,
-	   such that it won't pass to the asm volatile below a
-	   register that is shared with any other variable.  That's
-	   because we modify p4 and p5 there, but we can't mark them
-	   as read/write, otherwise we'd overflow the 10-asm-operands
-	   limit of GCC < 3.1.  */
-	asm("" : "+r" (p4), "+r" (p5));
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		PF1(i)					\
-				PF1(i + 2)		\
-		LD(i,0)					\
-			LD(i + 1, 1)			\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF2(i)					\
-				PF2(i + 2)		\
-		XO1(i,0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		PF3(i)					\
-				PF3(i + 2)		\
-		XO2(i,0)				\
-			XO2(i + 1, 1)			\
-				XO2(i + 2, 2)		\
-					XO2(i + 3, 3)	\
-		PF4(i)					\
-				PF4(i + 2)		\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO3(i,0)				\
-			XO3(i + 1, 1)			\
-				XO3(i + 2, 2)		\
-					XO3(i + 3, 3)	\
-		XO4(i,0)				\
-			XO4(i + 1, 1)			\
-				XO4(i + 2, 2)		\
-					XO4(i + 3, 3)	\
-		ST(i,0)					\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addl $256, %1           ;\n"
-	"       addl $256, %2           ;\n"
-	"       addl $256, %3           ;\n"
-	"       addl $256, %4           ;\n"
-	"       addl $256, %5           ;\n"
-	"       decl %0                 ;\n"
-	"       jnz 1b                  ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2), "+r" (p3)
-	: "r" (p4), "r" (p5)
-	: "memory");
-
-	/* p4 and p5 were modified, and now the variables are dead.
-	   Clobber them just to be sure nobody does something stupid
-	   like assuming they have some legal value.  */
-	asm("" : "=r" (p4), "=r" (p5));
-
-	kernel_fpu_end();
-}
-
 static struct xor_block_template xor_block_pIII_sse = {
 	.name = "pIII_sse",
 	.do_2 = xor_sse_2,
diff --git a/arch/x86/include/asm/xor_64.h b/arch/x86/include/asm/xor_64.h
index 87ac522..1baf89d 100644
--- a/arch/x86/include/asm/xor_64.h
+++ b/arch/x86/include/asm/xor_64.h
@@ -1,301 +1,6 @@
 #ifndef _ASM_X86_XOR_64_H
 #define _ASM_X86_XOR_64_H
 
-/*
- * Optimized RAID-5 checksumming functions for MMX and SSE.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * You should have received a copy of the GNU General Public License
- * (for example /usr/src/linux/COPYING); if not, write to the Free
- * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-
-/*
- * Cache avoiding checksumming functions utilizing KNI instructions
- * Copyright (C) 1999 Zach Brown (with obvious credit due Ingo)
- */
-
-/*
- * Based on
- * High-speed RAID5 checksumming functions utilizing SSE instructions.
- * Copyright (C) 1998 Ingo Molnar.
- */
-
-/*
- * x86-64 changes / gcc fixes from Andi Kleen.
- * Copyright 2002 Andi Kleen, SuSE Labs.
- *
- * This hasn't been optimized for the hammer yet, but there are likely
- * no advantages to be gotten from x86-64 here anyways.
- */
-
-#include <asm/i387.h>
-
-#define OFFS(x)		"16*("#x")"
-#define PF_OFFS(x)	"256+16*("#x")"
-#define	PF0(x)		"	prefetchnta "PF_OFFS(x)"(%[p1])		;\n"
-#define LD(x, y)	"       movaps   "OFFS(x)"(%[p1]), %%xmm"#y"	;\n"
-#define ST(x, y)	"       movaps %%xmm"#y",   "OFFS(x)"(%[p1])	;\n"
-#define PF1(x)		"	prefetchnta "PF_OFFS(x)"(%[p2])		;\n"
-#define PF2(x)		"	prefetchnta "PF_OFFS(x)"(%[p3])		;\n"
-#define PF3(x)		"	prefetchnta "PF_OFFS(x)"(%[p4])		;\n"
-#define PF4(x)		"	prefetchnta "PF_OFFS(x)"(%[p5])		;\n"
-#define PF5(x)		"	prefetchnta "PF_OFFS(x)"(%[p6])		;\n"
-#define XO1(x, y)	"       xorps   "OFFS(x)"(%[p2]), %%xmm"#y"	;\n"
-#define XO2(x, y)	"       xorps   "OFFS(x)"(%[p3]), %%xmm"#y"	;\n"
-#define XO3(x, y)	"       xorps   "OFFS(x)"(%[p4]), %%xmm"#y"	;\n"
-#define XO4(x, y)	"       xorps   "OFFS(x)"(%[p5]), %%xmm"#y"	;\n"
-#define XO5(x, y)	"       xorps   "OFFS(x)"(%[p6]), %%xmm"#y"	;\n"
-
-
-static void
-xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
-{
-	unsigned int lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		LD(i, 0)				\
-			LD(i + 1, 1)			\
-		PF1(i)					\
-				PF1(i + 2)		\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO1(i, 0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		ST(i, 0)				\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addq %[inc], %[p1]           ;\n"
-	"       addq %[inc], %[p2]           ;\n"
-		"		decl %[cnt] ; jnz 1b"
-	: [p1] "+r" (p1), [p2] "+r" (p2), [cnt] "+r" (lines)
-	: [inc] "r" (256UL)
-	: "memory");
-
-	kernel_fpu_end();
-}
-
-static void
-xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
-	  unsigned long *p3)
-{
-	unsigned int lines = bytes >> 8;
-
-	kernel_fpu_begin();
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		PF1(i)					\
-				PF1(i + 2)		\
-		LD(i, 0)					\
-			LD(i + 1, 1)			\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF2(i)					\
-				PF2(i + 2)		\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO1(i, 0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		XO2(i, 0)				\
-			XO2(i + 1, 1)			\
-				XO2(i + 2, 2)		\
-					XO2(i + 3, 3)	\
-		ST(i, 0)				\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addq %[inc], %[p1]           ;\n"
-	"       addq %[inc], %[p2]          ;\n"
-	"       addq %[inc], %[p3]           ;\n"
-		"		decl %[cnt] ; jnz 1b"
-	: [cnt] "+r" (lines),
-	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3)
-	: [inc] "r" (256UL)
-	: "memory");
-	kernel_fpu_end();
-}
-
-static void
-xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
-	  unsigned long *p3, unsigned long *p4)
-{
-	unsigned int lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		PF1(i)					\
-				PF1(i + 2)		\
-		LD(i, 0)				\
-			LD(i + 1, 1)			\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF2(i)					\
-				PF2(i + 2)		\
-		XO1(i, 0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		PF3(i)					\
-				PF3(i + 2)		\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO2(i, 0)				\
-			XO2(i + 1, 1)			\
-				XO2(i + 2, 2)		\
-					XO2(i + 3, 3)	\
-		XO3(i, 0)				\
-			XO3(i + 1, 1)			\
-				XO3(i + 2, 2)		\
-					XO3(i + 3, 3)	\
-		ST(i, 0)				\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addq %[inc], %[p1]           ;\n"
-	"       addq %[inc], %[p2]           ;\n"
-	"       addq %[inc], %[p3]           ;\n"
-	"       addq %[inc], %[p4]           ;\n"
-	"	decl %[cnt] ; jnz 1b"
-	: [cnt] "+c" (lines),
-	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3), [p4] "+r" (p4)
-	: [inc] "r" (256UL)
-	: "memory" );
-
-	kernel_fpu_end();
-}
-
-static void
-xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
-	  unsigned long *p3, unsigned long *p4, unsigned long *p5)
-{
-	unsigned int lines = bytes >> 8;
-
-	kernel_fpu_begin();
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		PF1(i)					\
-				PF1(i + 2)		\
-		LD(i, 0)				\
-			LD(i + 1, 1)			\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF2(i)					\
-				PF2(i + 2)		\
-		XO1(i, 0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		PF3(i)					\
-				PF3(i + 2)		\
-		XO2(i, 0)				\
-			XO2(i + 1, 1)			\
-				XO2(i + 2, 2)		\
-					XO2(i + 3, 3)	\
-		PF4(i)					\
-				PF4(i + 2)		\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO3(i, 0)				\
-			XO3(i + 1, 1)			\
-				XO3(i + 2, 2)		\
-					XO3(i + 3, 3)	\
-		XO4(i, 0)				\
-			XO4(i + 1, 1)			\
-				XO4(i + 2, 2)		\
-					XO4(i + 3, 3)	\
-		ST(i, 0)				\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addq %[inc], %[p1]           ;\n"
-	"       addq %[inc], %[p2]           ;\n"
-	"       addq %[inc], %[p3]           ;\n"
-	"       addq %[inc], %[p4]           ;\n"
-	"       addq %[inc], %[p5]           ;\n"
-	"	decl %[cnt] ; jnz 1b"
-	: [cnt] "+c" (lines),
-	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3), [p4] "+r" (p4),
-	  [p5] "+r" (p5)
-	: [inc] "r" (256UL)
-	: "memory");
-
-	kernel_fpu_end();
-}
-
 static struct xor_block_template xor_block_sse = {
 	.name = "generic_sse",
 	.do_2 = xor_sse_2,

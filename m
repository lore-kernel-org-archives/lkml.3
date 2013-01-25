Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab3AYKmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:42:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40858 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab3AYKmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:42:51 -0500
Date: Fri, 25 Jan 2013 02:42:35 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-f317820cb6ee3fb173319bf76e0e62437be78ad2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, jbeulich@suse.com, JBeulich@suse.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, JBeulich@suse.com, jbeulich@suse.com,
        tglx@linutronix.de
In-Reply-To: <5093E4B802000078000A615E@nat28.tlf.novell.com>
References: <5093E4B802000078000A615E@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86/xor:
  Add alternative SSE implementation only prefetching once per 64-byte line
Git-Commit-ID: f317820cb6ee3fb173319bf76e0e62437be78ad2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 02:42:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f317820cb6ee3fb173319bf76e0e62437be78ad2
Gitweb:     http://git.kernel.org/tip/f317820cb6ee3fb173319bf76e0e62437be78ad2
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 2 Nov 2012 14:20:24 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 25 Jan 2013 09:23:50 +0100

x86/xor: Add alternative SSE implementation only prefetching once per 64-byte line

On CPUs with 64-byte last level cache lines, this yields roughly
10% better performance, independent of CPU vendor or specific
model (as far as I was able to test).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/5093E4B802000078000A615E@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/xor.h    | 172 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/xor_32.h |  23 +++---
 arch/x86/include/asm/xor_64.h |  10 +--
 3 files changed, 187 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/xor.h b/arch/x86/include/asm/xor.h
index c661571..d882975 100644
--- a/arch/x86/include/asm/xor.h
+++ b/arch/x86/include/asm/xor.h
@@ -58,6 +58,14 @@
 #define XO2(x, y)	"	xorps "OFFS(x)"(%[p3]), %%xmm"#y"	;\n"
 #define XO3(x, y)	"	xorps "OFFS(x)"(%[p4]), %%xmm"#y"	;\n"
 #define XO4(x, y)	"	xorps "OFFS(x)"(%[p5]), %%xmm"#y"	;\n"
+#define NOP(x)
+
+#define BLK64(pf, op, i)				\
+		pf(i)					\
+		op(i, 0)				\
+			op(i + 1, 1)			\
+				op(i + 2, 2)		\
+					op(i + 3, 3)
 
 static void
 xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
@@ -111,6 +119,40 @@ xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
 }
 
 static void
+xor_sse_2_pf64(unsigned long bytes, unsigned long *p1, unsigned long *p2)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i)			\
+		BLK64(PF0, LD, i)	\
+		BLK64(PF1, XO1, i)	\
+		BLK64(NOP, ST, i)	\
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
 xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3)
 {
@@ -170,6 +212,43 @@ xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 }
 
 static void
+xor_sse_3_pf64(unsigned long bytes, unsigned long *p1, unsigned long *p2,
+	       unsigned long *p3)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i)			\
+		BLK64(PF0, LD, i)	\
+		BLK64(PF1, XO1, i)	\
+		BLK64(PF2, XO2, i)	\
+		BLK64(NOP, ST, i)	\
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
 xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3, unsigned long *p4)
 {
@@ -236,6 +315,45 @@ xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 }
 
 static void
+xor_sse_4_pf64(unsigned long bytes, unsigned long *p1, unsigned long *p2,
+	       unsigned long *p3, unsigned long *p4)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i)			\
+		BLK64(PF0, LD, i)	\
+		BLK64(PF1, XO1, i)	\
+		BLK64(PF2, XO2, i)	\
+		BLK64(PF3, XO3, i)	\
+		BLK64(NOP, ST, i)	\
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
 xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3, unsigned long *p4, unsigned long *p5)
 {
@@ -308,12 +426,63 @@ xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	kernel_fpu_end();
 }
 
+static void
+xor_sse_5_pf64(unsigned long bytes, unsigned long *p1, unsigned long *p2,
+	       unsigned long *p3, unsigned long *p4, unsigned long *p5)
+{
+	unsigned long lines = bytes >> 8;
+
+	kernel_fpu_begin();
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i)			\
+		BLK64(PF0, LD, i)	\
+		BLK64(PF1, XO1, i)	\
+		BLK64(PF2, XO2, i)	\
+		BLK64(PF3, XO3, i)	\
+		BLK64(PF4, XO4, i)	\
+		BLK64(NOP, ST, i)	\
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
+static struct xor_block_template xor_block_sse_pf64 = {
+	.name = "prefetch64-sse",
+	.do_2 = xor_sse_2_pf64,
+	.do_3 = xor_sse_3_pf64,
+	.do_4 = xor_sse_4_pf64,
+	.do_5 = xor_sse_5_pf64,
+};
+
 #undef LD
 #undef XO1
 #undef XO2
 #undef XO3
 #undef XO4
 #undef ST
+#undef NOP
+#undef BLK64
 #undef BLOCK
 
 #undef XOR_CONSTANT_CONSTRAINT
@@ -324,4 +493,7 @@ xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 # include <asm/xor_64.h>
 #endif
 
+#define XOR_SELECT_TEMPLATE(FASTEST) \
+	AVX_SELECT(FASTEST)
+
 #endif /* _ASM_X86_XOR_H */
diff --git a/arch/x86/include/asm/xor_32.h b/arch/x86/include/asm/xor_32.h
index b85dc87..ce05722 100644
--- a/arch/x86/include/asm/xor_32.h
+++ b/arch/x86/include/asm/xor_32.h
@@ -543,26 +543,25 @@ static struct xor_block_template xor_block_pIII_sse = {
 /* Also try the generic routines.  */
 #include <asm-generic/xor.h>
 
+/* We force the use of the SSE xor block because it can write around L2.
+   We may also be able to load into the L1 only depending on how the cpu
+   deals with a load to a line that is being prefetched.  */
 #undef XOR_TRY_TEMPLATES
 #define XOR_TRY_TEMPLATES				\
 do {							\
-	xor_speed(&xor_block_8regs);			\
-	xor_speed(&xor_block_8regs_p);			\
-	xor_speed(&xor_block_32regs);			\
-	xor_speed(&xor_block_32regs_p);			\
 	AVX_XOR_SPEED;					\
-	if (cpu_has_xmm)				\
+	if (cpu_has_xmm) {				\
 		xor_speed(&xor_block_pIII_sse);		\
-	if (cpu_has_mmx) {				\
+		xor_speed(&xor_block_sse_pf64);		\
+	} else if (cpu_has_mmx) {			\
 		xor_speed(&xor_block_pII_mmx);		\
 		xor_speed(&xor_block_p5_mmx);		\
+	} else {					\
+		xor_speed(&xor_block_8regs);		\
+		xor_speed(&xor_block_8regs_p);		\
+		xor_speed(&xor_block_32regs);		\
+		xor_speed(&xor_block_32regs_p);		\
 	}						\
 } while (0)
 
-/* We force the use of the SSE xor block because it can write around L2.
-   We may also be able to load into the L1 only depending on how the cpu
-   deals with a load to a line that is being prefetched.  */
-#define XOR_SELECT_TEMPLATE(FASTEST)			\
-	AVX_SELECT(cpu_has_xmm ? &xor_block_pIII_sse : FASTEST)
-
 #endif /* _ASM_X86_XOR_32_H */
diff --git a/arch/x86/include/asm/xor_64.h b/arch/x86/include/asm/xor_64.h
index 1baf89d..546f1e3 100644
--- a/arch/x86/include/asm/xor_64.h
+++ b/arch/x86/include/asm/xor_64.h
@@ -13,17 +13,15 @@ static struct xor_block_template xor_block_sse = {
 /* Also try the AVX routines */
 #include <asm/xor_avx.h>
 
+/* We force the use of the SSE xor block because it can write around L2.
+   We may also be able to load into the L1 only depending on how the cpu
+   deals with a load to a line that is being prefetched.  */
 #undef XOR_TRY_TEMPLATES
 #define XOR_TRY_TEMPLATES			\
 do {						\
 	AVX_XOR_SPEED;				\
+	xor_speed(&xor_block_sse_pf64);		\
 	xor_speed(&xor_block_sse);		\
 } while (0)
 
-/* We force the use of the SSE xor block because it can write around L2.
-   We may also be able to load into the L1 only depending on how the cpu
-   deals with a load to a line that is being prefetched.  */
-#define XOR_SELECT_TEMPLATE(FASTEST) \
-	AVX_SELECT(&xor_block_sse)
-
 #endif /* _ASM_X86_XOR_64_H */

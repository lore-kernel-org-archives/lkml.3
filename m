Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab3F1Qls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:41:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49272 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695Ab3F1Qlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:41:47 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86, cpufeature: Use new CC_HAVE_ASM_GOTO
Date: Fri, 28 Jun 2013 18:41:41 +0200
Message-Id: <1372437701-13351-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <51CD99C2.9040109@zytor.com>
References: <51CD99C2.9040109@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... for checking for "asm goto" compiler support. It is more explicit
this way and we cover the cases where distros have backported that
support even to gcc versions < 4.5.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cpufeature.h | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 47538a61c91b..d3f5c63078d8 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -366,9 +366,10 @@ extern bool __static_cpu_has_safe(u16 bit);
  */
 static __always_inline __pure bool __static_cpu_has(u16 bit)
 {
-#if __GNUC__ > 4 || __GNUC_MINOR__ >= 5
+#ifdef CC_HAVE_ASM_GOTO
 
 #ifdef CONFIG_X86_DEBUG_STATIC_CPU_HAS
+
 		/*
 		 * Catch too early usage of this before alternatives
 		 * have run.
@@ -384,6 +385,7 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 			 ".previous\n"
 			 /* skipping size check since replacement size = 0 */
 			 : : "i" (X86_FEATURE_ALWAYS) : : t_warn);
+
 #endif
 
 		asm goto("1: jmp %l[t_no]\n"
@@ -406,7 +408,9 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 		warn_pre_alternatives();
 		return false;
 #endif
-#else /* GCC_VERSION >= 40500 */
+
+#else /* CC_HAVE_ASM_GOTO */
+
 		u8 flag;
 		/* Open-coded due to __stringify() in ALTERNATIVE() */
 		asm volatile("1: movb $0,%0\n"
@@ -427,7 +431,8 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 			     ".previous\n"
 			     : "=qm" (flag) : "i" (bit));
 		return flag;
-#endif
+
+#endif /* CC_HAVE_ASM_GOTO */
 }
 
 #define static_cpu_has(bit)					\
@@ -441,7 +446,7 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 
 static __always_inline __pure bool _static_cpu_has_safe(u16 bit)
 {
-#if __GNUC__ > 4 || __GNUC_MINOR__ >= 5
+#ifdef CC_HAVE_ASM_GOTO
 /*
  * We need to spell the jumps to the compiler because, depending on the offset,
  * the replacement jump can be bigger than the original jump, and this we cannot
@@ -475,7 +480,7 @@ static __always_inline __pure bool _static_cpu_has_safe(u16 bit)
 		return false;
 	t_dynamic:
 		return __static_cpu_has_safe(bit);
-#else /* GCC_VERSION >= 40500 */
+#else
 		u8 flag;
 		/* Open-coded due to __stringify() in ALTERNATIVE() */
 		asm volatile("1: movb $2,%0\n"
@@ -511,7 +516,7 @@ static __always_inline __pure bool _static_cpu_has_safe(u16 bit)
 			     : "=qm" (flag)
 			     : "i" (bit), "i" (X86_FEATURE_ALWAYS));
 		return (flag == 2 ? __static_cpu_has_safe(bit) : flag);
-#endif
+#endif /* CC_HAVE_ASM_GOTO */
 }
 
 #define static_cpu_has_safe(bit)				\
-- 
1.8.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826Ab3GEOZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:25:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34632 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab3GEOZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:25:18 -0400
Date: Fri, 5 Jul 2013 07:24:51 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-62122fd7dadac09704782d8bc051fb898a0272bd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de, hpa@linux.intel.com
In-Reply-To: <1372437701-13351-1-git-send-email-bp@alien8.de>
References: <1372437701-13351-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpufeature: Use new CC_HAVE_ASM_GOTO
Git-Commit-ID: 62122fd7dadac09704782d8bc051fb898a0272bd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 05 Jul 2013 07:24:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62122fd7dadac09704782d8bc051fb898a0272bd
Gitweb:     http://git.kernel.org/tip/62122fd7dadac09704782d8bc051fb898a0272bd
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Fri, 28 Jun 2013 18:41:41 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 28 Jun 2013 15:26:48 -0700

x86, cpufeature: Use new CC_HAVE_ASM_GOTO

... for checking for "asm goto" compiler support. It is more explicit
this way and we cover the cases where distros have backported that
support even to gcc versions < 4.5.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1372437701-13351-1-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 47538a6..d3f5c63 100644
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

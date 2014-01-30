Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbaA3QLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 11:11:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56689 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbaA3QLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 11:11:08 -0500
Date: Thu, 30 Jan 2014 08:10:17 -0800
From: tip-bot for David Woodhouse <tipbot@zytor.com>
Message-ID: <tip-5fbbc25a99d680feca99a3095f0440f65d4307cc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dwmw2@infradead.org, tglx@linutronix.de, hpa@linux.intel.com,
        David.Woodhouse@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, tglx@linutronix.de, hpa@linux.intel.com,
        David.Woodhouse@intel.com
In-Reply-To: <1391079628.26079.82.camel@shinybook.infradead.org>
References: <1391079628.26079.82.camel@shinybook.infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86, boot: Fix word-size assumptions in has_eflag
 () inline asm
Git-Commit-ID: 5fbbc25a99d680feca99a3095f0440f65d4307cc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 30 Jan 2014 08:10:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5fbbc25a99d680feca99a3095f0440f65d4307cc
Gitweb:     http://git.kernel.org/tip/5fbbc25a99d680feca99a3095f0440f65d4307cc
Author:     David Woodhouse <dwmw2@infradead.org>
AuthorDate: Thu, 30 Jan 2014 11:00:28 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 30 Jan 2014 08:04:32 -0800

x86, boot: Fix word-size assumptions in has_eflag() inline asm

Commit dd78b97367bd575918204cc89107c1479d3fc1a7 ("x86, boot: Move CPU
flags out of cpucheck") introduced ambiguous inline asm in the
has_eflag() function. In 16-bit mode want the instruction to be
'pushfl', but we just say 'pushf' and hope the compiler does what we
wanted.

When building with 'clang -m16', it won't, because clang doesn't use
the horrid '.code16gcc' hack that even 'gcc -m16' uses internally.

Say what we mean and don't make the compiler make assumptions.

[ hpa: ideally we would be able to use the gcc %zN construct here, but
  that is broken for 64-bit integers in gcc < 4.5.

  The code with plain "pushf/popf" is fine for 32- or 64-bit mode, but
  not for 16-bit mode; in 16-bit mode those are 16-bit instructions in
  .code16 mode, and 32-bit instructions in .code16gcc mode. ]

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Link: http://lkml.kernel.org/r/1391079628.26079.82.camel@shinybook.infradead.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/cpuflags.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/x86/boot/cpuflags.c b/arch/x86/boot/cpuflags.c
index a9fcb7c..431fa5f 100644
--- a/arch/x86/boot/cpuflags.c
+++ b/arch/x86/boot/cpuflags.c
@@ -28,20 +28,35 @@ static int has_fpu(void)
 	return fsw == 0 && (fcw & 0x103f) == 0x003f;
 }
 
+/*
+ * For building the 16-bit code we want to explicitly specify 32-bit
+ * push/pop operations, rather than just saying 'pushf' or 'popf' and
+ * letting the compiler choose. But this is also included from the
+ * compressed/ directory where it may be 64-bit code, and thus needs
+ * to be 'pushfq' or 'popfq' in that case.
+ */
+#ifdef __x86_64__
+#define PUSHF "pushfq"
+#define POPF "popfq"
+#else
+#define PUSHF "pushfl"
+#define POPF "popfl"
+#endif
+
 int has_eflag(unsigned long mask)
 {
 	unsigned long f0, f1;
 
-	asm volatile("pushf	\n\t"
-		     "pushf	\n\t"
+	asm volatile(PUSHF "	\n\t"
+		     PUSHF "	\n\t"
 		     "pop %0	\n\t"
 		     "mov %0,%1	\n\t"
 		     "xor %2,%1	\n\t"
 		     "push %1	\n\t"
-		     "popf	\n\t"
-		     "pushf	\n\t"
+		     POPF "	\n\t"
+		     PUSHF "	\n\t"
 		     "pop %1	\n\t"
-		     "popf"
+		     POPF
 		     : "=&r" (f0), "=&r" (f1)
 		     : "ri" (mask));
 

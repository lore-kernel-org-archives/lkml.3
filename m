Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161226Ab3FUAwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:52:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52103 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043Ab3FUAwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:52:07 -0400
Date: Thu, 20 Jun 2013 17:51:53 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-4a90a99c4f8002edaa6be11bd756872ebf3f3d97@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de, hpa@linux.intel.com
In-Reply-To: <1370772454-6106-5-git-send-email-bp@alien8.de>
References: <1370772454-6106-5-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86: Add a static_cpu_has_safe variant
Git-Commit-ID: 4a90a99c4f8002edaa6be11bd756872ebf3f3d97
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Jun 2013 17:51:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a90a99c4f8002edaa6be11bd756872ebf3f3d97
Gitweb:     http://git.kernel.org/tip/4a90a99c4f8002edaa6be11bd756872ebf3f3d97
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Sun, 9 Jun 2013 12:07:33 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 20 Jun 2013 17:38:14 -0700

x86: Add a static_cpu_has_safe variant

We want to use this in early code where alternatives might not have run
yet and for that case we fall back to the dynamic boot_cpu_has.

For that, force a 5-byte jump since the compiler could be generating
differently sized jumps for each label.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1370772454-6106-5-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h | 86 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/common.c      |  6 +++
 2 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 252b28f..47538a6 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -357,6 +357,7 @@ extern const char * const x86_power_flags[32];
 
 #if __GNUC__ >= 4
 extern void warn_pre_alternatives(void);
+extern bool __static_cpu_has_safe(u16 bit);
 
 /*
  * Static testing of CPU features.  Used the same as boot_cpu_has().
@@ -437,11 +438,94 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 		__static_cpu_has(bit) :				\
 		boot_cpu_has(bit)				\
 )
+
+static __always_inline __pure bool _static_cpu_has_safe(u16 bit)
+{
+#if __GNUC__ > 4 || __GNUC_MINOR__ >= 5
+/*
+ * We need to spell the jumps to the compiler because, depending on the offset,
+ * the replacement jump can be bigger than the original jump, and this we cannot
+ * have. Thus, we force the jump to the widest, 4-byte, signed relative
+ * offset even though the last would often fit in less bytes.
+ */
+		asm goto("1: .byte 0xe9\n .long %l[t_dynamic] - 2f\n"
+			 "2:\n"
+			 ".section .altinstructions,\"a\"\n"
+			 " .long 1b - .\n"		/* src offset */
+			 " .long 3f - .\n"		/* repl offset */
+			 " .word %P1\n"			/* always replace */
+			 " .byte 2b - 1b\n"		/* src len */
+			 " .byte 4f - 3f\n"		/* repl len */
+			 ".previous\n"
+			 ".section .altinstr_replacement,\"ax\"\n"
+			 "3: .byte 0xe9\n .long %l[t_no] - 2b\n"
+			 "4:\n"
+			 ".previous\n"
+			 ".section .altinstructions,\"a\"\n"
+			 " .long 1b - .\n"		/* src offset */
+			 " .long 0\n"			/* no replacement */
+			 " .word %P0\n"			/* feature bit */
+			 " .byte 2b - 1b\n"		/* src len */
+			 " .byte 0\n"			/* repl len */
+			 ".previous\n"
+			 : : "i" (bit), "i" (X86_FEATURE_ALWAYS)
+			 : : t_dynamic, t_no);
+		return true;
+	t_no:
+		return false;
+	t_dynamic:
+		return __static_cpu_has_safe(bit);
+#else /* GCC_VERSION >= 40500 */
+		u8 flag;
+		/* Open-coded due to __stringify() in ALTERNATIVE() */
+		asm volatile("1: movb $2,%0\n"
+			     "2:\n"
+			     ".section .altinstructions,\"a\"\n"
+			     " .long 1b - .\n"		/* src offset */
+			     " .long 3f - .\n"		/* repl offset */
+			     " .word %P2\n"		/* always replace */
+			     " .byte 2b - 1b\n"		/* source len */
+			     " .byte 4f - 3f\n"		/* replacement len */
+			     ".previous\n"
+			     ".section .discard,\"aw\",@progbits\n"
+			     " .byte 0xff + (4f-3f) - (2b-1b)\n" /* size check */
+			     ".previous\n"
+			     ".section .altinstr_replacement,\"ax\"\n"
+			     "3: movb $0,%0\n"
+			     "4:\n"
+			     ".previous\n"
+			     ".section .altinstructions,\"a\"\n"
+			     " .long 1b - .\n"		/* src offset */
+			     " .long 5f - .\n"		/* repl offset */
+			     " .word %P1\n"		/* feature bit */
+			     " .byte 4b - 3b\n"		/* src len */
+			     " .byte 6f - 5f\n"		/* repl len */
+			     ".previous\n"
+			     ".section .discard,\"aw\",@progbits\n"
+			     " .byte 0xff + (6f-5f) - (4b-3b)\n" /* size check */
+			     ".previous\n"
+			     ".section .altinstr_replacement,\"ax\"\n"
+			     "5: movb $1,%0\n"
+			     "6:\n"
+			     ".previous\n"
+			     : "=qm" (flag)
+			     : "i" (bit), "i" (X86_FEATURE_ALWAYS));
+		return (flag == 2 ? __static_cpu_has_safe(bit) : flag);
+#endif
+}
+
+#define static_cpu_has_safe(bit)				\
+(								\
+	__builtin_constant_p(boot_cpu_has(bit)) ?		\
+		boot_cpu_has(bit) :				\
+		_static_cpu_has_safe(bit)			\
+)
 #else
 /*
  * gcc 3.x is too stupid to do the static test; fall back to dynamic.
  */
-#define static_cpu_has(bit) boot_cpu_has(bit)
+#define static_cpu_has(bit)		boot_cpu_has(bit)
+#define static_cpu_has_safe(bit)	boot_cpu_has(bit)
 #endif
 
 #define cpu_has_bug(c, bit)	cpu_has(c, (bit))
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 59adaa1..a4a07c0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1372,3 +1372,9 @@ void warn_pre_alternatives(void)
 }
 EXPORT_SYMBOL_GPL(warn_pre_alternatives);
 #endif
+
+inline bool __static_cpu_has_safe(u16 bit)
+{
+	return boot_cpu_has(bit);
+}
+EXPORT_SYMBOL_GPL(__static_cpu_has_safe);

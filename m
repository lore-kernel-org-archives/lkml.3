Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3FIKIM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 06:08:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47464 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681Ab3FIKHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 06:07:38 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 4/5] x86: Add a static_cpu_has_safe variant
Date: Sun,  9 Jun 2013 12:07:33 +0200
Message-Id: <1370772454-6106-5-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1370772454-6106-1-git-send-email-bp@alien8.de>
References: <1370772454-6106-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We want to use this in early code where alternatives might not have run
yet and for that case we fall back to the dynamic boot_cpu_has.

For that, force a 5-byte jump since the compiler could be generating
differently sized jumps for each label.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cpufeature.h | 86 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/common.c      |  6 +++
 2 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index eba671c0e5b1..0a803b74ac35 100644
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
index 407510155f40..f30267ac9371 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1373,3 +1373,9 @@ void warn_pre_alternatives(void)
 }
 EXPORT_SYMBOL_GPL(warn_pre_alternatives);
 #endif
+
+inline bool __static_cpu_has_safe(u16 bit)
+{
+	return boot_cpu_has(bit);
+}
+EXPORT_SYMBOL_GPL(__static_cpu_has_safe);
-- 
1.8.3


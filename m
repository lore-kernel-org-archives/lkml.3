Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab3FIKIK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 06:08:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47461 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab3FIKHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 06:07:38 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 3/5] x86: Sanity-check static_cpu_has usage
Date: Sun,  9 Jun 2013 12:07:32 +0200
Message-Id: <1370772454-6106-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1370772454-6106-1-git-send-email-bp@alien8.de>
References: <1370772454-6106-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

static_cpu_has may be used only after alternatives have run. Before that
it always returns false if constant folding with __builtin_constant_p()
doesn't happen. And you don't want that.

This patch is the result of me debugging an issue where I overzealously
put static_cpu_has in code which executed before alternatives have run
and had to spend some time with scratching head and cursing at the
monitor.

So add a jump to a warning which screams loudly when we use this
function too early. The alternatives patch that check away in
conjunction with patching the rest of the kernel image.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cpufeature.h | 30 ++++++++++++++++++++++++++++--
 arch/x86/kernel/cpu/common.c      |  8 ++++++++
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 043d61e66efc..eba671c0e5b1 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -356,15 +356,35 @@ extern const char * const x86_power_flags[32];
 #endif /* CONFIG_X86_64 */
 
 #if __GNUC__ >= 4
+extern void warn_pre_alternatives(void);
+
 /*
  * Static testing of CPU features.  Used the same as boot_cpu_has().
  * These are only valid after alternatives have run, but will statically
  * patch the target code for additional performance.
- *
  */
 static __always_inline __pure bool __static_cpu_has(u16 bit)
 {
 #if __GNUC__ > 4 || __GNUC_MINOR__ >= 5
+
+#ifdef CONFIG_X86_MISC_DEBUG_CHECKS
+		/*
+		 * Catch too early usage of this before alternatives
+		 * have run.
+		 */
+		asm goto("1: jmp %l[t_warn]\n"
+			 "2:\n"
+			 ".section .altinstructions,\"a\"\n"
+			 " .long 1b - .\n"
+			 " .long 0\n"		/* no replacement */
+			 " .word %P0\n"		/* 1: do replace */
+			 " .byte 2b - 1b\n"	/* source len */
+			 " .byte 0\n"		/* replacement len */
+			 ".previous\n"
+			 /* skipping size check since replacement size = 0 */
+			 : : "i" (X86_FEATURE_ALWAYS) : : t_warn);
+#endif
+
 		asm goto("1: jmp %l[t_no]\n"
 			 "2:\n"
 			 ".section .altinstructions,\"a\"\n"
@@ -379,7 +399,13 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 		return true;
 	t_no:
 		return false;
-#else
+
+#ifdef CONFIG_X86_MISC_DEBUG_CHECKS
+	t_warn:
+		warn_pre_alternatives();
+		return false;
+#endif
+#else /* GCC_VERSION >= 40500 */
 		u8 flag;
 		/* Open-coded due to __stringify() in ALTERNATIVE() */
 		asm volatile("1: movb $0,%0\n"
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 6a0361d7132c..407510155f40 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1365,3 +1365,11 @@ void __cpuinit cpu_init(void)
 	fpu_init();
 }
 #endif
+
+#ifdef CONFIG_X86_MISC_DEBUG_CHECKS
+void warn_pre_alternatives(void)
+{
+	WARN(1, "You're using static_cpu_has before alternatives have run!\n");
+}
+EXPORT_SYMBOL_GPL(warn_pre_alternatives);
+#endif
-- 
1.8.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab3D2OFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 10:05:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54454 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737Ab3D2OEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 10:04:34 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 2/3] x86: Sanity-check static_cpu_has usage
Date: Mon, 29 Apr 2013 16:04:21 +0200
Message-Id: <1367244262-29511-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3.rc0
In-Reply-To: <1367244262-29511-1-git-send-email-bp@alien8.de>
References: <1367244262-29511-1-git-send-email-bp@alien8.de>
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

This first JMP the compiler then issues should always be a two-byte JMP
because its relative offset fits in a byte. This gets replaced by only a
two-byte NOP => less instruction cache bloat.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cpufeature.h | 23 ++++++++++++++++++++++-
 arch/x86/kernel/cpu/common.c      |  6 ++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 398f7cb1353d..fa84c127f9db 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -354,15 +354,32 @@ extern const char * const x86_power_flags[32];
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
+		/*
+		 * Catch too early usage of this before alternatives
+		 * have run.
+		 */
+		asm goto("1: jmp %l[t_warn]\n"
+			 "2:\n"
+			 ".section .altinstructions,\"a\"\n"
+			 " .long 1b - .\n"
+			 " .long 0\n"		/* no replacement */
+			 " .word 1\n"		/* 1: do replace */
+			 " .byte 2b - 1b\n"	/* source len */
+			 " .byte 0\n"		/* replacement len */
+			 ".previous\n"
+			 /* skipping size check since replacement size = 0 */
+			 : : : : t_warn);
+
 		asm goto("1: jmp %l[t_no]\n"
 			 "2:\n"
 			 ".section .altinstructions,\"a\"\n"
@@ -377,6 +394,10 @@ static __always_inline __pure bool __static_cpu_has(u16 bit)
 		return true;
 	t_no:
 		return false;
+
+	t_warn:
+		warn_pre_alternatives();
+		return false;
 #else
 		u8 flag;
 		/* Open-coded due to __stringify() in ALTERNATIVE() */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d4dd99350e9d..aa33109bc020 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1362,3 +1362,9 @@ void __cpuinit cpu_init(void)
 	fpu_init();
 }
 #endif
+
+void warn_pre_alternatives(void)
+{
+	WARN(1, "You're using static_cpu_has before alternatives have run!\n");
+}
+EXPORT_SYMBOL_GPL(warn_pre_alternatives);
-- 
1.8.3.rc0


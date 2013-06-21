Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030315Ab3FUAwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:52:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52101 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843Ab3FUAwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:52:07 -0400
Date: Thu, 20 Jun 2013 17:51:45 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-5700f743b597951743da9c7d891d3989aac0486e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de, hpa@linux.intel.com
In-Reply-To: <1370772454-6106-4-git-send-email-bp@alien8.de>
References: <1370772454-6106-4-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86: Sanity-check static_cpu_has usage
Git-Commit-ID: 5700f743b597951743da9c7d891d3989aac0486e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Jun 2013 17:51:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5700f743b597951743da9c7d891d3989aac0486e
Gitweb:     http://git.kernel.org/tip/5700f743b597951743da9c7d891d3989aac0486e
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Sun, 9 Jun 2013 12:07:32 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 20 Jun 2013 17:37:19 -0700

x86: Sanity-check static_cpu_has usage

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

[ hpa: factored this into its own configuration option.  If we want to
  have an overarching option, it should be an option which selects
  other options, not as a group option in the source code. ]

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1370772454-6106-4-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig.debug            | 10 ++++++++++
 arch/x86/include/asm/cpufeature.h | 30 ++++++++++++++++++++++++++++--
 arch/x86/kernel/cpu/common.c      |  8 ++++++++
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index c198b7e..c6acdf7 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -304,4 +304,14 @@ config DEBUG_NMI_SELFTEST
 
 	  If unsure, say N.
 
+config X86_DEBUG_STATIC_CPU_HAS
+	bool "Debug alternatives"
+	depends on DEBUG_KERNEL
+	---help---
+	  This option causes additional code to be generated which
+	  fails if static_cpu_has() is used before alternatives have
+	  run.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 043d61e..252b28f 100644
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
+#ifdef CONFIG_X86_DEBUG_STATIC_CPU_HAS
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
+#ifdef CONFIG_X86_DEBUG_STATIC_CPU_HAS
+	t_warn:
+		warn_pre_alternatives();
+		return false;
+#endif
+#else /* GCC_VERSION >= 40500 */
 		u8 flag;
 		/* Open-coded due to __stringify() in ALTERNATIVE() */
 		asm volatile("1: movb $0,%0\n"
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d388ce1..59adaa1 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1364,3 +1364,11 @@ void __cpuinit cpu_init(void)
 	fpu_init();
 }
 #endif
+
+#ifdef CONFIG_X86_DEBUG_STATIC_CPU_HAS
+void warn_pre_alternatives(void)
+{
+	WARN(1, "You're using static_cpu_has before alternatives have run!\n");
+}
+EXPORT_SYMBOL_GPL(warn_pre_alternatives);
+#endif

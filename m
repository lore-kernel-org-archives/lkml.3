Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab3CTOIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:08:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41227 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab3CTOHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:07:35 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 3/6] x86, cpu: Convert FDIV bug detection
Date: Wed, 20 Mar 2013 15:07:25 +0100
Message-Id: <1363788448-31325-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1363788448-31325-1-git-send-email-bp@alien8.de>
References: <1363788448-31325-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... to the new facility. Add a reference to the wikipedia article
explaining the FDIV test we're doing here.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cpufeature.h | 1 +
 arch/x86/include/asm/processor.h  | 1 -
 arch/x86/kernel/cpu/bugs.c        | 7 ++++---
 arch/x86/kernel/cpu/proc.c        | 2 +-
 arch/x86/kernel/setup.c           | 2 --
 5 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index c0ad7e75815c..25eb9488a9a5 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -223,6 +223,7 @@
 #define X86_BUG(x)		(NCAPINTS*32 + (x))
 
 #define X86_BUG_F00F		X86_BUG(0) /* Intel F00F */
+#define X86_BUG_FDIV		X86_BUG(1) /* FPU FDIV */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 1e55e2d543b5..ea22dfaf6c5e 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -91,7 +91,6 @@ struct cpuinfo_x86 {
 	/* Problems on some 486Dx4's and old 386's: */
 	char			hard_math;
 	char			rfu;
-	char			fdiv_bug;
 	char			coma_bug;
 	char			pad0;
 #else
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index af6455e3fcc9..c59635ecbbb8 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -59,7 +59,7 @@ static void __init check_fpu(void)
 	 * trap_init() enabled FXSR and company _before_ testing for FP
 	 * problems here.
 	 *
-	 * Test for the divl bug..
+	 * Test for the divl bug: http://en.wikipedia.org/wiki/Fdiv_bug
 	 */
 	__asm__("fninit\n\t"
 		"fldl %1\n\t"
@@ -75,9 +75,10 @@ static void __init check_fpu(void)
 
 	kernel_fpu_end();
 
-	boot_cpu_data.fdiv_bug = fdiv_bug;
-	if (boot_cpu_data.fdiv_bug)
+	if (fdiv_bug) {
+		set_cpu_bug(&boot_cpu_data, X86_BUG_FDIV);
 		pr_warn("Hmm, FPU with FDIV bug\n");
+	}
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 2d60b2bec01c..5dfb6c65138f 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -34,7 +34,7 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 		   "fpu_exception\t: %s\n"
 		   "cpuid level\t: %d\n"
 		   "wp\t\t: %s\n",
-		   c->fdiv_bug ? "yes" : "no",
+		   static_cpu_has_bug(X86_BUG_FDIV) ? "yes" : "no",
 		   static_cpu_has_bug(X86_BUG_F00F) ? "yes" : "no",
 		   c->coma_bug ? "yes" : "no",
 		   c->hard_math ? "yes" : "no",
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 90d8cc930f5e..29258c75a2f3 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -173,12 +173,10 @@ static struct resource bss_resource = {
 /* cpu data as detected by the assembly code in head.S */
 struct cpuinfo_x86 new_cpu_data __cpuinitdata = {
 	.wp_works_ok = -1,
-	.fdiv_bug = -1,
 };
 /* common cpu data for all cpus */
 struct cpuinfo_x86 boot_cpu_data __read_mostly = {
 	.wp_works_ok = -1,
-	.fdiv_bug = -1,
 };
 EXPORT_SYMBOL(boot_cpu_data);
 
-- 
1.8.1.3.535.ga923c31


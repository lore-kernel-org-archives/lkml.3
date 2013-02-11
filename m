Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab3BKLTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:19:10 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34206 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512Ab3BKLSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:18:51 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [RFC PATCH 3/4] x86, cpu: Convert FDIV bug detection
Date: Mon, 11 Feb 2013 12:18:40 +0100
Message-Id: <1360581521-4712-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360581521-4712-1-git-send-email-bp@alien8.de>
References: <1360581521-4712-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... to the new facility.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cpufeature.h | 1 +
 arch/x86/include/asm/processor.h  | 1 -
 arch/x86/kernel/cpu/bugs.c        | 5 +++--
 arch/x86/kernel/cpu/proc.c        | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 22107c57c0e4..6be6fab3dced 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -217,6 +217,7 @@
 #define X86_FEATURE_SMAP	(9*32+20) /* Supervisor Mode Access Prevention */
 
 #define X86_BUG_F00F		(NCAPINTS*32+ 0) /* Intel F00F bug */
+#define X86_BUG_FDIV		(NCAPINTS*32+ 1) /* FPU FDIV bug */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 60b21f132ae4..d18dedf333aa 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -92,7 +92,6 @@ struct cpuinfo_x86 {
 	char			hlt_works_ok;
 	char			hard_math;
 	char			rfu;
-	char			fdiv_bug;
 	char			coma_bug;
 	char			pad0;
 #else
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 92dfec986a48..3ca8ab0001bc 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -84,9 +84,10 @@ static void __init check_fpu(void)
 
 	kernel_fpu_end();
 
-	boot_cpu_data.fdiv_bug = fdiv_bug;
-	if (boot_cpu_data.fdiv_bug)
+	if (fdiv_bug) {
+		set_cpu_bug(&boot_cpu_data, X86_BUG_FDIV);
 		pr_warn("Hmm, FPU with FDIV bug\n");
+	}
 }
 
 static void __init check_hlt(void)
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index debb8826589b..de41600664da 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -35,7 +35,7 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 		   "fpu_exception\t: %s\n"
 		   "cpuid level\t: %d\n"
 		   "wp\t\t: %s\n",
-		   c->fdiv_bug ? "yes" : "no",
+		   static_cpu_has_bug(X86_BUG_FDIV) ? "yes" : "no",
 		   c->hlt_works_ok ? "no" : "yes",
 		   static_cpu_has_bug(X86_BUG_F00F) ? "yes" : "no",
 		   c->coma_bug ? "yes" : "no",
-- 
1.8.1.3.535.ga923c31


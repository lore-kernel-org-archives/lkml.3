Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021Ab3DBTfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:35:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57381 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762111Ab3DBTfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:35:44 -0400
Date: Tue, 2 Apr 2013 12:34:51 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-93a829e8e2c292f1d30155f64803101ca1cb7d3d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1363788448-31325-4-git-send-email-bp@alien8.de>
References: <1363788448-31325-4-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Convert FDIV bug detection
Git-Commit-ID: 93a829e8e2c292f1d30155f64803101ca1cb7d3d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 12:34:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  93a829e8e2c292f1d30155f64803101ca1cb7d3d
Gitweb:     http://git.kernel.org/tip/93a829e8e2c292f1d30155f64803101ca1cb7d3d
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Wed, 20 Mar 2013 15:07:25 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 2 Apr 2013 10:12:53 -0700

x86, cpu: Convert FDIV bug detection

... to the new facility. Add a reference to the wikipedia article
explaining the FDIV test we're doing here.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1363788448-31325-4-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/cpufeature.h | 1 +
 arch/x86/include/asm/processor.h  | 1 -
 arch/x86/kernel/cpu/bugs.c        | 7 ++++---
 arch/x86/kernel/cpu/proc.c        | 2 +-
 arch/x86/kernel/setup.c           | 2 --
 5 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index c0ad7e7..25eb948 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -223,6 +223,7 @@
 #define X86_BUG(x)		(NCAPINTS*32 + (x))
 
 #define X86_BUG_F00F		X86_BUG(0) /* Intel F00F */
+#define X86_BUG_FDIV		X86_BUG(1) /* FPU FDIV */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 1e55e2d..ea22dfa 100644
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
index af6455e..c59635e 100644
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
index 2d60b2b..5dfb6c6 100644
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
index 90d8cc9..29258c75 100644
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
 

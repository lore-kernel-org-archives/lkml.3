Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab3CTOHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:07:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41217 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab3CTOHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:07:34 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 2/6] x86, cpu: Convert F00F bug detection
Date: Wed, 20 Mar 2013 15:07:24 +0100
Message-Id: <1363788448-31325-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1363788448-31325-1-git-send-email-bp@alien8.de>
References: <1363788448-31325-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... to using the new facility and drop the cpuinfo_x86 member.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cpufeature.h | 2 ++
 arch/x86/include/asm/processor.h  | 1 -
 arch/x86/kernel/cpu/intel.c       | 4 ++--
 arch/x86/kernel/cpu/proc.c        | 2 +-
 arch/x86/mm/fault.c               | 2 +-
 5 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 16190abd8905..c0ad7e75815c 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -222,6 +222,8 @@
  */
 #define X86_BUG(x)		(NCAPINTS*32 + (x))
 
+#define X86_BUG_F00F		X86_BUG(0) /* Intel F00F */
+
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
 #include <asm/asm.h>
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 23c8081d3870..1e55e2d543b5 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -92,7 +92,6 @@ struct cpuinfo_x86 {
 	char			hard_math;
 	char			rfu;
 	char			fdiv_bug;
-	char			f00f_bug;
 	char			coma_bug;
 	char			pad0;
 #else
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1905ce98bee0..1acdd42d86d1 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -209,11 +209,11 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 	 * system.
 	 * Note that the workaround only should be initialized once...
 	 */
-	c->f00f_bug = 0;
+	clear_cpu_bug(c, X86_BUG_F00F);
 	if (!paravirt_enabled() && c->x86 == 5) {
 		static int f00f_workaround_enabled;
 
-		c->f00f_bug = 1;
+		set_cpu_bug(c, X86_BUG_F00F);
 		if (!f00f_workaround_enabled) {
 			trap_init_f00f_bug();
 			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - workaround enabled.\n");
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index e280253f6f94..2d60b2bec01c 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -35,7 +35,7 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 		   "cpuid level\t: %d\n"
 		   "wp\t\t: %s\n",
 		   c->fdiv_bug ? "yes" : "no",
-		   c->f00f_bug ? "yes" : "no",
+		   static_cpu_has_bug(X86_BUG_F00F) ? "yes" : "no",
 		   c->coma_bug ? "yes" : "no",
 		   c->hard_math ? "yes" : "no",
 		   c->hard_math ? "yes" : "no",
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index fa8c02de0d25..3da69dbc0185 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -555,7 +555,7 @@ static int is_f00f_bug(struct pt_regs *regs, unsigned long address)
 	/*
 	 * Pentium F0 0F C7 C8 bug workaround:
 	 */
-	if (boot_cpu_data.f00f_bug) {
+	if (boot_cpu_has_bug(X86_BUG_F00F)) {
 		nr = (address - idt_descr.address) >> 3;
 
 		if (nr == 6) {
-- 
1.8.1.3.535.ga923c31


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762207Ab3DBTee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:34:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57358 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762153Ab3DBTec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:34:32 -0400
Date: Tue, 2 Apr 2013 12:33:39 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-e2604b49e8a8827e8bc5b61bc0c5a889e028fdad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1363788448-31325-3-git-send-email-bp@alien8.de>
References: <1363788448-31325-3-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Convert F00F bug detection
Git-Commit-ID: e2604b49e8a8827e8bc5b61bc0c5a889e028fdad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 12:33:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e2604b49e8a8827e8bc5b61bc0c5a889e028fdad
Gitweb:     http://git.kernel.org/tip/e2604b49e8a8827e8bc5b61bc0c5a889e028fdad
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Wed, 20 Mar 2013 15:07:24 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 2 Apr 2013 10:12:52 -0700

x86, cpu: Convert F00F bug detection

... to using the new facility and drop the cpuinfo_x86 member.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1363788448-31325-3-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/cpufeature.h | 2 ++
 arch/x86/include/asm/processor.h  | 1 -
 arch/x86/kernel/cpu/intel.c       | 4 ++--
 arch/x86/kernel/cpu/proc.c        | 2 +-
 arch/x86/mm/fault.c               | 2 +-
 5 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 16190ab..c0ad7e7 100644
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
index 23c8081..1e55e2d 100644
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
index 1905ce9..1acdd42 100644
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
index e280253..2d60b2b 100644
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
index 2b97525..a1ce1fa 100644
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

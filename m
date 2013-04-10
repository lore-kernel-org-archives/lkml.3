Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936089Ab3DJA05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:26:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53618 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964957Ab3DJA0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:26:25 -0400
Date: Tue, 9 Apr 2013 17:26:10 -0700
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-1a138b534ac6063ccca1a534967df46edc0366c4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, digitaleric@google.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, digitaleric@google.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20130409163932.GA19130@www.outflux.net>
References: <20130409163932.GA19130@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: Use a read-only IDT alias on all CPUs
Git-Commit-ID: 1a138b534ac6063ccca1a534967df46edc0366c4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 09 Apr 2013 17:26:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1a138b534ac6063ccca1a534967df46edc0366c4
Gitweb:     http://git.kernel.org/tip/1a138b534ac6063ccca1a534967df46edc0366c4
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Tue, 9 Apr 2013 09:39:32 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 9 Apr 2013 17:08:50 -0700

x86: Use a read-only IDT alias on all CPUs

Make a copy of the IDT (as seen via the "sidt" instruction) read-only.
This primarily removes the IDT from being a target for arbitrary memory
write attacks, and has the added benefit of also not leaking the kernel
base offset, if it has been relocated.

We already did this on vendor == Intel and family == 5 because of the
F0 0F bug -- regardless of if a particular CPU had the F0 0F bug or
not.  Since the workaround was so cheap, there simply was no reason to
be very specific.  This patch extends the readonly alias to all CPUs,
but does not activate the #PF to #UD conversion code needed to deliver
the proper exception in the F0 0F case except on Intel family 5
processors.

Signed-off-by: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/20130409163932.GA19130@www.outflux.net
Cc: Eric Northup <digitaleric@google.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/fixmap.h |  4 +---
 arch/x86/kernel/cpu/intel.c   | 18 +-----------------
 arch/x86/kernel/traps.c       |  8 ++++++++
 arch/x86/xen/mmu.c            |  4 +---
 4 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index a09c285..51b9e32 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -104,9 +104,7 @@ enum fixed_addresses {
 	FIX_LI_PCIA,	/* Lithium PCI Bridge A */
 	FIX_LI_PCIB,	/* Lithium PCI Bridge B */
 #endif
-#ifdef CONFIG_X86_F00F_BUG
-	FIX_F00F_IDT,	/* Virtual mapping for IDT */
-#endif
+	FIX_RO_IDT,	/* Virtual mapping for read-only IDT */
 #ifdef CONFIG_X86_CYCLONE_TIMER
 	FIX_CYCLONE_TIMER, /*cyclone timer register*/
 #endif
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1acdd42..dcda985 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -164,20 +164,6 @@ int __cpuinit ppro_with_ram_bug(void)
 	return 0;
 }
 
-#ifdef CONFIG_X86_F00F_BUG
-static void __cpuinit trap_init_f00f_bug(void)
-{
-	__set_fixmap(FIX_F00F_IDT, __pa_symbol(idt_table), PAGE_KERNEL_RO);
-
-	/*
-	 * Update the IDT descriptor and reload the IDT so that
-	 * it uses the read-only mapped virtual address.
-	 */
-	idt_descr.address = fix_to_virt(FIX_F00F_IDT);
-	load_idt(&idt_descr);
-}
-#endif
-
 static void __cpuinit intel_smp_check(struct cpuinfo_x86 *c)
 {
 	/* calling is from identify_secondary_cpu() ? */
@@ -206,8 +192,7 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 	/*
 	 * All current models of Pentium and Pentium with MMX technology CPUs
 	 * have the F0 0F bug, which lets nonprivileged users lock up the
-	 * system.
-	 * Note that the workaround only should be initialized once...
+	 * system. Announce that the fault handler will be checking for it.
 	 */
 	clear_cpu_bug(c, X86_BUG_F00F);
 	if (!paravirt_enabled() && c->x86 == 5) {
@@ -215,7 +200,6 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 
 		set_cpu_bug(c, X86_BUG_F00F);
 		if (!f00f_workaround_enabled) {
-			trap_init_f00f_bug();
 			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - workaround enabled.\n");
 			f00f_workaround_enabled = 1;
 		}
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 68bda7a..a2a9b78 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -753,6 +753,14 @@ void __init trap_init(void)
 #endif
 
 	/*
+	 * Set the IDT descriptor to a fixed read-only location, so that the
+	 * "sidt" instruction will not leak the location of the kernel, and
+	 * to defend the IDT against arbitrary memory write vulnerabilities.
+	 * It will be reloaded in cpu_init() */
+	__set_fixmap(FIX_RO_IDT, __pa_symbol(idt_table), PAGE_KERNEL_RO);
+	idt_descr.address = fix_to_virt(FIX_RO_IDT);
+
+	/*
 	 * Should be a barrier for any external CPU state:
 	 */
 	cpu_init();
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 6afbb2c..8bc4dec 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2039,9 +2039,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 
 	switch (idx) {
 	case FIX_BTMAP_END ... FIX_BTMAP_BEGIN:
-#ifdef CONFIG_X86_F00F_BUG
-	case FIX_F00F_IDT:
-#endif
+	case FIX_RO_IDT:
 #ifdef CONFIG_X86_32
 	case FIX_WP_TEST:
 	case FIX_VDSO:

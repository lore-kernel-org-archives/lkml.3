Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaA3GXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 01:23:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52167 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbaA3GXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 01:23:02 -0500
Date: Wed, 29 Jan 2014 22:21:51 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-a2e7f0e3a4f0f23fe4cd8cc22da547872f0170bb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jeremy@goop.org, ak@linux.intel.com, tglx@linutronix.de,
        ido@wizery.com, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jeremy@goop.org, ak@linux.intel.com, tglx@linutronix.de,
        ido@wizery.com, hpa@linux.intel.com
In-Reply-To: <1382458079-24450-5-git-send-email-andi@firstfloor.org>
References: <1382458079-24450-5-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86, asmlinkage, paravirt:
  Make paravirt thunks global
Git-Commit-ID: a2e7f0e3a4f0f23fe4cd8cc22da547872f0170bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 29 Jan 2014 22:21:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a2e7f0e3a4f0f23fe4cd8cc22da547872f0170bb
Gitweb:     http://git.kernel.org/tip/a2e7f0e3a4f0f23fe4cd8cc22da547872f0170bb
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Tue, 22 Oct 2013 09:07:56 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 29 Jan 2014 22:17:17 -0800

x86, asmlinkage, paravirt: Make paravirt thunks global

The paravirt thunks use a hack of using a static reference to a static
function to reference that function from the top level statement.

This assumes that gcc always generates static function names in a specific
format, which is not necessarily true.

Simply make these functions global and asmlinkage or __visible. This way the
static __used variables are not needed and everything works.

Functions with arguments are __visible to keep the register calling
convention on 32bit.

Changed in paravirt and in all users (Xen and vsmp)

v2: Use __visible for functions with arguments

Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ido Yariv <ido@wizery.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1382458079-24450-5-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/paravirt.h |  2 +-
 arch/x86/kernel/vsmp_64.c       |  8 ++++----
 arch/x86/xen/irq.c              |  8 ++++----
 arch/x86/xen/mmu.c              | 16 ++++++++--------
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 401f350..cd6e161 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -781,9 +781,9 @@ static __always_inline void __ticket_unlock_kick(struct arch_spinlock *lock,
  */
 #define PV_CALLEE_SAVE_REGS_THUNK(func)					\
 	extern typeof(func) __raw_callee_save_##func;			\
-	static void *__##func##__ __used = func;			\
 									\
 	asm(".pushsection .text;"					\
+	    ".globl __raw_callee_save_" #func " ; "			\
 	    "__raw_callee_save_" #func ": "				\
 	    PV_SAVE_ALL_CALLER_REGS					\
 	    "call " #func ";"						\
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 992f890..f6584a9 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -33,7 +33,7 @@
  * and vice versa.
  */
 
-static unsigned long vsmp_save_fl(void)
+asmlinkage unsigned long vsmp_save_fl(void)
 {
 	unsigned long flags = native_save_fl();
 
@@ -43,7 +43,7 @@ static unsigned long vsmp_save_fl(void)
 }
 PV_CALLEE_SAVE_REGS_THUNK(vsmp_save_fl);
 
-static void vsmp_restore_fl(unsigned long flags)
+__visible void vsmp_restore_fl(unsigned long flags)
 {
 	if (flags & X86_EFLAGS_IF)
 		flags &= ~X86_EFLAGS_AC;
@@ -53,7 +53,7 @@ static void vsmp_restore_fl(unsigned long flags)
 }
 PV_CALLEE_SAVE_REGS_THUNK(vsmp_restore_fl);
 
-static void vsmp_irq_disable(void)
+asmlinkage void vsmp_irq_disable(void)
 {
 	unsigned long flags = native_save_fl();
 
@@ -61,7 +61,7 @@ static void vsmp_irq_disable(void)
 }
 PV_CALLEE_SAVE_REGS_THUNK(vsmp_irq_disable);
 
-static void vsmp_irq_enable(void)
+asmlinkage void vsmp_irq_enable(void)
 {
 	unsigned long flags = native_save_fl();
 
diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
index 0da7f86..f56c23b 100644
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -22,7 +22,7 @@ void xen_force_evtchn_callback(void)
 	(void)HYPERVISOR_xen_version(0, NULL);
 }
 
-static unsigned long xen_save_fl(void)
+asmlinkage unsigned long xen_save_fl(void)
 {
 	struct vcpu_info *vcpu;
 	unsigned long flags;
@@ -40,7 +40,7 @@ static unsigned long xen_save_fl(void)
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_save_fl);
 
-static void xen_restore_fl(unsigned long flags)
+__visible void xen_restore_fl(unsigned long flags)
 {
 	struct vcpu_info *vcpu;
 
@@ -62,7 +62,7 @@ static void xen_restore_fl(unsigned long flags)
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_restore_fl);
 
-static void xen_irq_disable(void)
+asmlinkage void xen_irq_disable(void)
 {
 	/* There's a one instruction preempt window here.  We need to
 	   make sure we're don't switch CPUs between getting the vcpu
@@ -73,7 +73,7 @@ static void xen_irq_disable(void)
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_irq_disable);
 
-static void xen_irq_enable(void)
+asmlinkage void xen_irq_enable(void)
 {
 	struct vcpu_info *vcpu;
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index ce563be..648512c 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -431,7 +431,7 @@ static pteval_t iomap_pte(pteval_t val)
 	return val;
 }
 
-static pteval_t xen_pte_val(pte_t pte)
+__visible pteval_t xen_pte_val(pte_t pte)
 {
 	pteval_t pteval = pte.pte;
 #if 0
@@ -448,7 +448,7 @@ static pteval_t xen_pte_val(pte_t pte)
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_pte_val);
 
-static pgdval_t xen_pgd_val(pgd_t pgd)
+__visible pgdval_t xen_pgd_val(pgd_t pgd)
 {
 	return pte_mfn_to_pfn(pgd.pgd);
 }
@@ -479,7 +479,7 @@ void xen_set_pat(u64 pat)
 	WARN_ON(pat != 0x0007010600070106ull);
 }
 
-static pte_t xen_make_pte(pteval_t pte)
+__visible pte_t xen_make_pte(pteval_t pte)
 {
 	phys_addr_t addr = (pte & PTE_PFN_MASK);
 #if 0
@@ -514,14 +514,14 @@ static pte_t xen_make_pte(pteval_t pte)
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_make_pte);
 
-static pgd_t xen_make_pgd(pgdval_t pgd)
+__visible pgd_t xen_make_pgd(pgdval_t pgd)
 {
 	pgd = pte_pfn_to_mfn(pgd);
 	return native_make_pgd(pgd);
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_make_pgd);
 
-static pmdval_t xen_pmd_val(pmd_t pmd)
+__visible pmdval_t xen_pmd_val(pmd_t pmd)
 {
 	return pte_mfn_to_pfn(pmd.pmd);
 }
@@ -580,7 +580,7 @@ static void xen_pmd_clear(pmd_t *pmdp)
 }
 #endif	/* CONFIG_X86_PAE */
 
-static pmd_t xen_make_pmd(pmdval_t pmd)
+__visible pmd_t xen_make_pmd(pmdval_t pmd)
 {
 	pmd = pte_pfn_to_mfn(pmd);
 	return native_make_pmd(pmd);
@@ -588,13 +588,13 @@ static pmd_t xen_make_pmd(pmdval_t pmd)
 PV_CALLEE_SAVE_REGS_THUNK(xen_make_pmd);
 
 #if PAGETABLE_LEVELS == 4
-static pudval_t xen_pud_val(pud_t pud)
+__visible pudval_t xen_pud_val(pud_t pud)
 {
 	return pte_mfn_to_pfn(pud.pud);
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_pud_val);
 
-static pud_t xen_make_pud(pudval_t pud)
+__visible pud_t xen_make_pud(pudval_t pud)
 {
 	pud = pte_pfn_to_mfn(pud);
 

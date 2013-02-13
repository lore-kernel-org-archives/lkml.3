Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087Ab3BMFBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 00:01:39 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48161 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750712Ab3BMFBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 00:01:37 -0500
Message-ID: <1360731691.2544.15.camel@dabdike>
Subject: [GIT PULL] parisc fixes for 3.8-rc7
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 13 Feb 2013 09:01:31 +0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.6.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a couple of patches, one to fix a broken build with HPUX
compatibility and the other to solve a coherency problem we've been
seeing in our TLB where setting a page read only occasionally fails to
trigger a COW because of a stale writeable TLB entry.

The patches are here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/parisc-2.6.git parisc-fixes

The short changelog is:

Geert Uytterhoeven (1):
      hpux: Remove obsolete regs parameter from do_execve() in hpux_execve()

John David Anglin (1):
      Purge existing TLB entries in set_pte_at and ptep_set_wrprotect

and the diffstat:

 arch/parisc/hpux/fs.c             |  3 +--
 arch/parisc/include/asm/pgtable.h | 13 ++++++++++---
 arch/parisc/kernel/cache.c        | 18 ++++++++++++++++++
 3 files changed, 29 insertions(+), 5 deletions(-)

Full diff is attached below.

James

---

diff --git a/arch/parisc/hpux/fs.c b/arch/parisc/hpux/fs.c
index a0760b8..838b479 100644
--- a/arch/parisc/hpux/fs.c
+++ b/arch/parisc/hpux/fs.c
@@ -43,8 +43,7 @@ int hpux_execve(struct pt_regs *regs)
 
 	error = do_execve(filename->name,
 			  (const char __user *const __user *) regs->gr[25],
-			  (const char __user *const __user *) regs->gr[24],
-			  regs);
+			  (const char __user *const __user *) regs->gr[24]);
 
 	putname(filename);
 
diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
index ee99f23..7df49fa 100644
--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -12,11 +12,10 @@
 
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
+#include <linux/mm_types.h>
 #include <asm/processor.h>
 #include <asm/cache.h>
 
-struct vm_area_struct;
-
 /*
  * kern_addr_valid(ADDR) tests if ADDR is pointing to valid kernel
  * memory.  For the return value to be meaningful, ADDR must be >=
@@ -40,7 +39,14 @@ struct vm_area_struct;
         do{                                                     \
                 *(pteptr) = (pteval);                           \
         } while(0)
-#define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
+
+extern void purge_tlb_entries(struct mm_struct *, unsigned long);
+
+#define set_pte_at(mm, addr, ptep, pteval)                      \
+	do {                                                    \
+		set_pte(ptep, pteval);                          \
+		purge_tlb_entries(mm, addr);                    \
+	} while (0)
 
 #endif /* !__ASSEMBLY__ */
 
@@ -466,6 +472,7 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr,
 		old = pte_val(*ptep);
 		new = pte_val(pte_wrprotect(__pte (old)));
 	} while (cmpxchg((unsigned long *) ptep, old, new) != old);
+	purge_tlb_entries(mm, addr);
 #else
 	pte_t old_pte = *ptep;
 	set_pte_at(mm, addr, ptep, pte_wrprotect(old_pte));
diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index 48e16dc..b89a85a 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -419,6 +419,24 @@ void kunmap_parisc(void *addr)
 EXPORT_SYMBOL(kunmap_parisc);
 #endif
 
+void purge_tlb_entries(struct mm_struct *mm, unsigned long addr)
+{
+	unsigned long flags;
+
+	/* Note: purge_tlb_entries can be called at startup with
+	   no context.  */
+
+	/* Disable preemption while we play with %sr1.  */
+	preempt_disable();
+	mtsp(mm->context, 1);
+	purge_tlb_start(flags);
+	pdtlb(addr);
+	pitlb(addr);
+	purge_tlb_end(flags);
+	preempt_enable();
+}
+EXPORT_SYMBOL(purge_tlb_entries);
+
 void __flush_tlb_range(unsigned long sid, unsigned long start,
 		       unsigned long end)
 {



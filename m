Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab3CDEVg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:21:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60743 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755221Ab3CDDmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:32 -0500
Message-Id: <20130304033708.731679917@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:18 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, John David Anglin <dave.anglin@bell.net>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 011/153] [PARISC] Purge existing TLB entries in set_pte_at and
 ptep_set_wrprotect
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit 7139bc1579901b53db7e898789e916ee2fb52d78 upstream.

This patch goes a long way toward fixing the minifail bug, and
it  significantly improves the stability of SMP machines such as
the rp3440.  When write  protecting a page for COW, we need to
purge the existing translation.  Otherwise, the COW break
doesn't occur as expected because the TLB may still have a stale entry
which allows writes.

[jejb: fix up checkpatch errors]
Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/parisc/include/asm/pgtable.h |   13 ++++++++++---
 arch/parisc/kernel/cache.c        |   18 ++++++++++++++++++
 2 files changed, 28 insertions(+), 3 deletions(-)

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
 
@@ -464,6 +470,7 @@ static inline void ptep_set_wrprotect(st
 		old = pte_val(*ptep);
 		new = pte_val(pte_wrprotect(__pte (old)));
 	} while (cmpxchg((unsigned long *) ptep, old, new) != old);
+	purge_tlb_entries(mm, addr);
 #else
 	pte_t old_pte = *ptep;
 	set_pte_at(mm, addr, ptep, pte_wrprotect(old_pte));
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -421,6 +421,24 @@ void kunmap_parisc(void *addr)
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



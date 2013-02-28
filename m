Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab3B1OqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:46:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41888 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3B1OqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:46:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: John David Anglin <dave.anglin@bell.net>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 010/139] Purge existing TLB entries in set_pte_at and ptep_set_wrprotect
Date: Thu, 28 Feb 2013 14:42:40 +0000
Message-Id: <1362062689-2567-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/parisc/include/asm/pgtable.h | 13 ++++++++++---
 arch/parisc/kernel/cache.c        | 18 ++++++++++++++++++
 2 files changed, 28 insertions(+), 3 deletions(-)

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
index 9d18189..fa21463 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -420,6 +420,24 @@ void kunmap_parisc(void *addr)
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
-- 
1.8.1.2


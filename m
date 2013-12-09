Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761615Ab3LIVSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:18:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761339Ab3LIVS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:18:29 -0500
Date: Mon, 9 Dec 2013 22:18:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@alien8.de>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] uprobes: Kill __replace_page(), change
	uprobe_write_opcode() to rely on gup(WRITE)
Message-ID: <20131209211843.GA15014@redhat.com>
References: <20131209211824.GA15006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131209211824.GA15006@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__replace_page() logic is nontrivial, it plays with vm internals.

uprobe_write_opcode() can rely on gup(WRITE|FORCE) which should
break the mapping and unshare the page. After that we can unmap
this page temporary to ensure that nobody can access it, modify
its content, and restore the same pte + _PAGE_DIRTY.

This greatly simplifies the code and avoids the extra alloc_page()
if uprobe_write_opcode() was already called in the past.

Note: perhaps we do not need pte games at least on x86 which
always updates a single byte, we can trivially change this code
later to do copy_to_page() + set_page_dirty_lock() after the 2nd
get_user_pages() if CONFIG_X86.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |  133 +++++++++++++++++-----------------------------
 1 files changed, 49 insertions(+), 84 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 24b7d6c..1bae429 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -33,7 +33,6 @@
 #include <linux/swap.h>		/* try_to_free_swap */
 #include <linux/ptrace.h>	/* user_enable_single_step */
 #include <linux/kdebug.h>	/* notifier mechanism */
-#include "../../mm/internal.h"	/* munlock_vma_page */
 #include <linux/percpu-rwsem.h>
 #include <linux/task_work.h>
 
@@ -114,65 +113,6 @@ static loff_t vaddr_to_offset(struct vm_area_struct *vma, unsigned long vaddr)
 }
 
 /**
- * __replace_page - replace page in vma by new page.
- * based on replace_page in mm/ksm.c
- *
- * @vma:      vma that holds the pte pointing to page
- * @addr:     address the old @page is mapped at
- * @page:     the cowed page we are replacing by kpage
- * @kpage:    the modified page we replace page by
- *
- * Returns 0 on success, -EFAULT on failure.
- */
-static int __replace_page(struct vm_area_struct *vma, unsigned long addr,
-				struct page *page, struct page *kpage)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	spinlock_t *ptl;
-	pte_t *ptep;
-	int err;
-	/* For mmu_notifiers */
-	const unsigned long mmun_start = addr;
-	const unsigned long mmun_end   = addr + PAGE_SIZE;
-
-	/* For try_to_free_swap() and munlock_vma_page() below */
-	lock_page(page);
-
-	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
-	err = -EAGAIN;
-	ptep = page_check_address(page, mm, addr, &ptl, 0);
-	if (!ptep)
-		goto unlock;
-
-	get_page(kpage);
-	page_add_new_anon_rmap(kpage, vma, addr);
-
-	if (!PageAnon(page)) {
-		dec_mm_counter(mm, MM_FILEPAGES);
-		inc_mm_counter(mm, MM_ANONPAGES);
-	}
-
-	flush_cache_page(vma, addr, pte_pfn(*ptep));
-	ptep_clear_flush(vma, addr, ptep);
-	set_pte_at_notify(mm, addr, ptep, mk_pte(kpage, vma->vm_page_prot));
-
-	page_remove_rmap(page);
-	if (!page_mapped(page))
-		try_to_free_swap(page);
-	pte_unmap_unlock(ptep, ptl);
-
-	if (vma->vm_flags & VM_LOCKED)
-		munlock_vma_page(page);
-	put_page(page);
-
-	err = 0;
- unlock:
-	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
-	unlock_page(page);
-	return err;
-}
-
-/**
  * is_swbp_insn - check if instruction is breakpoint instruction.
  * @insn: instruction to be checked.
  * Default implementation of is_swbp_insn
@@ -264,43 +204,68 @@ static int verify_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t
 int uprobe_write_opcode(struct mm_struct *mm, unsigned long vaddr,
 			uprobe_opcode_t opcode)
 {
-	struct page *old_page, *new_page;
+	struct page *page;
 	struct vm_area_struct *vma;
+	pte_t *ptep, entry;
+	spinlock_t *ptlp;
 	int ret;
 
-retry:
 	/* Read the page with vaddr into memory */
-	ret = get_user_pages(NULL, mm, vaddr, 1, 0, 1, &old_page, &vma);
-	if (ret <= 0)
+	ret = get_user_pages(NULL, mm, vaddr, 1, 0, 1, &page, NULL);
+	if (ret < 0)
 		return ret;
 
-	ret = verify_opcode(old_page, vaddr, &opcode);
+	ret = verify_opcode(page, vaddr, &opcode);
 	if (ret <= 0)
-		goto put_old;
+		goto put;
 
-	ret = -ENOMEM;
-	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
-	if (!new_page)
-		goto put_old;
-
-	__SetPageUptodate(new_page);
+ retry:
+	put_page(page);
+	/*
+	 * Break the mapping unless the page is already anonymous and
+	 * unshare the page, see the WARN_ON() below.
+	 *
+	 * We never write to the VM_SHARED vma, every caller must check
+	 * valid_vma(). FOLL_WRITE | FOLL_FORCE should anonymize this
+	 * page unless uprobe_write_opcode() was already called in the
+	 * past or the application itself did mprotect(PROT_WRITE) and
+	 * wrote into this page.
+	 *
+	 * If it was already anonymous it can be shared due to dup_mm(),
+	 * in this case do_wp_page() or do_swap_page() will do another
+	 * cow to unshare, so we can safely modify it.
+	 */
+	ret = get_user_pages(NULL, mm, vaddr, 1, 1, 1, &page, &vma);
+	if (ret < 0)
+		return ret;
 
-	copy_highpage(new_page, old_page);
-	copy_to_page(new_page, vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
+	ptep = page_check_address(page, mm, vaddr, &ptlp, 0);
+	if (!ptep)
+		goto retry;
 
-	ret = anon_vma_prepare(vma);
-	if (ret)
-		goto put_new;
+	ret = 0;
+	if (WARN_ON(!PageAnon(page) || page_mapcount(page) != 1)) {
+		dump_page(page);
+		ret = -EFAULT;
+		goto unlock;
+	}
 
-	ret = __replace_page(vma, vaddr, old_page, new_page);
+	/* Unmap this page to ensure that nobody can execute it */
+	flush_cache_page(vma, vaddr, pte_pfn(*ptep));
+	entry = ptep_clear_flush(vma, vaddr, ptep);
 
-put_new:
-	page_cache_release(new_page);
-put_old:
-	put_page(old_page);
+	/* Nobody can fault in this page, modify it */
+	copy_to_page(page, vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
 
-	if (unlikely(ret == -EAGAIN))
-		goto retry;
+	/* Restore the old mapping */
+	entry = pte_mkdirty(entry);
+	flush_icache_page(vma, page);
+	set_pte_at(mm, vaddr, ptep, entry);
+	update_mmu_cache(vma, vaddr, ptep);
+ unlock:
+	pte_unmap_unlock(ptep, ptlp);
+ put:
+	put_page(page);
 	return ret;
 }
 
-- 
1.5.5.1



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab3LCStV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 13:49:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393Ab3LCStF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 13:49:05 -0500
Date: Tue, 3 Dec 2013 19:49:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH?] uprobes: change uprobe_write_opcode() to modify the page
	directly
Message-ID: <20131203184909.GA17571@redhat.com>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org> <20131129183558.GA9803@redhat.com> <20131129195419.GB17656@two.firstfloor.org> <20131129200532.GA13561@redhat.com> <alpine.LRH.2.00.1311300023070.9932@twin.jikos.cz> <CA+55aFxJGidV4=ot0z_Va8+y2QWTDYghTm1Gin84StZ+R1SfXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxJGidV4=ot0z_Va8+y2QWTDYghTm1Gin84StZ+R1SfXg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29, Linus Torvalds wrote:
>
> On Fri, Nov 29, 2013 at 3:24 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> >
> > Do you think this'd be faster than the int3-based aproach?
>
> Unlikely to be faster, but perhaps more robust and more portable. Maybe.

Can't we at least change uprobe_write_opcode() and kill the
nontrivial __replace_page() logic?

See the patch below. For review only, I can't understand if
it needs mmu_notifier_invalidate* and set_pte_notify(), and
of course I can easily miss something else.

Currently uprobe_write_opcode() always allocs/installs the new
page, even if the previous uprobe_write_opcode() has already
created the cowed anonymous page.

With this patch uprobe_write_opcode() calls gup(write, force),
then invalidates pte, then modifies the page, and restores the
old pte.

The patch is hardly readable, this is how the code looks:

	int uprobe_write_opcode(struct mm_struct *mm, unsigned long vaddr,
				uprobe_opcode_t opcode)
	{
		struct page *page;
		struct vm_area_struct *vma;
		pte_t *ptep, entry;
		spinlock_t *ptlp;
		int ret;

		/* Read the page with vaddr into memory */
		ret = get_user_pages(NULL, mm, vaddr, 1, 0, 1, &page, NULL);
		if (ret <= 0)
			return ret;

		ret = verify_opcode(page, vaddr, &opcode);
		if (ret <= 0)
			goto put;

	 retry:
		put_page(page);
		/* COW this page if not writable */
		ret = get_user_pages(NULL, mm, vaddr, 1, 1, 1, &page, &vma);
		if (ret <= 0)
			goto put;

		ptep = page_check_address(page, mm, vaddr, &ptlp, 0);
		if (!ptep)
			goto retry;

		/* Unmap this page to ensure that nobody can execute it */
		flush_cache_page(vma, vaddr, pte_pfn(*ptep));
		entry = ptep_clear_flush(vma, vaddr, ptep);

		/* Nobody can fault in this page, modify it */
		copy_to_page(page, vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);

		/* Restore the old mapping */
		entry = pte_mkdirty(entry);
		set_pte_at(mm, vaddr, ptep, entry);
		update_mmu_cache(vma, vaddr, ptep);
		pte_unmap_unlock(ptep, ptlp);
	 put:
		put_page(page);
		return ret;
	}

you can safely ignore the fist get_user_pages() and verify_opcode().

I'll appretiate any review, thanks in advance.

Oleg.


--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -114,65 +114,6 @@ static loff_t vaddr_to_offset(struct vm_area_struct *vma, unsigned long vaddr)
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
@@ -264,43 +205,46 @@ static int verify_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t
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
+	ret = get_user_pages(NULL, mm, vaddr, 1, 0, 1, &page, NULL);
 	if (ret <= 0)
 		return ret;
 
-	ret = verify_opcode(old_page, vaddr, &opcode);
+	ret = verify_opcode(page, vaddr, &opcode);
 	if (ret <= 0)
-		goto put_old;
-
-	ret = -ENOMEM;
-	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
-	if (!new_page)
-		goto put_old;
+		goto put;
 
-	__SetPageUptodate(new_page);
-
-	copy_highpage(new_page, old_page);
-	copy_to_page(new_page, vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
+ retry:
+	put_page(page);
+	/* COW this page if not writable */
+	ret = get_user_pages(NULL, mm, vaddr, 1, 1, 1, &page, &vma);
+	if (ret <= 0)
+		goto put;
 
-	ret = anon_vma_prepare(vma);
-	if (ret)
-		goto put_new;
+	ptep = page_check_address(page, mm, vaddr, &ptlp, 0);
+	if (!ptep)
+		goto retry;
 
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
+	set_pte_at(mm, vaddr, ptep, entry);
+	update_mmu_cache(vma, vaddr, ptep);
+	pte_unmap_unlock(ptep, ptlp);
+ put:
+	put_page(page);
 	return ret;
 }
 


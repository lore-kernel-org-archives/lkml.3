Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab3LDRnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:43:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab3LDRnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:43:23 -0500
Date: Wed, 4 Dec 2013 18:43:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH?] uprobes: change uprobe_write_opcode() to modify the
	page directly
Message-ID: <20131204174328.GA8082@redhat.com>
References: <529E3D4C.9070403@zytor.com> <20131203203826.GA24812@redhat.com> <e6082bc4-c910-4a36-9e40-624b9319f5fb@email.android.com> <20131203205400.GA25735@redhat.com> <CA+55aFxKk+O4e51sq6iqunVWAwKfNAnZ-3=aZT-VuRpDAZUnzQ@mail.gmail.com> <20131204111125.GA26552@redhat.com> <529F51D9.7010001@zytor.com> <20131204164817.GA5271@redhat.com> <529F5E47.3040108@zytor.com> <CA+55aFyMx74jiKgS-o0axuuTBw7295UEMSf_vYDQCAghk3Vr=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyMx74jiKgS-o0axuuTBw7295UEMSf_vYDQCAghk3Vr=w@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, Linus, I got lost.

So what do you finally think about this change? Please see v2 below:

	- update the comment above gup(write, force)

	- add flush_icache_page() before set_pte_at() (nop on x86
	  and powerpc)

	- fix the returned value, and with this change it seems
	  to work although I do not trust my testing.

I am attaching the code:

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
		if (ret < 0)
			return ret;

		ret = verify_opcode(page, vaddr, &opcode);
		if (ret < 0)
			goto put;

	 retry:
		put_page(page);
		/* Break the mapping unless the page is already anonymous */
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
		flush_icache_page(vma, page);
		set_pte_at(mm, vaddr, ptep, entry);
		update_mmu_cache(vma, vaddr, ptep);
		pte_unmap_unlock(ptep, ptlp);
		ret = 0;
	 put:
		put_page(page);
		return ret;
	}

And/Or. Are you still saying that on x86 (and powerpc?) we do not need
these pte games at all and uprobe_write_opcode() can simply do:

		/* Break the mapping unless the page is already anonymous */
		ret = get_user_pages(NULL, mm, vaddr, 1, 1, 1, &page, &vma);

		// this page can't be swapped out due to page_freeze_refs()
		copy_to_page(page, vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
		
		set_page_dirty_lock(page);

Just in case... I have no idea if this matters or not, but
uprobe_write_opcode() is also used to restore the original insn which
can even cross the page. We still write a single (1st) byte in this
case, the byte which was previously replaced by int3.

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
@@ -264,43 +205,48 @@ static int verify_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t
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
-	if (ret <= 0)
-		goto put_old;
-
-	ret = -ENOMEM;
-	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
-	if (!new_page)
-		goto put_old;
-
-	__SetPageUptodate(new_page);
-
-	copy_highpage(new_page, old_page);
-	copy_to_page(new_page, vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
-
-	ret = anon_vma_prepare(vma);
-	if (ret)
-		goto put_new;
-
-	ret = __replace_page(vma, vaddr, old_page, new_page);
+	ret = verify_opcode(page, vaddr, &opcode);
+	if (ret < 0)
+		goto put;
 
-put_new:
-	page_cache_release(new_page);
-put_old:
-	put_page(old_page);
+ retry:
+	put_page(page);
+	/* Break the mapping unless the page is already anonymous */
+	ret = get_user_pages(NULL, mm, vaddr, 1, 1, 1, &page, &vma);
+	if (ret <= 0)
+		goto put;
 
-	if (unlikely(ret == -EAGAIN))
+	ptep = page_check_address(page, mm, vaddr, &ptlp, 0);
+	if (!ptep)
 		goto retry;
+
+	/* Unmap this page to ensure that nobody can execute it */
+	flush_cache_page(vma, vaddr, pte_pfn(*ptep));
+	entry = ptep_clear_flush(vma, vaddr, ptep);
+
+	/* Nobody can fault in this page, modify it */
+	copy_to_page(page, vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
+
+	/* Restore the old mapping */
+	entry = pte_mkdirty(entry);
+	flush_icache_page(vma, page);
+	set_pte_at(mm, vaddr, ptep, entry);
+	update_mmu_cache(vma, vaddr, ptep);
+	pte_unmap_unlock(ptep, ptlp);
+	ret = 0;
+ put:
+	put_page(page);
 	return ret;
 }
 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602Ab3LIVS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:18:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758864Ab3LIVS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:18:26 -0500
Date: Mon, 9 Dec 2013 22:18:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@alien8.de>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] uprobes: Kill __replace_page(), change
	uprobe_write_opcode() to rely on gup(WRITE)
Message-ID: <20131209211824.GA15006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

It is not clear to me if Linus still dislikes this change or not.
Let me send the patch "officially" so that it can be nacked if I
misunderstood the result of discussion.

Changes:

	- add a huge comment above gup(WRITE | FORCE)

	- add WARN_ON(!(PageAnon() && page_mapcount() == 1))
	  to ensure it works as expected

If (say, on x86) we can avoid the pte games, we can simply add

	if (IS_ENABLED(CONFIG_WHATEVER)) {
		copy_to_page(...);
		set_page_dirty_locked(page);
		goto put;
	}

right after the 2nd get_user_pages().

In any case I believe it would be very nice to kill __replace_page(),
and even the fact this patch removes include(mm/internal.h) makes me
think this patch makes sense. Assuming it is correct.

Oleg.
---

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
	if (ret <= 0)
		goto put;

 retry:
	put_page(page);
	/*
	 * Break the mapping unless the page is already anonymous and
	 * unshare the page, see the WARN_ON() below.
	 *
	 * We never write to the VM_SHARED vma, every caller must check
	 * valid_vma(). FOLL_WRITE | FOLL_FORCE should anonymize this
	 * page unless uprobe_write_opcode() was already called in the
	 * past or the application itself did mprotect(PROT_WRITE) and
	 * wrote into this page.
	 *
	 * If it was already anonymous it can be shared due to dup_mm(),
	 * in this case do_wp_page() or do_swap_page() will do another
	 * cow to unshare, so we can safely modify it.
	 */
	ret = get_user_pages(NULL, mm, vaddr, 1, 1, 1, &page, &vma);
	if (ret < 0)
		return ret;

	ptep = page_check_address(page, mm, vaddr, &ptlp, 0);
	if (!ptep)
		goto retry;

	ret = 0;
	if (WARN_ON(!PageAnon(page) || page_mapcount(page) != 1)) {
		dump_page(page);
		ret = -EFAULT;
		goto unlock;
	}

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
 unlock:
	pte_unmap_unlock(ptep, ptlp);
 put:
	put_page(page);
	return ret;
}


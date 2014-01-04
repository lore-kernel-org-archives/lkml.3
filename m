Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbaADUkR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 15:40:17 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:60523 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbaADUkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 15:40:16 -0500
MIME-Version: 1.0
Date: Sat, 4 Jan 2014 12:40:14 -0800
Message-ID: <CAC2Wwaxuxh7Qz=Ko8gPL0A_x7LpxXucgf+p37+44eq6XH2H2HQ@mail.gmail.com>
Subject: error when getting page from page table in KVM ept violation handler
From: Ruby Zhang <littleegg.zhang@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm trying to get a page structure at KVM ept violation handler (in
tdp_page_fault). My code is invoked when tdp_page_fault calls
__direct_map (where the page fault should have been handled, is it?).
But I get a "unable to handle kerenel paging request" error
occasionally when I try to access the second double word of the page
structure. Here's my code:

Inside __direct_map

for_each_shadow_entry(vcpu, (u64)gfn << PAGE_SHIFT, iterator) {
   if (iterator.level == level) {
       mmu_set_spte(vcpu, iterator.sptep, ACC_ALL,
             write, &emulate, level, gfn, pfn, prefault, map_writeable);
       direct_pte_prefetch(vcpu, iterator.sptep);
       ++vcpu->stat.pf_fixed;
// beginning of my code:
     if (level == 1) {
       pgd_t *pgdp;
       pud_t *pudp;
       pmd_t *pmdp;
       pte_t *ptep;
       unsigned long hva = gfn_to_hva(vcpu->kvm, gfn);
       struct page *page = NULL;
       pgdp = pgd_offset(current->mm, hva);
       if (!pgd_present(*pgdp))
           goto out;
       pudp = pud_offset(pgdp, hva);
       if (!pud_present(*pudp))
           goto out;
       pmdp = pmd_offset(pudp, hva);
       if (!pmd_preset(*pmdp))
          goto out;
       ptep = pte_offset_map(pmdp, hva);
       if (!pte_present(*ptep) || pte_none(*ptep))
          goto out;
       if (!pfn_valid(pte_pfn(*ptep)))
          goto out;
       page = pte_page(*ptep);
       if (!page)
          goto out;

// this prink gives the unable to handle paging request" error:
      printk(KERN_CRIT "page %p count %d mapping %p\n",
            page, atomic_read(&page->_count), page->mapping);

out:
.........
     }

// end of my code

}

Is there anything I did wrong here to get the page? The error only
happens occasionally.

Thanks

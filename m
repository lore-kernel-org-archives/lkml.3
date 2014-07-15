Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbaGOLzD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:55:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:41760 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758039AbaGOLzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:55:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,665,1400050800"; 
   d="scan'208";a="543565589"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Ingo Korb <ingo.korb@tu-dortmund.de>,
        Ning Qu <quning@google.com>, Dave Jones <davej@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CALYGNiM3tQUCvSPxPbum5jkhNOPeKpAVL=x3ggFmZH-QaqULcA@mail.gmail.com>
References: <748020aaaf5c5c2924a16232313e0175.squirrel@webmail.tu-dortmund.de>
 <alpine.LSU.2.11.1407141209160.17242@eggly.anvils>
 <CALYGNiM9Fu9-i7hXMQNTUP69RfydN+2NqO29wZYd+4Gn25GbCQ@mail.gmail.com>
 <20140715105547.C4832E00A3@blue.fi.intel.com>
 <CALYGNiM3tQUCvSPxPbum5jkhNOPeKpAVL=x3ggFmZH-QaqULcA@mail.gmail.com>
Subject: Re: PROBLEM: repeated remap_file_pages on tmpfs triggers bug on
 process exit
Content-Transfer-Encoding: 7bit
Message-Id: <20140715115456.32886E00A3@blue.fi.intel.com>
Date: Tue, 15 Jul 2014 14:54:56 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Khlebnikov wrote:
> On Tue, Jul 15, 2014 at 2:55 PM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > Konstantin Khlebnikov wrote:
> >> It seems boundng logic in do_fault_around is wrong:
> >>
> >> start_addr = max(address & fault_around_mask(), vma->vm_start);
> >> off = ((address - start_addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
> >> pte -= off;
> >> pgoff -= off;
> >>
> >> Ok, off  <= 511, but it might be bigger than pte offset in pte table.
> >
> > I don't see how it possible: fault_around_mask() cannot be more than 0x1ff000
> > (x86-64, fault_around_bytes == 2M). It means start_addr will be aligned to 2M
> > boundary in this case which is start of the page table pte belong to.
> >
> > Do I miss something?
> 
> Nope, you're right. This fixes kernel crash but not the original problem.
> 
> Problem is caused by calling do_fault_around for _non-linear_ faiult.
> In this case pgoff is shifted and might become negative during calculation.
> I'll send another patch.

I've got to the same conclusion. My patch is below.

>From dd761b693cd06c649499e913713ae5bc7c029f6e Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Tue, 15 Jul 2014 14:40:02 +0300
Subject: [PATCH] mm: avoid do_fault_around() on non-linear mappings

Originally, I've wrongly assumed that non-linear mapping are always
populated at least with pte_file() entries there, so !pte_none() check
will catch them. It's not always the case: we can get there from
__mm_populte in remap_file_pages() and pte will be clear.

Let's put explicit check for non-linear mapping.

This is a root cause of recent "kernel BUG at mm/filemap.c:202!".

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: stable@vger.kernel.org # 3.15+
---
 mm/memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index d67fd9fcf1f2..440ad48266d6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2882,7 +2882,8 @@ static int do_read_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * if page by the offset is not ready to be mapped (cold cache or
 	 * something).
 	 */
-	if (vma->vm_ops->map_pages && fault_around_pages() > 1) {
+	if (vma->vm_ops->map_pages && fault_around_pages() > 1 &&
+			!(vma->vm_flags & VM_NONLINEAR)) {
 		pte = pte_offset_map_lock(mm, pmd, address, &ptl);
 		do_fault_around(vma, address, pte, pgoff, flags);
 		if (!pte_same(*pte, orig_pte))
-- 
2.0.1

-- 
 Kirill A. Shutemov

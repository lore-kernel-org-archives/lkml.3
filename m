Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624Ab3EBQoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 12:44:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758913Ab3EBQow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 12:44:52 -0400
Date: Thu, 02 May 2013 12:44:04 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mgorman@suse.de,
        aarcange@redhat.com, dave.hansen@intel.com, dsterba@suse.cz,
        hannes@cmpxchg.org, kosaki.motohiro@gmail.com,
        kirill.shutemov@linux.intel.com, mpm@selenic.com,
        rdunlap@infradead.org
Message-ID: <1367513044-s3jtazd5-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <E1UXsLY-0003oJ-KD@eag09.americas.sgi.com>
References: <E1UXsLY-0003oJ-KD@eag09.americas.sgi.com>
Subject: Re: [PATCH v2] mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP
 areas
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 07:10:48AM -0500, Cliff Wickman wrote:
> 
> /proc/<pid>/smaps and similar walks through a user page table should not
> be looking at VM_PFNMAP areas.
> 
> This is v2: 
> - moves the VM_BUG_ON out of the loop
> - adds the needed test for  vma->vm_start <= addr
> 
> Certain tests in walk_page_range() (specifically split_huge_page_pmd())
> assume that all the mapped PFN's are backed with page structures. And this is
> not usually true for VM_PFNMAP areas. This can result in panics on kernel
> page faults when attempting to address those page structures.
> 
> There are a half dozen callers of walk_page_range() that walk through
> a task's entire page table (as N. Horiguchi pointed out). So rather than
> change all of them, this patch changes just walk_page_range() to ignore 
> VM_PFNMAP areas.
> 
> The logic of hugetlb_vma() is moved back into walk_page_range(), as we
> want to test any vma in the range.
> 
> VM_PFNMAP areas are used by:
> - graphics memory manager   gpu/drm/drm_gem.c
> - global reference unit     sgi-gru/grufile.c
> - sgi special memory        char/mspec.c
> - and probably several out-of-tree modules
> 
> I'm copying everyone who has changed this file recently, in case
> there is some reason that I am not aware of to provide
> /proc/<pid>/smaps|clear_refs|maps|numa_maps for these VM_PFNMAP areas.
> 
> Signed-off-by: Cliff Wickman <cpw@sgi.com>

walk_page_range() does vma-based walk only for address ranges backed by
hugetlbfs, and it doesn't see vma for address ranges backed by normal pages
and thps (in those case we just walk over page table hierarchy).

I think that vma-based walk was introduced as a kind of dirty hack to
handle hugetlbfs, and it can be cleaned up in the future. So I'm afraid
it's not a good idea to extend or adding code heavily depending on this hack.
I recommend that you check VM_PFNMAP in the possible callers' side.
But this patch seems to solve your problem, so with properly commenting
this somewhere, I do not oppose it.

Thanks,
Naoya Horiguchi

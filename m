Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbaAHKJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:09:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862AbaAHKJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:09:01 -0500
Date: Wed, 8 Jan 2014 11:08:59 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Bob Liu <lliubbo@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bob Liu <bob.liu@oracle.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: could you clarify mm/mempolicy: fix !vma in new_vma_page()
Message-ID: <20140108100859.GC27937@dhcp22.suse.cz>
References: <20140106112422.GA27602@dhcp22.suse.cz>
 <CAA_GA1dNdrG9aQ3UKDA0O=BY721rvseORVkc2+RxUpzysp3rYw@mail.gmail.com>
 <20140106141827.GB27602@dhcp22.suse.cz>
 <CAA_GA1csMEhSYmeS7qgDj7h=Xh2WrsYvirkS55W4Jj3LTHy87A@mail.gmail.com>
 <20140107102212.GC8756@dhcp22.suse.cz>
 <20140107173034.GE8756@dhcp22.suse.cz>
 <CAA_GA1fN5p3-m40Mf3nqFzRrGcJ9ni9Cjs_q4fm1PCLnzW1cEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA_GA1fN5p3-m40Mf3nqFzRrGcJ9ni9Cjs_q4fm1PCLnzW1cEw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 08-01-14 08:56:44, Bob Liu wrote:
> On Wed, Jan 8, 2014 at 1:30 AM, Michal Hocko <mhocko@suse.cz> wrote:
> > On Tue 07-01-14 11:22:12, Michal Hocko wrote:
> >> On Tue 07-01-14 13:29:31, Bob Liu wrote:
> >> > On Mon, Jan 6, 2014 at 10:18 PM, Michal Hocko <mhocko@suse.cz> wrote:
> >> > > On Mon 06-01-14 20:45:54, Bob Liu wrote:
> >> > > [...]
> >> > >>  544         if (PageAnon(page)) {
> >> > >>  545                 struct anon_vma *page__anon_vma = page_anon_vma(page);
> >> > >>  546                 /*
> >> > >>  547                  * Note: swapoff's unuse_vma() is more efficient with this
> >> > >>  548                  * check, and needs it to match anon_vma when KSM is active.
> >> > >>  549                  */
> >> > >>  550                 if (!vma->anon_vma || !page__anon_vma ||
> >> > >>  551                     vma->anon_vma->root != page__anon_vma->root)
> >> > >>  552                         return -EFAULT;
> >> > >>  553         } else if (page->mapping && !(vma->vm_flags & VM_NONLINEAR)) {
> >> > >>  554                 if (!vma->vm_file ||
> >> > >>  555                     vma->vm_file->f_mapping != page->mapping)
> >> > >>  556                         return -EFAULT;
> >> > >>  557         } else
> >> > >>  558                 return -EFAULT;
> >> > >>
> >> > >> That's the "other conditions" and the reason why we can't use
> >> > >> BUG_ON(!vma) in new_vma_page().
> >> > >
> >> > > Sorry, I wasn't clear with my question. I was interested in which of
> >> > > these triggered and why only for hugetlb pages?
> >> > >
> >> >
> >> > Sorry I didn't analyse the root cause. They are several checks in
> >> > page_address_in_vma() so I think it might be not difficult to hit one
> >> > of them.
> >>
> >> I would be really curious when anon_vma or f_mapping would be out of
> >> sync, that's why I've asked in the first place.
> >>
> >> > For example, if the page was mapped to vma by nonlinear
> >> > mapping?
> >>
> >> Hmm, ok !private shmem/hugetlbfs might be remapped as non-linear.
> >
> > OK, it didn't let go away from my head so I had to check. hugetlbfs
> > cannot be remmaped as non-linear because it is missing its vm_ops is
> > missing remap_pages implementation. So this case is impossible for these
> > pages. So at least the PageHuge part of the patch is bogus AFAICS.
> >
> > We still have shmem and even then I am curious whether we are doing the
> > right thing. The loop is inteded to handle range spanning multiple VMAs
> > (as per 3ad33b2436b54 (Migration: find correct vma in new_vma_page()))
> > and it doesn't seem to be VM_NONLINEAR aware. It will always fail for
> > shared shmem and so we always fallback to task/system default mempolicy.
> > Whether somebody uses mempolicy on VM_NONLINEAR mappings is hard to
> > tell. I am not familiar with this feature much.
> >
> > That being said. The BUG_ON(!vma) was bogus for VM_NONLINEAR cases.
> > The changed code could keep it for hugetlbfs path because we shouldn't
> > see NULL vma there AFAICS.
> >
> 
> Sounds reasonable, but as your said we'd better find out the root
> cause before making any changes.
> Do you think below debug info is enough? If yes, then we can ask Sasha
> help us having a test.

If I was debugging this I would simply add printk into page_address_in_vma
error paths.

Anyway, I think that at least hugetlbfs part should be reverted because
it might paper over real bugs. Although the migration would fail for
such hugetlb page we should catch that a weird page was tried to be
migrated. What about the patch below?
---
>From 2d61421f26a3b63b4670d71b7adc67e2191b6157 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 8 Jan 2014 10:57:41 +0100
Subject: [PATCH] mm: new_vma_page cannot see NULL vma for hugetlb pages

11c731e81bb0 (mm/mempolicy: fix !vma in new_vma_page()) has removed
BUG_ON(!vma) from new_vma_page which is partially correct because
page_address_in_vma will return EFAULT for non-linear mappings and at
least shared shmem might be mapped this way.

The patch also tried to prevent NULL ptr for hugetlb pages which is not
correct AFAICS because hugetlb pages cannot be mapped as VM_NONLINEAR
and other conditions in page_address_in_vma seem to be legit and catch
real bugs.

This patch restores BUG_ON for PageHuge to catch potential issues when
the to-be-migrated page is not setup properly.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/mempolicy.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 9e8d2d86978a..f3f51464a23b 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1199,10 +1199,8 @@ static struct page *new_vma_page(struct page *page, unsigned long private, int *
 	}
 
 	if (PageHuge(page)) {
-		if (vma)
-			return alloc_huge_page_noerr(vma, address, 1);
-		else
-			return NULL;
+		BUG_ON(vma)
+		return alloc_huge_page_noerr(vma, address, 1);
 	}
 	/*
 	 * if !vma, alloc_page_vma() will use task or system default policy
-- 
1.8.5.2

-- 
Michal Hocko
SUSE Labs

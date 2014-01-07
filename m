Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaAGRap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:30:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbaAGRaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:30:39 -0500
Date: Tue, 7 Jan 2014 18:30:34 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Bob Liu <lliubbo@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bob Liu <bob.liu@oracle.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: could you clarify mm/mempolicy: fix !vma in new_vma_page()
Message-ID: <20140107173034.GE8756@dhcp22.suse.cz>
References: <20140106112422.GA27602@dhcp22.suse.cz>
 <CAA_GA1dNdrG9aQ3UKDA0O=BY721rvseORVkc2+RxUpzysp3rYw@mail.gmail.com>
 <20140106141827.GB27602@dhcp22.suse.cz>
 <CAA_GA1csMEhSYmeS7qgDj7h=Xh2WrsYvirkS55W4Jj3LTHy87A@mail.gmail.com>
 <20140107102212.GC8756@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107102212.GC8756@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 07-01-14 11:22:12, Michal Hocko wrote:
> On Tue 07-01-14 13:29:31, Bob Liu wrote:
> > On Mon, Jan 6, 2014 at 10:18 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > > On Mon 06-01-14 20:45:54, Bob Liu wrote:
> > > [...]
> > >>  544         if (PageAnon(page)) {
> > >>  545                 struct anon_vma *page__anon_vma = page_anon_vma(page);
> > >>  546                 /*
> > >>  547                  * Note: swapoff's unuse_vma() is more efficient with this
> > >>  548                  * check, and needs it to match anon_vma when KSM is active.
> > >>  549                  */
> > >>  550                 if (!vma->anon_vma || !page__anon_vma ||
> > >>  551                     vma->anon_vma->root != page__anon_vma->root)
> > >>  552                         return -EFAULT;
> > >>  553         } else if (page->mapping && !(vma->vm_flags & VM_NONLINEAR)) {
> > >>  554                 if (!vma->vm_file ||
> > >>  555                     vma->vm_file->f_mapping != page->mapping)
> > >>  556                         return -EFAULT;
> > >>  557         } else
> > >>  558                 return -EFAULT;
> > >>
> > >> That's the "other conditions" and the reason why we can't use
> > >> BUG_ON(!vma) in new_vma_page().
> > >
> > > Sorry, I wasn't clear with my question. I was interested in which of
> > > these triggered and why only for hugetlb pages?
> > >
> > 
> > Sorry I didn't analyse the root cause. They are several checks in
> > page_address_in_vma() so I think it might be not difficult to hit one
> > of them.
> 
> I would be really curious when anon_vma or f_mapping would be out of
> sync, that's why I've asked in the first place.
> 
> > For example, if the page was mapped to vma by nonlinear
> > mapping?
> 
> Hmm, ok !private shmem/hugetlbfs might be remapped as non-linear.

OK, it didn't let go away from my head so I had to check. hugetlbfs
cannot be remmaped as non-linear because it is missing its vm_ops is
missing remap_pages implementation. So this case is impossible for these
pages. So at least the PageHuge part of the patch is bogus AFAICS.

We still have shmem and even then I am curious whether we are doing the
right thing. The loop is inteded to handle range spanning multiple VMAs
(as per 3ad33b2436b54 (Migration: find correct vma in new_vma_page()))
and it doesn't seem to be VM_NONLINEAR aware. It will always fail for
shared shmem and so we always fallback to task/system default mempolicy.
Whether somebody uses mempolicy on VM_NONLINEAR mappings is hard to
tell. I am not familiar with this feature much.

That being said. The BUG_ON(!vma) was bogus for VM_NONLINEAR cases.
The changed code could keep it for hugetlbfs path because we shouldn't
see NULL vma there AFAICS.

What is the right(tm) thing to do for VM_NONLINEAR is hard to tell and I
would leave it to those who are more familiar with the usage.

-- 
Michal Hocko
SUSE Labs

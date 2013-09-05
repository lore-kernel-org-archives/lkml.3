Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763636Ab3IEJS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:18:29 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:57964 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763397Ab3IEJS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:18:27 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Andi Kleen <andi@firstfloor.org>,
        Michal Hocko <mhocko@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        kirill.shutemov@linux.intel.com, Alex Thorlton <athorlton@sgi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hugetlbfs: support split page table lock
In-Reply-To: <1378312330-afoa3r2y-mutt-n-horiguchi@ah.jp.nec.com>
References: <1377883120-5280-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1377883120-5280-2-git-send-email-n-horiguchi@ah.jp.nec.com> <87li3dvz3k.fsf@linux.vnet.ibm.com> <1378312330-afoa3r2y-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Notmuch/0.16+32~g01f5508 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Thu, 05 Sep 2013 14:48:18 +0530
Message-ID: <87d2onwrs5.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090509-5140-0000-0000-000003C830E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:

> Hi Aneesh,
>
> On Wed, Sep 04, 2013 at 12:43:19PM +0530, Aneesh Kumar K.V wrote:
>> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:
>> 
>> > Currently all of page table handling by hugetlbfs code are done under
>> > mm->page_table_lock. So when a process have many threads and they heavily
>> > access to the memory, lock contention happens and impacts the performance.
>> >
>> > This patch makes hugepage support split page table lock so that we use
>> > page->ptl of the leaf node of page table tree which is pte for normal pages
>> > but can be pmd and/or pud for hugepages of some architectures.
>> >
>> > ChangeLog v2:
>> >  - add split ptl on other archs missed in v1
>> >
>> > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>> > ---
>> >  arch/powerpc/mm/hugetlbpage.c |  6 ++-
>> >  arch/tile/mm/hugetlbpage.c    |  6 ++-
>> >  include/linux/hugetlb.h       | 20 ++++++++++
>> >  mm/hugetlb.c                  | 92 ++++++++++++++++++++++++++-----------------
>> >  mm/mempolicy.c                |  5 ++-
>> >  mm/migrate.c                  |  4 +-
>> >  mm/rmap.c                     |  2 +-
>> >  7 files changed, 90 insertions(+), 45 deletions(-)
>> >
>> > diff --git v3.11-rc3.orig/arch/powerpc/mm/hugetlbpage.c v3.11-rc3/arch/powerpc/mm/hugetlbpage.c
>> > index d67db4b..7e56cb7 100644
>> > --- v3.11-rc3.orig/arch/powerpc/mm/hugetlbpage.c
>> > +++ v3.11-rc3/arch/powerpc/mm/hugetlbpage.c
>> > @@ -124,6 +124,7 @@ static int __hugepte_alloc(struct mm_struct *mm, hugepd_t *hpdp,
>> >  {
>> >  	struct kmem_cache *cachep;
>> >  	pte_t *new;
>> > +	spinlock_t *ptl;
>> >
>> >  #ifdef CONFIG_PPC_FSL_BOOK3E
>> >  	int i;
>> > @@ -141,7 +142,8 @@ static int __hugepte_alloc(struct mm_struct *mm, hugepd_t *hpdp,
>> >  	if (! new)
>> >  		return -ENOMEM;
>> >
>> > -	spin_lock(&mm->page_table_lock);
>> > +	ptl = huge_pte_lockptr(mm, new);
>> > +	spin_lock(ptl);
>> 
>> 
>> Are you sure we can do that for ppc ?
>> 	new = kmem_cache_zalloc(cachep, GFP_KERNEL|__GFP_REPEAT);
>
> Ah, thanks. new is not a pointer to one full page occupied by page
> table entries, so trying to use struct page of it is totally wrong.
>
>> The page for new(pte_t) could be shared right ? which mean a deadlock ?
>
> Yes, that's disastrous.
>
>> May be you should do it at the pmd level itself for ppc

The pgd page also cannot be used because pgd also comes from kmem
cache.

>
> Yes, that's possible, but I simply drop the changes in __hugepte_alloc()
> for now because this lock seems to protect us from the race between concurrent
> calls of __hugepte_alloc(), not between allocation and read/write access.
> Split ptl is used to avoid race between read/write accesses, so I think
> that using different types of locks here is not dangerous.
> # I guess that that's why we now use mm->page_table_lock for __pte_alloc()
> # and its family even if USE_SPLIT_PTLOCKS is true.

A simpler approach could be to make huge_pte_lockptr arch
specific and leave it as mm->page_table_lock for ppc 


-aneesh


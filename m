Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498Ab3DCAOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 20:14:07 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56828 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758219Ab3DCAOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 20:14:05 -0400
X-AuditID: 9c930197-b7b50ae00000018c-bb-515b744af073
Date: Wed, 3 Apr 2013 09:14:01 +0900
From: Minchan Kim <minchan@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] THP: Use explicit memory barrier
Message-ID: <20130403001401.GC16026@blaptop>
References: <1364773535-26264-1-git-send-email-minchan@kernel.org>
 <alpine.DEB.2.02.1304011634530.21603@chino.kir.corp.google.com>
 <20130402003746.GA30444@blaptop>
 <alpine.LNX.2.00.1304021221240.5808@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1304021221240.5808@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 12:30:15PM -0700, Hugh Dickins wrote:
> On Tue, 2 Apr 2013, Minchan Kim wrote:
> > On Mon, Apr 01, 2013 at 04:35:38PM -0700, David Rientjes wrote:
> > > On Mon, 1 Apr 2013, Minchan Kim wrote:
> > > 
> > > > __do_huge_pmd_anonymous_page depends on page_add_new_anon_rmap's
> > > > spinlock for making sure that clear_huge_page write become visible
> > > > after set set_pmd_at() write.
> > > > 
> > > > But lru_cache_add_lru uses pagevec so it could miss spinlock
> > > > easily so above rule was broken so user may see inconsistent data.
> > > > 
> > > > This patch fixes it with using explict barrier rather than depending
> > > > on lru spinlock.
> > > > 
> > > 
> > > Is this the same issue that Andrea responded to in the "thp and memory 
> > > barrier assumptions" thread at http://marc.info/?t=134333512700004 ?
> > 
> > Yes and Peter pointed out further step.
> > Thanks for pointing out.
> > Not that I know that Andrea alreay noticed it, I don't care about this
> > patch.
> > 
> > Remaining question is Kame's one.
> > > Hmm...how about do_anonymous_page() ? there are no comments/locks/barriers.
> > > Users can see non-zero value after page fault in theory ?
> > Isn't there anyone could answer it?
> 
> See Nick's 2008 0ed361dec "mm: fix PageUptodate data race", which gave us
> 
> static inline void __SetPageUptodate(struct page *page)
> {
> 	smp_wmb();
> 	__set_bit(PG_uptodate, &(page)->flags);
> }
> 
> So both do_anonymous_page() and __do_huge_pmd_anonymous_page() look safe
> to me already, though the huge_memory one could do with a fixed comment.

Thanks you very much!
That's one everybody are really missing.

Here it goes!

==================== 8< =====================

>From fb0b9f3df698547bfb70f81d85e0d1e00f19e1fc Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Wed, 3 Apr 2013 08:53:27 +0900
Subject: [PATCH] THP: fix comment about memory barrier

Now, memory barrier in __do_huge_pmd_anonymous_page doesn't work.
Because lru_cache_add_lru uses pagevec so it could miss spinlock
easily so above rule was broken so user might see inconsistent data.

I was not first person who pointed out the problem. Mel and Peter
pointed out a few months ago and Peter pointed out further that
even spin_lock/unlock can't make sure it.
http://marc.info/?t=134333512700004

	In particular:

        	*A = a;
        	LOCK
        	UNLOCK
        	*B = b;

	may occur as:

        	LOCK, STORE *B, STORE *A, UNLOCK

At last, Hugh pointed out that even we don't need memory barrier
in there because __SetPageUpdate already have done it from
Nick's [1] explicitly.

So this patch fixes comment on THP and adds same comment for
do_anonymous_page, too because everybody except Hugh was missing
that. It means we needs COMMENT about that.

[1] 0ed361dec "mm: fix PageUptodate data race"

Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/huge_memory.c | 11 +++++------
 mm/memory.c      |  5 +++++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e2f7f5aa..f2f17ff 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -713,6 +713,11 @@ static int __do_huge_pmd_anonymous_page(struct mm_struct *mm,
 		return VM_FAULT_OOM;
 
 	clear_huge_page(page, haddr, HPAGE_PMD_NR);
+	/*
+	 * The memory barrier inside __SetPageUptodate makes sure that
+	 * clear_huge_page writes become visible after the set_pmd_at()
+	 * write.
+	 */
 	__SetPageUptodate(page);
 
 	spin_lock(&mm->page_table_lock);
@@ -724,12 +729,6 @@ static int __do_huge_pmd_anonymous_page(struct mm_struct *mm,
 	} else {
 		pmd_t entry;
 		entry = mk_huge_pmd(page, vma);
-		/*
-		 * The spinlocking to take the lru_lock inside
-		 * page_add_new_anon_rmap() acts as a full memory
-		 * barrier to be sure clear_huge_page writes become
-		 * visible after the set_pmd_at() write.
-		 */
 		page_add_new_anon_rmap(page, vma, haddr);
 		set_pmd_at(mm, haddr, pmd, entry);
 		pgtable_trans_huge_deposit(mm, pgtable);
diff --git a/mm/memory.c b/mm/memory.c
index 494526a..d0da51e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3196,6 +3196,11 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	page = alloc_zeroed_user_highpage_movable(vma, address);
 	if (!page)
 		goto oom;
+	/*
+	 * The memory barrier inside __SetPageUptodate makes sure that
+	 * preceeding stores to the page contents become visible after
+	 * the set_pte_at() write.
+	 */
 	__SetPageUptodate(page);
 
 	if (mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))
-- 
1.8.2

-- 
Kind regards,
Minchan Kim

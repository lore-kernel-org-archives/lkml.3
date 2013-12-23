Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab3LWCLW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 21:11:22 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47968 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949Ab3LWCLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 21:11:21 -0500
X-AuditID: 9c93016f-b7b37ae000002852-2b-52b79bc7aa69
Date: Mon, 23 Dec 2013 11:11:19 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>, aswin@hp.com
Subject: Re: [PATCH v3 13/14] mm, hugetlb: retry if failed to allocate and
 there is concurrent user
Message-ID: <20131223021118.GA2487@lge.com>
References: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1387349640-8071-14-git-send-email-iamjoonsoo.kim@lge.com>
 <20131219170202.0df2d82a2adefa3ab616bdaa@linux-foundation.org>
 <20131220140153.GC11295@suse.de>
 <1387608497.3119.17.camel@buesod1.americas.hpqcorp.net>
 <20131223004438.GA19388@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131223004438.GA19388@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 09:44:38AM +0900, Joonsoo Kim wrote:
> On Fri, Dec 20, 2013 at 10:48:17PM -0800, Davidlohr Bueso wrote:
> > On Fri, 2013-12-20 at 14:01 +0000, Mel Gorman wrote:
> > > On Thu, Dec 19, 2013 at 05:02:02PM -0800, Andrew Morton wrote:
> > > > On Wed, 18 Dec 2013 15:53:59 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> > > > 
> > > > > If parallel fault occur, we can fail to allocate a hugepage,
> > > > > because many threads dequeue a hugepage to handle a fault of same address.
> > > > > This makes reserved pool shortage just for a little while and this cause
> > > > > faulting thread who can get hugepages to get a SIGBUS signal.
> > > > > 
> > > > > To solve this problem, we already have a nice solution, that is,
> > > > > a hugetlb_instantiation_mutex. This blocks other threads to dive into
> > > > > a fault handler. This solve the problem clearly, but it introduce
> > > > > performance degradation, because it serialize all fault handling.
> > > > > 
> > > > > Now, I try to remove a hugetlb_instantiation_mutex to get rid of
> > > > > performance degradation.
> > > > 
> > > > So the whole point of the patch is to improve performance, but the
> > > > changelog doesn't include any performance measurements!
> > > > 
> > > 
> > > I don't really deal with hugetlbfs any more and I have not examined this
> > > series but I remember why I never really cared about this mutex. It wrecks
> > > fault scalability but AFAIK fault scalability almost never mattered for
> > > workloads using hugetlbfs.  The most common user of hugetlbfs by far is
> > > sysv shared memory. The memory is faulted early in the lifetime of the
> > > workload and after that it does not matter. At worst, it hurts application
> > > startup time but that is still poor motivation for putting a lot of work
> > > into removing the mutex.
> > 
> > Yep, important hugepage workloads initially pound heavily on this lock,
> > then it naturally decreases.
> > 
> > > Microbenchmarks will be able to trigger problems in this area but it'd
> > > be important to check if any workload that matters is actually hitting
> > > that problem.
> > 
> > I was thinking of writing one to actually get some numbers for this
> > patchset -- I don't know of any benchmark that might stress this lock. 
> > 
> > However I first measured the amount of cycles it costs to start an
> > Oracle DB and things went south with these changes. A simple 'startup
> > immediate' calls hugetlb_fault() ~5000 times. For a vanilla kernel, this
> > costs ~7.5 billion cycles and with this patchset it goes up to ~27.1
> > billion. While there is naturally a fair amount of variation, these
> > changes do seem to do more harm than good, at least in real world
> > scenarios.
> 
> Hello,
> 
> I think that number of cycles is not proper to measure this patchset,
> because cycles would be wasted by fault handling failure. Instead, it
> targeted improved elapsed time. Could you tell me how long it
> takes to fault all of it's hugepages?
> 
> Anyway, this order of magnitude still seems a problem. :/
> 
> I guess that cycles are wasted by zeroing hugepage in fault-path like as
> Andrew pointed out.
> 
> I will send another patches to fix this problem.

Hello, Davidlohr.

Here goes the fix on top of this series.
Thanks.

-------------->8---------------------------
>From 5f20459d90dfa2f7cd28d62194ce22bd9a0df0f5 Mon Sep 17 00:00:00 2001
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Mon, 23 Dec 2013 10:32:04 +0900
Subject: [PATCH] mm, hugetlb: optimize zeroing hugepage

When parallel faults occur, someone would be failed. In this case,
cpu cycles for zeroing failed hugepage is wasted. To reduce this overhead,
mark the hugepage as zeroed hugepage after zeroing hugepage and unmark
it as non-zeroed hugepage after it is really used. If it isn't used with
any reason, it returns back to the hugepage pool and it will be used
sometime ago. At this time, we would see zeroed page marker and skip to
do zeroing.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6edf423..b90b792 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -582,6 +582,7 @@ static void update_and_free_page(struct hstate *h, struct page *page)
 				1 << PG_private | 1 << PG_writeback);
 	}
 	VM_BUG_ON(hugetlb_cgroup_from_page(page));
+	ClearPageActive(page);
 	set_compound_page_dtor(page, NULL);
 	set_page_refcounted(page);
 	arch_release_hugepage(page);
@@ -2715,6 +2716,7 @@ retry_avoidcopy:
 	spin_lock(ptl);
 	ptep = huge_pte_offset(mm, address & huge_page_mask(h));
 	if (likely(pte_same(huge_ptep_get(ptep), pte))) {
+		ClearPageActive(new_page);
 		ClearPagePrivate(new_page);
 
 		/* Break COW */
@@ -2834,7 +2836,10 @@ retry:
 			}
 			goto out;
 		}
-		clear_huge_page(page, address, pages_per_huge_page(h));
+		if (!PageActive(page)) {
+			clear_huge_page(page, address, pages_per_huge_page(h));
+			SetPageActive(page);
+		}
 		__SetPageUptodate(page);
 
 		if (vma->vm_flags & VM_MAYSHARE) {
@@ -2850,6 +2855,7 @@ retry:
 					goto retry;
 				goto out;
 			}
+			ClearPageActive(page);
 			ClearPagePrivate(page);
 			if (do_dequeue)
 				commit_dequeued_huge_page(vma);
@@ -2901,6 +2907,7 @@ retry:
 		goto backout;
 
 	if (anon_rmap) {
+		ClearPageActive(page);
 		ClearPagePrivate(page);
 		hugepage_add_new_anon_rmap(page, vma, address);
 	}
-- 
1.7.9.5


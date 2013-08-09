Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965818Ab3HIJ1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:27:11 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59885 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965514Ab3HIJ1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:27:08 -0400
X-AuditID: 9c930197-b7b44ae00000347f-8f-5204b5e9cca9
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 00/20] mm, hugetlb: remove a hugetlb_instantiation_mutex
Date: Fri,  9 Aug 2013 18:26:18 +0900
Message-Id: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without a hugetlb_instantiation_mutex, if parallel fault occur, we can
fail to allocate a hugepage, because many threads dequeue a hugepage
to handle a fault of same address. This makes reserved pool shortage
just for a little while and this cause faulting thread to get a SIGBUS
signal, although there are enough hugepages.

To solve this problem, we already have a nice solution, that is,
a hugetlb_instantiation_mutex. This blocks other threads to dive into
a fault handler. This solve the problem clearly, but it introduce
performance degradation, because it serialize all fault handling.
    
Now, I try to remove a hugetlb_instantiation_mutex to get rid of
performance problem reported by Davidlohr Bueso [1].

This patchset consist of 4 parts roughly.

Part 1. (1-6) Random fix and clean-up. Enhancing error handling.
	
	These can be merged into mainline separately.

Part 2. (7-9) Protect region tracking via it's own spinlock, instead of
	the hugetlb_instantiation_mutex.
	
	Breaking dependency on the hugetlb_instantiation_mutex for
	tracking a region is also needed by other approaches like as
	'table mutexes', so these can be merged into mainline separately.

Part 3. (10-13) Clean-up.
	
	IMO, these make code really simple, so these are worth to go into
	mainline separately, regardless success of my approach.

Part 4. (14-20) Remove a hugetlb_instantiation_mutex.
	
	Almost patches are just for clean-up to error handling path.
	In patch 19, retry approach is implemented that if faulted thread
	failed to allocate a hugepage, it continue to run a fault handler
	until there is no concurrent thread having a hugepage. This causes
	threads who want to get a last hugepage to be serialized, so
	threads don't get a SIGBUS if enough hugepage exist.
	In patch 20, remove a hugetlb_instantiation_mutex.

These patches are based on my previous patchset [2] which is now on mmotm.
In my compile testing, [2] and this patchset can be applied to
v3.11-rc4 cleanly, but, I do running test of this patchset on top of v3.10 :)

With applying these, I passed a libhugetlbfs test suite clearly which
have allocation-instantiation race test cases.

If there is a something I should consider, please let me know!
Thanks.

* Changes in v2
- Re-order patches to clear it's relationship
- sleepable object allocation(kmalloc) without holding a spinlock
	(Pointed by Hillf)
- Remove vma_has_reserves, instead of vma_needs_reservation.
	(Suggest by Aneesh and Naoya)
- Change a way of returning a hugepage back to reserved pool
	(Suggedt by Naoya)


[1] http://lwn.net/Articles/558863/ 
	"[PATCH] mm/hugetlb: per-vma instantiation mutexes"
[2] https://lkml.org/lkml/2013/7/22/96
	"[PATCH v2 00/10] mm, hugetlb: clean-up and possible bug fix"

Joonsoo Kim (20):
  mm, hugetlb: protect reserved pages when soft offlining a hugepage
  mm, hugetlb: change variable name reservations to resv
  mm, hugetlb: fix subpool accounting handling
  mm, hugetlb: remove useless check about mapping type
  mm, hugetlb: grab a page_table_lock after page_cache_release
  mm, hugetlb: return a reserved page to a reserved pool if failed
  mm, hugetlb: unify region structure handling
  mm, hugetlb: region manipulation functions take resv_map rather
    list_head
  mm, hugetlb: protect region tracking via newly introduced resv_map
    lock
  mm, hugetlb: remove resv_map_put()
  mm, hugetlb: make vma_resv_map() works for all mapping type
  mm, hugetlb: remove vma_has_reserves()
  mm, hugetlb: mm, hugetlb: unify chg and avoid_reserve to use_reserve
  mm, hugetlb: call vma_needs_reservation before entering
    alloc_huge_page()
  mm, hugetlb: remove a check for return value of alloc_huge_page()
  mm, hugetlb: move down outside_reserve check
  mm, hugetlb: move up anon_vma_prepare()
  mm, hugetlb: clean-up error handling in hugetlb_cow()
  mm, hugetlb: retry if failed to allocate and there is concurrent user
  mm, hugetlb: remove a hugetlb_instantiation_mutex

 fs/hugetlbfs/inode.c    |   16 +-
 include/linux/hugetlb.h |   11 ++
 mm/hugetlb.c            |  419 +++++++++++++++++++++++++----------------------
 3 files changed, 250 insertions(+), 196 deletions(-)

-- 
1.7.9.5


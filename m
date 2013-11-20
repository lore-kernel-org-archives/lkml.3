Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3KTRvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:51:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab3KTRvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:51:49 -0500
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Khalid Aziz <khalid.aziz@oracle.com>,
        Pravin Shelar <pshelar@nicira.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Minchan Kim <minchan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/8] mm: hugetlbfs: fix hugetlbfs optimization v3
Date: Wed, 20 Nov 2013 18:51:08 +0100
Message-Id: <1384969876-6374-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v2:

1) optimize away a few more locked ops in the get_page/put_page
   hugetlbfs and slab paths (see 3/8 and 4/8).

   3/8 is the least trivial addition to the series as we now are
   running PageSlab and PageHeadHuge on random page structure without
   holding any reference count on this. A smp_rmb() if any of the two
   checks succeeds is what is supposed to make it safe doing so and
   it's lighter weight than get_page_unless_zero (hence the supposed
   optimization out of it). 3/8 makes no difference whatsoever to the
   speed of the THP case. It's unclear if 3/8 is worth it but it seems
   every bit is affecting performance for directio over hugetlbfs with
   >8GB/sec storage devices so I thought of trying it. 4/8 is quite
   self explanatory and it removes some smp_rmb which is not needed
   with the current layout of the struct page.

2) two nice cleanups from Andrew

3) Removed the PageHeadHuge export as it's not needed right now

Andrea Arcangeli (6):
  mm: hugetlbfs: fix hugetlbfs optimization
  mm: hugetlb: use get_page_foll in follow_hugetlb_page
  mm: hugetlbfs: move the put/get_page slab and hugetlbfs optimization
    in a faster path
  mm: thp: optimize compound_trans_huge
  mm: tail page refcounting optimization for slab and hugetlbfs
  mm/hugetlb.c: defer PageHeadHuge() symbol export

Andrew Morton (2):
  mm/hugetlb.c: simplify PageHeadHuge() and PageHuge()
  mm/swap.c: reorganize put_compound_page()

 include/linux/huge_mm.h |  23 ++++
 include/linux/mm.h      |  32 +++++-
 mm/hugetlb.c            |  20 +++-
 mm/internal.h           |   3 +-
 mm/swap.c               | 284 +++++++++++++++++++++++++++++-------------------
 5 files changed, 240 insertions(+), 122 deletions(-)


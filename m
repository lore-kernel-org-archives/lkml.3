Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3KORsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 12:48:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab3KORsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 12:48:20 -0500
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
Subject: [PATCH 0/3] mm: hugetlbfs: fix hugetlbfs optimization v2
Date: Fri, 15 Nov 2013 18:47:45 +0100
Message-Id: <1384537668-10283-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

1/3 is a bugfix so it should be applied more urgently. 1/3 is not as
fast as the current upstream code in the hugetlbfs + directio extreme
8GB/sec benchmark (but 3/3 should fill the gap later). The code is
identical to the one I posted in v1 just rebased on upstream and was
developed in collaboration with Khalid who already tested it.

2/3 and 3/3 had very little testing yet, and they're incremental
optimization. 2/3 is minor and most certainly worth applying later.

3/3 instead complicates things a bit and adds more branches to the THP
fast paths, so it should only be applied if the benchmarks of
hugetlbfs + directio show that it is very worthwhile (that has not
been verified yet). If it's not worthwhile 3/3 should be dropped (and
the gap should be filled in some other way if the gap is not caused by
the _mapcount mangling as I guessed). Ideally this should bring even
more performance than current upstream code, as current upstream code
still increased the _mapcount in gup_fast by mistake, while this
eliminates the locked op on the tail page cacheline in gup_fast too
(which is required for correctness too).

As a side note: the _mapcount refcounting on tail pages is only needed
for THP as it is a fundamental information required for
split_huge_page_refcount to be able to distribute the head refcounts
during the split. And it is done on _mapcount instead of the _count,
because the _count would screwup badly with the get_page_unless_zero
speculative pagecache accesses.

Andrea Arcangeli (3):
  mm: hugetlbfs: fix hugetlbfs optimization
  mm: hugetlb: use get_page_foll in follow_hugetlb_page
  mm: tail page refcounting optimization for slab and hugetlbfs

 include/linux/mm.h |  30 ++++++++-
 mm/hugetlb.c       |  19 +++++-
 mm/internal.h      |   3 +-
 mm/swap.c          | 187 ++++++++++++++++++++++++++++++++++-------------------
 4 files changed, 170 insertions(+), 69 deletions(-)


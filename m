Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbaCNGhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 02:37:54 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56012 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbaCNGh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 02:37:27 -0400
X-AuditID: 9c93017e-b7cf9ae000004b4b-d9-5322a3a55f16
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Jason Evans <je@fb.com>, Minchan Kim <minchan@kernel.org>
Subject: [RFC 0/6] mm: support madvise(MADV_FREE)
Date: Fri, 14 Mar 2014 15:37:44 +0900
Message-Id: <1394779070-8545-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.9.0
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is an attempt to support MADV_FREE for Linux.

Rationale is following as.

Allocators call munmap(2) when user call free(3) if ptr is
in mmaped area. But munmap isn't cheap because it have to clean up
all pte entries, unlinking a vma and returns free pages to buddy
so overhead would be increased linearly by mmaped area's size.
So they like madvise_dontneed rather than munmap.

"dontneed" holds read-side lock of mmap_sem so other threads
of the process could go with concurrent page faults so it is
better than munmap if it's not lack of address space.
But the problem is that most of allocator reuses that address
space soonish so applications see page fault, page allocation,
page zeroing if allocator already called madvise_dontneed
on the address space.

For avoidng that overheads, other OS have supported MADV_FREE.
The idea is just mark pages as lazyfree when madvise called
and purge them if memory pressure happens. Otherwise, VM doesn't
detach pages on the address space so application could use
that memory space without above overheads.

I tweaked jamalloc to use MADV_FREE for the testing.

diff --git a/src/chunk_mmap.c b/src/chunk_mmap.c
index 8a42e75..20e31af 100644
--- a/src/chunk_mmap.c
+++ b/src/chunk_mmap.c
@@ -131,7 +131,7 @@ pages_purge(void *addr, size_t length)
 #  else
 #    error "No method defined for purging unused dirty pages."
 #  endif
-       int err = madvise(addr, length, JEMALLOC_MADV_PURGE);
+       int err = madvise(addr, length, 5);
        unzeroed = (JEMALLOC_MADV_ZEROS == false || err != 0);
 #  undef JEMALLOC_MADV_PURGE
 #  undef JEMALLOC_MADV_ZEROS


RAM 2G, CPU 4, ebizzy benchmark(./ebizzy -S 30 -n 512)

(1.1) stands for 1 process and 1 thread so for exmaple,
(1.4) is 1 process and 4 thread.

vanilla jemalloc	 patched jemalloc

1.1       1.1
records:  5              records:  5
avg:      7404.60        avg:      14059.80
std:      116.67(1.58%)  std:      93.92(0.67%)
max:      7564.00        max:      14152.00
min:      7288.00        min:      13893.00
1.4       1.4
records:  5              records:  5
avg:      16160.80       avg:      30173.00
std:      509.80(3.15%)  std:      3050.72(10.11%)
max:      16728.00       max:      33989.00
min:      15216.00       min:      25173.00
1.8       1.8
records:  5              records:  5
avg:      16003.00       avg:      30080.20
std:      290.40(1.81%)  std:      2063.57(6.86%)
max:      16537.00       max:      32735.00
min:      15727.00       min:      27381.00
4.1       4.1
records:  5              records:  5
avg:      4003.60        avg:      8064.80
std:      65.33(1.63%)   std:      143.89(1.78%)
max:      4118.00        max:      8319.00
min:      3921.00        min:      7888.00
4.4       4.4
records:  5              records:  5
avg:      3907.40        avg:      7199.80
std:      48.68(1.25%)   std:      80.21(1.11%)
max:      3997.00        max:      7320.00
min:      3863.00        min:      7113.00
4.8       4.8
records:  5              records:  5
avg:      3893.00        avg:      7195.20
std:      19.11(0.49%)   std:      101.55(1.41%)
max:      3927.00        max:      7309.00
min:      3869.00        min:      7012.00
8.1       8.1
records:  5              records:  5
avg:      1942.00        avg:      3602.80
std:      34.60(1.78%)   std:      22.97(0.64%)
max:      2010.00        max:      3632.00
min:      1913.00        min:      3563.00
8.4       8.4
records:  5              records:  5
avg:      1938.00        avg:      3405.60
std:      32.77(1.69%)   std:      36.25(1.06%)
max:      1998.00        max:      3468.00
min:      1905.00        min:      3374.00
8.8       8.8
records:  5              records:  5
avg:      1977.80        avg:      3434.20
std:      25.75(1.30%)   std:      57.95(1.69%)
max:      2011.00        max:      3533.00
min:      1937.00        min:      3363.00

So, MADV_FREE is 2 time faster than MADV_DONTNEED for
every cases.

I didn't test a lot but it's enough to show the concept and
direction before LSF/MM.

Patchset is based on 3.14-rc6.

Welcome any comment!

Minchan Kim (6):
  mm: clean up PAGE_MAPPING_FLAGS
  mm: work deactivate_page with anon pages
  mm: support madvise(MADV_FREE)
  mm: add stat about lazyfree pages
  mm: reclaim lazyfree pages in swapless system
  mm: ksm: don't merge lazyfree page

 include/asm-generic/tlb.h              |  9 ++++++++
 include/linux/mm.h                     | 39 +++++++++++++++++++++++++++++++++-
 include/linux/mm_inline.h              |  9 ++++++++
 include/linux/mmzone.h                 |  1 +
 include/linux/rmap.h                   |  1 +
 include/linux/swap.h                   | 15 +++++++++++++
 include/linux/vm_event_item.h          |  1 +
 include/uapi/asm-generic/mman-common.h |  1 +
 mm/ksm.c                               | 18 +++++++++++-----
 mm/madvise.c                           | 17 +++++++++++++--
 mm/memory.c                            | 12 ++++++++++-
 mm/page_alloc.c                        |  5 ++++-
 mm/rmap.c                              | 25 ++++++++++++++++++----
 mm/swap.c                              | 20 ++++++++---------
 mm/swap_state.c                        | 38 ++++++++++++++++++++++++++++++++-
 mm/vmscan.c                            | 32 +++++++++++++++++++++++++---
 mm/vmstat.c                            |  2 ++
 17 files changed, 217 insertions(+), 28 deletions(-)

-- 
1.9.0


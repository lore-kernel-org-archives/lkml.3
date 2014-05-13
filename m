Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbaEMJp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:45:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759618AbaEMJpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:45:54 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@intel.com>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 00/19] Misc page alloc, shmem, mark_page_accessed and page_waitqueue optimisations v3r33
Date: Tue, 13 May 2014 10:45:31 +0100
Message-Id: <1399974350-11089-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog since V2
o Fewer atomic operations in buffer discards				(mgorman)
o Remove number_of_cpusets and use ref count in jump labels		(peterz)
o Optimise set loop for pageblock flags further				(peterz)
o Remove unnecessary parameters when setting pageblock flags		(vbabka)
o Rework how PG_waiters are set/cleared to avoid changing wait.c	(mgorman)

I was investigating a performance bug that looked like dd to tmpfs
had regressed.  The bulk of the problem turned out to be a difference
in Kconfig but it got me looking at the unnecessary overhead in tmpfs,
mark_page_accessed and parts of the allocator. This series is the result.

The patches themselves have details of the performance results but here
are a few showing the impact of the whole series. This is the result of
dd'ing to a file multiple times on tmpfs

sync DD to tmpfs
Throughput           3.15.0-rc4            3.15.0-rc4
                        vanilla         fullseries-v3
Min         4096.0000 (  0.00%)   4300.8000 (  5.00%)
Mean        4785.4933 (  0.00%)   5003.9467 (  4.56%)
TrimMean    4812.8000 (  0.00%)   5028.5714 (  4.48%)
Stddev       147.0509 (  0.00%)    191.9981 ( 30.57%)
Max         5017.6000 (  0.00%)   5324.8000 (  6.12%)

sync DD to tmpfs
Elapsed Time                3.15.0-rc4            3.15.0-rc4
                               vanilla         fullseries-v3
Min      elapsed      0.4200 (  0.00%)      0.3900 (  7.14%)
Mean     elapsed      0.4947 (  0.00%)      0.4527 (  8.49%)
TrimMean elapsed      0.4968 (  0.00%)      0.4539 (  8.63%)
Stddev   elapsed      0.0255 (  0.00%)      0.0340 (-33.02%)
Max      elapsed      0.5200 (  0.00%)      0.4800 (  7.69%)

TrimMean elapsed      0.4796 (  0.00%)      0.4179 ( 12.88%)
Stddev   elapsed      0.0353 (  0.00%)      0.0379 ( -7.23%)
Max      elapsed      0.5100 (  0.00%)      0.4800 (  5.88%)

sync DD to ext4
Throughput           3.15.0-rc4            3.15.0-rc4
                        vanilla         fullseries-v3
Min          113.0000 (  0.00%)    117.0000 (  3.54%)
Mean         116.3000 (  0.00%)    119.6667 (  2.89%)
TrimMean     116.2857 (  0.00%)    119.5714 (  2.83%)
Stddev         1.6961 (  0.00%)      1.1643 (-31.35%)
Max          120.0000 (  0.00%)    122.0000 (  1.67%)

sync DD to ext4
Elapsed time                3.15.0-rc4            3.15.0-rc4
                               vanilla         fullseries-v3
Min      elapsed     13.9500 (  0.00%)     13.6900 (  1.86%)
Mean     elapsed     14.4253 (  0.00%)     14.0010 (  2.94%)
TrimMean elapsed     14.4321 (  0.00%)     14.0161 (  2.88%)
Stddev   elapsed      0.2047 (  0.00%)      0.1423 ( 30.46%)
Max      elapsed     14.8300 (  0.00%)     14.3100 (  3.51%)

async DD to ext4 
Elapsed time                3.15.0-rc4            3.15.0-rc4
                               vanilla         fullseries-v3
Min      elapsed      0.7900 (  0.00%)      0.7800 (  1.27%)
Mean     elapsed     12.4023 (  0.00%)     12.2957 (  0.86%)
TrimMean elapsed     13.2036 (  0.00%)     13.0918 (  0.85%)
Stddev   elapsed      3.3286 (  0.00%)      2.9842 ( 10.35%)
Max      elapsed     18.6000 (  0.00%)     13.4300 ( 27.80%)



This table shows the latency in usecs of accessing ext4-backed
mappings of various sizes

lat_mmap
                       3.15.0-rc4            3.15.0-rc4
                          vanilla         fullseries-v3
Procs 107M     564.0000 (  0.00%)    546.0000 (  3.19%)
Procs 214M    1123.0000 (  0.00%)   1090.0000 (  2.94%)
Procs 322M    1636.0000 (  0.00%)   1395.0000 ( 14.73%)
Procs 429M    2076.0000 (  0.00%)   2051.0000 (  1.20%)
Procs 536M    2518.0000 (  0.00%)   2482.0000 (  1.43%)
Procs 644M    3008.0000 (  0.00%)   2978.0000 (  1.00%)
Procs 751M    3506.0000 (  0.00%)   3450.0000 (  1.60%)
Procs 859M    3988.0000 (  0.00%)   3756.0000 (  5.82%)
Procs 966M    4544.0000 (  0.00%)   4310.0000 (  5.15%)
Procs 1073M   4960.0000 (  0.00%)   4928.0000 (  0.65%)
Procs 1181M   5342.0000 (  0.00%)   5144.0000 (  3.71%)
Procs 1288M   5573.0000 (  0.00%)   5427.0000 (  2.62%)
Procs 1395M   5777.0000 (  0.00%)   6056.0000 ( -4.83%)
Procs 1503M   6141.0000 (  0.00%)   5963.0000 (  2.90%)
Procs 1610M   6689.0000 (  0.00%)   6331.0000 (  5.35%)
Procs 1717M   8839.0000 (  0.00%)   6807.0000 ( 22.99%)
Procs 1825M   8399.0000 (  0.00%)   9062.0000 ( -7.89%)
Procs 1932M   7871.0000 (  0.00%)   8778.0000 (-11.52%)
Procs 2040M   8235.0000 (  0.00%)   8081.0000 (  1.87%)
Procs 2147M   8861.0000 (  0.00%)   8337.0000 (  5.91%)

In general the system CPU overhead is lower.

 arch/tile/mm/homecache.c        |   2 +-
 fs/btrfs/extent_io.c            |  11 +-
 fs/btrfs/file.c                 |   5 +-
 fs/buffer.c                     |  21 ++-
 fs/ext4/mballoc.c               |  14 +-
 fs/f2fs/checkpoint.c            |   3 -
 fs/f2fs/node.c                  |   2 -
 fs/fuse/dev.c                   |   2 +-
 fs/fuse/file.c                  |   2 -
 fs/gfs2/aops.c                  |   1 -
 fs/gfs2/meta_io.c               |   4 +-
 fs/ntfs/attrib.c                |   1 -
 fs/ntfs/file.c                  |   1 -
 include/linux/buffer_head.h     |   5 +
 include/linux/cpuset.h          |  46 +++++
 include/linux/gfp.h             |   4 +-
 include/linux/jump_label.h      |  20 ++-
 include/linux/mmzone.h          |  21 ++-
 include/linux/page-flags.h      |  20 +++
 include/linux/pageblock-flags.h |  30 +++-
 include/linux/pagemap.h         | 115 +++++++++++-
 include/linux/swap.h            |   9 +-
 kernel/cpuset.c                 |  10 +-
 mm/filemap.c                    | 380 +++++++++++++++++++++++++---------------
 mm/page_alloc.c                 | 229 ++++++++++++++----------
 mm/shmem.c                      |   8 +-
 mm/swap.c                       |  27 ++-
 mm/swap_state.c                 |   2 +-
 mm/vmscan.c                     |   9 +-
 29 files changed, 686 insertions(+), 318 deletions(-)

-- 
1.8.4.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbaFPJ0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:26:41 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:10328 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbaFPJ0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:26:37 -0400
Message-ID: <539EB7D6.8070401@huawei.com>
Date: Mon, 16 Jun 2014 17:24:38 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <aquini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>
CC: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Xishi Qiu <qiuxishi@huawei.com>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH 0/8] mm: add page cache limit and reclaim feature
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When system(e.g. smart phone) running for a long time, the cache often takes
a large memory, maybe the free memory is less than 50M, then OOM will happen
if APP allocate a large order pages suddenly and memory reclaim too slowly. 

Use "echo 3 > /proc/sys/vm/drop_caches" will drop the whole cache, this will
affect the performance, so it is used for debugging only. 

suse has this feature, I tested it before, but it can not limit the page cache
actually. So I rewrite the feature and add some parameters.

Christoph Lameter has written a patch "Limit the size of the pagecache"
http://marc.info/?l=linux-mm&m=116959990228182&w=2
It changes in zone fallback, this is not a good way.

The patchset is based on v3.15, it introduces two features, page cache limit
and page cache reclaim in circles.

Add four parameters in /proc/sys/vm

1) cache_limit_mbytes
This is used to limit page cache amount.
The input unit is MB, value range is from 0 to totalram_pages.
If this is set to 0, it will not limit page cache.
When written to the file, cache_limit_ratio will be updated too.
The default value is 0.

2) cache_limit_ratio
This is used to limit page cache amount.
The input unit is percent, value range is from 0 to 100.
If this is set to 0, it will not limit page cache.
When written to the file, cache_limit_mbytes will be updated too.
The default value is 0.

3) cache_reclaim_s
This is used to reclaim page cache in circles.
The input unit is second, the minimum value is 0.
If this is set to 0, it will disable the feature.
The default value is 0.

4) cache_reclaim_weight
This is used to speed up page cache reclaim.
It depend on enabling cache_limit_mbytes/cache_limit_ratio or cache_reclaim_s.
Value range is from 1(slow) to 100(fast).
The default value is 1.

I tested the two features on my system(x86_64), it seems to work right.
However, as it changes the hot path "add_to_page_cache_lru()", I don't know
how much it will the affect the performance, maybe there are some errors
in the patches too, RFC.


*** BLURB HERE ***

Xishi Qiu (8):
  mm: introduce cache_limit_ratio and cache_limit_mbytes
  mm: add shrink page cache core
  mm: implement page cache limit feature
  mm: introduce cache_reclaim_s
  mm: implement page cache reclaim in circles
  mm: introduce cache_reclaim_weight
  mm: implement page cache reclaim speed
  doc: update Documentation/sysctl/vm.txt

 Documentation/sysctl/vm.txt |   43 +++++++++++++++++++
 include/linux/swap.h        |   17 ++++++++
 kernel/sysctl.c             |   35 +++++++++++++++
 mm/filemap.c                |    3 +
 mm/hugetlb.c                |    3 +
 mm/page_alloc.c             |   51 ++++++++++++++++++++++
 mm/vmscan.c                 |   97 ++++++++++++++++++++++++++++++++++++++++++-
 7 files changed, 248 insertions(+), 1 deletions(-)



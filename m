Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbaFPKpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 06:45:12 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:63924 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbaFPKpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 06:45:10 -0400
Message-ID: <539ECA21.5090906@huawei.com>
Date: Mon, 16 Jun 2014 18:42:41 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <aquini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 0/8] mm: add page cache limit and reclaim feature
References: <539EB7D6.8070401@huawei.com> <539EC117.1040105@cn.fujitsu.com>
In-Reply-To: <539EC117.1040105@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/16 18:04, Zhang Yanfei wrote:

> Hi,
> 
> On 06/16/2014 05:24 PM, Xishi Qiu wrote:
>> When system(e.g. smart phone) running for a long time, the cache often takes
>> a large memory, maybe the free memory is less than 50M, then OOM will happen
>> if APP allocate a large order pages suddenly and memory reclaim too slowly. 
> 
> If there is really too many page caches, and the free memory is low. I think
> the page allocator will enter the slowpath to free more memory for allocation.
> And it the slowpath, there is indeed the direct reclaim operation, so is that
> really not enough to reclaim pagecaches?
> 

Hi Yanfei,

Do you mean this path?
__alloc_pages_slowpath()
	__alloc_pages_direct_reclaim()
		__perform_reclaim()
			try_to_free_pages()
the "nr_to_reclaim = SWAP_CLUSTER_MAX" is only 32 pages.

>>
>> Use "echo 3 > /proc/sys/vm/drop_caches" will drop the whole cache, this will
>> affect the performance, so it is used for debugging only. 
>>
>> suse has this feature, I tested it before, but it can not limit the page cache
>> actually. So I rewrite the feature and add some parameters.
>>
>> Christoph Lameter has written a patch "Limit the size of the pagecache"
>> http://marc.info/?l=linux-mm&m=116959990228182&w=2
>> It changes in zone fallback, this is not a good way.
>>
>> The patchset is based on v3.15, it introduces two features, page cache limit
>> and page cache reclaim in circles.
>>
>> Add four parameters in /proc/sys/vm
>>
>> 1) cache_limit_mbytes
>> This is used to limit page cache amount.
>> The input unit is MB, value range is from 0 to totalram_pages.
>> If this is set to 0, it will not limit page cache.
>> When written to the file, cache_limit_ratio will be updated too.
>> The default value is 0.
>>
>> 2) cache_limit_ratio
>> This is used to limit page cache amount.
>> The input unit is percent, value range is from 0 to 100.
>> If this is set to 0, it will not limit page cache.
>> When written to the file, cache_limit_mbytes will be updated too.
>> The default value is 0.
>>
>> 3) cache_reclaim_s
>> This is used to reclaim page cache in circles.
>> The input unit is second, the minimum value is 0.
>> If this is set to 0, it will disable the feature.
>> The default value is 0.
>>
>> 4) cache_reclaim_weight
>> This is used to speed up page cache reclaim.
>> It depend on enabling cache_limit_mbytes/cache_limit_ratio or cache_reclaim_s.
>> Value range is from 1(slow) to 100(fast).
>> The default value is 1.
>>
>> I tested the two features on my system(x86_64), it seems to work right.
>> However, as it changes the hot path "add_to_page_cache_lru()", I don't know
>> how much it will the affect the performance,
> 
> Yeah, at a quick glance, for every invoke of add_to_page_cache_lru(), there is the 
> newly added test:
> 
> if (vm_cache_limit_mbytes && page_cache_over_limit())
> 
> and if the test is passed, shrink_page_cache()->do_try_to_free_pages() is called.
> And this is a sync operation. IMO, it is better to make such an operation async.
> (You've implemented async operation but I doubt if it is suitable to put the sync operation
> here.)
> 
> Thanks.
> 

Sounds to a good idea, how about waking up kswapd()?

Thanks,
Xishi Qiu

>  maybe there are some errors
>> in the patches too, RFC.
>>
>>
>> *** BLURB HERE ***
>>
>> Xishi Qiu (8):
>>   mm: introduce cache_limit_ratio and cache_limit_mbytes
>>   mm: add shrink page cache core
>>   mm: implement page cache limit feature
>>   mm: introduce cache_reclaim_s
>>   mm: implement page cache reclaim in circles
>>   mm: introduce cache_reclaim_weight
>>   mm: implement page cache reclaim speed
>>   doc: update Documentation/sysctl/vm.txt
>>
>>  Documentation/sysctl/vm.txt |   43 +++++++++++++++++++
>>  include/linux/swap.h        |   17 ++++++++
>>  kernel/sysctl.c             |   35 +++++++++++++++
>>  mm/filemap.c                |    3 +
>>  mm/hugetlb.c                |    3 +
>>  mm/page_alloc.c             |   51 ++++++++++++++++++++++
>>  mm/vmscan.c                 |   97 ++++++++++++++++++++++++++++++++++++++++++-
>>  7 files changed, 248 insertions(+), 1 deletions(-)
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>> .
>>
> 
> 




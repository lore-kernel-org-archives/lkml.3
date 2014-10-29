Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbaJ2Ik4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:40:56 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:47766 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931AbaJ2Ikw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:40:52 -0400
X-Original-SENDERIP: 10.186.123.76
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <5450A810.6030108@lge.com>
Date: Wed, 29 Oct 2014 17:40:48 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org, john.stultz@linaro.org, rebecca@android.com,
        lauraa@codeaurora.org, dan.carpenter@oracle.com, minchan@kernel.org,
        iamjoonsoo.kim@lge.com
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gunho.lee@lge.com
Subject: Re: [PATCHv2 0/3] staging: ion: enable pool shrinking in page unit
References: <1414560960-21130-1-git-send-email-gioh.kim@lge.com>
In-Reply-To: <1414560960-21130-1-git-send-email-gioh.kim@lge.com>
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2014-10-29 오후 2:35에 Gioh Kim 이(가) 쓴 글:
> Hello,
> 
> Current pool shrinking is not page unit, block unit.
> But shrinker returns the pool size in page unit,
> so it is confused.
> 
> And there is no way to control pool size and shrink pool directly.
> 
> I have 3 patches like followings.
> 
> 1. Patch 1/3: make pool be shrinked by page unit
> This patch shrinks pool in page unit.
> 
> 2. Patch 2/3: limit pool size
> This patch specifies pool size limit via debugfs.
> The default value of limit is 0.
> cat /sys/kernel/debug/ion/heaps/system_limit returns 0.
> If you want to create 4 pools and limit each pool by 10MB,
> you can write 40MB(=41943040) at system_limit debugfs file
> like following:
> echo 41943040 > /sys/kernel/debug/ion/heaps/system_limit
> 
> 2. Patch 3/3: enable debugfs to shrink page directly
> This patch enables debugfs to specify shrink amount.
> For instance, this shrinks all pages in every pool.
> echo 0 > /sys/kernel/debug/ion/heaps/system_shrink
> And this shrinks 300-pages from entire pool.
> echo 30 > /sys/kernel/debug/ion/heaps/system_shrink
> It try to shrink high-order pool first because high-order pages is necessary
> more than low-order when the system has low memory.
> 
> This patchset is based on linux-next-20141023.
> 
> 
> Gioh Kim (3):
>    staging: ion: shrink page-pool by page unit
>    staging: ion: limit pool size
>    staging: ion: debugfs to shrink pool
> 
>   drivers/staging/android/ion/ion.c             |   62 ++++++++++++++++---------
>   drivers/staging/android/ion/ion_page_pool.c   |   32 ++++++++-----
>   drivers/staging/android/ion/ion_system_heap.c |   20 ++++++--
>   3 files changed, 75 insertions(+), 39 deletions(-)
> 

Following is my test result.
I set the orders as 4,3,2,0 for test.

# mount -t debugfs none /sys/kernel/debug

...... activate driver that calls ion-alloc ......

# cat /sys/kernel/debug/ion/heaps/system  ===================> no limit
          client              pid             size
----------------------------------------------------
----------------------------------------------------
orphaned allocations (info is from last known client):
----------------------------------------------------
  total orphaned                0
          total                 0
   deferred free                0
----------------------------------------------------
0 order 4 highmem pages in pool = 0 total
176 order 4 lowmem pages in pool = 11534336 total
0 order 3 highmem pages in pool = 0 total
0 order 3 lowmem pages in pool = 0 total
0 order 2 highmem pages in pool = 0 total
704 order 2 lowmem pages in pool = 11534336 total
0 order 0 highmem pages in pool = 0 total
2816 order 0 lowmem pages in pool = 11534336 total
# cat /sys/kernel/debug/ion/heaps/system_limit
0
# echo 41943040 > /sys/kernel/debug/ion/heaps/system_limit
# cat /sys/kernel/debug/ion/heaps/system_limit
41943040

...... activate driver that calls ion-alloc ......

# cat /sys/kernel/debug/ion/heaps/system     ====================> 10MB limit
          client              pid             size
----------------------------------------------------
----------------------------------------------------
orphaned allocations (info is from last known client):
----------------------------------------------------
  total orphaned                0
          total                 0
   deferred free                0
----------------------------------------------------
0 order 4 highmem pages in pool = 0 total
161 order 4 lowmem pages in pool = 10551296 total
0 order 3 highmem pages in pool = 0 total
0 order 3 lowmem pages in pool = 0 total
0 order 2 highmem pages in pool = 0 total
641 order 2 lowmem pages in pool = 10502144 total
0 order 0 highmem pages in pool = 0 total
2561 order 0 lowmem pages in pool = 10489856 total
# cat /sys/kernel/debug/ion/heaps/system_shrink ===============> count total pages
7701
# echo 0 > /sys/kernel/debug/ion/heaps/system_shrink  =========> shrink all pages
# cat /sys/kernel/debug/ion/heaps/system
          client              pid             size
----------------------------------------------------
----------------------------------------------------
orphaned allocations (info is from last known client):
----------------------------------------------------
  total orphaned                0
          total                 0
   deferred free                0
----------------------------------------------------
0 order 4 highmem pages in pool = 0 total
0 order 4 lowmem pages in pool = 0 total
0 order 3 highmem pages in pool = 0 total
0 order 3 lowmem pages in pool = 0 total
0 order 2 highmem pages in pool = 0 total
0 order 2 lowmem pages in pool = 0 total
0 order 0 highmem pages in pool = 0 total
0 order 0 lowmem pages in pool = 0 total
# cat /sys/kernel/debug/ion/heaps/system_shrink
0



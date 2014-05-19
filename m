Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaESBrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 21:47:16 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:53994 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbaESBrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 21:47:15 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <537962A0.4090600@lge.com>
Date: Mon, 19 May 2014 10:47:12 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Minchan Kim <minchan.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Laura Abbott <lauraa@codeaurora.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Heesub Shin <heesub.shin@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>, gurugio@gmail.com
Subject: Re: [RFC][PATCH] CMA: drivers/base/Kconfig: restrict CMA size to
 non-zero value
References: <1399509144-8898-1-git-send-email-iamjoonsoo.kim@lge.com> <1399509144-8898-3-git-send-email-iamjoonsoo.kim@lge.com> <20140513030057.GC32092@bbox> <20140515015301.GA10116@js1304-P5Q-DELUXE> <5375C619.8010501@lge.com> <xa1tppjdfwif.fsf@mina86.com>
In-Reply-To: <xa1tppjdfwif.fsf@mina86.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your advice. I didn't notice it.

I'm adding followings according to your advice:

- range restrict for CMA_SIZE_MBYTES and *CMA_SIZE_PERCENTAGE*
I think this can prevent the wrong kernel option.

- change size_cmdline into default value SZ_16M
I am not sure this can prevent if cma=0 cmdline option is also with base and limit options.


I don't know how to send the second patch.
Please pardon me that I just copy the patch here.

--------------------------------- 8< -------------------------------------
 From c283eaac41b044a2abb11cfd32a60fff034633c3 Mon Sep 17 00:00:00 2001
From: Gioh Kim <gioh.kim@lge.com>
Date: Fri, 16 May 2014 16:15:43 +0900
Subject: [PATCH] drivers/base/Kconfig: restrict CMA size to non-zero value

The size of CMA area must be larger than zero.
If the size is zero, all physically-contiguous allocation
can be failed.

Signed-off-by: Gioh Kim <gioh.kim@lge.co.kr>
---
  drivers/base/Kconfig          |   14 ++++++++++++--
  drivers/base/dma-contiguous.c |    3 ++-
  2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 4b7b452..a7292ac 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -222,17 +222,27 @@ config DMA_CMA
  if  DMA_CMA
  comment "Default contiguous memory area size:"

+config CMA_SIZE_MBYTES_DEFAULT
+       int
+       default 16
+
+config CMA_SIZE_MBYTES_MAX
+       int
+       default 1024
+
  config CMA_SIZE_MBYTES
         int "Size in Mega Bytes"
         depends on !CMA_SIZE_SEL_PERCENTAGE
-       default 16
+       range 1 CMA_SIZE_MBYTES_MAX
+       default CMA_SIZE_MBYTES_DEFAULT
         help
           Defines the size (in MiB) of the default memory area for Contiguous
-         Memory Allocator.
+         Memory Allocator. This value must be larger than zero.

  config CMA_SIZE_PERCENTAGE
         int "Percentage of total memory"
         depends on !CMA_SIZE_SEL_MBYTES
+       range 1 100
         default 10
         help
           Defines the size of the default memory area for Contiguous Memory
diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index b056661..5b70442 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -125,7 +125,8 @@ void __init dma_contiguous_reserve(phys_addr_t limit)
         pr_debug("%s(limit %08lx)\n", __func__, (unsigned long)limit);

         if (size_cmdline != -1) {
-               selected_size = size_cmdline;
+               selected_size = ((size_cmdline == 0) ?
+                                CONFIG_CMA_SIZE_MBYTES_DEFAULT : size_cmdline);
                 selected_base = base_cmdline;
                 selected_limit = min_not_zero(limit_cmdline, limit);
                 if (base_cmdline + size_cmdline == limit_cmdline)
--
1.7.9.5


2014-05-17 오전 2:45, Michal Nazarewicz 쓴 글:
> On Fri, May 16 2014, Gioh Kim wrote:
>> If CMA_SIZE_MBYTES is allowed to be zero, there should be defense code
>> to check CMA is initlaized correctly. And atomic_pool initialization
>> should be done by __alloc_remap_buffer instead of
>> __alloc_from_contiguous if __alloc_from_contiguous is failed.
>
> Agreed, and this is the correct fix.
>
>> IMPO, it is more simple and powerful to restrict CMA_SIZE_MBYTES_MAX
>> configuration to be larger than zero.
>
> No, because it makes it impossible to have CMA disabled by default and
> only enabled if command line argument is given.
>
> Furthermore, your patch does *not* guarantee CMA region to always be
> allocated.  If CMA_SIZE_SEL_PERCENTAGE is selected for instance.  Or if
> user explicitly passes 0 on command line.
>
>
>

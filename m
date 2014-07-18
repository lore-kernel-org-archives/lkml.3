Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbaGRHui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 03:50:38 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:13474 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaGRHuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 03:50:37 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-f0-53c8d1cab510
Message-id: <53C8D1CA.9070102@samsung.com>
Date: Fri, 18 Jul 2014 09:50:34 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Gioh Kim <gioh.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?J+q5gOykgOyImCc=?= <iamjoonsoo.kim@lge.com>,
        Laura Abbott <lauraa@codeaurora.org>, Minchan Kim <minchan@kernel.org>
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        =?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>,
        "'Chanho Min'" <chanho.min@lge.com>
Subject: Re: [PATCH] CMA/HOTPLUG: clear buffer-head lru before page migration
References: <53C8C290.90503@lge.com>
In-reply-to: <53C8C290.90503@lge.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t/xa7qnLp4INri7Qtlizvo1bBYfr11g
	t3jW9IXR4sK0hcwWqzf5Wqzsbmaz2N45g93i8q45bBb31vxntfh9sJPdYsHxFlaLZV/fs1uc
	/3uc1YHX4/Cb98wel/t6mTx6935l9di0qpPNY9OnSeweXW+vMHmcmPGbxWPdn1dMHp83yXls
	evKWKYArissmJTUnsyy1SN8ugStj2ROxgoeyFXeWTmZuYOwV72Lk5JAQMJF4+HgmM4QtJnHh
	3nq2LkYuDiGBpYwSR6dPY4dwPjFKPF76lQWkildAS2LulOOMIDaLgKrEl+5lYHE2AUOJrrdd
	bCC2qECMxJnez8wQ9YISPybfYwEZJCJwllGi81wjWBGzwAImiROHs0FsYQFfiSc9h8GGCgmo
	SEzf8YcJxOYEWvB42gGoejOJRy3rmCFseYnNa94yT2AUmIVkxywkZbOQlC1gZF7FKJpamlxQ
	nJSea6RXnJhbXJqXrpecn7uJERJTX3cwLj1mdYhRgINRiYd3gcmJYCHWxLLiytxDjBIczEoi
	vNn3jwcL8aYkVlalFuXHF5XmpBYfYmTi4JRqYHTax97z1U31lk+e56Nte3gLJuXsZ7RsEHA5
	ta/kwIInN2Jdrz5xUTVo21UZcnD/oazTYpIdk21/my4p92JIetwqmLH1jsD0o46/Uh2fO0V+
	FBJTK2c9WS+ZdutHsrXIywKVda4JpY95heO12VU5Sr6Zn/qUcMSPdYZV6FHfaUE1fyI6DyRt
	VWIpzkg01GIuKk4EAHQGaOmHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-07-18 08:45, Gioh Kim wrote:
> For page migration of CMA, buffer-heads of lru should be dropped.
> Please refer to https://lkml.org/lkml/2014/7/4/101 for the history.
>
> I have two solution to drop bhs.
> One is invalidating entire lru.
> Another is searching the lru and dropping only one bh that Laura proposed
> at https://lkml.org/lkml/2012/8/31/313.
>
> I'm not sure which has better performance.
> So I did performance test on my cortex-a7 platform with Lmbench
> that has "File & VM system latencies" test.
> I am attaching the results.
> The first line is of invalidating entire lru and the second is dropping selected bh.
>
> File & VM system latencies in microseconds - smaller is better
> -------------------------------------------------------------------------------
> Host                 OS   0K File      10K File     Mmap    Prot   Page   100fd
>                          Create Delete Create Delete Latency Fault  Fault  selct
> --------- ------------- ------ ------ ------ ------ ------- ----- ------- -----
> 10.178.33 Linux 3.10.19   25.1   19.6   32.6   19.7  5098.0 0.666 3.45880 6.506
> 10.178.33 Linux 3.10.19   24.9   19.5   32.3   19.4  5059.0 0.563 3.46380 6.521
>
>
> I tried several times but the result tells that they are the same under 1% gap
> except Protection Fault.
> But the latency of Protection Fault is very small and I think it has little effect.
>
> Therefore we can choose anything but I choose invalidating entire lru.
> The try_to_free_buffers() which is calling drop_buffers() is called by many filesystem code.
> So I think inserting codes in drop_buffers() can affect the system.
> And also we cannot distinguish migration type in drop_buffers().
>
> In alloc_contig_range() we can distinguish migration type and invalidate lru if it needs.
> I think alloc_contig_range() is proper to deal with bh like following patch.
>
> Laura, can I have you name on Acked-by line?
> Please let me represent my thanks.
>
> Thanks for any feedback.
>
> ------------------------------- 8< ----------------------------------
>
> >From 33c894b1bab9bc26486716f0c62c452d3a04d35d Mon Sep 17 00:00:00 2001
> From: Gioh Kim <gioh.kim@lge.com>
> Date: Fri, 18 Jul 2014 13:40:01 +0900
> Subject: [PATCH] CMA/HOTPLUG: clear buffer-head lru before page migration
>
> The bh must be free to migrate a page at which bh is mapped.
> The reference count of bh is increased when it is installed
> into lru so that the bh of lru must be freed before migrating the page.
>
> This frees every bh of lru. We could free only bh of migrating page.
> But searching lru costs more than invalidating entire lru.
>
> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
> Acked-by: Laura Abbott <lauraa@codeaurora.org>
> ---
>   mm/page_alloc.c |    3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b99643d4..3b474e0 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6369,6 +6369,9 @@ int alloc_contig_range(unsigned long start, unsigned long end,
>          if (ret)
>                  return ret;
>
> +       if (migratetype == MIGRATE_CMA || migratetype == MIGRATE_MOVABLE)

I'm not sure if it really makes sense to check the migratetype here. 
This check
doesn't add any new information to the code and make false impression 
that this
function can be called for other migratetypes than CMA or MOVABLE. Even 
if so,
then invalidating bh_lrus unconditionally will make more sense, IMHO.

> +               invalidate_bh_lrus();
> +
>          ret = __alloc_contig_migrate_range(&cc, start, end);
>          if (ret)
>                  goto done;
> --
> 1.7.9.5
>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaEIMjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 08:39:12 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:61660 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaEIMjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 08:39:10 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-d9-536ccc6b5e2b
Message-id: <536CCC78.6050806@samsung.com>
Date: Fri, 09 May 2014 14:39:20 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Mel Gorman <mgorman@suse.de>, Laura Abbott <lauraa@codeaurora.org>,
        Minchan Kim <minchan@kernel.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "'Tomasz Stanislawski'" <t.stanislaws@samsung.com>
Subject: Re: [RFC PATCH 0/3] Aggressively allocate the pages on cma reserved
 memory
References: <1399509144-8898-1-git-send-email-iamjoonsoo.kim@lge.com>
In-reply-to: <1399509144-8898-1-git-send-email-iamjoonsoo.kim@lge.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t/xa7rZZ3KCDebOFrWYs34Nm8XGGetZ
	LVZv8rU4OHsJk8XK7mY2i7NNb9gttnfOYLe4vGsOm8W9Nf9ZLSa/e8ZoseB4C6vFsq/v2S3+
	XlnPYjGv/SWrA5/H4TfvmT0u9/UyeWxa1cnmsenTJHaPrrdXmDxOzPjN4rHuzysmj/f7rrJ5
	9G1Zxeix+XS1x+dNcgHcUVw2Kak5mWWpRfp2CVwZX36fZSp4Ilxx+6FNA+MN/i5GDg4JAROJ
	lw3uXYycQKaYxIV769lAbCGBpYwSvY2lXYxcQPYnRombbb3sIAleAS2J/e8ngRWxCKhKXFq1
	iQnEZhMwlOh62wUWFxWIkdj9eSEjRL2gxI/J91hAbBGBUIm5HavAbGaBs8wS1z4mgtjCQPEd
	q3ZCLXaVWN2xC6yXU8BNYnbrJ6h6M4lHLeuYIWx5ic1r3jJPYBSYhWTFLCRls5CULWBkXsUo
	mlqaXFCclJ5rpFecmFtcmpeul5yfu4kREl9fdzAuPWZ1iFGAg1GJh3eBTEawEGtiWXFl7iFG
	CQ5mJRFezcM5wUK8KYmVValF+fFFpTmpxYcYmTg4pRoYdXuFeN7YxO8pPhId+f1B/VrlCYwh
	/LEfTqQkZe0y+mlyeEVt5U3W72E8vsaFCd8LG45uUNbu1PefPbv14T+N1pUhFrMWlBma34u7
	FjhZuDX/2c+GSV6OVzZFNfidfckVmT+Dr6A+Ou+O07ZLCw5v2Cx6wufCme8PLz2SOdp95D7H
	Os+60goTJZbijERDLeai4kQABO/zJ40CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-05-08 02:32, Joonsoo Kim wrote:
> This series tries to improve CMA.
>
> CMA is introduced to provide physically contiguous pages at runtime
> without reserving memory area. But, current implementation works like as
> reserving memory approach, because allocation on cma reserved region only
> occurs as fallback of migrate_movable allocation. We can allocate from it
> when there is no movable page. In that situation, kswapd would be invoked
> easily since unmovable and reclaimable allocation consider
> (free pages - free CMA pages) as free memory on the system and free memory
> may be lower than high watermark in that case. If kswapd start to reclaim
> memory, then fallback allocation doesn't occur much.
>
> In my experiment, I found that if system memory has 1024 MB memory and
> has 512 MB reserved memory for CMA, kswapd is mostly invoked around
> the 512MB free memory boundary. And invoked kswapd tries to make free
> memory until (free pages - free CMA pages) is higher than high watermark,
> so free memory on meminfo is moving around 512MB boundary consistently.
>
> To fix this problem, we should allocate the pages on cma reserved memory
> more aggressively and intelligenetly. Patch 2 implements the solution.
> Patch 1 is the simple optimization which remove useless re-trial and patch 3
> is for removing useless alloc flag, so these are not important.
> See patch 2 for more detailed description.
>
> This patchset is based on v3.15-rc4.

Thanks for posting those patches. It basically reminds me the following 
discussion:
http://thread.gmane.org/gmane.linux.kernel/1391989/focus=1399524

Your approach is basically the same. I hope that your patches can be 
improved
in such a way that they will be accepted by mm maintainers. I only 
wonder if the
third patch is really necessary. Without it kswapd wakeup might be still 
avoided
in some cases.

> Thanks.
> Joonsoo Kim (3):
>    CMA: remove redundant retrying code in __alloc_contig_migrate_range
>    CMA: aggressively allocate the pages on cma reserved memory when not
>      used
>    CMA: always treat free cma pages as non-free on watermark checking
>
>   include/linux/mmzone.h |    6 +++
>   mm/compaction.c        |    4 --
>   mm/internal.h          |    3 +-
>   mm/page_alloc.c        |  117 +++++++++++++++++++++++++++++++++++++++---------
>   4 files changed, 102 insertions(+), 28 deletions(-)
>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


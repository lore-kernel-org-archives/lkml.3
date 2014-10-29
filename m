Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaJ2Avq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 20:51:46 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:39572 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaJ2Avp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 20:51:45 -0400
X-Original-SENDERIP: 10.186.123.76
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <54503A1A.5030301@lge.com>
Date: Wed, 29 Oct 2014 09:51:38 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org, john.stultz@linaro.org, rebecca@android.com,
        lauraa@codeaurora.org, dan.carpenter@oracle.com
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gunho.lee@lge.com
Subject: Re: [PATCH 1/3] staging: ion: shrink page-pool by page unit
References: <1414456605-26049-1-git-send-email-gioh.kim@lge.com> <1414456605-26049-2-git-send-email-gioh.kim@lge.com>
In-Reply-To: <1414456605-26049-2-git-send-email-gioh.kim@lge.com>
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2014-10-28 오전 9:36에 Gioh Kim 이(가) 쓴 글:
> This patch shrink page-pool by page unit.
> 
> Shrinker usually get the pool size with the pool-scanner
> and pass the size to the pool-counter to shrink entire pool.
> But the pool-scanner is working in block unit.
> and pool-counter page unit.
> So it is confused.
> 
> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
> ---
>   drivers/staging/android/ion/ion_page_pool.c   |    5 +++--
>   drivers/staging/android/ion/ion_system_heap.c |    7 +++++--
>   2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
> index 5864f3d..165152f 100644
> --- a/drivers/staging/android/ion/ion_page_pool.c
> +++ b/drivers/staging/android/ion/ion_page_pool.c
> @@ -116,7 +116,7 @@ static int ion_page_pool_total(struct ion_page_pool *pool, bool high)
>   int ion_page_pool_shrink(struct ion_page_pool *pool, gfp_t gfp_mask,
>   				int nr_to_scan)
>   {
> -	int freed;
> +	int freed = 0;
>   	bool high;
>   
>   	if (current_is_kswapd())
> @@ -127,7 +127,7 @@ int ion_page_pool_shrink(struct ion_page_pool *pool, gfp_t gfp_mask,
>   	if (nr_to_scan == 0)
>   		return ion_page_pool_total(pool, high);
>   
> -	for (freed = 0; freed < nr_to_scan; freed++) {
> +	while (freed <= nr_to_scan) {
>   		struct page *page;
>   
>   		mutex_lock(&pool->mutex);
> @@ -141,6 +141,7 @@ int ion_page_pool_shrink(struct ion_page_pool *pool, gfp_t gfp_mask,
>   		}
>   		mutex_unlock(&pool->mutex);
>   		ion_page_pool_free_pages(pool, page);
> +		freed += (1 << pool->order);
>   	}
>   
>   	return freed;
> diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
> index da2a63c..91d862f 100644
> --- a/drivers/staging/android/ion/ion_system_heap.c
> +++ b/drivers/staging/android/ion/ion_system_heap.c
> @@ -211,7 +211,7 @@ static int ion_system_heap_shrink(struct ion_heap *heap, gfp_t gfp_mask,
>   					int nr_to_scan)
>   {
>   	struct ion_system_heap *sys_heap;
> -	int nr_total = 0;
> +	int nr_total = 0, nr_freed;
>   	int i;
>   
>   	sys_heap = container_of(heap, struct ion_system_heap, heap);
> @@ -219,7 +219,10 @@ static int ion_system_heap_shrink(struct ion_heap *heap, gfp_t gfp_mask,
>   	for (i = 0; i < num_orders; i++) {
>   		struct ion_page_pool *pool = sys_heap->pools[i];
>   
> -		nr_total += ion_page_pool_shrink(pool, gfp_mask, nr_to_scan);
> +		nr_freed = ion_page_pool_shrink(pool, gfp_mask, nr_to_scan);

I found a mistake that if nr_to_scan is 0, this works wrong.
Please ignore this patch and I'm going to send v2.


> +		nr_total += nr_freed;
> +		/* nr_to_scan can be negative */
> +		nr_to_scan -= nr_freed;
>   	}
>   
>   	return nr_total;
> 

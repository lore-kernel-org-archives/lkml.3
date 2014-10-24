Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbaJXUxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 16:53:45 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38701 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbaJXUxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 16:53:42 -0400
Message-ID: <544ABC53.5030300@codeaurora.org>
Date: Fri, 24 Oct 2014 13:53:39 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Gioh Kim <gioh.kim@lge.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>
CC: devel@driverdev.osuosl.org, gunho.lee@lge.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv2 3/3] staging: ion: limit pool size
References: <1414133248-639-1-git-send-email-gioh.kim@lge.com> <1414133248-639-4-git-send-email-gioh.kim@lge.com>
In-Reply-To: <1414133248-639-4-git-send-email-gioh.kim@lge.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/23/2014 11:47 PM, Gioh Kim wrote:
> This patch limits pool size by page unit.
>

This looks useful. Might be nice to add a debugfs option
to change this at runtime as well.

> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
> ---
>   drivers/staging/android/ion/Kconfig         |    4 ++++
>   drivers/staging/android/ion/ion_page_pool.c |   26 ++++++++++++++++----------
>   2 files changed, 20 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/staging/android/ion/Kconfig b/drivers/staging/android/ion/Kconfig
> index 3452346..e6b1a54 100644
> --- a/drivers/staging/android/ion/Kconfig
> +++ b/drivers/staging/android/ion/Kconfig
> @@ -33,3 +33,7 @@ config ION_TEGRA
>   	help
>   	  Choose this option if you wish to use ion on an nVidia Tegra.
>
> +config ION_POOL_LIMIT
> +	int "Limit count of pages in pool"
> +	depends on ION
> +	default "0"

Can you add help text here? It would be useful to clarify that the
units are in pages and that 0 will allow unlimited growth of the
pool. This should also clarify that this is a limit per
individual pool and not a limit for all page pools in the system.

> diff --git a/drivers/staging/android/ion/ion_page_pool.c b/drivers/staging/android/ion/ion_page_pool.c
> index 165152f..d63e93f 100644
> --- a/drivers/staging/android/ion/ion_page_pool.c
> +++ b/drivers/staging/android/ion/ion_page_pool.c
> @@ -22,8 +22,11 @@
>   #include <linux/module.h>
>   #include <linux/slab.h>
>   #include <linux/swap.h>
> +#include <linux/kconfig.h>
>   #include "ion_priv.h"
>
> +#define POOL_LIMIT CONFIG_ION_POOL_LIMIT
> +

I don't think the extra #define helps anything here, was
there something else intended here?

>   static void *ion_page_pool_alloc_pages(struct ion_page_pool *pool)
>   {
>   	struct page *page = alloc_pages(pool->gfp_mask, pool->order);
> @@ -41,8 +44,21 @@ static void ion_page_pool_free_pages(struct ion_page_pool *pool,
>   	__free_pages(page, pool->order);
>   }
>
> +static int ion_page_pool_total(struct ion_page_pool *pool, bool high)
> +{
> +	int count = pool->low_count;
> +
> +	if (high)
> +		count += pool->high_count;
> +
> +	return count << pool->order;
> +}
> +
>   static int ion_page_pool_add(struct ion_page_pool *pool, struct page *page)
>   {
> +	if (POOL_LIMIT && ion_page_pool_total(pool, 1) > POOL_LIMIT)
> +		return 1;
> +
>   	mutex_lock(&pool->mutex);
>   	if (PageHighMem(page)) {
>   		list_add_tail(&page->lru, &pool->high_items);
> @@ -103,16 +119,6 @@ void ion_page_pool_free(struct ion_page_pool *pool, struct page *page)
>   		ion_page_pool_free_pages(pool, page);
>   }
>
> -static int ion_page_pool_total(struct ion_page_pool *pool, bool high)
> -{
> -	int count = pool->low_count;
> -
> -	if (high)
> -		count += pool->high_count;
> -
> -	return count << pool->order;
> -}
> -
>   int ion_page_pool_shrink(struct ion_page_pool *pool, gfp_t gfp_mask,
>   				int nr_to_scan)
>   {
>

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

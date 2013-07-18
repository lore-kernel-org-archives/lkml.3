Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900Ab3GRMsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 08:48:17 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24210 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab3GRMsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 08:48:16 -0400
Message-ID: <51E7E400.4070705@oracle.com>
Date: Thu, 18 Jul 2013 20:48:00 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Heesub Shin <heesub.shin@samsung.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Dongjun Shin <d.j.shin@samsung.com>,
        Sunae Seo <sunae.seo@samsung.com>, Heesub Shin <heesub@gmail.com>
Subject: Re: [PATCH] mm: zbud: fix condition check on allocation size
References: <1374071410-9337-1-git-send-email-heesub.shin@samsung.com>
In-Reply-To: <1374071410-9337-1-git-send-email-heesub.shin@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 10:30 PM, Heesub Shin wrote:
> zbud_alloc() incorrectly verifies the size of allocation limit. It
> should deny the allocation request greater than (PAGE_SIZE -
> ZHDR_SIZE_ALIGNED - CHUNK_SIZE), not (PAGE_SIZE - ZHDR_SIZE_ALIGNED)
> which has no remaining spaces for its buddy. There is no point in
> spending the entire zbud page storing only a single page, since we don't
> have any benefits.
> 
> Signed-off-by: Heesub Shin <heesub.shin@samsung.com>

Looks good to me, although I'm thinking to make it more aggressive.
eg. minus two or three times of CHUNK_SIZE.

> ---
>  mm/zbud.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/zbud.c b/mm/zbud.c
> index 9bb4710..ad1e781 100644
> --- a/mm/zbud.c
> +++ b/mm/zbud.c
> @@ -257,7 +257,7 @@ int zbud_alloc(struct zbud_pool *pool, int size, gfp_t gfp,
>  
>  	if (size <= 0 || gfp & __GFP_HIGHMEM)
>  		return -EINVAL;
> -	if (size > PAGE_SIZE - ZHDR_SIZE_ALIGNED)
> +	if (size > PAGE_SIZE - ZHDR_SIZE_ALIGNED - CHUNK_SIZE)
>  		return -ENOSPC;
>  	chunks = size_to_chunks(size);
>  	spin_lock(&pool->lock);
> 

-- 
Regards,
-Bob

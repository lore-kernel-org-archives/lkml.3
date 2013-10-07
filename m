Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab3JGPiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:38:13 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53187 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486Ab3JGPiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:38:12 -0400
Date: Mon, 7 Oct 2013 10:37:56 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Shaohua Li <shli@fusionio.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH] frontswap: enable call to invalidate area on swapoff
Message-ID: <20131007153756.GA4473@variantweb.net>
References: <1381159541-13981-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381159541-13981-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100715-0320-0000-0000-00000143F5B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 05:25:41PM +0200, Krzysztof Kozlowski wrote:
> During swapoff the frontswap_map was NULL-ified before calling
> frontswap_invalidate_area(). However the frontswap_invalidate_area()
> exits early if frontswap_map is NULL. Invalidate was never called during
> swapoff.
> 
> This patch moves frontswap_map_set() in swapoff just after calling
> frontswap_invalidate_area() so outside of locks
> (swap_lock and swap_info_struct->lock). This shouldn't be a problem as
> during swapon the frontswap_map_set() is called also outside of any
> locks.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Nice catch!

Reviewed-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

> ---
>  mm/swapfile.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 3963fc2..3a4896b 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1922,10 +1922,10 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  	p->cluster_info = NULL;
>  	p->flags = 0;
>  	frontswap_map = frontswap_map_get(p);
> -	frontswap_map_set(p, NULL);
>  	spin_unlock(&p->lock);
>  	spin_unlock(&swap_lock);
>  	frontswap_invalidate_area(type);
> +	frontswap_map_set(p, NULL);
>  	mutex_unlock(&swapon_mutex);
>  	free_percpu(p->percpu_cluster);
>  	p->percpu_cluster = NULL;
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 


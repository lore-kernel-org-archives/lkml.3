Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaFJTSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:18:07 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44787 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaFJTSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:18:04 -0400
Date: Tue, 10 Jun 2014 15:17:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: dchinner@redhat.com, airlied@linux.ie, glommer@openvz.org, mgorman@suse.de,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 3/5] gpu/drm/ttm: Use mutex_trylock() to avoid deadlock
 inside shrinker functions.
Message-ID: <20140610191741.GA28523@phenom.dumpdata.com>
References: <201405290647.DHI69200.HSFVFMFOJOLOQt@I-love.SAKURA.ne.jp>
 <201405292334.EAG00503.FLOOJFStHVQMFO@I-love.SAKURA.ne.jp>
 <20140530160824.GD3621@localhost.localdomain>
 <201405311158.DGE64002.QLOOHJSFFMVFOt@I-love.SAKURA.ne.jp>
 <201405311159.CHG64048.SOFLQHVtFOMFJO@I-love.SAKURA.ne.jp>
 <201405311200.III57894.MLFOOFStQVHJFO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201405311200.III57894.MLFOOFStQVHJFO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.23 (2014-03-12)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 12:00:45PM +0900, Tetsuo Handa wrote:
> >From 4e8d1a83629c5966bfd401c5f2187355624194f2 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Sat, 31 May 2014 09:59:44 +0900
> Subject: [PATCH 3/5] gpu/drm/ttm: Use mutex_trylock() to avoid deadlock inside shrinker functions.
> 
> I can observe that RHEL7 environment stalls with 100% CPU usage when a
> certain type of memory pressure is given. While the shrinker functions
> are called by shrink_slab() before the OOM killer is triggered, the stall
> lasts for many minutes.
> 
> One of reasons of this stall is that
> ttm_dma_pool_shrink_count()/ttm_dma_pool_shrink_scan() are called and
> are blocked at mutex_lock(&_manager->lock). GFP_KERNEL allocation with
> _manager->lock held causes someone (including kswapd) to deadlock when
> these functions are called due to memory pressure. This patch changes
> "mutex_lock();" to "if (!mutex_trylock()) return ...;" in order to
> avoid deadlock.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: stable <stable@kernel.org> [3.3+]
> ---
>  drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> index d8e59f7..620da39 100644
> --- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> +++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> @@ -1014,7 +1014,8 @@ ttm_dma_pool_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
>  	if (list_empty(&_manager->pools))
>  		return SHRINK_STOP;
>  
> -	mutex_lock(&_manager->lock);
> +	if (!mutex_lock(&_manager->lock))
> +		return SHRINK_STOP;

Hmm..

/home/konrad/linux/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c: In function ‘ttm_dma_pool_shrink_scan’:
/home/konrad/linux/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c:1015:2: error: invalid use of void expression
  if (!mutex_lock(&_manager->lock))

This is based on v3.15 with these patches.

>  	if (!_manager->npools)
>  		goto out;
>  	pool_offset = ++start_pool % _manager->npools;
> @@ -1047,7 +1048,8 @@ ttm_dma_pool_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
>  	struct device_pools *p;
>  	unsigned long count = 0;
>  
> -	mutex_lock(&_manager->lock);
> +	if (!mutex_trylock(&_manager->lock))
> +		return 0;
>  	list_for_each_entry(p, &_manager->pools, pools)
>  		count += p->pool->npages_free;
>  	mutex_unlock(&_manager->lock);
> -- 
> 1.7.1

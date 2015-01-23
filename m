Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbbAWOYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:24:05 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:59505 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611AbbAWOYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:24:02 -0500
Date: Fri, 23 Jan 2015 23:24:35 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH 1/2] zram: free meta out of init_lock
Message-ID: <20150123142435.GA2320@swordfish>
References: <1421992707-32658-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421992707-32658-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/23/15 14:58), Minchan Kim wrote:
> We don't need to call zram_meta_free, zcomp_destroy and zs_free
> under init_lock. What we need to prevent race with init_lock
> in reset is setting NULL into zram->meta (ie, init_done).
> This patch does it.
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  drivers/block/zram/zram_drv.c | 28 ++++++++++++++++------------
>  1 file changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 9250b3f54a8f..0299d82275e7 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -708,6 +708,7 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
>  {
>  	size_t index;
>  	struct zram_meta *meta;
> +	struct zcomp *comp;
>  
>  	down_write(&zram->init_lock);
>  
> @@ -719,20 +720,10 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
>  	}
>  
>  	meta = zram->meta;
> -	/* Free all pages that are still in this zram device */
> -	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
> -		unsigned long handle = meta->table[index].handle;
> -		if (!handle)
> -			continue;
> -
> -		zs_free(meta->mem_pool, handle);
> -	}
> -
> -	zcomp_destroy(zram->comp);

I'm not so sure about moving zcomp destruction. if we would have detached it
from zram, then yes. otherwise, think of zram ->destoy vs ->init race.

suppose,
CPU1 waits for down_write() init lock in disksize_store() with new comp already allocated;
CPU0 detaches ->meta and releases write init lock;
CPU1 grabs the lock and does zram->comp = comp;
CPU0 reaches the point of zcomp_destroy(zram->comp);


I'd probably prefer to keep zcomp destruction on its current place. I
see a little real value in introducing zcomp detaching and moving
destruction out of init_lock.

	-ss

> +	comp = zram->comp;
> +	zram->meta = NULL;
>  	zram->max_comp_streams = 1;
>  
> -	zram_meta_free(zram->meta);
> -	zram->meta = NULL;
>  	/* Reset stats */
>  	memset(&zram->stats, 0, sizeof(zram->stats));
>  
> @@ -742,6 +733,19 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
>  
>  	up_write(&zram->init_lock);
>  
> +	/* Free all pages that are still in this zram device */
> +	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
> +		unsigned long handle = meta->table[index].handle;
> +
> +		if (!handle)
> +			continue;
> +
> +		zs_free(meta->mem_pool, handle);
> +	}
> +
> +	zcomp_destroy(comp);
> +	zram_meta_free(meta);
> +
>  	/*
>  	 * Revalidate disk out of the init_lock to avoid lockdep splat.
>  	 * It's okay because disk's capacity is protected by init_lock
> -- 
> 1.9.1
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbbAUOV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:21:29 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:64183 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbbAUOVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:21:20 -0500
Date: Wed, 21 Jan 2015 23:21:53 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dan Streetman <ddstreet@ieee.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Nitin Gupta <ngupta@vflare.org>, Juneho Choi <juno.choi@lge.com>,
        Gunho Lee <gunho.lee@lge.com>, Luigi Semenzato <semenzato@google.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH v1 01/10] zram: avoid calling of zram_meta_free under
 init_lock
Message-ID: <20150121142115.GA986@swordfish>
References: <1421820866-26521-1-git-send-email-minchan@kernel.org>
 <1421820866-26521-2-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421820866-26521-2-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/21/15 15:14), Minchan Kim wrote:
> We don't need to call zram_meta_free under init_lock.
> What we need to prevent race is setting NULL into zram->meta
> (ie, init_done). This patch does it.
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  drivers/block/zram/zram_drv.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 9250b3f..7e03d86 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -719,6 +719,8 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
>  	}
>  
>  	meta = zram->meta;
> +	zram->meta = NULL;
> +
>  	/* Free all pages that are still in this zram device */
>  	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
>  		unsigned long handle = meta->table[index].handle;
> @@ -731,8 +733,6 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
>  	zcomp_destroy(zram->comp);
>  	zram->max_comp_streams = 1;
>  
> -	zram_meta_free(zram->meta);
> -	zram->meta = NULL;
>  	/* Reset stats */
>  	memset(&zram->stats, 0, sizeof(zram->stats));
>  
> @@ -741,6 +741,7 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
>  		set_capacity(zram->disk, 0);
>  
>  	up_write(&zram->init_lock);
> +	zram_meta_free(meta);

Hello,

since we detached ->meta from zram, this one doesn't really need
->init_lock protection:

	/* Free all pages that are still in this zram device */
	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
		unsigned long handle = meta->table[index].handle;
		if (!handle)
			continue;

		zs_free(meta->mem_pool, handle);
	}


	-ss

>  	/*
>  	 * Revalidate disk out of the init_lock to avoid lockdep splat.
> -- 
> 1.9.3
> 

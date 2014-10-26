Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978AbaJZFlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 01:41:18 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:32901 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaJZFlR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 01:41:17 -0400
Date: Sun, 26 Oct 2014 14:41:39 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: "'Minchan Kim'" <minchan@kernel.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Dan Streetman'" <ddstreet@ieee.org>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Nitin Gupta'" <ngupta@vflare.org>, "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>
Subject: Re: [PATCH 2/2] zram: avoid NULL pointer access when reading
 mem_used_total
Message-ID: <20141026054139.GA952@swordfish>
References: <000101cff035$d9f50480$8ddf0d80$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <000101cff035$d9f50480$8ddf0d80$%yang@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (10/25/14 17:26), Weijie Yang wrote:
> Date: Sat, 25 Oct 2014 17:26:31 +0800
> From: Weijie Yang <weijie.yang@samsung.com>
> To: 'Minchan Kim' <minchan@kernel.org>
> Cc: 'Andrew Morton' <akpm@linux-foundation.org>, 'Dan Streetman'
>  <ddstreet@ieee.org>, 'Sergey Senozhatsky' <sergey.senozhatsky@gmail.com>,
>  'Nitin Gupta' <ngupta@vflare.org>, 'Linux-MM' <linux-mm@kvack.org>,
>  'linux-kernel' <linux-kernel@vger.kernel.org>, 'Weijie Yang'
>  <weijie.yang.kh@gmail.com>
> Subject: [PATCH 2/2] zram: avoid NULL pointer access when reading
>  mem_used_total
> X-Mailer: Microsoft Office Outlook 12.0
> 
> There is a rare NULL pointer bug in mem_used_total_show() in concurrent
> situation, like this:
> zram is not initialized, process A is a mem_used_total reader which runs
> periodicity, while process B try to init zram.
> 
> 	process A 				process B
> access meta, get a NULL value
> 						init zram, done
> init_done() is true
> access meta->mem_pool, get a NULL pointer BUG
> 
> This patch fixes this issue.
> 	
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>

Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

	-ss

> ---
>  drivers/block/zram/zram_drv.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 64dd79a..2ffd7d8 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -99,11 +99,12 @@ static ssize_t mem_used_total_show(struct device *dev,
>  {
>  	u64 val = 0;
>  	struct zram *zram = dev_to_zram(dev);
> -	struct zram_meta *meta = zram->meta;
>  
>  	down_read(&zram->init_lock);
> -	if (init_done(zram))
> +	if (init_done(zram)) {
> +		struct zram_meta *meta = zram->meta;
>  		val = zs_get_total_pages(meta->mem_pool);
> +	}
>  	up_read(&zram->init_lock);
>  
>  	return scnprintf(buf, PAGE_SIZE, "%llu\n", val << PAGE_SHIFT);
> -- 
> 1.7.0.4
> 
> 

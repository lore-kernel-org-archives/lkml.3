Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbaHYEJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 00:09:05 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:47353 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaHYEJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 00:09:03 -0400
MIME-Version: 1.0
In-Reply-To: <1408925156-11733-3-git-send-email-minchan@kernel.org>
References: <1408925156-11733-1-git-send-email-minchan@kernel.org>
	<1408925156-11733-3-git-send-email-minchan@kernel.org>
Date: Mon, 25 Aug 2014 00:08:51 -0400
Message-ID: <CAFdhcLR=Hfvpq5rCozAbym8uhxE1sOyuDz0J1NOzyaURUoY2qw@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] zsmalloc: change return value unit of zs_get_total_size_bytes
From: David Horner <ds2horner@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, juno.choi@lge.com,
        seungho1.park@lge.com, Luigi Semenzato <semenzato@google.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Dan Streetman <ddstreet@ieee.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2014 at 8:05 PM, Minchan Kim <minchan@kernel.org> wrote:
> zs_get_total_size_bytes returns a amount of memory zsmalloc
> consumed with *byte unit* but zsmalloc operates *page unit*
> rather than byte unit so let's change the API so benefit
> we could get is that reduce unnecessary overhead
> (ie, change page unit with byte unit) in zsmalloc.
>
> Since return type is pages, "zs_get_total_pages" is better than
> "zs_get_total_size_bytes".
>
> Reviewed-by: Dan Streetman <ddstreet@ieee.org>
Reviewed-by: David Horner <ds2horner@gmail.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  drivers/block/zram/zram_drv.c | 4 ++--
>  include/linux/zsmalloc.h      | 2 +-
>  mm/zsmalloc.c                 | 9 ++++-----
>  3 files changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index d00831c3d731..f0b8b30a7128 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -103,10 +103,10 @@ static ssize_t mem_used_total_show(struct device *dev,
>
>         down_read(&zram->init_lock);
>         if (init_done(zram))
> -               val = zs_get_total_size_bytes(meta->mem_pool);
> +               val = zs_get_total_pages(meta->mem_pool);
>         up_read(&zram->init_lock);
>
> -       return scnprintf(buf, PAGE_SIZE, "%llu\n", val);
> +       return scnprintf(buf, PAGE_SIZE, "%llu\n", val << PAGE_SHIFT);
>  }
>
>  static ssize_t max_comp_streams_show(struct device *dev,
> diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
> index e44d634e7fb7..05c214760977 100644
> --- a/include/linux/zsmalloc.h
> +++ b/include/linux/zsmalloc.h
> @@ -46,6 +46,6 @@ void *zs_map_object(struct zs_pool *pool, unsigned long handle,
>                         enum zs_mapmode mm);
>  void zs_unmap_object(struct zs_pool *pool, unsigned long handle);
>
> -u64 zs_get_total_size_bytes(struct zs_pool *pool);
> +unsigned long zs_get_total_pages(struct zs_pool *pool);
>
>  #endif
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 2a4acf400846..c4a91578dc96 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -297,7 +297,7 @@ static void zs_zpool_unmap(void *pool, unsigned long handle)
>
>  static u64 zs_zpool_total_size(void *pool)
>  {
> -       return zs_get_total_size_bytes(pool);
> +       return zs_get_total_pages(pool) << PAGE_SHIFT;
>  }
>
>  static struct zpool_driver zs_zpool_driver = {
> @@ -1181,12 +1181,11 @@ void zs_unmap_object(struct zs_pool *pool, unsigned long handle)
>  }
>  EXPORT_SYMBOL_GPL(zs_unmap_object);
>
> -u64 zs_get_total_size_bytes(struct zs_pool *pool)
> +unsigned long zs_get_total_pages(struct zs_pool *pool)
>  {
> -       u64 npages = atomic_long_read(&pool->pages_allocated);
> -       return npages << PAGE_SHIFT;
> +       return atomic_long_read(&pool->pages_allocated);
>  }
> -EXPORT_SYMBOL_GPL(zs_get_total_size_bytes);
> +EXPORT_SYMBOL_GPL(zs_get_total_pages);
>
>  module_init(zs_init);
>  module_exit(zs_exit);
> --
> 2.0.0
>

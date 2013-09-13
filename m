Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab3IMLta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 07:49:30 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44137 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3IMLt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 07:49:27 -0400
Message-ID: <5232FBC0.2030509@gmail.com>
Date: Fri, 13 Sep 2013 19:49:20 +0800
From: Jin Xu <linuxclimber@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Chao Yu <chao2.yu@samsung.com>
CC: ??? <jaegeuk.kim@samsung.com>, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?GB2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: Re: [f2fs-dev][PATCH] f2fs: limit nr_iovecs in bio_alloc
References: <000001ceb069$318a87a0$949f96e0$@samsung.com>
In-Reply-To: <000001ceb069$318a87a0$949f96e0$@samsung.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did this patch pass the basic build? There seems have a typo
regarding MAX_BIO_BLOCK.

--
Jin

On 13/09/2013 18:07, Chao Yu wrote:
> This patch add macro MAX_BIO_BLOCKS to limit value of npages in
> f2fs_bio_alloc,
> it can avoid to return NULL in bio_alloc caused by npages is larger than
> UIO_MAXIOV.
>
> Signed-off-by: Yu Chao <chao2.yu@samsung.com>
>  ---
>  fs/f2fs/segment.c |    4 +++-
>  fs/f2fs/segment.h |    3 +++
>  2 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index 09af9c7..bd79bbe 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -657,6 +657,7 @@ static void submit_write_page(struct f2fs_sb_info *sbi,
> struct page *page,
>                                 block_t blk_addr, enum page_type type)
>  {
>         struct block_device *bdev = sbi->sb->s_bdev;
> +       int bio_blocks;
>  
>         verify_block_addr(sbi, blk_addr);
>  
> @@ -676,7 +677,8 @@ retry:
>                         goto retry;
>                 }
>  
> -               sbi->bio[type] = f2fs_bio_alloc(bdev, max_hw_blocks(sbi));
> +               bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> +               sbi->bio[type] = f2fs_bio_alloc(bdev, bio_blocks);
>                 sbi->bio[type]->bi_sector = SECTOR_FROM_BLOCK(sbi,
> blk_addr);
>                 sbi->bio[type]->bi_private = priv;
>                 /*
> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
> index bdd10ea..9cc95eb 100644
> --- a/fs/f2fs/segment.h
> +++ b/fs/f2fs/segment.h
> @@ -9,6 +9,7 @@
>   * published by the Free Software Foundation.
>   */
>  #include <linux/blkdev.h>
> +#include <linux/uio.h>
>  
>  /* constant macro */
>  #define NULL_SEGNO                     ((unsigned int)(~0))
> @@ -90,6 +91,8 @@
>         (blk_addr << ((sbi)->log_blocksize - F2FS_LOG_SECTOR_SIZE))
>  #define SECTOR_TO_BLOCK(sbi, sectors)                                  \
>         (sectors >> ((sbi)->log_blocksize - F2FS_LOG_SECTOR_SIZE))
> +#define MAX_BIO_BLOCK(max_hw_blocks)                                   \
> +       (min((int)max_hw_blocks, UIO_MAXIOV))
>  
>  /* during checkpoint, bio_private is used to synchronize the last bio */
>  struct bio_private {
> ---
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


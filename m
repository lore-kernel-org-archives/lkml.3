Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab3IPCON (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 22:14:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53097 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755943Ab3IPCOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 22:14:11 -0400
X-IronPort-AV: E=Sophos;i="4.90,912,1371052800"; 
   d="scan'208";a="8533619"
Message-ID: <5236684C.6020606@cn.fujitsu.com>
Date: Mon, 16 Sep 2013 10:09:16 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Chao Yu <chao2.yu@samsung.com>
CC: Kim Jaegeuk <jaegeuk.kim@gmail.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?GB2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: Re: [f2fs-dev][PATCH RESEND] f2fs: avoid allocating failure in bio_alloc
References: <000301ceb085$13189480$3949bd80$@samsung.com>
In-Reply-To: <000301ceb085$13189480$3949bd80$@samsung.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/16 10:12:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/16 10:12:42,
	Serialize complete at 2013/09/16 10:12:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

On 09/13/2013 09:27 PM, Chao Yu wrote:

> This patch add macro MAX_BIO_BLOCKS to limit value of npages in
> f2fs_bio_alloc,
> it can avoid allocating failure in bio_alloc caused by npages is larger than
> UIO_MAXIOV.

As I know bio_alloc is based of *fs_bio_set* pool, without the limitation of UIO_MAXIOV,
am I missing something?

Thanks,
Gu

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
> index bdd10ea..6352af1 100644
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
> +#define MAX_BIO_BLOCKS(max_hw_blocks)                                  \
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
> 



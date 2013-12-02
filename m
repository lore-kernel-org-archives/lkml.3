Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab3LBGPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 01:15:32 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:32394 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab3LBGPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 01:15:30 -0500
X-AuditID: cbfee61a-b7f316d000007e34-b1-529c25800cd3
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
References: <1385776085-21163-1-git-send-email-jaegeuk.kim@samsung.com>
In-reply-to: <1385776085-21163-1-git-send-email-jaegeuk.kim@samsung.com>
Subject: RE: [f2fs-dev] [PATCH] f2fs: remove the own bi_private allocation
Date: Mon, 02 Dec 2013 14:14:06 +0800
Message-id: <000201ceef25$e145cec0$a3d16c40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGX/9NZphYaRjZNa5uMOVNLOkn7OpquScyA
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t9jAd1G1TlBBg0f2Cyu7/rLZHFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr4+v1b0wF
	s/Uqfh/bxdTAuEe1i5GTQ0LAROLI3f9sELaYxIV768FsIYFFjBJPPulC2D8YJfYuLASx2QRU
	JJZ3/GcCsUUEtCV+zm1l72Lk4mAWmMEocXjuP1aIBneJo49usYDYnAIeEusX7WMHsYUFvCQa
	Tr0Ds1kEVCVOHXzD3MXIwcErYCnxvEcEJMwrICjxY/I9sFZmAQ2J/kUb2CBseYnNa94yQ9yp
	ILHj7GtGkFYRASOJRSd5IErEJTYeucUygVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6Xn
	GuoVJ+YWl+al6yXn525iBIf/M6kdjCsbLA4xCnAwKvHwXhSeEyTEmlhWXJl7iFGCg1lJhJfl
	7+wgId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHWq0DhQTSE0tSs1NTC1KLYLJMHJxSDYxVTkbK
	rBseanlLJ06O+hgp0/RWdPrrU8oeHu7/xJfaveyXFubTuc769r//srXTZv1a+DLlAu+Ck/Vv
	KjKa0l0dCzY08f5/tffds6QZLPenRPX+L7X5I8mk1p/Cvf9M9Mqlb6adijoSGbZ2t9L334w9
	sa8kJ+w3WWvfm1p9bFpT+2LFF8s2/z2sxFKckWioxVxUnAgAjy9fgHsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Saturday, November 30, 2013 9:48 AM
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> Subject: [f2fs-dev] [PATCH] f2fs: remove the own bi_private allocation
> 
> Previously f2fs allocates its own bi_private data structure all the time even
> though we don't use it. But, can we remove this bi_private allocation?
> 
> This patch removes such the additional bi_private allocation.
> 
> 1. Retrieve f2fs_sb_info from its page->mapping->host->i_sb.
>  - This removes the usecases of bi_private in end_io.
> 
> 2. Use bi_private only when we really need it.
>  - The bi_private is used only when the checkpoint procedure is conducted.
>  - When conducting the checkpoint, f2fs submits a META_FLUSH bio to wait its bio
> completion.
>  - Since we have no dependancies to remove bi_private now, let's just use
>  bi_private pointer as the completion pointer.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/segment.c | 43 ++++++++++++++++---------------------------
>  fs/f2fs/segment.h |  7 -------
>  2 files changed, 16 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index 0387863..0db4027 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -791,7 +791,7 @@ static void f2fs_end_io_write(struct bio *bio, int err)
>  {
>  	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
>  	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
> -	struct bio_private *p = bio->bi_private;
> +	struct f2fs_sb_info *sbi = F2FS_SB(bvec->bv_page->mapping->host->i_sb);

I'm not sure whether bvec->bv_page->mapping will be set to NULL in the flow
where may not check WRITEBACK flag of page. Is it possible?

> 
>  	do {
>  		struct page *page = bvec->bv_page;
> @@ -802,21 +802,21 @@ static void f2fs_end_io_write(struct bio *bio, int err)
>  			SetPageError(page);
>  			if (page->mapping)
>  				set_bit(AS_EIO, &page->mapping->flags);
> -			set_ckpt_flags(p->sbi->ckpt, CP_ERROR_FLAG);
> -			p->sbi->sb->s_flags |= MS_RDONLY;
> +
> +			set_ckpt_flags(sbi->ckpt, CP_ERROR_FLAG);
> +			sbi->sb->s_flags |= MS_RDONLY;
>  		}
>  		end_page_writeback(page);
> -		dec_page_count(p->sbi, F2FS_WRITEBACK);
> +		dec_page_count(sbi, F2FS_WRITEBACK);
>  	} while (bvec >= bio->bi_io_vec);
> 
> -	if (p->is_sync)
> -		complete(p->wait);
> +	if (bio->bi_private)
> +		complete(bio->bi_private);
> 
> -	if (!get_pages(p->sbi, F2FS_WRITEBACK) &&
> -			!list_empty(&p->sbi->cp_wait.task_list))
> -		wake_up(&p->sbi->cp_wait);
> +	if (!get_pages(sbi, F2FS_WRITEBACK) &&
> +			!list_empty(&sbi->cp_wait.task_list))
> +		wake_up(&sbi->cp_wait);
> 
> -	kfree(p);
>  	bio_put(bio);
>  }
> 
> @@ -838,7 +838,6 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
>  	int rw = sync ? WRITE_SYNC : WRITE;
>  	enum page_type btype = PAGE_TYPE_OF_BIO(type);
>  	struct f2fs_bio_info *io = &sbi->write_io[btype];
> -	struct bio_private *p;
> 
>  	if (!io->bio)
>  		return;
> @@ -851,18 +850,16 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
> 
>  	trace_f2fs_submit_write_bio(sbi->sb, rw, btype, io->bio);
> 
> -	p = io->bio->bi_private;
> -	p->sbi = sbi;
> -	io->bio->bi_end_io = f2fs_end_io_write;
> -
> +	/*
> +	 * META_FLUSH is only from the checkpoint procedure, and we should wait
> +	 * this metadata bio for FS consistency.
> +	 */
>  	if (type == META_FLUSH) {
>  		DECLARE_COMPLETION_ONSTACK(wait);
> -		p->is_sync = true;
> -		p->wait = &wait;
> +		io->bio->bi_private = &wait;
>  		submit_bio(rw, io->bio);
>  		wait_for_completion(&wait);
>  	} else {
> -		p->is_sync = false;
>  		submit_bio(rw, io->bio);
>  	}
>  	io->bio = NULL;
> @@ -897,18 +894,10 @@ static void submit_write_page(struct f2fs_sb_info *sbi, struct page *page,
>  		do_submit_bio(sbi, type, false);
>  alloc_new:
>  	if (io->bio == NULL) {
> -		struct bio_private *priv;
> -retry:
> -		priv = kmalloc(sizeof(struct bio_private), GFP_NOFS);
> -		if (!priv) {
> -			cond_resched();
> -			goto retry;
> -		}
> -
>  		bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
>  		io->bio = f2fs_bio_alloc(bdev, bio_blocks);
>  		io->bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
> -		io->bio->bi_private = priv;
> +		io->bio->bi_end_io = f2fs_end_io_write;
>  		/*
>  		 * The end_io will be assigned at the sumbission phase.
>  		 * Until then, let bio_add_page() merge consecutive IOs as much
> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
> index 7fea2ee..26812fc 100644
> --- a/fs/f2fs/segment.h
> +++ b/fs/f2fs/segment.h
> @@ -92,13 +92,6 @@
>  #define MAX_BIO_BLOCKS(max_hw_blocks)					\
>  	(min((int)max_hw_blocks, BIO_MAX_PAGES))
> 
> -/* during checkpoint, bio_private is used to synchronize the last bio */
> -struct bio_private {
> -	struct f2fs_sb_info *sbi;
> -	bool is_sync;
> -	struct completion *wait;
> -};
> -
>  /*
>   * indicate a block allocation direction: RIGHT and LEFT.
>   * RIGHT means allocating new sections towards the end of volume.
> --
> 1.8.4.474.g128a96c
> 
> 
> ------------------------------------------------------------------------------
> Rapidly troubleshoot problems before they affect your business. Most IT
> organizations don't have a clear picture of how application performance
> affects their revenue. With AppDynamics, you get 100% visibility into your
> Java,.NET, & PHP application. Start your 15-day FREE TRIAL of AppDynamics Pro!
> http://pubads.g.doubleclick.net/gampad/clk?id=84349351&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel


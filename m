Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab3LBCAS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 21:00:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:47912 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab3LBCAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 21:00:14 -0500
X-IronPort-AV: E=Sophos;i="4.93,807,1378828800"; 
   d="scan'208";a="9167363"
Message-ID: <529BE288.5060000@cn.fujitsu.com>
Date: Mon, 02 Dec 2013 09:29:44 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH] f2fs: remove the own bi_private allocation
References: <1385776085-21163-1-git-send-email-jaegeuk.kim@samsung.com>
In-Reply-To: <1385776085-21163-1-git-send-email-jaegeuk.kim@samsung.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/02 09:36:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/02 09:37:02,
	Serialize complete at 2013/12/02 09:37:02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2013 09:48 AM, Jaegeuk Kim wrote:

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

Cool, looks good to me.:)

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>

 Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

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



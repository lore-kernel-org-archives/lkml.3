Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab3KRJ1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:27:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:6032 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab3KRJ1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:27:37 -0500
X-IronPort-AV: E=Sophos;i="4.93,722,1378828800"; 
   d="scan'208";a="9064258"
Message-ID: <5289DC0C.30909@cn.fujitsu.com>
Date: Mon, 18 Nov 2013 17:21:16 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] f2fs: use sbi->wr_mutex for write bios
References: <1384765922-24028-1-git-send-email-jaegeuk.kim@samsung.com> <1384765922-24028-2-git-send-email-jaegeuk.kim@samsung.com>
In-Reply-To: <1384765922-24028-2-git-send-email-jaegeuk.kim@samsung.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/18 17:25:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/18 17:25:43,
	Serialize complete at 2013/11/18 17:25:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,
On 11/18/2013 05:12 PM, Jaegeuk Kim wrote:

> This patch removes an unnecessary semaphore (i.e., sbi->bio_sem).
> There is no reason to use the semaphore when f2fs submits read and write IOs.
> Instead, let's use a write mutex and cover the sbi->bio[] by the lock.

My god, I just sent out an almost the same patch, do we have a telepathy?:)

Regard,
Gu 

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/data.c    |  4 ----
>  fs/f2fs/f2fs.h    |  2 +-
>  fs/f2fs/segment.c | 13 +++++++++----
>  fs/f2fs/super.c   |  2 +-
>  4 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 84867dc..7550026 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -390,8 +390,6 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
>  
>  	trace_f2fs_readpage(page, blk_addr, type);
>  
> -	down_read(&sbi->bio_sem);
> -
>  	/* Allocate a new bio */
>  	bio = f2fs_bio_alloc(bdev, 1);
>  
> @@ -401,13 +399,11 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
>  
>  	if (bio_add_page(bio, page, PAGE_CACHE_SIZE, 0) < PAGE_CACHE_SIZE) {
>  		bio_put(bio);
> -		up_read(&sbi->bio_sem);
>  		f2fs_put_page(page, 1);
>  		return -EFAULT;
>  	}
>  
>  	submit_bio(type, bio);
> -	up_read(&sbi->bio_sem);
>  	return 0;
>  }
>  
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 1c783fd..76f5586 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -375,7 +375,7 @@ struct f2fs_sb_info {
>  	struct f2fs_sm_info *sm_info;		/* segment manager */
>  	struct bio *bio[NR_PAGE_TYPE];		/* bios to merge */
>  	sector_t last_block_in_bio[NR_PAGE_TYPE];	/* last block number */
> -	struct rw_semaphore bio_sem;		/* IO semaphore */
> +	struct mutex write_mutex;		/* mutex for writing IOs */
>  
>  	/* for checkpoint */
>  	struct f2fs_checkpoint *ckpt;		/* raw checkpoint pointer */
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index dad5f1a..893d489 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -871,9 +871,14 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
>  
>  void f2fs_submit_bio(struct f2fs_sb_info *sbi, enum page_type type, bool sync)
>  {
> -	down_write(&sbi->bio_sem);
> +	enum page_type btype = PAGE_TYPE_OF_BIO(type);
> +
> +	if (!sbi->bio[btype])
> +		return;
> +
> +	mutex_lock(&sbi->write_mutex);
>  	do_submit_bio(sbi, type, sync);
> -	up_write(&sbi->bio_sem);
> +	mutex_unlock(&sbi->write_mutex);
>  }
>  
>  static void submit_write_page(struct f2fs_sb_info *sbi, struct page *page,
> @@ -884,7 +889,7 @@ static void submit_write_page(struct f2fs_sb_info *sbi, struct page *page,
>  
>  	verify_block_addr(sbi, blk_addr);
>  
> -	down_write(&sbi->bio_sem);
> +	mutex_lock(&sbi->write_mutex);
>  
>  	inc_page_count(sbi, F2FS_WRITEBACK);
>  
> @@ -919,7 +924,7 @@ retry:
>  
>  	sbi->last_block_in_bio[type] = blk_addr;
>  
> -	up_write(&sbi->bio_sem);
> +	mutex_unlock(&sbi->write_mutex);
>  	trace_f2fs_submit_write_page(page, blk_addr, type);
>  }
>  
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index 2c52527..c7b6300 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -882,7 +882,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
>  	mutex_init(&sbi->node_write);
>  	sbi->por_doing = false;
>  	spin_lock_init(&sbi->stat_lock);
> -	init_rwsem(&sbi->bio_sem);
> +	mutex_init(&sbi->write_mutex);
>  	init_rwsem(&sbi->cp_rwsem);
>  	init_waitqueue_head(&sbi->cp_wait);
>  	init_sb_info(sbi);



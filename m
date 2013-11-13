Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab3KMDqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 22:46:09 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:25553 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755874Ab3KMDpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 22:45:51 -0500
X-IronPort-AV: E=Sophos;i="4.93,690,1378828800"; 
   d="scan'208";a="9020141"
Message-ID: <5282F46C.5040403@cn.fujitsu.com>
Date: Wed, 13 Nov 2013 11:39:24 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Chao Yu <chao2.yu@samsung.com>
CC: ??? <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        =?GB2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: Re: [f2fs-dev] [PATCH 1/2] f2fs: add a new function to support for
 merging contiguous read
References: <000001cedf66$46a9bb70$d3fd3250$@samsung.com>
In-Reply-To: <000001cedf66$46a9bb70$d3fd3250$@samsung.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/13 11:43:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/13 11:43:56,
	Serialize complete at 2013/11/13 11:43:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 01:15 PM, Chao Yu wrote:

> For better read performance, we add a new function to support for merging contiguous read as the one for write.

Nice shot!

> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>

Acked-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

> ---
>  fs/f2fs/data.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
>  fs/f2fs/f2fs.h |    2 ++
>  2 files changed, 47 insertions(+)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index aa3438c..f30060b 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -404,6 +404,51 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
>  	return 0;
>  }
>  
> +void f2fs_submit_read_bio(struct f2fs_sb_info *sbi, int rw)
> +{
> +	down_read(&sbi->bio_sem);
> +	if (sbi->read_bio) {
> +		submit_bio(rw, sbi->read_bio);
> +		sbi->read_bio = NULL;
> +	}
> +	up_read(&sbi->bio_sem);
> +}
> +
> +void submit_read_page(struct f2fs_sb_info *sbi, struct page *page,
> +					block_t blk_addr, int rw)
> +{
> +	struct block_device *bdev = sbi->sb->s_bdev;
> +	int bio_blocks;
> +
> +	verify_block_addr(sbi, blk_addr);
> +
> +	down_read(&sbi->bio_sem);
> +
> +	if (sbi->read_bio && sbi->last_read_block != blk_addr - 1) {
> +		submit_bio(rw, sbi->read_bio);
> +		sbi->read_bio = NULL;
> +	}
> +
> +alloc_new:
> +	if (sbi->read_bio == NULL) {
> +		bio_blocks = MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> +		sbi->read_bio = f2fs_bio_alloc(bdev, bio_blocks);
> +		sbi->read_bio->bi_sector = SECTOR_FROM_BLOCK(sbi, blk_addr);
> +		sbi->read_bio->bi_end_io = read_end_io;
> +	}
> +
> +	if (bio_add_page(sbi->read_bio, page, PAGE_CACHE_SIZE, 0) <
> +							PAGE_CACHE_SIZE) {
> +		submit_bio(rw, sbi->read_bio);
> +		sbi->read_bio = NULL;
> +		goto alloc_new;
> +	}
> +
> +	sbi->last_read_block = blk_addr;
> +
> +	up_read(&sbi->bio_sem);
> +}
> +
>  /*
>   * This function should be used by the data read flow only where it
>   * does not check the "create" flag that indicates block allocation.
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 89dc750..0afdcec 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -359,6 +359,8 @@ struct f2fs_sb_info {
>  
>  	/* for segment-related operations */
>  	struct f2fs_sm_info *sm_info;		/* segment manager */
> +	struct bio *read_bio;			/* read bios to merge */
> +	sector_t last_read_block;		/* last read block number */
>  	struct bio *bio[NR_PAGE_TYPE];		/* bios to merge */
>  	sector_t last_block_in_bio[NR_PAGE_TYPE];	/* last block number */
>  	struct rw_semaphore bio_sem;		/* IO semaphore */



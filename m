Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbaLWSuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 13:50:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:43681 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbaLWSuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 13:50:39 -0500
Date: Tue, 23 Dec 2014 10:50:33 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: Changman Lee <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [f2fs-dev][PATCH] f2fs: cleanup trace event of
 f2fs_submit_page_{m,}bio with DECLARE_EVENT_CLASS
Message-ID: <20141223185033.GA12880@jaegeuk-mac02>
References: <003701d01e8b$883e0e00$98ba2a00$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003701d01e8b$883e0e00$98ba2a00$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

Is there a chance to use *fio* as one parameter?

Thanks,

On Tue, Dec 23, 2014 at 04:35:21PM +0800, Chao Yu wrote:
> This patch adds missing parameter _type_ for trace_f2fs_submit_page_bio, then
> use DECLARE_EVENT_CLASS/DEFINE_EVENT_CONDITION pair to cleanup some trace event
> code related to f2fs_submit_page_{m,}bio.
> 
> Additionally, after we remove redundant code, size of code can be reduced:
>    text    data     bss     dec     hex filename
>  176787    8712      56  185555   2d4d3 f2fs.ko.org
>  174408    8648      56  183112   2cb48 f2fs.ko
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/data.c              |   4 +-
>  include/trace/events/f2fs.h | 115 ++++++++++++++++++++------------------------
>  2 files changed, 53 insertions(+), 66 deletions(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 20aa3c3..7953bc2 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -137,7 +137,7 @@ int f2fs_submit_page_bio(struct f2fs_sb_info *sbi, struct page *page,
>  {
>  	struct bio *bio;
>  
> -	trace_f2fs_submit_page_bio(page, fio->blk_addr, fio->rw);
> +	trace_f2fs_submit_page_bio(page, fio->blk_addr, fio->rw, fio->type);
>  	f2fs_trace_ios(page, fio, 0);
>  
>  	/* Allocate a new bio */
> @@ -190,7 +190,7 @@ alloc_new:
>  	f2fs_trace_ios(page, fio, 0);
>  
>  	up_write(&io->io_rwsem);
> -	trace_f2fs_submit_page_mbio(page, fio->rw, fio->type, fio->blk_addr);
> +	trace_f2fs_submit_page_mbio(page, fio->blk_addr, fio->rw, fio->type);
>  }
>  
>  /*
> diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
> index bbc4de9..553311f 100644
> --- a/include/trace/events/f2fs.h
> +++ b/include/trace/events/f2fs.h
> @@ -440,38 +440,6 @@ TRACE_EVENT(f2fs_truncate_partial_nodes,
>  		__entry->err)
>  );
>  
> -TRACE_EVENT_CONDITION(f2fs_submit_page_bio,
> -
> -	TP_PROTO(struct page *page, sector_t blkaddr, int type),
> -
> -	TP_ARGS(page, blkaddr, type),
> -
> -	TP_CONDITION(page->mapping),
> -
> -	TP_STRUCT__entry(
> -		__field(dev_t,	dev)
> -		__field(ino_t,	ino)
> -		__field(pgoff_t,	index)
> -		__field(sector_t,	blkaddr)
> -		__field(int,	type)
> -	),
> -
> -	TP_fast_assign(
> -		__entry->dev		= page->mapping->host->i_sb->s_dev;
> -		__entry->ino		= page->mapping->host->i_ino;
> -		__entry->index		= page->index;
> -		__entry->blkaddr	= blkaddr;
> -		__entry->type		= type;
> -	),
> -
> -	TP_printk("dev = (%d,%d), ino = %lu, page_index = 0x%lx, "
> -		"blkaddr = 0x%llx, bio_type = %s%s",
> -		show_dev_ino(__entry),
> -		(unsigned long)__entry->index,
> -		(unsigned long long)__entry->blkaddr,
> -		show_bio_type(__entry->type))
> -);
> -
>  TRACE_EVENT(f2fs_get_data_block,
>  	TP_PROTO(struct inode *inode, sector_t iblock,
>  				struct buffer_head *bh, int ret),
> @@ -680,6 +648,57 @@ TRACE_EVENT(f2fs_reserve_new_block,
>  		__entry->ofs_in_node)
>  );
>  
> +DECLARE_EVENT_CLASS(f2fs__submit_page_bio,
> +
> +	TP_PROTO(struct page *page, block_t blkaddr, int rw, int type),
> +
> +	TP_ARGS(page, blkaddr, rw, type),
> +
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(ino_t, ino)
> +		__field(pgoff_t, index)
> +		__field(block_t, blkaddr)
> +		__field(int, rw)
> +		__field(int, type)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->dev		= page->mapping->host->i_sb->s_dev;
> +		__entry->ino		= page->mapping->host->i_ino;
> +		__entry->index		= page->index;
> +		__entry->blkaddr	= blkaddr;
> +		__entry->rw		= rw;
> +		__entry->type		= type;
> +	),
> +
> +	TP_printk("dev = (%d,%d), ino = %lu, page_index = 0x%lx, "
> +		"blkaddr = 0x%llx, rw = %s%s, type = %s",
> +		show_dev_ino(__entry),
> +		(unsigned long)__entry->index,
> +		(unsigned long long)__entry->blkaddr,
> +		show_bio_type(__entry->rw),
> +		show_block_type(__entry->type))
> +);
> +
> +DEFINE_EVENT_CONDITION(f2fs__submit_page_bio, f2fs_submit_page_bio,
> +
> +	TP_PROTO(struct page *page, block_t blkaddr, int rw, int type),
> +
> +	TP_ARGS(page, blkaddr, rw, type),
> +
> +	TP_CONDITION(page->mapping)
> +);
> +
> +DEFINE_EVENT_CONDITION(f2fs__submit_page_bio, f2fs_submit_page_mbio,
> +
> +	TP_PROTO(struct page *page, block_t blkaddr, int rw, int type),
> +
> +	TP_ARGS(page, blkaddr, rw, type),
> +
> +	TP_CONDITION(page->mapping)
> +);
> +
>  DECLARE_EVENT_CLASS(f2fs__submit_bio,
>  
>  	TP_PROTO(struct super_block *sb, int rw, int type, struct bio *bio),
> @@ -916,38 +935,6 @@ TRACE_EVENT(f2fs_writepages,
>  		__entry->for_sync)
>  );
>  
> -TRACE_EVENT(f2fs_submit_page_mbio,
> -
> -	TP_PROTO(struct page *page, int rw, int type, block_t blk_addr),
> -
> -	TP_ARGS(page, rw, type, blk_addr),
> -
> -	TP_STRUCT__entry(
> -		__field(dev_t,	dev)
> -		__field(ino_t,	ino)
> -		__field(int, rw)
> -		__field(int, type)
> -		__field(pgoff_t, index)
> -		__field(block_t, block)
> -	),
> -
> -	TP_fast_assign(
> -		__entry->dev	= page->mapping->host->i_sb->s_dev;
> -		__entry->ino	= page->mapping->host->i_ino;
> -		__entry->rw	= rw;
> -		__entry->type	= type;
> -		__entry->index	= page->index;
> -		__entry->block	= blk_addr;
> -	),
> -
> -	TP_printk("dev = (%d,%d), ino = %lu, %s%s, %s, index = %lu, blkaddr = 0x%llx",
> -		show_dev_ino(__entry),
> -		show_bio_type(__entry->rw),
> -		show_block_type(__entry->type),
> -		(unsigned long)__entry->index,
> -		(unsigned long long)__entry->block)
> -);
> -
>  TRACE_EVENT(f2fs_write_checkpoint,
>  
>  	TP_PROTO(struct super_block *sb, int reason, char *msg),
> -- 
> 2.2.1

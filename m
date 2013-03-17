Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab3CQNkL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 09:40:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5487 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab3CQNkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 09:40:06 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=TEBkTCqgGbUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=9zBKDYq3lMIA:10 a=hD80L64hAAAA:8 a=sv4GSNfhMyjI3i0lrlIA:9 a=PUjeQqilurYA:10 a=v3rLFGiuRE8A:10 a=pzcgHt7BIlHJOh1L:21 a=6i_QezVtkkXCAsO7:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363527603.25967.119.camel@gandalf.local.home>
Subject: Re: [PATCH v2 3/7] f2fs: add tracepoint for tracing the page i/o
 operations
From: Steven Rostedt <rostedt@goodmis.org>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jaegeuk.kim@samsung.com, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Date: Sun, 17 Mar 2013 09:40:03 -0400
In-Reply-To: <1363509620-3571-1-git-send-email-linkinjeon@gmail.com>
References: <1363509620-3571-1-git-send-email-linkinjeon@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-03-17 at 17:40 +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Add tracepoints for page i/o operations and block allocation
> tracing during page read operation.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
> ---
>  fs/f2fs/data.c              |   11 ++++++--
>  include/trace/events/f2fs.h |   58 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 67 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 02ad450..bb9117b 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -22,6 +22,7 @@
>  #include "f2fs.h"
>  #include "node.h"
>  #include "segment.h"
> +#include <trace/events/f2fs.h>
>  
>  /*
>   * Lock ordering for the change of data block address:
> @@ -335,6 +336,9 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
>  	bool sync = (type == READ_SYNC);
>  	struct bio *bio;
>  
> +	if (page->mapping)
> +		trace_f2fs_readpage(page);

Since the only thing that happens whet page->mapping is set is to trace
the page, you can move that check into the tracepoint itself. That is,
move the branch into the tracepoint, making the branch a nop when the
tracepoint isn't active. That's what TRACE_EVENT_CONDITION() does. Make
this into:

	trace_f2fs_readpage(page);

and then see below.

> +
>  	/* This page can be already read by other threads */
>  	if (PageUptodate(page)) {
>  		if (!sync)
> @@ -385,6 +389,7 @@ static int get_data_block_ro(struct inode *inode, sector_t iblock,
>  	pgoff_t pgofs;
>  	int err;
>  
> +	trace_f2fs_get_data_block_enter(inode, iblock, 0);
>  	/* Get the page offset from the block offset(iblock) */
>  	pgofs =	(pgoff_t)(iblock >> (PAGE_CACHE_SHIFT - blkbits));
>  
> @@ -394,9 +399,10 @@ static int get_data_block_ro(struct inode *inode, sector_t iblock,
>  	/* When reading holes, we need its node page */
>  	set_new_dnode(&dn, inode, NULL, NULL, 0);
>  	err = get_dnode_of_data(&dn, pgofs, LOOKUP_NODE_RA);
> -	if (err)
> +	if (err) {
> +		trace_f2fs_get_data_block_exit(inode, iblock, err);
>  		return (err == -ENOENT) ? 0 : err;
> -
> +	}
>  	/* It does not support data allocation */
>  	BUG_ON(create);
>  
> @@ -420,6 +426,7 @@ static int get_data_block_ro(struct inode *inode, sector_t iblock,
>  		bh_result->b_size = (i << blkbits);
>  	}
>  	f2fs_put_dnode(&dn);
> +	trace_f2fs_get_data_block_exit(inode, iblock, 0);
>  	return 0;
>  }
>  
> diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
> index 0d39f58..d60f3ed 100644
> --- a/include/trace/events/f2fs.h
> +++ b/include/trace/events/f2fs.h
> @@ -266,6 +266,64 @@ TRACE_EVENT(f2fs_truncate,
>  		  (unsigned long) __entry->ino)
>  );
>  
> +TRACE_EVENT(f2fs_readpage,

TRACE_EVENT_CONDITIO(f2fs_readpage,

> +	TP_PROTO(struct page *page),
> +
> +	TP_ARGS(page),

	TP_CONDITION(page->mapping),

That's it!

Now the tracepoint will only be called if page->mapping is set, but
checking page->mapping will be done only if the tracepoint is enabled.
Keeping the original code untouched.

-- Steve

> +
> +	TP_STRUCT__entry(
> +		__field(pgoff_t, index)
> +		__field(ino_t,	ino)
> +		__field(dev_t,	dev)
> +
> +	),
> +
> +	TP_fast_assign(
> +		__entry->index	= page->index;
> +		__entry->ino	= page->mapping->host->i_ino;
> +		__entry->dev	= page->mapping->host->i_sb->s_dev;
> +	),
> +
> +	TP_printk("dev %d,%d ino %lu page_index %lu",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  (unsigned long) __entry->ino,
> +		  (unsigned long) __entry->index)
> +);
> +
> +DECLARE_EVENT_CLASS(f2fs_data_block,
> +	TP_PROTO(struct inode *inode, sector_t block, int ret),
> +
> +	TP_ARGS(inode, block, ret),
> +
> +	TP_STRUCT__entry(
> +		__field(dev_t,	dev)
> +		__field(ino_t,	ino)
> +		__field(sector_t,	block)
> +		__field(int,	ret)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->dev	= inode->i_sb->s_dev;
> +		__entry->ino	= inode->i_ino;
> +		__entry->block	= block;
> +		__entry->ret	= ret;
> +	),
> +
> +	TP_printk("dev %d,%d ino %lu block number %llu error %d",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  (unsigned long) __entry->ino, (unsigned long long) __entry->block, __entry->ret)
> +);
> +
> +DEFINE_EVENT(f2fs_data_block, f2fs_get_data_block_enter,
> +	TP_PROTO(struct inode *inode, sector_t block, int ret),
> +	TP_ARGS(inode, block, ret)
> +);
> +
> +DEFINE_EVENT(f2fs_data_block, f2fs_get_data_block_exit,
> +	TP_PROTO(struct inode *inode, sector_t block, int ret),
> +	TP_ARGS(inode, block, ret)
> +);
> +
>  #endif /* _TRACE_F2FS_H */
>  
>   /* This part must be outside protection */



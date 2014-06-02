Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbaFBDPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 23:15:31 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:13207 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751869AbaFBDPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 23:15:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmJ3AOLqi1N5LL1sPGdsb2JhbABZgweDRagRAQEBAQEBBpgbAYEPFwMBAQEBODWCJQEBBScTHCMQCAMVAgEJJQ8FJQMHDA4TiEHUFhcWhT+ILAEBTweEQASZf5Z4K4E5
Date: Mon, 2 Jun 2014 13:15:26 +1000
From: Dave Chinner <david@fromorbit.com>
To: Daniel Phillips <daniel@phunq.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [RFC][PATCH 1/2] Add a super operation for writeback
Message-ID: <20140602031526.GS14410@dastard>
References: <538B9DEE.20800@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538B9DEE.20800@phunq.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 02:41:02PM -0700, Daniel Phillips wrote:
> ---
> From: Daniel Phillips <daniel@tux3.org>
> Subject: [PATCH] Add a super operation for writeback
> 
> Add a "writeback" super operation to be called in the
> form:
> 
>         progress = sb->s_op->writeback(sb, &wbc, &pages);
> 
> The filesystem is expected to flush some inodes to disk
> and return progress of at least 1, or if no inodes are
> flushed, return progress of zero. The filesystem should
> try to flush at least the number of pages specified in
> *pages, or if that is not possible, return approximately
> the number of pages not flushed into *pages.
> 
> Within the ->writeback callback, the filesystem should
> call inode_writeback_done(inode) for each inode flushed
> (and therefore set clean) or inode_writeback_touch(inode)
> for any inode that will be retained dirty in cache.
> 
> Signed-off-by: Daniel Phillips  <daniel@tux3.org>
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
> 
>  fs/fs-writeback.c  |   59 +++++++++++++++++++++++++++++++++++++++++++++++++---
>  include/linux/fs.h |    4 +++
>  2 files changed, 60 insertions(+), 3 deletions(-)
> 
> diff -puN fs/fs-writeback.c~core-writeback fs/fs-writeback.c
> --- linux-tux3/fs/fs-writeback.c~core-writeback	2014-05-31 06:43:19.416031712 +0900
> +++ linux-tux3-hirofumi/fs/fs-writeback.c	2014-05-31 06:44:46.087904373 +0900
> @@ -192,6 +192,35 @@ void inode_wb_list_del(struct inode *ino
>  }
> 
>  /*
> + * Remove inode from writeback list if clean.
> + */
> +void inode_writeback_done(struct inode *inode)
> +{
> +	struct backing_dev_info *bdi = inode_to_bdi(inode);
> +
> +	spin_lock(&bdi->wb.list_lock);
> +	spin_lock(&inode->i_lock);
> +	if (!(inode->i_state & I_DIRTY))
> +		list_del_init(&inode->i_wb_list);
> +	spin_unlock(&inode->i_lock);
> +	spin_unlock(&bdi->wb.list_lock);
> +}
> +EXPORT_SYMBOL_GPL(inode_writeback_done);
> +
> +/*
> + * Add inode to writeback dirty list with current time.
> + */
> +void inode_writeback_touch(struct inode *inode)
> +{
> +	struct backing_dev_info *bdi = inode->i_sb->s_bdi;
> +	spin_lock(&bdi->wb.list_lock);
> +	inode->dirtied_when = jiffies;
> +	list_move(&inode->i_wb_list, &bdi->wb.b_dirty);
> +	spin_unlock(&bdi->wb.list_lock);
> +}
> +EXPORT_SYMBOL_GPL(inode_writeback_touch);

You should be able to use redirty_tail() for this....

Hmmmm - this is using the wb dirty lists and locks, but you
don't pass the wb structure to the writeback callout? That seem
wrong to me - why would you bother manipulating these lists if you
aren't using them to track dirty inodes in the first place?

> +
> +/*
>   * Redirty an inode: set its when-it-was dirtied timestamp and move it to the
>   * furthest end of its superblock's dirty-inode list.
>   *
> @@ -593,9 +622,9 @@ static long writeback_chunk_size(struct
>   *
>   * Return the number of pages and/or inodes written.
>   */
> -static long writeback_sb_inodes(struct super_block *sb,
> -				struct bdi_writeback *wb,
> -				struct wb_writeback_work *work)
> +static long __writeback_sb_inodes(struct super_block *sb,
> +				  struct bdi_writeback *wb,
> +				  struct wb_writeback_work *work)
>  {
>  	struct writeback_control wbc = {
>  		.sync_mode		= work->sync_mode,
> @@ -710,6 +739,30 @@ static long writeback_sb_inodes(struct s
>  	return wrote;
>  }
> 
> +static long writeback_sb_inodes(struct super_block *sb,
> +				struct bdi_writeback *wb,
> +				struct wb_writeback_work *work)
> +{
> +	if (sb->s_op->writeback) {
> +		struct writeback_control wbc = {
> +			.sync_mode		= work->sync_mode,
> +			.tagged_writepages	= work->tagged_writepages,
> +			.for_kupdate		= work->for_kupdate,
> +			.for_background		= work->for_background,
> +			.for_sync		= work->for_sync,
> +			.range_cyclic		= work->range_cyclic,
> +		};
> +		long ret;
> +
> +		spin_unlock(&wb->list_lock);
> +		ret = sb->s_op->writeback(sb, &wbc, &work->nr_pages);
> +		spin_lock(&wb->list_lock);
> +		return ret;
> +	}
> +
> +	return __writeback_sb_inodes(sb, wb, work);
> +}

The first thing that __writeback_sb_inodes() does is create a struct
writeback_control from the wb_writeback_work. That should be done
here and passed to __writeback_sb_inodes(), which should be renamed
"generic_writeback_sb_inodes()".  Also, all the fields in the wbc
need to be initialised correctly (i.e including range_start/end).

Further, a writeback implementation will need to use the generic bdi
list and lock structures and so we need to pass the bdi_writeback.
Similarly, if we are going to pass nr_pages, we might as well pass
the entire work structure. 

Finally, I don't like the way the wb->list_lock is treated
differently by this code. I suspect that we need to rationalise the
layering of the wb->list_lock as it is currently not clear what it
protects and what (nested) layers of the writeback code actually
require it.

What I'd like to see is this work:

struct super_ops ... = {
....
	.writeback = generic_writeback_sb_inodes,
....

And that means writeback_sb_inodes() would become:

static long writeback_sb_inodes(struct super_block *sb,
				struct bdi_writeback *wb,
				struct wb_writeback_work *work)
{
	struct writeback_control wbc = {
		.sync_mode		= work->sync_mode,
		.tagged_writepages	= work->tagged_writepages,
		.for_kupdate		= work->for_kupdate,
		.for_background		= work->for_background,
		.for_sync		= work->for_sync,
		.range_cyclic		= work->range_cyclic,
		.range_start		= 0,
		.range_end		= LLONG_MAX,
	};

	if (sb->s_op->writeback)
		return sb->s_op->writeback(sb, wb, work, &wbc);

	return generic_writeback_sb_inodes(sb, wb, work, &wbc);
}

And the higher/lower layers deal with wb->list_lock appropriately.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

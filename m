Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbaFBUCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:02:36 -0400
Received: from mail.phunq.net ([184.71.0.62]:57823 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbaFBUCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:02:34 -0400
Message-ID: <538CD855.90804@phunq.net>
Date: Mon, 02 Jun 2014 13:02:29 -0700
From: Daniel Phillips <daniel@phunq.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [RFC][PATCH 1/2] Add a super operation for writeback
References: <538B9DEE.20800@phunq.net> <20140602031526.GS14410@dastard>
In-Reply-To: <20140602031526.GS14410@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06/01/2014 08:15 PM, Dave Chinner wrote:
> On Sun, Jun 01, 2014 at 02:41:02PM -0700, I wrote:
>> +
>> +/*
>> + * Add inode to writeback dirty list with current time.
>> + */
>> +void inode_writeback_touch(struct inode *inode)
>> +{
>> +	struct backing_dev_info *bdi = inode->i_sb->s_bdi;
>> +	spin_lock(&bdi->wb.list_lock);
>> +	inode->dirtied_when = jiffies;
>> +	list_move(&inode->i_wb_list, &bdi->wb.b_dirty);
>> +	spin_unlock(&bdi->wb.list_lock);
>> +}
>> +EXPORT_SYMBOL_GPL(inode_writeback_touch);
> You should be able to use redirty_tail() for this....

Redirty_tail nearly works, but "if (!list_empty(&wb->b_dirty))" is not correct because the inode
needs to end up on the dirty list whether it was already there or not. This requirement is analogous
to __mark_inode_dirty() and must tolerate similar races. At the microoptimization level, calling
redirty_tail from inode_writeback_touch would be less efficient and more bulky. Another small issue
is, redirty_tail does not always update the timestamp, which could trigger some bogus writeback events.

> Hmmmm - this is using the wb dirty lists and locks, but you
> don't pass the wb structure to the writeback callout? That seem
> wrong to me - why would you bother manipulating these lists if you
> aren't using them to track dirty inodes in the first place?

>From Tux3's point of view, the wb lists just allow fs-writeback to determine when to call
->writeback(). We agree that inode lists are a suboptimal mechanism, but that is how fs-writeback
currently thinks. It would be better if our inodes never go onto wb lists in the first place,
provided that fs-writeback can still drive writeback appropriately.

Perhaps fs-writeback should have an option to work without inode lists at all, and just maintain
writeback scheduling statistics in the superblock or similar. That would be a big change, more on
the experimental side. We would be happy to take it on after merge, hopefully for the benefit of
other filesystems besides Tux3.

What we pass to ->writeback() is just a matter of taste at the moment because we currently ignore
everything except &work->nr_pages. Anything sane is fine. Note that bdi_writeback is already
available from bdi->wb, the "default writeback info", whatever that means. A quick tour of existing
usage suggests that you can reliably obtain the wb that way, but a complete audit would be needed.

Most probably, this API will evolve as new users arrive, and also as our Tux3 usage becomes more
sophisticated. For now, Tux3 just flushes everything without asking questions. Exactly how that
might change in the future is hard to predict. You are in a better position to know what XFS would
require in order to use this interface.

> The first thing that __writeback_sb_inodes() does is create a struct
> writeback_control from the wb_writeback_work. That should be done
> here and passed to __writeback_sb_inodes(), which should be renamed
> "generic_writeback_sb_inodes()".  Also, all the fields in the wbc
> need to be initialised correctly (i.e including range_start/end).

Good point. I will try that generic_writeback_sb_inode concept for the next iteration, which will
need a day or two including regression testing.

> Further, a writeback implementation will need to use the generic bdi
> list and lock structures and so we need to pass the bdi_writeback.
> Similarly, if we are going to pass nr_pages, we might as well pass
> the entire work structure. 
>
> Finally, I don't like the way the wb->list_lock is treated
> differently by this code. I suspect that we need to rationalise the
> layering of the wb->list_lock as it is currently not clear what it
> protects and what (nested) layers of the writeback code actually
> require it.

One design goal of this proposed writeback interface is to hide the wb list lock entirely from the
filesystem so core writeback can evolve more easily. This is not cast in stone, but it smells like
decent factoring. We can save some spinlocks by violating that factoring (as Hirofumi's original
hack did) at the cost of holding a potentially busy wb lock longer, which does not seem like a good
trade.

I agree that writeback list locking is murky, and fs-writeback is murky in general. We would like
Tux3 to be part of the solution, not the problem.

> What I'd like to see is this work:
>
> struct super_ops ... = {
> ....
> 	.writeback = generic_writeback_sb_inodes,
> ....
>
> And that means writeback_sb_inodes() would become:
>
> static long writeback_sb_inodes(struct super_block *sb,
> 				struct bdi_writeback *wb,
> 				struct wb_writeback_work *work)
> {
> 	struct writeback_control wbc = {
> 		.sync_mode		= work->sync_mode,
> 		.tagged_writepages	= work->tagged_writepages,
> 		.for_kupdate		= work->for_kupdate,
> 		.for_background		= work->for_background,
> 		.for_sync		= work->for_sync,
> 		.range_cyclic		= work->range_cyclic,
> 		.range_start		= 0,
> 		.range_end		= LLONG_MAX,
> 	};
>
> 	if (sb->s_op->writeback)
> 		return sb->s_op->writeback(sb, wb, work, &wbc);
>
> 	return generic_writeback_sb_inodes(sb, wb, work, &wbc);
> }
>
> And the higher/lower layers deal with wb->list_lock appropriately.
>

Looks good to me. As noted above, I am not sure that *work is actually required but it does no harm,
so...

Regards,

Daniel


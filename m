Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaFCDe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 23:34:28 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:26836 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751737AbaFCDe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 23:34:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As11AOxBjVN5LL1sPGdsb2JhbABZgweDRagbAQEBAQEBBpgbAYELFwMBAQEBODWCJQEBBAEnExwjBQsIAxgJJQ8FJQMHGhMZiCEH0GoXFoU/iCVYB4MrgRUElXuEBJZ4K4Ew
Date: Tue, 3 Jun 2014 13:33:22 +1000
From: Dave Chinner <david@fromorbit.com>
To: Daniel Phillips <daniel@phunq.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [RFC][PATCH 1/2] Add a super operation for writeback
Message-ID: <20140603033322.GA14410@dastard>
References: <538B9DEE.20800@phunq.net>
 <20140602031526.GS14410@dastard>
 <538CD855.90804@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538CD855.90804@phunq.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ please line wrap at something sane like 68 columns ]

On Mon, Jun 02, 2014 at 01:02:29PM -0700, Daniel Phillips wrote:
> On 06/01/2014 08:15 PM, Dave Chinner wrote:
> > On Sun, Jun 01, 2014 at 02:41:02PM -0700, I wrote:
> >> +
> >> +/*
> >> + * Add inode to writeback dirty list with current time.
> >> + */
> >> +void inode_writeback_touch(struct inode *inode)
> >> +{
> >> +	struct backing_dev_info *bdi = inode->i_sb->s_bdi;
> >> +	spin_lock(&bdi->wb.list_lock);
> >> +	inode->dirtied_when = jiffies;
> >> +	list_move(&inode->i_wb_list, &bdi->wb.b_dirty);
> >> +	spin_unlock(&bdi->wb.list_lock);
> >> +}
> >> +EXPORT_SYMBOL_GPL(inode_writeback_touch);
> > You should be able to use redirty_tail() for this....
> 
> Redirty_tail nearly works, but "if (!list_empty(&wb->b_dirty))" is
> not correct because the inode needs to end up on the dirty list
> whether it was already there or not.

redirty_tail() always moves the inode to the end of the dirty
list.

> This requirement is analogous to __mark_inode_dirty() and must
> tolerate similar races. At the microoptimization level, calling
> redirty_tail from inode_writeback_touch would be less efficient
> and more bulky. Another small issue is, redirty_tail does not
> always update the timestamp, which could trigger some bogus
> writeback events.

redirty_tail does not update the timestamp when it doesn't need to
change. If it needs to be changed because the current value would
violate the time ordering requirements of the list, it rewrites it.

So there is essentially no functional difference between the new
function and redirty_tail....

> > Hmmmm - this is using the wb dirty lists and locks, but you
> > don't pass the wb structure to the writeback callout? That seem
> > wrong to me - why would you bother manipulating these lists if
> > you aren't using them to track dirty inodes in the first place?
> 
> From Tux3's point of view, the wb lists just allow fs-writeback to
> determine when to call ->writeback(). We agree that inode lists
> are a suboptimal mechanism, but that is how fs-writeback currently
> thinks. It would be better if our inodes never go onto wb lists in
> the first place, provided that fs-writeback can still drive
> writeback appropriately.

It can't, and definitely not with the callout you added.

However, we already avoid the VFS writeback lists for certain
filesystems for pure metadata. e.g. XFS does not use the VFS dirty
inode lists for inode metadata changes.  They get tracked internally
by the transaction subsystem which does it's own writeback according
to the requirements of journal space availability.

This is done simply by not calling mark_inode_dirty() on any
metadata only change. If we want to do the same for data, then we'd
simply not call mark_inode_dirty() in the data IO path. That
requires a custom ->set_page_dirty method to be provided by the
filesystem that didn't call

	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);

and instead did it's own thing.

So the per-superblock dirty tracking is something we can do right
now, and some filesystems do it for metadata. The missing piece for
data is writeback infrastructure capable of deferring to superblocks
for writeback rather than BDIs....

> Perhaps fs-writeback should have an option to work without inode
> lists at all, and just maintain writeback scheduling statistics in
> the superblock or similar. That would be a big change, more on the
> experimental side. We would be happy to take it on after merge,
> hopefully for the benefit of other filesystems besides Tux3.

Well, I don't see it that way. If you have a requirement to be able
to track dirty inodes internally, then lets move to that implement
that infrastructure rather than hacking around with callouts that
only have a limited shelf-life.

> What we pass to ->writeback() is just a matter of taste at the
> moment because we currently ignore everything except
> &work->nr_pages. Anything sane is fine. Note that bdi_writeback is
> already available from bdi->wb, the "default writeback info",
> whatever that means. A quick tour of existing usage suggests that
> you can reliably obtain the wb that way, but a complete audit
> would be needed.
> 
> Most probably, this API will evolve as new users arrive, and also
> as our Tux3 usage becomes more sophisticated. For now, Tux3 just
> flushes everything without asking questions. Exactly how that
> might change in the future is hard to predict. You are in a better
> position to know what XFS would require in order to use this
> interface.

XFS already has everything it needs internally to track dirty
inodes. In fact, we used to do data writeback from within XFS and we
slowly removed it as the generic writeback code was improved made
the XFS code redundant.

That said, parallelising writeback so we can support hundreds of
GB/s of delayed allocation based writeback is something we
eventually need to do, and that pretty much means we need to bring
dirty data inode tracking back into XFS.

So what we really need is writeback infrastructure that is:

	a) independent of the dirty inode lists
	b) implements background, periodic and immediate writeback
	c) can be driven by BDI or superblock

IOWs, the abstraction we need for this writeback callout is not at
the writeback_sb_inodes() layer, it's above the dirty inode list
queuing layer. IOWs, the callout needs to be closer to the
wb_do_writeback() layer which drives all the writeback work
including periodic and background writeback, and the interactions
between foreground and background work that wb_writeback() uses
needs to be turned into a bunch of helpers...

> > Finally, I don't like the way the wb->list_lock is treated
> > differently by this code. I suspect that we need to rationalise
> > the layering of the wb->list_lock as it is currently not clear
> > what it protects and what (nested) layers of the writeback code
> > actually require it.
> 
> One design goal of this proposed writeback interface is to hide
> the wb list lock entirely from the filesystem so core writeback
> can evolve more easily.

Yes, I realise that. Hence my point that the bleeding of it across
layers of writeback infrstructure is sub-optimal.

> This is not cast in stone, but it smells
> like decent factoring. We can save some spinlocks by violating
> that factoring (as Hirofumi's original hack did) at the cost of
> holding a potentially busy wb lock longer, which does not seem
> like a good trade.

If we abstract at a higher layer, the wb lock protects just the work
queuing and dispatch, and everything else can be done by the
superblock callout. If the superblock callout is missing, then
we simply fall down to the existing wb_writeback() code that retakes
the lock and does it's work....

Let's get the layering and abstraction in the right place the first
time, rather having to revist this in the not-to-distant future.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

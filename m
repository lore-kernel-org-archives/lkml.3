Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbaFCHwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:52:16 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:4490 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753232AbaFCHwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:52:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao5xAPF9jVN5LL1sPGdsb2JhbABZgweDRYUIoxMBAgaYGwGBCxcDAQEBATg1giUBAQQBJxMcDxQFCwgDGAklDwUlAwcaExkCiB8H0TAXFoU/g16ER1gHgyuBFQSZf5Z4K4Ew
Date: Tue, 3 Jun 2014 17:52:09 +1000
From: Dave Chinner <david@fromorbit.com>
To: Daniel Phillips <daniel@phunq.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [RFC][PATCH 1/2] Add a super operation for writeback
Message-ID: <20140603075209.GD14410@dastard>
References: <538B9DEE.20800@phunq.net>
 <20140602031526.GS14410@dastard>
 <538CD855.90804@phunq.net>
 <20140603033322.GA14410@dastard>
 <538D72B7.3010700@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538D72B7.3010700@phunq.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 12:01:11AM -0700, Daniel Phillips wrote:
> Hi Dave,
> On 06/02/2014 08:33 PM, Dave Chinner wrote:
> > On Mon, Jun 02, 2014 at 01:02:29PM -0700, Daniel Phillips wrote:
> >>> Hmmmm - this is using the wb dirty lists and locks, but you
> >>> don't pass the wb structure to the writeback callout? That seem
> >>> wrong to me - why would you bother manipulating these lists if
> >>> you aren't using them to track dirty inodes in the first place?
> >> From Tux3's point of view, the wb lists just allow fs-writeback to
> >> determine when to call ->writeback(). We agree that inode lists
> >> are a suboptimal mechanism, but that is how fs-writeback currently
> >> thinks. It would be better if our inodes never go onto wb lists in
> >> the first place, provided that fs-writeback can still drive
> >> writeback appropriately.
> > It can't, and definitely not with the callout you added.
> 
> Obviously, fs-writeback does not get to choose inodes or specific pages
> with our proposal (which is the whole point) but it still decides when
> to call Tux3 vs some other filesystem on the same device, and is still
> able to indicate how much data it thinks should be written out. Even
> though we ignore the latter suggestion and always flush everything, we
> appreciate the timing of those callbacks very much, because they give
> us exactly the pressure sensitive batching behavior we want.

Which, again, points out that you want per-superblock flushing, not
per-bdi flushing which is what the current writeback code does.

> > However, we already avoid the VFS writeback lists for certain
> > filesystems for pure metadata. e.g. XFS does not use the VFS dirty
> > inode lists for inode metadata changes.  They get tracked internally
> > by the transaction subsystem which does it's own writeback according
> > to the requirements of journal space availability.
> >
> > This is done simply by not calling mark_inode_dirty() on any
> > metadata only change. If we want to do the same for data, then we'd
> > simply not call mark_inode_dirty() in the data IO path. That
> > requires a custom ->set_page_dirty method to be provided by the
> > filesystem that didn't call
> >
> > 	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> >
> > and instead did it's own thing.
> >
> > So the per-superblock dirty tracking is something we can do right
> > now, and some filesystems do it for metadata. The missing piece for
> > data is writeback infrastructure capable of deferring to superblocks
> > for writeback rather than BDIs....
> 
> We agree that fs-writeback inode lists are broken for anything
> more sophisticated than Ext2.

No, I did not say that.

I said XFS does something different for metadata changes because it
has different flushing constraints and requirements than the generic
code provides. That does not make the generic code broken.

> An advantage of the patch under
> consideration is that it still lets fs-writeback mostly work the
> way it has worked for the last few years, except for not allowing it
> to pick specific inodes and data pages for writeout. As far as I
> can see, it still balances writeout between different filesystems
> on the same block device pretty well.

Not really. If there are 3 superblocks on a BDI, and the dirty inode
list iterates between 2 of them with lots of dirty inodes, it can
starve writeback from the third until one of it's dirty inodes pops
to the head of the b_io list. So it's inherently unfair from that
perspective.

Changing the high level flushing to be per-superblock rather than
per-BDI would enable us to control that behaviour and be much fairer
to all the superblocks on a given BDI. That said, I don't really
care that much about this case...

> >> Perhaps fs-writeback should have an option to work without inode
> >> lists at all, and just maintain writeback scheduling statistics in
> >> the superblock or similar. That would be a big change, more on the
> >> experimental side. We would be happy to take it on after merge,
> >> hopefully for the benefit of other filesystems besides Tux3.
> > Well, I don't see it that way. If you have a requirement to be able
> > to track dirty inodes internally, then lets move to that implement
> > that infrastructure rather than hacking around with callouts that
> > only have a limited shelf-life.
> 
> What you call shelf-life, I call iteration. Small changes are beautiful.
> Apologies for the rhetoric, content is below.

Ok, let me use stronger language: implementing something at the
wrong layer only to have to redo it at the correct layer a short
while later is wasted effort. Do it right the first time.

I do beleive I've explained this to you at least once before, so
lets not have to go over this again.

> > XFS already has everything it needs internally to track dirty
> > inodes. In fact, we used to do data writeback from within XFS and we
> > slowly removed it as the generic writeback code was improved made
> > the XFS code redundant.
> >
> > That said, parallelising writeback so we can support hundreds of
> > GB/s of delayed allocation based writeback is something we
> > eventually need to do, and that pretty much means we need to bring
> > dirty data inode tracking back into XFS.
> >
> > So what we really need is writeback infrastructure that is:
> >
> > 	a) independent of the dirty inode lists
> > 	b) implements background, periodic and immediate writeback
> > 	c) can be driven by BDI or superblock
> >
> > IOWs, the abstraction we need for this writeback callout is not at
> > the writeback_sb_inodes() layer, it's above the dirty inode list
> > queuing layer. IOWs, the callout needs to be closer to the
> > wb_do_writeback() layer which drives all the writeback work
> > including periodic and background writeback, and the interactions
> > between foreground and background work that wb_writeback() uses
> > needs to be turned into a bunch of helpers...
> 
> I agree, and that is what Tux3 really wants. I just wonder about the
> wisdom of embarking on a big change to fs-writeback when a small
> change will do. How will fs-writeback balancing between different
> filesystems on the same device work? What will those helpers look
> like? How long will it take to prove the new scheme stable? How can
> we prove that no existing fs-writeback clients will regress?

If the filesystem doesn't provide a callout, then the existing
writeback code runs. So for everything but tux3, there is no change
in behaviour. For tux3, you don't have to care about such
interactions while you are developing it. IOWs, we don't have to
solve every problem immediately but we get the hooks in the right
place and clean up and sanitise the locking and writeback
infrastructure at the same time.

> What about a sporting proposal: you post a patch that trumps ours in
> elegance, that you could in theory use for XFS. We verify that it
> works for Tux3 at least as well as the current patch. We also test
> it for you.

Sorry, the world doesn't work that way. I have other work to do, and
the onus on getting new code into the tree is on the people who need
it, not the people who are reviewing the code.

> >> This is not cast in stone, but it smells
> >> like decent factoring. We can save some spinlocks by violating
> >> that factoring (as Hirofumi's original hack did) at the cost of
> >> holding a potentially busy wb lock longer, which does not seem
> >> like a good trade.
> > If we abstract at a higher layer, the wb lock protects just the work
> > queuing and dispatch, and everything else can be done by the
> > superblock callout. If the superblock callout is missing, then
> > we simply fall down to the existing wb_writeback() code that retakes
> > the lock and does it's work....
> >
> > Let's get the layering and abstraction in the right place the first
> > time, rather having to revist this in the not-to-distant future.
> >
> 
> That would be ideal, but incremental also has its attractions. In that
> vein, here is a rewrite along the lines you suggested yesterday.

Sure, but that assumes the hook is in the correct place, which with
the information you gave today tells me it isn't. So polishing the
original patch isn't the solution. Driving the hook up the stack
seems to me like the better approach.

> - * Passed into wb_writeback(), essentially a subset of writeback_control
> - */
> -struct wb_writeback_work {
> -    long nr_pages;
> -    struct super_block *sb;
> -    unsigned long *older_than_this;

Something is mangling tabs to 4 spaces in your patches.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

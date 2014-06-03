Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718AbaFCOFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:05:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073AbaFCOFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:05:37 -0400
Date: Tue, 3 Jun 2014 16:05:31 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Daniel Phillips <daniel@phunq.net>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [RFC][PATCH 1/2] Add a super operation for writeback
Message-ID: <20140603140531.GB30706@quack.suse.cz>
References: <538B9DEE.20800@phunq.net>
 <20140602031526.GS14410@dastard>
 <538CD855.90804@phunq.net>
 <20140603033322.GA14410@dastard>
 <538D72B7.3010700@phunq.net>
 <20140603075209.GD14410@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603075209.GD14410@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 03-06-14 17:52:09, Dave Chinner wrote:
> On Tue, Jun 03, 2014 at 12:01:11AM -0700, Daniel Phillips wrote:
> > > However, we already avoid the VFS writeback lists for certain
> > > filesystems for pure metadata. e.g. XFS does not use the VFS dirty
> > > inode lists for inode metadata changes.  They get tracked internally
> > > by the transaction subsystem which does it's own writeback according
> > > to the requirements of journal space availability.
> > >
> > > This is done simply by not calling mark_inode_dirty() on any
> > > metadata only change. If we want to do the same for data, then we'd
> > > simply not call mark_inode_dirty() in the data IO path. That
> > > requires a custom ->set_page_dirty method to be provided by the
> > > filesystem that didn't call
> > >
> > > 	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> > >
> > > and instead did it's own thing.
> > >
> > > So the per-superblock dirty tracking is something we can do right
> > > now, and some filesystems do it for metadata. The missing piece for
> > > data is writeback infrastructure capable of deferring to superblocks
> > > for writeback rather than BDIs....
> > 
> > We agree that fs-writeback inode lists are broken for anything
> > more sophisticated than Ext2.
> 
> No, I did not say that.
> 
> I said XFS does something different for metadata changes because it
> has different flushing constraints and requirements than the generic
> code provides. That does not make the generic code broken.
> 
> > An advantage of the patch under
> > consideration is that it still lets fs-writeback mostly work the
> > way it has worked for the last few years, except for not allowing it
> > to pick specific inodes and data pages for writeout. As far as I
> > can see, it still balances writeout between different filesystems
> > on the same block device pretty well.
> 
> Not really. If there are 3 superblocks on a BDI, and the dirty inode
> list iterates between 2 of them with lots of dirty inodes, it can
> starve writeback from the third until one of it's dirty inodes pops
> to the head of the b_io list. So it's inherently unfair from that
> perspective.
> 
> Changing the high level flushing to be per-superblock rather than
> per-BDI would enable us to control that behaviour and be much fairer
> to all the superblocks on a given BDI. That said, I don't really
> care that much about this case...
So we currently flush inodes in first dirtied first written back order when
superblock is not specified in writeback work. That completely ignores the
fact to which superblock inode belongs but I don't see per-sb fairness to
actually make any sense when
1) flushing old data (to keep promise set in dirty_expire_centisecs)
2) flushing data to reduce number of dirty pages
And these are really the only two cases where we don't do per-sb flushing.

Now when filesystems want to do something more clever (and I can see
reasons for that e.g. when journalling metadata, even more so when
journalling data) I agree we need to somehow implement the above two types
of writeback using per-sb flushing. Type 1) is actually pretty easy - just
tell each sb to writeback dirty data upto time T. Type 2) is more difficult
because that is more openended task - it seems similar to what shrinkers do
but that would require us to track per sb amount of dirty pages / inodes
and I'm not sure we want to add even more page counting statistics...
Especially since often bdi == fs. Thoughts?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

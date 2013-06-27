Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab3F0Jku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:40:50 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:7305 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752168Ab3F0Jks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:40:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AroPAGAHzFF5LKwQ/2dsb2JhbABbgwm6WIUgBAF8F3SCIwEBBScTHCMQCAMYCSUPBSUDIROIDbo7Fo18JoEdB4NjA5dEih+HJ4MjKg
Date: Thu, 27 Jun 2013 19:40:42 +1000
From: Dave Chinner <david@fromorbit.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tux3@tux3.org
Subject: Re: [PATCH] Optimize wait_sb_inodes()
Message-ID: <20130627094042.GZ29338@dastard>
References: <87ehbpntuk.fsf@devron.myhome.or.jp>
 <20130626231143.GC28426@dastard>
 <87wqpg76ls.fsf@devron.myhome.or.jp>
 <20130627044705.GB29790@dastard>
 <87y59w5dye.fsf@devron.myhome.or.jp>
 <20130627063816.GD29790@dastard>
 <87ppv83tnn.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppv83tnn.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 04:22:04PM +0900, OGAWA Hirofumi wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> >> Otherwise, vfs can't know the data is whether after sync point or before
> >> sync point, and have to wait or not. FS is using the behavior like
> >> data=journal has tracking of those already, and can reuse it.
> >
> > The VFS writeback code already differentiates between data written
> > during a sync operation and that dirtied after a sync operation.
> > Perhaps you should look at the tagging for WB_SYNC_ALL writeback
> > that write_cache_pages does....
> >
> > But, anyway, we don't have to do that on the waiting side of things.
> > All we need to do is add the inode to a "under IO" list on the bdi
> > when the mapping is initially tagged with pages under writeback,
> > and remove it from that list during IO completion when the mapping
> > is no longer tagged as having pages under writeback.
> >
> > wait_sb_inodes() just needs to walk that list and wait on each inode
> > to complete IO. It doesn't require *any awareness* of the underlying
> > filesystem implementation or how the IO is actually issued - if
> > there's IO in progress at the time wait_sb_inodes() is called, then
> > it waits for it.
> >
> >> > Fix the root cause of the problem - the sub-optimal VFS code.
> >> > Hacking around it specifically for out-of-tree code is not the way
> >> > things get done around here...
> >> 
> >> I'm thinking the root cause is vfs can't have knowledge of FS internal,
> >> e.g. FS is handling data transactional way, or not.
> >
> > If the filesystem has transactional data/metadata that the VFS is
> > not tracking, then that is what the ->sync_fs call is for. i.e. so
> > the filesystem can then do what ever extra writeback/waiting it
> > needs to do that the VFS is unaware of.
> >
> > We already cater for what Tux3 needs in the VFS - all you've done is
> > found an inefficient algorithm that needs fixing.
> 
> write_cache_pages() is library function to be called from per-FS. So, it
> is not under vfs control can be assume already. And it doesn't do right
> things via write_cache_pages() for data=journal, because it handles for
> each inodes, not at once. So, new dirty data can be inserted while
> marking.

Sure it can. But that newly dirtied data has occurred after the data
integrity writeback call was begun, so it's not part of what the
writeback code call needs to write back. We are quite entitled to
ignore it for the purposes of a data integrity sync because it as
dirtied *after* write_cache_pages() was asked to sync the range of
the inode.

IOWs, the VFS draws a line in the sand at a point in time when each
inode is written for a data integrity sync. You have to do that
somewhere, and there's little point in making that a global barrier
when it is not necessary to do so.

tux3 draws a different line in the sand, as does ext3/4
data=journal.  In effect, tux3 and ext3/4 data=journal define a
global point in time that everything is "in sync", and that's way
above what is necessary for a sync(2) operation.  The VFS already
has equivalent functionality - it's the state we force filesystems
into when they are frozen. i.e. freezing a filesystem forces it down
into a state where it is transactionally consistent on disk w.r.t
both data and metadata.  sync(2) does not require these
"transactionally consistent" semantics, so the VFS does not try to
provide them.

Anyway, this is a moot discussion. I've already got prototype code
that fixes the wait_sb_inodes() problem as somebody is having
problems with many concurrent executions of wait_sb_inodes() causing
severe lock contention...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

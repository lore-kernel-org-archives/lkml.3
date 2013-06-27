Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab3F0Gi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 02:38:26 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:14394 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751003Ab3F0GiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 02:38:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArsPAO7cy1F5LKwQ/2dsb2JhbABbgwm6VIUgBAF8F3SCIwEBBAEnExwjBQsIAxgJJQ8FJQMhE4gIBboXFo4igR0HgwJhA5dEih+HJ4MjKg
Date: Thu, 27 Jun 2013 16:38:16 +1000
From: Dave Chinner <david@fromorbit.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tux3@tux3.org
Subject: Re: [PATCH] Optimize wait_sb_inodes()
Message-ID: <20130627063816.GD29790@dastard>
References: <87ehbpntuk.fsf@devron.myhome.or.jp>
 <20130626231143.GC28426@dastard>
 <87wqpg76ls.fsf@devron.myhome.or.jp>
 <20130627044705.GB29790@dastard>
 <87y59w5dye.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y59w5dye.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 02:18:17PM +0900, OGAWA Hirofumi wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> >> Optimizing wait_sb_inodes() might help lock contention, but it doesn't
> >> help unnecessary wait/check.
> >
> > You have your own wait code, that doesn't make what the VFS does
> > unnecesary. Quite frankly, I don't trust individual filesystems to
> > get it right - there's a long history of filesystem specific data
> > sync problems (including in XFS), and the best way to avoid that is
> > to ensure the VFS gets it right for you.
> >
> > Indeed, we've gone from having sooper special secret sauce data sync
> > code in XFS to using the VFS over the past few years, and the result
> > is that it is now more reliable and faster than when we were trying
> > to be smart and do it all ourselves. We got to where we are by
> > fixing the problems in the VFS rather than continuing to try to work
> > around them.
> 
> I guess you are assuming FS which is using data=writeback or such.

No, I'm not asumming anything about the filesystem. Indeed, many
filesystems don't work like ext4 data=writeback/ordered, and to
assume that they do at the VFS level is completely wrong.

I'm saying that the VFS - which is tracking all the inodes with
dirty data, and is starting IO on them - needs to also provide
correct and efficient "wait for all inodes under IO" behaviour. it
currently provides "correct", but it's not efficient.

> 
> >> Since some FSes know about current
> >> in-flight I/O already in those internal, so I think, those FSes can be
> >> done it here, or are already doing in ->sync_fs().
> >
> > Sure, do your internal checks in ->sync_fs(), but if
> > wait_sb_inodes() does not have any lock contention and very little
> > overhead, then why do you need to avoid it? This wait has to be done
> > somewhere between sync_inodes_sb() dispatching all the IO and
> > ->sync_fs completing, so what's the problem with hving the VFS do
> > that *for everyone* efficiently?
> 
> Are you saying the vfs should track all in-flight I/O with some sort of
> transactional way?

The VFs doesn't need to know a thing about filesystem transactions.

> Otherwise, vfs can't know the data is whether after sync point or before
> sync point, and have to wait or not. FS is using the behavior like
> data=journal has tracking of those already, and can reuse it.

The VFS writeback code already differentiates between data written
during a sync operation and that dirtied after a sync operation.
Perhaps you should look at the tagging for WB_SYNC_ALL writeback
that write_cache_pages does....

But, anyway, we don't have to do that on the waiting side of things.
All we need to do is add the inode to a "under IO" list on the bdi
when the mapping is initially tagged with pages under writeback,
and remove it from that list during IO completion when the mapping
is no longer tagged as having pages under writeback.

wait_sb_inodes() just needs to walk that list and wait on each inode
to complete IO. It doesn't require *any awareness* of the underlying
filesystem implementation or how the IO is actually issued - if
there's IO in progress at the time wait_sb_inodes() is called, then
it waits for it.

> > Fix the root cause of the problem - the sub-optimal VFS code.
> > Hacking around it specifically for out-of-tree code is not the way
> > things get done around here...
> 
> I'm thinking the root cause is vfs can't have knowledge of FS internal,
> e.g. FS is handling data transactional way, or not.

If the filesystem has transactional data/metadata that the VFS is
not tracking, then that is what the ->sync_fs call is for. i.e. so
the filesystem can then do what ever extra writeback/waiting it
needs to do that the VFS is unaware of.

We already cater for what Tux3 needs in the VFS - all you've done is
found an inefficient algorithm that needs fixing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

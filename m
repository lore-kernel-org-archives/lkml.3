Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab3LSEI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 23:08:28 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:18199 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852Ab3LSEI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 23:08:26 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmIHADdwslJ5LHyk/2dsb2JhbABZgwu0ToVdgRQXdIIlAQEBAwEnExwjBQsIAw4KCSUPBSUDIROHfAfKUBcWjnwHhDYElDODYpIVgz8o
Date: Thu, 19 Dec 2013 15:08:21 +1100
From: Dave Chinner <david@fromorbit.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        tomaz.solc@tablix.org, aaron.lu@intel.com,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: Writeback threads and freezable
Message-ID: <20131219040821.GW31386@dastard>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131214015343.GP31386@dastard>
 <20131214202324.GA4020@htj.dyndns.org>
 <20131216035652.GY31386@dastard>
 <20131216125124.GC32509@htj.dyndns.org>
 <20131216125604.GD32509@htj.dyndns.org>
 <20131218003510.GD20579@dastard>
 <20131218114343.GA4324@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218114343.GA4324@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 06:43:43AM -0500, Tejun Heo wrote:
> Hello, Dave.
> 
> On Wed, Dec 18, 2013 at 11:35:10AM +1100, Dave Chinner wrote:
> > Perhaps the function "invalidate_partition()" is badly named. To
> > state the obvious, fsync != invalidation. What it does is:
> > 
> > 	1. sync filesystem
> > 	2. shrink the dcache
> > 	3. invalidates inodes and kills dirty inodes
> > 	4. invalidates block device (removes cached bdev pages)
> > 
> > Basically, the first step is "flush", the remainder is "invalidate".
> > 
> > Indeed, step 3 throws away dirty inodes, so why on earth would we
> > even bother with step 1 to try to clean them in the first place?
> > IOWs, the flush is irrelevant in the hot-unplug case as it will
> > fail to flush stuff, and then we just throw the stuff we
> > failed to write away.
> >
> > But in attempting to flush all the dirty data and metadata, we can
> > cause all sorts of other potential re-entrancy based deadlocks due
> > to attempting to issue IO. Whether they be freezer based or through
> > IO error handling triggering device removal or some other means, it
> > is irrelevant - it is the flush that causes all the problems.
> 
> Isn't the root cause there hotunplug reentering anything above it in
> the first place.  The problem with your proposal is that filesystem
> isn't the only place where this could happen.  Even with no filesystem
> involved, block device could still be dirty and IOs pending in
> whatever form - dirty bdi, bios queued in dm, requests queued in
> request_queue, whatever really - and if the hotunplug path reenters
> any of the higher layers in a way which blocks IO processing, it will
> deadlock.

Entirely possible.

> If knowing that the underlying device has gone away somehow helps
> filesystem, maybe we can expose that interface and avoid flushing
> after hotunplug but that merely hides the possible deadlock scenario
> that you're concerned about.  Nothing is really solved.

Except that a user of the block device has been informed that it is
now gone and has been freed from under it. i.e. we can *immediately*
inform the user that their mounted filesystem is now stuffed and
supress all the errors that are going to occur as a result of
sync_filesystem() triggering IO failures all over the place and then
having to react to that.i

Indeed, there is no guarantee that sync_filesystem will result in
the filesystem being shut down - if the filesystem is clean then
nothing will happen, and it won't be until the user modifies some
metadata that a shutdown will be triggered. That could be a long
time after the device has been removed....

> We can try to do the same thing at each layer and implement quick exit
> path for hot unplug all the way down to the driver but that kinda
> sounds complex and fragile to me.  It's a lot larger surface to cover
> when the root cause is hotunplug allowed to reenter anything at all
> from IO path.  This is especially true because hotunplug can trivially
> be made fully asynchronous in most cases.  In terms of destruction of
> higher level objects, warm and hot unplugs can and should behave
> identical.

I don't see that there is a difference between a warm and hot unplug
from a filesystem point of view - both result in the filesystem's
backing device being deleted and freed, and in both cases we have to
take the same action....

> > We need to either get rid of the flush on device failure/hot-unplug,
> > or turn it into a callout for the superblock to take an appropriate
> > action (e.g. shutting down the filesystem) rather than trying to
> > issue IO. i.e. allow the filesystem to take appropriate action of
> > shutting down the filesystem and invalidating it's caches.
> 
> There could be cases where some optimizations for hot unplug could be
> useful.  Maybe suppressing pointless duplicate warning messages or
> whatnot but I'm highly doubtful anything will be actually fixed that
> way.  We'll be most likely making bugs just less reproducible.
> 
> > Indeed, in XFS there's several other caches that could contain dirty
> > metadata that isn't invalidated by invalidate_partition(), and so
> > unless the filesystem is shut down it can continue to try to issue
> > IO on those buffers to the removed device until the filesystem is
> > shutdown or unmounted.
> 
> Do you mean xfs never gives up after IO failures?

There's this thing called a transient IO failure which we have to
handle. e.g multipath taking several minutes to detect a path
failure and fail over, whilst in the mean time IO errors are
reported after a 30s timeout. So some types of async metadata write
IO failures are simply rescheduled for a short time in the future.
They'll either succeed, or continual failure will eventually trigger
some kind of filesystem failure.

If it's a synchronous write or a write that we cannot tolerate even
transient errors on (e.g. journal writes), then we'll shut down the
filesystem immediately.

> > Seriously, Tejun, the assumption that invalidate_partition() knows
> > enough about filesystems to safely "invalidate" them is just broken.
> > These days, filesystems often reference multiple block devices, and
> > so the way hotplug currently treats them as "one device, one
> > filesystem" is also fundamentally wrong.
> > 
> > So there's many ways in which the hot-unplug code is broken in it's
> > use of invalidate_partition(), the least of which is the
> > dependencies caused by re-entrancy. We really need a
> > "sb->shutdown()" style callout as step one in the above process, not
> > fsync_bdev().
> 
> If filesystems need an indication that the underlying device is no
> longer functional, please go ahead and add it, but please keep in mind
> all these are completely asynchronous.  Nothing guarantees you that
> such events would happen in any specific order.  IOW, you can be at
> *ANY* point in your warm unplug path and the device is hot unplugged,
> which essentially forces all the code paths to be ready for the worst,
> and that's exactly why there isn't much effort in trying to separate
> out warm and hot unplug paths.

I'm not concerned about the problems that might happen if you hot
unplug during a warm unplug. All I care about is when a device is
invalidated the filesystem on top of it can take appropriate action.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

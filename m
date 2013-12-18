Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab3LRLnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 06:43:50 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:62534 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab3LRLns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 06:43:48 -0500
Date: Wed, 18 Dec 2013 06:43:43 -0500
From: Tejun Heo <tj@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        tomaz.solc@tablix.org, aaron.lu@intel.com,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: Writeback threads and freezable
Message-ID: <20131218114343.GA4324@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131214015343.GP31386@dastard>
 <20131214202324.GA4020@htj.dyndns.org>
 <20131216035652.GY31386@dastard>
 <20131216125124.GC32509@htj.dyndns.org>
 <20131216125604.GD32509@htj.dyndns.org>
 <20131218003510.GD20579@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218003510.GD20579@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dave.

On Wed, Dec 18, 2013 at 11:35:10AM +1100, Dave Chinner wrote:
> Sure I understand the problem. Part of that dependency loop is
> caused by filesystem re-entrancy from the hot unplug code.
> Regardless of this /specific freezer problem/, that filesystem
> re-entrancy path is *never OK* during a hot-unplug event and it
> needs to be fixed.

I don't think you do.  The only relation between the two problems is
that they're traveling the same code path.  Again, the deadlock can be
triggered *the same* with warm unplug && it *doesn't* need writeback
or jbd - we can deadlock with any freezables and we have drivers which
use freezables in IO issue path.

I don't really mind the discussion branching off to a related topic
but you've been consistently misunderstanding the issue at hand and
derailing the larger discussion.  If you want to discuss the issue
that you brought up, that's completely fine but *PLEASE* stop getting
confused and mixing up the two.

> Perhaps the function "invalidate_partition()" is badly named. To
> state the obvious, fsync != invalidation. What it does is:
> 
> 	1. sync filesystem
> 	2. shrink the dcache
> 	3. invalidates inodes and kills dirty inodes
> 	4. invalidates block device (removes cached bdev pages)
> 
> Basically, the first step is "flush", the remainder is "invalidate".
> 
> Indeed, step 3 throws away dirty inodes, so why on earth would we
> even bother with step 1 to try to clean them in the first place?
> IOWs, the flush is irrelevant in the hot-unplug case as it will
> fail to flush stuff, and then we just throw the stuff we
> failed to write away.
>
> But in attempting to flush all the dirty data and metadata, we can
> cause all sorts of other potential re-entrancy based deadlocks due
> to attempting to issue IO. Whether they be freezer based or through
> IO error handling triggering device removal or some other means, it
> is irrelevant - it is the flush that causes all the problems.

Isn't the root cause there hotunplug reentering anything above it in
the first place.  The problem with your proposal is that filesystem
isn't the only place where this could happen.  Even with no filesystem
involved, block device could still be dirty and IOs pending in
whatever form - dirty bdi, bios queued in dm, requests queued in
request_queue, whatever really - and if the hotunplug path reenters
any of the higher layers in a way which blocks IO processing, it will
deadlock.

If knowing that the underlying device has gone away somehow helps
filesystem, maybe we can expose that interface and avoid flushing
after hotunplug but that merely hides the possible deadlock scenario
that you're concerned about.  Nothing is really solved.

We can try to do the same thing at each layer and implement quick exit
path for hot unplug all the way down to the driver but that kinda
sounds complex and fragile to me.  It's a lot larger surface to cover
when the root cause is hotunplug allowed to reenter anything at all
from IO path.  This is especially true because hotunplug can trivially
be made fully asynchronous in most cases.  In terms of destruction of
higher level objects, warm and hot unplugs can and should behave
identical.

In fact, it isn't possible to draw a strict line between warm and hot
unplugs - what if the device gets detached while warm unplug is in
progress?  We'd be already traveling warm unplug path when the
operating condition becomes identical to hot unplug.

> We need to either get rid of the flush on device failure/hot-unplug,
> or turn it into a callout for the superblock to take an appropriate
> action (e.g. shutting down the filesystem) rather than trying to
> issue IO. i.e. allow the filesystem to take appropriate action of
> shutting down the filesystem and invalidating it's caches.

There could be cases where some optimizations for hot unplug could be
useful.  Maybe suppressing pointless duplicate warning messages or
whatnot but I'm highly doubtful anything will be actually fixed that
way.  We'll be most likely making bugs just less reproducible.

> Indeed, in XFS there's several other caches that could contain dirty
> metadata that isn't invalidated by invalidate_partition(), and so
> unless the filesystem is shut down it can continue to try to issue
> IO on those buffers to the removed device until the filesystem is
> shutdown or unmounted.

Do you mean xfs never gives up after IO failures?

> Seriously, Tejun, the assumption that invalidate_partition() knows
> enough about filesystems to safely "invalidate" them is just broken.
> These days, filesystems often reference multiple block devices, and
> so the way hotplug currently treats them as "one device, one
> filesystem" is also fundamentally wrong.
> 
> So there's many ways in which the hot-unplug code is broken in it's
> use of invalidate_partition(), the least of which is the
> dependencies caused by re-entrancy. We really need a
> "sb->shutdown()" style callout as step one in the above process, not
> fsync_bdev().

If filesystems need an indication that the underlying device is no
longer functional, please go ahead and add it, but please keep in mind
all these are completely asynchronous.  Nothing guarantees you that
such events would happen in any specific order.  IOW, you can be at
*ANY* point in your warm unplug path and the device is hot unplugged,
which essentially forces all the code paths to be ready for the worst,
and that's exactly why there isn't much effort in trying to separate
out warm and hot unplug paths.

Thanks.

-- 
tejun

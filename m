Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab3LRAfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 19:35:50 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:13551 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810Ab3LRAft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 19:35:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMIAPbssFJ5LHyk/2dsb2JhbABZgwqDPLBthVCBHxd0giUBAQEEJxMcIxAIAw4KCSUPBSUDIROIA8llFxaOfAeDI4ETBJgVkhWDPyiBLCM
Date: Wed, 18 Dec 2013 11:35:10 +1100
From: Dave Chinner <david@fromorbit.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        tomaz.solc@tablix.org, aaron.lu@intel.com,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: Writeback threads and freezable
Message-ID: <20131218003510.GD20579@dastard>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131214015343.GP31386@dastard>
 <20131214202324.GA4020@htj.dyndns.org>
 <20131216035652.GY31386@dastard>
 <20131216125124.GC32509@htj.dyndns.org>
 <20131216125604.GD32509@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216125604.GD32509@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 07:56:04AM -0500, Tejun Heo wrote:
> On Mon, Dec 16, 2013 at 07:51:24AM -0500, Tejun Heo wrote:
> > On Mon, Dec 16, 2013 at 02:56:52PM +1100, Dave Chinner wrote:
> > > > What are you suggesting?  Implementing separate warm and hot unplug
> > > > paths?  That makes no sense whatsoever.  Device hot unplug is just a
> > > > sub operation of general device unplug which should be able to succeed
> > > > whether the underlying device is failing IOs or not.
> > > 
> > > I don't care. Trying to issue IO from an an IO error handling path
> > > where the device has just been removed is fundamentally broken.
> > 
> > What?  Have you even read the original message?  IO error handling
> > path isn't issuing the IO here.  The hot unplug operation is
> > completely asynchronous to the IO path.  What's dead locking is not
> > the filesystem and IO path but device driver layer and hot unplug
> > path.  IOs are not stalled.
> 
> In fact, this deadlock can be reproduced without hotunplug at all.  If
> you initiate warm unplug and warm unplugging races with suspend/resume
> cycle, it'll behave exactly the same - the IOs from flushing in that
> scenario would succeed but IOs failing or not has *NOTHING* to do with
> this deadlock.  It'd still happen.  It's freezer behaving as a giant
> lock and other locks of course getting dragged into giant dependency
> loop.  Can you please at least *try* to understand what's going on
> before throwing strong assertions?

Sure I understand the problem. Part of that dependency loop is
caused by filesystem re-entrancy from the hot unplug code.
Regardless of this /specific freezer problem/, that filesystem
re-entrancy path is *never OK* during a hot-unplug event and it
needs to be fixed.

Perhaps the function "invalidate_partition()" is badly named. To
state the obvious, fsync != invalidation. What it does is:

	1. sync filesystem
	2. shrink the dcache
	3. invalidates inodes and kills dirty inodes
	4. invalidates block device (removes cached bdev pages)

Basically, the first step is "flush", the remainder is "invalidate".

Indeed, step 3 throws away dirty inodes, so why on earth would we
even bother with step 1 to try to clean them in the first place?
IOWs, the flush is irrelevant in the hot-unplug case as it will
fail to flush stuff, and then we just throw the stuff we
failed to write away.

But in attempting to flush all the dirty data and metadata, we can
cause all sorts of other potential re-entrancy based deadlocks due
to attempting to issue IO. Whether they be freezer based or through
IO error handling triggering device removal or some other means, it
is irrelevant - it is the flush that causes all the problems.

We need to either get rid of the flush on device failure/hot-unplug,
or turn it into a callout for the superblock to take an appropriate
action (e.g. shutting down the filesystem) rather than trying to
issue IO. i.e. allow the filesystem to take appropriate action of
shutting down the filesystem and invalidating it's caches.

Indeed, in XFS there's several other caches that could contain dirty
metadata that isn't invalidated by invalidate_partition(), and so
unless the filesystem is shut down it can continue to try to issue
IO on those buffers to the removed device until the filesystem is
shutdown or unmounted.

Seriously, Tejun, the assumption that invalidate_partition() knows
enough about filesystems to safely "invalidate" them is just broken.
These days, filesystems often reference multiple block devices, and
so the way hotplug currently treats them as "one device, one
filesystem" is also fundamentally wrong.

So there's many ways in which the hot-unplug code is broken in it's
use of invalidate_partition(), the least of which is the
dependencies caused by re-entrancy. We really need a
"sb->shutdown()" style callout as step one in the above process, not
fsync_bdev().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

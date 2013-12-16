Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab3LPD45 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 22:56:57 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:45590 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752260Ab3LPD44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 22:56:56 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlsIAIJ5rlJ5LHyk/2dsb2JhbABZgwqDPLBmhU+BGxd0giUBAQQBOhwjBQsIAw4KCSUPBSUDIROHfAfHNhcWjwMHhDYEmBWSFYM+KA
Date: Mon, 16 Dec 2013 14:56:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        tomaz.solc@tablix.org, aaron.lu@intel.com,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: Writeback threads and freezable
Message-ID: <20131216035652.GY31386@dastard>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131214015343.GP31386@dastard>
 <20131214202324.GA4020@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131214202324.GA4020@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 03:23:24PM -0500, Tejun Heo wrote:
> Hello, Dave.
> 
> On Sat, Dec 14, 2013 at 12:53:43PM +1100, Dave Chinner wrote:
> > That's the fundamental problem here - device removal asks the device
> > to fsync the filesystem on top of the device that was just removed.
> > The simple way to trigger this is to pull a device from underneath
> > an active filesystem (e.g. user unplugs a USB device without first
> > unmounting it). There are many years worth of bug reports showing
> > that this attempt by the device removal code to sync the filesystem
> > leads to deadlocks.
> 
> What are you suggesting?  Implementing separate warm and hot unplug
> paths?  That makes no sense whatsoever.  Device hot unplug is just a
> sub operation of general device unplug which should be able to succeed
> whether the underlying device is failing IOs or not.

I don't care. Trying to issue IO from an an IO error handling path
where the device has just been removed is fundamentally broken.

> Another thing to consider is that you want to excercise your error
> handling path as often as possible.  IOs could still fail even during
> device warm unplugs.  If anything atop the driver can't handle that,
> that's a bug and we want to fix them.  The fact that we have bug
> reports going back years on the subject simply means that we've been
> traditionally lousy with error handling throughout the layers - those
> were the occassions where we fixed actual error handling bugs, hot
> unplug or not.  Special casing hot unplug would just make existing
> error handling bugs more difficult to find.

This has nothing to do with existing filesystem error handling paths.
We get plenty of testing of them without having to pull devices out
of machines. Why do you think we have stuff like dm-flakey or forced
shutdown ioctls for XFS?

Indeed, what I'm asking for is for a notification so that we can
*shut the filesystem down* straight away, rather than have to wait
for an IO error in a critical metadata structure to trigger the
shutdown for us.

> > It's simply not a valid thing to do - just how is the filesystem
> > supposed to sync to a non-existent device?
> 
> By issuing all IOs and then handling the failures appropriately.

Which bit of "filesystem might deadlock trying to issue IO" didn't
you understand?

> Exactly just as it would handle *ANY* io errors.  This actually is the
> simplest thing to do to drain the pipe - pushing things down all the
> way and fail them at single point.  What's the alternative?  Implement
> quick exit path at each layer?  That's just silly and error-prone.
> 
> > I've raised this each time a user reports it over the past few years
> > and never been able to convince any to fix the filesystem
> > re-entrancy problem device removal causes. Syncing the filesystem
> 
> Well, it isn't a good idea.
> 
> > will require taking locks that are by IO in progress, and so can't
> > make progress until the IO is completed, but that can't happen
> > until the error handling completes the sync of the filesystem....
> 
> IOs in progress shouldn't ever be stalled by filesystem sync.  That's
> a massive layering violation.  Where and how does that happen?

IOs in progress get stalled by IO error handling.

Then IO error handling tries to issue more IO via fsync_bdev().

The the filesystem tries to look a metadata buffer that is still
under IO (i.e. in error handling) and stalls.

That's the problem here - IO error handling is re-entering the the
filesystem inappropriately.

If you have to invalidate the device due to errors, fsync_bdev() is
not the function to call. That's for *flushing* the filesystem. A
shutdown is the only sane thing for an active filesystem to do when
the device underneath it has been invalidated.

Really, it gets worse - the block device is deleted and freed from
the system while the filesystem on top of it still has an open
reference to it. Why do you think we have all that nasty default BDI
crap in the writeback path, Tejun? it's because the disk hot-unplug
paths free the bdi the filesystem is using out from underneath it.

What the hell happened to the usual rule of "don't free objects until
the last user goes away? What makes the error handling paths of the
layers below the filesystem not subject to common sense?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

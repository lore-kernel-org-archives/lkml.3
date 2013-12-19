Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab3LSQYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:24:20 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:35540 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab3LSQYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:24:18 -0500
Date: Thu, 19 Dec 2013 11:24:11 -0500
From: Tejun Heo <tj@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        tomaz.solc@tablix.org, aaron.lu@intel.com,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: Writeback threads and freezable
Message-ID: <20131219162411.GD16994@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131214015343.GP31386@dastard>
 <20131214202324.GA4020@htj.dyndns.org>
 <20131216035652.GY31386@dastard>
 <20131216125124.GC32509@htj.dyndns.org>
 <20131216125604.GD32509@htj.dyndns.org>
 <20131218003510.GD20579@dastard>
 <20131218114343.GA4324@htj.dyndns.org>
 <20131219040821.GW31386@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219040821.GW31386@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yo, Dave.

On Thu, Dec 19, 2013 at 03:08:21PM +1100, Dave Chinner wrote:
> > If knowing that the underlying device has gone away somehow helps
> > filesystem, maybe we can expose that interface and avoid flushing
> > after hotunplug but that merely hides the possible deadlock scenario
> > that you're concerned about.  Nothing is really solved.
> 
> Except that a user of the block device has been informed that it is
> now gone and has been freed from under it. i.e. we can *immediately*
> inform the user that their mounted filesystem is now stuffed and
> supress all the errors that are going to occur as a result of
> sync_filesystem() triggering IO failures all over the place and then
> having to react to that.i

Please note that there's no real "immediacy" in that it's inherently
racy and that the extent of the usefulness of such notification can't
reach much further than suppressing error messages.  Even that benefit
is kinda dubious.  Don't we want to generate errors when a device is
removed while dirty data / IOs are pending on it?  I fail to see how
"supressing all the errors" would be a sane thing to do.

Another thing is that I think it's actually healthier in terms of
excercise of code paths to travel those error paths on hot unplugs
which are relatively common than taking a different behavior on them.
It'll inevitably lower our test coverage.

> Indeed, there is no guarantee that sync_filesystem will result in
> the filesystem being shut down - if the filesystem is clean then
> nothing will happen, and it won't be until the user modifies some
> metadata that a shutdown will be triggered. That could be a long
> time after the device has been removed....

I still fail to see that why that is a problem.  Filesystems should be
able to handle hot unplug or IO failures at any point in a reasonable
way, so what difference would having a notification make other than
introducing yet another exception code path?

> I don't see that there is a difference between a warm and hot unplug
> from a filesystem point of view - both result in the filesystem's
> backing device being deleted and freed, and in both cases we have to
> take the same action....

Yeah, exactly, so what'd be the point of getting separate notification
for hot unplug events?

> > Do you mean xfs never gives up after IO failures?
> 
> There's this thing called a transient IO failure which we have to
> handle. e.g multipath taking several minutes to detect a path
> failure and fail over, whilst in the mean time IO errors are
> reported after a 30s timeout. So some types of async metadata write
> IO failures are simply rescheduled for a short time in the future.
> They'll either succeed, or continual failure will eventually trigger
> some kind of filesystem failure.
> 
> If it's a synchronous write or a write that we cannot tolerate even
> transient errors on (e.g. journal writes), then we'll shut down the
> filesystem immediately.

Sure, filesystems should (be able to) react to different types of
errors in different ways.  We still have a long way to go to do that
properly but that should be done through IO failures not some side
channel one-off "hotunplug" happened call.  Again, it doesn't solve
anything.  It just side steps one very specific case in a half-assed
way.

> > If filesystems need an indication that the underlying device is no
> > longer functional, please go ahead and add it, but please keep in mind
> > all these are completely asynchronous.  Nothing guarantees you that
> > such events would happen in any specific order.  IOW, you can be at
> > *ANY* point in your warm unplug path and the device is hot unplugged,
> > which essentially forces all the code paths to be ready for the worst,
> > and that's exactly why there isn't much effort in trying to separate
> > out warm and hot unplug paths.
> 
> I'm not concerned about the problems that might happen if you hot
> unplug during a warm unplug. All I care about is when a device is
> invalidated the filesystem on top of it can take appropriate action.

I can't follow your logic here.  You started with a deadlock scenario
where lower layer calls into upper layer while blocking its own
operation, which apparently is a bug to be fixed in the lower layer as
discussed above; otherwise, we'd be chasing the symptoms rather than
plugging the source.  Combined with the fact that you can't really
prevent hotunplug happening during warmunplug (it doesn't even have to
be hotunplug, there are other conditions which would match such IO
failure pattern), this reduces the benefit of such notification to
optimizations far from correctness issues.

These are all logically connected; yet, you claim that you're not
concerned about part of it and then continue to assert your original
position.  It doesn't compute.  You proposed it as a fix for a
deadlock issue, but it turns out your proposal can't fix the deadlock
issue exactly because of the part you aren't concerned about and you
continue to assert the original proposal.  What's going on here?

Thanks.

-- 
tejun

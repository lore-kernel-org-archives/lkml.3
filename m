Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030222Ab3LTNq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:46:57 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65004 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030186Ab3LTNqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:46:55 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tejun Heo <tj@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        tomaz.solc@tablix.org, aaron.lu@intel.com,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: Writeback threads and freezable
Date: Fri, 20 Dec 2013 15:00:17 +0100
Message-ID: <1560958.dtxLEj3lem@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131219162411.GD16994@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org> <20131219040821.GW31386@dastard> <20131219162411.GD16994@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 19, 2013 11:24:11 AM Tejun Heo wrote:
> Yo, Dave.
> 
> On Thu, Dec 19, 2013 at 03:08:21PM +1100, Dave Chinner wrote:
> > > If knowing that the underlying device has gone away somehow helps
> > > filesystem, maybe we can expose that interface and avoid flushing
> > > after hotunplug but that merely hides the possible deadlock scenario
> > > that you're concerned about.  Nothing is really solved.
> > 
> > Except that a user of the block device has been informed that it is
> > now gone and has been freed from under it. i.e. we can *immediately*
> > inform the user that their mounted filesystem is now stuffed and
> > supress all the errors that are going to occur as a result of
> > sync_filesystem() triggering IO failures all over the place and then
> > having to react to that.i
> 
> Please note that there's no real "immediacy" in that it's inherently
> racy and that the extent of the usefulness of such notification can't
> reach much further than suppressing error messages.  Even that benefit
> is kinda dubious.  Don't we want to generate errors when a device is
> removed while dirty data / IOs are pending on it?  I fail to see how
> "supressing all the errors" would be a sane thing to do.
> 
> Another thing is that I think it's actually healthier in terms of
> excercise of code paths to travel those error paths on hot unplugs
> which are relatively common than taking a different behavior on them.
> It'll inevitably lower our test coverage.
> 
> > Indeed, there is no guarantee that sync_filesystem will result in
> > the filesystem being shut down - if the filesystem is clean then
> > nothing will happen, and it won't be until the user modifies some
> > metadata that a shutdown will be triggered. That could be a long
> > time after the device has been removed....
> 
> I still fail to see that why that is a problem.  Filesystems should be
> able to handle hot unplug or IO failures at any point in a reasonable
> way, so what difference would having a notification make other than
> introducing yet another exception code path?
> 
> > I don't see that there is a difference between a warm and hot unplug
> > from a filesystem point of view - both result in the filesystem's
> > backing device being deleted and freed, and in both cases we have to
> > take the same action....
> 
> Yeah, exactly, so what'd be the point of getting separate notification
> for hot unplug events?
> 
> > > Do you mean xfs never gives up after IO failures?
> > 
> > There's this thing called a transient IO failure which we have to
> > handle. e.g multipath taking several minutes to detect a path
> > failure and fail over, whilst in the mean time IO errors are
> > reported after a 30s timeout. So some types of async metadata write
> > IO failures are simply rescheduled for a short time in the future.
> > They'll either succeed, or continual failure will eventually trigger
> > some kind of filesystem failure.
> > 
> > If it's a synchronous write or a write that we cannot tolerate even
> > transient errors on (e.g. journal writes), then we'll shut down the
> > filesystem immediately.
> 
> Sure, filesystems should (be able to) react to different types of
> errors in different ways.  We still have a long way to go to do that
> properly but that should be done through IO failures not some side
> channel one-off "hotunplug" happened call.  Again, it doesn't solve
> anything.  It just side steps one very specific case in a half-assed
> way.

Another problem is to distinguish "hotunplug" from "power failure", for
example, because it may not be entirely clear what happened to start with
until way after when we get a "these devices are gone" notification from the
platform firmware.

So even if something may be regarded as a "hotunplug" from the order of the
Universe perspective, it still may look like a regular IO error at the device
level until device_del() is called for that device (which may not happen for
quite a while).

[That said, there are situations in which we may want to wait until it is
"safe" to eject stuff, or even we may want to allow subsystems to fail
"offline" requests, like in the memory eject case.  In those cases the
hot-removal actually consists of two parts, an offline and a removal,
where devices are supposed to be not in use after offline (which may fail).
But that is a different story. :-)]

Thanks,
Rafael

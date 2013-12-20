Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab3LTAw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 19:52:27 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:62711 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756516Ab3LTAw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 19:52:26 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmIHAGeUs1J5LHyk/2dsb2JhbABZgwu0YIVdgRcXdIIlAQEBBDocIxAIAw4KCSUPBSUDIROIA8p9FxaOfAeDI4ETBJgVkhWDPyg
Date: Fri, 20 Dec 2013 11:51:14 +1100
From: Dave Chinner <david@fromorbit.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        tomaz.solc@tablix.org, aaron.lu@intel.com,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: Writeback threads and freezable
Message-ID: <20131220005114.GE31386@dastard>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131214015343.GP31386@dastard>
 <20131214202324.GA4020@htj.dyndns.org>
 <20131216035652.GY31386@dastard>
 <20131216125124.GC32509@htj.dyndns.org>
 <20131216125604.GD32509@htj.dyndns.org>
 <20131218003510.GD20579@dastard>
 <20131218114343.GA4324@htj.dyndns.org>
 <20131219040821.GW31386@dastard>
 <20131219162411.GD16994@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219162411.GD16994@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 11:24:11AM -0500, Tejun Heo wrote:
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
> reach much further than suppressing error messages.

So says you. What about btrfs, which might use such a notification
to start replicating metadata and data to other devices to maintain
redundancy levels? Or even XFS, which might have a real-time device
go away - that's not a fatal error for the filesystem, but we sure
as hell want the user to know about it and be able to set a flag
indicating access to data in real-time files need to be errored out
at the .aio_write level rather than some time later when writeback
fails with EIO and the application cannot capture the IO error.

Seriously, Tejun, you need to stop focussing on tearing apart
micro-examples and consider the wider context of the issue that the
examples are being used to demonstrate.  The notifications being
talked about here are already being delivered to userspace because
there are OS management applications that need to know about devices
going away. Filesystems are no different - there's all sorts of
optimisations we can make if we get such a notification.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

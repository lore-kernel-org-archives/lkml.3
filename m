Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab3LNUXa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:23:30 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:40441 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab3LNUX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:23:28 -0500
Date: Sat, 14 Dec 2013 15:23:24 -0500
From: Tejun Heo <tj@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        tomaz.solc@tablix.org, aaron.lu@intel.com,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: Writeback threads and freezable
Message-ID: <20131214202324.GA4020@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131214015343.GP31386@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131214015343.GP31386@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dave.

On Sat, Dec 14, 2013 at 12:53:43PM +1100, Dave Chinner wrote:
> That's the fundamental problem here - device removal asks the device
> to fsync the filesystem on top of the device that was just removed.
> The simple way to trigger this is to pull a device from underneath
> an active filesystem (e.g. user unplugs a USB device without first
> unmounting it). There are many years worth of bug reports showing
> that this attempt by the device removal code to sync the filesystem
> leads to deadlocks.

What are you suggesting?  Implementing separate warm and hot unplug
paths?  That makes no sense whatsoever.  Device hot unplug is just a
sub operation of general device unplug which should be able to succeed
whether the underlying device is failing IOs or not.

Another thing to consider is that you want to excercise your error
handling path as often as possible.  IOs could still fail even during
device warm unplugs.  If anything atop the driver can't handle that,
that's a bug and we want to fix them.  The fact that we have bug
reports going back years on the subject simply means that we've been
traditionally lousy with error handling throughout the layers - those
were the occassions where we fixed actual error handling bugs, hot
unplug or not.  Special casing hot unplug would just make existing
error handling bugs more difficult to find.

> It's simply not a valid thing to do - just how is the filesystem
> supposed to sync to a non-existent device?

By issuing all IOs and then handling the failures appropriately.
Exactly just as it would handle *ANY* io errors.  This actually is the
simplest thing to do to drain the pipe - pushing things down all the
way and fail them at single point.  What's the alternative?  Implement
quick exit path at each layer?  That's just silly and error-prone.

> I've raised this each time a user reports it over the past few years
> and never been able to convince any to fix the filesystem
> re-entrancy problem device removal causes. Syncing the filesystem

Well, it isn't a good idea.

> will require taking locks that are by IO in progress, and so can't
> make progress until the IO is completed, but that can't happen
> until the error handling completes the sync of the filesystem....

IOs in progress shouldn't ever be stalled by filesystem sync.  That's
a massive layering violation.  Where and how does that happen?

> Preventing fs/io re-entrancy from contexts where we might be holding
> locks is the same reason we have GFP_NOFS and GFP_NOIO for memory
> allocation: re-entering a filesystem or IO subsystem whenever we are
> holding locks or serialised context in the fs/io path can deadlock
> the fs/io path.
>
> IOWs, syncing the filesystem from the device delete code is just
> plain wrong. That's what needs fixing - removing the cause of
> re-entrancy, not the workqueue or writeback code...

No, the wrong thing there is having IO failures depending on
filesystem sync.  Nothing else.

> > Ideas?
> 
> Fix the device delete error handling not to re-enter the
> filesystem and IO path. It's just wrong.

Nope, bad idea.

Thanks.

-- 
tejun

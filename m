Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab3LNBxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 20:53:49 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:44103 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752867Ab3LNBxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 20:53:48 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMIAEW5q1J5LHyk/2dsb2JhbABSB4MKOIMEsGKFT4EhF3SCJQEBBAE6HCMFCwgDDgoJJQ8FJQMhE4d8Bw7KcwQWjjdIB4Q2BJgVkhWDPiiBLCM
Date: Sat, 14 Dec 2013 12:53:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        tomaz.solc@tablix.org, aaron.lu@intel.com,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: Writeback threads and freezable
Message-ID: <20131214015343.GP31386@dastard>
References: <20131213174932.GA27070@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213174932.GA27070@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 12:49:32PM -0500, Tejun Heo wrote:
> Hello, guys.
> 
> This is discovered while investigating bug 62801 - "EliteBoot hangs at
> dock, suspend, undock, resume".
> 
>  https://bugzilla.kernel.org/show_bug.cgi?id=62801
> 
> The laptop locks up during resume if undocked while suspended.  The
> dock contains a hard drive and the drive removal path and resume path
> get stuck.  This got bisected to 839a8e8660b6 ("writeback: replace
> custom worker pool implementation with unbound workqueue") by the
> reporter.  The problem can be reproduced by just removing mounted
> harddrive while a machine is suspended.  I first thought it was some
> dumb mistake but it turns out to be something fundamental.
> 
> So, here's the lock up.
> 
> * Resume starts and libata resume is kicked off.
> 
> * libata EH determines that the device is gone.  Eventually it invokes
>   device_del() through a work item.
> 
> * device_del() tries to delete the block device which invokes
>   writeback_inodes_sb() on the mounted filesystem which in turn
>   schedules and flushes bdi work item.  Note that at this point, the
>   kworker is holding multiple driver layer locks.

That's the fundamental problem here - device removal asks the device
to fsync the filesystem on top of the device that was just removed.
The simple way to trigger this is to pull a device from underneath
an active filesystem (e.g. user unplugs a USB device without first
unmounting it). There are many years worth of bug reports showing
that this attempt by the device removal code to sync the filesystem
leads to deadlocks.

It's simply not a valid thing to do - just how is the filesystem
supposed to sync to a non-existent device?

I've raised this each time a user reports it over the past few years
and never been able to convince any to fix the filesystem
re-entrancy problem device removal causes. Syncing the filesystem
will require taking locks that are by IO in progress, and so can't
make progress until the IO is completed, but that can't happen
until the error handling completes the sync of the filesystem....

Preventing fs/io re-entrancy from contexts where we might be holding
locks is the same reason we have GFP_NOFS and GFP_NOIO for memory
allocation: re-entering a filesystem or IO subsystem whenever we are
holding locks or serialised context in the fs/io path can deadlock
the fs/io path.

IOWs, syncing the filesystem from the device delete code is just
plain wrong. That's what needs fixing - removing the cause of
re-entrancy, not the workqueue or writeback code...

> Ideas?

Fix the device delete error handling not to re-enter the
filesystem and IO path. It's just wrong.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

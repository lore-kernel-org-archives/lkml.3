Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbaCGVcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:32:19 -0500
Received: from imap.thunk.org ([74.207.234.97]:38531 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaCGVcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:32:18 -0500
Date: Fri, 7 Mar 2014 16:32:12 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Nilesh More <nilesh99999@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Reporting a bug - Memory corruption in Linux kernel
Message-ID: <20140307213212.GA30970@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Nilesh More <nilesh99999@gmail.com>, linux-kernel@vger.kernel.org
References: <CAMbOQaUW7K=FBESVeo=BOXfYU6cuqthjnmMR6jmeNFnx8PcvuQ@mail.gmail.com>
 <CAMbOQaU-jX8Dvmjj_iQJGBhDesMyFj02epaROFfW+ae+BDg_tA@mail.gmail.com>
 <20140307040028.GA17965@thunk.org>
 <CAMbOQaUDWGBHLAjFzVSZtU3NJzu5mgcpm34g=dARADDaZB9Ryw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbOQaUDWGBHLAjFzVSZtU3NJzu5mgcpm34g=dARADDaZB9Ryw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2014 at 01:48:42AM +0530, Nilesh More wrote:
> 
> 1. When the USB is hotplugged, in the call stack of add_disk( ),
> while registering disk blkdev_get(bdev, FMODE_READ, NULL) gets called
> which I guess scans the partition table, initializes part array and
> registers the partitions in the driver model.
> 
> 2. To release the ownership of bdev obtained in step#1,
> blkdev_put(bdev, FMODE_READ) is called. This invalidates the pages
> cached for bdev in above blkdev_get call by first doing a writeback of
> these pages to disk.
> 
> 3. Now if I prevent the invalidate page call in step# 2, I see that
> ext4 file system remains intact without any correction. That suggests,
> some part of cached pages obtained in step#1 blkdev_get call is
> already being used by ext4 file system and once these pages are
> invalidated we have a corruption in ext4 file system.

Can you put in a WARN_ON(1) in blkdev_put() and blkdev_get(), so we
can see the exact call stack?  Also, can you print out the value of
the bdev->bd_dev and bdev->bd_openers at the beginning of blkdev_put()
and blkdev_get()?

I am not convinced that your analysis is correct, given the "USB
disconnect" message.  So let's see the exact call stack for the calls
to blkdev_get() and blkdev_put(), and see exactly which device is
getting obtained and released.

> My query now is, has anybody seen similar kind of issue before ? Could
> this be a known bug ?

Nothing like this before, no.  Note that the invalidate_pages() in
blkdev_put() only happens when bdev->bd_openers drops down to zero.
If the file system is mounted, then bd_openers will be one.  So even
if someone is calling blkdev_get() and blkdev_put() on the file
system, bd_openers will not drop to zero.

Also, the USB device would be a different bdev than the one for the
system disk.  So your theory simply doesn't make any sense to me.  If
you think that is really what's going on, let's put in the debugging
printk's that show exactly which device and the bd_openers count for
each call to blkdev_put() and blkdev_get(), and then let's get the
precise stack trace used when the pages get invalidated.

This pattern:

[ 413.607849] usb 2-1.1: USB disconnect, device number 12
[ 414.022630] EXT4-fs error (device mmcblk0p20): ext4_readdir:227: inode #81827: block 328308: comm installd...

is the normal thing that one would expect if someone yanks the USB
device or a SD card containing a mounted file system from the system.
Any theory of what's going that doesn't account for the "USB
disconnect" message is going to be fundamentally incomplete.


Cheers,

						- Ted

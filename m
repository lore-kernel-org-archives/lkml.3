Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbaFAAkb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 20:40:31 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:30516 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751659AbaFAAk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 20:40:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0PACp2ilN5LL1s/2dsb2JhbABZgwerVAEBAQEBAQaYGwGBBhd0giUBAQQBOhwjBQsIAxgJJQ8FJQMhE4g6B9U/FxaFP4h9B4RABJl/ixyIEoNKKw
Date: Sun, 1 Jun 2014 10:39:54 +1000
From: Dave Chinner <david@fromorbit.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Message-ID: <20140601003954.GM14410@dastard>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
 <1401480116-1973111-12-git-send-email-arnd@arndb.de>
 <20140531003712.GH14410@dastard>
 <5389252A.5050503@zytor.com>
 <20140531011450.GJ14410@dastard>
 <c7770275-61de-4e94-9586-5ee118f77ba5@email.android.com>
 <20140531055457.GK14410@dastard>
 <538995D4.9050702@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538995D4.9050702@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 01:41:56AM -0700, H. Peter Anvin wrote:
> On 05/30/2014 10:54 PM, Dave Chinner wrote:
> > 
> > If we are changing the in-kernel timestamp to have a greater dynamic
> > range that anything we current support on disk, then we need support
> > for all filesystems for similar translation and constraint. The
> > filesystems need to be able to tell the kernel what they timestamp
> > range they support, and then the kernel needs to follow those
> > guidelines. And if the filesystem is mounted on a kernel that
> > doesn't support the current filesystem's timestamp format, then at
> > minimum that filesystem cannot do anything that writes a
> > timestamp....
> > 
> > Put simply: the filesystem defines the timestamp range that can be
> > used safely, not the userspace API. If the filesystem can't support
> > the date it is handed then that is an out-of-range error. Since
> > when have we accepted that it's OK to handle out-of-range data with
> > silent overflows or corruption of the data that we are attempting to
> > store? We're defining a new API to support a wider date range -
> > there is nothing that prevents us from saying ERANGE can be returned
> > to a timestamp that the file cannot store correctly....
> > 
> 
> I'm still puzzled.
> 
> Are you saying that you want a program that does:
> 
> 	/* Deliberately simplified */
> 	gettimeofdayns(&now ...);
> 	utimensat(... now);
> 
> ... to suddenly start failing on Jan 19, 2038 (for a filesystem with
> 32-bit timestamps),

Yes. Hard fail so overflows are in your face and we know exactly
what is going to cause silent timestamp screwups when the epoch

> or would you propose some ways for the filesystems
> in question to extend the range of the timestamps?

Filesystems are going to have to change their on-disk formats, so
we'd do that just like we do every other on-disk format change. With
feature bits and translation layers, new ioctl structures, etc.
Depending on the amount of work necessary, some filesystems could do
this in 3.16, others it might be 3.20 before everything is sorted
out across the kernel and userspace code...

Either way, the hard fail problem goes away as each filesystem is
converted. Further, if we have regression tests then new filesystems
are guaranteed to be designed to handle 2038 epoch rollover, and so
in a year of two this "hard fail" is effectively a non-problem. If
someone breaks something in future, then we'll know about it pretty
quickly.

> What you seem to propose also seems to imply that on Jan 19, 2038
> anything that writes a timestamp with the current date (which logically
> ends up being almost every write operation) would be dead and frozen on
> such a filesystem -- pretty much meaning the filesystem would become
> readonly if not in reality than in practice.

Yup. If we can't do what the user wants without the user thinking
corruption has occurred, then the only thing we are left with is
"shut down the filesystem" error handling. Kind of like using BUG()
rather than returning an error. That's why we need to be able to
hard fail and return an error.

However, we've got 20+ years to fix our current filesystems and all
their support code to ensure this doesn't happen. In the mean time,
having stuff hard fail is a great way to ensure that filesystems get
fixed sooner rather than later...

> I strongly suspect that that would be a more catastrophic failure than
> incorrect timestamps, as you suddenly have all kinds of machines
> embedded in $DEITY knows what places just stop and refuse to run.

Yup, that's a great way of flushing out problems 20 years before
they really matter.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

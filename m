Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaEaPqb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 11:46:31 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:55542 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbaEaPqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 11:46:19 -0400
Date: Sat, 31 May 2014 11:46:16 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Dave Chinner <david@fromorbit.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        joseph@codesourcery.com, john.stultz@linaro.org, hch@infradead.org,
        tglx@linutronix.de, geert@linux-m68k.org, lftan@altera.com,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
In-Reply-To: <538995D4.9050702@zytor.com>
Message-ID: <alpine.LFD.2.11.1405311055410.17310@knanqh.ubzr>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <1401480116-1973111-12-git-send-email-arnd@arndb.de> <20140531003712.GH14410@dastard> <5389252A.5050503@zytor.com> <20140531011450.GJ14410@dastard> <c7770275-61de-4e94-9586-5ee118f77ba5@email.android.com>
 <20140531055457.GK14410@dastard> <538995D4.9050702@zytor.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2014, H. Peter Anvin wrote:

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
> 32-bit timestamps), or would you propose some ways for the filesystems
> in question to extend the range of the timestamps?
> 
> What you seem to propose also seems to imply that on Jan 19, 2038
> anything that writes a timestamp with the current date (which logically
> ends up being almost every write operation) would be dead and frozen on
> such a filesystem -- pretty much meaning the filesystem would become
> readonly if not in reality than in practice.

For those (legacy) filesystems with a signed 32-bit timestamps, any 
attempt to create a timestamp past Jan 19 03:14:06 2038 UTC should be 
(silently) clamped to 0x7fffffff and that value (the last representable 
time) used as an overflow indicator.  The filesystem driver should 
convert that value into a corresponding overflow value for whatever 
kernel internal time representation being used when read back, and this 
should be propagated up to user space.  It should not be a hard error 
otherwise, as you rightfully stated, everything non read-only would come 
to a halt on that day.

Inside the kernel, the overflow indicator could be as simple as 
dedicating one of the top bit in a 64-bit time_t value in order to still 
transmit the overflow limit.  For example, in the above case, we could 
use 0x40000000-7fffffff to indicate the actual time is unavailable due 
to the filesystem's time representation being overflowed from 
0x7fffffff.

If for example a filesystem cannot represent timestamps from Jan  1 
00:00:00 2100 UTC then the overflow representation for this particular 
filesystem would be 0x40000000-f48656ff.

Those syscalls with a 32-bit time_t would be returned 0x7fffffff 
whenever there is an overflow being signaled.  Whether 64-bit 
overflow-marked time_t values, when passed to user space, should clear 
the overflow bit, or use a unique time_t overflow value, could be 
decided and even changed later after discussion with glibc people for 
example.

Hard errors should be signaled to user space, and the actual operation 
aborted, only with the presence of a new flag passed to the kernel.  
However, by default, things should "just work" albeit with the "wrong" 
i.e clamped time being saved on disk as much as possible otherwise.


Nicolas

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbaFBBga (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 21:36:30 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:41042 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbaFBBg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 21:36:29 -0400
Date: Sun, 1 Jun 2014 21:36:26 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: "H. Peter Anvin" <hpa@zytor.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        joseph@codesourcery.com, john.stultz@linaro.org, hch@infradead.org,
        tglx@linutronix.de, geert@linux-m68k.org, lftan@altera.com,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
In-Reply-To: <8618458.1EVJCoVbkH@wuerfel>
Message-ID: <alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <538995D4.9050702@zytor.com> <alpine.LFD.2.11.1405311055410.17310@knanqh.ubzr> <8618458.1EVJCoVbkH@wuerfel>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2014, Arnd Bergmann wrote:

> On Saturday 31 May 2014 11:46:16 Nicolas Pitre wrote:
> > > readonly if not in reality than in practice.
> > 
> > For those (legacy) filesystems with a signed 32-bit timestamps, any 
> > attempt to create a timestamp past Jan 19 03:14:06 2038 UTC should be 
> > (silently) clamped to 0x7fffffff and that value (the last representable 
> > time) used as an overflow indicator.  The filesystem driver should 
> > convert that value into a corresponding overflow value for whatever 
> > kernel internal time representation being used when read back, and this 
> > should be propagated up to user space.  It should not be a hard error 
> > otherwise, as you rightfully stated, everything non read-only would come 
> > to a halt on that day.
> 
> I don't think there is much of a difference between not being able to
> write at all and all newly written files having the same timestamp,
> causing random things to break differently.

Well, in one case you have a crash certitude. In the other case you have 
some probability that your system might still be usable.

> The clamp to the maximum supported time stamp sounds like a reasonable
> choice for 'utimens' and related syscalls for the case of someone
> setting an arbitrary future date beyond what the file system can
> represent. Then again, I don't see a reason why that shouldn't just
> cause an error to be returned.

Resiliance is better than outright failure.

> For actually running kernels beyond 2038, the best idea I've seen so
> far is to disallow all broken code at compile time. I don't see
> a choice but to audit the entire kernel for invalid uses on both
> 32 and 64 bit in the next few years. A lot of code will get changed
> in the process so we can actually keep running 32-bit kernels and
> file systems, but other code will likely go away:
> 
> * any system calls that pass a time_t, timeval or timespec on
>   32-bit systems return -ENOSYS, to ensure all user land uses
>   the replacements we will put into place
> * The definition of 'time_t', 'timval' and 'timespec' can be hidden
>   from the kernel, and all code using it left out.
> * ext2 and ext3 file system code will have to be disabled, but that's
>   file since ext4 can mount old file systems.

Syscalls and libs can be "fixed".  Existing filesystem content might 
not.  So if you need to mount some old media in read-write mode after 
2038 and that happens to content an ext2 or similarly limited filesystem 
then it'd better just "work".  Having the kernel refuse to modify the 
filesystem would be unacceptable.


Nicolas

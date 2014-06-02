Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbaFBCWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 22:22:37 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:30567 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753691AbaFBCWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 22:22:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al53AF/fi1N5LL1sPGdsb2JhbABZgweDRagRAQEBAQEBBpgbAYEOFwMBAQEBODWCJQEBBScTHCMQCAMYCSUPBSUDBxoTiEHUEBcWhT+DXoRHAQ5JB4RABJl/ixyLXCuBMAEf
Date: Mon, 2 Jun 2014 12:22:11 +1000
From: Dave Chinner <david@fromorbit.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        joseph@codesourcery.com, john.stultz@linaro.org, hch@infradead.org,
        tglx@linutronix.de, geert@linux-m68k.org, lftan@altera.com,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Message-ID: <20140602022211.GN6677@dastard>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
 <538995D4.9050702@zytor.com>
 <alpine.LFD.2.11.1405311055410.17310@knanqh.ubzr>
 <8618458.1EVJCoVbkH@wuerfel>
 <alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 09:36:26PM -0400, Nicolas Pitre wrote:
> On Sun, 1 Jun 2014, Arnd Bergmann wrote:
> > On Saturday 31 May 2014 11:46:16 Nicolas Pitre wrote:
> > For actually running kernels beyond 2038, the best idea I've seen so
> > far is to disallow all broken code at compile time. I don't see
> > a choice but to audit the entire kernel for invalid uses on both
> > 32 and 64 bit in the next few years. A lot of code will get changed
> > in the process so we can actually keep running 32-bit kernels and
> > file systems, but other code will likely go away:
> > 
> > * any system calls that pass a time_t, timeval or timespec on
> >   32-bit systems return -ENOSYS, to ensure all user land uses
> >   the replacements we will put into place
> > * The definition of 'time_t', 'timval' and 'timespec' can be hidden
> >   from the kernel, and all code using it left out.
> > * ext2 and ext3 file system code will have to be disabled, but that's
> >   file since ext4 can mount old file systems.
> 
> Syscalls and libs can be "fixed".  Existing filesystem content might 
> not.  So if you need to mount some old media in read-write mode after 
> 2038 and that happens to content an ext2 or similarly limited filesystem 
> then it'd better just "work".  Having the kernel refuse to modify the 
> filesystem would be unacceptable.

We can already tell the VFS/filesystems not to update timestamps:

	inode->i_flags |= S_NOATIME | S_NOCMTIME;

Just enforce that everywhere (i.e. notify_change()) rather than just
on the IO path and the "legacy filesystem timestamp" problem is
"solved".

New interfaces need to return errors when an out-of-range parameter
is set. And right now, >epoch dates are out of range for most
filesystems, and so we need to handle that condition appropriately.
Silent date overflow == filesystem corruption, and as such I'm going
to error out such conditions in the filesystem regardless of what
the userspace API says.

Filesystems place all sorts of userspace visible limits on storage -
ever tried to create a file >16TB on ext4? The on-disk format
doesn't support it, so it returns an out of range error (E2BIG, I
think) if you try. XFS, OTOH, handles this just fine and so it
continues to work. It's exactly the same with timestamps - there's a
physical limit to what can sanely be stored in any given filesystem
and it's an *error condition* to go beyond that limit....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

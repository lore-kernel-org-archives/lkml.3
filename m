Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaERNqa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 09:46:30 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:40685 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaERNq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 09:46:26 -0400
Date: Sun, 18 May 2014 13:46:15 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Arnd Bergmann <arnd@arndb.de>, Chung-Lin Tang <cltang@codesourcery.com>,
        John Stultz <john.stultz@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
In-Reply-To: <5376AE23.10905@zytor.com>
Message-ID: <Pine.LNX.4.64.1405181325520.4608@digraph.polyomino.org.uk>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
 <4706636.rTYoqSXXOR@wuerfel> <Pine.LNX.4.64.1405151949160.911@digraph.polyomino.org.uk>
 <9236147.lyD24Zv5SZ@wuerfel> <53769B27.2090407@zytor.com>
 <Pine.LNX.4.64.1405162336150.24114@digraph.polyomino.org.uk> <5376AE23.10905@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 18 May 2014 13:46:18.0978 (UTC) FILETIME=[8BEA2C20:01CF729F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2014, H. Peter Anvin wrote:

> > Adding snseconds_t to POSIX seems pointless when there is no need for this 
> > field to store values that can't fit in "long".  Even if it were added, 
> > good practice would say that implementations should keep using "long" 
> > whenever possible for compatibility with existing applications (just like 
> > the ISO C recommendation "The types used for size_t and ptrdiff_t should 
> > not have an integer conversion rank greater than that of signed long int 
> > unless the implementation supports objects large enough to make this 
> > necessary.").
> 
> That is a very different thing, though.

It's advising against breaking compatibility with existing applications 
(in that case, C90 applications that assume sizes can be cast to unsigned 
long for printing, etc.) unless necessary.

Rich Felker suggests 
<https://sourceware.org/bugzilla/show_bug.cgi?id=16438> there are similar 
security risks from various types in the x32 ABI being wider than size_t.  
That seems entirely plausible, if unconfirmed; I don't think there's been 
much effort to look for such issues where applications expect types to be 
no wider than size_t when there's no use to them being wider than size_t.  
Most of those choices are valid but may be risky to existing software much 
as IL32LLP64 can be risky to existing software.

> > If you were designing from scratch, no doubt a typedef such as snseconds_t 
> > would be there, but with real-world APIs that have accumulated over time, 
> > deviating from "long" now is a bad idea.
> 
> Given that you already have a long long member of the same structure, it
> seems unlikely that adding another long long to this is a problem.
> 
> Anyway, this was discussed back in 2011:
> 
> https://lkml.org/lkml/2011/8/31/244

Just because one buggy port (I consider this quite clearly a bug at the 
glibc level, whatever the kernel does, agreeing with Rich Felker in 
<https://sourceware.org/bugzilla/show_bug.cgi?id=16437>) managed to get 
into glibc does not mean any more should be added.  glibc's function is to 
provide POSIX (and other) interfaces on top of the underlying kernel, 
which includes fixing any mismatch between the kernel and POSIX interfaces 
(such as converting from userspace POSIX struct timespec to the form in 
which times are passed to the kernel, by copying and zeroing padding, if 
necessary).  That's just like implementing POSIX threads on top of clone - 
or, if future POSIX disallows newlines in filenames (something that's been 
discussed for some time but doesn't seem to have seen much action lately) 
but the Linux kernel doesn't follow, making such checks on filenames 
before passing them to the kernel.  Of course, one would hope that the 
underlying kernel interfaces are designed to make it straightforward to 
implement POSIX on top of them (as well as other things not envisaged by 
POSIX).

The userspace ABI for struct timespec with 64-bit time_t and 32-bit long 
should use long tv_nsec in any future ports, with appropriate conversion 
code in glibc if the kernel interface is different (for ports that started 
out with 32-bit time_t, conversion code will be needed anyway to convert 
to the 32-bit structure if the new syscalls are unavailable at runtime and 
so the old syscalls need to be used, but if the kernel's structure with 
64-bit time_t is different from that in userspace then both old and new 
kernels need conversion code).  Given Rich Felker's bug reports, it seems 
reasonable to suppose that musl will wish to do this as well as glibc.

-- 
Joseph S. Myers
joseph@codesourcery.com

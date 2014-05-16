Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbaEPXrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 19:47:51 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:49198 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbaEPXrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 19:47:49 -0400
Date: Fri, 16 May 2014 23:47:37 +0000
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
In-Reply-To: <53769B27.2090407@zytor.com>
Message-ID: <Pine.LNX.4.64.1405162336150.24114@digraph.polyomino.org.uk>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
 <4706636.rTYoqSXXOR@wuerfel> <Pine.LNX.4.64.1405151949160.911@digraph.polyomino.org.uk>
 <9236147.lyD24Zv5SZ@wuerfel> <53769B27.2090407@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 16 May 2014 23:47:40.0980 (UTC) FILETIME=[39A33F40:01CF7161]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2014, H. Peter Anvin wrote:

> On 05/15/2014 01:38 PM, Arnd Bergmann wrote:
> > 
> > For practical purposes in the kernel, we may still want to use 64-bit
> > nanoseconds: if we use a 96 bit struct timespec, that would be incompatible
> > with the native type on 64-bit kernels, thus complicating the syscall
> > emulation layer.
> > 
> > I don't know why timespec on x32 uses 'long tv_nsec', it does seem
> > problematic.
> 
> struct timespec is specified in POSIX as having type "long" for tv_nsec.
>  This, as Linus pointed out, is totally braindamaged.

long is a perfectly reasonable type for this purpose - it's guaranteed to 
have enough precision.  ISO C11 follows POSIX in the definition of struct 
timespec.

> x32 does not follow POSIX (Linus pretty much dictated that), and instead
> does the __kernel_suseconds_t to match the native kernel type.  The
> proposal at some point was to try to push a snseconds_t into POSIX.

If the x32 kernel won't be fixed to treat the high part as padding then 
glibc will need fixing to copy all struct timespec values passed to the 
kernel and clear the padding when copying (really, fixing that bug would 
need such copying anyway unless --enable-kernel is used to allow a fixed 
kernel to be assumed).  In any case, we should not put any more ports into 
glibc with that x32 bug; "long" and an explicit padding field is the way 
to go (and copying / zeroing if the kernel doesn't treat that padding 
field as padding).

Adding snseconds_t to POSIX seems pointless when there is no need for this 
field to store values that can't fit in "long".  Even if it were added, 
good practice would say that implementations should keep using "long" 
whenever possible for compatibility with existing applications (just like 
the ISO C recommendation "The types used for size_t and ptrdiff_t should 
not have an integer conversion rank greater than that of signed long int 
unless the implementation supports objects large enough to make this 
necessary.").

If you were designing from scratch, no doubt a typedef such as snseconds_t 
would be there, but with real-world APIs that have accumulated over time, 
deviating from "long" now is a bad idea.

-- 
Joseph S. Myers
joseph@codesourcery.com

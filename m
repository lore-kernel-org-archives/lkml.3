Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbaEOVFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:05:11 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:63151 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbaEOVFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:05:08 -0400
Date: Thu, 15 May 2014 21:05:03 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: Arnd Bergmann <arnd@arndb.de>
CC: Chung-Lin Tang <cltang@codesourcery.com>,
        John Stultz <john.stultz@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
In-Reply-To: <9236147.lyD24Zv5SZ@wuerfel>
Message-ID: <Pine.LNX.4.64.1405152050230.911@digraph.polyomino.org.uk>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
 <4706636.rTYoqSXXOR@wuerfel> <Pine.LNX.4.64.1405151949160.911@digraph.polyomino.org.uk>
 <9236147.lyD24Zv5SZ@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginalArrivalTime: 15 May 2014 21:05:07.0131 (UTC) FILETIME=[597A40B0:01CF7081]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014, Arnd Bergmann wrote:

> > The distribution side of the change for _FILE_OFFSET_BITS (i.e., moving to 
> > building libraries that way so a glibc change to the default wouldn't 
> > cause issues for other libraries' ABIs) has gradually been done.  The 
> > discussion in March on libc-alpha about changing the default tailed off.  
> > This is something that needs someone to take the lead with a *careful and 
> > detailed analysis of the information from the previous discussion* in 
> > order to present a properly reasoned proposal for a change to the default 
> > - not scattergun patches, not patches with brief or no analysis of the 
> > environment in which glibc is used, not dismissing concerns, but a 
> > properly reasoned argument for why the change should be made, along with 
> > details of how distributions can determine whether ABI issues would arise 
> > from rebuilding a particular library against newer glibc.
> 
> Ok, I see. I wasn't aware that distributions actually set _FILE_OFFSET_BITS
> globally for building packages. I guess the effect (from the distro point
> of view) of that is similar to having a configure option when building glibc
> as I expected to be the normal way to do it.

I'm not sure they set it globally (modulo the suggestion in that recent 
thread that Gentoo might try changing the default and seeing what breaks) 
- but it at least seems to be set for most libraries for which it affects 
the ABI (whether upstream or by the distributions), based on the sample 
Paul Eggert looked at 
<https://sourceware.org/ml/libc-alpha/2014-03/msg00351.html> (which is an 
important piece of evidence that a change to the default in glibc wouldn't 
be dumping a large problem on distributors regarding the ABIs of many 
widely-used libraries).

> I don't know why timespec on x32 uses 'long tv_nsec', it does seem
> problematic.

Yes, we have a glibc bug 
<https://sourceware.org/bugzilla/show_bug.cgi?id=16437> about the glibc 
definition (64-bit tv_nsec in x32 userspace to match the kernel's 64-bit 
"long") being nonconforming, but without the kernel treating upper bits as 
padding, fixing glibc requires wrappers that copy the value and clear the 
upper bits.

> What could work is a type that has explicit padding:
> 
> struct timespec {
> 	__s64 tv_sec;
> #ifdef BIG_ENDIAN_32BIT
> 	u32 __pad;
> #endif
> 	long tv_nsec;
> #ifdef LITTLE_ENDIAN_32BIT
> 	u32 __pad;
> #endif
> };

Yes.  That's fine for POSIX (and I think x32 should move to such a 
definition, though for glibc there would still be the issue of 
compatibility with existing kernels).

> For timeval, I think we don't care about the padding, because we wouldn't
> use it on new interfaces when the kernel uses nanosecond resolution
> internally.

Indeed - I haven't checked, but hopefully none of the asm-generic 
interfaces use timeval (and I was suggesting that only the interfaces 
present in asm-generic should be duplicated for 64-bit time_t).

(You also mentioned ioctls.  All affected ioctls would need new variants 
unless you have a new variant of the ioctl syscall itself.  Logically I 
suppose _TIME_BITS=64 should then map the generic version of an ioctl to 
the 64-bit time_t version so applications don't need to change beyond 
defining _TIME_BITS=64, though I don't know if there's any precedent for 
doing that sort of thing for definitions in kernel headers rather than 
glibc's headers.)

-- 
Joseph S. Myers
joseph@codesourcery.com

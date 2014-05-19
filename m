Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaESIIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:08:44 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:53642 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbaESIIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:08:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Joseph S. Myers" <joseph@codesourcery.com>
Cc: Chung-Lin Tang <cltang@codesourcery.com>,
        John Stultz <john.stultz@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
Date: Mon, 19 May 2014 10:08:18 +0200
Message-ID: <4254860.84WuxPQ4j9@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.64.1405152050230.911@digraph.polyomino.org.uk>
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <9236147.lyD24Zv5SZ@wuerfel> <Pine.LNX.4.64.1405152050230.911@digraph.polyomino.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:yAB6YuGTmXfV8mdZCgEz5eBGG9hClnnIfJHhEsFoXi8
 U/U/QmjPdghYSEfHVBY7oSsBHHn0iQU1ZJB9Lj4YB42s7dObuu
 kdtG1ESbgMMB1E4hf12YsWTnfAWqcE9fWSCVjbwJvjj9vMWITZ
 ACn1QT6FIe2Op/O818aAPYJmOrQyQje1uIPG+plqh6KgmenoY3
 osM8m75QvjfrVoojVgNsJtqRGw9Me+JVjkL/nSZnE3MEP2W2ru
 lWjVwOKSLL89d44rZh72r4XjlReCKCKJGfBiG010XGVmIg7Qe+
 j+hFj95CISenFhNoEVtKLakDekvpnS+yLFwn70f7KjZr2wAfxp
 8IQRqZe0Cp3KXSTzThiE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 May 2014 21:05:03 Joseph S. Myers wrote:
> On Thu, 15 May 2014, Arnd Bergmann wrote:
> 
> > > The distribution side of the change for _FILE_OFFSET_BITS (i.e., moving to 
> > > building libraries that way so a glibc change to the default wouldn't 
> > > cause issues for other libraries' ABIs) has gradually been done.  The 
> > > discussion in March on libc-alpha about changing the default tailed off.  
> > > This is something that needs someone to take the lead with a *careful and 
> > > detailed analysis of the information from the previous discussion* in 
> > > order to present a properly reasoned proposal for a change to the default 
> > > - not scattergun patches, not patches with brief or no analysis of the 
> > > environment in which glibc is used, not dismissing concerns, but a 
> > > properly reasoned argument for why the change should be made, along with 
> > > details of how distributions can determine whether ABI issues would arise 
> > > from rebuilding a particular library against newer glibc.
> > 
> > Ok, I see. I wasn't aware that distributions actually set _FILE_OFFSET_BITS
> > globally for building packages. I guess the effect (from the distro point
> > of view) of that is similar to having a configure option when building glibc
> > as I expected to be the normal way to do it.
> 
> I'm not sure they set it globally (modulo the suggestion in that recent 
> thread that Gentoo might try changing the default and seeing what breaks) 
> - but it at least seems to be set for most libraries for which it affects 
> the ABI (whether upstream or by the distributions), based on the sample 
> Paul Eggert looked at 
> <https://sourceware.org/ml/libc-alpha/2014-03/msg00351.html> (which is an 
> important piece of evidence that a change to the default in glibc wouldn't 
> be dumping a large problem on distributors regarding the ABIs of many 
> widely-used libraries).

I'm mostly worried about the embedded use case, which at least for time_t
would have to build everything the new way as soon as possible. For
desktop and server systems, doing a slow migration to catch the bugs
and never introduce regressions in the field makes a lot of sense,
but when someone today wants to build an embedded system, they already
build everything from source, and it's more important to find all
the bugs now (ideally at compile time) than to have a chance of hitting
a subtle issue 24 years ago on today's build.

For that, it would be nice to even build a glibc that has no backwards
compatibility interfaces for 32-bit time_t at all.

> > I don't know why timespec on x32 uses 'long tv_nsec', it does seem
> > problematic.
> 
> Yes, we have a glibc bug 
> <https://sourceware.org/bugzilla/show_bug.cgi?id=16437> about the glibc 
> definition (64-bit tv_nsec in x32 userspace to match the kernel's 64-bit 
> "long") being nonconforming, but without the kernel treating upper bits as 
> padding, fixing glibc requires wrappers that copy the value and clear the 
> upper bits.

Ok. There is also work going on to have an x32-like ABI for ARM64, and
that will likely have to support big-endian as well, so then it's not
just about clearing the padding bits, but also having them in the right
place.

I don't know what happens with powerpc64le, but I assume they will also
at some point want to support 32-bit user space if they don't already.

> > For timeval, I think we don't care about the padding, because we wouldn't
> > use it on new interfaces when the kernel uses nanosecond resolution
> > internally.
> 
> Indeed - I haven't checked, but hopefully none of the asm-generic 
> interfaces use timeval (and I was suggesting that only the interfaces 
> present in asm-generic should be duplicated for 64-bit time_t).
> 
> (You also mentioned ioctls.  All affected ioctls would need new variants 
> unless you have a new variant of the ioctl syscall itself.  Logically I 
> suppose _TIME_BITS=64 should then map the generic version of an ioctl to 
> the 64-bit time_t version so applications don't need to change beyond 
> defining _TIME_BITS=64, though I don't know if there's any precedent for 
> doing that sort of thing for definitions in kernel headers rather than 
> glibc's headers.)

For ioctls, it's not that uncommon to change the definition in the kernel
headers to fix bugs, implying we break compatibility between a user space
tool built against new kernel headers but running on older kernels. That
is already the case for any user space relying on newly introduced ioctls,
so we can e.g. introduce a new ioctl command using a
struct __kernel_timespec64 in one of its structs.

Unfortunately, not every driver installs the header files into the user
visible location, some of them have a copy in their (only) user space
tool. This is still fine if we can catch it and if the driver uses
the correct macro to create the ioctl number, which changes the command
code because of the new argument size. The same would be true if we get
a glibc with 64-bit time_t and old kernel headers that use a 'struct
timespec' or 'time_t' in an ioctl data structure and expect that to
use  a 32-bit type. There are probably a small number of those that
also use a malformed command code definition (one that does not take
the structure size into account), and those will cause us problems no
matter what we do.

Another incompatibility is clearly things like include/sound/asound.h
if we decide to change all the structs to use u64 nanosecond timestamps
instead of timespec as we discussed earlier. This means we don't just
have to introduced new command codes but also change all user space
code working with the structs.

The worst case I've found so far is include/linux/if_packet.h, which
uses a memory mapped data structure with 'unsigned int ts_sec'
embedded. It's not possible to translate this at all, and it's also
broken on all 64-bit architectures today. There are already three
versions of that ABI defined though, and I guess there will have to
be another one.

	Arnd

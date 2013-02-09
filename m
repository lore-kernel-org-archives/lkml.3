Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760591Ab3BIDQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 22:16:50 -0500
Received: from relais.videotron.ca ([24.201.245.36]:32823 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760514Ab3BIDQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 22:16:49 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Fri, 08 Feb 2013 22:16:47 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Kim Phillips <kim.phillips@freescale.com>
Cc: "Woodhouse, David" <david.woodhouse@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Rientjes <rientjes@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [RFC] arm: use built-in byte swap function
In-reply-to: <20130208191208.2ef3d78bda71aa7b44d00d7b@freescale.com>
Message-id: <alpine.LFD.2.02.1302082102380.6300@xanadu.home>
References: <20130129181046.GC25415@pd.tnic>
 <1359541333.3529.186.camel@shinybook.infradead.org>
 <20130130200900.9d7cf7908caeaef4ecee1d61@freescale.com>
 <20130131092801.GV23505@n2100.arm.linux.org.uk>
 <20130131145947.f62474a0600848df86548b96@freescale.com>
 <20130201011712.GF23505@n2100.arm.linux.org.uk>
 <1359703995.23531.6.camel@shinybook.infradead.org>
 <20130205210436.670c62e26d2121330e87af35@freescale.com>
 <1360141322.6066.4.camel@shinybook.infradead.org>
 <20130206191905.ac8eb6743e69425f30888704@freescale.com>
 <20130207181315.GM17833@n2100.arm.linux.org.uk>
 <1360344301.6066.263.camel@shinybook.infradead.org>
 <alpine.LFD.2.02.1302081503430.6300@xanadu.home>
 <1360363233.6066.283.camel@shinybook.infradead.org>
 <alpine.LFD.2.02.1302081745500.6300@xanadu.home>
 <20130208191208.2ef3d78bda71aa7b44d00d7b@freescale.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2013, Kim Phillips wrote:

> On Fri, 8 Feb 2013 17:47:33 -0500
> Nicolas Pitre <nico@fluxnic.net> wrote:
> 
> > On Fri, 8 Feb 2013, Woodhouse, David wrote:
> > 
> > > On Fri, 2013-02-08 at 15:04 -0500, Nicolas Pitre wrote:
> > > > On Fri, 8 Feb 2013, Woodhouse, David wrote:
> > > > 
> > > > > On Thu, 2013-02-07 at 18:13 +0000, Russell King - ARM Linux wrote:
> > > > > > 
> > > > > > However, the biggest reason not to use libgcc is that we want to control
> > > > > > what gets used in the kernel - for example, no floating point, and no
> > > > > > use of 64 x 64bit division.
> > > > > 
> > > > > Which is all very sensible. But there's no particular reason we couldn't
> > > > > add a __bswap[sd]i2 to the kernel's version of libgcc if we wanted to.
> > > > 
> > > > Absolutely.
> > > 
> > > And then ARM can just set ARCH_USE_BUILTIN_BSWAP like other
> > > architectures do, right?
> > 
> > If that turns out to be beneficial over what we have now, then yes.
> > I didn't read back the whole thread to form an opinion though.
> 
> The diff below implements __bswap[sd]i2 in arch/arm/lib, and
> results in the following savings in vmlinux size:
> 
> column 1: name of defconfig
> column 2: text+data+bss, linux-next-20130207 vanilla, gcc 4.6.3
> column 3: text+data+bss, linux-next-20130207+below diff, gcc 4.6.3
> column 4: col. 3 - col. 2 (ie., -ve numbers represent savings)
> 
[...]
> imx_v6_v7_defconfig: 	7672373 	7667089 	-5284
> lart_defconfig:	2941150		2941054         -96
> mxs_defconfig: 	11091983 	11095679 	3696

The savings are good, with some impressive cases.  However the 
mxs_defconfig is completely the opposite and by far.  Any idea?

> gcc 4.7.3 runs haven't been as good across the board as gcc 4.6.3,
> however:

Not only that, but in many cases the results are wildly different given 
the same config:

> imx_v6_v7_defconfig:	7637605		7636935		-670
> lart_defconfig: 	2922550 	2926600 	4050
> mxs_defconfig: 	11071139 	11070893 	-246

The mxs_defconfig became much better while lart_defconfig regressed a 
lot.

> Haven't looked at why.

Would be a good idea since this is rather weird and gcc could benefit 
from your findings.

> In any case, some questions I have are:
> 
> (a) are the __bswap[sd]i2 implementations acceptable written in C,
> as in the diff?  I don't speak ARM asm (yet at least).  The
> generated code looks pretty optimal in both armv5 and 6+.

It looks pretty nice indeed:

__bswapsi2:
        eor     r2, r0, r0, ror #16
        mov     r1, r2, lsr #8
        bic     r3, r1, #65280
        eor     r0, r3, r0, ror #8
        bx      lr

There is no way to do better than that.  But that's true only if -Os is 
_not_ used.  With -Os we get the following output:

__bswapsi2:
        mov     r3, r0, asl #24
        and     r2, r0, #65280
        orr     r3, r3, r0, lsr #24
        orr     r3, r3, r2, asl #8
        and     r0, r0, #16711680
        orr     r0, r3, r0, lsr #8
        bx      lr

I really don't get why gcc thinks the above is shorter.  I'm saving you 
from pasting the __bswapdi2 result which is also way way worse.
That was with Linaro gcc v4.6.2.

With Sourcery gcc v4.5.1 we get:

__bswapsi2:
        stmfd   sp!, {r3, lr}
        bl      __bswapsi2
        ldmfd   sp!, {r3, pc}

This is indeed shorter, but much less useful.  So you better enforce -O2 
for this file.  And the nice thing with C code is that it is fully 
optimized with the rev instruction when compiling for ARMv6+ if it is 
ever used in that case.

> (b) would adding __bswap[sd]i2 to the kernel build need to be
> disabled on armv6+? AFAICT, gcc doesn't emit calls - even for the
> 8-byte swap, even with -Os, on armv6+.

I wouldn't bother.  That would save only 6 instructions total.  And who 
knows if some gcc flavor start calling them for some reason eventually.

> (c) testing allyesconfigs is proving to be a pain - lots of
> breakeage - other than defconfig testing, is there any more I can do?

The defconfigs provide wildly different results and that is a good 
thing for further investigation.  You may concentrate on a small 
interesting sample such as those I kept above.

With allyesconfig the good configs would cancel out the bad ones making 
the bad ones invisible.


Nicolas

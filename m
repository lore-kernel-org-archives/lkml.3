Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaENLri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:47:38 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:52995 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbaENLre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:47:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] mtd: orion-nand: fix build error with ARMv4
Date: Wed, 14 May 2014 13:47:20 +0200
Message-ID: <4645786.pJABUgPlCA@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140513205548.GC22907@obsidianresearch.com>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de> <20140509220915.GA391@arch.cereza> <20140513205548.GC22907@obsidianresearch.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:fx+WR49xISKGcz6m1pAawPCepP4HolBOy4mfuVz8dP7
 P3BYKcOYCaWIZ+JPKiRW8ZQosZl6N+RX1RSbBi/R3Ec8SRGW5j
 axI/jOYtIuzAAaPhDCSiMOF/qlADUupGJ39owq/K6VRr6DtlV1
 nwkyum4ho3w11L0UybS+sMsoHpUJ6fImC/0w+EzToDET61t2Dx
 3LX78kd6Ye8Fq0S6bEJ2e9yI0zykJiEgq8J1GHLOXBVUILFd9c
 GxZDm1altQ7GKl/IaESPJ9EuG8Ab54n1vvIyEcAtz4E3Dsa3Dq
 THwnEYo+s2vqcrLy3Em4ABJ30OvTZcCvQMT6vli03W/PozC0mp
 rDidgQ6T+kQ6snniNcwY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 May 2014 14:55:48 Jason Gunthorpe wrote:
> On Fri, May 09, 2014 at 07:09:15PM -0300, Ezequiel Garcia wrote:
> > On 09 May 03:28 PM, Jason Gunthorpe wrote:
> > > 
> > > > I gave this a try in order to answer Arnd's performance
> > > > question. First of all, the patch seems wrong. I guess it's because
> > > > readsl reads 4-bytes pieces, instead of 8-bytes.
> > > > 
> > > > This patch below is tested (but not completely, see below) and works:
> > > 
> > > Compilers are better now, I think you can just ditch the weirdness:
> > > 
> > [..]
> > > 
> > > The below gives:
> > > 
> > >   c8:   ea000002        b       d8 <orion_nand_read_buf+0x84>
> > >   cc:   e5dc0000        ldrb    r0, [ip]
> > >   d0:   e7c30001        strb    r0, [r3, r1]
> > >   d4:   e2811001        add     r1, r1, #1
> > >   d8:   e1510002        cmp     r1, r2
> > > 
> > > Which looks the same as the asm version to me.
> > > 
> > 
> > Nice! It wasn't really needed but since I have the board here:
> > 
> > # time nanddump /dev/mtd5 -f /dev/null -q
> > real  0m 5.82s
> > user  0m 0.20s
> > sys   0m 5.60s
> > 
> > Jason: Care to submit a proper patch?
> 
> Sure, but did anyone (Arnd?) have thoughts on a better way to do this:
> 
> +#ifdef CONFIG_64BIT
> +               buf64[i++] = readq_relaxed(io_base);
> +#else
> +               buf64[i++] = *(const volatile u64 __force *)io_base;
> +#endif
>
> IMHO, readq should exist on any platform that can issue a 64 bit bus
> transaction, and I expect many ARM's qualify.

Well, the original problem happened specifically for the case that doesn't
have a 64-bit bus transaction (building for ARMv4). If we define
readq_relaxed, it has to be an inline assembly, in order to work for
drivers that require an atomic transaction, so that would have the
same problem. We are a bit inconsistent here though: most 32-bit
architectures have no readq, parisc has one that does two 32-bit accesses,
sh relies on the compiler, and tile apparently has a native instruction.

It seems reasonable to replace the inline assembly in this driver with
a new function as a cleanup, but then how do you want to solve the case
of building a combined armv4/v5 kernel?

	Arnd

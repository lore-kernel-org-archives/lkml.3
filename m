Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218AbaENNJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:09:51 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:49806 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaENNJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:09:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] mtd: orion-nand: fix build error with ARMv4
Date: Wed, 14 May 2014 15:09:08 +0200
Message-ID: <5493671.FYnaLOl21S@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAMuHMdXD7HhG_jGJdz8hCR847tKcRC-tQnHp=xtTDYVKBc6yQQ@mail.gmail.com>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de> <4645786.pJABUgPlCA@wuerfel> <CAMuHMdXD7HhG_jGJdz8hCR847tKcRC-tQnHp=xtTDYVKBc6yQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:05TLbHxSh+XwepfIG62/KFGvpB4mrGhSuDq7M6BeQ0H
 U4SFUtPWoQHj/xVevQNELFKAdF/z8uJjShPAHI4BCqoRTnmrAN
 bL6XsjupLP5d1GBdjZTMT6Tayxgxs7KHqdwvd79fS1MBxmFaKi
 dpmxZpOtNXppgRIwCARSjSS5kYX6IKP4vMA8zPOgmawFeJknRz
 DyYa4moGuA+BU8MyWzh5Bd1meHpYWuw3DAWBCWFo8LHjXjd4x6
 5MUwg9xJ/+HfapzIOFkTNp+72GHn8gmcDpTMyrq0qqDOAiv1mw
 cVW2HOxxIp5FpvJ9LBJbUWxWFzt4XM8zP8gG3QoXI8w+qCAlHw
 vhk4CrwJdw40W/cLMSaQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2014 14:35:28 Geert Uytterhoeven wrote:
> On Wed, May 14, 2014 at 1:47 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> Sure, but did anyone (Arnd?) have thoughts on a better way to do this:
> >>
> >> +#ifdef CONFIG_64BIT
> >> +               buf64[i++] = readq_relaxed(io_base);
> >> +#else
> >> +               buf64[i++] = *(const volatile u64 __force *)io_base;
> >> +#endif
> >>
> >> IMHO, readq should exist on any platform that can issue a 64 bit bus
> >> transaction, and I expect many ARM's qualify.
> >
> > Well, the original problem happened specifically for the case that doesn't
> > have a 64-bit bus transaction (building for ARMv4). If we define
> > readq_relaxed, it has to be an inline assembly, in order to work for
> > drivers that require an atomic transaction, so that would have the
> > same problem. We are a bit inconsistent here though: most 32-bit
> > architectures have no readq, parisc has one that does two 32-bit accesses,
> > sh relies on the compiler, and tile apparently has a native instruction.
> >
> > It seems reasonable to replace the inline assembly in this driver with
> > a new function as a cleanup, but then how do you want to solve the case
> > of building a combined armv4/v5 kernel?
> 
> Provide two helper functions, one for v4, one for v5, and call
> them through a function pointer that's set up during driver probe?

No, that won't help. It's a compile-time problem only: This driver
is never actually used on ARMv4, but if we build a kernel that supports
both ARMv4 and later, gcc passes -march=armv4 to the assembler, which
barfs on an invalid instruction. It would be fine to make that error
message just go away because we know it will only be used on CPUs that
do have this instruction.

	Arnd

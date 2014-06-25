Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbaFYOhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:37:41 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42611 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757066AbaFYOhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:37:40 -0400
Date: Wed, 25 Jun 2014 15:37:28 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Daniel Drake <drake@endlessm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v2 0/6] Enable L2 cache support on Exynos4210/4x12 SoCs
Message-ID: <20140625143728.GN3705@n2100.arm.linux.org.uk>
References: <1403703451-12233-1-git-send-email-t.figa@samsung.com> <20140625135039.GM3705@n2100.arm.linux.org.uk> <53AAD8FC.9040306@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AAD8FC.9040306@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 04:13:16PM +0200, Tomasz Figa wrote:
> On 25.06.2014 15:50, Russell King - ARM Linux wrote:
> > On Wed, Jun 25, 2014 at 03:37:25PM +0200, Tomasz Figa wrote:
> >> This series intends to add support for L2 cache on Exynos4 SoCs on boards
> >> running under secure firmware, which requires certain initialization steps
> >> to be done with help of firmware, as selected registers are writable only
> >> from secure mode.
> > 
> > What I said in my message on June 12th applies to this series.  I'm
> > not having the virtual address exposed via the write_sec call.
> > 
> > Yes, you need to read other registers in order to use your secure
> > firmware implementation.  Let's fix that by providing a better write_sec
> > interface so you don't have to read back these registers, rather than
> > working around this short-coming.
> 
> Do you have anything in particular in mind? I would be glad to implement
> it and send patches.

As I've already said, you are not the only ones who need fuller information
to make your secure monitor calls.  So, what that implies is that rather
than the interface being "please write register X with value V", and then
having platforms work-around that by reading various registers, we need
a more flexible interface which passes the desired state.

> > That's exactly what I meant when I talked on June 12th about turning
> > cache-l2x0.c back into a pile of crap.  You're working around problems
> > rather than fixing the underlying issue, as seems to be standard
> > platform maintainer behaviour when things like core ARM code is
> > concerned.  This is why things devolve over time into piles of crap,
> > because platforms just hack around problems rather than fixing the
> > root cause of the problem.
> 
> I'm not sure what part of my patches exactly is turning cache-l2x0.c
> into a pile of crap. On the contrary, I believe that working around the
> firmware brokenness on platform level, while keeping the core code
> simple does the opposite.

What you're doing is making the future maintanence of cache-l2x0.c
harder by breaking the modularity of it.  By exposing the virtual
address of the registers, reading the registers and getting your
secure monitor to write them back, you're making assumptions about
the behaviours inside cache-l2x0.c - while this may seem to be a no-op
think about what happens a few years down the line when someone needs
to change how this stuff operates, and you've long since moved on to
new pastures and aren't around to answer questions on the exynos
implementation.

Compare that to modifying the implementation to give the secure
monitors what they want - the desired state of the secure registers
when enabling and resuming the L2 cache.  The API becomes much
clearer, and maintainable, because - from the core persective,
there isn't a load of platforms doing weird crap with an API which
doesn't really fit what they're trying to do.

So, if we accept your patches as is and let that approach continue,
then years down the line, cleaning up the crap that you've deposited
becomes much harder, and we end up either having to break Exynos
declaring it as a SoC we just don't give a damn about it, or keep the
old interface.  That is bad news which ever way you look at it.

Quite simply, if a job is worth doing, then it's worth doing well and
properly.

The reason we have l2c_write_sec() right now is that when I sorted out
the existing shitpile that platform maintainers had turned that code
into over the years, it was the interface which suited the current
implementations.  As the secure APIs are typically confidential, there
is no way to consider what other alternatives are out there, so this
is something that is going to have to remain flexible - in other words,
it needs to remain long term maintainable, so that it can change.  So,
working around it's short-comings in platform code is totally the wrong
thing to do.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.

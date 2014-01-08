Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963AbaAHTUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:20:41 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:59437 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752110AbaAHTUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:20:39 -0500
Date: Wed, 8 Jan 2014 19:20:28 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Doug Anderson <dianders@chromium.org>
Cc: Will Deacon <will.deacon@arm.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        David Garbett <David.Garbett@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH] arm: Add Arm Erratum 773769 for Large data RAM latency.
Message-ID: <20140108192028.GM27432@n2100.arm.linux.org.uk>
References: <1389187991-26446-1-git-send-email-gautam.vivek@samsung.com> <20140108143529.GB14122@mudshark.cambridge.arm.com> <CAD=FV=WYe7Qk_XPs=FCeB7pbDz8AnG0txFcDyAQWWAU60vd-Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=WYe7Qk_XPs=FCeB7pbDz8AnG0txFcDyAQWWAU60vd-Sw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 08:21:21AM -0800, Doug Anderson wrote:
> WIll,
> 
> Thanks for your comments!
> 
> On Wed, Jan 8, 2014 at 6:35 AM, Will Deacon <will.deacon@arm.com> wrote:
> > NAK. Whilst I appreciate that you may not be able to fix your bootloader,
> > this isn't the right change to make in the kernel. Blindly changing memory
> > latencies is likely to do more harm than good for a multi-platform kernel,
> > even if it works for exynos 5250. The only alternative I can think of (if you
> > have to make a mainline kernel change) is to restrict the clock frequencies at
> > which the CPU is allowed to run, although that obviously requires some
> > investigation in order to determine how viable it is for your SoC.

+1

> I'll start off by saying that I'm totally OK if mainline doesn't want
> this fixed.  If mainline is not interested in running reliably on
> exynos5250-based products then there's nothing I can do about it.  It
> seems unfortunate, but I'm not going to get into a shouting match
> about it.

No, we're saying to put the work-around in the boot loader, not the kernel.

> You're saying that this patch is blindly changing memory latencies.  I
> don't think it is (please correct me if I'm wrong!).  This patch:
> 
> * Is guarded by a CONFIG option so the code isn't even compiled in if
> you don't want EXYNOS5250 support.  I know this doesn't help
> multiplatform, but it means that if you really hate the code it's easy
> to disable.

As you identify, this is completely useless in the multiplatform kernel
case, so you can completely remove this from the argument _for_ this
change - it carries no weight what so ever.

> * Is guarded by a runtime check of the revision number so that it
> doesn't run on unaffected A15 revisions.

So what if the A15 reports an affected revision, but the SoC integrator
has fixed the problem - why should they have to put up with the work-
around being applied on their silicon?

> * Is guarded by a runtime check so it does nothing at all if the total
> latency is <= 3 (AKA if boot code already picked a sane value)

Right, so the effect of the above is that with a multiplatform kernel
including Exynos 5 support, all platforms with an A15 r2p0 or earlier
have this work-around applied even if it was actually fixed in the
silicon - which there's no way to know from the software perspective.

We've been through these arguments many times, you're not the first to
raise it, and we've decided upon the policy.  We want as _few_ work-
arounds in the kernel as possible, because applying the work-arounds
is very problematical with the mixture of secure and non-secure booting.

Maybe Will can check, but I believe that the L2 cache control register
is one of those which is not writable from non-secure mode, and thus
will crash the kernel at boot if a write is attempted.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaLQCI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 21:08:56 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:49098 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaLQCIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 21:08:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] clocksource: sh_tmu: Set cpu_possible_mask to fix SMP broadcast
Date: Wed, 17 Dec 2014 04:08:56 +0200
Message-ID: <2855304.l47b4KVhTf@avalon>
User-Agent: KMail/4.14.3 (Linux/3.16.5-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <CANqRtoRTcC_ixjY_Qr1T=2Jhh9qu_5+=Z3YRBDUJX8HWHP6Nog@mail.gmail.com>
References: <20141216094854.22639.69181.sendpatchset@w520> <CAMuHMdUzys9pbEjUybyDP-3=uemLZuP5WgXeyONxGmADUJJL4A@mail.gmail.com> <CANqRtoRTcC_ixjY_Qr1T=2Jhh9qu_5+=Z3YRBDUJX8HWHP6Nog@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus and Geert,

On Wednesday 17 December 2014 10:30:33 Magnus Damm wrote:
> On Tue, Dec 16, 2014 at 9:40 PM, Geert Uytterhoeven wrote:
> > On Tue, Dec 16, 2014 at 12:46 PM, Magnus Damm wrote:
> >>> Could you please confirm that you've tested both CONFIG_PREEMPT_NONE and
> >>> CONFIG_PREEMPT with and without the ARM TWD times, and that you've
> >>> booted to userspace and tested timer broadcast on all CPUs ?
> >> 
> >> No I have not. I've booted to user space in initramfs with DT-based
> >> TWD on Multiplatform for r8a7779. Without this fix (and other r8a7779
> >> TWD bits) I see a lot of breakage. For instance, TWD and SMP boot is
> >> broken on r8a7779 - both legacy and non-legacy. I have not gotten to
> >> sh73a0 yet, but I assume it is busted too.
> > 
> > FWIW, I applied this patch, and booted the result successfully and without
> > 
> > any user-visible changes on:
> >   - koelsch
> >   - armadillo-multiplatform
> >   - kzm9g-legacy
> >   - kzm9g-multiplatform
> 
> Thanks for testing - now let us wait and see what Laurent says.
> 
> > Armadillo-legacy is broken, and probably won't come back (cfr.
> > https://lkml.org/lkml/2014/12/2/339).
> > 
> > Kzm9g-reference still hangs at "Calibrating local timer..." (it did work
> > at some point in the past).

kzm9g-reference boots for me with kzm9g_defconfig on Simon's devel branch with 
CONFIG_PREEMPT_NONE but fails to boot with CONFIG_PREEMPT. The platform 
doesn't instantiate the TMU at the moment anyway, so it's unrelated to this 
patch.

Given that kzm9g-legacy works for me regardless of the preempt configuration 
and on the TMU cpumask, that kzm9g-reference doesn't use TMU, and that you've 
tested kzm9g-multiplaform successfully, I think we can consider that this 
patch is safe from a kzm9g point of view.

(By the way, how have you tested kzm9g-multiplatform given that none of 
renesas-drivers-2014-12-08-v3.18, renesas-devel-20141212-v3.18 or today's 
upstream support multiplatform kernels for sh73a0 ?)

Magnus, you have told me that you've performed tests on Marzen with 
CONFIG_PREEMPT_NONE and with both TWD enabled and disabled. If you could 
perform the same tests with CONFIG_PREEMPT instead without noticing any 
regression I think we can merge your patch. Whatever breakage it has caused in 
the past is likely hidden somewhere beyond eyesight.

> When the time allows I'd like us to try to fix up these somehow. At
> least I'll give it a go - I guess Armadillo is difficult without any
> board.

I'd like that very much. Let's get rid of r8a73a4 legacy (Ulrich's patches 
should be ready) first, and possible sh73a0 and r8a7740 as well, and then 
retest our various timers configurations. We should test both CONFIG_PREEMPT 
and CONFIG_PREEMPT none, with all combination of the CMT, TMU, MTU2, TWD and 
ARM architected timer enabled.

> > Note that my local tree is based on renesas-drivers-2014-12-08-v3.18,
> > renesas-devel-20141212-v3.18, and yesterday's upstream, with CCF,
> > PM domain, TWD, and lots of WIP patches from the kitchen sink applied.
> 
> The TWD portion above - is it driver code or integration stuff? If the
> latter - is there any reason why these can't be picked up by Simon and
> merged right away.
> 
> My plan is to dig into sh73a0 (maybe including TWD) later today.

-- 
Regards,

Laurent Pinchart


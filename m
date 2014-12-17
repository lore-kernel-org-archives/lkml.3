Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223AbaLQAnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 19:43:41 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:49029 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaLQAnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 19:43:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] clocksource: sh_tmu: Set cpu_possible_mask to fix SMP broadcast
Date: Wed, 17 Dec 2014 02:43:42 +0200
Message-ID: <3231701.Zbfs8c4b3F@avalon>
User-Agent: KMail/4.14.3 (Linux/3.16.5-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <CANqRtoTpSadrrpeBxA-ym4MZBfhY_BEyTPr_sfau8dZGCKttOQ@mail.gmail.com>
References: <20141216094854.22639.69181.sendpatchset@w520> <1418731028.WfBPmyK53y@avalon> <CANqRtoTpSadrrpeBxA-ym4MZBfhY_BEyTPr_sfau8dZGCKttOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

On Tuesday 16 December 2014 20:46:33 Magnus Damm wrote:
> On Tue, Dec 16, 2014 at 8:20 PM, Laurent Pinchart wrote:
> > On Tuesday 16 December 2014 12:14:40 Daniel Lezcano wrote:
> >> On 12/16/2014 10:48 AM, Magnus Damm wrote:
> >> > From: Magnus Damm <damm+renesas@opensource.se>
> >> > 
> >> > Update the TMU driver to use cpu_possible_mask as cpumask to make
> >> > r8a7779 SMP work as expected with or without the ARM TWD timer.
> >> > 
> >> > Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
> >> 
> >> Applied as a 3.18 fix.
> > 
> > You're a bit too fast, I haven't had time to review the patch yet.
> > 
> >> ps: May I suggest to use the CLOCK_EVT_FEAT_DYNIRQ flag for this driver ?
> >> 
> >> > ---
> >> > 
> >> >   drivers/clocksource/sh_tmu.c |    2 +-
> >> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >> > 
> >> > --- 0001/drivers/clocksource/sh_tmu.c
> >> > +++ work/drivers/clocksource/sh_tmu.c       2014-12-16
> >> > 17:49:49.000000000 +0900 @@ -428,7 +428,7 @@ static void
> >> > sh_tmu_register_clockevent(s
> >> >     ced->features = CLOCK_EVT_FEAT_PERIODIC;
> >> >     ced->features |= CLOCK_EVT_FEAT_ONESHOT;
> >> >     ced->rating = 200;
> >> > -   ced->cpumask = cpumask_of(0);
> >> > +   ced->cpumask = cpu_possible_mask;
> > 
> > Magnus, how thoroughly have you tested this ? The TMU is indeed usable by
> > all CPUs, so setting the CPU mask to cpu_possible_mask makes sense, but
> > last time I've tried that it broke the broadcast timer due to the
> > heuristics used by the clock events core code.
> 
> Uhm, so I've tested this particular patch on r8a7779 but I do agree
> that the TMU is used on a bunch of SoCs if that's what you mean. I
> don't see how it is different from any other of our timers though, and
> those got fixed like this earlier.
> 
> I wonder if you may recall an earlier issue with incorrect clock event
> priorities and code somehow working-by-accident without the mask set
> as expected?

As discussed privately today, I've had this exact same patch in one of my 
private branches, and I haven't pushed it upstream at the same time as the 
similar cmt and mtu2 patches due to a regression. Unfortunately I don't 
remember the details :-/

I'll test the patch on Marzen and KZM9G. I unfortunately can't test it on 
Armadillo as I don't have access to that board anymore.

> > Could you please confirm that you've tested both CONFIG_PREEMPT_NONE and
> > CONFIG_PREEMPT with and without the ARM TWD times, and that you've booted
> > to userspace and tested timer broadcast on all CPUs ?
> 
> No I have not. I've booted to user space in initramfs with DT-based
> TWD on Multiplatform for r8a7779. Without this fix (and other r8a7779
> TWD bits) I see a lot of breakage. For instance, TWD and SMP boot is
> broken on r8a7779 - both legacy and non-legacy. I have not gotten to
> sh73a0 yet, but I assume it is busted too.
> 
> Can you please explain to me how the TMU is any different compared to
> the CMT, MTU2 or STI? =)

I don't know yet :-) I'll hopefully have more information after testing on 
KZM9G.

> And no, I don't have any r8a7740 board anymore. Can anyone else test?

-- 
Regards,

Laurent Pinchart


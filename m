Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaLQMEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 07:04:53 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:49598 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaLQMEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 07:04:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] clocksource: sh_tmu: Set cpu_possible_mask to fix SMP broadcast
Date: Wed, 17 Dec 2014 14:04:55 +0200
Message-ID: <4785362.yhOOf0IjKV@avalon>
User-Agent: KMail/4.14.3 (Linux/3.16.5-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <CAMuHMdXmzah7xZMb+y_0HHE5aeOr_efCv9GZhPutjWxb39WCCw@mail.gmail.com>
References: <20141216094854.22639.69181.sendpatchset@w520> <CAMuHMdWT+yytt1mRZPLvzyXACcw638Sf4DBjHUTf_+iPjsNzbA@mail.gmail.com> <CAMuHMdXmzah7xZMb+y_0HHE5aeOr_efCv9GZhPutjWxb39WCCw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Wednesday 17 December 2014 10:42:52 Geert Uytterhoeven wrote:
> On Wed, Dec 17, 2014 at 9:30 AM, Geert Uytterhoeven wrote:
> > On Wed, Dec 17, 2014 at 3:08 AM, Laurent Pinchart wrote:
> >>>> Kzm9g-reference still hangs at "Calibrating local timer..." (it did
> >>>> work at some point in the past).
> >> 
> >> kzm9g-reference boots for me with kzm9g_defconfig on Simon's devel branch
> >> with
> >>
> > OK.
> > 
> > I had expected the breakage to be something in my tree, either an issue in
> > a -next branch I'm using, an interaction with the CCF patches or so, or a
> > config issue (e.g. CONFIG_CPU_IDLE became broken lately if the TWD is
> > not in DT).
> 
> Kzm9g-reference hangs at "Calibrating local timer..." because I added the
> TWD to sh73a0.dtsi (http://www.spinics.net/lists/arm-kernel/msg383413.html).
> 
> As twd_get_clock() does
> 
>         if (np)
>                 twd_clk = of_clk_get(np, 0);
>         else
>                 twd_clk = clk_get_sys("smp_twd", NULL);
> 
> it's not DT-without-CCF proof, and kzm9g-reference cannot get its clock :-(
> 
> So the TWD node should be in sh73a0-kzm9g-multiplatform.dts, and we need
> more dts files instead of less...
> 
> Note that I added the TWD node to DT to fix a hang on kzm9g-multiplatform
> with CONFIG_CPU_IDLE=y (recently introduced "regression" in core code)
> after:
> 
>      DMA: preallocated 256 KiB pool for atomic coherent allocations
> 
> On kzm9g-legacy the TWD is instantiated from C board code
> (machine_desc.init_time = sh73a0_earlytimer_init), so CONFIG_CPU_IDLE=y
> does not hang. Despite https://lkml.org/lkml/2014/12/2/339.
> 
> On kzm9g-reference, the TWD is not instantiated, causing the same hang.
> If I instantiate the TWD from C board code there, it fails with
> 
>     twd: can't register interrupt 29 (-22)
> 
> which looks like a symptom of https://lkml.org/lkml/2014/12/2/339
> 
> So no cookies for users of several -legacy and -reference platforms in
> v3.19-rc1 this Monday...

I'm not sure if fixing that would be worth it. Should we instead try to 
replace kzm9g-legacy and kzm9g-reference by kzm9g-multiplatform in v3.20 ? 
What are we missing ?

- The DIV6 multiparent series has been merged by Mike, and the sh73a0 CCF is 
nearly ready.

- We need proper BSC support to get LAN working, although it could be worked 
around temporarily by specifying the BSC clock in the LAN node if I recall 
correctly.

- MMCIF and SDHI are present.

- Sound support is there as far as I can tell, but possibly without DMA.

- Touchscreen and magnetometer have DT bindings but are not instantiated in 
the dts at the moment. That should be easy to fix.

- Accelerometer and RTC have no DT bindings, but they should work with the I2C 
core OF match support.

- We're loosing USBHS (driver supports OF but doesn't cover sh73a0), USB host 
(no OF support in driver) and LCDC (no OF support in driver).

All but USBHS, USB host and LCDC should be possible to support in v3.20 
without too much issues, depending on the effort we can put in this.

-- 
Regards,

Laurent Pinchart


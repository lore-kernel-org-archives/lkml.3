Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaLQJm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:42:56 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:55186 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaLQJmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:42:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWT+yytt1mRZPLvzyXACcw638Sf4DBjHUTf_+iPjsNzbA@mail.gmail.com>
References: <20141216094854.22639.69181.sendpatchset@w520>
	<CAMuHMdUzys9pbEjUybyDP-3=uemLZuP5WgXeyONxGmADUJJL4A@mail.gmail.com>
	<CANqRtoRTcC_ixjY_Qr1T=2Jhh9qu_5+=Z3YRBDUJX8HWHP6Nog@mail.gmail.com>
	<2855304.l47b4KVhTf@avalon>
	<CAMuHMdWT+yytt1mRZPLvzyXACcw638Sf4DBjHUTf_+iPjsNzbA@mail.gmail.com>
Date: Wed, 17 Dec 2014 10:42:52 +0100
X-Google-Sender-Auth: weGywYwtPGwbYYtjVMM1bLfBySg
Message-ID: <CAMuHMdXmzah7xZMb+y_0HHE5aeOr_efCv9GZhPutjWxb39WCCw@mail.gmail.com>
Subject: Re: [PATCH] clocksource: sh_tmu: Set cpu_possible_mask to fix SMP broadcast
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent, Magnus,

On Wed, Dec 17, 2014 at 9:30 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Wed, Dec 17, 2014 at 3:08 AM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>>> > Kzm9g-reference still hangs at "Calibrating local timer..." (it did work
>>> > at some point in the past).
>>
>> kzm9g-reference boots for me with kzm9g_defconfig on Simon's devel branch with
>
> OK.
>
> I had expected the breakage to be something in my tree, either an issue in
> a -next branch I'm using, an interaction with the CCF patches or so, or a
> config issue (e.g. CONFIG_CPU_IDLE became broken lately if the TWD is
> not in DT).

Kzm9g-reference hangs at "Calibrating local timer..." because I added the
TWD to sh73a0.dtsi (http://www.spinics.net/lists/arm-kernel/msg383413.html).

As twd_get_clock() does

        if (np)
                twd_clk = of_clk_get(np, 0);
        else
                twd_clk = clk_get_sys("smp_twd", NULL);

it's not DT-without-CCF proof, and kzm9g-reference cannot get its clock :-(

So the TWD node should be in sh73a0-kzm9g-multiplatform.dts, and we need
more dts files instead of less...

Note that I added the TWD node to DT to fix a hang on kzm9g-multiplatform
with CONFIG_CPU_IDLE=y (recently introduced "regression" in core code) after:

     DMA: preallocated 256 KiB pool for atomic coherent allocations

On kzm9g-legacy the TWD is instantiated from C board code
(machine_desc.init_time = sh73a0_earlytimer_init), so CONFIG_CPU_IDLE=y
does not hang. Despite https://lkml.org/lkml/2014/12/2/339.

On kzm9g-reference, the TWD is not instantiated, causing the same hang.
If I instantiate the TWD from C board code there, it fails with

    twd: can't register interrupt 29 (-22)

which looks like a symptom of https://lkml.org/lkml/2014/12/2/339

So no cookies for users of several -legacy and -reference platforms in v3.19-rc1
this Monday...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

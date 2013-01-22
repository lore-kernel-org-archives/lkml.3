Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab3AVCLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 21:11:11 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:39987 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab3AVCLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 21:11:10 -0500
MIME-Version: 1.0
In-Reply-To: <50FDEBF8.3090902@linaro.org>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com>
 <201301212041.17951.arnd@arndb.de> <50FDAC5F.4040605@linaro.org>
 <CAKGA1b=D5CNikijoOAk5xP6TC-nB_gEGtS05ncrPR68sQTMrxw@mail.gmail.com>
 <50FDC2DD.7090406@linaro.org> <CAKGA1bmtTH1N8nx79MGiMighdQROpNtpvAZXhHKT+mT3kcazBQ@mail.gmail.com>
 <50FDE2AE.8030608@linaro.org> <CAKGA1bkXx2qn+c6sKqXsty-aFe1r-W79uyem0O8p6JNeeq6zxQ@mail.gmail.com>
 <50FDEBF8.3090902@linaro.org>
From: Matt Sealey <matt@genesi-usa.com>
Date: Mon, 21 Jan 2013 20:10:48 -0600
Message-ID: <CAKGA1bmpL-PyyMENmwgH9WNmdQ=+1oXrtDo+0OLffdvTChpLFQ@mail.gmail.com>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.


On Mon, Jan 21, 2013 at 7:31 PM, John Stultz <john.stultz@linaro.org> wrote:
> On 01/21/2013 05:06 PM, Matt Sealey wrote:
>>
>> On Mon, Jan 21, 2013 at 6:51 PM, John Stultz <john.stultz@linaro.org>
>> wrote:
>>>
>>> On 01/21/2013 02:54 PM, Matt Sealey wrote:
>>>>
>>>> On Mon, Jan 21, 2013 at 4:36 PM, John Stultz <john.stultz@linaro.org>
>>>> wrote:
>>>>>
>>>>> On 01/21/2013 01:14 PM, Matt Sealey wrote:
>>>
>>> As far as jiffies rating, from jiffies.c:
>>>      .rating        = 1, /* lowest valid rating*/
>>>
>>> So I'm not sure what you mean by "the debug on the kernel log is telling
>>> me
>>> it has a higher resolution".
>>
>> Oh, it is just if I actually don't run setup_sched_clock on my
>> platform, it gives a little message (with #define DEBUG 1 in
>> sched_clock.c) about who setup the last sched_clock. Since you only
>> get one chance, and I was fiddling with setup_sched_clock being probed
>> from multiple possible timers from device tree (i.MX3 has a crapload
>> of valid timers, which one you use right now is basically forced by
>> the not-quite-fully-DT-only code and some funky iomap tricks).
>>
>> And what I got was, if I use the real hardware timer, it runs at 66MHz
>> and says it has 15ns resolution and wraps every 500 seconds or so. The
>> jiffies timer says it's 750MHz, with a 2ns resoluton.. you get the
>> drift. The generic reporting of how "good" the sched_clock source is
>> kind of glosses over the quality rating of the clock source and at
>> first glance (if you're not paying that much attention), it is a
>> little bit misleading..
>
>
> I've got no clue on this. sched_clock is arch specific, and while ARM does
> use clocksources for sched_clock, what you're seeing is a detail of the ARM
> implementation and not the clocksource code (one complication is that
> clocksources rating values are for the requirements of timekeeping, which
> are different then the requirements for sched_clock - so the confusion is
> understandable).
>
>
>
>>> Yes, in the case I was remembering, the 60HZ was driven by the electrical
>>> line.
>>
>> While I have your attention, what would be the minimum "good" speed to
>> run the sched_clock or delay timer implementation from? My rudimentary
>> scribblings in my notebook give me a value of "don't bother" with less
>> than 10KHz based on HZ=100, so I'm wondering if a direct 32.768KHz
>> clock would do (i.MX osc clock input if I can supply it to one of the
>> above myriad timers) since this would be low-power compared to a 66MHz
>> one (by a couple mA anyway). I also have a bunch of questions about
>> the delay timer requirements.. I might mail you personally.. or would
>> you prefer on-list?
>
> So there are probably other folks who could better comment on sched_clock()
> or the delay timer (I'm guessing the delay() implementation is what you mean
> by that) design trade-offs.

I'm specifically talking about if I do

static struct delay_timer imx_gpt_delay_timer = {
        .read_current_timer = imx_gpt_read_current_timer,
};

and then something like:

imx_gpt_delay_timer.freq = clk_get_rate(clk_per);
register_current_timer_delay(&imx_gpt_delay_timer);

In the sense that now (as of kernel 3.7 iirc), I have an ability to
have the delay implementation use this awesome fast accessor (which is
nothing to do with a 'clocksource' as in the subsystem..) to get to my
(here at least) 66.5MHz counter (up or down, i.MX has both, but I
dunno if you can use a down counter for delay_timer, or if that's
preferred, or what.. there are no examples of it.. but it seems to
work.. that said I can't imagine what would be an immediately visible
and not totally random effect of doing it "wrong", maybe that delays
are instantly returned, that could be very hard or impossible to ever
notice compared to not being able to browse the internet on the target
device.. it might pop up on some randomly-not-resetting platform
device or so, though..)

And I can also put sched_clock on a completely different timer. Does
that make any sense at all? I wouldn't know, it's not documented.

And if I wanted to I could register 8 more timers. That seems rather
excessive, but the ability to use those extra 8 as clock outputs from
the SoC or otherwise directly use comparators is useful to some
people, does Linux in general really give a damn about having 8 timers
of the same quality being available when most systems barely have two
clocksources anyway (on x86, tsc and hpet - on ARM I guess twd and
some SoC-specific timer). I dunno how many people might actually want
to define in a device tree, but I figure every single one is not a bad
thing and which ones end up as sched_clock, delay_timer or just plain
registered clocksources, or not registered as a clocksource and
accessed as some kind of comparator through some kooky ioctl API, is
something you would also configure...

> But again, someone more familiar with the scheduler and driver requirements
> would probably be more informational.

Okay. I assume that's a combination of Russell and Thomas..

-- 
Matt Sealey

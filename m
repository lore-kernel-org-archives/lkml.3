Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3AVBbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 20:31:40 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:40821 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3AVBbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 20:31:39 -0500
Message-ID: <50FDEBF8.3090902@linaro.org>
Date: Mon, 21 Jan 2013 17:31:36 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matt Sealey <matt@genesi-usa.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <201301212041.17951.arnd@arndb.de> <50FDAC5F.4040605@linaro.org> <CAKGA1b=D5CNikijoOAk5xP6TC-nB_gEGtS05ncrPR68sQTMrxw@mail.gmail.com> <50FDC2DD.7090406@linaro.org> <CAKGA1bmtTH1N8nx79MGiMighdQROpNtpvAZXhHKT+mT3kcazBQ@mail.gmail.com> <50FDE2AE.8030608@linaro.org> <CAKGA1bkXx2qn+c6sKqXsty-aFe1r-W79uyem0O8p6JNeeq6zxQ@mail.gmail.com>
In-Reply-To: <CAKGA1bkXx2qn+c6sKqXsty-aFe1r-W79uyem0O8p6JNeeq6zxQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 05:06 PM, Matt Sealey wrote:
> On Mon, Jan 21, 2013 at 6:51 PM, John Stultz <john.stultz@linaro.org> wrote:
>> On 01/21/2013 02:54 PM, Matt Sealey wrote:
>>> On Mon, Jan 21, 2013 at 4:36 PM, John Stultz <john.stultz@linaro.org>
>>> wrote:
>>>> On 01/21/2013 01:14 PM, Matt Sealey wrote:
>> As far as jiffies rating, from jiffies.c:
>>      .rating        = 1, /* lowest valid rating*/
>>
>> So I'm not sure what you mean by "the debug on the kernel log is telling me
>> it has a higher resolution".
> Oh, it is just if I actually don't run setup_sched_clock on my
> platform, it gives a little message (with #define DEBUG 1 in
> sched_clock.c) about who setup the last sched_clock. Since you only
> get one chance, and I was fiddling with setup_sched_clock being probed
> from multiple possible timers from device tree (i.MX3 has a crapload
> of valid timers, which one you use right now is basically forced by
> the not-quite-fully-DT-only code and some funky iomap tricks).
>
> And what I got was, if I use the real hardware timer, it runs at 66MHz
> and says it has 15ns resolution and wraps every 500 seconds or so. The
> jiffies timer says it's 750MHz, with a 2ns resoluton.. you get the
> drift. The generic reporting of how "good" the sched_clock source is
> kind of glosses over the quality rating of the clock source and at
> first glance (if you're not paying that much attention), it is a
> little bit misleading..

I've got no clue on this. sched_clock is arch specific, and while ARM 
does use clocksources for sched_clock, what you're seeing is a detail of 
the ARM implementation and not the clocksource code (one complication is 
that clocksources rating values are for the requirements of timekeeping, 
which are different then the requirements for sched_clock - so the 
confusion is understandable).


>> Yes, in the case I was remembering, the 60HZ was driven by the electrical
>> line.
> While I have your attention, what would be the minimum "good" speed to
> run the sched_clock or delay timer implementation from? My rudimentary
> scribblings in my notebook give me a value of "don't bother" with less
> than 10KHz based on HZ=100, so I'm wondering if a direct 32.768KHz
> clock would do (i.MX osc clock input if I can supply it to one of the
> above myriad timers) since this would be low-power compared to a 66MHz
> one (by a couple mA anyway). I also have a bunch of questions about
> the delay timer requirements.. I might mail you personally.. or would
> you prefer on-list?
So there are probably other folks who could better comment on 
sched_clock() or the delay timer (I'm guessing the delay() 
implementation is what you mean by that) design trade-offs.

My first *guess* would be that for delay, you probably want a counter 
that has half-usec granularity or finer (~5Mhz), since udelay is likely 
the most common usage, and coarser then that and you might cause driver 
issues.  Though you could probably get away with a cpu loop based delay 
and avoid requiring a high res counter.

For sched_clock(), the standard reply is probably "as fast and as 
fine-graned as you can get".  But as far as a lower-bound, I'd expect 
the CONFIG_HZ value would be a good bet, as many systems use jiffies for 
their sched_clock without major issue, though I'm sure there are 
interactivity trade-offs.

But again, someone more familiar with the scheduler and driver 
requirements would probably be more informational.

thanks
-john



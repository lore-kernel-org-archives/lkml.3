Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaEGSKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 14:10:07 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33377 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaEGSKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 14:10:04 -0400
Message-ID: <536A76F9.3090908@linaro.org>
Date: Wed, 07 May 2014 11:10:01 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: David Riley <davidriley@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Add test to validate udelay
References: <1399421543-7751-1-git-send-email-davidriley@chromium.org>	<53697D7D.4020908@linaro.org> <CAD=FV=VqPFcAFMfRi2L=QiRJ1qP8fokycmPxrjOi4mPv2W9NMA@mail.gmail.com>
In-Reply-To: <CAD=FV=VqPFcAFMfRi2L=QiRJ1qP8fokycmPxrjOi4mPv2W9NMA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 09:19 PM, Doug Anderson wrote:
> John,
>
> On Tue, May 6, 2014 at 5:25 PM, John Stultz <john.stultz@linaro.org> wrote:
>> On 05/06/2014 05:12 PM, David Riley wrote:
>>> This change adds a module and a script that makes use of it to
>>> validate that udelay delays for at least as long as requested
>>> (as compared to ktime).
>> Interesting.
>>
>> So fundamentally, udelay is a good bit fuzzier accuracy wise then
>> ktime_get(), as it may be backed by relatively coarsely calibrated delay
>> loops, or very rough tsc freq estimates.
>>
>> ktime_get on the other hand is as fine grained as we can be, and is ntp
>> corrected, so that a second can really be a second.
>>
>> So your comparing the fast and loose interface so we can delay a bit
>> before hitting some hardware again with a fairly precise interface.
>> Thus  I'd not be surprised if your test failed on various hardware. I'd
>> really only trust udelay to be roughly accurate, so you might want to
>> consider adding some degree of acceptable error to the test.
> My understanding is that udelay should be >= the true delay.
> Specifically it tends to be used when talking to hardware.  We used it
> to ensure a minimum delay between SPI transactions when talking to a
> slow embedded controller.  I think the regulator code uses udelay() to
> wait for voltage to ramp up, for instance.  Waiting too long isn't
> terrible, but too short is bad.
>
> That being said, I think if udelay was within 1% we're probably OK.  I
> believe I have seen systems where udelay is marginally shorter than it
> ought to be and it didn't upset me too much.

Yea,  udelay() should clearly delay for greater then or equal to the
time requested. The worry I have is that we're measuring that time with
two different clocks, so the larger the delay the more likely the time
error between those two clocks will be apparent (particularly with one
being very coarsely calibrated and the other being ntp corrected).

But these sorts of differences should be well within 0.1%.  So for most
reasonable delays this should be mostly hidden by the measuring overhead
and not likely a problem with your test. I just wanted to be sure we
weren't in a situation where folks were expecting udelay to be ntp
corrected ;)



>
>> Really, I'm curious about the backstory that made you generate the test?
>> I assume something bit you where udelay was way off? Or were you using
>> udelay for some sort of accuracy sensitive use?
> Several times we've seen cases where udelay() was pretty broken with
> cpufreq if you were actually implementing udelay() with
> loops_per_jiffy.  I believe it may also be broken upstream on
> multicore systems, though now that ARM arch timers are there maybe we
> don't care as much?
>
> Specifically, there is a lot of confusion between the global loops per
> jiffy and the per CPU one.  On ARM I think we always use the global
> one and we attempt to scale it as cpufreq changes.  ...but...
>
> * cores tend scale together and there's a single global.  That means
> you might have started the delay loop at one freq and ended it at
> another (if another CPU changes the freq).

Good point. The loops based delay would clearly be broken w/ ASMP unless
we use per-cpu values that are scaled(and as you point out, we don't
scale the value mid-delay). Time based counters for udelay() - like the
arch timer you mention - are a much better way to work around this.


> * I believe there's some strange issues in terms of how the loops per
> jiffy variable is initialized and how the "original CPU freq" is.  I
> know we ran into issues on big.LITTLE where the LITTLE cores came up
> and clobbered the loops_per_jiffy variable but it was still doing math
> based on the big cores.

Hrm. I don't have a theory on this right now, but clearly there are
issues to be resolved, so having your tests included would be a good
thing to help find these issues.

So no objections from me. Thanks for the extra context!

thanks
-john




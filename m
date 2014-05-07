Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaEGETq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 00:19:46 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63933 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaEGETo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 00:19:44 -0400
MIME-Version: 1.0
In-Reply-To: <53697D7D.4020908@linaro.org>
References: <1399421543-7751-1-git-send-email-davidriley@chromium.org>
	<53697D7D.4020908@linaro.org>
Date: Tue, 6 May 2014 21:19:43 -0700
X-Google-Sender-Auth: Lhts2Qd3rERZWb9jw0AxL1yTbMg
Message-ID: <CAD=FV=VqPFcAFMfRi2L=QiRJ1qP8fokycmPxrjOi4mPv2W9NMA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Add test to validate udelay
From: Doug Anderson <dianders@chromium.org>
To: John Stultz <john.stultz@linaro.org>
Cc: David Riley <davidriley@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John,

On Tue, May 6, 2014 at 5:25 PM, John Stultz <john.stultz@linaro.org> wrote:
> On 05/06/2014 05:12 PM, David Riley wrote:
>> This change adds a module and a script that makes use of it to
>> validate that udelay delays for at least as long as requested
>> (as compared to ktime).
>
> Interesting.
>
> So fundamentally, udelay is a good bit fuzzier accuracy wise then
> ktime_get(), as it may be backed by relatively coarsely calibrated delay
> loops, or very rough tsc freq estimates.
>
> ktime_get on the other hand is as fine grained as we can be, and is ntp
> corrected, so that a second can really be a second.
>
> So your comparing the fast and loose interface so we can delay a bit
> before hitting some hardware again with a fairly precise interface.
> Thus  I'd not be surprised if your test failed on various hardware. I'd
> really only trust udelay to be roughly accurate, so you might want to
> consider adding some degree of acceptable error to the test.

My understanding is that udelay should be >= the true delay.
Specifically it tends to be used when talking to hardware.  We used it
to ensure a minimum delay between SPI transactions when talking to a
slow embedded controller.  I think the regulator code uses udelay() to
wait for voltage to ramp up, for instance.  Waiting too long isn't
terrible, but too short is bad.

That being said, I think if udelay was within 1% we're probably OK.  I
believe I have seen systems where udelay is marginally shorter than it
ought to be and it didn't upset me too much.


> Really, I'm curious about the backstory that made you generate the test?
> I assume something bit you where udelay was way off? Or were you using
> udelay for some sort of accuracy sensitive use?

Several times we've seen cases where udelay() was pretty broken with
cpufreq if you were actually implementing udelay() with
loops_per_jiffy.  I believe it may also be broken upstream on
multicore systems, though now that ARM arch timers are there maybe we
don't care as much?

Specifically, there is a lot of confusion between the global loops per
jiffy and the per CPU one.  On ARM I think we always use the global
one and we attempt to scale it as cpufreq changes.  ...but...

* cores tend scale together and there's a single global.  That means
you might have started the delay loop at one freq and ended it at
another (if another CPU changes the freq).

* I believe there's some strange issues in terms of how the loops per
jiffy variable is initialized and how the "original CPU freq" is.  I
know we ran into issues on big.LITTLE where the LITTLE cores came up
and clobbered the loops_per_jiffy variable but it was still doing math
based on the big cores.


-Doug

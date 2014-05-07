Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaEGXyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 19:54:46 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64794 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaEGXyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 19:54:45 -0400
MIME-Version: 1.0
In-Reply-To: <536AB7D5.30006@linaro.org>
References: <1399421543-7751-1-git-send-email-davidriley@chromium.org>
	<53697D7D.4020908@linaro.org>
	<CAD=FV=VqPFcAFMfRi2L=QiRJ1qP8fokycmPxrjOi4mPv2W9NMA@mail.gmail.com>
	<536A76F9.3090908@linaro.org>
	<CAD=FV=VF8S6m8Liwkk5NNxkDz-khvRZmuNUaNDX2i_9Zuvxswg@mail.gmail.com>
	<536AB7D5.30006@linaro.org>
Date: Wed, 7 May 2014 16:54:44 -0700
X-Google-Sender-Auth: n0y1g4gmmDtHzs3DTwEzqjjL5J0
Message-ID: <CAD=FV=UcBjP5i4UimOk17832R_hmOuTRF8=E=ZNp-DCq9jhZug@mail.gmail.com>
Subject: Re: [PATCH 0/2] Add test to validate udelay
From: Doug Anderson <dianders@chromium.org>
To: John Stultz <john.stultz@linaro.org>
Cc: David Riley <davidriley@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John,

On Wed, May 7, 2014 at 3:46 PM, John Stultz <john.stultz@linaro.org> wrote:
> On 05/07/2014 11:32 AM, Doug Anderson wrote:
>> John,
>>
>> On Wed, May 7, 2014 at 11:10 AM, John Stultz <john.stultz@linaro.org> wrote:
>>> On 05/06/2014 09:19 PM, Doug Anderson wrote:
>>>> John,
>>>>
>>>> On Tue, May 6, 2014 at 5:25 PM, John Stultz <john.stultz@linaro.org> wrote:
>>>>> Really, I'm curious about the backstory that made you generate the test?
>>>>> I assume something bit you where udelay was way off? Or were you using
>>>>> udelay for some sort of accuracy sensitive use?
>>>> Several times we've seen cases where udelay() was pretty broken with
>>>> cpufreq if you were actually implementing udelay() with
>>>> loops_per_jiffy.  I believe it may also be broken upstream on
>>>> multicore systems, though now that ARM arch timers are there maybe we
>>>> don't care as much?
>>>>
>>>> Specifically, there is a lot of confusion between the global loops per
>>>> jiffy and the per CPU one.  On ARM I think we always use the global
>>>> one and we attempt to scale it as cpufreq changes.  ...but...
>>>>
>>>> * cores tend scale together and there's a single global.  That means
>>>> you might have started the delay loop at one freq and ended it at
>>>> another (if another CPU changes the freq).
>>> Good point. The loops based delay would clearly be broken w/ ASMP unless
>>> we use per-cpu values that are scaled(and as you point out, we don't
>>> scale the value mid-delay). Time based counters for udelay() - like the
>>> arch timer you mention - are a much better way to work around this.
>> Locally we have this:
>> * https://chromium-review.googlesource.com/189885
>>   ARM: Don't ever downscale loops_per_jiffy in SMP systems
>>
>> I didn't think upstream would really want this given the move to arch
>> timers, but I'm happy to post it.
>
> Might be good just to get the discussion going. I agree its probably not
> the best solution, and likely the timer delay is the right path, but but
> I think we need to have some rails in place so that other folks don't
> trip over this.
>
> Maybe a combination of your change and something where on systems that
> see cpufreq changes (or cores with different frequencies) complain
> loudly if they're not configured to use the delay timer?

I thew the patch up there.  I didn't add any loud complaining, but I
certainly can if people think that the patches are useful and they'd
like the complaining.

https://patchwork.kernel.org/patch/4132521/


>>>> * I believe there's some strange issues in terms of how the loops per
>>>> jiffy variable is initialized and how the "original CPU freq" is.  I
>>>> know we ran into issues on big.LITTLE where the LITTLE cores came up
>>>> and clobbered the loops_per_jiffy variable but it was still doing math
>>>> based on the big cores.
>>> Hrm. I don't have a theory on this right now, but clearly there are
>>> issues to be resolved, so having your tests included would be a good
>>> thing to help find these issues.
>> Locally we added:
>> * https://chromium-review.googlesource.com/189725
>>   init: Don't decrease loops_per_jiffy when a CPU comes up
>>
>> ...and that "fixed" things for us.  Specifically what happened was:
>>
>> - A15s boot up at 1.8GHz (though they can actually go up to 1.9/2.0).
>>
>> - A7s boot up at ~600MHz and clobbered loops_per_jiffy with something tiny.
>>
>> - In the first "cpufreq_callback" in "arch/arm/kernel/smp.c", we
>> stored the current _A15_ frequency upon the first cpufreq transition
>> and the current _A7_ loops per jiffy (since the A7s clobbered it).
>>
>>
>> It seemed like our situation was so messed up that upstream probably
>> wouldn't want the fix (using loops_per_jiffy in an HMP system is
>> pretty insane), but again I'm happy to send it up.
>
> Yea. Again, might be good to send it out just so more folks are aware
> (particularly outside the arm world) that ASMP systems are here and the
> generic delay infrastructure has assumptions that are not compatible.

Here ya go: <https://patchwork.kernel.org/patch/4132651/>

-Doug

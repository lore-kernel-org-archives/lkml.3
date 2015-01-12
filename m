Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbbALShC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:37:02 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:32939 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbbALSg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:36:59 -0500
MIME-Version: 1.0
In-Reply-To: <20150111114724.GE4467@localhost.localdomain>
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
	<1420850068-27828-4-git-send-email-john.stultz@linaro.org>
	<20150111114724.GE4467@localhost.localdomain>
Date: Mon, 12 Jan 2015 10:36:58 -0800
Message-ID: <CALAqxLWnAQhVzJH4VzVN9oyYAPu88R1jX3CvDatrra8XKC1djw@mail.gmail.com>
Subject: Re: [PATCH 03/10] clocksource: Remove clocksource_max_deferment()
From: John Stultz <john.stultz@linaro.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 3:47 AM, Richard Cochran
<richardcochran@gmail.com> wrote:
>
> This series added:
>
> +       /* Return 50% of the actual maximum, so we can detect bad values */
> +       max_nsecs >>= 1;
>
> and then...
>
> On Fri, Jan 09, 2015 at 04:34:21PM -0800, John Stultz wrote:
>> @@ -760,7 +746,8 @@ void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
>>               cs->maxadj = clocksource_max_adjustment(cs);
>>       }
>>
>> -     cs->max_idle_ns = clocksource_max_deferment(cs);
>> +     cs->max_idle_ns = clocks_calc_max_nsecs(cs->mult, cs->shift,
>> +                                              cs->maxadj, cs->mask);
>>  }
>>  EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);
>>
>> @@ -807,7 +794,8 @@ int clocksource_register(struct clocksource *cs)
>>               cs->name);
>>
>>       /* calculate max idle time permitted for this clocksource */
>> -     cs->max_idle_ns = clocksource_max_deferment(cs);
>> +     cs->max_idle_ns = clocks_calc_max_nsecs(cs->mult, cs->shift,
>> +                                              cs->maxadj, cs->mask);
>
> ... the whole world's maximum idle time is artificially reduced by
> half in order to catch some rare HW bug?  Not a very green solution.

So, the first patch had a cleanup which removed case where the max
mult value was being calculated assuming nanoseconds was a s64 instead
of a u64, which resulted in the max_idle_ns to be halved. So this
doesn't actually cost us more over what the current kernel does.

In fact, the cleanup removed the extra 12.5% reductions that were
applied, so for the HPET in qemu on my system, the max idle goes from
~16 secs to ~21 secs with this patchset (if I'm remembering
correctly).

But I'm open to put this under a debug config if its justified (part
of Linus' concern w/ clocksource code is that its had a few spots that
were needlessly complex, so some weighing of performance/power vs
simplified logic should be done). Do you have a specific case in mind
that you're worried about?

thanks
-john

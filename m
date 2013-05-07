Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121Ab3EGAK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 20:10:29 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:36691 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab3EGAK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 20:10:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130506230137.GA16801@amd.pavel.ucw.cz>
References: <20130430074322.GA20110@gmail.com>
	<20130506230137.GA16801@amd.pavel.ucw.cz>
Date: Mon, 6 May 2013 17:10:27 -0700
X-Google-Sender-Auth: n5Oj4oV3nKR8S9zWpes0k0Ayo5E
Message-ID: <CANcMJZAxA75K+i0GSxV=z_14YU3vkv81h0Op9yKa1sM2ygBHqg@mail.gmail.com>
Subject: Re: [GIT PULL] timer changes for v3.10
From: John Stultz <john.stultz@linaro.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 4:01 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>>  - suspend/resume enhancements by Feng Tang: on certain new Intel Atom
>>    processors (Penwell and Cloverview), there is a feature that the TSC
>>    won't stop in S3 state, so the TSC value won't be reset to 0 after
>>    resume. This can be taken advantage of by the generic via the
>>    CLOCK_SOURCE_SUSPEND_NONSTOP flag: instead of using the RTC to
>>    recover/approximate sleep time, the main (and precise) clocksource can
>>    be used.
>
> Ok, so for system time, we use three different timers:
>
> 1) RTC, while system is off
>
> 2) PIT, while system is running (plus TSC for parts of second)

? We've not used interpolated timekeeping (PIT + TSC) since
2.6.18/2.6.21. Instead only a single clocksource is used (TSC, hpet,
acpi_pm being the most common on x86, and PIT or jiffies on much older
systems).


> 3) TSC, while system is sleeping

So this is only used when the TSC has the SUSPEND_NONSTOP flag.
Otherwise we use the CMOS/RTC clock.

> Now. we have ntpd that is trying to compute "speed of clock", and
> adjust accordingly (adjtimex). But will it still do the right thing
> when we switch to different source during sleep?

Its true any frequency error we have will grow during suspend.
Additionally, if the frequency of the hardware changes during suspend,
correcting that will be difficult as well.  It has yet to be seen how
the TSC hardware that enabled this NONSTOP flag will preform in this
regard. If it proves problematic, we'll likely have to add additional
checks against the RTC.

Even so, I suspect the hardware that likely to gain this feature is
targeted for mobile devices where they're likely to wake up
periodically. In this case, the extra precision of the fine-grained
clocksource, compared to the second granular CMOS is a much greater
benefit, as injecting 1second of error on each suspend/resume cycle
isn't good for timekeeping either.

Additionally, some ARM boards do something very similar with the
32k-timer (albeit hidden behind the persistent_clock interface) so we
should eventually be able to share the logic here.


> And is the TSC even good enough? According to man page, PIT is not
> precise enough, so we sync from RTC every 11 minutes. I'd imagine TSC

?? I think you're confusing the RTC being synced to the system time
every 11 minutes while we're in sync w/ ntp servers here.

thanks
-john

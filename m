Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaFEROJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:14:09 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:47687 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaFEROH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:14:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAKfTPtBeYMW7kOrAhVrqoWhTHfLAtcMeY9FXxZpm7CNAM7NdaA@mail.gmail.com>
References: <1401903034-20074-1-git-send-email-dianders@chromium.org>
	<1401903034-20074-2-git-send-email-dianders@chromium.org>
	<CAKfTPtBeYMW7kOrAhVrqoWhTHfLAtcMeY9FXxZpm7CNAM7NdaA@mail.gmail.com>
Date: Thu, 5 Jun 2014 10:14:05 -0700
X-Google-Sender-Auth: uPLgVFQoUv8KpJ0po2nfwHIQ_BY
Message-ID: <CAD=FV=Xy84f=KFO4SLmW27=ztt_hxSiBMJSMAwhw9RxKAaFU-Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] clocksource: exynos_mct: cache mct upper count
From: Doug Anderson <dianders@chromium.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Chirantan Ekbote <chirantan@chromium.org>,
        David Riley <davidriley@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Mandeep Singh Baines <msb@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vincent,

On Thu, Jun 5, 2014 at 12:55 AM, Vincent Guittot
<vincent.guittot@linaro.org> wrote:
> On 4 June 2014 19:30, Doug Anderson <dianders@chromium.org> wrote:
>> From: Mandeep Singh Baines <msb@chromium.org>
>>
>> Saves one register read.  Note that the upper count only changes every
>> ~178 seconds with a 24MHz source clock, so it's likely it hasn't
>> changed from call to call.
>
> Hi Doug,
>
> Have you checked that the time saved in using a 32bits counter instead
> of a 64bits one is not lost in the handle of the wrap of sched_clock
> which occurs every 178s instead of never ?
>
> sched_clock_poll function will be called every 178s

Probably should move this to the discussion in the other patch where
we're talking about moving to 32-bits?

...but in general I have no benchmarks at all that how much the
scheduler is affected by this change.  All of my benchmarks are based
on gettimeofday(), where the improvement is clear.  Do you have a
suggested way to check?

I think that it's pretty clear that we'll want to take either the
32-bit conversion or the 64-bit optimizations I sent out.  If you take
out gettimeofday() overhead, I believe that the actual read of the MCT
(exynos_frc_read) took about:
* ~800ns per call with the original 64-bit code
* ~500ns per call with the optimized 64-bit code (both patch 2 and 3)
* ~500ns per call with the 32-bit code

The 32-bit code is slightly faster but not significantly (like 530ns
vs 500ns).  ...but it is definitely simpler.

If we find that the schedule clock wrap overhead is real then that
would be a good reason to take the 64-bit version.

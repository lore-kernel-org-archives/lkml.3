Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbaALRQt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 12:16:49 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19598 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaALRQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 12:16:47 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-6c-52d2cdfc1b49
Message-id: <52D2CDFA.9050501@samsung.com>
Date: Sun, 12 Jan 2014 21:16:42 +0400
From: Alexey Perevalov <a.perevalov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Anton Vorontsov <anton@enomsg.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] Deferrable timers support for timerfd API
References: <1388687448-12987-1-git-send-email-a.perevalov@samsung.com>
 <52C5F38D.5060201@linaro.org> <52C6F722.3090704@samsung.com>
 <52C75353.8060505@linaro.org> <52C9B39C.2000901@samsung.com>
 <CALAqxLXvK0Ptob-6kXVXnHdpo4JfwzvKmd41SG77Uq0=yY=ZPg@mail.gmail.com>
In-reply-to: <CALAqxLXvK0Ptob-6kXVXnHdpo4JfwzvKmd41SG77Uq0=yY=ZPg@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t/xq7p/zl4KMvjYy24xZ/0aNouDWzUt
	zvzWtTjb9Ibd4vKuOWwOrB4T+j8xety5tofN48SM3ywefVtWMXp83iQXwBrFZZOSmpNZllqk
	b5fAlbFq0nzGggMiFR23VrI1MB4X6GLk5JAQMJGYPv83M4QtJnHh3nq2LkYuDiGBpYwSy7eu
	ZIFwPjNKXFrazwpSxSugJbFmyxuwDhYBVYmdK+YAxTk42AQMJPbdswUxRQUiJI4u14SoFpT4
	MfkeC4gtIqAhsXDJVSaQkcwg8+dsnMkEkhAWcJLYNf8lE8SuHiaJ7U1rwTo4BYIlnn7eAbaX
	WcBaYuWkbYwQtrzE5jVvmScwCsxCsmQWkrJZSMoWMDKvYhRNLU0uKE5KzzXSK07MLS7NS9dL
	zs/dxAgJ5687GJceszrEKMDBqMTD++LoxSAh1sSy4srcQ4wSHMxKIrznTlwKEuJNSaysSi3K
	jy8qzUktPsTIxMEp1cCon+esoLB02pZtsQwBnWcTyheln9mfeMj7x1XuydaZBlfkCzdse/ZE
	4aMrD+f743nRB9P6vSc7JbBuWc1RJMhn0VDnKq+T7nNh2aPClUc0Jb7/j5RllEo90WqxOXSH
	7vbzd+9tMg1sb9kmknmTM7xB+7bpsp+ZLfmem5atzv4RrpfZGfO+64YSS3FGoqEWc1FxIgD3
	md0RRQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 12:32 AM, John Stultz wrote:
> On Sun, Jan 5, 2014 at 11:33 AM, Alexey Perevalov
> <a.perevalov@samsung.com> wrote:
>> On 01/04/2014 04:18 AM, John Stultz wrote:
>>> So while the alarm timers are a reasonable precedent, I think they were
>>> introduced prior to the timerfd interface, so it seemed at the time
>>> having new clockids for the functionality was required to work with the
>>> existing syscalls that use the clockid (Though in retrospect, I question
>>> if it would have been better to use timer flags to introduce the alarm
>>> functionality rather then introducing it via a clockid, as it would
>>> simplify the clockid definitions).
>> As I understood alarm and deferrability it's type of repetition (timer
>> trigger condition),
>> but REALTIME, BOOTTIME, MONOTONIC it's a type of time representation.
>> Mixed it in one clockid, maybe it's a controversially. Which flags do you
>> want to use, flags of timerfd_settime?
> Well, my first reaction was just to suggest you create a new timer
> flag (like TIMER_ABSTIME) TIMER_DEFER, which we could then consider
> adapting as a new flag value for all the timer related code
> (posix-timers, nanosleep, etc).
>
> Then looking closer at the timerfd code, I see I wasn't aware there's
> some additional constraints as the timerfd flags overlap with many of
> the file O_ flags, and that the timerfd has its own TFD_TIMER_ABSTIME.
>   I'm not quite sure I recall the context of that decision, so it might
> be good to involve those who recall more of that history. So I'm not
> sure which particular bit flag would be best to take there. Anton's
> patch took (1<<2), so I'm guessing that's still ok.
>
> Anyway, adding something like a TFD_TIMER_DEFER along with TIMER_DEFER
> would seem to me like a reasonable approach.
>
> Addtionally the TFD_CANCEL_ON_SET is interesting in that we don't have
> a similar flag for the posix timers interfaces. Do you think there's
> any value in looking into unifying that as well?
Posix timer doens't have cancel_list ability right now.
Do you want to add such ability?
With posix timer there is no problem of interference O_ flags,
and flag for posix timer might have the same value as 
TFD_TIMER_CANCEL_ON_SET,
and appropriate name.

Version of Anton's patches with flag based interface I'll send tomorrow.
But with little modification in overruns, I think evaluation
based on hrtimer for overrun is not proper way for deferrable timer, because
in most cases number of deferrable ticks is lesser.

> thanks
> -john
>


-- 
Best regards,
Alexey Perevalov

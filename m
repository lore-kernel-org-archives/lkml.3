Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbaAIUdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 15:33:09 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38471 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089AbaAIUc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 15:32:58 -0500
MIME-Version: 1.0
In-Reply-To: <52C9B39C.2000901@samsung.com>
References: <1388687448-12987-1-git-send-email-a.perevalov@samsung.com>
	<52C5F38D.5060201@linaro.org>
	<52C6F722.3090704@samsung.com>
	<52C75353.8060505@linaro.org>
	<52C9B39C.2000901@samsung.com>
Date: Thu, 9 Jan 2014 12:32:58 -0800
Message-ID: <CALAqxLXvK0Ptob-6kXVXnHdpo4JfwzvKmd41SG77Uq0=yY=ZPg@mail.gmail.com>
Subject: Re: [PATCH 0/3] Deferrable timers support for timerfd API
From: John Stultz <john.stultz@linaro.org>
To: Alexey Perevalov <a.perevalov@samsung.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Anton Vorontsov <anton@enomsg.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 5, 2014 at 11:33 AM, Alexey Perevalov
<a.perevalov@samsung.com> wrote:
> On 01/04/2014 04:18 AM, John Stultz wrote:
>>
>> So while the alarm timers are a reasonable precedent, I think they were
>> introduced prior to the timerfd interface, so it seemed at the time
>> having new clockids for the functionality was required to work with the
>> existing syscalls that use the clockid (Though in retrospect, I question
>> if it would have been better to use timer flags to introduce the alarm
>> functionality rather then introducing it via a clockid, as it would
>> simplify the clockid definitions).
>
> As I understood alarm and deferrability it's type of repetition (timer
> trigger condition),
> but REALTIME, BOOTTIME, MONOTONIC it's a type of time representation.
> Mixed it in one clockid, maybe it's a controversially. Which flags do you
> want to use, flags of timerfd_settime?

Well, my first reaction was just to suggest you create a new timer
flag (like TIMER_ABSTIME) TIMER_DEFER, which we could then consider
adapting as a new flag value for all the timer related code
(posix-timers, nanosleep, etc).

Then looking closer at the timerfd code, I see I wasn't aware there's
some additional constraints as the timerfd flags overlap with many of
the file O_ flags, and that the timerfd has its own TFD_TIMER_ABSTIME.
 I'm not quite sure I recall the context of that decision, so it might
be good to involve those who recall more of that history. So I'm not
sure which particular bit flag would be best to take there. Anton's
patch took (1<<2), so I'm guessing that's still ok.

Anyway, adding something like a TFD_TIMER_DEFER along with TIMER_DEFER
would seem to me like a reasonable approach.

Addtionally the TFD_CANCEL_ON_SET is interesting in that we don't have
a similar flag for the posix timers interfaces. Do you think there's
any value in looking into unifying that as well?

thanks
-john

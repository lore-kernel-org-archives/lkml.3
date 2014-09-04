Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbaIDVSC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:18:02 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:43515 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbaIDVSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:18:00 -0400
MIME-Version: 1.0
In-Reply-To: <CALAqxLUHt=+L4XHFqsfNnB8LExtptXkqW58vKZ4JzwN49D+hOw@mail.gmail.com>
References: <1407456558-18509-1-git-send-email-ahh@google.com>
	<CALAqxLUHt=+L4XHFqsfNnB8LExtptXkqW58vKZ4JzwN49D+hOw@mail.gmail.com>
Date: Thu, 4 Sep 2014 14:17:59 -0700
Message-ID: <CADroS=5BcPqCdgYAMfdyod1PNeYFU_qQXNYYQnoPAtB6RdCLWQ@mail.gmail.com>
Subject: Re: [PATCH] sched: fix timeval conversion to jiffies
From: Andrew Hunter <ahh@google.com>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Phil Miller <unmobile@gmail.com>, Paul Turner <pjt@google.com>,
        Aaron Jacobs <jacobsa@google.com>, Ingo Molnar <mingo@elte.hu>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 3, 2014 at 5:06 PM, John Stultz <john.stultz@linaro.org> wrote:
> Maybe with the next version of the patch, before you get into the
> unwinding the math, you might practically describe what is broken,
> then explain how its broken.
>

Done.

> My quick read here is that we're converting a timespec -> jiffies, and
> in doing so we round up by one jiffy.
>
> This seems actually perfectly normal, as we usually end up rounding up
> by a jiffy in many cases since we don't want to undershoot any
> timeout, and we're always allowed return later then specified.

Well, yes, timeouts can be longer than specified, but what you said
technically applies just as much to code that arbitrarily multiplies
jiffies by 10 before returning, no? :)

The problem isn't the rounding, it's that the rounding is _wrong_: I'm
fine rounding 10100usec / (1000 usec/jiffie) = 11 jiffies. The current
code rounds 10000usec / (1000 usec/jiffies) to 11.  I've rewritten the
description to make this clearer.

>
>> In particular, with HZ=1000, we consistently computed that 10000 usec
>> was 11 jiffies; the same was true for any exact multiple of
>> TICK_NSEC. This is obviously bad as a general rule, and caused
>> observable user problems with setitimer() at the very least:
>>
>> setitimer(ITIMER_PROF, &val, NULL);
>> setitimer(ITIMER_PROF, NULL, &val);
>>
>> would actually add a tick to val!
>
> So this looks like an issue. Since we convert and store the internal
> representation in jiffies, when we pull it back out, we get the
> rounded up value, which is larger then the timespec value originally
> submitted.  This is really the core issue, correct?

For the particular user bug reported to me, yes, this was the core
issue: some code that stopped and restarted an itimer found the
interval growing by 1ms each time.  But again, it wasn't that it was
rounded:  if we initially passed e.g. 10500 usec and got back 11000,
that'd be annoying but workable, because if we then went through
another cycle of enabling/disabling itimer, we'd set it to 11000 usec
and get back 11000 again.  What we have now instead adds a full jiffie
_every time_.

> Or does this
> manifest in other ways that are problematic (the patch seems to hint
> that it does)?
>

Um: hard to be sure. I can tell you that for PROF itimers we track the
difference between the requested timeval in ns and the given number of
jiffies (see the logic with it->error in check_cpu_itimer() in
kernel/posix-cpu-timers.c), so over long periods we'll get the right
sample rate (the only problem is the timeval reported back to
userspace, and the samples might not quite be uniform.)  It appears
there are no other uses of timeval_to_jiffies, so we're probably safe.
But in any case it's wrong as currently coded so we should fix it.

(Actually, one could use the same code tracking it->error to always
return the exact--unrounded--interval to userspace, but that's minor
compared to a constantly growing interval, and I'd rather not
complicate this patch any more.)

>> +       nsec = nsec + TICK_NSEC - 1;
>
>
> If we're still rounding up one tick here, does the same issue not persist?
>

Nope (at least not in tested configurations.) Since jiffie is
effectively defined as some integral number of nsec, this rounding
DTRT to round up to an integral number of jiffies. (The scaled
arithmetic might, for sufficiently large intervals/right values of
timeval produce some error, but I haven't been able to make it do so.)

> Overall the patch doesn't look too bad and does reduce the amount of
> ugly math with simpler code reuse.  But I'd like the patch description
> to be more clear about why this is needed and the impact.
>

Rewritten; sending v2.

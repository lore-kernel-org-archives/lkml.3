Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbaIDVbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:31:00 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:65457 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311AbaIDVa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:30:58 -0400
MIME-Version: 1.0
In-Reply-To: <CADroS=5BcPqCdgYAMfdyod1PNeYFU_qQXNYYQnoPAtB6RdCLWQ@mail.gmail.com>
References: <1407456558-18509-1-git-send-email-ahh@google.com>
	<CALAqxLUHt=+L4XHFqsfNnB8LExtptXkqW58vKZ4JzwN49D+hOw@mail.gmail.com>
	<CADroS=5BcPqCdgYAMfdyod1PNeYFU_qQXNYYQnoPAtB6RdCLWQ@mail.gmail.com>
Date: Thu, 4 Sep 2014 14:30:56 -0700
Message-ID: <CALAqxLWp3-BfgN_CUrvCForKNgxvsSW74WisuqT+8n6x6A=OhQ@mail.gmail.com>
Subject: Re: [PATCH] sched: fix timeval conversion to jiffies
From: John Stultz <john.stultz@linaro.org>
To: Andrew Hunter <ahh@google.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Phil Miller <unmobile@gmail.com>, Paul Turner <pjt@google.com>,
        Aaron Jacobs <jacobsa@google.com>, Ingo Molnar <mingo@elte.hu>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 2:17 PM, Andrew Hunter <ahh@google.com> wrote:
> On Wed, Sep 3, 2014 at 5:06 PM, John Stultz <john.stultz@linaro.org> wrote:
>> Maybe with the next version of the patch, before you get into the
>> unwinding the math, you might practically describe what is broken,
>> then explain how its broken.
>>
>> My quick read here is that we're converting a timespec -> jiffies, and
>> in doing so we round up by one jiffy.
>>
>> This seems actually perfectly normal, as we usually end up rounding up
>> by a jiffy in many cases since we don't want to undershoot any
>> timeout, and we're always allowed return later then specified.
>
> Well, yes, timeouts can be longer than specified, but what you said
> technically applies just as much to code that arbitrarily multiplies
> jiffies by 10 before returning, no? :)
>
> The problem isn't the rounding, it's that the rounding is _wrong_: I'm
> fine rounding 10100usec / (1000 usec/jiffie) = 11 jiffies. The current
> code rounds 10000usec / (1000 usec/jiffies) to 11.  I've rewritten the
> description to make this clearer.

Ok. Very much appreciated!

>>> In particular, with HZ=1000, we consistently computed that 10000 usec
>>> was 11 jiffies; the same was true for any exact multiple of
>>> TICK_NSEC. This is obviously bad as a general rule, and caused
>>> observable user problems with setitimer() at the very least:
>>>
>>> setitimer(ITIMER_PROF, &val, NULL);
>>> setitimer(ITIMER_PROF, NULL, &val);
>>>
>>> would actually add a tick to val!
>>
>> So this looks like an issue. Since we convert and store the internal
>> representation in jiffies, when we pull it back out, we get the
>> rounded up value, which is larger then the timespec value originally
>> submitted.  This is really the core issue, correct?
>
> For the particular user bug reported to me, yes, this was the core
> issue: some code that stopped and restarted an itimer found the
> interval growing by 1ms each time.  But again, it wasn't that it was
> rounded:  if we initially passed e.g. 10500 usec and got back 11000,
> that'd be annoying but workable, because if we then went through
> another cycle of enabling/disabling itimer, we'd set it to 11000 usec
> and get back 11000 again.  What we have now instead adds a full jiffie
> _every time_.

Ah, ok. This part is key to understanding the problem. Thanks for
clarifying this.

This seems to be a quite old bug.. Do you think this is needed for -stable?

thanks
-john

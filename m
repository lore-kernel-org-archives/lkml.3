Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbbAVUzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:55:10 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:46356 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbbAVUzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:55:06 -0500
MIME-Version: 1.0
In-Reply-To: <20150114093539.GM23965@worktop.programming.kicks-ass.net>
References: <1420850068-27828-1-git-send-email-john.stultz@linaro.org>
	<1420850068-27828-7-git-send-email-john.stultz@linaro.org>
	<20150113111146.GL23965@worktop.programming.kicks-ass.net>
	<CALAqxLVFLAjCD2Vw6Zue=+RU2GSspCDTBTeRAv-EQMy3iA6oBw@mail.gmail.com>
	<20150114093539.GM23965@worktop.programming.kicks-ass.net>
Date: Thu, 22 Jan 2015 12:55:05 -0800
Message-ID: <CALAqxLW0gzWS6kB0d6dMM8rkq3-OFuPdSrB=x2EWffwAF3dTJA@mail.gmail.com>
Subject: Re: [PATCH 06/10] time: Cap clocksource reads to the clocksource
 max_cycles value
From: John Stultz <john.stultz@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 1:35 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jan 13, 2015 at 01:33:29PM -0800, John Stultz wrote:
>> On Tue, Jan 13, 2015 at 3:11 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Fri, Jan 09, 2015 at 04:34:24PM -0800, John Stultz wrote:
>> >> When calculating the current delta since the last tick, we
>> >> currently have no hard protections to prevent a multiplciation
>> >> overflow from ocurring.
>> >>
>> >> This patch introduces such a cap that limits the read delta
>> >> value to the max_cycles value, which is where an overflow would
>> >> occur.
>> >
>> >> +++ b/kernel/time/timekeeping.c
>> >> @@ -202,6 +202,9 @@ static inline s64 timekeeping_get_ns(struct tk_read_base *tkr)
>> >>       /* calculate the delta since the last update_wall_time: */
>> >>       delta = clocksource_delta(cycle_now, tkr->cycle_last, tkr->mask);
>> >>
>> >> +     /* Cap delta value to the max_cycles values to avoid mult overflows */
>> >> +     delta = min(delta, tkr->clock->max_cycles);
>> >> +
>> >>       nsec = delta * tkr->mult + tkr->xtime_nsec;
>> >>       nsec >>= tkr->shift;
>> >>
>> >
>> > So while I appreciate stuff can be broken, should we not at least keep
>> > track of this brokenness? That is, we all agree bad things happened IF
>> > we actually hit this, right? So should we then not inform people that
>> > bad things did happen?
>>
>> So since this is a time reading function, this could be called
>> anywhere. So I'm hesitant to try to printk anything in such a hot
>> path. Though, if we catch such a large delta during the timekeeping
>> update function, we will print a warning (which is done in an earlier
>> patch in the series).
>>
>> Were you thinking of something else maybe? I guess we could set a flag
>> and then print later (if there is a later), but we'd lose much of the
>> context of what went wrong.
>
> Maybe a stats counter? In any case, keeping it silent seems the wrong
> thing.

So I spent a bit of time looking into if we could track if we were
actually seeing underflows, and to do some rate limited printing in a
different context to provide some warning.

Luckily this found one bug with my underflow checking logic (falsely
triggering if delta was zero), but even then I was occasionally seeing
reports of underflows on my test systems using the hpet (as well as
other clocksources). I added a bunch of extra debug logic and started
to see really strange underflow behavior, where hardware reads were
returning values slightly before cycle_last.

Then after banging my head on it a bit with a knot in my stomach that
I've uncovered a bigger issue, I realized that we're in a seqlock
loop. Duh. So the data reads are done optimistically and we throw away
any reads that might have raced with the writer. So I was doing a
hardware read, then having an interrupt land and update the cycle_last
state with even newer time, then go back see the negative delta, flag
to report a warning, then throw all the data away because we noticed
the seqlock was updated.

So this makes it a little hard to have the protective capping /
underflow logic also trigger a warning, because they may trigger in
many cases where the data is all junk and we're going to repeat the
calculation anyway. Its also a bit nested down a few functions below
where we actually take the seqlock, so we'd probably have to leave the
capping alone and then find some way to capture and sanity check the
data points after we left the lock. That gets a bit ugly.

I'll see if I can't sort out something better, but I'll probably drop
the reporting patch I was working on before resending this series.

thanks
-john

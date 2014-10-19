Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaJSW6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:58:17 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:49543 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaJSW6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:58:16 -0400
MIME-Version: 1.0
In-Reply-To: <20141019222004.GI23531@worktop.programming.kicks-ass.net>
References: <cover.1413323611.git.luto@amacapital.net> <b6c264b3bb064658af498763e234e3cb4f9db4e2.1413323612.git.luto@amacapital.net>
 <CALCETrXRGNeUipujcGiT30SV+MDHCFpTxG7LOTXj4Z4CbtxdJQ@mail.gmail.com>
 <CALCETrXv=bWUqVWhCekjq3UQeLFgGcbocKFjtNiNqm6DhyPmzA@mail.gmail.com>
 <20141019213341.GF23531@worktop.programming.kicks-ass.net>
 <CALCETrVT9vHjBRRvhTayqfOEebMjyVU9Yw7v80D6EPAmcyREZw@mail.gmail.com> <20141019222004.GI23531@worktop.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 19 Oct 2014 15:57:54 -0700
Message-ID: <CALCETrXzwA3JH8xYLFcLdUSXAJi05Q62dZP3yOjZJTxgVugDrQ@mail.gmail.com>
Subject: Re: [RFC 5/5] x86,perf: Only allow rdpmc if a perf_event is mapped
To: Peter Zijlstra <peterz@infradead.org>
Cc: Erik Bosman <ebn310@few.vu.nl>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Kees Cook <keescook@chromium.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 3:20 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sun, Oct 19, 2014 at 03:05:42PM -0700, Andy Lutomirski wrote:
>> On Oct 19, 2014 2:33 PM, "Peter Zijlstra" <peterz@infradead.org> wrote:
>
>> > > Also, I don't understand the purpose of cap_user_time.  Wouldn't it be
>> > > easier to just record the last CLOCK_MONOTONIC time and let the user
>> > > call __vdso_clock_gettime if they need an updated time?
>> >
>> > Because perf doesn't use CLOCK_MONOTONIC. Due to performance
>> > considerations we used the sched_clock stuff, which tries its best to
>> > make the best of the TSC without reverting to HPET and the like.
>> >
>> > Not to mention that CLOCK_MONOTONIC was not available from NMI context
>> > until very recently.
>>
>> I'm only talking about the userspace access to when an event was
>> enabled and how long it's been running.  I think that's what the
>> cap_user_time stuff is for.  I don't think those parameters are
>> touched from NMI, right?
>>
>> Point taken about sched_clock, though.
>
> Well, mixing two time bases, one TSC based and one CLOCK_MONOTONIC is
> just asking for trouble IMO ;-)

Fair enough.

>
>> > Also, things like c73deb6aecda ("perf/x86: Add ability to calculate TSC
>> > from perf sample timestamps") seem to suggest people actually use TSC
>> > for things as well.
>> >
>> > Now we might change to using the new NMI safe CLOCK_MONOTONIC (with a
>> > fallback to use the sched_clock stuff on time challenged hardware) in
>> > order to ease the correlation between other trace thingies, but even
>> > then it makes sense to have this, having it here and reading the TSC
>> > within the seqcount loop ensures you've got consistent data and touch
>> > less cachelines for reading.
>>
>> True.
>>
>> OTOH, people (i.e. I) have optimized the crap out of
>> __vdso_clock_gettime, and __vdso_perf_event_whatever could be
>> similarly optimized.
>
> Maybe, but at that point we commit to yet another ABI... I'd rather just
> put a 'sane' implementation in a library or so.

This cuts both ways, though.  For vdso timekeeping, the underlying
data structure has changed repeatedly, sometimes to add features, and
sometimes for performance, and the vdso has done a good job insulating
userspace from it.  (In fact, until 3.16, even the same exact kernel
version couldn't be relied on to have the same data structure with
different configs, and even now, no one really wants to teach user
libraries how to parse the pvclock data structures.)

I would certainly not suggest putting anything beyond the bare minimum
into the vdso.

FWIW, something should probably specify exactly when it's safe to try
a userspace rdpmc.  I think that the answer is that, for a perf event
watching a pid, only that pid can do it (in particular, other threads
must not try).  For a perf event monitoring a whole cpu, the answer is
less clear to me.

--Andy

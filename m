Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbaJSWGI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:06:08 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:37655 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaJSWGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:06:04 -0400
MIME-Version: 1.0
In-Reply-To: <20141019213341.GF23531@worktop.programming.kicks-ass.net>
References: <cover.1413323611.git.luto@amacapital.net> <b6c264b3bb064658af498763e234e3cb4f9db4e2.1413323612.git.luto@amacapital.net>
 <CALCETrXRGNeUipujcGiT30SV+MDHCFpTxG7LOTXj4Z4CbtxdJQ@mail.gmail.com>
 <CALCETrXv=bWUqVWhCekjq3UQeLFgGcbocKFjtNiNqm6DhyPmzA@mail.gmail.com> <20141019213341.GF23531@worktop.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 19 Oct 2014 15:05:42 -0700
Message-ID: <CALCETrVT9vHjBRRvhTayqfOEebMjyVU9Yw7v80D6EPAmcyREZw@mail.gmail.com>
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

On Oct 19, 2014 2:33 PM, "Peter Zijlstra" <peterz@infradead.org> wrote:
>
> On Sun, Oct 19, 2014 at 01:23:17PM -0700, Andy Lutomirski wrote:
> > On Thu, Oct 16, 2014 at 5:00 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> > > The current cap_user_rdpmc code seems rather confused to me.  On x86,
> > > *all* events set cap_user_rdpmc if the global rdpmc control is set.
> > > But only x86_pmu events define .event_idx, so amd uncore events won't
> > > actually expose their rdpmc index to userspace.
> > >
> > > Would it make more sense to add a flag PERF_X86_EVENT_RDPMC_PERMITTED
> > > that gets set on all events created while rdpmc == 1, to change
> > > x86_pmu_event_idx to do something like:
> > >
> > > if (event->hw.flags & PERF_X86_EVENT_RDPMC_PERMITTED)
> > >   return event->hw.event_base_rdpmc + 1;
> > > else
> > >   return 0;
> > >
> > > and to change arch_perf_update_userpage cap_user_rdpmc to match
> > > PERF_X86_EVENT_RDPMC_PERMITTED?
> > >
> > > Then we could ditch the static key and greatly simplify writes to the
> > > rdpmc flag by just counting PERF_X86_EVENT_RDPMC_PERMITTED events.
> > >
> > > This would be a user-visible change on AMD, and I can't test it.
> > >
> > >
> > > On a semi-related note: would this all be nicer if there were vdso
> > > function __u64 __vdso_perf_event__read_count(int fd, void *userpage)?
> > > This is very easy to do nowadays.  If we got *really* fancy, it would
> > > be possible to have an rdpmc_safe in the vdso, which has some
> > > benefits, although it would be a bit evil and wouldn't work if
> > > userspace tracers like pin are in use.
> > >
> >
> > Also, I don't understand the purpose of cap_user_time.  Wouldn't it be
> > easier to just record the last CLOCK_MONOTONIC time and let the user
> > call __vdso_clock_gettime if they need an updated time?
>
> Because perf doesn't use CLOCK_MONOTONIC. Due to performance
> considerations we used the sched_clock stuff, which tries its best to
> make the best of the TSC without reverting to HPET and the like.
>
> Not to mention that CLOCK_MONOTONIC was not available from NMI context
> until very recently.

I'm only talking about the userspace access to when an event was
enabled and how long it's been running.  I think that's what the
cap_user_time stuff is for.  I don't think those parameters are
touched from NMI, right?

Point taken about sched_clock, though.

>
> Also, things like c73deb6aecda ("perf/x86: Add ability to calculate TSC
> from perf sample timestamps") seem to suggest people actually use TSC
> for things as well.
>
> Now we might change to using the new NMI safe CLOCK_MONOTONIC (with a
> fallback to use the sched_clock stuff on time challenged hardware) in
> order to ease the correlation between other trace thingies, but even
> then it makes sense to have this, having it here and reading the TSC
> within the seqcount loop ensures you've got consistent data and touch
> less cachelines for reading.

True.

OTOH, people (i.e. I) have optimized the crap out of
__vdso_clock_gettime, and __vdso_perf_event_whatever could be
similarly optimized.

--Andy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaJSWUQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:20:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52837 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaJSWUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:20:13 -0400
Date: Mon, 20 Oct 2014 00:20:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Erik Bosman <ebn310@few.vu.nl>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Kees Cook <keescook@chromium.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Subject: Re: [RFC 5/5] x86,perf: Only allow rdpmc if a perf_event is mapped
Message-ID: <20141019222004.GI23531@worktop.programming.kicks-ass.net>
References: <cover.1413323611.git.luto@amacapital.net>
 <b6c264b3bb064658af498763e234e3cb4f9db4e2.1413323612.git.luto@amacapital.net>
 <CALCETrXRGNeUipujcGiT30SV+MDHCFpTxG7LOTXj4Z4CbtxdJQ@mail.gmail.com>
 <CALCETrXv=bWUqVWhCekjq3UQeLFgGcbocKFjtNiNqm6DhyPmzA@mail.gmail.com>
 <20141019213341.GF23531@worktop.programming.kicks-ass.net>
 <CALCETrVT9vHjBRRvhTayqfOEebMjyVU9Yw7v80D6EPAmcyREZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVT9vHjBRRvhTayqfOEebMjyVU9Yw7v80D6EPAmcyREZw@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 03:05:42PM -0700, Andy Lutomirski wrote:
> On Oct 19, 2014 2:33 PM, "Peter Zijlstra" <peterz@infradead.org> wrote:

> > > Also, I don't understand the purpose of cap_user_time.  Wouldn't it be
> > > easier to just record the last CLOCK_MONOTONIC time and let the user
> > > call __vdso_clock_gettime if they need an updated time?
> >
> > Because perf doesn't use CLOCK_MONOTONIC. Due to performance
> > considerations we used the sched_clock stuff, which tries its best to
> > make the best of the TSC without reverting to HPET and the like.
> >
> > Not to mention that CLOCK_MONOTONIC was not available from NMI context
> > until very recently.
> 
> I'm only talking about the userspace access to when an event was
> enabled and how long it's been running.  I think that's what the
> cap_user_time stuff is for.  I don't think those parameters are
> touched from NMI, right?
> 
> Point taken about sched_clock, though.

Well, mixing two time bases, one TSC based and one CLOCK_MONOTONIC is
just asking for trouble IMO ;-)

> > Also, things like c73deb6aecda ("perf/x86: Add ability to calculate TSC
> > from perf sample timestamps") seem to suggest people actually use TSC
> > for things as well.
> >
> > Now we might change to using the new NMI safe CLOCK_MONOTONIC (with a
> > fallback to use the sched_clock stuff on time challenged hardware) in
> > order to ease the correlation between other trace thingies, but even
> > then it makes sense to have this, having it here and reading the TSC
> > within the seqcount loop ensures you've got consistent data and touch
> > less cachelines for reading.
> 
> True.
> 
> OTOH, people (i.e. I) have optimized the crap out of
> __vdso_clock_gettime, and __vdso_perf_event_whatever could be
> similarly optimized.

Maybe, but at that point we commit to yet another ABI... I'd rather just
put a 'sane' implementation in a library or so.

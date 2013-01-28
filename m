Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab3A1XRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 18:17:05 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54922 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab3A1XRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 18:17:03 -0500
Date: Tue, 29 Jan 2013 00:16:59 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 07/12] perf, x86: Avoid checkpointed counters causing excessive TSX aborts v3
Message-ID: <20130128231659.GW30577@one.firstfloor.org>
References: <1359151245-13179-1-git-send-email-andi@firstfloor.org> <1359151245-13179-8-git-send-email-andi@firstfloor.org> <CABPqkBTM8w_RVrQNiyhBprMBjL5a0Q7Y9KQsKP3Ld62EZPSufQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTM8w_RVrQNiyhBprMBjL5a0Q7Y9KQsKP3Ld62EZPSufQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't buy really this workaround. You are assuming you're always
> measuring INTC_CHECKPOINTED
> event by itself. 

There's no such assumption.

> So what if you get into the handler because of an PMI
> due to an overflow
> of another counter which is active at the same time as counter2?
> You're going to artificially
> add an overflow to counter2. Unless you're enforcing only counter2 in use.

All the code does it to always check the counter. There's no
"overflow added". For counting it may be set back and accumulated 
a bit earlier than normal, but that's no problem. This will only
happen for a checkpointed counter 2, not for anything else.

> The counter is reinstated to its state before the critical section but
> the PMI cannot be
> cancelled and there is no state left behind to tell what to do with it.

The PMI is effectively spurious, but we use it to set back. Don't know 
what you mean with "cancel". It already happened of course.


> static inline bool is_event_intx_cp(struct perf_event *event)
> {
>    return event && (event->hw.config & HSW_INTX_CHECKPOINTED);
> }

They both look the same to me.
> 
> 
> >         for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
> >                 struct perf_event *event = cpuc->events[bit];
> >
> > @@ -1615,6 +1635,20 @@ static int hsw_hw_config(struct perf_event *event)
> >              ((event->hw.config & ARCH_PERFMON_EVENTSEL_ANY) ||
> >               event->attr.precise_ip > 0))
> >                 return -EIO;
> > +       if (event->hw.config & HSW_INTX_CHECKPOINTED) {
> > +               /*
> > +                * Sampling of checkpointed events can cause situations where
> > +                * the CPU constantly aborts because of a overflow, which is
> > +                * then checkpointed back and ignored. Forbid checkpointing
> > +                * for sampling.
> > +                *
> > +                * But still allow a long sampling period, so that perf stat
> > +                * from KVM works.
> > +                */
> 
> What has perf stat have to do with sample_period?

It always uses a period to accumulate in a larger counter as you probably know.
Also with the other code we only allow checkpoint with stat.


> 
> > +               if (event->attr.sample_period > 0 &&
> > +                   event->attr.sample_period < 0x7fffffff)
> > +                       return -EIO;
> > +       }
> same comment about -EIO vs. EOPNOTSUPP. sample_period is u64
> so, it's always >= 0. Where does this 31-bit limit come from? 

That's what perf stat uses when running in the KVM guest.

> Experimentation?

The code does > 0, not >= 0

> Could be written:
>       if (event->attr.sample_period && event->attr.sample_period < 0x7fffffff)

That's 100% equivalent to what I wrote.

I can change the error value.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

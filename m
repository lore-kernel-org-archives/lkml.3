Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbaFWLiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:38:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:47042 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaFWLiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:38:03 -0400
Date: Mon, 23 Jun 2014 13:37:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Joe Mario <jmario@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/2] perf/x86: update Haswell PEBS event constraints
Message-ID: <20140623113759.GD13930@laptop.programming.kicks-ass.net>
References: <1403193509-22393-1-git-send-email-eranian@google.com>
 <1403193509-22393-2-git-send-email-eranian@google.com>
 <20140619180028.GU8178@tassilo.jf.intel.com>
 <20140623071454.GI19860@laptop.programming.kicks-ass.net>
 <CABPqkBTXNuKQKd-jFhAphmKnQ8PTdD7iQ66oYe7Uao_05rP8pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTXNuKQKd-jFhAphmKnQ8PTdD7iQ66oYe7Uao_05rP8pw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 10:06:43AM +0200, Stephane Eranian wrote:
> > @@ -1736,8 +1742,17 @@ static int intel_pmu_hw_config(struct perf_event *event)
> >         if (ret)
> >                 return ret;
> >
> > -       if (event->attr.precise_ip && x86_pmu.pebs_aliases)
> > -               x86_pmu.pebs_aliases(event);
> > +       if (event->attr.precise_ip) {
> > +               if ((event->attr.config & INTEL_ARCH_EVENT_MASK) == 0x0000)
> > +                       return -EINVAL;
> > +
> > +               if ((event->attr.config & ARCH_PERFMON_STRICT_PEBS) &&
> > +                   (x86_pmu.attr_strict_pebs || !capable(CAP_SYS_ADMIN)))
> > +                       return -EINVAL;
> > +
> I don't think filters work with any PEBS events. The event captured
> does not qualify
> for any of the filters (root or non-root).

Filters? You mean the inv,cmask etc? Well, we have the Intel provided
'cycle' events that use them, so exposing them makes sense and allows
such experimentation when we need another such alias.

> > +               if (x86_pmu.pebs_aliases)
> > +                       x86_pmu.pebs_aliases(event);
> > +       }
> >
> >         if (intel_pmu_needs_lbr_smpl(event)) {
> >                 ret = intel_pmu_setup_lbr_filter(event);
> > diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> > index ae96cfa5eddd..36b1f2afa61c 100644
> > --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> > @@ -540,6 +540,7 @@ struct event_constraint intel_core2_pebs_event_constraints[] = {
> >         INTEL_UEVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_RETIRED.MISPRED */
> >         INTEL_UEVENT_CONSTRAINT(0x1fc7, 0x1), /* SIMD_INST_RETURED.ANY */
> >         INTEL_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
> > +       INTEL_UEVENT_CONSTRAINT(0x0000, 0x1), /* generic PEBS mask */
> >         EVENT_CONSTRAINT_END
> >  };
> >
> You probably need  to explain that 0x0000 MUST be the last event in
> each table, i.e., catch all
> event.

Yeah, probably ;-) Alternatively we could make PEBS_CONSTRAINT_END that
includes it or so.

Like said (possibly in another email) this patch was a very quick draft
and I don't think I've even ran it, it was on the todo pile..

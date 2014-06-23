Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaFWLvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:51:14 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:42203 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaFWLvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:51:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140623113759.GD13930@laptop.programming.kicks-ass.net>
References: <1403193509-22393-1-git-send-email-eranian@google.com>
	<1403193509-22393-2-git-send-email-eranian@google.com>
	<20140619180028.GU8178@tassilo.jf.intel.com>
	<20140623071454.GI19860@laptop.programming.kicks-ass.net>
	<CABPqkBTXNuKQKd-jFhAphmKnQ8PTdD7iQ66oYe7Uao_05rP8pw@mail.gmail.com>
	<20140623113759.GD13930@laptop.programming.kicks-ass.net>
Date: Mon, 23 Jun 2014 13:51:12 +0200
Message-ID: <CABPqkBSVGYAHtP6xf-SdDoCN3YJbKPRx9n7xjdhhQkNTGkE_UA@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf/x86: update Haswell PEBS event constraints
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Joe Mario <jmario@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 1:37 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Jun 23, 2014 at 10:06:43AM +0200, Stephane Eranian wrote:
>> > @@ -1736,8 +1742,17 @@ static int intel_pmu_hw_config(struct perf_event *event)
>> >         if (ret)
>> >                 return ret;
>> >
>> > -       if (event->attr.precise_ip && x86_pmu.pebs_aliases)
>> > -               x86_pmu.pebs_aliases(event);
>> > +       if (event->attr.precise_ip) {
>> > +               if ((event->attr.config & INTEL_ARCH_EVENT_MASK) == 0x0000)
>> > +                       return -EINVAL;
>> > +
>> > +               if ((event->attr.config & ARCH_PERFMON_STRICT_PEBS) &&
>> > +                   (x86_pmu.attr_strict_pebs || !capable(CAP_SYS_ADMIN)))
>> > +                       return -EINVAL;
>> > +
>> I don't think filters work with any PEBS events. The event captured
>> does not qualify
>> for any of the filters (root or non-root).
>
> Filters? You mean the inv,cmask etc? Well, we have the Intel provided
> 'cycle' events that use them, so exposing them makes sense and allows
> such experimentation when we need another such alias.
>
Yes, inv, cmask, edge, any. They are ignored for the sampled instruction.
They are used to get to the PEBS trigger, then after it is the plain event/umask
for the next qualifying instruction.

I believe that the reason while cycles:pp somewhat works is because you are
after stalls. cycles:pp = uops_retired:any:cmask=1:inv. The sampled instruction
matches uops_retired:any (filters ignored). Given you are stalled,
nothing retires.
The next uops to retire (forward progress) is captured.

>> > +               if (x86_pmu.pebs_aliases)
>> > +                       x86_pmu.pebs_aliases(event);
>> > +       }
>> >
>> >         if (intel_pmu_needs_lbr_smpl(event)) {
>> >                 ret = intel_pmu_setup_lbr_filter(event);
>> > diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> > index ae96cfa5eddd..36b1f2afa61c 100644
>> > --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> > +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
>> > @@ -540,6 +540,7 @@ struct event_constraint intel_core2_pebs_event_constraints[] = {
>> >         INTEL_UEVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_RETIRED.MISPRED */
>> >         INTEL_UEVENT_CONSTRAINT(0x1fc7, 0x1), /* SIMD_INST_RETURED.ANY */
>> >         INTEL_EVENT_CONSTRAINT(0xcb, 0x1),    /* MEM_LOAD_RETIRED.* */
>> > +       INTEL_UEVENT_CONSTRAINT(0x0000, 0x1), /* generic PEBS mask */
>> >         EVENT_CONSTRAINT_END
>> >  };
>> >
>> You probably need  to explain that 0x0000 MUST be the last event in
>> each table, i.e., catch all
>> event.
>
> Yeah, probably ;-) Alternatively we could make PEBS_CONSTRAINT_END that
> includes it or so.

You could do that, though it would serve dual purpose: end marker and catch all.
>
> Like said (possibly in another email) this patch was a very quick draft
> and I don't think I've even ran it, it was on the todo pile..

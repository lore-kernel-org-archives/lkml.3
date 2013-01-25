Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab3AYP5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 10:57:22 -0500
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:46071
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755926Ab3AYP5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 10:57:20 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(z551biz98dI9371I1432I4015Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bh8275dhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1155h)
X-WSS-ID: 0MH6UYF-02-CQH-02
X-M-MSG: 
Date: Fri, 25 Jan 2013 09:56:40 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Robert Richter <rric@kernel.org>
Subject: Re: [PATCH RESEND V5 2/6] perf, amd: Generalize northbridge
 constraints code for family 15h
Message-ID: <20130125155640.GB25064@jshin-Toonie>
References: <1357847443-3878-1-git-send-email-jacob.shin@amd.com>
 <1357847443-3878-3-git-send-email-jacob.shin@amd.com>
 <CABPqkBTYeUw7Mput=ubAYiWsXSPKag1WPFN5dR=LBw3yzbk04g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CABPqkBTYeUw7Mput=ubAYiWsXSPKag1WPFN5dR=LBw3yzbk04g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 12:07:40PM +0100, Stephane Eranian wrote:
> On Thu, Jan 10, 2013 at 8:50 PM, Jacob Shin <jacob.shin@amd.com> wrote:
> > From: Robert Richter <rric@kernel.org>
> >
> > Generalize northbridge constraints code for family 10h so that later
> > we can reuse the same code path with other AMD processor families that
> > have the same northbridge event constraints.
> >
> > Signed-off-by: Robert Richter <rric@kernel.org>
> > Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> > ---
> >  arch/x86/kernel/cpu/perf_event_amd.c |   43 ++++++++++++++++++++--------------
> >  1 file changed, 25 insertions(+), 18 deletions(-)
> >
> > diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
> > index e7963c7..9541fe5 100644
> > --- a/arch/x86/kernel/cpu/perf_event_amd.c
> > +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> > @@ -188,20 +188,13 @@ static inline int amd_has_nb(struct cpu_hw_events *cpuc)
> >         return nb && nb->nb_id != -1;
> >  }
> >
> > -static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
> > -                                     struct perf_event *event)
> > +static void __amd_put_nb_event_constraints(struct cpu_hw_events *cpuc,
> > +                                          struct perf_event *event)
> >  {
> > -       struct hw_perf_event *hwc = &event->hw;
> >         struct amd_nb *nb = cpuc->amd_nb;
> >         int i;
> >
> >         /*
> > -        * only care about NB events
> > -        */
> > -       if (!(amd_has_nb(cpuc) && amd_is_nb_event(hwc)))
> > -               return;
> > -
> > -       /*
> >          * need to scan whole list because event may not have
> >          * been assigned during scheduling
> >          *
> > @@ -247,12 +240,13 @@ static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
> >    *
> >    * Given that resources are allocated (cmpxchg), they must be
> >    * eventually freed for others to use. This is accomplished by
> > -  * calling amd_put_event_constraints().
> > +  * calling __amd_put_nb_event_constraints()
> >    *
> >    * Non NB events are not impacted by this restriction.
> >    */
> >  static struct event_constraint *
> > -amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
> > +__amd_get_nb_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event,
> > +                              struct event_constraint *c)
> >  {
> >         struct hw_perf_event *hwc = &event->hw;
> >         struct amd_nb *nb = cpuc->amd_nb;
> > @@ -260,12 +254,6 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
> >         int idx, new = -1;
> >
> >         /*
> > -        * if not NB event or no NB, then no constraints
> > -        */
> > -       if (!(amd_has_nb(cpuc) && amd_is_nb_event(hwc)))
> > -               return &unconstrained;
> > -
> > -       /*
> >          * detect if already present, if so reuse
> >          *
> >          * cannot merge with actual allocation
> > @@ -275,7 +263,7 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
> >          * because of successive calls to x86_schedule_events() from
> >          * hw_perf_group_sched_in() without hw_perf_enable()
> >          */
> > -       for (idx = 0; idx < x86_pmu.num_counters; idx++) {
> > +       for_each_set_bit(idx, c->idxmsk, X86_PMC_IDX_MAX) {
> 
> So here you're using   X86_PMC_IDX_MAX but in
> __amd_put_nb_event_constraints() you're using
> x86_pmu.num_counters.
> 
> There is implicit assumption in the AMD code the counters index
> namespace is contiguous. That
> means the uncore counters show up right after the core counters. On
> Fam15h, that would be NB
> counters start at index 6, on Fam10h at index 4. In that case, the
> constraint mask cannot have bits set
> beyond num_counters, so why not use that limit in
> amd_get_event_constraints()? It would significantly
> cut down on the number of iterations in the loop from 64 down to 10 on Fam15h.

Yes, you are right, I will change that in V6.

Thanks,

> 
> 
> >                 if (new == -1 || hwc->idx == idx)
> >                         /* assign free slot, prefer hwc->idx */
> >                         old = cmpxchg(nb->owners + idx, NULL, event);
> > @@ -391,6 +379,25 @@ static void amd_pmu_cpu_dead(int cpu)
> >         }
> >  }
> >
> > +static struct event_constraint *
> > +amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
> > +{
> > +       /*
> > +        * if not NB event or no NB, then no constraints
> > +        */
> > +       if (!(amd_has_nb(cpuc) && amd_is_nb_event(&event->hw)))
> > +               return &unconstrained;
> > +
> > +       return __amd_get_nb_event_constraints(cpuc, event, &unconstrained);
> > +}
> > +
> > +static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
> > +                                     struct perf_event *event)
> > +{
> > +       if (amd_has_nb(cpuc) && amd_is_nb_event(&event->hw))
> > +               __amd_put_nb_event_constraints(cpuc, event);
> > +}
> > +
> >  PMU_FORMAT_ATTR(event, "config:0-7,32-35");
> >  PMU_FORMAT_ATTR(umask, "config:8-15"   );
> >  PMU_FORMAT_ATTR(edge,  "config:18"     );
> > --
> > 1.7.9.5
> >
> >
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab3AYP7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 10:59:32 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:12023
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756678Ab3AYP7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 10:59:30 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z551biz98dI9371I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1155h)
X-WSS-ID: 0MH6V2Y-02-02Y-02
X-M-MSG: 
Date: Fri, 25 Jan 2013 09:59:23 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND V5 4/6] perf, x86: Move MSR address offset
 calculation to architecture specific files
Message-ID: <20130125155923.GC25064@jshin-Toonie>
References: <1357847443-3878-1-git-send-email-jacob.shin@amd.com>
 <1357847443-3878-5-git-send-email-jacob.shin@amd.com>
 <CABPqkBR7KwJhPg2XJfO5d14Q4KiK7v0eqO_uyr_b6W3_nf-o-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CABPqkBR7KwJhPg2XJfO5d14Q4KiK7v0eqO_uyr_b6W3_nf-o-w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 12:15:37PM +0100, Stephane Eranian wrote:
> On Thu, Jan 10, 2013 at 8:50 PM, Jacob Shin <jacob.shin@amd.com> wrote:
> > Move counter index to MSR address offset calculation to architecture
> > specific files. This prepares the way for perf_event_amd to enable
> > counter addresses that are not contiguous -- for example AMD Family
> > 15h processors have 6 core performance counters starting at 0xc0010200
> > and 4 northbridge performance counters starting at 0xc0010240.
> >
> > Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> > ---
> >  arch/x86/kernel/cpu/perf_event.h     |   21 ++++-------------
> >  arch/x86/kernel/cpu/perf_event_amd.c |   42 ++++++++++++++++++++++++++++++++++
> >  2 files changed, 47 insertions(+), 16 deletions(-)
> >
> > diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
> > index 115c1ea..4440218 100644
> > --- a/arch/x86/kernel/cpu/perf_event.h
> > +++ b/arch/x86/kernel/cpu/perf_event.h
> > @@ -325,6 +325,7 @@ struct x86_pmu {
> >         int             (*schedule_events)(struct cpu_hw_events *cpuc, int n, int *assign);
> >         unsigned        eventsel;
> >         unsigned        perfctr;
> > +       int             (*addr_offset)(int index, int eventsel);
> >         u64             (*event_map)(int);
> >         int             max_events;
> >         int             num_counters;
> > @@ -446,28 +447,16 @@ extern u64 __read_mostly hw_cache_extra_regs
> >
> >  u64 x86_perf_event_update(struct perf_event *event);
> >
> > -static inline int x86_pmu_addr_offset(int index)
> > -{
> > -       int offset;
> > -
> > -       /* offset = X86_FEATURE_PERFCTR_CORE ? index << 1 : index */
> > -       alternative_io(ASM_NOP2,
> > -                      "shll $1, %%eax",
> > -                      X86_FEATURE_PERFCTR_CORE,
> > -                      "=a" (offset),
> > -                      "a"  (index));
> > -
> > -       return offset;
> > -}
> > -
> >  static inline unsigned int x86_pmu_config_addr(int index)
> >  {
> > -       return x86_pmu.eventsel + x86_pmu_addr_offset(index);
> > +       return x86_pmu.eventsel +
> > +               (x86_pmu.addr_offset ? x86_pmu.addr_offset(index, 1) : index);
> >  }
> >
> >  static inline unsigned int x86_pmu_event_addr(int index)
> >  {
> > -       return x86_pmu.perfctr + x86_pmu_addr_offset(index);
> > +       return x86_pmu.perfctr +
> > +               (x86_pmu.addr_offset ? x86_pmu.addr_offset(index, 0) : index);
> >  }
> Would be better to use a constant name instead of 1 and 0 to name a event_sel
> vs. a counter. It would help the reader understand what this is about
> as that may
> be useful for other processors as well.

Yes will do .. or should I use bool instead? Which would be preferred?

> 
> >  int x86_setup_perfctr(struct perf_event *event);
> > diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
> > index 0c2cc51..ef1df38 100644
> > --- a/arch/x86/kernel/cpu/perf_event_amd.c
> > +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> > @@ -132,6 +132,47 @@ static u64 amd_pmu_event_map(int hw_event)
> >         return amd_perfmon_event_map[hw_event];
> >  }
> >
> > +/*
> > + * Previously calculated offsets
> > + */
> > +static unsigned int event_offsets[X86_PMC_IDX_MAX] __read_mostly;
> > +static unsigned int count_offsets[X86_PMC_IDX_MAX] __read_mostly;
> > +
> > +/*
> > + * Legacy CPUs:
> > + *   4 counters starting at 0xc0010000 each offset by 1
> > + *
> > + * CPUs with core performance counter extensions:
> > + *   6 counters starting at 0xc0010200 each offset by 2
> > + */
> > +static inline int amd_pmu_addr_offset(int index, int eventsel)
> > +{
> > +       int offset;
> > +
> > +       if (!index)
> > +               return index;
> > +
> > +       if (eventsel)
> > +               offset = event_offsets[index];
> > +       else
> > +               offset = count_offsets[index];
> > +
> > +       if (offset)
> > +               return offset;
> > +
> > +       if (!cpu_has_perfctr_core)
> > +               offset = index;
> > +       else
> > +               offset = index << 1;
> > +
> > +       if (eventsel)
> > +               event_offsets[index] = offset;
> > +       else
> > +               count_offsets[index] = offset;
> > +
> > +       return offset;
> > +}
> > +
> >  static int amd_pmu_hw_config(struct perf_event *event)
> >  {
> >         int ret;
> > @@ -578,6 +619,7 @@ static __initconst const struct x86_pmu amd_pmu = {
> >         .schedule_events        = x86_schedule_events,
> >         .eventsel               = MSR_K7_EVNTSEL0,
> >         .perfctr                = MSR_K7_PERFCTR0,
> > +       .addr_offset            = amd_pmu_addr_offset,
> >         .event_map              = amd_pmu_event_map,
> >         .max_events             = ARRAY_SIZE(amd_perfmon_event_map),
> >         .num_counters           = AMD64_NUM_COUNTERS,
> > --
> > 1.7.9.5
> >
> >
> 


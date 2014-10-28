Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760786AbaJ1HcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:32:07 -0400
Received: from out11.biz.mail.alibaba.com ([205.204.114.131]:60489 "EHLO
	out11.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932204AbaJ1Dll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:41:41 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R281e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r46d02010;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=10;RT=10;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "'Andy Lutomirski'" <luto@amacapital.net>
Cc: "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Ingo Molnar'" <mingo@redhat.com>,
        "'Vince Weaver'" <vince@deater.net>,
        "'Paul Mackerras'" <paulus@samba.org>,
        "'Kees Cook'" <keescook@chromium.org>,
        "'Arnaldo Carvalho de Melo'" <acme@kernel.org>,
        "'Andrea Arcangeli'" <aarcange@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        "'Valdis Kletnieks'" <Valdis.Kletnieks@vt.edu>
References: <00cd01cff1b5$fda5a660$f8f0f320$@alibaba-inc.com> <CALCETrX7-OzQrOr3+TXy8NB8LS8aYwLN_A-vAeicwoQHsUH_yw@mail.gmail.com>
In-Reply-To: <CALCETrX7-OzQrOr3+TXy8NB8LS8aYwLN_A-vAeicwoQHsUH_yw@mail.gmail.com>
Subject: RE: [PATCH v2 7/8] x86, perf: Only allow rdpmc if a perf_event is mapped
Date: Tue, 28 Oct 2014 11:35:34 +0800
Message-ID: <007d01cff260$3c69e9b0$b53dbd10$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQGv8belJq57AVXnUT9ecJ/XX3ZkYAILijxMnHR8j3A=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Andy Lutomirski [mailto:luto@amacapital.net]
> Sent: Monday, October 27, 2014 11:45 PM
> To: Hillf Danton
> Cc: Peter Zijlstra; Ingo Molnar; Vince Weaver; Paul Mackerras; Kees Cook; Arnaldo Carvalho de Melo; Andrea Arcangeli; linux-
> kernel@vger.kernel.org; Valdis Kletnieks
> Subject: Re: [PATCH v2 7/8] x86, perf: Only allow rdpmc if a perf_event is mapped
> 
> >
> > >
> > > We currently allow any process to use rdpmc.  This significantly
> > > weakens the protection offered by PR_TSC_DISABLED, and it could be
> > > helpful to users attempting to exploit timing attacks.
> > >
> > > Since we can't enable access to individual counters, use a very
> > > coarse heuristic to limit access to rdpmc: allow access only when
> > > a perf_event is mmapped.  This protects seccomp sandboxes.
> > >
> > > There is plenty of room to further tighen these restrictions.  For
> > > example, this allows rdpmc for any x86_pmu event, but it's only
> > > useful for self-monitoring tasks.
> > >
> > > As a side effect, cap_user_rdpmc will now be false for AMD uncore
> > > events.  This isn't a real regression, since .event_idx is disabled
> > > for these events anyway for the time being.  Whenever that gets
> > > re-added, the cap_user_rdpmc code can be adjusted or refactored
> > > accordingly.
> > >
> > > Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> > > ---
> > >  arch/x86/include/asm/mmu.h         |  2 ++
> > >  arch/x86/include/asm/mmu_context.h | 16 +++++++++++
> > >  arch/x86/kernel/cpu/perf_event.c   | 57 +++++++++++++++++++++++++-------------
> > >  arch/x86/kernel/cpu/perf_event.h   |  2 ++
> > >  4 files changed, 58 insertions(+), 19 deletions(-)
> > >
> > > diff --git a/arch/x86/include/asm/mmu.h b/arch/x86/include/asm/mmu.h
> > > index 876e74e8eec7..09b9620a73b4 100644
> > > --- a/arch/x86/include/asm/mmu.h
> > > +++ b/arch/x86/include/asm/mmu.h
> > > @@ -19,6 +19,8 @@ typedef struct {
> > >
> > >       struct mutex lock;
> > >       void __user *vdso;
> > > +
> > > +     atomic_t perf_rdpmc_allowed;    /* nonzero if rdpmc is allowed */
> > >  } mm_context_t;
> > >
> > >  #ifdef CONFIG_SMP
> > > diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
> > > index 23697f74b372..ccad8d616038 100644
> > > --- a/arch/x86/include/asm/mmu_context.h
> > > +++ b/arch/x86/include/asm/mmu_context.h
> > > @@ -19,6 +19,18 @@ static inline void paravirt_activate_mm(struct mm_struct *prev,
> > >  }
> > >  #endif       /* !CONFIG_PARAVIRT */
> > >
> > > +#ifdef CONFIG_PERF_EVENTS
> > > +static inline void load_mm_cr4(struct mm_struct *mm)
> > > +{
> > > +     if (atomic_read(&mm->context.perf_rdpmc_allowed))
> > > +             cr4_set_bits(X86_CR4_PCE);
> > > +     else
> > > +             cr4_clear_bits(X86_CR4_PCE);
> > > +}
> > > +#else
> > > +static inline void load_mm_cr4(struct mm_struct *mm) {}
> > > +#endif
> > > +
> > >  /*
> > >   * Used for LDT copy/destruction.
> > >   */
> > > @@ -53,6 +65,9 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
> > >               /* Stop flush ipis for the previous mm */
> > >               cpumask_clear_cpu(cpu, mm_cpumask(prev));
> > >
> > > +             /* Load per-mm CR4 state */
> > > +             load_mm_cr4(next);
> > > +
> > >               /*
> > >                * Load the LDT, if the LDT is different.
> > >                *
> > > @@ -88,6 +103,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
> > >                        */
> > >                       load_cr3(next->pgd);
> > >                       trace_tlb_flush(TLB_FLUSH_ON_TASK_SWITCH, TLB_FLUSH_ALL);
> > > +                     load_mm_cr4(next);
> > >                       load_LDT_nolock(&next->context);
> > >               }
> > >       }
> > > diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> > > index 00fbab7aa587..3e875b3b30f2 100644
> > > --- a/arch/x86/kernel/cpu/perf_event.c
> > > +++ b/arch/x86/kernel/cpu/perf_event.c
> > > @@ -31,6 +31,7 @@
> > >  #include <asm/nmi.h>
> > >  #include <asm/smp.h>
> > >  #include <asm/alternative.h>
> > > +#include <asm/mmu_context.h>
> > >  #include <asm/tlbflush.h>
> > >  #include <asm/timer.h>
> > >  #include <asm/desc.h>
> > > @@ -1336,8 +1337,6 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
> > >               break;
> > >
> > >       case CPU_STARTING:
> > > -             if (x86_pmu.attr_rdpmc)
> > > -                     cr4_set_bits(X86_CR4_PCE);
> > >               if (x86_pmu.cpu_starting)
> > >                       x86_pmu.cpu_starting(cpu);
> > >               break;
> > > @@ -1813,14 +1812,44 @@ static int x86_pmu_event_init(struct perf_event *event)
> > >                       event->destroy(event);
> > >       }
> > >
> > > +     if (ACCESS_ONCE(x86_pmu.attr_rdpmc))
> > > +             event->hw.flags |= PERF_X86_EVENT_RDPMC_ALLOWED;
> > > +
> > >       return err;
> > >  }
> > >
> > > +static void refresh_pce(void *ignored)
> > > +{
> > > +     if (current->mm)
> > > +             load_mm_cr4(current->mm);
> > > +}
> > > +
> > > +static void x86_pmu_event_mapped(struct perf_event *event)
> > > +{
> > > +     if (!(event->hw.flags & PERF_X86_EVENT_RDPMC_ALLOWED))
> > > +             return;
> > > +
> > > +     if (atomic_inc_return(&current->mm->context.perf_rdpmc_allowed) == 1)
> > > +             on_each_cpu_mask(mm_cpumask(current->mm), refresh_pce, NULL, 1);
> > > +}
> > > +
> > > +static void x86_pmu_event_unmapped(struct perf_event *event)
> > > +{
> > > +     if (!current->mm)
> > > +             return;
> > > +
> > > +     if (!(event->hw.flags & PERF_X86_EVENT_RDPMC_ALLOWED))
> > > +             return;
> > > +
> > > +     if (atomic_dec_and_test(&current->mm->context.perf_rdpmc_allowed))
> > > +             on_each_cpu_mask(mm_cpumask(current->mm), refresh_pce, NULL, 1);
> >
> > The current task(T-a on CPU A) is asking CPUs(A, B, C, D) to refresh pce, and looks
> > the current task(T-d on CPU D) is disturbed if T-d loaded CR4 when going on CPU D.
> 
> I don't understand.  This code is intended to interrupt only affected
> tasks, except for a race if cpus switch mm while this code is running.
> At worst, the race should only result in an unnecessary IPI.
> 
> Can you clarify your concern?
>

CPU D			CPU A
switch_mm
load_mm_cr4
			x86_pmu_event_unmapped

I wonder if the X86_CR4_PCE set on CPU D is
cleared by CPU A by broadcasting IPI.

Hillf



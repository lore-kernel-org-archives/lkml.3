Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaJaS0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 14:26:21 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:39743 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaJaS0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 14:26:19 -0400
MIME-Version: 1.0
In-Reply-To: <5453CCB8.4020301@redhat.com>
References: <cover.1414190806.git.luto@amacapital.net> <a2bdb3cf3a1d70c26980d7c6dddfbaa69f3182bf.1414190806.git.luto@amacapital.net>
 <5453CCB8.4020301@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 31 Oct 2014 11:25:51 -0700
Message-ID: <CALCETrX_3Pk0Ks_Gg5OArwTZ-qS3k3BVNX9zcgnL7mDdHB4Qzg@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] x86, perf: Only allow rdpmc if a perf_event is mapped
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "hillf.zj" <hillf.zj@alibaba-inc.com>, Vince Weaver <vince@deater.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Kees Cook <keescook@chromium.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 31, 2014 10:54 AM, "Paolo Bonzini" <pbonzini@redhat.com> wrote:
>
> On 25/10/2014 00:58, Andy Lutomirski wrote:
> > We currently allow any process to use rdpmc.  This significantly
> > weakens the protection offered by PR_TSC_DISABLED, and it could be
> > helpful to users attempting to exploit timing attacks.
> >
> > Since we can't enable access to individual counters, use a very
> > coarse heuristic to limit access to rdpmc: allow access only when
> > a perf_event is mmapped.  This protects seccomp sandboxes.
> >
> > There is plenty of room to further tighen these restrictions.  For
> > example, this allows rdpmc for any x86_pmu event, but it's only
> > useful for self-monitoring tasks.
> >
> > As a side effect, cap_user_rdpmc will now be false for AMD uncore
> > events.  This isn't a real regression, since .event_idx is disabled
> > for these events anyway for the time being.  Whenever that gets
> > re-added, the cap_user_rdpmc code can be adjusted or refactored
> > accordingly.
> >
> > Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>
> What's the impact of this if the host doesn't have "x86,kvm,vmx:
> Preserve CR4 across VM entry"?

Do you mean if these patches are applied in a guest and the host isn't
fixed?  I think it shoudn't make a difference.  As far as I know,
there was never anything wrong with KVM's handling of the guest's cr4
value, at least under VMX.  I haven't looked at SVM much.

If you apply this on the host without the fix, then you'll have some
conflicts, and, if you fix those conflicts, then you'll exacerbate the
VMX bug, because perf_event will trigger it, too.  You'll also have
unprivileged-host-user-triggerable IPIs that change cr4, resulting in
lovely cross-CPU races.  This is why I arranged the fix so that the
entire window during which a host cr4 change would get lost happens
with interrupts off.

This is actually how I found the bug in the first place.  I was trying
to convince myself that these patches weren't racy, so I looked at all
of the cr4-manipulation code I could find, and the VMX code made my
scratch my head. :)

--Andy

>
> Paolo
>
> > ---
> >  arch/x86/include/asm/mmu.h         |  2 ++
> >  arch/x86/include/asm/mmu_context.h | 16 +++++++++++
> >  arch/x86/kernel/cpu/perf_event.c   | 57 +++++++++++++++++++++++++-------------
> >  arch/x86/kernel/cpu/perf_event.h   |  2 ++
> >  4 files changed, 58 insertions(+), 19 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/mmu.h b/arch/x86/include/asm/mmu.h
> > index 876e74e8eec7..09b9620a73b4 100644
> > --- a/arch/x86/include/asm/mmu.h
> > +++ b/arch/x86/include/asm/mmu.h
> > @@ -19,6 +19,8 @@ typedef struct {
> >
> >       struct mutex lock;
> >       void __user *vdso;
> > +
> > +     atomic_t perf_rdpmc_allowed;    /* nonzero if rdpmc is allowed */
> >  } mm_context_t;
> >
> >  #ifdef CONFIG_SMP
> > diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
> > index 23697f74b372..ccad8d616038 100644
> > --- a/arch/x86/include/asm/mmu_context.h
> > +++ b/arch/x86/include/asm/mmu_context.h
> > @@ -19,6 +19,18 @@ static inline void paravirt_activate_mm(struct mm_struct *prev,
> >  }
> >  #endif       /* !CONFIG_PARAVIRT */
> >
> > +#ifdef CONFIG_PERF_EVENTS
> > +static inline void load_mm_cr4(struct mm_struct *mm)
> > +{
> > +     if (atomic_read(&mm->context.perf_rdpmc_allowed))
> > +             cr4_set_bits(X86_CR4_PCE);
> > +     else
> > +             cr4_clear_bits(X86_CR4_PCE);
> > +}
> > +#else
> > +static inline void load_mm_cr4(struct mm_struct *mm) {}
> > +#endif
> > +
> >  /*
> >   * Used for LDT copy/destruction.
> >   */
> > @@ -53,6 +65,9 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
> >               /* Stop flush ipis for the previous mm */
> >               cpumask_clear_cpu(cpu, mm_cpumask(prev));
> >
> > +             /* Load per-mm CR4 state */
> > +             load_mm_cr4(next);
> > +
> >               /*
> >                * Load the LDT, if the LDT is different.
> >                *
> > @@ -88,6 +103,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
> >                        */
> >                       load_cr3(next->pgd);
> >                       trace_tlb_flush(TLB_FLUSH_ON_TASK_SWITCH, TLB_FLUSH_ALL);
> > +                     load_mm_cr4(next);
> >                       load_LDT_nolock(&next->context);
> >               }
> >       }
> > diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> > index 00fbab7aa587..3e875b3b30f2 100644
> > --- a/arch/x86/kernel/cpu/perf_event.c
> > +++ b/arch/x86/kernel/cpu/perf_event.c
> > @@ -31,6 +31,7 @@
> >  #include <asm/nmi.h>
> >  #include <asm/smp.h>
> >  #include <asm/alternative.h>
> > +#include <asm/mmu_context.h>
> >  #include <asm/tlbflush.h>
> >  #include <asm/timer.h>
> >  #include <asm/desc.h>
> > @@ -1336,8 +1337,6 @@ x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
> >               break;
> >
> >       case CPU_STARTING:
> > -             if (x86_pmu.attr_rdpmc)
> > -                     cr4_set_bits(X86_CR4_PCE);
> >               if (x86_pmu.cpu_starting)
> >                       x86_pmu.cpu_starting(cpu);
> >               break;
> > @@ -1813,14 +1812,44 @@ static int x86_pmu_event_init(struct perf_event *event)
> >                       event->destroy(event);
> >       }
> >
> > +     if (ACCESS_ONCE(x86_pmu.attr_rdpmc))
> > +             event->hw.flags |= PERF_X86_EVENT_RDPMC_ALLOWED;
> > +
> >       return err;
> >  }
> >
> > +static void refresh_pce(void *ignored)
> > +{
> > +     if (current->mm)
> > +             load_mm_cr4(current->mm);
> > +}
> > +
> > +static void x86_pmu_event_mapped(struct perf_event *event)
> > +{
> > +     if (!(event->hw.flags & PERF_X86_EVENT_RDPMC_ALLOWED))
> > +             return;
> > +
> > +     if (atomic_inc_return(&current->mm->context.perf_rdpmc_allowed) == 1)
> > +             on_each_cpu_mask(mm_cpumask(current->mm), refresh_pce, NULL, 1);
> > +}
> > +
> > +static void x86_pmu_event_unmapped(struct perf_event *event)
> > +{
> > +     if (!current->mm)
> > +             return;
> > +
> > +     if (!(event->hw.flags & PERF_X86_EVENT_RDPMC_ALLOWED))
> > +             return;
> > +
> > +     if (atomic_dec_and_test(&current->mm->context.perf_rdpmc_allowed))
> > +             on_each_cpu_mask(mm_cpumask(current->mm), refresh_pce, NULL, 1);
> > +}
> > +
> >  static int x86_pmu_event_idx(struct perf_event *event)
> >  {
> >       int idx = event->hw.idx;
> >
> > -     if (!x86_pmu.attr_rdpmc)
> > +     if (!(event->hw.flags & PERF_X86_EVENT_RDPMC_ALLOWED))
> >               return 0;
> >
> >       if (x86_pmu.num_counters_fixed && idx >= INTEL_PMC_IDX_FIXED) {
> > @@ -1838,16 +1867,6 @@ static ssize_t get_attr_rdpmc(struct device *cdev,
> >       return snprintf(buf, 40, "%d\n", x86_pmu.attr_rdpmc);
> >  }
> >
> > -static void change_rdpmc(void *info)
> > -{
> > -     bool enable = !!(unsigned long)info;
> > -
> > -     if (enable)
> > -             cr4_set_bits(X86_CR4_PCE);
> > -     else
> > -             cr4_clear_bits(X86_CR4_PCE);
> > -}
> > -
> >  static ssize_t set_attr_rdpmc(struct device *cdev,
> >                             struct device_attribute *attr,
> >                             const char *buf, size_t count)
> > @@ -1862,11 +1881,7 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
> >       if (x86_pmu.attr_rdpmc_broken)
> >               return -ENOTSUPP;
> >
> > -     if (!!val != !!x86_pmu.attr_rdpmc) {
> > -             x86_pmu.attr_rdpmc = !!val;
> > -             on_each_cpu(change_rdpmc, (void *)val, 1);
> > -     }
> > -
> > +     x86_pmu.attr_rdpmc = !!val;
> >       return count;
> >  }
> >
> > @@ -1909,6 +1924,9 @@ static struct pmu pmu = {
> >
> >       .event_init             = x86_pmu_event_init,
> >
> > +     .event_mapped           = x86_pmu_event_mapped,
> > +     .event_unmapped         = x86_pmu_event_unmapped,
> > +
> >       .add                    = x86_pmu_add,
> >       .del                    = x86_pmu_del,
> >       .start                  = x86_pmu_start,
> > @@ -1930,7 +1948,8 @@ void arch_perf_update_userpage(struct perf_event *event,
> >
> >       userpg->cap_user_time = 0;
> >       userpg->cap_user_time_zero = 0;
> > -     userpg->cap_user_rdpmc = x86_pmu.attr_rdpmc;
> > +     userpg->cap_user_rdpmc =
> > +             !!(event->hw.flags & PERF_X86_EVENT_RDPMC_ALLOWED);
> >       userpg->pmc_width = x86_pmu.cntval_bits;
> >
> >       if (!sched_clock_stable())
> > diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
> > index d98a34d435d7..f6868186e67b 100644
> > --- a/arch/x86/kernel/cpu/perf_event.h
> > +++ b/arch/x86/kernel/cpu/perf_event.h
> > @@ -71,6 +71,8 @@ struct event_constraint {
> >  #define PERF_X86_EVENT_COMMITTED     0x8 /* event passed commit_txn */
> >  #define PERF_X86_EVENT_PEBS_LD_HSW   0x10 /* haswell style datala, load */
> >  #define PERF_X86_EVENT_PEBS_NA_HSW   0x20 /* haswell style datala, unknown */
> > +#define PERF_X86_EVENT_RDPMC_ALLOWED 0x40 /* grant rdpmc permission */
> > +
> >
> >  struct amd_nb {
> >       int nb_id;  /* NorthBridge id */
> >

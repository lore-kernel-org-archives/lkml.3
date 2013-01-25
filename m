Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab3AYPTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 10:19:34 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:54239 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab3AYPTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 10:19:31 -0500
MIME-Version: 1.0
In-Reply-To: <1357847443-3878-7-git-send-email-jacob.shin@amd.com>
References: <1357847443-3878-1-git-send-email-jacob.shin@amd.com>
	<1357847443-3878-7-git-send-email-jacob.shin@amd.com>
Date: Fri, 25 Jan 2013 16:13:44 +0100
Message-ID: <CABPqkBSE6Ani2G__=36C6uD7f9dbm=Rok2yFb_SOW41V_a8HNA@mail.gmail.com>
Subject: Re: [PATCH RESEND V5 6/6] perf, amd: Enable northbridge performance
 counters on AMD family 15h
From: Stephane Eranian <eranian@google.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 8:50 PM, Jacob Shin <jacob.shin@amd.com> wrote:
> On AMD family 15h processors, there are 4 new performance counters
> (in addition to 6 core performance counters) that can be used for
> counting northbridge events (i.e. DRAM accesses). Their bit fields are
> almost identical to the core performance counters. However, unlike the
> core performance counters, these MSRs are shared between multiple
> cores (that share the same northbridge). We will reuse the same code
> path as existing family 10h northbridge event constraints handler
> logic to enforce this sharing.
>
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> ---
>  arch/x86/include/asm/cpufeature.h     |    2 +
>  arch/x86/include/asm/perf_event.h     |    9 ++
>  arch/x86/include/uapi/asm/msr-index.h |    2 +
>  arch/x86/kernel/cpu/perf_event_amd.c  |  167 +++++++++++++++++++++++++++++----
>  4 files changed, 160 insertions(+), 20 deletions(-)
>
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index 2d9075e..93fe929 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -167,6 +167,7 @@
>  #define X86_FEATURE_TBM                (6*32+21) /* trailing bit manipulations */
>  #define X86_FEATURE_TOPOEXT    (6*32+22) /* topology extensions CPUID leafs */
>  #define X86_FEATURE_PERFCTR_CORE (6*32+23) /* core performance counter extensions */
> +#define X86_FEATURE_PERFCTR_NB  (6*32+24) /* NB performance counter extensions */
>
>  /*
>   * Auxiliary flags: Linux defined - For features scattered in various
> @@ -309,6 +310,7 @@ extern const char * const x86_power_flags[32];
>  #define cpu_has_hypervisor     boot_cpu_has(X86_FEATURE_HYPERVISOR)
>  #define cpu_has_pclmulqdq      boot_cpu_has(X86_FEATURE_PCLMULQDQ)
>  #define cpu_has_perfctr_core   boot_cpu_has(X86_FEATURE_PERFCTR_CORE)
> +#define cpu_has_perfctr_nb     boot_cpu_has(X86_FEATURE_PERFCTR_NB)
>  #define cpu_has_cx8            boot_cpu_has(X86_FEATURE_CX8)
>  #define cpu_has_cx16           boot_cpu_has(X86_FEATURE_CX16)
>  #define cpu_has_eager_fpu      boot_cpu_has(X86_FEATURE_EAGER_FPU)
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index 2234eaaec..57cb634 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -29,9 +29,14 @@
>  #define ARCH_PERFMON_EVENTSEL_INV                      (1ULL << 23)
>  #define ARCH_PERFMON_EVENTSEL_CMASK                    0xFF000000ULL
>
> +#define AMD64_EVENTSEL_INT_CORE_ENABLE                 (1ULL << 36)
>  #define AMD64_EVENTSEL_GUESTONLY                       (1ULL << 40)
>  #define AMD64_EVENTSEL_HOSTONLY                                (1ULL << 41)
>
> +#define AMD64_EVENTSEL_INT_CORE_SEL_SHIFT              37
> +#define AMD64_EVENTSEL_INT_CORE_SEL_MASK               \
> +       (0xFULL << AMD64_EVENTSEL_INT_CORE_SEL_SHIFT)
> +
Interestingly enough, this bitfield is not yet documented in the
public BKDG from March 2012.
I assume it will be in the next rev.

>  #define AMD64_EVENTSEL_EVENT   \
>         (ARCH_PERFMON_EVENTSEL_EVENT | (0x0FULL << 32))
>  #define INTEL_ARCH_EVENT_MASK  \
> @@ -46,8 +51,12 @@
>  #define AMD64_RAW_EVENT_MASK           \
>         (X86_RAW_EVENT_MASK          |  \
>          AMD64_EVENTSEL_EVENT)
> +#define AMD64_RAW_EVENT_MASK_NB                \
> +       (AMD64_EVENTSEL_EVENT        |  \
> +        ARCH_PERFMON_EVENTSEL_UMASK)
>  #define AMD64_NUM_COUNTERS                             4
>  #define AMD64_NUM_COUNTERS_CORE                                6
> +#define AMD64_NUM_COUNTERS_NB                          4
>
>  #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_SEL          0x3c
>  #define ARCH_PERFMON_UNHALTED_CORE_CYCLES_UMASK                (0x00 << 8)
> diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
> index 433a59f..075a402 100644
> --- a/arch/x86/include/uapi/asm/msr-index.h
> +++ b/arch/x86/include/uapi/asm/msr-index.h
> @@ -194,6 +194,8 @@
>  /* Fam 15h MSRs */
>  #define MSR_F15H_PERF_CTL              0xc0010200
>  #define MSR_F15H_PERF_CTR              0xc0010201
> +#define MSR_F15H_NB_PERF_CTL           0xc0010240
> +#define MSR_F15H_NB_PERF_CTR           0xc0010241
>
>  /* Fam 10h MSRs */
>  #define MSR_FAM10H_MMIO_CONF_BASE      0xc0010058
> diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
> index faf9072..1a80e05 100644
> --- a/arch/x86/kernel/cpu/perf_event_amd.c
> +++ b/arch/x86/kernel/cpu/perf_event_amd.c
> @@ -132,11 +132,14 @@ static u64 amd_pmu_event_map(int hw_event)
>         return amd_perfmon_event_map[hw_event];
>  }
>
> +static struct event_constraint *amd_nb_event_constraint;
> +
>  /*
>   * Previously calculated offsets
>   */
>  static unsigned int event_offsets[X86_PMC_IDX_MAX] __read_mostly;
>  static unsigned int count_offsets[X86_PMC_IDX_MAX] __read_mostly;
> +static unsigned int rdpmc_indexes[X86_PMC_IDX_MAX] __read_mostly;
>
>  /*
>   * Legacy CPUs:
> @@ -144,10 +147,14 @@ static unsigned int count_offsets[X86_PMC_IDX_MAX] __read_mostly;
>   *
>   * CPUs with core performance counter extensions:
>   *   6 counters starting at 0xc0010200 each offset by 2
> + *
> + * CPUs with north bridge performance counter extensions:
> + *   4 additional counters starting at 0xc0010240 each offset by 2
> + *   (indexed right above either one of the above core counters)
>   */
>  static inline int amd_pmu_addr_offset(int index, int eventsel)
>  {
> -       int offset;
> +       int offset, first, base;
>
>         if (!index)
>                 return index;
> @@ -160,7 +167,23 @@ static inline int amd_pmu_addr_offset(int index, int eventsel)
>         if (offset)
>                 return offset;
>
> -       if (!cpu_has_perfctr_core)
> +       if (amd_nb_event_constraint &&
> +           test_bit(index, amd_nb_event_constraint->idxmsk)) {
> +               /*
> +                * calculate the offset of NB counters with respect to
> +                * base eventsel or perfctr
> +                */
> +
> +               first = find_first_bit(amd_nb_event_constraint->idxmsk,
> +                                      X86_PMC_IDX_MAX);
> +
> +               if (eventsel)
> +                       base = MSR_F15H_NB_PERF_CTL - x86_pmu.eventsel;
> +               else
> +                       base = MSR_F15H_NB_PERF_CTR - x86_pmu.perfctr;
> +
> +               offset = base + ((index - first) << 1);
> +       } else if (!cpu_has_perfctr_core)
>                 offset = index;
>         else
>                 offset = index << 1;
> @@ -175,24 +198,36 @@ static inline int amd_pmu_addr_offset(int index, int eventsel)
>
>  static inline int amd_pmu_rdpmc_index(int index)
>  {
> -       return index;
> -}
> +       int ret, first;
>
> -static int amd_pmu_hw_config(struct perf_event *event)
> -{
> -       int ret;
> +       if (!index)
> +               return index;
>
> -       /* pass precise event sampling to ibs: */
> -       if (event->attr.precise_ip && get_ibs_caps())
> -               return -ENOENT;
> +       ret = rdpmc_indexes[index];
>
> -       ret = x86_pmu_hw_config(event);
>         if (ret)
>                 return ret;
>
> -       if (has_branch_stack(event))
> -               return -EOPNOTSUPP;
> +       if (amd_nb_event_constraint &&
> +           test_bit(index, amd_nb_event_constraint->idxmsk)) {
> +               /*
> +                * according to the mnual, ECX value of the NB counters is
> +                * the index of the NB counter (0, 1, 2 or 3) plus 6
> +                */
> +
> +               first = find_first_bit(amd_nb_event_constraint->idxmsk,
> +                                      X86_PMC_IDX_MAX);
> +               ret = index - first + 6;
> +       } else
> +               ret = index;
> +
> +       rdpmc_indexes[index] = ret;
>
> +       return ret;
> +}
> +
> +static int amd_core_hw_config(struct perf_event *event)
> +{
>         if (event->attr.exclude_host && event->attr.exclude_guest)
>                 /*
>                  * When HO == GO == 1 the hardware treats that as GO == HO == 0
> @@ -206,10 +241,29 @@ static int amd_pmu_hw_config(struct perf_event *event)
>         else if (event->attr.exclude_guest)
>                 event->hw.config |= AMD64_EVENTSEL_HOSTONLY;
>
> -       if (event->attr.type != PERF_TYPE_RAW)
> -               return 0;
> +       return 0;
> +}
>
> -       event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;
> +/*
> + * NB counters do not support the following event select bits:
> + *   Host/Guest only
> + *   Counter mask
> + *   Invert counter mask
> + *   Edge detect
> + *   OS/User mode
> + */
> +static int amd_nb_hw_config(struct perf_event *event)
> +{
> +       if (event->attr.exclude_user || event->attr.exclude_kernel ||
> +           event->attr.exclude_host || event->attr.exclude_guest)
> +               return -EINVAL;
> +
> +       event->hw.config &= ~(ARCH_PERFMON_EVENTSEL_USR |
> +                             ARCH_PERFMON_EVENTSEL_OS);
> +
> +       if (event->hw.config & ~(AMD64_RAW_EVENT_MASK_NB |
> +                                ARCH_PERFMON_EVENTSEL_INT))
> +               return -EINVAL;
>
>         return 0;
>  }
> @@ -227,6 +281,11 @@ static inline int amd_is_nb_event(struct hw_perf_event *hwc)
>         return (hwc->config & 0xe0) == 0xe0;
>  }
>
> +static inline int amd_is_perfctr_nb_event(struct hw_perf_event *hwc)
> +{
> +       return amd_nb_event_constraint && amd_is_nb_event(hwc);
> +}
> +
>  static inline int amd_has_nb(struct cpu_hw_events *cpuc)
>  {
>         struct amd_nb *nb = cpuc->amd_nb;
> @@ -234,6 +293,30 @@ static inline int amd_has_nb(struct cpu_hw_events *cpuc)
>         return nb && nb->nb_id != -1;
>  }
>
> +static int amd_pmu_hw_config(struct perf_event *event)
> +{
> +       int ret;
> +
> +       /* pass precise event sampling to ibs: */
> +       if (event->attr.precise_ip && get_ibs_caps())
> +               return -ENOENT;
> +
> +       if (has_branch_stack(event))
> +               return -EOPNOTSUPP;
> +
> +       ret = x86_pmu_hw_config(event);
> +       if (ret)
> +               return ret;
> +
> +       if (event->attr.type == PERF_TYPE_RAW)
> +               event->hw.config |= event->attr.config & AMD64_RAW_EVENT_MASK;
> +
> +       if (amd_is_perfctr_nb_event(&event->hw))
> +               return amd_nb_hw_config(event);
> +
> +       return amd_core_hw_config(event);
> +}
> +
>  static void __amd_put_nb_event_constraints(struct cpu_hw_events *cpuc,
>                                            struct perf_event *event)
>  {
> @@ -254,6 +337,19 @@ static void __amd_put_nb_event_constraints(struct cpu_hw_events *cpuc,
>         }
>  }
>
> +static void amd_nb_interrupt_hw_config(struct hw_perf_event *hwc)
> +{
> +       int core_id = cpu_data(smp_processor_id()).cpu_core_id;
> +
> +       /* deliver interrupts only to this core */
> +       if (hwc->config & ARCH_PERFMON_EVENTSEL_INT) {
> +               hwc->config |= AMD64_EVENTSEL_INT_CORE_ENABLE;
> +               hwc->config &= ~AMD64_EVENTSEL_INT_CORE_SEL_MASK;
> +               hwc->config |= (u64)(core_id) <<
> +                       AMD64_EVENTSEL_INT_CORE_SEL_SHIFT;
> +       }
> +}
> +
Well, given the model that you are using, i.e., fused with the core
PMU, then you can
supposedly measure NB events in per-thread mode. If the thread migrates from one
CPU to another. Then the uncore interrupt has to follow. Otherwise, you
may get an interrupt on CPU0 where there is no active events if the
thread is now
running on CPU1, for instance. So this does not work well. I think for
NB events,
you may want to disable per-thread support. This is how it's done for
Intel uncore.

The  NB interrupt is useful for:
- 64-bit virtualization of the HW counter
- sampling.

Now, I admit given the list NB events, it does not really make sense
to sample on
those and hope to correlate to a meaningful address in a program. For
all I know,
the actual cause of an event may come from a program that is not even running on
the measured core (assuming you were doing: perf record -a -C 0 -e
r01e0 sleep 10).

Next, I tried running a simple example:

  $ perf record -a -C 0 -e r01e0 sleep 10

But, there is nothing running on CPU0, so it's idle and even goes low-power.
Yet, if on CPU1 there is load causing memory traffic and therefore
firing the event.

First, in your setup, you're using the current CPU and NOT the target CPU of the
event. Even though, you want to measure CPU0, you can be invoking
perf_event_open()
from CPU3. Unless that setup phase is guaranteed to ALWAYS run on the target
CPU  for the event, here CPU0, that setup won't work.

I am using a simple memory benchmark called triad for which I can pin where
the memory init (-i) and execution (-r) occur. So here I run everything on CPU0
and I sample only one NB event via CPU0. First, I count the actual number of
events in per-process mode. This gives me a ballpark figure for a sampling
period.

$ perf stat --no-big-num --pfm-event dram_accesses:dct0_page_miss
triad -i 0 -r 0
          62302388 dram_accesses:dct0_page_miss
       6.099754492 seconds time elapsed

Want about 1000 samples, so I use -c 62302388/1000

$ perf record -a -C 0  -c 62302  --pfm-event
dram_accesses:dct0_page_miss  triad -i 0 -r 0
$ perf report -D | tail -6
dram_accesses:dct0_page_miss stats:
           TOTAL events:       3451
            MMAP events:       2197
            COMM events:        254
            EXIT events:          2
          SAMPLE events:        998

Got about a 1000 samples. All is good.

Now, I modify the setup by forcing triad to init and run on CPU3 but I
am still measuring
from CPU0:

$ perf record -a -C 0  -c 62302  --pfm-event
dram_accesses:dct0_page_miss  triad -i 3 -r 3 -l 3
$ perf report -D | tail -6
           TOTAL events:       2792
            MMAP events:       2201
            COMM events:        255
        THROTTLE events:          3
      UNTHROTTLE events:          3
          SAMPLE events:        330

I have lost 2/3rd of the samples. Why?

NB counters are shared across all 4 cores (of my Fam15h CPU), so when
the counter
overflows it will interrupt CPU0. But how come samples disappear?

At first, I thought it could be due to the same problem that exists on
Intel uncore:
uncore interrupt does not wake up a core in low-power state. But that
is not quite
the problem here. Instead, you have to look at throttling. Why is this
run throttled?
Capturing about 1000 samples over 6s. We are very far from the default
100000 intrs/event/cpu/s. So something is wrong here. Looks like CPU0 may get
a burst of NB interrupts and decides the throttle for a timer tick or
so. It does not
happen a lot but enough to cause 2/3rd of the sample to disappear. If I raise
the threshold to 1000000 (million), then the problem goes away:

$ perf report -D | tail -6
dram_accesses:dct0_page_miss stats:
           TOTAL events:       3296
            MMAP events:       2037
            COMM events:        249
          SAMPLE events:       1010

So something is broken with NB interrupts and I don't quite know what it is.

But in general, I remain convinced that unless you have broadcast
interrupt and perf_event is modified to handle this case, sampling on
the NB is pointless. So we might as well disable this and keep counting.
But that does still require working NB interrupts. Worst case, we can do
like on Intel and use hrtimer-based polling.


>   /*
>    * AMD64 NorthBridge events need special treatment because
>    * counter access needs to be synchronized across all cores
> @@ -299,6 +395,12 @@ __amd_get_nb_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *ev
>         struct perf_event *old;
>         int idx, new = -1;
>
> +       if (!c)
> +               c = &unconstrained;
> +
> +       if (cpuc->is_fake)
> +               return c;
> +
>         /*
>          * detect if already present, if so reuse
>          *
> @@ -335,6 +437,9 @@ __amd_get_nb_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *ev
>         if (new == -1)
>                 return &emptyconstraint;
>
> +       if (amd_is_perfctr_nb_event(hwc))
> +               amd_nb_interrupt_hw_config(hwc);
> +
>         return &nb->event_constraints[new];
>  }
>
> @@ -434,7 +539,8 @@ amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
>         if (!(amd_has_nb(cpuc) && amd_is_nb_event(&event->hw)))
>                 return &unconstrained;
>
> -       return __amd_get_nb_event_constraints(cpuc, event, &unconstrained);
> +       return __amd_get_nb_event_constraints(cpuc, event,
> +                                             amd_nb_event_constraint);
>  }
>
>  static void amd_put_event_constraints(struct cpu_hw_events *cpuc,
> @@ -533,6 +639,9 @@ static struct event_constraint amd_f15_PMC30 = EVENT_CONSTRAINT_OVERLAP(0, 0x09,
>  static struct event_constraint amd_f15_PMC50 = EVENT_CONSTRAINT(0, 0x3F, 0);
>  static struct event_constraint amd_f15_PMC53 = EVENT_CONSTRAINT(0, 0x38, 0);
>
> +static struct event_constraint amd_NBPMC96 = EVENT_CONSTRAINT(0, 0x3C0, 0);
> +static struct event_constraint amd_NBPMC74 = EVENT_CONSTRAINT(0, 0xF0, 0);
> +
>  static struct event_constraint *
>  amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *event)
>  {
> @@ -598,8 +707,8 @@ amd_get_event_constraints_f15h(struct cpu_hw_events *cpuc, struct perf_event *ev
>                         return &amd_f15_PMC20;
>                 }
>         case AMD_EVENT_NB:
> -               /* not yet implemented */
> -               return &emptyconstraint;
> +               return __amd_get_nb_event_constraints(cpuc, event,
> +                                                     amd_nb_event_constraint);
>         default:
>                 return &emptyconstraint;
>         }
> @@ -647,7 +756,7 @@ static __initconst const struct x86_pmu amd_pmu = {
>
>  static int setup_event_constraints(void)
>  {
> -       if (boot_cpu_data.x86 >= 0x15)
> +       if (boot_cpu_data.x86 == 0x15)
>                 x86_pmu.get_event_constraints = amd_get_event_constraints_f15h;
>         return 0;
>  }
> @@ -677,6 +786,23 @@ static int setup_perfctr_core(void)
>         return 0;
>  }
>
> +static int setup_perfctr_nb(void)
> +{
> +       if (!cpu_has_perfctr_nb)
> +               return -ENODEV;
> +
> +       x86_pmu.num_counters += AMD64_NUM_COUNTERS_NB;
> +
> +       if (cpu_has_perfctr_core)
> +               amd_nb_event_constraint = &amd_NBPMC96;
> +       else
> +               amd_nb_event_constraint = &amd_NBPMC74;
> +
> +       printk(KERN_INFO "perf: AMD northbridge performance counters detected\n");
> +
> +       return 0;
> +}
> +
>  __init int amd_pmu_init(void)
>  {
>         /* Performance-monitoring supported from K7 and later: */
> @@ -687,6 +813,7 @@ __init int amd_pmu_init(void)
>
>         setup_event_constraints();
>         setup_perfctr_core();
> +       setup_perfctr_nb();
>
>         /* Events are common for all AMDs */
>         memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
> --
> 1.7.9.5
>
>

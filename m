Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbaLJV5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 16:57:30 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53098 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744AbaLJV52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 16:57:28 -0500
Date: Wed, 10 Dec 2014 13:57:13 -0800
From: Shaohua Li <shli@fb.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, <kernel-team@fb.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 3/3] X86: Add a thread cpu time implementation to vDSO
Message-ID: <20141210215713.GA30230@devbig257.prn2.facebook.com>
References: <f0f3eab5f68f74bfabf42d745ccf1e2ecf642683.1418006970.git.shli@fb.com>
 <862cbb2ab71a9f71d1123b5512605350a4b61846.1418006970.git.shli@fb.com>
 <CALCETrUU-vb34550mbE-yqoWYrzVNarVf++Logt0gmSTh_Cg2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CALCETrUU-vb34550mbE-yqoWYrzVNarVf++Logt0gmSTh_Cg2w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-10_08:2014-12-10,2014-12-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=39.3128602056297
 compositescore=0.928745990228454 urlsuspect_oldscore=0.928745990228454
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.928745990228454 spamscore=0
 recipient_to_sender_domain_totalscore=46 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412100207
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 11:10:52AM -0800, Andy Lutomirski wrote:
> On Sun, Dec 7, 2014 at 7:03 PM, Shaohua Li <shli@fb.com> wrote:
> > This primarily speeds up clock_gettime(CLOCK_THREAD_CPUTIME_ID, ..). We
> > use the following method to compute the thread cpu time:
> 
> I like the idea, and I like making this type of profiling fast.  I
> don't love the implementation because it's an information leak (maybe
> we don't care) and it's ugly.
> 
> The info leak could be fixed completely by having a per-process array
> instead of a global array.  That's currently tricky without wasting
> memory, but it could be created on demand if we wanted to do that,
> once my vvar .fault patches go in (assuming they do -- I need to ping
> the linux-mm people).

those info leak really doesn't matter. But we need the global array
anyway. The context switch detection should be per-cpu data and should
be able to access in remote cpus.

> As for ugliness, it seems to me that there really ought to be a better
> way to do this.  What we really want is a per-thread vvar-like thing.
> Any code that can use TLS can do this trivially, but the vdso,
> unfortunately, has no straightforward way to use TLS.
> 
> If we could rely on something like TSX (ha!), then this becomes straightforward:
> 
> xbegin()
> rdtscp
> read params
> xcommit()
> 
> But we can't do that for the next decade or so, obviously.
> 
> If we were willing to limit ourselves to systems with rdwrgsbase, then
> we could do:
> 
> save gs and gsbase
> mov $__VDSO_CPU,%gs
> mov %gs:(base our array),%whatever
> restore gs and gsbase
> 
> (We actually could do this if we make arch_prctl disable this feature
> the first time a process tries to set the gs base.)
> 
> If we were willing to limit ourselves to at most 2^20 threads per
> process, then we could assign each thread a 20-bit index within its
> process with some LSL trickery.  Then we could have the vdso look up
> the thread in a per-process array with one element per thread.  This
> would IMO be the winning approach if we think we'd ever extend the set
> of per-thread vvar things.  (For the 32-bit VDSO, this is trivial --
> just use a far pointer.)
> 
> If we has per-cpu fixmap entries, we'd use that.  Unfortunately, that
> would be a giant mess to implement, and it would be a slowdown for
> some workloads (and a speedup for others - hmm).
> 
> Grumble.  Thoughts?
> 
> --Andy
> 
> >
> >     t0 = process start
> >     t1 = most recent context switch time
> >     t2 = time at which the vsyscall is invoked
> >
> >     thread_cpu_time = sum(time slices between t0 to t1) + (t2 - t1)
> >                 = current->se.sum_exec_runtime + now - sched_clock()
> >
> > At context switch time We stash away
> >
> >     adj_sched_time = sum_exec_runtime - sched_clock()
> >
> > in a per-cpu struct in the VVAR page and then compute
> >
> >     thread_cpu_time = adj_sched_time + now
> >
> > All computations are done in nanosecs on systems where TSC is stable. If
> > TSC is unstable, we fallback to a regular syscall.
> >     Benchmark data:
> >
> >     for (i = 0; i < 100000000; i++) {
> >             clock_gettime(CLOCK_THREAD_CPUTIME_ID, &ts);
> >             sum += ts.tv_sec * NSECS_PER_SEC + ts.tv_nsec;
> >     }
> >
> >     Baseline:
> >     real    1m3.428s
> >     user    0m5.190s
> >     sys     0m58.220s
> >
> >     patched:
> >     real    0m4.912s
> >     user    0m4.910s
> >     sys     0m0.000s
> >
> > This should speed up profilers that need to query thread cpu time a lot
> > to do fine-grained timestamps.
> >
> > No statistically significant regression was detected on x86_64 context
> > switch code. Most archs that don't support vsyscalls will have this code
> > disabled via jump labels.
> >
> > Cc: Andy Lutomirski <luto@amacapital.net>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Signed-off-by: Kumar Sundararajan <kumar@fb.com>
> > Signed-off-by: Arun Sharma <asharma@fb.com>
> > Signed-off-by: Chris Mason <clm@fb.com>
> > Signed-off-by: Shaohua Li <shli@fb.com>
> > ---
> >  arch/x86/include/asm/vdso.h    |  9 +++++++-
> >  arch/x86/kernel/tsc.c          | 14 ++++++++++++
> >  arch/x86/vdso/vclock_gettime.c | 49 ++++++++++++++++++++++++++++++++++++++++++
> >  arch/x86/vdso/vma.c            |  4 ++++
> >  kernel/sched/core.c            |  3 +++
> >  5 files changed, 78 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
> > index 42d6d2c..cbbab3a 100644
> > --- a/arch/x86/include/asm/vdso.h
> > +++ b/arch/x86/include/asm/vdso.h
> > @@ -54,14 +54,21 @@ extern void __init init_vdso_image(const struct vdso_image *image);
> >  struct vdso_percpu_data {
> >         /* layout: | cpu ID | context switch count | */
> >         unsigned long cpu_cs_count;
> > +
> > +       unsigned long long adj_sched_time;
> > +       unsigned long long cyc2ns_offset;
> > +       unsigned long cyc2ns;
> 
> Having two offsets seems unnecessary.
> 
> >  } ____cacheline_aligned;
> >
> >  struct vdso_data {
> > -       int dummy;
> > +       unsigned int thread_cputime_disabled;
> >         struct vdso_percpu_data vpercpu[0];
> >  };
> >  extern struct vdso_data vdso_data;
> >
> > +struct static_key;
> > +extern struct static_key vcpu_thread_cputime_enabled;
> > +
> >  #ifdef CONFIG_SMP
> >  #define VDSO_CS_COUNT_BITS \
> >         (sizeof(unsigned long) * 8 - NR_CPUS_BITS)
> > diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> > index b7e50bb..83f8091 100644
> > --- a/arch/x86/kernel/tsc.c
> > +++ b/arch/x86/kernel/tsc.c
> > @@ -21,6 +21,7 @@
> >  #include <asm/hypervisor.h>
> >  #include <asm/nmi.h>
> >  #include <asm/x86_init.h>
> > +#include <asm/vdso.h>
> >
> >  unsigned int __read_mostly cpu_khz;    /* TSC clocks / usec, not used here */
> >  EXPORT_SYMBOL(cpu_khz);
> > @@ -263,6 +264,11 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
> >         data->cyc2ns_offset = ns_now -
> >                 mul_u64_u32_shr(tsc_now, data->cyc2ns_mul, CYC2NS_SCALE_FACTOR);
> >
> > +#ifdef CONFIG_VDSO_CS_DETECT
> > +       vdso_data.vpercpu[cpu].cyc2ns = data->cyc2ns_mul;
> > +       vdso_data.vpercpu[cpu].cyc2ns_offset = data->cyc2ns_offset;
> > +#endif
> > +
> >         cyc2ns_write_end(cpu, data);
> >
> >  done:
> > @@ -989,6 +995,10 @@ void mark_tsc_unstable(char *reason)
> >                 tsc_unstable = 1;
> >                 clear_sched_clock_stable();
> >                 disable_sched_clock_irqtime();
> > +#ifdef CONFIG_VDSO_CS_DETECT
> > +               vdso_data.thread_cputime_disabled = 1;
> > +               static_key_slow_dec(&vcpu_thread_cputime_enabled);
> > +#endif
> >                 pr_info("Marking TSC unstable due to %s\n", reason);
> >                 /* Change only the rating, when not registered */
> >                 if (clocksource_tsc.mult)
> > @@ -1202,6 +1212,10 @@ void __init tsc_init(void)
> >
> >         tsc_disabled = 0;
> >         static_key_slow_inc(&__use_tsc);
> > +#ifdef CONFIG_VDSO_CS_DETECT
> > +       vdso_data.thread_cputime_disabled = !cpu_has(&boot_cpu_data,
> > +                       X86_FEATURE_RDTSCP);
> > +#endif
> 
> This is backwards IMO.  Even if this function never runs, the flag
> should be set to disable the feature.  Then you can enable it here.
> 
> >
> >         if (!no_sched_irq_time)
> >                 enable_sched_clock_irqtime();
> > diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
> > index 438b3be..46c03af2 100644
> > --- a/arch/x86/vdso/vclock_gettime.c
> > +++ b/arch/x86/vdso/vclock_gettime.c
> > @@ -299,6 +299,48 @@ notrace unsigned long __vdso_get_context_switch_count(void)
> >         smp_rmb();
> >         return VVAR(vdso_data).vpercpu[cpu].cpu_cs_count;
> >  }
> > +
> > +#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
> > +notrace static inline unsigned long long __cycles_2_ns(unsigned long long cyc,
> > +                                       unsigned long long scale,
> > +                                       unsigned long long offset)
> > +{
> > +       unsigned long long ns = offset;
> > +       ns += mul_u64_u32_shr(cyc, scale, CYC2NS_SCALE_FACTOR);
> > +       return ns;
> > +}
> > +
> > +notrace static unsigned long do_thread_cpu_time(void)
> > +{
> > +       unsigned int p;
> > +       u_int64_t tscval;
> > +       unsigned long long adj_sched_time;
> > +       unsigned long long scale;
> > +       unsigned long long offset;
> > +       const struct vdso_data *vp = &VVAR(vdso_data);
> > +       int cpu;
> > +       unsigned long cs;
> > +
> > +       do {
> > +               cs = __vdso_get_context_switch_count();
> > +
> > +               rdtscpll(tscval, p);
> > +               cpu = p & VGETCPU_CPU_MASK;
> > +               adj_sched_time = vp->vpercpu[cpu].adj_sched_time;
> > +               scale = vp->vpercpu[cpu].cyc2ns;
> > +               offset = vp->vpercpu[cpu].cyc2ns_offset;
> > +
> > +       } while (unlikely(cs != __vdso_get_context_switch_count()));
> > +
> > +       return __cycles_2_ns(tscval, scale, offset) + adj_sched_time;
> 
> You're literally adding two offsets together here, although it's
> obscured by the abstraction of __cycles_2_ns.

I don't understand 'two offsets' stuff, could you please give more
details?

> Also, if you actually expand this function out, it's not optimized
> well.  You're doing, roughly:
> 
> getcpu
> read cs count
> rdtscp
> read clock params
> getcpu
> read cs count
> repeat if necessary
> 
> You should need at most two operations that read the cpu number.  You could do:
> 
> getcpu
> read cs count
> rdtscp
> read clock params
> barrier()
> check that both cpu numbers agree and that the cs count hasn't changed
> 
> All those smp barriers should be unnecessary, too.  There's no SMP here.
> 
> Also, if you do this, then the high bits of the cs count can be removed.
> It may also make sense to bail and use the fallback after a couple
> failures.  Otherwise, in some debuggers, you will literally never
> finish the loop.

ok, makes sense.

> I am curious, though: why are you using sched clock instead of
> CLOCK_MONOTONIC?  Is it because you can't read CLOCK_MONOTONIC in the
> scheduler?

The sched clock is faster, I guess.

Thanks,
Shaohua

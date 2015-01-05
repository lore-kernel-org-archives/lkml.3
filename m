Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbbAEWtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:49:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbbAEWtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:49:18 -0500
Date: Mon, 5 Jan 2015 20:48:58 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: [RFC 2/2] x86, vdso, pvclock: Simplify and speed up the vdso
 pvclock reader
Message-ID: <20150105224858.GA6846@amt.cnet>
References: <cover.1419295081.git.luto@amacapital.net>
 <8d09c16eb39cbe264417cc66c4aca730af10b70b.1419295081.git.luto@amacapital.net>
 <20150105152511.GA9172@amt.cnet>
 <CALCETrXRs4NmhMvp+7kydrfyGCiNymkTe_sP6HFVvhMCC2Ei0Q@mail.gmail.com>
 <20150105191756.GA31201@amt.cnet>
 <CALCETrVWmbcv1w5a3N1VzyWEobP0qW+RQkhWO9yOkxzdKdJgeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVWmbcv1w5a3N1VzyWEobP0qW+RQkhWO9yOkxzdKdJgeg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 02:38:46PM -0800, Andy Lutomirski wrote:
> On Mon, Jan 5, 2015 at 11:17 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > On Mon, Jan 05, 2015 at 10:56:07AM -0800, Andy Lutomirski wrote:
> >> On Mon, Jan 5, 2015 at 7:25 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> >> > On Mon, Dec 22, 2014 at 04:39:57PM -0800, Andy Lutomirski wrote:
> >> >> The pvclock vdso code was too abstracted to understand easily and
> >> >> excessively paranoid.  Simplify it for a huge speedup.
> >> >>
> >> >> This opens the door for additional simplifications, as the vdso no
> >> >> longer accesses the pvti for any vcpu other than vcpu 0.
> >> >>
> >> >> Before, vclock_gettime using kvm-clock took about 64ns on my machine.
> >> >> With this change, it takes 19ns, which is almost as fast as the pure TSC
> >> >> implementation.
> >> >>
> >> >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> >> >> ---
> >> >>  arch/x86/vdso/vclock_gettime.c | 82 ++++++++++++++++++++++++------------------
> >> >>  1 file changed, 47 insertions(+), 35 deletions(-)
> >> >>
> >> >> diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
> >> >> index 9793322751e0..f2e0396d5629 100644
> >> >> --- a/arch/x86/vdso/vclock_gettime.c
> >> >> +++ b/arch/x86/vdso/vclock_gettime.c
> >> >> @@ -78,47 +78,59 @@ static notrace const struct pvclock_vsyscall_time_info *get_pvti(int cpu)
> >> >>
> >> >>  static notrace cycle_t vread_pvclock(int *mode)
> >> >>  {
> >> >> -     const struct pvclock_vsyscall_time_info *pvti;
> >> >> +     const struct pvclock_vcpu_time_info *pvti = &get_pvti(0)->pvti;
> >> >>       cycle_t ret;
> >> >> -     u64 last;
> >> >> -     u32 version;
> >> >> -     u8 flags;
> >> >> -     unsigned cpu, cpu1;
> >> >> -
> >> >> +     u64 tsc, pvti_tsc;
> >> >> +     u64 last, delta, pvti_system_time;
> >> >> +     u32 version, pvti_tsc_to_system_mul, pvti_tsc_shift;
> >> >>
> >> >>       /*
> >> >> -      * Note: hypervisor must guarantee that:
> >> >> -      * 1. cpu ID number maps 1:1 to per-CPU pvclock time info.
> >> >> -      * 2. that per-CPU pvclock time info is updated if the
> >> >> -      *    underlying CPU changes.
> >> >> -      * 3. that version is increased whenever underlying CPU
> >> >> -      *    changes.
> >> >> +      * Note: The kernel and hypervisor must guarantee that cpu ID
> >> >> +      * number maps 1:1 to per-CPU pvclock time info.
> >> >> +      *
> >> >> +      * Because the hypervisor is entirely unaware of guest userspace
> >> >> +      * preemption, it cannot guarantee that per-CPU pvclock time
> >> >> +      * info is updated if the underlying CPU changes or that that
> >> >> +      * version is increased whenever underlying CPU changes.
> >> >> +      *
> >> >> +      * On KVM, we are guaranteed that pvti updates for any vCPU are
> >> >> +      * atomic as seen by *all* vCPUs.  This is an even stronger
> >> >> +      * guarantee than we get with a normal seqlock.
> >> >>        *
> >> >> +      * On Xen, we don't appear to have that guarantee, but Xen still
> >> >> +      * supplies a valid seqlock using the version field.
> >> >> +
> >> >> +      * We only do pvclock vdso timing at all if
> >> >> +      * PVCLOCK_TSC_STABLE_BIT is set, and we interpret that bit to
> >> >> +      * mean that all vCPUs have matching pvti and that the TSC is
> >> >> +      * synced, so we can just look at vCPU 0's pvti.
> >> >>        */
> >> >
> >> > Can Xen guarantee that ?
> >>
> >> I think so, vacuously.  Xen doesn't seem to set PVCLOCK_TSC_STABLE_BIT
> >> at all.  I have no idea going forward, though.
> >>
> >> Xen people?
> >>
> >> >
> >> >> -     do {
> >> >> -             cpu = __getcpu() & VGETCPU_CPU_MASK;
> >> >> -             /* TODO: We can put vcpu id into higher bits of pvti.version.
> >> >> -              * This will save a couple of cycles by getting rid of
> >> >> -              * __getcpu() calls (Gleb).
> >> >> -              */
> >> >> -
> >> >> -             pvti = get_pvti(cpu);
> >> >> -
> >> >> -             version = __pvclock_read_cycles(&pvti->pvti, &ret, &flags);
> >> >> -
> >> >> -             /*
> >> >> -              * Test we're still on the cpu as well as the version.
> >> >> -              * We could have been migrated just after the first
> >> >> -              * vgetcpu but before fetching the version, so we
> >> >> -              * wouldn't notice a version change.
> >> >> -              */
> >> >> -             cpu1 = __getcpu() & VGETCPU_CPU_MASK;
> >> >> -     } while (unlikely(cpu != cpu1 ||
> >> >> -                       (pvti->pvti.version & 1) ||
> >> >> -                       pvti->pvti.version != version));
> >> >> -
> >> >> -     if (unlikely(!(flags & PVCLOCK_TSC_STABLE_BIT)))
> >> >> +
> >> >> +     if (unlikely(!(pvti->flags & PVCLOCK_TSC_STABLE_BIT))) {
> >> >>               *mode = VCLOCK_NONE;
> >> >> +             return 0;
> >> >> +     }
> >> >
> >> > This check must be performed after reading a stable pvti.
> >> >
> >>
> >> We can even read it in the middle, guarded by the version checks.
> >> I'll do that for v2.
> >>
> >> >> +
> >> >> +     do {
> >> >> +             version = pvti->version;
> >> >> +
> >> >> +             /* This is also a read barrier, so we'll read version first. */
> >> >> +             rdtsc_barrier();
> >> >> +             tsc = __native_read_tsc();
> >> >> +
> >> >> +             pvti_tsc_to_system_mul = pvti->tsc_to_system_mul;
> >> >> +             pvti_tsc_shift = pvti->tsc_shift;
> >> >> +             pvti_system_time = pvti->system_time;
> >> >> +             pvti_tsc = pvti->tsc_timestamp;
> >> >> +
> >> >> +             /* Make sure that the version double-check is last. */
> >> >> +             smp_rmb();
> >> >> +     } while (unlikely((version & 1) || version != pvti->version));
> >> >> +
> >> >> +     delta = tsc - pvti_tsc;
> >> >> +     ret = pvti_system_time +
> >> >> +             pvclock_scale_delta(delta, pvti_tsc_to_system_mul,
> >> >> +                                 pvti_tsc_shift);
> >> >
> >> > The following is possible:
> >> >
> >> > 1) State: all pvtis marked as PVCLOCK_TSC_STABLE_BIT.
> >> > 1) Update request for all vcpus, for a TSC_STABLE_BIT -> ~TSC_STABLE_BIT
> >> > transition.
> >> > 2) vCPU-1 updates its pvti with new values.
> >> > 3) vCPU-0 still has not updated its pvti with new values.
> >> > 4) vCPU-1 VM-enters, uses vCPU-0 values, even though it has been
> >> > notified of a TSC_STABLE_BIT -> ~TSC_STABLE_BIT transition.
> >> >
> >> > The update is not actually atomic across all vCPUs, its atomic in
> >> > the sense of not allowing visibility of distinct
> >> > system_timestamp/tsc_timestamp values.
> >> >
> >>
> >> Hmm.  In step 4, is there a guarantee that vCPU-0 won't VM-enter until
> >> it gets marked unstable?
> >
> > Yes. It will VM-enter after pvti is updated.
> >
> >> Otherwise the vdso could could just as
> >> easily be called from vCPU-1, migrated to vCPU-0, read the data
> >> complete with stale stable bit, and get migrated back to vCPU-1.
> >
> > Right.
> >
> >> But I thought that KVM currently froze all vCPUs when updating pvti
> >> for any of them.  How can this happen?  I admit I don't really
> >> understand the update request code.
> >
> > The update is performed as follows:
> >
> >         - Stop guest instruction execution on every vCPU, parking them in the host.
> >         - Request KVMCLOCK update for every vCPU.
> >         - Resume guest instruction execution.
> >
> > The KVMCLOCK update (==pvti update) is guaranteed to be performed before
> > guest instructions are executed again.
> >
> > But there is no guarantee that vCPU-N has updated its pvti when
> > vCPU-M resumes guest instruction execution.
> 
> Still confused.  So we can freeze all vCPUs in the host, then update
> pvti 1, then resume vCPU 1, then update pvti 0?  In that case, we have
> a problem, because vCPU 1 can observe pvti 0 mid-update, and KVM
> doesn't increment the version pre-update, and we can return completely
> bogus results.

Yes.

> > So the cost this patch removes is mainly from __getcpu (==RDTSCP?) ?
> 
> It removes a whole bunch of code, an extra barrier, and two __getcpus.
> 
> > Perhaps you can use Gleb's idea to stick vcpu id into version field ?
> 
> I don't understand how that's useful at all.  If you're reading pvti,
> you clearly know the vcpu id.

Replace the return value of __getcpus by value read from pvti.version.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbaLVQD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:03:27 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:45624 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbaLVQD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:03:26 -0500
MIME-Version: 1.0
In-Reply-To: <20141222133430.GA23631@amt.cnet>
References: <CALCETrV4Bhc=pwjJR-S7dfgcR7n0xKtj0o=ofOxCfJmnVFcjGw@mail.gmail.com>
 <20141222133430.GA23631@amt.cnet>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 22 Dec 2014 08:03:04 -0800
Message-ID: <CALCETrXU+Z_t3qon+DR1hUiqSgpWLe9w74guBxbDG68ytM0icg@mail.gmail.com>
Subject: Re: Cleaning up the KVM clock
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 5:34 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> On Sat, Dec 20, 2014 at 07:31:19PM -0800, Andy Lutomirski wrote:
>> I'm looking at the vdso timing code, and I'm puzzled by the pvclock
>> code.  My motivation is comprehensibility, performance, and
>> correctness.
>>
>> # for i in `seq 10`; do ./timing_test_64 10 vclock_gettime 0; done
>> 10000000 loops in 0.69138s = 69.14 nsec / loop
>> 10000000 loops in 0.63614s = 63.61 nsec / loop
>> 10000000 loops in 0.63213s = 63.21 nsec / loop
>> 10000000 loops in 0.63087s = 63.09 nsec / loop
>> 10000000 loops in 0.63079s = 63.08 nsec / loop
>> 10000000 loops in 0.63096s = 63.10 nsec / loop
>> 10000000 loops in 0.63096s = 63.10 nsec / loop
>> 10000000 loops in 0.63062s = 63.06 nsec / loop
>> 10000000 loops in 0.63100s = 63.10 nsec / loop
>> 10000000 loops in 0.63112s = 63.11 nsec / loop
>> bash-4.3# echo tsc
>> >/sys/devices/system/clocksource/clocksource0/current_clocksource
>> [   45.957524] Switched to clocksource tsc
>> bash-4.3# for i in `seq 10`; do ./timing_test_64 10 vclock_gettime 0;
>> done10000000 loops in 0.33583s = 33.58 nsec / loop
>> 10000000 loops in 0.28530s = 28.53 nsec / loop
>> 10000000 loops in 0.28904s = 28.90 nsec / loop
>> 10000000 loops in 0.29001s = 29.00 nsec / loop
>> 10000000 loops in 0.28775s = 28.78 nsec / loop
>> 10000000 loops in 0.30102s = 30.10 nsec / loop
>> 10000000 loops in 0.28006s = 28.01 nsec / loop
>> 10000000 loops in 0.28584s = 28.58 nsec / loop
>> 10000000 loops in 0.28175s = 28.17 nsec / loop
>> 10000000 loops in 0.28724s = 28.72 nsec / loop
>>
>> The current code is rather slow, especially compared to the tsc variant.
>>
>> The algorithm used by the pvclock vgetsns implementation is, approximately:
>>
>> cpu = getcpu;
>> pvti = pointer to the relevant paravirt data
>> version = pvti->version;
>> rdtsc_barrier();
>> tsc = rdtsc()
>> delta = (tsc - x) * y >> z;
>> cycles = delta + w;
>> flags = pvti->flags;
>> rdtsc_barrier();  <-- totally unnecessary
>>
>> cpu1 = getcpu;
>> if (cpu != cpu1 || the we missed the seqlock)
>>   retry;
>>
>> if (!stable)
>>   bail;
>>
>> After that, the main vclock_gettime code applies the kernel's regular
>> time adjustments.
>>
>>
>> First, is there any guarantee that, if pvti is marked as stable, that
>> the pvti data is consistent across cpus?  If so (which would be really
>> nice), then we could always use vcpu 0's pvti, which would be a really
>> nice cleanup.
>>
>> If not, then the current algorithm is buggy.  There is no guarantee
>> that the tsc stamp we get matches the cpu whose pvti we looked at.  We
>> could fix that using rdtscp.
>
> Please read the comment at arch/x86/kvm/x86.c which starts with
>
> "Assuming a stable TSC across physical CPUS, and a stable TSC".
>
>> I think it's also rather strange that the return value is "cycles"
>> instead of nanoseconds.  If the guest is using pvclock *and* ntp,
>> isn't something very wrong?
>>
>> Can the algorithm just be:
>>
>> tsc, cpu = rdtscp;
>> pvti = pvti for cpu
>>
>> read the scale, offset, etc;
>> if (!stable)
>>   bail;
>
> "The RDTSCP instruction waits until all previous instructions have been
> executed before reading the counter.
> However, subsequent instructions may begin execution before the read
> operation is performed."
>
> So you would need a barrier there after RDTSCP.
>

After considerable manual reading and experimentation a couple years
ago, the conclusion was that:

 - RDTSCP is ordered like a load on AMD and Intel.  That means that
you can't observe RDTSCP by itself failing to be monotonic across
CPUs.

 - RDTSC by itself is not ordered.  It's easy to observe it behaving
non-monotonically.

 - rdtsc_barrier(); RDTSC is ordered like RDTSCP on AMD and Intel.

>> barrier();
>> read pvti->tsc_timestamp;
>> if (tsc < pvti->tsc_timestamp)
>>   retry;
>
> A kvmclock update does not necessarily update tsc_timestamp.

Hmm.

>
> See
>
> "        /*
>          * If the host uses TSC clock, then passthrough TSC as stable
>          * to the guest.
>          */
>         spin_lock(&ka->pvclock_gtod_sync_lock);
>         use_master_clock = ka->use_master_clock;
>         if (use_master_clock) {
>                 host_tsc = ka->master_cycle_now;
>                 kernel_ns = ka->master_kernel_ns;
>         }
> "
>
> At arch/x86/kvm/x86.c.


So there's a much bigger problem here.  Despite the read
implementation and the docs in Documentation/, the KVM hots doesn't
actually use the version field the way it's supposed to.  It just
updates the whole pvti with one __copy_to_user.  It has a comment:

        * The interface expects us to write an even number signaling that the
        * update is finished. Since the guest won't see the intermediate
        * state, we just increase by 2 at the end.

This is wrong.  The guest *kernel* might not see the intermediate
state because the kernel (presumably it disabled migration while
reading pvti), but the guest vdso can't do that and could very easily
observe pvti while it's being written.

Also, __getcpu is completely unordered on current kernels, so it
doesn't generate the code that anyone would expect.  I'll fix that.

I'll send patches for the whole mess, complete with lots of comments,
after I test them a bit today.

--Andy

>
>> if (the versions are unhappy)
>>   retry;
>> return the computed nanosecond count;
>>
>> I think this is likely to be at least as correct as the current
>> algorithm, if not more so, and it correctly handles the case where we
>> migrate to a different vcpu in the middle.  (I also think that, with
>> this algorithm, the version check should also be unnecessary, since if
>> we race with a host update, we'll fail the tsc < pvti->tsc_timestamp
>> check.)
>>
>> It would be even nicer, though, if we could do much the same thing but
>> without worrying about which vcpu we're on.
>>
>> Thoughts?  Am I missing some considerations here?
>
> Maybe we can find another optimization opportunities?
>
> Thanks!
>



-- 
Andy Lutomirski
AMA Capital Management, LLC

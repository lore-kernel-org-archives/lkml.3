Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbaLVKPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 05:15:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327AbaLVKPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 05:15:16 -0500
Message-ID: <5497EF2C.2070305@redhat.com>
Date: Mon, 22 Dec 2014 11:15:08 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Gleb Natapov <gleb@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Cleaning up the KVM clock
References: <CALCETrV4Bhc=pwjJR-S7dfgcR7n0xKtj0o=ofOxCfJmnVFcjGw@mail.gmail.com>
In-Reply-To: <CALCETrV4Bhc=pwjJR-S7dfgcR7n0xKtj0o=ofOxCfJmnVFcjGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21/12/2014 04:31, Andy Lutomirski wrote:
> I'm looking at the vdso timing code, and I'm puzzled by the pvclock
> code.  My motivation is comprehensibility, performance, and
> correctness.
> 
> # for i in `seq 10`; do ./timing_test_64 10 vclock_gettime 0; done
> 10000000 loops in 0.69138s = 69.14 nsec / loop
> 10000000 loops in 0.63614s = 63.61 nsec / loop
> 10000000 loops in 0.63213s = 63.21 nsec / loop
> 10000000 loops in 0.63087s = 63.09 nsec / loop
> 10000000 loops in 0.63079s = 63.08 nsec / loop
> 10000000 loops in 0.63096s = 63.10 nsec / loop
> 10000000 loops in 0.63096s = 63.10 nsec / loop
> 10000000 loops in 0.63062s = 63.06 nsec / loop
> 10000000 loops in 0.63100s = 63.10 nsec / loop
> 10000000 loops in 0.63112s = 63.11 nsec / loop
> bash-4.3# echo tsc
>> /sys/devices/system/clocksource/clocksource0/current_clocksource
> [   45.957524] Switched to clocksource tsc
> bash-4.3# for i in `seq 10`; do ./timing_test_64 10 vclock_gettime 0;
> done10000000 loops in 0.33583s = 33.58 nsec / loop
> 10000000 loops in 0.28530s = 28.53 nsec / loop
> 10000000 loops in 0.28904s = 28.90 nsec / loop
> 10000000 loops in 0.29001s = 29.00 nsec / loop
> 10000000 loops in 0.28775s = 28.78 nsec / loop
> 10000000 loops in 0.30102s = 30.10 nsec / loop
> 10000000 loops in 0.28006s = 28.01 nsec / loop
> 10000000 loops in 0.28584s = 28.58 nsec / loop
> 10000000 loops in 0.28175s = 28.17 nsec / loop
> 10000000 loops in 0.28724s = 28.72 nsec / loop
> 
> The current code is rather slow, especially compared to the tsc variant.
> 
> The algorithm used by the pvclock vgetsns implementation is, approximately:
> 
> cpu = getcpu;
> pvti = pointer to the relevant paravirt data
> version = pvti->version;
> rdtsc_barrier();
> tsc = rdtsc()
> delta = (tsc - x) * y >> z;
> cycles = delta + w;
> flags = pvti->flags;
> rdtsc_barrier();  <-- totally unnecessary

It's not unnecessary.  The first one is a "lock", the second is an
"unlock".  You can move the second rdtsc_barrier below the cpu/seqlock
check though.

> 
> cpu1 = getcpu;
> if (cpu != cpu1 || the we missed the seqlock)
>   retry;
> 
> if (!stable)
>   bail;
> 
> After that, the main vclock_gettime code applies the kernel's regular
> time adjustments.
> 
> First, is there any guarantee that, if pvti is marked as stable, that
> the pvti data is consistent across cpus?  If so (which would be really
> nice), then we could always use vcpu 0's pvti, which would be a really
> nice cleanup.

I think you cannot because the TSCs might not be perfectly synced up
even if the rates are, but...

> If not, then the current algorithm is buggy.  There is no guarantee
> that the tsc stamp we get matches the cpu whose pvti we looked at.  We
> could fix that using rdtscp.

... Marcelo will have to answer this.

> I think it's also rather strange that the return value is "cycles"
> instead of nanoseconds.  If the guest is using pvclock *and* ntp,
> isn't something very wrong?

It's not cycles.  pvclock_get_nsec_offset returns nanoseconds, and
__pvclock_read_cycles does the same.  Patches are welcome. :)

Paolo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaLXVnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 16:43:55 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:46205 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaLXVnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 16:43:53 -0500
MIME-Version: 1.0
In-Reply-To: <CALzav=fuOieDmkWviyzLFyTuyray0=oZWTaOUCBUHRAmiKynmg@mail.gmail.com>
References: <cover.1419295081.git.luto@amacapital.net> <8d09c16eb39cbe264417cc66c4aca730af10b70b.1419295081.git.luto@amacapital.net>
 <CALzav=fuOieDmkWviyzLFyTuyray0=oZWTaOUCBUHRAmiKynmg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 24 Dec 2014 13:43:30 -0800
Message-ID: <CALCETrX1zvwPOaeuUM6wbir0ajRy4a7UuXdqgXsJJ3AZFRWRow@mail.gmail.com>
Subject: Re: [RFC 2/2] x86, vdso, pvclock: Simplify and speed up the vdso
 pvclock reader
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 1:30 PM, David Matlack <dmatlack@google.com> wrote:
> On Mon, Dec 22, 2014 at 4:39 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> The pvclock vdso code was too abstracted to understand easily and
>> excessively paranoid.  Simplify it for a huge speedup.
>>
>> This opens the door for additional simplifications, as the vdso no
>> longer accesses the pvti for any vcpu other than vcpu 0.
>>
>> Before, vclock_gettime using kvm-clock took about 64ns on my machine.
>> With this change, it takes 19ns, which is almost as fast as the pure TSC
>> implementation.
>>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>  arch/x86/vdso/vclock_gettime.c | 82 ++++++++++++++++++++++++------------------
>>  1 file changed, 47 insertions(+), 35 deletions(-)
>>
>> diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
>> index 9793322751e0..f2e0396d5629 100644
>> --- a/arch/x86/vdso/vclock_gettime.c
>> +++ b/arch/x86/vdso/vclock_gettime.c
>> @@ -78,47 +78,59 @@ static notrace const struct pvclock_vsyscall_time_info *get_pvti(int cpu)
>>
>>  static notrace cycle_t vread_pvclock(int *mode)
>>  {
>> -       const struct pvclock_vsyscall_time_info *pvti;
>> +       const struct pvclock_vcpu_time_info *pvti = &get_pvti(0)->pvti;
>>         cycle_t ret;
>> -       u64 last;
>> -       u32 version;
>> -       u8 flags;
>> -       unsigned cpu, cpu1;
>> -
>> +       u64 tsc, pvti_tsc;
>> +       u64 last, delta, pvti_system_time;
>> +       u32 version, pvti_tsc_to_system_mul, pvti_tsc_shift;
>>
>>         /*
>> -        * Note: hypervisor must guarantee that:
>> -        * 1. cpu ID number maps 1:1 to per-CPU pvclock time info.
>> -        * 2. that per-CPU pvclock time info is updated if the
>> -        *    underlying CPU changes.
>> -        * 3. that version is increased whenever underlying CPU
>> -        *    changes.
>> +        * Note: The kernel and hypervisor must guarantee that cpu ID
>> +        * number maps 1:1 to per-CPU pvclock time info.
>> +        *
>> +        * Because the hypervisor is entirely unaware of guest userspace
>> +        * preemption, it cannot guarantee that per-CPU pvclock time
>> +        * info is updated if the underlying CPU changes or that that
>> +        * version is increased whenever underlying CPU changes.
>> +        *
>> +        * On KVM, we are guaranteed that pvti updates for any vCPU are
>> +        * atomic as seen by *all* vCPUs.  This is an even stronger
>> +        * guarantee than we get with a normal seqlock.
>>          *
>> +        * On Xen, we don't appear to have that guarantee, but Xen still
>> +        * supplies a valid seqlock using the version field.
>> +
>
> Forgotten * here?
>
>> +        * We only do pvclock vdso timing at all if
>> +        * PVCLOCK_TSC_STABLE_BIT is set, and we interpret that bit to
>> +        * mean that all vCPUs have matching pvti and that the TSC is
>> +        * synced, so we can just look at vCPU 0's pvti.
>>          */
>> -       do {
>> -               cpu = __getcpu() & VGETCPU_CPU_MASK;
>> -               /* TODO: We can put vcpu id into higher bits of pvti.version.
>> -                * This will save a couple of cycles by getting rid of
>> -                * __getcpu() calls (Gleb).
>> -                */
>> -
>> -               pvti = get_pvti(cpu);
>> -
>> -               version = __pvclock_read_cycles(&pvti->pvti, &ret, &flags);
>> -
>> -               /*
>> -                * Test we're still on the cpu as well as the version.
>> -                * We could have been migrated just after the first
>> -                * vgetcpu but before fetching the version, so we
>> -                * wouldn't notice a version change.
>> -                */
>> -               cpu1 = __getcpu() & VGETCPU_CPU_MASK;
>> -       } while (unlikely(cpu != cpu1 ||
>> -                         (pvti->pvti.version & 1) ||
>> -                         pvti->pvti.version != version));
>> -
>> -       if (unlikely(!(flags & PVCLOCK_TSC_STABLE_BIT)))
>> +
>> +       if (unlikely(!(pvti->flags & PVCLOCK_TSC_STABLE_BIT))) {
>>                 *mode = VCLOCK_NONE;
>> +               return 0;
>> +       }
>> +
>> +       do {
>> +               version = pvti->version;
>> +
>> +               /* This is also a read barrier, so we'll read version first. */
>> +               rdtsc_barrier();
>> +               tsc = __native_read_tsc();
>
> Is there a reason why you read the tsc inside the loop rather than once
> after the loop?

I want to make sure that the tsc value used is consistent with the
scale and offset.  Otherwise it would be possible to read the pvti
data, then get preempted and sleep for a long time before rdtsc.  The
result could be a time value larger than an immediate subsequent call
would return.

--Andy

>
>> +
>> +               pvti_tsc_to_system_mul = pvti->tsc_to_system_mul;
>> +               pvti_tsc_shift = pvti->tsc_shift;
>> +               pvti_system_time = pvti->system_time;
>> +               pvti_tsc = pvti->tsc_timestamp;
>> +
>> +               /* Make sure that the version double-check is last. */
>> +               smp_rmb();
>> +       } while (unlikely((version & 1) || version != pvti->version));
>> +
>> +       delta = tsc - pvti_tsc;
>> +       ret = pvti_system_time +
>> +               pvclock_scale_delta(delta, pvti_tsc_to_system_mul,
>> +                                   pvti_tsc_shift);
>>
>>         /* refer to tsc.c read_tsc() comment for rationale */
>>         last = gtod->cycle_last;
>> --
>> 2.1.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Andy Lutomirski
AMA Capital Management, LLC

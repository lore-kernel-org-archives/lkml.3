Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbaIDTAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 15:00:33 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:54078 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbaIDTAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 15:00:31 -0400
MIME-Version: 1.0
In-Reply-To: <54088CB5.6050406@canonical.com>
References: <1409835487-14371-1-git-send-email-pbonzini@redhat.com>
	<54088CB5.6050406@canonical.com>
Date: Thu, 4 Sep 2014 12:00:30 -0700
Message-ID: <CALAqxLV0-9q_HNMSWrmqX0esUBecUBGDc3EOe_7gtbb4ZCnLJQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: fix kvmclock breakage from timers branch merge
From: John Stultz <john.stultz@linaro.org>
To: Chris J Arges <chris.j.arges@canonical.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 9:00 AM, Chris J Arges
<chris.j.arges@canonical.com> wrote:
>
>
> On 09/04/2014 07:58 AM, Paolo Bonzini wrote:
>> Commit cbcf2dd3b3d4 (x86: kvm: Make kvm_get_time_and_clockread() nanoseconds
>> based, 2014-07-16) forgot to add tk->xtime_sec, thus breaking kvmclock on
>> hosts that have a reliable TSC.  Add it back; and since the field boot_ns
>> is not anymore related to the host boot-based clock, rename boot_ns->nsec_base
>> and the existing nsec_base->snsec_base.
>>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: John Stultz <john.stultz@linaro.org>
>> Reported-by: Chris J Arges <chris.j.arges@canonical.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  arch/x86/kvm/x86.c | 11 ++++++-----
>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 8f1e22d3b286..92493e10937c 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1020,8 +1020,8 @@ struct pvclock_gtod_data {
>>               u32     shift;
>>       } clock;
>>
>> -     u64             boot_ns;
>>       u64             nsec_base;
>> +     u64             snsec_base;
>>  };
>>
>>  static struct pvclock_gtod_data pvclock_gtod_data;
>> @@ -1042,8 +1042,9 @@ static void update_pvclock_gtod(struct timekeeper *tk)
>>       vdata->clock.mult               = tk->tkr.mult;
>>       vdata->clock.shift              = tk->tkr.shift;
>>
>> -     vdata->boot_ns                  = boot_ns;
>> -     vdata->nsec_base                = tk->tkr.xtime_nsec;
>> +     vdata->nsec_base                = tk->xtime_sec * (u64)NSEC_PER_SEC
>> +                                     + boot_ns;
>> +     vdata->snsec_base               = tk->tkr.xtime_nsec;
>>
>>       write_seqcount_end(&vdata->seq);
>>  }
>> @@ -1413,10 +1414,10 @@ static int do_monotonic_boot(s64 *t, cycle_t *cycle_now)
>>       do {
>>               seq = read_seqcount_begin(&gtod->seq);
>>               mode = gtod->clock.vclock_mode;
>> -             ns = gtod->nsec_base;
>> +             ns = gtod->snsec_base;
>>               ns += vgettsc(cycle_now);
>>               ns >>= gtod->clock.shift;
>> -             ns += gtod->boot_ns;
>> +             ns += gtod->nsec_base;
>>       } while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
>>       *t = ns;
>>
>>
>
> Paulo,
> I've tested with the above patch and I still have issues with the
> kvmclock test offset; however the cycle tests pass now.
>
> Here is trace data:
> http://people.canonical.com/~arges/kvm/trace-4.dat.xz
>
> Uptime:
>  15:58:02 up  1:00,  1 user,  load average: 0.59, 0.60, 0.31
>
> Here is the output:
>
> ./x86-run x86/kvmclock_test.flat -smp 2 --append "10000000 `date +%s`"
> qemu-system-x86_64 -enable-kvm -device pc-testdev -device
> isa-debug-exit,iobase=0xf4,iosize=0x4 -display none -serial stdio
> -device pci-testdev -kernel x86/kvmclock_test.flat -smp 2 --append
> 10000000 1409846210
> enabling apic
> enabling apic
> kvm-clock: cpu 0, msr 0x:44d4c0
> kvm-clock: cpu 0, msr 0x:44d4c0
> Wallclock test, threshold 5
> Seconds get from host:     1409846210
> Seconds get from kvmclock: 2819688866
> Offset:                    1409842656
> offset too large!


Hey, thanks for reporting the issue and sending an initial patch (even
if its not quite all sorted yet).

Is the test you're using here available somewhere? Are there any
special requirements to run it?

thanks
-john

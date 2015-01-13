Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbbAMR6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:58:01 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:64722 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbbAMR57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:57:59 -0500
MIME-Version: 1.0
In-Reply-To: <54B5598F.4070202@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com>
 <1421012793-30106-5-git-send-email-riel@redhat.com> <20150113171134.GA27519@redhat.com>
 <CALCETrWuOeYYpwbfX3x56KZSV_1nC+r7GHRiYH=pt_xOuOVM2g@mail.gmail.com> <54B5598F.4070202@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 13 Jan 2015 09:57:38 -0800
Message-ID: <CALCETrXRs7AgTEgDV93RA=5_Of--W9Q4H+oVVbZPrDeWRs8Y_g@mail.gmail.com>
Subject: Re: [RFC PATCH 04/11] x86,fpu: defer FPU restore until return to userspace
To: Rik van Riel <riel@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 9:44 AM, Rik van Riel <riel@redhat.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 01/13/2015 12:18 PM, Andy Lutomirski wrote:
>> On Tue, Jan 13, 2015 at 9:11 AM, Oleg Nesterov <oleg@redhat.com>
>> wrote:
>>> On 01/11, riel@redhat.com wrote:
>>>>
>>>> Defer restoring the FPU state, if so desired, until the task
>>>> returns to userspace.
>>>
>>> And I have another concern.
>>>
>>> Afaocs with this patch the idle threads will run with
>>> TIF_LOAD_FPU set but without fpu.has_fpu.
>>
>> Yuck.  IMO there are still too many possible states.
>>
>> AFAICS the sensible states for a task are:
>>
>> - Task is current on some cpu and FPU is loaded into that cpu. -
>> Task is current on some cpu and FPU is in memory. - Task is current
>> on some cpu and FPU is loaded into a different cpu.
>
> When switching a task out, in prepare_fpu_switch() we will always save
> the FPU state to memory. The third case can be treated identical to the
> second case.

Then what's last_cpu for?

>
>> - Task is not current and FPU is in memory. - Task is not current
>> and FPU is loaded into some cpu.
>
> Same for this one. When the task is not current, the FPU state
> will have been saved to memory. If we try running the task
> somewhere else, it devolves to "FPU is in memory".
>

Isn't there a case where the FPU is in memory *and* in the cpu regs?
Isn't that how you can skip reloading the FPU after going idle and
returning?  Is this what fpu_lazy_restore is for?  Confused.

>> Am I missing anything?  (In lazy mode, there are a few more
>> involving CR0.TS.)
>>
>> That's five states, plus an optional cpu number.  But we have tons
>> of state variable that can express all kinds of nonsense things.
>>
>> If we asserted that we were in a sensible state and fixed the
>> things that exited the sensible states, maybe this would be easier
>> to understand and debug.
>
> Lets see what things we could test, at different points.
>
> 1) At context switch time, we need to make sure that the previous task
>    will no longer have __thread_has_fpu()
>
> 2) When loading the FPU state, we need to make sure that the current
>    task does not have __thread_has_fpu()

Examples, any of which may be wrong:

If !current, then !TIF_LOAD_FPU

If switching out a task with TIF_LOAD_FPU set, then !has_fpu

If last_cpu == smp_processor_id(), then fpu_owner == fpu.

If has_fpu, then the task must be current somewhere and last_cpu must
be the cpu on which it's current.

At the very least, asking these questions may help fill in holes in my
understanding :)

--Andy

>
> 3) ... what else?
>
> - --
> All rights reversed
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1
>
> iQEcBAEBAgAGBQJUtVmPAAoJEM553pKExN6Dc0gIAI0JZE4VpNlJElnuGbFKzM8t
> r9dSH3XLeEX5/JARsQMNuwUL7HjjBbYO9PrdpejVAEUq2XltVyq3+RuSYMBprlpV
> aCWKrw9jn7H43++LSziXh0LP+t+zqL9+/5WUm3oVWkTXJEBu9CdNgYYP7luf87nX
> +mxqDsp5YjmmYJRW2LncK/SuEpItTAtHI5bORjsbWNQOZ2pl31cr1ZEbdrRaZqje
> 5wONfs0f2mor0Ms7FSzVJCNmps3TGJnfpkx37vzqRiPkisdWVcM16RwvM6jJTFZ+
> VmM2Jj4xWMhPYvqpZ8oZWAb8xNCl+DijjZFEGW1j9Ji5gcPQ2HLvFEWNp3TpIeM=
> =OU/0
> -----END PGP SIGNATURE-----



-- 
Andy Lutomirski
AMA Capital Management, LLC

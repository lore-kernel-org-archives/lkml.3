Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbbAMS0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:26:49 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:55474 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbbAMS0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:26:48 -0500
MIME-Version: 1.0
In-Reply-To: <54B5604E.1070403@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com>
 <1421012793-30106-5-git-send-email-riel@redhat.com> <20150113171134.GA27519@redhat.com>
 <CALCETrWuOeYYpwbfX3x56KZSV_1nC+r7GHRiYH=pt_xOuOVM2g@mail.gmail.com>
 <54B5598F.4070202@redhat.com> <CALCETrXRs7AgTEgDV93RA=5_Of--W9Q4H+oVVbZPrDeWRs8Y_g@mail.gmail.com>
 <54B5604E.1070403@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 13 Jan 2015 10:26:25 -0800
Message-ID: <CALCETrWcX5s30bMq+ivYoRiUngq-rXGqX=QDz7uq3j43wQzDZA@mail.gmail.com>
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

On Tue, Jan 13, 2015 at 10:13 AM, Rik van Riel <riel@redhat.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 01/13/2015 12:57 PM, Andy Lutomirski wrote:
>> On Tue, Jan 13, 2015 at 9:44 AM, Rik van Riel <riel@redhat.com>
>> wrote: On 01/13/2015 12:18 PM, Andy Lutomirski wrote:
>
>>>>> - Task is not current and FPU is in memory. - Task is not
>>>>> current and FPU is loaded into some cpu.
>>
>>> Same for this one. When the task is not current, the FPU state
>>> will have been saved to memory. If we try running the task
>>> somewhere else, it devolves to "FPU is in memory".
>>
>>
>> Isn't there a case where the FPU is in memory *and* in the cpu
>> regs? Isn't that how you can skip reloading the FPU after going
>> idle and returning?  Is this what fpu_lazy_restore is for?
>> Confused.
>
> Indeed, if we end up running the task on the same CPU again, and the
> FPU still has the state loaded, we may skip restoring the FPU state.
>
>>>>> Am I missing anything?  (In lazy mode, there are a few more
>>>>> involving CR0.TS.)
>>>>>
>>>>> That's five states, plus an optional cpu number.  But we have
>>>>> tons of state variable that can express all kinds of nonsense
>>>>> things.
>>>>>
>>>>> If we asserted that we were in a sensible state and fixed
>>>>> the things that exited the sensible states, maybe this would
>>>>> be easier to understand and debug.
>>
>> Lets see what things we could test, at different points.
>>
>> 1) At context switch time, we need to make sure that the previous
>> task will no longer have __thread_has_fpu()
>>
>> 2) When loading the FPU state, we need to make sure that the
>> current task does not have __thread_has_fpu()
>>
>>> Examples, any of which may be wrong:
>>
>>> If !current, then !TIF_LOAD_FPU
>
> We set TIF_LOAD_CPU on the next task at context switch time,
> which is different from the current task. I suspect we can
> deal with that exception, though :)
>
> What we can test is that "new" does not already have TIF_LOAD_CPU
> set...
>
>>> If switching out a task with TIF_LOAD_FPU set, then !has_fpu
>
> ... and that old does not have both TIF_LOAD_FPU and has_fpu.
>
>>> If last_cpu == smp_processor_id(), then fpu_owner == fpu.
>
> Not necessarily, since the task may not have entered userspace in
> a very long time, so it may not have loaded its FPU context.
>

Is the idea that it's possible for fpu_owner == fpu if the task is
brand new (i.e. fpu_owner really refers to some now-dead task whose
memory is reused) but that, if this is the case, then last_cpu won't
match that cpu?

If so, then I think that I'm finally starting to understand that part of it.

>>> If has_fpu, then the task must be current somewhere and last_cpu
>>> must be the cpu on which it's current.
>
> Indeed, if has_fpu, then last_cpu must match the current cpu.

Phew.

Thanks,
Andy

>
>
> - --
> All rights reversed
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1
>
> iQEcBAEBAgAGBQJUtWBOAAoJEM553pKExN6DNwIH/2wzfLqqM1V/Asd29nidDUrw
> zD7HN//LyWTLjNMfAS4M/rOk3LsbphFBOo2L5BE7CYoNAGEWwKcQi7ld3dDAXeZL
> +AkRtzMNEU1NqzrtnpGhABBrn3wBXwr9ldKSlaVQhYUop3q5Hhg8lyo2v+wWKf7y
> ULi/RLiERS72tUomFXTE4RT021N2h+tl42jSREEyT0+VqEc7vqTlb5fctsF3VAhS
> g48fX/VOYit3rXFU9hPz9m9vnodsEGCapdRxsXaE4xA7lg8dZ5WsaAos2TUwPQYt
> EyCbS9z2Yzy1UpySwZudo6OGbQIaugOtgrcCS/cvdvlRb8K4mLe+807MPGmBOGA=
> =7wEX
> -----END PGP SIGNATURE-----



-- 
Andy Lutomirski
AMA Capital Management, LLC

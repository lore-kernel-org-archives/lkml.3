Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3AWNIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 08:08:30 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:56362 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab3AWNI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 08:08:29 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAFTL4hxW96Q=MDFmMw8dtJGY0yT6w0uEc20gB46oTEJuefbTSQ@mail.gmail.com>
References: <CA+icZUWuMEX7s8wvTZpA3C2-3qUjHgWM31Tefep_EU5Uj9xxLw@mail.gmail.com>
	<CA+icZUXzQgxBokwOmyx5+e8rLNCkoz6ea=YoPA7=BT+iENWj8g@mail.gmail.com>
	<CAFTL4hzmf9ZLb4=QjpGFXT96EwOyRSFbqBD0VjLgKYaZGrBzYg@mail.gmail.com>
	<CA+icZUV-e51Fg2xvhxz5Wvjj-g=tyft56eNmF9ZGrnJzkL+wUQ@mail.gmail.com>
	<CAFTL4hxW96Q=MDFmMw8dtJGY0yT6w0uEc20gB46oTEJuefbTSQ@mail.gmail.com>
Date: Wed, 23 Jan 2013 14:08:28 +0100
Message-ID: <CA+icZUUbYA=QzXVJjRRQdSjqWM8Ap7p5vqPE3JL1YzHzArXcpw@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.8-rc4-nohz3
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 1:20 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 2013/1/23 Sedat Dilek <sedat.dilek@gmail.com>:
>> On Wed, Jan 23, 2013 at 1:11 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>> 2013/1/23 Sedat Dilek <sedat.dilek@gmail.com>:
>>>> On Wed, Jan 23, 2013 at 12:19 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>>> Hi Frederic,
>>>>>
>>>>> I wanted to 3.8-rc4-nohz3 [1] here on my Ubuntu/precise AMD64 system.
>>>>>
>>>>> Unfortunately, the build breaks like this:
>>>>>
>>>>> ERROR: "guest_enter" [arch/x86/kvm/kvm.ko] undefined!
>>>>> ERROR: "guest_exit" [arch/x86/kvm/kvm.ko] undefined!
>>>>>
>>>>
>>>> Looks like you tested with CONFIG_KVM=y (as module fails!).
>>>
>>> Yep. looks like I forgot some EXPORT_SYMBOL().
>>>
>>
>> Hmmm, that was my first thought, too, but about...
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index c243b81..fff0932 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -5713,7 +5713,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>         if (req_immediate_exit)
>>                 smp_send_reschedule(vcpu->cpu);
>>
>> -       kvm_guest_enter();
>> +       guest_enter();
>>
>>         if (unlikely(vcpu->arch.switch_db_regs)) {
>>                 set_debugreg(0, 7);
>
> Yeah, guest_enter and guest_exit need an EXPORT_SYMBOL() in
> kernel/context_tracking.c such that the module can find these
> functions.

My patch did not fix it!

kernel/context_tracking.c:114:EXPORT_SYMBOL_GPL(guest_enter);
kernel/context_tracking.c:123:EXPORT_SYMBOL_GPL(guest_exit);

[ build-log ]
ERROR: "guest_enter" [arch/x86/kvm/kvm.ko] undefined!
ERROR: "guest_exit" [arch/x86/kvm/kvm.ko] undefined!
make[3]: *** [__modpost] Error 1

$ egrep 'CONFIG_KVM|CONFIG_CONTEXT_TRACKING' linux/.config
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_KVM_GUEST=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set

- Sedat -

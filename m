Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab3LYIWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 03:22:06 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:40533 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab3LYIWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 03:22:04 -0500
MIME-Version: 1.0
In-Reply-To: <52B9881E.4090702@redhat.com>
References: <1385990638-19548-1-git-send-email-prarit@redhat.com>
	<CANVTcTZ-ZkTvR0+=eFyNQ7E8R2UYo1qdA-RQ+9nzK2w=qCPkPQ@mail.gmail.com>
	<52B856D3.4030802@redhat.com>
	<CANVTcTb8SJKriUeRb9pxNiqAkwxO4p0N1-M3krHGeLduHsqrEQ@mail.gmail.com>
	<52B9881E.4090702@redhat.com>
Date: Wed, 25 Dec 2013 16:22:00 +0800
Message-ID: <CANVTcTb+1+03mRzyO7r1=OTkrocdZC2hY8YWoxE9vmfYEbS_cA@mail.gmail.com>
Subject: Re: [PATCH] x86, Fix do_IRQ interrupt warning for cpu hotplug
 retriggered irqs
From: rui wang <ruiv.wang@gmail.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Michel Lespinasse <walken@google.com>,
        Andi Kleen <ak@linux.intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, janet.morgan@intel.com,
        tony.luck@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/13, Prarit Bhargava <prarit@redhat.com> wrote:
>
>
> On 12/23/2013 11:41 PM, rui wang wrote:
>> On 12/23/13, Prarit Bhargava <prarit@redhat.com> wrote:
>> > I think I have root caused this to the IRR being set in the down'd cpu.
>> > It
>> > is
>> > admittedly a rare occurrence in the kernel.  I usually have to run
>> > about
>> > 1000 up
>> > and down's before hitting it, however, on my current test system it
>> > seems to
>> > hit
>> > much more frequently, almost 1 in 64 times.
>> >
>>>
>>
>> If that's the case, then it means stop_machine() doesn't manage to
>> clear the IRR and ISR bits. But why not? Since this cpu is down it's
>> not supposed to handle any further interrupts.
>
> ISR bits can be cleared by software (via EOI).  IRR bits CANNOT be cleared
> by
> software.  Once IRR bits are set the only thing that can clear them is the
> processor itself.
>
> IMHO we're supposed to
>> send EOIs repeatedly until all the APIC_IRR and APIC_ISR bits are
>> cleared. If an IRR bit is set, it means that there's (maybe another
>> vector) an APIC_ISR bit set with the highest interrupt priority
>
> I don't think that is quite right (admittedly I may be wrong on this and
> I'll
> have to dig out an Intel spec to double check).  As I mentioned above the
> ISR
> can be cleared but the IRR cannot be cleared.
>
> My understanding (also other's understanding on clearing of the IRR) is
> that
> only the processor can clear the IRR.  See arch/x86/kernel/apic/apic.c line
> 1352
> and the code below it.  Because of kexec boot, we "drain" the IRR by
> waiting.  I
> remember talking to the people who wrote that code about the IRR and the
> inability to affect a write to clear requested and pending IRQs.
>
>> Sending an EOI clears the highest priority APIC_ISR bit, so the LAPIC
>> will then clear the next highest priority IRR bit and set the
>> corresponding ISR bit...
>
> But the issue here is that the IRR has been set, but the processor is yet
> to
> execute the irq's handler.  That's what makes this error so difficult to
> hit.
> It is a race with the hardware to catch the processor in exactly this
> state.
>
> We can repeat the process. It's like handling
>> interrups in polled mode. That's the right thing to do IMHO.
>
> But the IRR register bits are still set and once the processor is out of
> interrupt context (ie, in the cpu_die() code) the processor will attempt to
> access the vector for that IRR bit and we'll still get a do_IRQ() warning.
> That
> is different than handling the ISR.
>
> [Aside: Sorry Rui, but it feels like I repeated myself several times about
> the
> IRR :).  I mean no disrespect towards you by that :) as I'm just answering
> each
> of your points and pointing out that the IRR is the problem here.]
>

I just did some experiments. Yes you are right. The IRR is hard to
clear. I thought the IRR could transfer into an ISR when there's no
higher priority irq pending. But it's not designed in that way.

>>
>> The other unanswered question is why isn't cpu_online_mask() protected
>> by a spin lock ? Being atomic isn't enough.
>
> Perhaps it is thought that the cpu_online_mask() can only be changed by the
> cpu
> hotplug code and that is done via stop_machine() and protected by
> cpu_maps_update_begin() and cpu_maps_update_done() in cpu_down()?  So an
> additional lock is not necessary?
>

Yes. I missed that part.

Thanks
Rui

>>
>> Are these all well-known issues? Are there well-known answers already?
>
> I thought the bug was well-known because of the number of do_IRQ warning
> reports
> I stumbled across while searching for a solution.  But as the code says in
> fixup_irqs()
>
>         /*
>          * We can remove mdelay() and then send spuriuous interrupts to
>          * new cpu targets for all the irqs that were handled previously by
>          * this cpu. While it works, I have seen spurious interrupt
> messages
>          * (nothing wrong but still...).
>
> so I don't think anyone has realized what the bug actually was.
> 	

Yes that comment was what triggered me to think that the issue wasn't
understood. You now have a clear enough explanation.

Thanks
Rui

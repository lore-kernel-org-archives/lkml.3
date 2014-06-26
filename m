Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaFZM7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 08:59:08 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50150 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaFZM7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:59:06 -0400
Message-ID: <53AC1906.90103@linaro.org>
Date: Thu, 26 Jun 2014 14:58:46 +0200
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 0/9] ARM: Forwarding physical interrupts to a guest
 VM
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com> <53AAE242.3060405@linaro.org> <53ABE88C.1010401@arm.com>
In-Reply-To: <53ABE88C.1010401@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2014 11:31 AM, Marc Zyngier wrote:
> Hi Eric,
> 
> On 25/06/14 15:52, Eric Auger wrote:
>> On 06/25/2014 11:28 AM, Marc Zyngier wrote:
>>> The GIC architecture (ARM's Generic Interrupt Controller) allows an
>>> active physical interrupt to be forwarded to a guest, and the guest to
>>> indirectly perform the deactivation of the interrupt by performing an
>>> EOI on the virtual interrupt (see for example the GICv2 spec, 3.2.1).
>>>
>>> So far, Linux doesn't have this notion, which is a bit of a pain.
>>>
>>> This patch series introduce two generic features:
>>>
>>> - A way to mark an interrupt as "forwarded": this allows an irq_chip
>>>   to know that it shouldn't perform the deactivation itself
>>> - A way to save/restore the "state" of a "forwarded" interrupt
>>>
>>> The series then adapts both GIC drivers to switch to EOImode == 1
>>> (split priority drop and deactivation), to support this "forwarded"
>>> feature and hacks the KVM/ARM timer backend to use all of this.
>>>
>>> This requires yet another bit of surgery in the vgic code in order to
>>> allow a mapping between physical interrupts and virtual
>>> ones. Hopefully, this should plug into VFIO and the whole irqfd thing,
>>> but I don't understand any of that just yet (Eric?)
>>
>> Hello Marc,
Hi Marc
>>
>> Thanks for the patch, it brings a very interesting capability for
>> improving the performance of KVM device assignment.
>>
>> From the integration pov I understand we need to
>> 1) call irq_set_fwd_state to tell the gic the physical IRQ is forwarded
>> and not deactivate it
> 
> That would be irqd_set_irq_forwarded().
> 
> irq_{g,s}et_fwd_state() are used when you're actually sharing a device
> between guests, and need to context-switch its HW interrupt state
> (typically, the timer). I wouldn't expect VFIO to use this, as the
> device is exclusively assigned to a guest.
OK
> 
>> 2) call vgic_map_phys_irq to the tell the vgic it must program the LRs
>> accordingly.
>>
>> We currently have the vfio driver VFIO_DEVICE_SET_IRQS user API that
>> makes possible to tell: device IRQ index #i (i=0, 1, 2 for my xgmac)
>> shall trigger this fd.
>> At that point it would be possible to tell the GIC the physical IRQ
>> corresponding to i is forwarded.
>>
>> On the other hand we have KVM_IRQFD that enables to tell KVM: when this
>> fd is triggered, you implement its handler in KVM irqfd framework and
>> the handler injects the provided irchip.pin(gsi)=virtualIRQ - the famous
>> GSI routing table - into this VM.
>>
>> Building the vgic map table hence requires to do some glue around vfio
>> and irqfd info: physical IRQ ->(vfio) fd ->(irqfd) gsi.
>>
>> As such I would say those 2 user APIs(VFIO and IRQFD) are not fully
>> adapted to put that in place but this may be feasible. Previous
>> KVM_ASSIGN_DEV_IRQ was directly associated the pIRQ and vIRQ.
>>
>> we should be able to remove the physical IRQ mask in the vfio driver
>> (this masking is done when triggering the fd and the IRQ is unmasked
>> when the virtual IRQ is completed). It was there because the physical
>> IRQ was completed and could hit again. Now with 2 stage completion the
>> same IRQ cannot hit while guest has not not DIR'ed the IRQ so it fixes
>> the issue I guess.
> 
> Yes, that's exactly the idea.
> 
>> Since we do not have EOI trap anymore we cannot trigger level-sensitive
>> resamplefd in irqfd (this would be an ARM specificity)
> 
> For a level interrupt, we still have the EOI maintenance interrupt,
> which we could hook into to perform whatever resampling we need.

Sorry I am confused by the above sentence. I thought you removed
maintenance IRQ for both edge and level-sensitive IRQS? Thought also the
2 features were exclusive, ie EOI maintenance IRQ (only if HW bit = 0)
and forward with HWbit = 1, since occupying GICH_LR[19:10].Sorry if I
misunderstood your code or the spec.
> 
> The thing is, I don't think we need it at all. If the IRQ line is still
> up, we'll take another interrupt right away. So it is not so much that
> we cannot trigger the resample mechanism, it is just that it seems to
> become useless. What do you think?

Yes indeed I think it becomes useless. Besides as far as I understand
resamplefd feature is not mandatory. There is a capability associated to
it, KVM_CAP_IRQFD_RESAMPLE. Also if we want to use it we pass the
KVM_IRQFD_FLAG_RESAMPLE as irqfd flag.

> 
>> A last comment/question, wouldn't it be possible to inject the vIRQ
>> (programming the LR) direcly in the irqchip, instead of relying on VFIO
>> to trigger an eventfd whose handler does the job? This could be an
>> optional capavility per forwarded IRQ. Of course this would create a
>> relationship between gic and vgic. Do you see it as ugly - I dare to ask - ?
> 
> I would say that it is what the interrupt handler is for. We could
> entirely bypass the eventfd, and inject the interrupt from the VFIO
> interrupt handler, couldn't we?

The problem is the VFIO driver currently is not meant for that. It is
meant to trigger an eventfd and that's it. Anyway we may need to invent
something new around existing API semantics.

Best Regards

Eric
> 
> I think that gives you the bypass you're asking for, without creating a
> dependency between the host GIC driver, and the guest support code.
> 
> Thanks,
> 
> 	M.
> 


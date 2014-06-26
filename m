Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbaFZJcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:32:01 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:11816 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756355AbaFZJb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:31:59 -0400
Message-ID: <53ABE88C.1010401@arm.com>
Date: Thu, 26 Jun 2014 10:31:56 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Eric Auger <eric.auger@linaro.org>
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
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com> <53AAE242.3060405@linaro.org>
In-Reply-To: <53AAE242.3060405@linaro.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On 25/06/14 15:52, Eric Auger wrote:
> On 06/25/2014 11:28 AM, Marc Zyngier wrote:
>> The GIC architecture (ARM's Generic Interrupt Controller) allows an
>> active physical interrupt to be forwarded to a guest, and the guest to
>> indirectly perform the deactivation of the interrupt by performing an
>> EOI on the virtual interrupt (see for example the GICv2 spec, 3.2.1).
>>
>> So far, Linux doesn't have this notion, which is a bit of a pain.
>>
>> This patch series introduce two generic features:
>>
>> - A way to mark an interrupt as "forwarded": this allows an irq_chip
>>   to know that it shouldn't perform the deactivation itself
>> - A way to save/restore the "state" of a "forwarded" interrupt
>>
>> The series then adapts both GIC drivers to switch to EOImode == 1
>> (split priority drop and deactivation), to support this "forwarded"
>> feature and hacks the KVM/ARM timer backend to use all of this.
>>
>> This requires yet another bit of surgery in the vgic code in order to
>> allow a mapping between physical interrupts and virtual
>> ones. Hopefully, this should plug into VFIO and the whole irqfd thing,
>> but I don't understand any of that just yet (Eric?)
> 
> Hello Marc,
> 
> Thanks for the patch, it brings a very interesting capability for
> improving the performance of KVM device assignment.
> 
> From the integration pov I understand we need to
> 1) call irq_set_fwd_state to tell the gic the physical IRQ is forwarded
> and not deactivate it

That would be irqd_set_irq_forwarded().

irq_{g,s}et_fwd_state() are used when you're actually sharing a device
between guests, and need to context-switch its HW interrupt state
(typically, the timer). I wouldn't expect VFIO to use this, as the
device is exclusively assigned to a guest.

> 2) call vgic_map_phys_irq to the tell the vgic it must program the LRs
> accordingly.
> 
> We currently have the vfio driver VFIO_DEVICE_SET_IRQS user API that
> makes possible to tell: device IRQ index #i (i=0, 1, 2 for my xgmac)
> shall trigger this fd.
> At that point it would be possible to tell the GIC the physical IRQ
> corresponding to i is forwarded.
> 
> On the other hand we have KVM_IRQFD that enables to tell KVM: when this
> fd is triggered, you implement its handler in KVM irqfd framework and
> the handler injects the provided irchip.pin(gsi)=virtualIRQ - the famous
> GSI routing table - into this VM.
> 
> Building the vgic map table hence requires to do some glue around vfio
> and irqfd info: physical IRQ ->(vfio) fd ->(irqfd) gsi.
> 
> As such I would say those 2 user APIs(VFIO and IRQFD) are not fully
> adapted to put that in place but this may be feasible. Previous
> KVM_ASSIGN_DEV_IRQ was directly associated the pIRQ and vIRQ.
> 
> we should be able to remove the physical IRQ mask in the vfio driver
> (this masking is done when triggering the fd and the IRQ is unmasked
> when the virtual IRQ is completed). It was there because the physical
> IRQ was completed and could hit again. Now with 2 stage completion the
> same IRQ cannot hit while guest has not not DIR'ed the IRQ so it fixes
> the issue I guess.

Yes, that's exactly the idea.

> Since we do not have EOI trap anymore we cannot trigger level-sensitive
> resamplefd in irqfd (this would be an ARM specificity)

For a level interrupt, we still have the EOI maintenance interrupt,
which we could hook into to perform whatever resampling we need.

The thing is, I don't think we need it at all. If the IRQ line is still
up, we'll take another interrupt right away. So it is not so much that
we cannot trigger the resample mechanism, it is just that it seems to
become useless. What do you think?

> A last comment/question, wouldn't it be possible to inject the vIRQ
> (programming the LR) direcly in the irqchip, instead of relying on VFIO
> to trigger an eventfd whose handler does the job? This could be an
> optional capavility per forwarded IRQ. Of course this would create a
> relationship between gic and vgic. Do you see it as ugly - I dare to ask - ?

I would say that it is what the interrupt handler is for. We could
entirely bypass the eventfd, and inject the interrupt from the VFIO
interrupt handler, couldn't we?

I think that gives you the bypass you're asking for, without creating a
dependency between the host GIC driver, and the guest support code.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

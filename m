Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaGGIkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:40:31 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:33379 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751401AbaGGIk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:40:27 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "kvmarm\@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "eric.auger\@linaro.org" <eric.auger@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 2/9] genirq: Allow the state of a  forwarded irq to be save/restored
In-Reply-To: <20140627131018.GS26276@arm.com> (Will Deacon's message of "Fri,
	27 Jun 2014 14:10:18 +0100")
Organization: ARM Ltd
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
	<1403688530-23273-3-git-send-email-marc.zyngier@arm.com>
	<20140627131018.GS26276@arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Mon, 07 Jul 2014 09:40:22 +0100
Message-ID: <87mwcla7ex.fsf@why.wild-wind.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On Fri, Jun 27 2014 at  2:10:18 pm BST, Will Deacon <will.deacon@arm.com> wrote:
> Hi Marc,
>
> On Wed, Jun 25, 2014 at 10:28:43AM +0100, Marc Zyngier wrote:
>> When a peripheral is shared between virtual machines, its interrupt
>> state becomes part of the guest's state, and must be switched accordingly.
>> 
>> Introduce a pair of accessors (irq_get_fwd_state/irq_set_fwd_state) to
>> retrieve the bits that can be of interest to KVM: pending, active, and masked.
>> 
>> - irq_get_fwd_state returns the state of the interrupt according to a mask
>> containing any of the IRQ_STATE_PENDING, IRQ_STATE_ACTIVE or IRQ_STATE_MASKED
>> bits.
>> - irq_set_fwd_state sets the state of the interrupt according to a
>> similar mask.
>> 
>> Only a forwarded interrupt can be manipulated in such a way.
>
> [...]
>
>> +/**
>> + *	irq_set_fwd_state - set the state of a forwarded interrupt.
>> + *	@irq: Interrupt line that is forwarded to a VM
>> + *	@val: State to be restored
>> + *	@mask: Bitmask of IRQ_FWD_STATE_* defining the valid bits in @val
>> + *
>> + *	This call sets the state of a forwarded interrupt, depending
>> + *	on the mask which indicates the valid bits.
>> + *
>> + *	This function should be called with preemption disabled if the
>> + *	interrupt controller has per-cpu registers.
>> + */
>> +int irq_set_fwd_state(unsigned int irq, u32 val, u32 mask)
>> +{
>> +	struct irq_desc *desc;
>> +	struct irq_data *data;
>> +	struct irq_chip *chip;
>> +	unsigned long flags;
>> +
>> +	desc = irq_to_desc(irq);
>> +	if (!desc)
>> +		return -EINVAL;
>> +
>> +	data = irq_desc_get_irq_data(desc);
>> +	if (!irqd_irq_forwarded(data))
>> +		return -EINVAL;
>> +
>> +	chip = irq_desc_get_chip(desc);
>> +	if (!chip->irq_set_fwd_state)
>> +		return -EINVAL;
>> +
>> +	chip_bus_lock(desc);
>> +	raw_spin_lock_irqsave(&desc->lock, flags);
>> +	chip->irq_set_fwd_state(data, val, mask);
>> +	raw_spin_unlock_irqrestore(&desc->lock, flags);
>> +	chip_bus_sync_unlock(desc);
>
> Having looked at this, I don't think you need to take the desc->lock
> after all. I thought you might need it for irq_desc_get_chip, but
> that's not going to change dynamically and you'd end up with a lock
> ordering problem against chip_bus_lock anyway.

I think this all depends on the state of the device generating the
interrupt:

- If we can guarantee that the device is completely off and won't
  generate an interrupt when the state is save/restored, then the locks
  can go.

- If the device can generate an interrupt, then we need a more complex
  locking strategy, similar to the one described in handle.c (the VM
  should be considered as a form a thread handler itself).

For the particular use case that we have on ARM, the first possibility
applies (we ensure that the timer is completely off when scheduling the
VM out).

But can we make this a requirement?

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.

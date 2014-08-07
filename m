Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbaHGPr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:47:58 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:53434 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaHGPr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:47:57 -0400
Message-ID: <53E39FA9.6040503@linaro.org>
Date: Thu, 07 Aug 2014 17:47:53 +0200
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
Subject: Re: [RFC PATCH 7/9] KVM: arm: vgic: allow dynamic mapping of physical/virtual
 interrupts
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>	<1403688530-23273-8-git-send-email-marc.zyngier@arm.com>	<53DE0584.2040405@linaro.org> <87bns0gzy8.fsf@approximate.cambridge.arm.com>
In-Reply-To: <87bns0gzy8.fsf@approximate.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2014 03:13 PM, Marc Zyngier wrote:
> On Sun, Aug 03 2014 at 10:48:52 am BST, Eric Auger <eric.auger@linaro.org> wrote:
>> On 06/25/2014 11:28 AM, Marc Zyngier wrote:
>>> In order to be able to feed physical interrupts to a guest, we need
>>> to be able to establish the virtual-physical mapping between the two
>>> worlds.
>>>
>>> As we try to keep the injection interface simple, find out what the
>>> physical interrupt is (if any) when we actually build the LR.
>>>
>>> The mapping is kept in a rbtree, indexed by virtual interrupts.
>>
>> Hi Marc,
>>
>> I suspect there is a piece missing here related to bitmap state
>> management. When using maintenance IRQ, in process_maintenance we cleared
>> - dist->irq_pending (and new dist->irq_level)
>> - vcpu->irq_queued
>>
>> Now this does not exist anymore for forwarded irqs, when a subsequent
>> IRQ will be injected, vgic_update_irq_pending will fail in injecting the
>> IRQ because the states are reflecting the IRQ is still in progress.
>>
>> Since I have a modified version of your code, using Christoffer patches
>> I may have missed some modifications you did but at least on my side I
>> was forced to add bitmap clearing.
>>
>> It is not clear to me where to put that code however. Since user-side
>> can inject an IRQ while the previous one is not completed at guest and
>> host level, it cannot be in update_irq_pending - or we shall prevent the
>> user from injecting fwd IRQs - .
Hi Marc,

Christoffer suggested me to put state bitmap reset in
__kvm_vgic_sync_hwstate where we check whether the LR were consumed. It
seems to work fine and we do no assumption about user action.

> 
> Interesting. Indeed, userspace shouldn't be allowed to inject a
> forwarded interrupt (or actually the virtual interrupt that matches the
> physical one). This interrupt is now under complete control of the
> kernel, and shouldn't triggered by userspace.
the user-side might only manipulate VFIO IRQ index (and not the hwirq).
So we can make sure the physical IRQ belongs to a valid VFIO device.
> 
> Now, it is completely possible that we're missing something here (or
> actually doing too much).
> 
>> In my case (VFIO/IRQFD), by construction I only inject a new forwarded
>> IRQ when the previous one was completed so I could put it in the irqfd
>> injection function. But even irqfd is injected through eventfd trigger.
>> We shall forbid the user-side to trigger that eventfd in place of the
>> VFIO driver. What do you think?
> 
> Yup. userspace can't interfere with a forwarded interrupt, that's way
> too dangerous.
> 
>> A question related to guest kill. Cannot it happen the guest sometimes
>> does not complete the vIRQ before exiting? Currently I observe cases
>> where when I launch qemu-system after a kill, forwarded irqs do not work
>> properly. I am not yet sure this is the cause of my problem but just in
>> case, can the host write into GICV_EOIR in place of guest?
> 
> It is quite possible that the interrupt is left active when the guest is
> killed, which would tend to indicate that we need a way to cleanup
> behind us. It should be enough to clear the active bit, shouldn't it?
So in practice this will directly write into the GICC_DIR right? I will
try this.

Best Regards

Eric
> 
>> Besides those problems, the patch works in my test environment
> 
> Thanks for testing!
> 
> 	M.
> 


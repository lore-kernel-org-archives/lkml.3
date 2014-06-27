Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaF0Rf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 13:35:27 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:56510 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752122AbaF0RfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 13:35:23 -0400
Message-ID: <53ADAB4F.1010401@arm.com>
Date: Fri, 27 Jun 2014 18:35:11 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm/gic: Add supports for GICv2m MSI(-X)
References: <1403569980-12913-1-git-send-email-suravee.suthikulpanit@amd.com> <1403569980-12913-3-git-send-email-suravee.suthikulpanit@amd.com> <53A94A46.1010801@arm.com> <53AD911C.6040301@amd.com>
In-Reply-To: <53AD911C.6040301@amd.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suravee,

On 27/06/14 16:43, Suravee Suthikulpanit wrote:
> Hi Marc,
> 
> After looking at the GICv3 implementation and trying to understand how 
> you architect the driver, I have a couple questions below.
> 
>  > On 06/24/2014 04:52 AM, Marc Zyngier wrote:
>> Hi Suravee,
>>
>> On 24/06/14 01:33, suravee.suthikulpanit@amd.com wrote:
>>> +       pr_info("GICv2m: SPI range [%d:%d]\n",
>>> +               msi->spi_start, (msi->spi_start + msi->max_spi_cnt));
>>> +
>>> +       gic_arch_extn.irq_mask = gicv2m_mask_msi;
>>> +       gic_arch_extn.irq_unmask = gicv2m_unmask_msi;
>>
>> Right, I now see why you need to test on the MSI descriptor. Don't do
>> that. The gic_arch_extn crap should *never* *be* *used*.
> 
> Hm, sounds like this should be removed all together then? In that case, 
> this would require changes in the irq-gic.c to call these functions 
> directly.

No. The gic_arch_extn's sole purpose in life is to allow a parallel
interrupt controller that mimics what the GIC does, and that can be used
as a wake up source. Clearly, MSI support is completely out of the scope
of this ... thing.

>>
>> What you want to do is do assign a different irq_chip to your MSI
>> interrupts. This will require a different integration with the main GIC
>> code though. For the GICv3 ITS, I do it when the interrupt gets mapped.
> 
> Ah, that's what I was trying to avoid. Why should we need a whole 
> different irq_chip just to add the MSI register frame support on top of 
> the GICv2 which is already supported by the current irq-gic.c?

Because, as you've noticed, it has a different set of requirements
(accessing the MSI specific data, for a start). That's the very purpose
of the irq_chip structure. Don't work around it. Nothing prevents you
from reusing the existing code, by the way.

>>
>>> +       return 0;
>>> +}
>>> +EXPORT_SYMBOL(gicv2m_msi_init);
>>> +
>>> +
>>> +
>>> +/**
>>> + * Override arch_setup_msi_irq in drivers/pci/msi.c
>>> + * since we don't want to change the chip_data
>>> + */
>>> +int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
>>> +{
>>> +       struct msi_chip *chip = pdev->bus->msi;
>>> +
>>> +       if (!chip || !chip->setup_irq)
>>> +               return -EINVAL;
>>> +
>>> +       return chip->setup_irq(chip, pdev, desc);
>>> +}
>>> +
>>> +/**
>>> + * Override arch_teardown_msi_irq in drivers/pci/msi.c
>>> + */
>>> +void arch_teardown_msi_irq(unsigned int irq)
>>> +{
>>> +       struct msi_desc *desc;
>>> +       struct msi_chip *chip;
>>> +
>>> +       desc = irq_get_msi_desc(irq);
>>> +       if (!desc)
>>> +               return;a
>>> +
>>> +       chip = desc->dev->bus->msi;
>>> +       if (!chip)
>>> +               return;
>>> +
>>> +       chip->teardown_irq(chip, irq);
>>> +}
>>
>> Please don't overtide those. There shouldn't be any reason for a
>> *driver* to do so. Only architecture code should do it. And nothing in
>> your code requires it (at least once you've stopped playing with the
>> silly gic extension...).
> 
> The reason I need these because the __weak version of arch_setup_msi_irq 
> function in driver/pci/msi.c calls irq_set_chip_data and replace the 
> chip_data with msi_chip (originally was pointing to the gic_chip_data 
> structure). This ended up breaking the GIC.

This is exactly why I urged you to have a different irq_chip, pointing
to different methods. MSI and IRQs are treated a bit differently in the
kernel. Hijacking global symbols to work around this difference is
hardly acceptable. Here, you're mandating that all the MSI controllers,
past, present and future are going to fit the requirements you've now
dictated. Hmmm... ;-)

> Looking at the GICv3 ITS implementation, this seems to also have similar 
> implementation. So, this was not an issue for you?

No. This is actually a very useful feature (and I should definitely make
use of it). You can embed the msi_chip into the gic_chip_data, and use
"container_of()" to go from one to the other. But again, this mandates
you provide your own methods (not that it is a lot of code, really).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

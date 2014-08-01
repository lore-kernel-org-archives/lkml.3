Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbaHARFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 13:05:31 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:47496 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755387AbaHARF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 13:05:29 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>,
        "jason\@lakedaemon.net" <jason@lakedaemon.net>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "Harish.Kasiviswanathan\@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 3/4 V3] irqchip: gic: Add supports for ARM GICv2m MSI(-X)
In-Reply-To: <53DBC074.3030309@amd.com> (Suravee Suthikulanit's message of
	"Fri, 1 Aug 2014 17:29:40 +0100")
Organization: ARM Ltd
References: <1404947104-21345-1-git-send-email-suravee.suthikulpanit@amd.com>
	<1404947104-21345-4-git-send-email-suravee.suthikulpanit@amd.com>
	<87zjfqj3mc.fsf@approximate.cambridge.arm.com>
	<53DBB562.5020003@amd.com> <53DBC074.3030309@amd.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Fri, 01 Aug 2014 18:05:15 +0100
Message-ID: <87oaw4gmyc.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01 2014 at  5:29:40 pm BST, Suravee Suthikulanit <suravee.suthikulpanit@amd.com> wrote:
> On 8/1/2014 10:42 AM, Suravee Suthikulanit wrote:
>>>> +#ifdef CONFIG_SMP
>>>> +       .irq_set_affinity       = gic_set_affinity,
>>>> +#endif
>>>> +#ifdef CONFIG_PM
>>>> +       .irq_set_wake           = gic_set_wake,
>>>> +#endif
>>>> +};
>>>> +
>>>> +#ifdef CONFIG_OF
>>>> +static int __init
>>>> +gicv2m_of_init(struct device_node *node, struct device_node *parent)
>>>> +{
>>>> +       struct gic_chip_data *gic;
>>>> +       int ret;
>>>> +
>>>> +       ret = _gic_of_init(node, parent, &gicv2m_chip, &gic);
>>>> +       if (ret) {
>>>> +               pr_err("GICv2m: Failed to initialize GIC\n");
>>>> +               return ret;
>>>> +       }
>>>> +
>>>> +       gic->msi_chip.owner = THIS_MODULE;
>>>> +       gic->msi_chip.of_node = node;
>>>> +       gic->msi_chip.setup_irq = gicv2m_setup_msi_irq;
>>>> +       gic->msi_chip.teardown_irq = gicv2m_teardown_msi_irq;
>>>> +       ret = of_pci_msi_chip_add(&gic->msi_chip);
>>>> +       if (ret) {
>>>> +               /* MSI is optional and not supported here */
>>>> +               pr_info("GICv2m: MSI is not supported.\n");
>>>> +               return 0;
>>>> +       }
>>>> +
>>>> +       ret = gicv2m_msi_init(node, &gic->v2m_data);
>>>> +       if (ret)
>>>> +               return ret;
>>>> +       return ret;
>>>> +}
>>>> +
>>>> +IRQCHIP_DECLARE(arm_gic_400_v2m, "arm,gic-400-v2m", gicv2m_of_init);
>>>
>>> So if you follow my advise of reversing your probing and call into the
>>> v2m init from the main GIC driver, you could take a irq_chip as a
>>> parameter, and use it to populate the v2m irq_chip, only overriding the
>>> two methods that actually differ.
>>>
>>> This would have the net effect of completely dropping patch #2, which
>>> becomes effectively useless.
>>>
>>
>> [Suravee] Ok, lemme look into this.
>
> So, in previous revision, you mentioned that we should have a separate 
> irq_chip for gicv2m stuff, is that is still the case here?

Yes. You would do something like this:

- In the main GIC code:
	if (v2m_present()) {
        	v2m_init(&gic_chip);
        }

- In the v2m code:
	static struct irq_chip_v2m_chip;
	void v2m_init(struct irq_chip *gic_chip)
        {
        	[...]
        	v2m_chip = *gic_chip;
                v2m_chip.mask = v2m_irq_mask;
                v2m_chip.unmask = v2m_irq_unmask;
                [...]
        }

Basically, you inherit a number of default methods, only overloading the
ones that are different. The rest of your driver is mostly unchanged.

This preserves the current probing structure, and avoids exposing
private methods outside of irq-gic.c (preventing people from doing silly
things with an unsuspecting interrupt controller...).

	M.
-- 
Jazz is not dead. It just smells funny.

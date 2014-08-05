Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbaHECNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 22:13:09 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:26136 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbaHECNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 22:13:07 -0400
Message-ID: <53E03D71.5080800@huawei.com>
Date: Tue, 5 Aug 2014 10:12:01 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        <Paul.Mundt@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>,
        <linux-pci@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        <virtualization@lists.linux-foundation.org>,
        Xinwei Hu <huxinwei@huawei.com>, Hanjun Guo <guohanjun@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Wuyun <wuyun.wu@huawei.com>
Subject: Re: [RFC PATCH 00/11] Refactor MSI to support Non-PCI device
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com> <201408011552.32135.arnd@arndb.de> <53DF2B7B.4000605@huawei.com> <201408041659.31364.arnd@arndb.de>
In-Reply-To: <201408041659.31364.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> The method you describe here makes sense for PCI devices that are required to support
>>> legacy interrupts and may or may not support MSI on a given system, but not so much
>>> for platform devices for which we know exactly whether we want to use MSI
>>> or legacy interrupts.
>>>
>>> In particular if you have a device that can only do MSI, the entire pci_enable_msi
>>> step is pointless: all we need to do is program the correct MSI target address/message
>>> pair into the device and register the handler.
>>
>> Yes, I almost agree if we won't change the existing hundreds of drivers, what
>> I worried about is some drivers may want to know the IRQ numbers, and use the IRQ
>> number to process different things, as I mentioned in another reply.
>> But we can also provide the interface which integrate MSI configuration and request_irq(),
>> if most drivers don't care the IRQ number.
> 
> The driver would still have the option of getting the IRQ number for now: With
> the interface I imagine, you would get a 'struct msi_desc' pointer, from which
> you can look up the 'struct irq_desc' pointer (either embedded in msi_desc,
> or using a pointer from a member of msi_desc), and you can already get the
> interrupt number from the irq_desc.
> 
> My point was that a well-written driver already does not care about the interrupt
> number: the only information a driver needs in the interrupt handler is a pointer
> to its own context, which we already derive from the irq_desc.

Agree, I will try to introduce this similar interface in next version, thanks!

> 
> The main interface that currently requires the irq number is free_irq(), but
> I would argue that we can just add a wrapper that takes the msi_desc pointer
> as its first argument so the driver does not have to worry about it.
> 
> We can add additional wrappers like that as needed.

OK

>>>> This is a huge change for device drivers, and some device drivers don't know which msi_chip
>>>> their MSI irq deliver to. I'm reworking the msi_chip, and try to use msi_chip to eliminate
>>>> all arch_msi_xxx() under every arch in kernel. And the important point is how to create the
>>>> binding for the MSI device to the target msi_chip.
>>>
>>> Which drivers are you thinking of? Again, I wouldn't expect to change any PCI drivers,
>>> but only platform drivers that do native MSI, so we only have to change drivers that
>>> do not support any MSI at all yet and that need to be changed anyway in order to add
>>> support.
>>
>> I mean platform device drivers, because we can find the target msi_chip by some platform
>> interfaces(like the existing of_pci_find_msi_chip_by_node()). So we no need to explicitly
>> provide the msi_chip as the function argument.
> 
> Right, that works too. I was thinking we might need an interface that allows us to
> pick a particular msi_chip if there are several alternatives (e.g. one in the GIC
> and one in the PCI host), but you are right: we should normally be able to hardwire
> that information in DT or elsewhere, and just need the 'struct device pointer' which
> should probably be the first argument here.
> 
> As you pointed out, it's common to have multiple MSIs for a single device, so we
> also need a context to pass around, so my suggestion would become something like:
> 
> struct msi_desc *msi_request(struct device *dev, irq_handler_t handler,
>  			unsigned long flags, const char *name, void *data);
> 
> It's possible that we have to add one or two more arguments here.

Good suggestion, thanks!

> 
>>> A degenerate case of this would be a system where a PCI device sends its MSI into
>>> the host controller, that generates a legacy interrupt and that in turn gets 
>>> sent to an irqchip which turns it back into an MSI for the GICv3. This would of
>>> course be very inefficient, but I think we should be able to express this with
>>> both the binding and the in-kernel framework just to be on the safe side.
>>
>> Yes, the best way to tell the kernel which msi_chip should deliver to is describe
>> the binding in DTS file. If a real degenerate case found, we can update the platform
>> interface which is responsible for getting the match msi_chip in future.
> 
> Ok.
> 
> 	Arnd
> 
> .
> 


-- 
Thanks!
Yijing


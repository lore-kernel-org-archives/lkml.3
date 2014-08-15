Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaHOPI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:08:56 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:13041 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751104AbaHOPIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:08:54 -0400
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
Subject: Re: [PATCH 2/2 V4] irqchip: gicv2m: Add support for multiple MSI for ARM64 GICv2m
In-Reply-To: <53EE1EE5.3060103@amd.com> (Suravee Suthikulanit's message of
	"Fri, 15 Aug 2014 15:53:25 +0100")
Organization: ARM Ltd
References: <1407942041-3291-1-git-send-email-suravee.suthikulpanit@amd.com>
	<1407942041-3291-3-git-send-email-suravee.suthikulpanit@amd.com>
	<87k369ri9k.fsf@approximate.cambridge.arm.com>
	<53EE1EE5.3060103@amd.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Fri, 15 Aug 2014 16:08:50 +0100
Message-ID: <877g29rdrx.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15 2014 at  3:53:25 pm BST, Suravee Suthikulanit <suravee.suthikulpanit@amd.com> wrote:
> On 8/15/2014 8:31 AM, Marc Zyngier wrote:
>> Hi Suravee,
>>
>>> +/*
>>> + * ARM64 function for seting up MSI irqs.
>>> + * Copied from driver/pci/msi.c: arch_setup_msi_irqs().
>>> + */
>>> +int arm64_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>>> +{
>>> +	struct msi_desc *entry;
>>> +	int ret;
>>> +
>>> +	if (type == PCI_CAP_ID_MSI && nvec > 1)
>>> +		return 1;
>>> +
>>> +	list_for_each_entry(entry, &dev->msi_list, list) {
>>> +		ret = arch_setup_msi_irq(dev, entry);
>>> +		if (ret < 0)
>>> +			return ret;
>>> +		if (ret > 0)
>>> +			return -ENOSPC;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>
>> I'm going to reiterate what I said last time: Why do we need this?
>
> [Suravee] Marc, I understand what you described last time but I think 
> there is one point that missing here. See below.
>
>> So far, we have two MSI-capable controllers on their way upstream:
>> GICv2m and GICv3. Both are perfectly capable of handling more than a
>> single MSI per device.
>
> [Suravee] I am aware of this.
>
>> So why should we cater for this? My gut feeling is that we should just
>> have:
>>
>> int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>> {
>>          struct msi_desc *entry;
>>          int ret;
>>
>>          /*
>>           * So far, all our MSI controllers are capable of handling more
>>           * than a single MSI per device. Should we encounter less
>>           * capable devices, we'll consider doing something special for
>>           * them.
>>           */
>>          list_for_each_entry(entry, &dev->msi_list, list) {
>>                  ret = arch_setup_msi_irq(dev, entry);
>>                  if (ret < 0)
>>                          return ret;
>>                  if (ret > 0)
>>                          return -ENOSPC;
>>          }
>>
>>          return 0;
>> }
>>
>> and nothing else. Your driver should be able to retrieve the number of
>> MSI needed by the device, and allocate them. GICv3 manages it, and so
>> should GICv2m.
>>
>
> [Suravee] Multi-MSI and MSI-x are not the same. For MSI-X, you can treat 
> each of the MSI separately since it MSI-X capability structure has a 
> table specific for each one of them.  For Multi-MSI, there is only one 
> MSI capability structure which control all of them, and you need to 
> program the "multiple-message enable" field with the encoding for 
> "power-of-two", and therefore must be in contiguous range.

I fully understand this.

> Your logic above is what the standard MSI-x setup code is using. It is 
> not handling of how many it can allocate all at once.

This logic can also be applied to MSI, provided that you start by
allocating all the possible MSIs on the first call to your setup
function.

> As for sharing the logic b/w GICv2m and GICv3, unless they are sharing 
> the same common data structure (e.g. the struct v2m which contans 
> msi_chip), and the allocation function (e.g. generic 
> gic_alloc_msi_irqs()), you pretty much need to do this separately since 
> we need to walk the msi_chip back to its container structure.

I'm not suggesting we should share code between the GICv3 ITS and the
v2m block (you definitely don't want the GICv3 madness to creep into
your code).

What I'm saying is that you can work out how many vectors you need from
the initial call to gicv2m_setup_msi_irq, and just make sure they are
effectively contiguous (you already have the code for this in
alloc_msi_irq).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.

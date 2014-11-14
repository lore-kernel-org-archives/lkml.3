Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935317AbaKNQNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 11:13:33 -0500
Received: from service87.mimecast.com ([91.220.42.44]:47652 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935274AbaKNQNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 11:13:32 -0500
Message-ID: <54662A27.6030201@arm.com>
Date: Fri, 14 Nov 2014 16:13:27 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch V1 0/6] Refine generic/PCI MSI irqodmian interfaces
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com> <54651BE2.9080008@arm.com> <alpine.DEB.2.11.1411132207470.3935@nanos> <5465227E.6000309@arm.com> <5466259A.7060505@linux.intel.com>
In-Reply-To: <5466259A.7060505@linux.intel.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 14 Nov 2014 16:13:28.0598 (UTC) FILETIME=[ED224360:01D00025]
X-MC-Unique: 114111416132821601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/11/14 15:54, Jiang Liu wrote:
> On 2014/11/14 5:28, Marc Zyngier wrote:
>> On 13/11/14 21:11, Thomas Gleixner wrote:
>>> On Thu, 13 Nov 2014, Marc Zyngier wrote:
>>>> With the new stacked irq domains, it becomes pretty tempting
>>>> to allocate an MSI domain per PCI bus, which would remove
>>>> the requirement of either relying on arch-specific code, or
>>>> a default PCI MSI domain.
>>>
>>> Right. That's what I roughly had in mind. And that would solve the
>>> multi-iommu issue on x86 nicely as well. We establish the association
>>> at the time where the bus gets populated. So the whole lookup magic
>>> simply goes away.
>>
>> Great. I've pushed the whole thing out with this patch, the couple
>> of fixes I mentioned earlier, as well as the whole ITS code:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git irq/stacked-its-v2
> Hi Marc,
> 	I have looked at the code, and found some issues.
> 1) With my next version, no need to implemeent its_pci_msi_free()
> anymore. msi_domain_free_irqs() will reset desc->irq to zero
> for all architectures.

Great. The less code, the better.

> 2) This piece of code in its_msi_prepare() may run into trouble
> for PCI device with both MSI and MSIX capability. I will change
> msi_prepare() prototype to pass in the "nvec" parameter. And you
> may access first_pci_msi_entry()->msi_attrib.is_msix to get
> allocation type if needed.
> 	nvec = pci_msix_vec_count(pdev);
> 	if (nvec < 0)
> 		nvec = pci_msi_vec_count(pdev);
> 	if (nvec < 0)
> 		return nvec;

Ah, good point. Having nvec will make things simpler indeed. I have the
feeling that the ITS driver may not be the only one to require such a thing.

> 3) Do we need to increase the default of NUM_MSI_ALLOC_SCRATCHPAD_REGS
> to 4? 2 is a little too limited.

I'd say that 2 is enough for now. The ITS only uses one (the second one
is for debug only). Should the need arise, we can bump it up later.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...


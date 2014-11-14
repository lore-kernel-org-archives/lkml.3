Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965615AbaKNPyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:54:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:52203 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964875AbaKNPyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:54:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="487527248"
Message-ID: <5466259A.7060505@linux.intel.com>
Date: Fri, 14 Nov 2014 23:54:02 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>
CC: Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
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
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com> <54651BE2.9080008@arm.com> <alpine.DEB.2.11.1411132207470.3935@nanos> <5465227E.6000309@arm.com>
In-Reply-To: <5465227E.6000309@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/14 5:28, Marc Zyngier wrote:
> On 13/11/14 21:11, Thomas Gleixner wrote:
>> On Thu, 13 Nov 2014, Marc Zyngier wrote:
>>> With the new stacked irq domains, it becomes pretty tempting
>>> to allocate an MSI domain per PCI bus, which would remove
>>> the requirement of either relying on arch-specific code, or
>>> a default PCI MSI domain.
>>
>> Right. That's what I roughly had in mind. And that would solve the
>> multi-iommu issue on x86 nicely as well. We establish the association
>> at the time where the bus gets populated. So the whole lookup magic
>> simply goes away.
> 
> Great. I've pushed the whole thing out with this patch, the couple
> of fixes I mentioned earlier, as well as the whole ITS code:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git irq/stacked-its-v2
Hi Marc,
	I have looked at the code, and found some issues.
1) With my next version, no need to implemeent its_pci_msi_free()
anymore. msi_domain_free_irqs() will reset desc->irq to zero
for all architectures.

2) This piece of code in its_msi_prepare() may run into trouble
for PCI device with both MSI and MSIX capability. I will change
msi_prepare() prototype to pass in the "nvec" parameter. And you
may access first_pci_msi_entry()->msi_attrib.is_msix to get
allocation type if needed.
	nvec = pci_msix_vec_count(pdev);
	if (nvec < 0)
		nvec = pci_msi_vec_count(pdev);
	if (nvec < 0)
		return nvec;

3) Do we need to increase the default of NUM_MSI_ALLOC_SCRATCHPAD_REGS
to 4? 2 is a little too limited.

Regards!
Gerry

> 
> Time to go home.
> 
> 	M.
> 

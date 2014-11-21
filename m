Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbaKUCDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 21:03:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:13327 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757656AbaKUCDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 21:03:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,427,1413270000"; 
   d="scan'208";a="640877436"
Message-ID: <546E9D80.3090405@linux.intel.com>
Date: Fri, 21 Nov 2014 10:03:44 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Yijing Wang <wangyijing@huawei.com>
CC: Marc Zyngier <marc.zyngier@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: Removal of bus->msi assignment breaks MSI with stacked domains
References: <546E1771.4030201@arm.com> <546E93DC.8010902@huawei.com> <alpine.DEB.2.11.1411210233250.6439@nanos>
In-Reply-To: <alpine.DEB.2.11.1411210233250.6439@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/21 9:46, Thomas Gleixner wrote:
> On Fri, 21 Nov 2014, Yijing Wang wrote:
>> On 2014/11/21 0:31, Marc Zyngier wrote:
>>> Bjorn, Yijing,
>>>
>>> I've just realized that patch c167caf8d174 (PCI/MSI: Remove useless
>>> bus->msi assignment) completely breaks MSI on arm64 when using the new
>>> MSI stacked domain:
>>
>> Sorry, this is my first part to refactor MSI related code, now how
>> to get pci msi_controller depends arch
>> functions(pcibios_msi_controller() or arch_setup_msi_irq()), we are
>> working on generic pci_host_bridge, after that, we could eventually
>> eliminate MSI arch functions and find pci dev 's msi controller by
>> pci_host_bridge->get_msi_controller().
> 
> The main question is why you think that pci_host_bridge is the proper
> place to store that information.
> 
> On x86 we have DMAR units associated to a single device. Each DMAR
> unit is a seperate MSI irq domain. 
> 
> Can you guarantee that the pci_host_bridge is the right point to
> provide the association of the device to the irq domain?
> 
> So the real question is:
> 
>    What is the association level requirement to properly identify the
>    irqdomain for a specific device on any given architecture with and
>    without IOMMU, interrupt redirection etc.
> 
> To be honest: I don't know.
> 
> My gut feeling tells me that it's at the device level, but I really
> leave that decision to the experts in that field.
Hi Thomas and Yijing,
	Since we are allocating interrupts for a PCI device, it's
natural to get irqdomain from the PCI device itself. If we try to
get irqdomain from a PCI bus or host bridge like
pci_get_msi_irqdomain(bus or hostbridge), it may fail for x86
because x86 may build per-device irqdomain theoretically.
So the preferred interface prototype is:
	pci_get_msi_irqdomain(pci_dev) or
	pcibios_msi_controller(pci_dev)
It's flexible enough. For architectures on which irqdomain is
associated with PCI bus or host bridge, you could get the bus
or host bridge from pci_dev. And it won't cause extra computation
because you always need to get bus or host bridge from the pci_dev.
Regards!
Gerry
> 
> Thanks,
> 
> 	tglx
> 

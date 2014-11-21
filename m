Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbaKUDqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 22:46:43 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:30597 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757348AbaKUDql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 22:46:41 -0500
Message-ID: <546EB597.20806@huawei.com>
Date: Fri, 21 Nov 2014 11:46:31 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>
CC: Marc Zyngier <marc.zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: Removal of bus->msi assignment breaks MSI with stacked domains
References: <546E1771.4030201@arm.com> <20141120215353.GA7987@google.com> <alpine.DEB.2.11.1411202355060.6439@nanos> <546E9B60.9070706@huawei.com> <546EA2AB.9080609@linux.intel.com>
In-Reply-To: <546EA2AB.9080609@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/21 10:25, Jiang Liu wrote:
> On 2014/11/21 9:54, Yijing Wang wrote:
>>>> Thomas, let me know if you want to do that.  I suppose we could add a new
>>>> patch to add it back, but that would leave bisection broken for the
>>>> interval between c167caf8d174 and the patch that adds it back.
>>>
>>> Fortunately my irq/irqdomain branch is not immutable yet. So we have
>>> no problem at that point. I can rebase on your branch until tomorrow
>>> night. Or just rebase on mainline and we sort out the merge conflicts
>>> later, i.e. delegate them to Linus so his job of pulling stuff gets
>>> not completely boring.
>>
>> Hi Thomas, sorry for my introducing the broken.
>>
>>>
>>> What I'm more worried about is whether this intended change is going
>>> to inflict a problem on Jiangs intention to deduce the MSI irq domain
>>> from the device, which we really need for making DMAR work w/o going
>>> through loops and hoops.
>>>
>>> I have limited knowledge about the actual scope of iommu (DMAR) units
>>> versus device/bus/host-controllers, so I would appreciate a proper
>>> explanation for that from you or Jiang or both.
>>
>> In my personal opinion, if it's not necessary, we should not put stuff
>> into pci_dev or pci_bus. If we plan to save msi_controller in pci_bus or
>> pci_dev.
>> I have a proposal, I would be appreciated if you could give some comments.
>> First we refactor pci_host_bridge to make a generic
>> pci_host_bridge, then we could save pci domain in it to eliminate
>> arch specific functions. I aslo wanted to save msi_controller as
>> pci domain, but now Jiang refactor hierarchy irq domain, and
>> pci devices under the same pci host bridge may need to associate
>> to different msi_controllers.
>>
>> So I want to associate a msi_controller finding ops with generic pci_host_bridge,
>> then every pci device could find its msi_controller/irq_domain by a
>> common function
>>
>> E.g
>>
>> struct msi_controller *pci_msi_controller(struct pci_dev *pdev)
>> {
>> 	struct msi_controller *ctrl;
>> 	struct pci_host_bridge *host = find_pci_host_bridge(pdev->bus);
>> 	if (host && host->pci_get_msi_controller)
>> 		ctrl = pci_host_bridge->pci_get_msi_controller(struct pci_dev *pdev);
>>
>> 	return ctrl;	
>> }
> Hi Yijing,
> 	This may be a little overhead for x86 because we could get
> irqdomain from pci_dev itself through:
> 	pci_dev->dev.archdata.iommu->ir_msi_domain.
> 	This doesn't work currently because pci_dev->dev.archdata.iommu
> is set on the first dma mapping request, but we have a plan to set it
> when creating PCI devices so we don't need to search the iommu list
> at runtime.
> 	Even the whole msi_controller concept may be killed for x86.
> Actually I'm trying to convert all MSI arch code to use hierarchy
> irqdomain, then we don't need arch_setup_msi_irqs() and
> msi_controller.setup_irq() and related anymore. But the issue is
> that it affects too many architectures and may cause slightly code
> size increase.
> 	If we could convert all PCI MSI code to use hierarchy irqdomain,
> then the suggested interface is:
> 	struct irq_domain *pci_get_msi_irqdomain(struct pci_dev *pdev);
> Thoughts?

So the final solution depends the MSI refactoring work progress.
		   (glue layer)
I prefer pci_dev->msi_controller->(msi irq hierarchy domain)/(normal msi irq allocation code).
If we want to eliminate msi_controller, we must force all PCI MSI code to use hierarchy
irq domain. I doubt whether it is worth to do.

Thanks!
Yijing.

> Regards!
> Gerry
>>
>> If I miss something, please let me know, thanks.
>>
>> Thanks!
>> Yijing.
>>
>>
>>>
>>> My guts feeling tells me that anything less granular than the bus
>>> level is wrong and according to my limited knowledge Intel even has
>>> DMARs which are assigned to a single device it's even more wrong. So
>>> the proper change would be not to push it from bus to something above
>>> the bus, but instead make it a per device property.
>>>
>>> But my knowledge there is limited, so I rely on the PCI/architecture
>>> experts to sort that out.
>>>
>>> Let me know ASAP.
>>>
>>> Thanks,
>>>
>>> 	tglx
>>>
>>> .
>>>
>>
>>
> 
> .
> 


-- 
Thanks!
Yijing


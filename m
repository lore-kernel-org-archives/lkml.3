Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbaKUKA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 05:00:57 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36287 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbaKUKAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 05:00:55 -0500
Message-ID: <546F0D43.4020307@arm.com>
Date: Fri, 21 Nov 2014 10:00:35 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>, Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: Removal of bus->msi assignment breaks MSI with stacked domains
References: <546E1771.4030201@arm.com> <20141120215353.GA7987@google.com> <alpine.DEB.2.11.1411202355060.6439@nanos> <546E9B60.9070706@huawei.com>
In-Reply-To: <546E9B60.9070706@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yijing,

On 21/11/14 01:54, Yijing Wang wrote:
>>> Thomas, let me know if you want to do that.  I suppose we could add a new
>>> patch to add it back, but that would leave bisection broken for the
>>> interval between c167caf8d174 and the patch that adds it back.
>>
>> Fortunately my irq/irqdomain branch is not immutable yet. So we have
>> no problem at that point. I can rebase on your branch until tomorrow
>> night. Or just rebase on mainline and we sort out the merge conflicts
>> later, i.e. delegate them to Linus so his job of pulling stuff gets
>> not completely boring.
> 
> Hi Thomas, sorry for my introducing the broken.
> 
>>
>> What I'm more worried about is whether this intended change is going
>> to inflict a problem on Jiangs intention to deduce the MSI irq domain
>> from the device, which we really need for making DMAR work w/o going
>> through loops and hoops.
>>
>> I have limited knowledge about the actual scope of iommu (DMAR) units
>> versus device/bus/host-controllers, so I would appreciate a proper
>> explanation for that from you or Jiang or both.
> 
> In my personal opinion, if it's not necessary, we should not put stuff
> into pci_dev or pci_bus. If we plan to save msi_controller in pci_bus or
> pci_dev.
> I have a proposal, I would be appreciated if you could give some comments.
> First we refactor pci_host_bridge to make a generic
> pci_host_bridge, then we could save pci domain in it to eliminate
> arch specific functions. I aslo wanted to save msi_controller as
> pci domain, but now Jiang refactor hierarchy irq domain, and
> pci devices under the same pci host bridge may need to associate
> to different msi_controllers.
> 
> So I want to associate a msi_controller finding ops with generic pci_host_bridge,
> then every pci device could find its msi_controller/irq_domain by a
> common function
> 
> E.g
> 
> struct msi_controller *pci_msi_controller(struct pci_dev *pdev)
> {
> 	struct msi_controller *ctrl;
> 	struct pci_host_bridge *host = find_pci_host_bridge(pdev->bus);
> 	if (host && host->pci_get_msi_controller)
> 		ctrl = pci_host_bridge->pci_get_msi_controller(struct pci_dev *pdev);
> 
> 	return ctrl;	
> }
> 
> If I miss something, please let me know, thanks.

That feels slightly convoluted for something that should be a very
simple operation. Does this mean you're trying to represent a situation
where:
- a single host bridge has multiple MSI controllers,
- this bridge serves multiple busses,
- devices on the same bus can talk to different MSI controllers?

That would be the only case where the current way we pass the
msi_controller around wouldn't work.

If that's what you're trying to do, I can see how this work, but I'd
suggest you put that infrastructure in place before tearing down the
existing one. This means being having support at the host-bridge level
and reasonable defaults for the non-complicated case where bus->msi is
exactly what you want.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

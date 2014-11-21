Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbaKULai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 06:30:38 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36450 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758225AbaKULah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 06:30:37 -0500
Message-ID: <546F224E.2080106@arm.com>
Date: Fri, 21 Nov 2014 11:30:22 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: Removal of bus->msi assignment breaks MSI with stacked domains
References: <546E1771.4030201@arm.com> <546E93DC.8010902@huawei.com> <alpine.DEB.2.11.1411210233250.6439@nanos> <546F140B.1050607@arm.com> <alpine.DEB.2.11.1411211142051.6439@nanos>
In-Reply-To: <alpine.DEB.2.11.1411211142051.6439@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/11/14 10:49, Thomas Gleixner wrote:
> Marc,
> 
> On Fri, 21 Nov 2014, Marc Zyngier wrote:
>> On 21/11/14 01:46, Thomas Gleixner wrote:
>>> So the real question is:
>>>
>>>    What is the association level requirement to properly identify the
>>>    irqdomain for a specific device on any given architecture with and
>>>    without IOMMU, interrupt redirection etc.
>>>
>>> To be honest: I don't know.
>>>
>>> My gut feeling tells me that it's at the device level, but I really
>>> leave that decision to the experts in that field.
>>
>> Given the above requirement (single device associated to DMAR), I can
>> see two possibilities:
>> - we represent DMAR as a single PCI bus: feels a bit artificial
>> - we move the MSI domain to the device, as you suggested.
>>
>> The second one seems a lot more attractive to me.
> 
> And that's very useful if you want to support MSI on non PCI
> devices.
> 
>> Also, it is not clear to me what is the advantage of getting rid of the
>> MSI controller. By doing so, we loose an important part of the topology
>> information (the irq domain is another level of abstraction).
> 
> That was probably my misunderstanding of the msi controller. I had the
> impression it's just there to expose the MSI properties of a device,
> i.e. a magic wrapper which can be replaced by the MSI irqdomain work.
> 
> If that handles other information as well, then it's probably a
> misnomer to begin with.

At the moment, it serves multiple purpose:
- MSI configuration via setup_irq/teardown_irq: this is what most 32bit
ARM system are using (it has been introduced last year for that very
purpose)
- PCI controller vs MSI hw matching: both arm and arm64 are using this
to associate the PCI controller with the matching MSI hw, using the
device tree (msi-controller and msi-parent properties in DT, of_node
field in the msi_controller structure).
- associated irq_domain (I've added that bit).

I expect setup_irq and co to disappear at some point, once all the users
have been converted to stacked domains. The matching information is
harder to let go though. But that could be a structure that doesn't have
to be inflicted on everyone, if we can go from:

pci-device -> msi-controller -> irq-domain

to

pci-device -> irq-domain -> dt-topology-information

Thoughts?

	M.
-- 
Jazz is not dead. It just smells funny...

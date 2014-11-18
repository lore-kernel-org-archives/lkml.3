Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbaKRLSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:18:11 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:6540 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaKRLSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:18:08 -0500
Message-ID: <546B2ACC.90304@huawei.com>
Date: Tue, 18 Nov 2014 19:17:32 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Liviu Dudau <liviu@dudau.co.uk>,
        "Tony Luck" <tony.luck@intel.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-pci@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Xinwei Hu <huxinwei@huawei.com>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        <Suravee.Suthikulpanit@amd.com>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        <linux-ia64@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Wuyun <wuyun.wu@huawei.com>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [RFC PATCH 00/16] Refine PCI host bridge scan interfaces
References: <1416219710-26088-1-git-send-email-wangyijing@huawei.com> <1463511.o4kE8TX3Bd@wuerfel>
In-Reply-To: <1463511.o4kE8TX3Bd@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020209.546B2ADD.0137,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 21f3bc63386cbff5ab0b19abc1d00665
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/17 22:13, Arnd Bergmann wrote:
> On Monday 17 November 2014 18:21:34 Yijing Wang wrote:
>> This series is based Linux 3.18-rc1 and Lorenzo Pieralisi's
>> arm PCI domain cleanup patches, link: 
>> https://patchwork.ozlabs.org/patch/407585/
>>
>> Current pci scan interfaces like pci_scan_root_bus() and directly
>> call pci_create_root_bus()/pci_scan_child_bus() lack flexiblity.
>> Some platform infos like PCI domain and msi_chip have to be
>> associated to PCI bus by some arch specific function.
>> We want to make a generic pci_host_bridge, and make it hold
>> the platform infos or hook. Then we could eliminate the lots
>> of arch pci_domain_nr, also we could associate some platform 
>> ops something like pci_get_msi_chip(struct pci_dev *dev)
>> with pci_host_bridge to avoid introduce arch weak functions.
>>
>> This RFC version not for all platforms, just applied the new
>> scan interface in x86/arm/powerpc/ia64, I will refresh other
>> platforms after the core pci scan interfaces are ok.
> 
> I think overall this is a good direction to take, in particular
> moving more things into struct pci_host_bridge so we can
> slim down the architecture specific code.

Hi Arnd, thanks very much for your review and comments!

> 
> I don't particularly like the way you use the 'pci_host_info'
> to pass callback pointers and some of the generic information.
> This duplicates some of the issues we are currently trying
> to untangle in the arm32 code to make drivers easier to share
> between architectures.

What arm32 code you are trying to untangle for example ?

Introduce pci_host_info here because I want to make the PCI scan interfaces
simple to host drviers, host drivers only need to call one scan
interface(pci_scan_host_bridge), but from your comments,
The combination pci_create_host_bridge() + pci_scan_xx()
seems to be more popular.

> 
> As a general approach, I'd rather see generic helper functions
> being exported by the PCI core that a driver may or may not
> call. 
> The way you split the interface between things that happen
> before scanning the buses (pci_create_host_bridge) and
> the actual scanning (__pci_create_root_bus, pci_scan_child_bus)
> seems very helpful and I think we can expand that concept further:
> 
> - The normal pci_create_host_bridge() function can contain
>   all of the DT scanning functions (finding bus/mem/io resources, 
>   finding the msi-parent), while drivers that don't depend on DT
>   for this information can call the same function and fill the
>   same things after they have the pci_host_bridge pointer.
> 
> - If a driver needs to set up mapping windows, it can do that after
>   calling pci_create_host_bridge(). E.g. all the dw_pcie glue drivers
>   can call a dw_pcie_setup_windows() function that takes the resources
>   out of the pci_host_bridge pointer before the bus is scanned.
> 
> - The ACPI code can have a completely different way of creating
>   a struct pci_host_bridge, which is also passed into the same
>   bus scanning functions, but doesn't have to come from
>   pci_create_host_bridge.

I hope platforms with ACPI or DT could both use pci_create_host_bridge().
Why we need to use two different ways to process it ?

> 
> - The PowerPC of_scan_bus function can take the same pci_host_bridge
>   pointer that comes from pci_create_host_bridge(), but we'd call
>   either pci_create_root_bus or of_scan_bus instead of calling
>   of_scan_bus through an indirect pointer from pci_create_root_bus.
> 
> 	Arnd
> 
> .
> 


-- 
Thanks!
Yijing


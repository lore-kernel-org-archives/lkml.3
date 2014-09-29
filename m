Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbaI2Bo5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 21:44:57 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:18324 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaI2Boy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 21:44:54 -0400
Message-ID: <5428B971.50101@huawei.com>
Date: Mon, 29 Sep 2014 09:44:17 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Liviu Dudau <liviu@dudau.co.uk>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xinwei Hu <huxinwei@huawei.com>,
        Wuyun <wuyun.wu@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-arch@vger.kernel.org>,
        <arnab.basu@freescale.com>, <Bharat.Bhushan@freescale.com>,
        <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <xen-devel@lists.xenproject.org>, Joerg Roedel <joro@8bytes.org>,
        <iommu@lists.linux-foundation.org>, <linux-mips@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        "Tony Luck" <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        David Vrabel <david.vrabel@citrix.com>,
        "Sergei Shtylyov" <sergei.shtylyov@cogentembedded.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH v2 00/22] Use MSI chip framework to configure MSI/MSI-X
 in all platforms
References: <1411614872-4009-1-git-send-email-wangyijing@huawei.com> <20140925074235.GN12423@ulmo> <20140925144855.GB31157@bart.dudau.co.uk> <20140925164937.GB30382@ulmo> <5424E09F.50701@huawei.com> <20140926085030.GE31157@bart.dudau.co.uk> <54276F6C.5010705@huawei.com> <20140928112144.GA4671@bart.dudau.co.uk>
In-Reply-To: <20140928112144.GA4671@bart.dudau.co.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/28 19:21, Liviu Dudau wrote:
> On Sun, Sep 28, 2014 at 10:16:12AM +0800, Yijing Wang wrote:
>>>>>> What I would like to see is a way of creating the pci_host_bridge structure outside
>>>>>> the pci_create_root_bus(). That would then allow us to pass this sort of platform
>>>>>> details like associated msi_chip into the host bridge and the child busses will
>>>>>> have an easy way of finding the information needed by finding the root bus and then
>>>>>> the host bridge structure. Then the generic pci_scan_root_bus() can be used by (mostly)
>>>>>> everyone and the drivers can remove their kludges that try to work around the
>>>>>> current limitations.
>>>>
>>>> So I think maybe save msi chip in PCI arch sysdata is a good candidate.
>>>
>>> Except that arch sysdata at the moment is an opaque pointer. I am all in favour in
>>> changing the type of sysdata from void* into pci_host_bridge* and arches can wrap their old
>>> sysdata around the pci_host_bridge*.
>>
>> I inspected every arch and found there are almost no common stuff,
> 
> I will disagree here. Most (all?) of the structures that are passed as sysdata argument to

Most.

> pci_create_root_bus() or pci_scan_root_bus() have a set of resources for storing the MEM and
> IO ranges, which struct pci_host_bridge already has. So that can be factored out of the
> arch code. Same for pci_domain_nr. Then there are some variables that are used for communication
> with the platform code due to convoluted way(s) in which PCI code gets instantiated.

Yes, currently some archs store MEM and IO resource in pci sysdata, and others not, move the MEM and IO
resource to pci_host_bride could make code become simple, we can clean up the resource list argument in
pci scan functions.

> 
> What I am arguing here is not that the arch equivalent of pci_host_bridge structure is already
> common, but that by moving the members that are common out of arch sysdata into pci_host_bridge
> we will have more commonality and it will be easier to re-factor the code.

Now, I got it, thanks!

> 
>> and generic data struct should
>> be created in generic PCI code.
> 
> Not necessarily. What I have in mind is something like this:

This is a good idea, what I'm worried is this series is already large, so I think we need to post
another series to do it.


> 
>  - drivers/pci/ exports pci_init_host_bridge() that does the initialisation of bridge->windows
>    and anything else that is needed (like find_pci_host_bridge() function).
>  - arch code does:
> 
> 	struct pci_controller {
> 		struct pci_host_bridge bridge;
> 		.....
> 	};
> 
> 	#define to_pci_controller(bridge)	container_of(bridge, struct pci_controller, bridge)
> 
> 	static inline struct pci_controller *get_host_controller(const struct pci_bus *bus)
> 	{
> 		struct pci_host_bridge *bridge = find_pci_host_bridge(bus);
> 		if (bridge)
> 			return to_pci_controller(bridge);
> 
> 		return NULL;
> 	}
> 
> 	int arch_pci_init(....)
> 	{
> 		struct pci_controller *hose;
> 		....
> 		hose = kzalloc(sizeof(*hose), GFP_KERNEL);
> 		pci_init_host_bridge(&hose->bridge);
> 		....
> 		pci_scan_root_bus(...., &hose->bridge, &resources);
> 		....
> 		return 0;
> 	}
> 
> Then finding the right structure will be easy.
> 
>> Another, I don't like associate msi chip and every PCI device, further more,
>> almost all platforms except arm have only one MSI controller, and currently, PCI enumerating code doesn't need
>> to know the MSI chip details, like for legacy IRQ, PCI device doesn't need to know which IRQ controller they
>> should deliver IRQ to. I would think more about it, and hope other PCI guys can give some comments, especially from Bjorn.
>>
> 
> I wasn't suggesing to associate an msi chip with every PCI device, but with the pci_host_bridge.
> I don't expect a host bridge to have more than one msi chip, so that should be OK. Also, I'm
> thinking that getting the associated msi chip should be some sort of pci_host_bridge ops function,
> and for arches that don't care about MSI it doesn't get implemented.

Currently, a property "msi-parent" was introduced in arm, and all msi chip integrated in irq chip controller will
be added to of_pci_msi_chip_list. PCI host driver find the match msi chip by its of_node.

Thanks!
Yijing.

> 
> Best regards,
> Liviu
> 
>  
>> Thanks!
>> Yijing.
>>
>>>
>>> Best regards,
>>> Liviu
>>>
>>>>
>>>>>
>>>>> I think both issues are orthogonal. Last time I checked a lot of work
>>>>> was still necessary to unify host bridges enough so that it could be
>>>>> shared across architectures. But perhaps some of that work has
>>>>> happened in the meantime.
>>>>>
>>>>> But like I said, when you create the root bus, you can easily attach the
>>>>> MSI chip to it.
>>>>>
>>>>> Thierry
>>>>>
>>>>
>>>>
>>>> -- 
>>>> Thanks!
>>>> Yijing
>>>>
>>>>
>>>
>>
>>
>> -- 
>> Thanks!
>> Yijing
>>
>>
> 


-- 
Thanks!
Yijing


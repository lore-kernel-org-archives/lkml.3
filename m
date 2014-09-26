Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaIZB4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 21:56:09 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:18447 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbaIZBzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 21:55:50 -0400
Message-ID: <5424C77B.2060807@huawei.com>
Date: Fri, 26 Sep 2014 09:55:07 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
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
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH v2 02/22] PCI/MSI: Remove useless bus->msi assignment
References: <1411614872-4009-1-git-send-email-wangyijing@huawei.com> <1411614872-4009-3-git-send-email-wangyijing@huawei.com> <20140925070601.GF12423@ulmo>
In-Reply-To: <20140925070601.GF12423@ulmo>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.5424C792.00B0,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 92fc8dcb982db260fa22475eeee18a7a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/25 15:06, Thierry Reding wrote:
> On Thu, Sep 25, 2014 at 11:14:12AM +0800, Yijing Wang wrote:
>> Currently, PCI drivers will initialize bus->msi in
>> pcibios_add_bus(). pcibios_add_bus() will be called
>> in every pci bus initialization. So the bus->msi
>> assignment in pci_alloc_child_bus() is useless.
> 
> I think this should be the other way around. The default should be to
> inherit bus->msi from the parent. That way drivers don't typically have
> to do it, yet they can still opt to override it if they need to.
> 
> For Tegra for example I think it would work if we assigned the MSI chip
> to the root bus (in tegra_pcie_scan_bus()) and then have it propagated
> to child busses in pci_alloc_child_bus() so that tegra_pcie_add_bus()
> can be removed altogether.

Hi Thierry, thanks very much for your review and comments!

Because pcibios_add_bus() and "child->msi = parent->msi;" in pci_alloc_child_bus()
do the same thing. So I think we should use one and remove another. I like
the latter.

In addition, I consider several solutions to associate msi chip and PCI device.

1. Add a msi_chip member in PCI arch sysdata to store the msi_chip pointer. Because
all PCI devices under a PCI hostbridge always share the same msi chip, so every PCI device
can find the msi chip by pci_bus->sysdata, but in this solution, we also need to add
ARCH specific functions to extract msi chip from PCI arch sysdata, like pci_domain_nr().
Then we can remove .add_bus() like tegra_pcie_add_bus() and the msi assignment in  pci_alloc_child_bus().

2. Remove .add_bus() functions, associate PCI root bus and msi chip after PCI root bus created,
as you mentioned above. In this solution we need to associate PCI root bus and msi chip in all PCI
hostbridge drivers, like in tegra_pcie_scan_bus().


3. Introduce a global msi chip list, currently, only in arm, there maybe more than one type MSI chip,
but in arm, we can find msi chip by PCI hostbridge platform device's of_node, Eg. use "msi-parent" property
to find it. Or msi chip is integrated into PCI hostbridge, we can find msi chip by compare msi_chip->dev and
PCI hostbridge's platform device's struct device *dev pointer. And because PCI hostbridge platform device pass
to pci_create_root_bus() as the parent device, so every PCI devices can first find the platform device, then
to find the msi chip, this solution looks a bit ugly, but we only associate pci hostbridge and msi chip, PCI child
buses and devices do not have to know the msi chip details.

4. Last, in this series, introduced weak arch function arch_find_msi_chip(), it's the simplest one, because all platforms
except arm, only one msi chip will exist in system.

What do you think about this ?

Thanks!
Yijing.

> 
> Thierry
> 


-- 
Thanks!
Yijing


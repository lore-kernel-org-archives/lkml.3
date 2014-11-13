Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788AbaKMMaC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 07:30:02 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:53020 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419AbaKMMaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 07:30:00 -0500
Message-ID: <5464A3F8.1000807@huawei.com>
Date: Thu, 13 Nov 2014 20:28:40 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        "Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC: Tony Luck <tony.luck@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch V1 0/6] Refine generic/PCI MSI irqodmian interfaces
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020208.5464A401.0173,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 1c752196d245dae841cae895127fa61d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/13 19:43, Jiang Liu wrote:
> This patch set is based on tip/irq/irqdomain and tries to refine
> interfaces to support irqdomain for generic MSI and PCI MSI.
> 
> Patch 1 is just minor fixes for tip/irq/irqdomain.
> 
> Patch 2 introduces some helpers to hide struct msi_desc implementation
> details, so later we could move msi_list from struct pci_dev into
> struct device to enable generic MSI support.

Hi Gerry,
   I tried to move msi info(eg. msi_list) into struct device, but I found
DMAR fault interrupt is initialized before the driver core init. And I don't
know whether there are other devices like ARM consolidator(introduced in GIC v3)
need to be initialized before driver core. What do you think about this ?

Thanks!
Yijing.

> 
> Patch 3 introduces msi_domain_{alloc|free}_irqs() which generalize
> pci_msi_domain_alloc_irqs() to support generic MSI.
> 
> Patch 4 introduces default data structures and callback implementations
> to support msi_domain_alloc_irqs(), so reduce burden on generic MSI
> users.
> 
> Patch 5 converts PCI MSI to use generic MSI interfaces, and also
> implement default callbacks for PCI MSI.
> 
> Patch 6 introduces a mechanism to replace arch_setup_msi_irq()/
> arch_setup_msi_irqs()/arch_teardown_msi_irq()/arch_teardown_msi_irqs().
> 
> With this patch set applied, the generic MSI and PCI MSI interfaces
> are much easier to use. For extreme case, you only need to define
> a "struct msi_domain_info" and don't need to implement any callbacks,
> just using the default callbacks is OK:)
> 
> This patch set is also a preparation for:
> 1) Kill all weak functions in drivers/pci/msi.c
> 2) Implement support for non-PCI-compliant MSI device
> 
> It has been tested on x86 platforms, comments are welcomed!
> 
> Jiang Liu (6):
>   PCI, MSI: Fix errors caused by commit e5f1a59c4e12
>   PCI, MSI: Introduce helpers to hide struct msi_desc implemenation
>     details
>   genirq: Introduce msi_domain_{alloc|free}_irqs()
>   genirq: Provide default callbacks for msi_domain_ops
>   PCI, MSI: Refine irqdomain interfaces to simplify its usage
>   PCI, MSI: Provide mechanism to alloc/free MSI/MSIX interrupt from
>     irqdomain
> 
>  drivers/pci/msi.c   |  170 ++++++++++++++++++++++++++++++++++++++++-----------
>  include/linux/msi.h |   90 ++++++++++++++++++++++++---
>  kernel/irq/msi.c    |  150 ++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 366 insertions(+), 44 deletions(-)
> 


-- 
Thanks!
Yijing


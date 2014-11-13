Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891AbaKMMkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 07:40:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:37852 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932566AbaKMMj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 07:39:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="487161742"
Message-ID: <5464A68E.4010004@linux.intel.com>
Date: Thu, 13 Nov 2014 20:39:42 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch V1 0/6] Refine generic/PCI MSI irqodmian interfaces
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com> <5464A3F8.1000807@huawei.com>
In-Reply-To: <5464A3F8.1000807@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/11/13 20:28, Yijing Wang wrote:
> On 2014/11/13 19:43, Jiang Liu wrote:
>> This patch set is based on tip/irq/irqdomain and tries to refine
>> interfaces to support irqdomain for generic MSI and PCI MSI.
>>
>> Patch 1 is just minor fixes for tip/irq/irqdomain.
>>
>> Patch 2 introduces some helpers to hide struct msi_desc implementation
>> details, so later we could move msi_list from struct pci_dev into
>> struct device to enable generic MSI support.
> 
> Hi Gerry,
>    I tried to move msi info(eg. msi_list) into struct device, but I found
> DMAR fault interrupt is initialized before the driver core init. And I don't
> know whether there are other devices like ARM consolidator(introduced in GIC v3)
> need to be initialized before driver core. What do you think about this ?
Hi Yijing,
	DMAR interrupt doesn't make use of msi_desc, so has no
dependency on msi_list.
	Actually there are two levels of generic MSI sharing. The first
level is to share common irq_chip/irqdomain code, such as HPET, DMAR and
HT_IRQ. The second level is to share msi_desc, such as some device
on ARM side as you have mentioned.
	With this patch set applied, we achieve level one sharing. For
level two sharing, we need to move msi_list into struct device, refactor
struct msi_desc, and provide a generic pci_enable_msix_range alike
user interfaces. I'm still working on this part, so we could cooperate
with each other.
Thanks!
Gerry

> 
> Thanks!
> Yijing.
> 
>>
>> Patch 3 introduces msi_domain_{alloc|free}_irqs() which generalize
>> pci_msi_domain_alloc_irqs() to support generic MSI.
>>
>> Patch 4 introduces default data structures and callback implementations
>> to support msi_domain_alloc_irqs(), so reduce burden on generic MSI
>> users.
>>
>> Patch 5 converts PCI MSI to use generic MSI interfaces, and also
>> implement default callbacks for PCI MSI.
>>
>> Patch 6 introduces a mechanism to replace arch_setup_msi_irq()/
>> arch_setup_msi_irqs()/arch_teardown_msi_irq()/arch_teardown_msi_irqs().
>>
>> With this patch set applied, the generic MSI and PCI MSI interfaces
>> are much easier to use. For extreme case, you only need to define
>> a "struct msi_domain_info" and don't need to implement any callbacks,
>> just using the default callbacks is OK:)
>>
>> This patch set is also a preparation for:
>> 1) Kill all weak functions in drivers/pci/msi.c
>> 2) Implement support for non-PCI-compliant MSI device
>>
>> It has been tested on x86 platforms, comments are welcomed!
>>
>> Jiang Liu (6):
>>   PCI, MSI: Fix errors caused by commit e5f1a59c4e12
>>   PCI, MSI: Introduce helpers to hide struct msi_desc implemenation
>>     details
>>   genirq: Introduce msi_domain_{alloc|free}_irqs()
>>   genirq: Provide default callbacks for msi_domain_ops
>>   PCI, MSI: Refine irqdomain interfaces to simplify its usage
>>   PCI, MSI: Provide mechanism to alloc/free MSI/MSIX interrupt from
>>     irqdomain
>>
>>  drivers/pci/msi.c   |  170 ++++++++++++++++++++++++++++++++++++++++-----------
>>  include/linux/msi.h |   90 ++++++++++++++++++++++++---
>>  kernel/irq/msi.c    |  150 ++++++++++++++++++++++++++++++++++++++++++++-
>>  3 files changed, 366 insertions(+), 44 deletions(-)
>>
> 
> 

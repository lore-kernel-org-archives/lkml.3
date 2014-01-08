Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbaAHGCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 01:02:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:7408 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350AbaAHGCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 01:02:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,622,1384329600"; 
   d="scan'208";a="455250762"
Message-ID: <52CCE9CD.5060404@linux.intel.com>
Date: Wed, 08 Jan 2014 14:01:49 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kai Huang <dev.kai.huang@gmail.com>
CC: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [RFC Patch Part2 V1 14/14] iommu/vt-d: update IOMMU state when
 memory hotplug happens
References: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>	<1389085234-22296-15-git-send-email-jiang.liu@linux.intel.com> <CAOtp4Kqn5e_51hwrRMgRmam7jXaVC=md7BAuwnG3gJGETj9iQA@mail.gmail.com>
In-Reply-To: <CAOtp4Kqn5e_51hwrRMgRmam7jXaVC=md7BAuwnG3gJGETj9iQA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/1/8 13:07, Kai Huang wrote:
> On Tue, Jan 7, 2014 at 5:00 PM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
>> If static identity domain is created, IOMMU driver needs to update
>> si_domain page table when memory hotplug event happens. Otherwise
>> PCI device DMA operations can't access the hot-added memory regions.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> ---
>>  drivers/iommu/intel-iommu.c |   52 ++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 51 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
>> index 83e3ed4..35a987d 100644
>> --- a/drivers/iommu/intel-iommu.c
>> +++ b/drivers/iommu/intel-iommu.c
>> @@ -33,6 +33,7 @@
>>  #include <linux/dmar.h>
>>  #include <linux/dma-mapping.h>
>>  #include <linux/mempool.h>
>> +#include <linux/memory.h>
>>  #include <linux/timer.h>
>>  #include <linux/iova.h>
>>  #include <linux/iommu.h>
>> @@ -3689,6 +3690,54 @@ static struct notifier_block device_nb = {
>>         .notifier_call = device_notifier,
>>  };
>>
>> +static int intel_iommu_memory_notifier(struct notifier_block *nb,
>> +                                      unsigned long val, void *v)
>> +{
>> +       struct memory_notify *mhp = v;
>> +       unsigned long long start, end;
>> +       struct iova *iova;
>> +
>> +       switch (val) {
>> +       case MEM_GOING_ONLINE:
>> +               start = mhp->start_pfn << PAGE_SHIFT;
>> +               end = ((mhp->start_pfn + mhp->nr_pages) << PAGE_SHIFT) - 1;
>> +               if (iommu_domain_identity_map(si_domain, start, end)) {
>> +                       pr_warn("dmar: failed to build identity map for [%llx-%llx]\n",
>> +                               start, end);
>> +                       return NOTIFY_BAD;
>> +               }
> 
> Better to use iommu_prepare_identity_map? For si_domain, if
> hw_pass_through is used, there's no page table.
Hi Kai,
	Good catch!
Seems function iommu_prepare_identity_map() is designed to handle
RMRRs. So how about avoiding of registering memory hotplug notifier
if hw_pass_through is true?

Thanks!
Gerry

> 
>> +               break;
>> +       case MEM_OFFLINE:
>> +       case MEM_CANCEL_ONLINE:
>> +               /* TODO: enhance RB-tree and IOVA code to support of splitting iova */
>> +               iova = find_iova(&si_domain->iovad, mhp->start_pfn);
>> +               if (iova) {
>> +                       unsigned long start_pfn, last_pfn;
>> +                       struct dmar_drhd_unit *drhd;
>> +                       struct intel_iommu *iommu;
>> +
>> +                       start_pfn = mm_to_dma_pfn(iova->pfn_lo);
>> +                       last_pfn = mm_to_dma_pfn(iova->pfn_hi + 1) - 1;
>> +                       dma_pte_clear_range(si_domain, start_pfn, last_pfn);
>> +                       dma_pte_free_pagetable(si_domain, start_pfn, last_pfn);
>> +                       rcu_read_lock();
>> +                       for_each_active_iommu(iommu, drhd)
>> +                               iommu_flush_iotlb_psi(iommu, si_domain->id,
>> +                                       start_pfn, last_pfn - start_pfn + 1, 0);
>> +                       rcu_read_unlock();
>> +                       __free_iova(&si_domain->iovad, iova);
>> +               }
> 
> The same as above. Looks we need to consider hw_pass_through for the si_domain.
> 
> -Kai
> 
>> +               break;
>> +       }
>> +
>> +       return NOTIFY_OK;
>> +}
>> +
>> +static struct notifier_block intel_iommu_memory_nb = {
>> +       .notifier_call = intel_iommu_memory_notifier,
>> +       .priority = 0
>> +};
>> +
>>  int __init intel_iommu_init(void)
>>  {
>>         int ret = -ENODEV;
>> @@ -3761,8 +3810,9 @@ int __init intel_iommu_init(void)
>>         init_iommu_pm_ops();
>>
>>         bus_set_iommu(&pci_bus_type, &intel_iommu_ops);
>> -
>>         bus_register_notifier(&pci_bus_type, &device_nb);
>> +       if (si_domain)
>> +               register_memory_notifier(&intel_iommu_memory_nb);
>>
>>         intel_iommu_enabled = 1;
>>
>> --
>> 1.7.10.4
>>
>> _______________________________________________
>> iommu mailing list
>> iommu@lists.linux-foundation.org
>> https://lists.linuxfoundation.org/mailman/listinfo/iommu

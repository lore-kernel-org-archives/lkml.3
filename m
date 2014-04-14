Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbaDNI6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:58:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:63287 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950AbaDNI56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:57:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,856,1389772800"; 
   d="scan'208";a="512541464"
Message-ID: <534BA30B.5040102@linux.intel.com>
Date: Mon, 14 Apr 2014 16:57:47 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>,
        "Woodhouse, David" <david.woodhouse@intel.com>
CC: "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>
Subject: Re: hpsa driver bug crack kernel down!
References: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>	 <1397083799.2608.20.camel@buesod1.americas.hpqcorp.net>	 <1397084904.9519.62.camel@dabdike> <1397085044.9519.63.camel@dabdike>	 <1397086817.2608.25.camel@buesod1.americas.hpqcorp.net>	 <1397087425.9519.67.camel@dabdike>	 <1397089180.2608.27.camel@buesod1.americas.hpqcorp.net>	 <CAErSpo4H=hcro8sMnt2MzDDVCROpASuUTQWBw37OxodHTyOfyw@mail.gmail.com>	 <1397111557.2608.29.camel@buesod1.americas.hpqcorp.net>	 <20140410071535.GX13491@8bytes.org>	 <1397119587.19944.14.camel@shinybook.infradead.org> <1397146781.2608.46.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1397146781.2608.46.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
	I guess I found the root cause. It's a bug in matching
device scope, variable 'level' should be decreased when walking up PCI
topology.
	Could you please help to test following patch?
Thanks!
Gerry

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index f445c10..1f8308c 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -152,7 +152,7 @@ dmar_alloc_pci_notify_info(struct pci_dev *dev,
unsigned long event)
        info->seg = pci_domain_nr(dev->bus);
        info->level = level;
        if (event == BUS_NOTIFY_ADD_DEVICE) {
-               for (tmp = dev, level--; tmp; tmp = tmp->bus->self) {
+               for (tmp = dev, level--; tmp; level--, tmp =
tmp->bus->self) {
                        info->path[level].device = PCI_SLOT(tmp->devfn);
                        info->path[level].function = PCI_FUNC(tmp->devfn);
                        if (pci_is_root_bus(tmp->bus))


On 2014/4/11 0:19, Davidlohr Bueso wrote:
> On Thu, 2014-04-10 at 08:46 +0000, Woodhouse, David wrote:
>> On Thu, 2014-04-10 at 09:15 +0200, Joerg Roedel wrote:
>>> [+ David, VT-d maintainer ]
>>>
>>> Jiang, David, can you please have a look into this issue?
>>>
>>
>>>>>>>>>>> DMAR:[fault reason 02] Present bit in context entry is clear
>>>>>>>>>>> dmar: DRHD: handling fault status reg 602
>>>>>>>>>>> dmar: DMAR:[DMA Read] Request device [02:00.0] fault addr 7f61e000
>>
>> That "Present bit in context entry is clear" fault means that we have
>> not set up *any* mappings for this PCI device… on this IOMMU.
>>
>>>> Yes, specifically (finally done bisecting):
>>>>
>>>> commit 2e45528930388658603ea24d49cf52867b928d3e
>>>> Author: Jiang Liu <jiang.liu@linux.intel.com>
>>>> Date:   Wed Feb 19 14:07:36 2014 +0800
>>>>
>>>>     iommu/vt-d: Unify the way to process DMAR device scope array
>>
>> This commit is about how we decide which IOMMU a given PCI device is
>> attached to.
>>
>> Thus, my first guess would be that we are quite happily setting up the
>> requested DMA maps on the *wrong* IOMMU, and then taking faults when the
>> device actually tries to do DMA.
>>
>> However, I'm not 100% convinced of that. The fault address looks
>> suspiciously like a true physical address, not a virtual bus address of
>> the type that we'd normally allocate for a dma_map_* operation. Those
>> would start at 0xfffff000 and work downwards, typically.
>>
>> Do you have 'iommu=pt' on the kernel command line? 
> 
> No.
> 
>> Can I see the full
>> dmesg as this system boots, and also a copy of the DMAR table?
> 
> Attaching a dmesg from one of the kernels that boots. It doesn't appear
> to have much of the related information... is there any debug config
> option I can enable that might give you more data?
> 

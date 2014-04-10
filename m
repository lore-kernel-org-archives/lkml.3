Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030208AbaDJPg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 11:36:56 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:7885 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbaDJPgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 11:36:54 -0400
Message-ID: <5346BA93.5090904@hp.com>
Date: Thu, 10 Apr 2014 11:36:51 -0400
From: Linda Knippers <linda.knippers@hp.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        "Woodhouse, David" <david.woodhouse@intel.com>
CC: "bhe@redhat.com" <bhe@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "davidlohr@hp.com" <davidlohr@hp.com>,
        "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>,
        "jiang.liu@linux.intel.com" <jiang.liu@linux.intel.com>
Subject: Re: hpsa driver bug crack kernel down!
References: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>	<1397083799.2608.20.camel@buesod1.americas.hpqcorp.net>	<1397084904.9519.62.camel@dabdike>	<1397085044.9519.63.camel@dabdike>	<1397086817.2608.25.camel@buesod1.americas.hpqcorp.net>	<1397087425.9519.67.camel@dabdike>	<1397089180.2608.27.camel@buesod1.americas.hpqcorp.net>	<CAErSpo4H=hcro8sMnt2MzDDVCROpASuUTQWBw37OxodHTyOfyw@mail.gmail.com>	<1397111557.2608.29.camel@buesod1.americas.hpqcorp.net>	<20140410071535.GX13491@8bytes.org>	<1397119587.19944.14.camel@shinybook.infradead.org> <CAErSpo6EORf02WS1UqP8EMWfHij7W2J5B3ZOoBT90txV85uZZw@mail.gmail.com>
In-Reply-To: <CAErSpo6EORf02WS1UqP8EMWfHij7W2J5B3ZOoBT90txV85uZZw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/2014 11:14 AM, Bjorn Helgaas wrote:
> On Thu, Apr 10, 2014 at 2:46 AM, Woodhouse, David
> <david.woodhouse@intel.com> wrote:
> 
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
> 
> I like the "wrong IOMMU (or no IOMMU at all)" theory.  If we didn't
> connect the device with an IOMMU at all, that would explain the device
> DMAing directly to a physical address, wouldn't it?
> 
>> Do you have 'iommu=pt' on the kernel command line? Can I see the full
>> dmesg as this system boots, and also a copy of the DMAR table?

This will be really helpful information.  This box has devices with
RMRR records and if they're not set up correctly, DMAR faults can occur.

>>
>> We should also rate-limit DMA faults, which would avoid the lockup
>> failure mode. Bjorn, what should an IOMMU driver *do* when it detects
>> that a device is creating an endless stream of DMA faults and isn't
>> aborting the transaction?
> 
> You mentioned that POWER with EEH does something intelligent in this
> case, but I'm not familiar with that code.  We have AER support, which
> can result in resetting a device, but I think DMA faults are reported
> differently, and I don't think there's any nice existing way for PCI
> to deal with them.  Maybe there should be, though.
> 
> Bjorn
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
> 


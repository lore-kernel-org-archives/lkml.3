Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab3KUGXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 01:23:20 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:2262 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3KUGXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 01:23:17 -0500
Message-ID: <528DA672.9020707@huawei.com>
Date: Thu, 21 Nov 2013 14:21:38 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>, Bjorn Helgaas <bhelgaas@google.com>
CC: Vinod Koul <vinod.koul@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>, <dmaengine@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/1] IOMMU: Save pci device id instead of pci_dev* pointer
 for DMAR devices
References: <1383639898-48776-1-git-send-email-wangyijing@huawei.com>	 <1383639898-48776-2-git-send-email-wangyijing@huawei.com>	 <20131107180713.GA2955@google.com> <527C5D36.7050206@huawei.com>	 <CAErSpo73N2Th-4D5G8-60tMuGwqthfu-VNHVf3LF9+s2mQp53w@mail.gmail.com> <1384963192.15487.76.camel@shinybook.infradead.org>
In-Reply-To: <1384963192.15487.76.camel@shinybook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/11/20 23:59, David Woodhouse wrote:
> On Fri, 2013-11-08 at 08:46 -0700, Bjorn Helgaas wrote:
>>
>> I don't know the IOMMU drivers well either, but it seems like they
>> rely on notifications of device addition and removal (see
>> iommu_bus_notifier()).  It doesn't seem right for them to also use the
>> generic PCI interfaces like pci_get_domain_bus_and_slot() because the
>> IOMMU driver should already know what devices exist and their
>> lifetimes.  It seems like confusion to mix the two.  But I don't have
>> a concrete suggestion.
> 

Hi David,
   Thanks for your review and comment!

> The generic IOMMU code has a notifier, and calls through to an
> ->add_device() method in the specific IOMMU driver's iommu_ops.
> 
> The Intel IOMMU driver predates that, and its scheme for mapping devices
> to the correct DMAR unit is different. It happens entirely within the
> get_domain_for_dev() function, which happens when we're first asked to
> set up a mapping for a given device (when we don't already have the
> answer stashed in dev->archdata).
> 
> I think we should add an ->add_device() method to the Intel IOMMU
> driver, and make it do much of what's in get_domain_for_dev() right now
> — finding the "proxy" device (the upstream PCIe bridge or whatever), and
> then looking through the ACPI DMAR table to find which DMAR unit that's
> attached to. Then we stash that information (dmar, devfn) in
> dev->archdata, and get_domain_for_dev() still has *some* work to do,
> actually allocating a logical domain on the IOMMU in question, but not
> as much. And refcount the damn domain instead of playing the horrid
> tricks we currently do to hang it off the upstream proxy device *too*.

Intel IOMMU driver has an ->add_device() method already,   .add_device	= intel_iommu_add_device,
this method was used to update iommu group info. Since Intel IOMMU driver has
its own notifier, so maybe it's a nice candidate to do something.
Currently, dmar driver parse DMAR table and find the pci device id under a specific
DRHD. But only save the device pci_dev * pointer in devices array. So if this pci device
was removed, this info became stale info. In the last version patch, I use pci device id intead
of pci_dev * pointer array completely. This maybe introduce some unsafe issues. Because
pci device maybe destroyed during process device dma mapping etc.

So, I have rework the patch and try to save pci device id as well as pci_dev *pointer, like:

struct dmar_device {
   u16 segment;
   u8 bus;
   u8 devfn;  ----------->these tree will be used only when pci device add or remove, we will use them to update pci_dev * pointer in intel iommu driver notifier.
   struct list_head list;   -->add to DRHD device list.
   struct pci_dev *pdev;   --->use to hold the pci device
}

What do you think about ?

In this new patch, we won't change the Intel iommu driver much, just enhance Intel driver iommu
notifier to make DRHD device list always effect, not stale info.

I will send out this new patch soon.

> 
> My main concern here is that the DMAR table contains the PCI bus numbers
> at boot time. Doing the lookup later will only work if we don't renumber
> busses. Or if we have a way to look things up based on the *original*
> bus number.

If we won't remove the pci device, the occupied buses won't be change, I think.
And because in the new patch, we still use pci_dev *pointer to find match DRHD, so
this is not a regression.
Since DMAR also use pci device id to identify the support device,
I have not found anything instead of device id.

In AMD IOMMU driver, it seems to use pci device id to identify drhd too, although
I just take a quickly glanced at it, maybe not correctly.

> 
> The Intel IOMMU also has a bus notifier of its own which it only uses to
> know when a driver is *detached*, so it can tear down the logical domain
> for the corresponding device. Would be nice to have the generic IOMMU
> notifier call a callback for us then too, perhaps.

Update the device info in Intel IOMMU driver is a good point.


Thanks!
Yijing.

> 
> 


-- 
Thanks!
Yijing


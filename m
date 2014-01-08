Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbaAHGtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 01:49:08 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:53964 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbaAHGs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 01:48:58 -0500
MIME-Version: 1.0
In-Reply-To: <52CCF0A9.70703@linux.intel.com>
References: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
	<1389085234-22296-4-git-send-email-jiang.liu@linux.intel.com>
	<CAOtp4KrK8yOktru+hgLSxYNZ67Nm2WYVGi2aGaJ3JJWLrdOq_g@mail.gmail.com>
	<52CCE6AE.1070809@linux.intel.com>
	<CAOtp4Kqo5m-uOKfr8WDwH1v3+23iSv9_329xS=K76Kpq-QXdVw@mail.gmail.com>
	<52CCF0A9.70703@linux.intel.com>
Date: Wed, 8 Jan 2014 14:48:57 +0800
Message-ID: <CAOtp4KpVbS6twWHukFWODDuwujG8BX6zYXOZiGRQM17f49UQ3w@mail.gmail.com>
Subject: Re: [Patch Part2 V1 03/14] iommu/vt-d: simplify function get_domain_for_dev()
From: Kai Huang <dev.kai.huang@gmail.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 2:31 PM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
>
>
> On 2014/1/8 14:06, Kai Huang wrote:
>> On Wed, Jan 8, 2014 at 1:48 PM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
>>>
>>>
>>> On 2014/1/8 11:06, Kai Huang wrote:
>>>>
>>>>
>>>>
>>>> On Tue, Jan 7, 2014 at 5:00 PM, Jiang Liu <jiang.liu@linux.intel.com
>>>> <mailto:jiang.liu@linux.intel.com>> wrote:
>>>>
>>>>     Function get_domain_for_dev() is a little complex, simplify it
>>>>     by factoring out dmar_search_domain_by_dev_info() and
>>>>     dmar_insert_dev_info().
>>>>
>>>>     Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com
>>>>     <mailto:jiang.liu@linux.intel.com>>
>>>>     ---
>>>>      drivers/iommu/intel-iommu.c |  161
>>>>     ++++++++++++++++++++-----------------------
>>>>      1 file changed, 75 insertions(+), 86 deletions(-)
>>>>
>>>>     diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
>>>>     index 1704e97..da65884 100644
>>>>     --- a/drivers/iommu/intel-iommu.c
>>>>     +++ b/drivers/iommu/intel-iommu.c
>>>>     @@ -1957,18 +1957,70 @@ find_domain(struct pci_dev *pdev)
>>>>             return NULL;
>>>>      }
>>>>
>>>>     +static inline struct dmar_domain *
>>>>     +dmar_search_domain_by_dev_info(int segment, int bus, int devfn)
>>>>     +{
>>>>     +       struct device_domain_info *info;
>>>>     +
>>>>     +       list_for_each_entry(info, &device_domain_list, global)
>>>>     +               if (info->segment == segment && info->bus == bus &&
>>>>     +                   info->devfn == devfn)
>>>>     +                       return info->domain;
>>>>     +
>>>>     +       return NULL;
>>>>     +}
>>>>     +
>>>>     +static int dmar_insert_dev_info(int segment, int bus, int devfn,
>>>>     +                               struct pci_dev *dev, struct
>>>>     dmar_domain **domp)
>>>>     +{
>>>>     +       struct dmar_domain *found, *domain = *domp;
>>>>     +       struct device_domain_info *info;
>>>>     +       unsigned long flags;
>>>>     +
>>>>     +       info = alloc_devinfo_mem();
>>>>     +       if (!info)
>>>>     +               return -ENOMEM;
>>>>     +
>>>>     +       info->segment = segment;
>>>>     +       info->bus = bus;
>>>>     +       info->devfn = devfn;
>>>>     +       info->dev = dev;
>>>>     +       info->domain = domain;
>>>>     +       if (!dev)
>>>>     +               domain->flags |= DOMAIN_FLAG_P2P_MULTIPLE_DEVICES;
>>>>     +
>>>>     +       spin_lock_irqsave(&device_domain_lock, flags);
>>>>     +       if (dev)
>>>>     +               found = find_domain(dev);
>>>>     +       else
>>>>     +               found = dmar_search_domain_by_dev_info(segment, bus,
>>>>     devfn);
>>>>     +       if (found) {
>>>>     +               spin_unlock_irqrestore(&device_domain_lock, flags);
>>>>     +               free_devinfo_mem(info);
>>>>     +               if (found != domain) {
>>>>     +                       domain_exit(domain);
>>>>     +                       *domp = found;
>>>>     +               }
>>>>     +       } else {
>>>>     +               list_add(&info->link, &domain->devices);
>>>>     +               list_add(&info->global, &device_domain_list);
>>>>     +               if (dev)
>>>>     +                       dev->dev.archdata.iommu = info;
>>>>     +               spin_unlock_irqrestore(&device_domain_lock, flags);
>>>>     +       }
>>>>     +
>>>>     +       return 0;
>>>>     +}
>>>>
>>>>
>>>> I am a little bit confused about the "alloc before check" sequence in
>>>> above function. I believe the purpose of allocating the
>>>> device_domain_info before searching the domain with spin_lock hold is to
>>>> avoid the memory allocation in the spin_lock? In this case, why can't we
>>>> use mutex instead of spin_lock? In my understanding, if we use mutex, we
>>>> can first check if the domain exists or not before we really allocate
>>>> device_domain_info, right?
>>> Hi Kai,
>>>         Thanks for review!
>>>         The domain->devices list may be access in interrupt context,
>>> so we need to protect it with spin_lock_irqsave(). Otherwise it may
>>> case deadlock.
>>>
>>
>> Thanks. That's what I am thinking. I observed lots of other iommu
>> functions also use spin_lock.
>>
>>>>
>>>> Another question is when is info->iommu field initialized? Looks it is
>>>> not initialized here?
>>> It's set in function iommu_support_dev_iotlb() for devices supporting
>>> device IOTLB.
>>
>> Thanks. I see in iommu_support_dev_iotlb, info->iommu won't be set
>> unless the device supports iotlb and ATS. Does this mean the
>> info->iommu won't be used if the device doesn't support iotlb?
>>
>> If this is true, looks it's not convenient to find the IOMMU that
>> handles the device via info, as it's possible that different IOMMUs
>> share the same domain, and we don't know which IOMMU actually handles
>> this device if we try to find it via the info->domain.
> It's a little heavy to find info by walking the list too:)
> Please refer to domain_get_iommu() for the way to find iommu associated
> with a domain.
>
Looks domain_get_iommu just returns the first IOMMU in the bitmap, so
it can't return the IOMMU that *really* handles the device in
hardware. But I guess from domain's view, probably we don't care which
IOMMU really handles the device, cause if multiple IOMMUs share the
same domain, the IOMMUs should have the same (or very similar)
capabilities, so referencing the first IOMMU to check some
capabilities (that's what I see in code so far) should work for the
domain layer API.

But looks it's safe to set info->iommu in get_domain_for_dev anyway
(and remove it in iommu_support_dev_iotlb)? In this case it's easier
when we want to get IOMMU from info.

Of course, it's just my opinion, and probably is wrong, it's totally
up to you if want to do this or not. :)

-Kai

>>
>> -Kai
>>
>>>
>>>>
>>>> -Kai
>>>>
>>>>     +
>>>>      /* domain is initialized */
>>>>      static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev,
>>>>     int gaw)
>>>>      {
>>>>     -       struct dmar_domain *domain, *found = NULL;
>>>>     +       struct dmar_domain *domain;
>>>>             struct intel_iommu *iommu;
>>>>             struct dmar_drhd_unit *drhd;
>>>>     -       struct device_domain_info *info, *tmp;
>>>>     -       struct pci_dev *dev_tmp;
>>>>     +       struct pci_dev *bridge;
>>>>             unsigned long flags;
>>>>     -       int bus = 0, devfn = 0;
>>>>     -       int segment;
>>>>     -       int ret;
>>>>     +       int segment, bus, devfn;
>>>>
>>>>             domain = find_domain(pdev);
>>>>             if (domain)
>>>>     @@ -1976,119 +2028,56 @@ static struct dmar_domain
>>>>     *get_domain_for_dev(struct pci_dev *pdev, int gaw)
>>>>
>>>>             segment = pci_domain_nr(pdev->bus);
>>>>
>>>>     -       dev_tmp = pci_find_upstream_pcie_bridge(pdev);
>>>>     -       if (dev_tmp) {
>>>>     -               if (pci_is_pcie(dev_tmp)) {
>>>>     -                       bus = dev_tmp->subordinate->number;
>>>>     +       bridge = pci_find_upstream_pcie_bridge(pdev);
>>>>     +       if (bridge) {
>>>>     +               if (pci_is_pcie(bridge)) {
>>>>     +                       bus = bridge->subordinate->number;
>>>>                             devfn = 0;
>>>>                     } else {
>>>>     -                       bus = dev_tmp->bus->number;
>>>>     -                       devfn = dev_tmp->devfn;
>>>>     +                       bus = bridge->bus->number;
>>>>     +                       devfn = bridge->devfn;
>>>>                     }
>>>>                     spin_lock_irqsave(&device_domain_lock, flags);
>>>>     -               list_for_each_entry(info, &device_domain_list, global) {
>>>>     -                       if (info->segment == segment &&
>>>>     -                           info->bus == bus && info->devfn == devfn) {
>>>>     -                               found = info->domain;
>>>>     -                               break;
>>>>     -                       }
>>>>     -               }
>>>>     +               domain = dmar_search_domain_by_dev_info(segment,
>>>>     bus, devfn);
>>>>                     spin_unlock_irqrestore(&device_domain_lock, flags);
>>>>                     /* pcie-pci bridge already has a domain, uses it */
>>>>     -               if (found) {
>>>>     -                       domain = found;
>>>>     +               if (domain)
>>>>                             goto found_domain;
>>>>     -               }
>>>>             }
>>>>
>>>>     -       domain = alloc_domain();
>>>>     -       if (!domain)
>>>>     -               goto error;
>>>>     -
>>>>     -       /* Allocate new domain for the device */
>>>>             drhd = dmar_find_matched_drhd_unit(pdev);
>>>>             if (!drhd) {
>>>>                     printk(KERN_ERR "IOMMU: can't find DMAR for device
>>>>     %s\n",
>>>>                             pci_name(pdev));
>>>>     -               free_domain_mem(domain);
>>>>                     return NULL;
>>>>             }
>>>>             iommu = drhd->iommu;
>>>>
>>>>     -       ret = iommu_attach_domain(domain, iommu);
>>>>     -       if (ret) {
>>>>     +       /* Allocate new domain for the device */
>>>>     +       domain = alloc_domain();
>>>>     +       if (!domain)
>>>>     +               goto error;
>>>>     +       if (iommu_attach_domain(domain, iommu)) {
>>>>                     free_domain_mem(domain);
>>>>                     goto error;
>>>>             }
>>>>     -
>>>>             if (domain_init(domain, gaw)) {
>>>>                     domain_exit(domain);
>>>>                     goto error;
>>>>             }
>>>>
>>>>             /* register pcie-to-pci device */
>>>>     -       if (dev_tmp) {
>>>>     -               info = alloc_devinfo_mem();
>>>>     -               if (!info) {
>>>>     +       if (bridge) {
>>>>     +               if (dmar_insert_dev_info(segment, bus, devfn, NULL,
>>>>     &domain)) {
>>>>                             domain_exit(domain);
>>>>                             goto error;
>>>>                     }
>>>>     -               info->segment = segment;
>>>>     -               info->bus = bus;
>>>>     -               info->devfn = devfn;
>>>>     -               info->dev = NULL;
>>>>     -               info->domain = domain;
>>>>     -               /* This domain is shared by devices under p2p bridge */
>>>>     -               domain->flags |= DOMAIN_FLAG_P2P_MULTIPLE_DEVICES;
>>>>     -
>>>>     -               /* pcie-to-pci bridge already has a domain, uses it */
>>>>     -               found = NULL;
>>>>     -               spin_lock_irqsave(&device_domain_lock, flags);
>>>>     -               list_for_each_entry(tmp, &device_domain_list, global) {
>>>>     -                       if (tmp->segment == segment &&
>>>>     -                           tmp->bus == bus && tmp->devfn == devfn) {
>>>>     -                               found = tmp->domain;
>>>>     -                               break;
>>>>     -                       }
>>>>     -               }
>>>>     -               if (found) {
>>>>     -                       spin_unlock_irqrestore(&device_domain_lock,
>>>>     flags);
>>>>     -                       free_devinfo_mem(info);
>>>>     -                       domain_exit(domain);
>>>>     -                       domain = found;
>>>>     -               } else {
>>>>     -                       list_add(&info->link, &domain->devices);
>>>>     -                       list_add(&info->global, &device_domain_list);
>>>>     -                       spin_unlock_irqrestore(&device_domain_lock,
>>>>     flags);
>>>>     -               }
>>>>             }
>>>>
>>>>      found_domain:
>>>>     -       info = alloc_devinfo_mem();
>>>>     -       if (!info)
>>>>     -               goto error;
>>>>     -       info->segment = segment;
>>>>     -       info->bus = pdev->bus->number;
>>>>     -       info->devfn = pdev->devfn;
>>>>     -       info->dev = pdev;
>>>>     -       info->domain = domain;
>>>>     -       spin_lock_irqsave(&device_domain_lock, flags);
>>>>     -       /* somebody is fast */
>>>>     -       found = find_domain(pdev);
>>>>     -       if (found != NULL) {
>>>>     -               spin_unlock_irqrestore(&device_domain_lock, flags);
>>>>     -               if (found != domain) {
>>>>     -                       domain_exit(domain);
>>>>     -                       domain = found;
>>>>     -               }
>>>>     -               free_devinfo_mem(info);
>>>>     +       if (dmar_insert_dev_info(segment, pdev->bus->number,
>>>>     pdev->devfn,
>>>>     +                                pdev, &domain) == 0)
>>>>                     return domain;
>>>>     -       }
>>>>     -       list_add(&info->link, &domain->devices);
>>>>     -       list_add(&info->global, &device_domain_list);
>>>>     -       pdev->dev.archdata.iommu = info;
>>>>     -       spin_unlock_irqrestore(&device_domain_lock, flags);
>>>>     -       return domain;
>>>>      error:
>>>>             /* recheck it here, maybe others set it */
>>>>             return find_domain(pdev);
>>>>     --
>>>>     1.7.10.4
>>>>
>>>>     _______________________________________________
>>>>     iommu mailing list
>>>>     iommu@lists.linux-foundation.org
>>>>     <mailto:iommu@lists.linux-foundation.org>
>>>>     https://lists.linuxfoundation.org/mailman/listinfo/iommu
>>>>
>>>>

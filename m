Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab3CHLna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 06:43:30 -0500
Received: from bolligen.cirrax.com ([217.197.128.7]:38788 "EHLO
	mail.cirrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab3CHLn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 06:43:28 -0500
From: Gaudenz Steinlin <gaudenz@soziologie.ch>
To: Andrew Cooks <acooks@gmail.com>, alex.williamson@redhat.com,
        acooks@gmail.com, jpiszcz@lucidpixels.com
Cc: David Woodhouse <dwmw2@infradead.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "open list\:INTEL IOMMU \(VT-d\)" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list\:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v4] Quirk for buggy dma source tags with Intel IOMMU.
In-Reply-To: <1362710133-25168-1-git-send-email-acooks@gmail.com>
References: <1362710133-25168-1-git-send-email-acooks@gmail.com>
User-Agent: Notmuch/0.15.1 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Fri, 08 Mar 2013 12:43:12 +0100
Message-ID: <87ip5286cv.fsf@meteor.durcheinandertal.bofh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew

Andrew Cooks <acooks@gmail.com> writes:

> This patch creates a quirk to allow the Intel IOMMU to be enabled for devices
> that use incorrect tags during DMA. It is similar to the quirk for Ricoh
> devices, but allows mapping multiple functions and mapping of 'ghost'
> functions that do not correspond to real devices. Devices that need this
> include a variety of Marvell 88SE91xx based SATA controllers. [1][2]

I can confirm that this version of the patch also works for my mini-PCIe
device (88NV9143). See the my mail about it for more information. I had
to manually fix the patch because the patch utility did not understand
it. There is a formatting error in the last hunk for quirks.c (missing
space before context line) and the line count in the hunk header is
wrong (66 lines changed should be 56 lines). I hope nothing was missing
from the patch.

Tested on 3.8.2.

Gaudenz

>
> Changelog:
> v4: Process feedback received from Alex Williamson.
>  * don't assume function 0 is a real device.
>  * exit early if no ghost functions are known, or all known functions have
>    been mapped.
>  * cleanup failure case so mapping succeeds or fails for all ghost functions
>    per device.
>  * improve comments.
>
> v3:
>  * Adopt David Woodhouse's terminology by referring to the quirky functions as
>  'ghost' functions.
>  * Unmap ghost functions when device is detached from IOMMU.
>  * Stub function for when CONFIG_PCI_QUIRKS is not enabled.
>
>
>  This patch was generated against 3.9-rc1, but will also apply to 3.7.10.
>
>  Bug reports:
>  1. https://bugzilla.redhat.com/show_bug.cgi?id=757166
>  2. https://bugzilla.kernel.org/show_bug.cgi?id=42679
>
> Signed-off-by: Andrew Cooks <acooks@gmail.com>
> ---
>  drivers/iommu/intel-iommu.c |   69 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/pci/quirks.c        |   67 +++++++++++++++++++++++++++++++++++++++++-
>  include/linux/pci.h         |    5 +++
>  include/linux/pci_ids.h     |    1 +
>  4 files changed, 141 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 0099667..f53f3e3 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -1674,6 +1674,69 @@ static int domain_context_mapping_one(struct dmar_domain *domain, int segment,
>  	return 0;
>  }
>  
> +static void iommu_detach_dev(struct intel_iommu *iommu, u8 bus, u8 devfn);
> +
> +static void unmap_ghost_dma_fn(struct pci_dev *pdev, u8 fn_map)
> +{
> +	u8 fn;
> +	struct intel_iommu *iommu;
> +
> +	iommu = device_to_iommu(pci_domain_nr(pdev->bus), pdev->bus->number,
> +				pdev->devfn);
> +
> +	/* something must be seriously fubar if we can't lookup the iommu. */
> +	BUG_ON(!iommu);
> +
> +	for (fn = 0; fn <= 7 && fn_map << fn; fn++) {
> +		if (fn == PCI_FUNC(pdev->devfn))
> +			continue;
> +		if (fn_map & (1<<fn)) {
> +			iommu_detach_dev(iommu,
> +					pdev->bus->number,
> +					PCI_DEVFN(PCI_SLOT(pdev->devfn), fn));
> +			dev_dbg(&pdev->dev, "quirk; ghost func %d unmapped",
> +				fn);
> +		}
> +	}
> +}
> +
> +/* For quirky devices like Marvell 88SE91xx chips that use ghost functions. */
> +static int map_ghost_dma_fn(struct dmar_domain *domain,
> +		struct pci_dev *pdev,
> +		int translation)
> +{
> +	u8 fn, fn_map;
> +	u8 fn_mapped = 0;
> +	int err = 0;
> +
> +	fn_map = pci_get_dma_source_map(pdev);
> +
> +	/* this is the common, non-quirky case. */
> +	if (!fn_map)
> +		return 0;
> +
> +	for (fn = 0; fn <= 7 && fn_map << fn; fn++) {
> +		if (fn == PCI_FUNC(pdev->devfn))
> +			continue;
> +		if (fn_map & (1<<fn)) {
> +			err = domain_context_mapping_one(domain,
> +					pci_domain_nr(pdev->bus),
> +					pdev->bus->number,
> +					PCI_DEVFN(PCI_SLOT(pdev->devfn), fn),
> +					translation);
> +			if (err) {
> +				dev_err(&pdev->dev,
> +					"mapping ghost func %d failed", fn);
> +				unmap_ghost_dma_fn(pdev, fn_mapped);
> +				return err;
> +			}
> +			dev_dbg(&pdev->dev, "quirk; ghost func %d mapped", fn);
> +			fn_mapped |= (1<<fn);
> +		}
> +	}
> +	return 0;
> +}
> +
>  static int
>  domain_context_mapping(struct dmar_domain *domain, struct pci_dev *pdev,
>  			int translation)
> @@ -1687,6 +1750,11 @@ domain_context_mapping(struct dmar_domain *domain, struct pci_dev *pdev,
>  	if (ret)
>  		return ret;
>  
> +	/* quirk for undeclared/ghost pci functions */
> +	ret = map_ghost_dma_fn(domain, pdev, translation);
> +	if (ret)
> +		return ret;
> +
>  	/* dependent device mapping */
>  	tmp = pci_find_upstream_pcie_bridge(pdev);
>  	if (!tmp)
> @@ -3786,6 +3854,7 @@ static void domain_remove_one_dev_info(struct dmar_domain *domain,
>  			iommu_disable_dev_iotlb(info);
>  			iommu_detach_dev(iommu, info->bus, info->devfn);
>  			iommu_detach_dependent_devices(iommu, pdev);
> +			unmap_ghost_dma_fn(pdev, pci_get_dma_source_map(pdev));
>  			free_devinfo_mem(info);
>  
>  			spin_lock_irqsave(&device_domain_lock, flags);
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 0369fb6..cf00acb 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3249,6 +3249,10 @@ static struct pci_dev *pci_func_0_dma_source(struct pci_dev *dev)
>  	return pci_get_slot(dev->bus, PCI_DEVFN(PCI_SLOT(dev->devfn), 0));
>  }
>  
> +/* Table of source functions for real devices. The DMA requests for the
> + * device are tagged with a different real function as source. This is
> + * relevant to multifunction devices.
> + */
>  static const struct pci_dev_dma_source {
>  	u16 vendor;
>  	u16 device;
> @@ -3275,7 +3279,8 @@ static const struct pci_dev_dma_source {
>   * the device doing the DMA, but sometimes hardware is broken and will
>   * tag the DMA as being sourced from a different device.  This function
>   * allows that translation.  Note that the reference count of the
> - * returned device is incremented on all paths.
> + * returned device is incremented on all paths. Translation is done when
> + * the device is added to an IOMMU group.
>   */
>  struct pci_dev *pci_get_dma_source(struct pci_dev *dev)
>  {
> @@ -3292,6 +3297,66 @@ struct pci_dev *pci_get_dma_source(struct pci_dev *dev)
>  	return pci_dev_get(dev);
>  }
>  
> +/* Table of multiple (ghost) source functions. This is similar to the
> + * translated sources above, but with the following differences:
> + * 1. the device may use multiple functions as DMA sources,
> + * 2. these functions cannot be assumed to be actual devices, they're simply
> + * incorrect DMA tags.
> + * 3. the specific ghost function for a request can not always be predicted.
> + * For example, the actual device could be xx:yy.1 and it could use
> + * both 0 and 1 for different requests, with no obvious way to tell when
> + * DMA will be tagged as comming from xx.yy.0 and and when it will be tagged
> + * as comming from xx.yy.1.
> + * The bitmap contains all of the functions used in DMA tags, including the
> + * actual device.
> + * See  https://bugzilla.redhat.com/show_bug.cgi?id=757166,
> + * https://bugzilla.kernel.org/show_bug.cgi?id=42679
> + * https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1089768
> + */
> +static const struct pci_dev_dma_multi_func_sources {
> +	u16 vendor;
> +	u16 device;
> +	u8 func_map;	/* bit map. lsb is fn 0. */
> +} pci_dev_dma_multi_func_sources[] = {
> +	{ PCI_VENDOR_ID_MARVELL_2, 0x9123, (1<<0)|(1<<1)},
> +	{ PCI_VENDOR_ID_MARVELL_2, 0x9125, (1<<0)|(1<<1)},
> +	{ PCI_VENDOR_ID_MARVELL_2, 0x9128, (1<<0)|(1<<1)},
> +	{ PCI_VENDOR_ID_MARVELL_2, 0x9130, (1<<0)|(1<<1)},
> +	{ PCI_VENDOR_ID_MARVELL_2, 0x9143, (1<<0)|(1<<1)},
> +	{ PCI_VENDOR_ID_MARVELL_2, 0x9172, (1<<0)|(1<<1)},
> +	{ 0 }
> +};
> +
> +/*
> + * The mapping of fake/ghost functions is used when the real device is
> + * attached to an IOMMU domain. IOMMU groups are not aware of these
> + * functions, because they're not real devices.
> + */
> +u8 pci_get_dma_source_map(struct pci_dev *dev)
> +{
> +	const struct pci_dev_dma_multi_func_sources *i;
> +
> +	for (i = pci_dev_dma_multi_func_sources; i->func_map; i++) {
> +		if ((i->vendor == dev->vendor ||
> +		     i->vendor == (u16)PCI_ANY_ID) &&
> +		    (i->device == dev->device ||
> +		     i->device == (u16)PCI_ANY_ID)) {
> +			return i->func_map;
> +		}
> +	}
> +	return 0;
> +}
> +
> static const struct pci_dev_acs_enabled {
>  	u16 vendor;
>  	u16 device;
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 2461033..5ad3822 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1578,6 +1578,7 @@ enum pci_fixup_pass {
>  #ifdef CONFIG_PCI_QUIRKS
>  void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev);
>  struct pci_dev *pci_get_dma_source(struct pci_dev *dev);
> +u8 pci_get_dma_source_map(struct pci_dev *dev);
>  int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
>  #else
>  static inline void pci_fixup_device(enum pci_fixup_pass pass,
> @@ -1586,6 +1587,10 @@ static inline struct pci_dev *pci_get_dma_source(struct pci_dev *dev)
>  {
>  	return pci_dev_get(dev);
>  }
> +u8 pci_get_dma_source_map(struct pci_dev *dev)
> +{
> +	return 0;
> +}
>  static inline int pci_dev_specific_acs_enabled(struct pci_dev *dev,
>  					       u16 acs_flags)
>  {
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index f11c1c2..df57496 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -1604,6 +1604,7 @@
>  #define PCI_SUBDEVICE_ID_KEYSPAN_SX2	0x5334
>  
>  #define PCI_VENDOR_ID_MARVELL		0x11ab
> +#define PCI_VENDOR_ID_MARVELL_2	0x1b4b
>  #define PCI_DEVICE_ID_MARVELL_GT64111	0x4146
>  #define PCI_DEVICE_ID_MARVELL_GT64260	0x6430
>  #define PCI_DEVICE_ID_MARVELL_MV64360	0x6460
> -- 
> 1.7.1
>

-- 
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~

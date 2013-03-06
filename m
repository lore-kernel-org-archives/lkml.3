Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab3CFEEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 23:04:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab3CFEEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 23:04:49 -0500
Message-ID: <1362542675.22132.86.camel@bling.home>
Subject: Re: [PATCH] Quirk to support Marvell 88SE91xx SATA controllers with
 Intel IOMMU.
From: Alex Williamson <alex.williamson@redhat.com>
To: Andrew Cooks <acooks@gmail.com>
Cc: joro@8bytes.org, xjtuychu@hotmail.com, gm.ychu@gmail.com,
        bhelgaas@google.com, jpiszcz@lucidpixels.com, dwmw2@infradead.org,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
Date: Tue, 05 Mar 2013 21:04:35 -0700
In-Reply-To: <1362126373-32318-1-git-send-email-acooks@gmail.com>
References: <1354533387-4110-1-git-send-email-acooks@gmail.com>
	, <1355914703-28576-1-git-send-email-acooks@gmail.com>
	 <1362126373-32318-1-git-send-email-acooks@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-01 at 16:26 +0800, Andrew Cooks wrote:
> This is my third submitted patch to make Marvell 88SE91xx SATA controllers work when IOMMU is enabled.[1][2]
> 
> What's changed:
> * Adopt David Woodhouse's terminology by referring to the quirky functions as 'ghost' functions.
> * Unmap ghost functions when device is detached from IOMMU.
> * Stub function for when CONFIG_PCI_QUIRKS is not enabled.
> 
> The bad:
> * Still no AMD support.
> * The table of affected chip IDs is as complete as I can make it by googling for bug reports.
> 
> This patch was generated against commit b0af9cd9aab60ceb17d3ebabb9fdf4ff0a99cf50, but will also apply cleanly to 3.7.10.
> 
> Bug reports:
> 1. https://bugzilla.redhat.com/show_bug.cgi?id=757166
> 2. https://bugzilla.kernel.org/show_bug.cgi?id=42679
> 
> Signed-off-by: Andrew Cooks <acooks@gmail.com>
> ---
>  drivers/iommu/intel-iommu.c |   50 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/pci/quirks.c        |   47 +++++++++++++++++++++++++++++++++++++++-
>  include/linux/pci.h         |    5 ++++
>  include/linux/pci_ids.h     |    1 +
>  4 files changed, 102 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 0099667..13323f2 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -1674,6 +1674,50 @@ static int domain_context_mapping_one(struct dmar_domain *domain, int segment,
>  	return 0;
>  }
>  
> +/* For quirky devices like Marvell 88SE91xx chips that use ghost functions. */
> +static int map_ghost_dma_fn(struct dmar_domain *domain,
> +		struct pci_dev *pdev,
> +		int translation)
> +{
> +	u8 fn, fn_map;
> +	int err = 0;
> +
> +	fn_map = pci_get_dma_source_map(pdev);

if (!fn_map)
	return 0;

> +
> +	for (fn = 1; fn < 8; fn++) {

Wouldn't you want to do 0 to 7, then add:

if (fn == PCI_FUNC(pdev->devfn))
	continue;

You could also get more creative with the loop using shifts and exit
when the remaining map is 0.

> +		if (fn_map & (1 << fn)) {
> +			err = domain_context_mapping_one(domain,
> +					pci_domain_nr(pdev->bus),
> +					pdev->bus->number,
> +					PCI_DEVFN(PCI_SLOT(pdev->devfn), fn),
> +					translation);
> +			if (err)
> +				return err;

I'd be worried that there's missing cleanup here, what if you were
mapping multiple ghost functions and the 2nd one failed, leaving one
attached?

> +			dev_dbg(&pdev->dev, "dma quirk; func %d mapped", fn);
> +		}
> +	}
> +	return 0;
> +}
> +
> +static void iommu_detach_dev(struct intel_iommu *iommu, u8 bus, u8 devfn);
> +
> +static void unmap_ghost_dma_fn(struct intel_iommu *iommu,
> +		struct pci_dev *pdev)
> +{
> +	u8 fn, fn_map;
> +
> +	fn_map = pci_get_dma_source_map(pdev);
> +
> +	for (fn = 1; fn < 8; fn++) {

Same early exit and loop comments as above.

> +		if (fn_map & (1 << fn)) {
> +			iommu_detach_dev(iommu,
> +					pdev->bus->number,
> +					PCI_DEVFN(PCI_SLOT(pdev->devfn), fn));
> +			dev_dbg(&pdev->dev, "dma quirk; func %d unmapped", fn);
> +		}
> +	}
> +}
> +
>  static int
>  domain_context_mapping(struct dmar_domain *domain, struct pci_dev *pdev,
>  			int translation)
> @@ -1687,6 +1731,11 @@ domain_context_mapping(struct dmar_domain *domain, struct pci_dev *pdev,
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
> @@ -3786,6 +3835,7 @@ static void domain_remove_one_dev_info(struct dmar_domain *domain,
>  			iommu_disable_dev_iotlb(info);
>  			iommu_detach_dev(iommu, info->bus, info->devfn);
>  			iommu_detach_dependent_devices(iommu, pdev);
> +			unmap_ghost_dma_fn(iommu, pdev);
>  			free_devinfo_mem(info);
>  
>  			spin_lock_irqsave(&device_domain_lock, flags);
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 0369fb6..d311100 100644
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
> @@ -3292,6 +3297,46 @@ struct pci_dev *pci_get_dma_source(struct pci_dev *dev)
>  	return pci_dev_get(dev);
>  }
>  
> +/* Table of multiple (ghost) source functions. This is similar to the
> + * translated sources above, but with the following differences:
> + * 1. the device may use multiple functions as DMA sources,
> + * 2. these functions cannot be assumed to be actual devices,
> + * 3. the specific ghost function for a request can not be exactly predicted.
> + * The bitmap only contains the additional quirk functions.
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
> +	{ PCI_VENDOR_ID_MARVELL_2, 0x9172, (1<<0)|(1<<1)},

Links to bug reports in the comments might be useful for future
workarounds.  I'm also not sure what you mean in the 3rd bullet, the
non-ghost function of some of these is sometimes 0, sometimes 1?  And
the ghost function is the other?  Skipping fn 0 above, I assume all
cases are fn 0 exists and fn 1 is the ghost function, right?  If so,
then we probably only want bit 1 set.  I'm afraid to ask whether there
are configurations of this vendor/device that have a fn 1.  Thanks,

Alex

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
>  static const struct pci_dev_acs_enabled {
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




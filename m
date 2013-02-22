Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab3BVTjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 14:39:17 -0500
Received: from mail.tintel.eu ([62.213.201.86]:38285 "EHLO mail.tintel.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756975Ab3BVTjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 14:39:14 -0500
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2013 14:39:13 EST
Message-ID: <5127C716.6050903@linux-ipv6.be>
Date: Fri, 22 Feb 2013 20:29:26 +0100
From: Stijn Tintel <stijn@linux-ipv6.be>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130112 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Cooks <acooks@gmail.com>
CC: iommu@lists.linux-foundation.org, joro@8bytes.org, xjtuychu@hotmail.com,
        alex.williamson@redhat.com, bhelgaas@google.com,
        jpiszcz@lucidpixels.com, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH] Fix Intel IOMMU support for Marvell 88SE91xx SATA
 controllers.
References: <1354533387-4110-1-git-send-email-acooks@gmail.com> <1355914703-28576-1-git-send-email-acooks@gmail.com>
In-Reply-To: <1355914703-28576-1-git-send-email-acooks@gmail.com>
X-Enigmail-Version: 1.5
Content-Type: multipart/mixed;
 boundary="------------090109080007000906020602"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090109080007000906020602
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19-12-12 11:58, Andrew Cooks wrote:
> This is my second attempt to make Marvell 88SE91xx SATA controllers work when IOMMU is enabled.[1][2] 
> As suggested, it no longer tries to add support for phantom functions.
> 
> What's missing:
> * No AMD support. I need some help with this.
> * Table of affected chip IDs is incomplete. I think 0x9123, 0x9125, 0x9128 are also affected.
This one is also affected: 08:00.0 0106: 1b4b:9130 (rev 11), this is in
dmesg:

[    1.914086] dmar: DMAR:[DMA Read] Request device [08:00.1] fault addr
fff00000
> 
> Patch is against 3.7.1
> 
> Review and feedback would be appreciated.
I changed your patch to check for my chip ID, and it solves my problem:
no more hang during boot, and the HDD connected to this controller is
now detected with IOMMU enabled.

Also see 1 minor comment inline.
> 
> 1. https://bugzilla.redhat.com/show_bug.cgi?id=757166
> 2. https://bugzilla.kernel.org/show_bug.cgi?id=42679
> 
> Signed-off-by: Andrew Cooks <acooks-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/iommu/intel-iommu.c |   36 ++++++++++++++++++++++++++++++++++--
>  drivers/pci/quirks.c        |   34 ++++++++++++++++++++++++++++++++++
>  include/linux/pci.h         |    1 +
>  3 files changed, 66 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 0badfa4..17e64c0 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -1672,6 +1674,31 @@ static int domain_context_mapping_one(struct dmar_domain *domain, int segment,
>  	return 0;
>  }
>  
> +/* For buggy devices like Marvell 88SE91xx chips that use unclaimed
> + * functions.
> + */
> +static int map_quirky_dma_fn(struct dmar_domain *domain,
> +		struct pci_dev *pdev,
> +		int translation)
> +{
> +	u8 fn;
> +	int err = 0;
> +
> +	for (fn = 1; fn < 8; fn++) {
> +		if (pci_func_is_dma_source(pdev, fn)) {
> +			err = domain_context_mapping_one(domain,
> +					pci_domain_nr(pdev->bus),
> +					pdev->bus->number,
> +					PCI_DEVFN(PCI_SLOT(pdev->devfn), fn),
> +					translation);
> +			if (err)
> +				return err;
> +			dev_dbg(&pdev->dev, "func: %d mapped dma quirk", fn);
> +		}
> +	}
> +	return 0;
> +}
> +
>  static int
>  domain_context_mapping(struct dmar_domain *domain, struct pci_dev *pdev,
>  			int translation)
> @@ -1685,6 +1712,11 @@ domain_context_mapping(struct dmar_domain *domain, struct pci_dev *pdev,
>  	if (ret)
>  		return ret;
>  
> +	/* quirk for undeclared pci functions */
> +	ret = map_quirky_dma_fn(domain, pdev, translation);
> +	if (ret)
> +		return ret;
> +
>  	/* dependent device mapping */
>  	tmp = pci_find_upstream_pcie_bridge(pdev);
>  	if (!tmp)
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 7a451ff..8d02bac 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3227,6 +3227,40 @@ static const struct pci_dev_dma_source {
>  	{ 0 }
>  };
>  
> +static const struct pci_dev_dma_source_funcs {
> +	u16 vendor;
> +	u16 device;
> +	u8 func_map;	/* bit map. lsb is fn 0. */
> +} pci_dev_dma_source_funcs[] = {
> +	 {0x1b4b, 0x9172, (1<<0)|(1<<1)},
May I suggest to apply the attached patch first, and check for
PCI_VENDOR_ID_MARVELL_2 instead?
> +	 { 0 },	
> +};
> +
> +static u8 pci_get_dma_source_map(struct pci_dev *dev)
> +{
> +	const struct pci_dev_dma_source_funcs *i;
> +
> +	for (i = pci_dev_dma_source_funcs; i->func_map; i++) {
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
> +int pci_func_is_dma_source(struct pci_dev *dev, int fn)
> +{
> +	u8 fn_map = pci_get_dma_source_map(dev);
> +
> +	if (fn_map & (1 << fn))
> +		return 1;
> +
> +	return 0;
> +}
> +
>  /*
>   * IOMMUs with isolation capabilities need to be programmed with the
>   * correct source ID of a device.  In most cases, the source ID matches
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index ee21795..8f0fa7f 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1546,6 +1546,7 @@ enum pci_fixup_pass {
>  #ifdef CONFIG_PCI_QUIRKS
>  void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev);
>  struct pci_dev *pci_get_dma_source(struct pci_dev *dev);
> +int pci_func_is_dma_source(struct pci_dev *dev, int fn);
>  int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
>  #else
>  static inline void pci_fixup_device(enum pci_fixup_pass pass,
> 


--------------090109080007000906020602
Content-Type: text/x-patch;
 name="move_pci_vendor_id_marvell_2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="move_pci_vendor_id_marvell_2.patch"

commit 05183aa996b2971884a60041e995b470b8224574
Author: Stijn Tintel <stijn@linux-ipv6.be>
Date:   Sun Feb 10 01:01:16 2013 +0100

    Move PCI_VENDOR_ID_MARVELL_2 to pci_ids.h
    
    Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>

diff --git a/drivers/scsi/mvumi.h b/drivers/scsi/mvumi.h
index e360135..41f1687 100644
--- a/drivers/scsi/mvumi.h
+++ b/drivers/scsi/mvumi.h
@@ -32,7 +32,6 @@
 #define VER_BUILD		1500
 
 #define MV_DRIVER_NAME			"mvumi"
-#define PCI_VENDOR_ID_MARVELL_2		0x1b4b
 #define PCI_DEVICE_ID_MARVELL_MV9143	0x9143
 #define PCI_DEVICE_ID_MARVELL_MV9580	0x9580
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 0eb6579..60c4ff4 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1608,6 +1608,7 @@
 #define PCI_DEVICE_ID_MARVELL_GT64260	0x6430
 #define PCI_DEVICE_ID_MARVELL_MV64360	0x6460
 #define PCI_DEVICE_ID_MARVELL_MV64460	0x6480
+#define PCI_VENDOR_ID_MARVELL_2		0x1b4b
 #define PCI_DEVICE_ID_MARVELL_88ALP01_NAND	0x4100
 #define PCI_DEVICE_ID_MARVELL_88ALP01_SD	0x4101
 #define PCI_DEVICE_ID_MARVELL_88ALP01_CCIC	0x4102

--------------090109080007000906020602--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3IXX6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 19:58:19 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:52844 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab3IXX6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 19:58:16 -0400
Date: Tue, 24 Sep 2013 17:58:12 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Bharat Bhushan <r65777@freescale.com>
Cc: alex.williamson@redhat.com, joro@8bytes.org, benh@kernel.crashing.org,
        galak@kernel.crashing.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-pci@vger.kernel.org,
        agraf@suse.de, scottwood@freescale.com,
        iommu@lists.linux-foundation.org,
        Bharat Bhushan <Bharat.Bhushan@freescale.com>
Subject: Re: [PATCH 1/7] powerpc: Add interface to get msi region information
Message-ID: <20130924235812.GD9302@google.com>
References: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
 <1379575763-2091-2-git-send-email-Bharat.Bhushan@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379575763-2091-2-git-send-email-Bharat.Bhushan@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 12:59:17PM +0530, Bharat Bhushan wrote:
> This patch adds interface to get following information
>   - Number of MSI regions (which is number of MSI banks for powerpc).
>   - Get the region address range: Physical page which have the
>      address/addresses used for generating MSI interrupt
>      and size of the page.
> 
> These are required to create IOMMU (Freescale PAMU) mapping for
> devices which are directly assigned using VFIO.
> 
> Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
> ---
>  arch/powerpc/include/asm/machdep.h |    8 +++++++
>  arch/powerpc/include/asm/pci.h     |    2 +
>  arch/powerpc/kernel/msi.c          |   18 ++++++++++++++++
>  arch/powerpc/sysdev/fsl_msi.c      |   39 +++++++++++++++++++++++++++++++++--
>  arch/powerpc/sysdev/fsl_msi.h      |   11 ++++++++-
>  drivers/pci/msi.c                  |   26 ++++++++++++++++++++++++
>  include/linux/msi.h                |    8 +++++++
>  include/linux/pci.h                |   13 ++++++++++++
>  8 files changed, 120 insertions(+), 5 deletions(-)
> 
> ...

> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index aca7578..6d85c15 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -30,6 +30,20 @@ static int pci_msi_enable = 1;
>  
>  /* Arch hooks */
>  
> +#ifndef arch_msi_get_region_count
> +int arch_msi_get_region_count(void)
> +{
> +	return 0;
> +}
> +#endif
> +
> +#ifndef arch_msi_get_region
> +int arch_msi_get_region(int region_num, struct msi_region *region)
> +{
> +	return 0;
> +}
> +#endif

This #define strategy is gone; see 4287d824 ("PCI: use weak functions for
MSI arch-specific functions").  Please use the weak function strategy
for your new MSI region functions.

> +
>  #ifndef arch_msi_check_device
>  int arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
>  {
> @@ -903,6 +917,18 @@ void pci_disable_msi(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL(pci_disable_msi);
>  
> +int msi_get_region_count(void)
> +{
> +	return arch_msi_get_region_count();
> +}
> +EXPORT_SYMBOL(msi_get_region_count);
> +
> +int msi_get_region(int region_num, struct msi_region *region)
> +{
> +	return arch_msi_get_region(region_num, region);
> +}
> +EXPORT_SYMBOL(msi_get_region);

Please split these interface additions, i.e., the drivers/pci/msi.c,
include/linux/msi.h, and include/linux/pci.h changes, into a separate
patch.

I don't know enough about VFIO to understand why these new interfaces
are needed.  Is this the first VFIO IOMMU driver?  I see
vfio_iommu_spapr_tce.c and vfio_iommu_type1.c but I don't know if
they're comparable to the Freescale PAMU.  Do other VFIO IOMMU
implementations support MSI?  If so, do they handle the problem of
mapping the MSI regions in a different way?

>  /**
>   * pci_msix_table_size - return the number of device's MSI-X table entries
>   * @dev: pointer to the pci_dev data structure of MSI-X device function
> diff --git a/include/linux/msi.h b/include/linux/msi.h
> index ee66f3a..ae32601 100644
> --- a/include/linux/msi.h
> +++ b/include/linux/msi.h
> @@ -50,6 +50,12 @@ struct msi_desc {
>  	struct kobject kobj;
>  };
>  
> +struct msi_region {
> +	int region_num;
> +	dma_addr_t addr;
> +	size_t size;
> +};

This needs some sort of explanatory comment.

>  /*
>   * The arch hook for setup up msi irqs
>   */
> @@ -58,5 +64,7 @@ void arch_teardown_msi_irq(unsigned int irq);
>  int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
>  void arch_teardown_msi_irqs(struct pci_dev *dev);
>  int arch_msi_check_device(struct pci_dev* dev, int nvec, int type);
> +int arch_msi_get_region_count(void);
> +int arch_msi_get_region(int region_num, struct msi_region *region);
>  
>  #endif /* LINUX_MSI_H */
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 186540d..2b26a59 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1126,6 +1126,7 @@ struct msix_entry {
>  	u16	entry;	/* driver uses to specify entry, OS writes */
>  };
>  
> +struct msi_region;
>  
>  #ifndef CONFIG_PCI_MSI
>  static inline int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
> @@ -1168,6 +1169,16 @@ static inline int pci_msi_enabled(void)
>  {
>  	return 0;
>  }
> +
> +static inline int msi_get_region_count(void)
> +{
> +	return 0;
> +}
> +
> +static inline int msi_get_region(int region_num, struct msi_region *region)
> +{
> +	return 0;
> +}
>  #else
>  int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec);
>  int pci_enable_msi_block_auto(struct pci_dev *dev, unsigned int *maxvec);
> @@ -1180,6 +1191,8 @@ void pci_disable_msix(struct pci_dev *dev);
>  void msi_remove_pci_irq_vectors(struct pci_dev *dev);
>  void pci_restore_msi_state(struct pci_dev *dev);
>  int pci_msi_enabled(void);
> +int msi_get_region_count(void);
> +int msi_get_region(int region_num, struct msi_region *region);
>  #endif
>  
>  #ifdef CONFIG_PCIEPORTBUS
> -- 
> 1.7.0.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

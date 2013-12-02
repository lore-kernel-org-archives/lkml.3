Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab3LBVeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:34:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595Ab3LBVd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 16:33:56 -0500
Message-ID: <1386020030.25738.241.camel@ul30vt.home>
Subject: Re: [PATCH 1/3 v2] iommu/fsl: Factor out PCI specific code.
From: Alex Williamson <alex.williamson@redhat.com>
To: Varun Sethi <Varun.Sethi@freescale.com>
Cc: joro@8bytes.org, iommu@lists.linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stuart.yoder@freescale.com, scottwood@freescale.com,
        r65777@freescale.com
Date: Mon, 02 Dec 2013 14:33:50 -0700
In-Reply-To: <1381922582-28724-2-git-send-email-Varun.Sethi@freescale.com>
References: <1381922582-28724-1-git-send-email-Varun.Sethi@freescale.com>
	 <1381922582-28724-2-git-send-email-Varun.Sethi@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-16 at 16:53 +0530, Varun Sethi wrote:
> Factor out PCI specific code in the PAMU driver.
> 
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> ---
>  drivers/iommu/fsl_pamu_domain.c |   88 +++++++++++++++++++--------------------
>  1 file changed, 43 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
> index c857c30..966ae70 100644
> --- a/drivers/iommu/fsl_pamu_domain.c
> +++ b/drivers/iommu/fsl_pamu_domain.c
> @@ -677,21 +677,15 @@ static int handle_attach_device(struct fsl_dma_domain *dma_domain,
>  	return ret;
>  }
>  
> -static int fsl_pamu_attach_device(struct iommu_domain *domain,
> -				  struct device *dev)
> +static struct device *get_dma_device(struct device *dev)
>  {
> -	struct fsl_dma_domain *dma_domain = domain->priv;
> -	const u32 *liodn;
> -	u32 liodn_cnt;
> -	int len, ret = 0;
> -	struct pci_dev *pdev = NULL;
> -	struct pci_controller *pci_ctl;
> +	struct device *dma_dev = dev;
> +#ifdef CONFIG_PCI
>  
> -	/*
> -	 * Use LIODN of the PCI controller while attaching a
> -	 * PCI device.
> -	 */
>  	if (dev->bus == &pci_bus_type) {
> +		struct pci_controller *pci_ctl;
> +		struct pci_dev *pdev;
> +
>  		pdev = to_pci_dev(dev);
>  		pci_ctl = pci_bus_to_host(pdev->bus);
>  		/*
> @@ -699,17 +693,31 @@ static int fsl_pamu_attach_device(struct iommu_domain *domain,
>  		 * so we can get the LIODN programmed by
>  		 * u-boot.
>  		 */
> -		dev = pci_ctl->parent;
> +		dma_dev = pci_ctl->parent;
>  	}
> +#endif
> +	return dma_dev;
> +}
> +
> +static int fsl_pamu_attach_device(struct iommu_domain *domain,
> +				  struct device *dev)
> +{
> +	struct fsl_dma_domain *dma_domain = domain->priv;
> +	struct device *dma_dev;
> +	const u32 *liodn;
> +	u32 liodn_cnt;
> +	int len, ret = 0;
> +
> +	dma_dev = get_dma_device(dev);
>  
> -	liodn = of_get_property(dev->of_node, "fsl,liodn", &len);
> +	liodn = of_get_property(dma_dev->of_node, "fsl,liodn", &len);
>  	if (liodn) {
>  		liodn_cnt = len / sizeof(u32);
>  		ret = handle_attach_device(dma_domain, dev,
>  					 liodn, liodn_cnt);
>  	} else {
>  		pr_debug("missing fsl,liodn property at %s\n",
> -		          dev->of_node->full_name);
> +		          dma_dev->of_node->full_name);
>  			ret = -EINVAL;
>  	}
>  
> @@ -720,32 +728,18 @@ static void fsl_pamu_detach_device(struct iommu_domain *domain,
>  				      struct device *dev)
>  {
>  	struct fsl_dma_domain *dma_domain = domain->priv;
> +	struct device *dma_dev;
>  	const u32 *prop;
>  	int len;
> -	struct pci_dev *pdev = NULL;
> -	struct pci_controller *pci_ctl;
>  
> -	/*
> -	 * Use LIODN of the PCI controller while detaching a
> -	 * PCI device.
> -	 */
> -	if (dev->bus == &pci_bus_type) {
> -		pdev = to_pci_dev(dev);
> -		pci_ctl = pci_bus_to_host(pdev->bus);
> -		/*
> -		 * make dev point to pci controller device
> -		 * so we can get the LIODN programmed by
> -		 * u-boot.
> -		 */
> -		dev = pci_ctl->parent;
> -	}
> +	dma_dev = get_dma_device(dev);
>  
> -	prop = of_get_property(dev->of_node, "fsl,liodn", &len);
> +	prop = of_get_property(dma_dev->of_node, "fsl,liodn", &len);
>  	if (prop)
>  		detach_device(dev, dma_domain);
>  	else
>  		pr_debug("missing fsl,liodn property at %s\n",
> -		          dev->of_node->full_name);
> +		          dma_dev->of_node->full_name);
>  }
>  
>  static  int configure_domain_geometry(struct iommu_domain *domain, void *data)
> @@ -905,6 +899,7 @@ static struct iommu_group *get_device_iommu_group(struct device *dev)
>  	return group;
>  }
>  
> +#ifdef CONFIG_PCI
>  static  bool check_pci_ctl_endpt_part(struct pci_controller *pci_ctl)
>  {
>  	u32 version;
> @@ -945,13 +940,18 @@ static struct iommu_group *get_shared_pci_device_group(struct pci_dev *pdev)
>  	return NULL;
>  }
>  
> -static struct iommu_group *get_pci_device_group(struct pci_dev *pdev)
> +static struct iommu_group *get_pci_device_group(struct device *dev)
>  {
>  	struct pci_controller *pci_ctl;
>  	bool pci_endpt_partioning;
>  	struct iommu_group *group = NULL;
> -	struct pci_dev *bridge, *dma_pdev = NULL;
> +	struct pci_dev *bridge, *pdev;
> +	struct pci_dev *dma_pdev = NULL;
>  
> +	pdev = to_pci_dev(dev);
> +	/* Don't create device groups for virtual PCI bridges */
> +	if (pdev->subordinate)
> +		return NULL;
>  	pci_ctl = pci_bus_to_host(pdev->bus);
>  	pci_endpt_partioning = check_pci_ctl_endpt_part(pci_ctl);
>  	/* We can partition PCIe devices so assign device group to the device */
> @@ -1044,11 +1044,11 @@ root_bus:
>  
>  	return group;
>  }
> +#endif
>  
>  static int fsl_pamu_add_device(struct device *dev)
>  {
>  	struct iommu_group *group = NULL;
> -	struct pci_dev *pdev;
>  	const u32 *prop;
>  	int ret, len;
>  
> @@ -1056,19 +1056,15 @@ static int fsl_pamu_add_device(struct device *dev)
>  	 * For platform devices we allocate a separate group for
>  	 * each of the devices.
>  	 */
> -	if (dev->bus == &pci_bus_type) {
> -		pdev = to_pci_dev(dev);
> -		/* Don't create device groups for virtual PCI bridges */
> -		if (pdev->subordinate)
> -			return 0;
> -
> -		group = get_pci_device_group(pdev);
> -
> -	} else {
> +	if (dev->bus == &platform_bus_type) {
>  		prop = of_get_property(dev->of_node, "fsl,liodn", &len);
>  		if (prop)
>  			group = get_device_iommu_group(dev);
>  	}
> +#ifdef CONFIG_PCI
> +	else
> +		group = get_pci_device_group(dev);
> +#endif
>  
>  	if (!group || IS_ERR(group))
>  		return PTR_ERR(group);

It feels like there's a bug here that group is initialized to NULL and
there are a few ways for it to remain NULL through the above code, then
we get here and return PTR_ERR(NULL), which is indistinguishable from a
successful return below.  Perhaps !group is ok, but if so I'd suggest a
separate return block for it.  Thanks,

Alex

> @@ -1166,7 +1162,9 @@ int pamu_domain_init()
>  		return ret;
>  
>  	bus_set_iommu(&platform_bus_type, &fsl_pamu_ops);
> +#ifdef CONFIG_PCI
>  	bus_set_iommu(&pci_bus_type, &fsl_pamu_ops);
> +#endif
>  
>  	return ret;
>  }




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab3JLHUR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 03:20:17 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:19538 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752609Ab3JLHUP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 03:20:15 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: "joro@8bytes.org" <joro@8bytes.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
Subject: RE: [PATCH 1/2] iommu/fsl: Factor out PCI specific code.
Thread-Topic: [PATCH 1/2] iommu/fsl: Factor out PCI specific code.
Thread-Index: AQHOxR7l1sARH9xatkqNHFH6zdCYSZnwrD0Q
Date: Sat, 12 Oct 2013 07:20:12 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D0A53259E@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1381343194-24059-1-git-send-email-Varun.Sethi@freescale.com>
In-Reply-To: <1381343194-24059-1-git-send-email-Varun.Sethi@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.64.58.89]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,
Please consider these patches for 3.12.

Regards
Varun

> -----Original Message-----
> From: Sethi Varun-B16395
> Sent: Wednesday, October 09, 2013 11:57 PM
> To: joro@8bytes.org; iommu@lists.linux-foundation.org; linuxppc-
> dev@lists.ozabs.org; linux-kernel@vger.kernel.org; Yoder Stuart-B08248;
> alex.williamson@redhat.com
> Cc: Sethi Varun-B16395
> Subject: [PATCH 1/2] iommu/fsl: Factor out PCI specific code.
> 
> Factor out PCI specific code in the PAMU driver.
> 
> Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> ---
>  drivers/iommu/fsl_pamu_domain.c |   81 +++++++++++++++++++--------------
> ------
>  1 file changed, 40 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/iommu/fsl_pamu_domain.c
> b/drivers/iommu/fsl_pamu_domain.c index c857c30..e02e1de 100644
> --- a/drivers/iommu/fsl_pamu_domain.c
> +++ b/drivers/iommu/fsl_pamu_domain.c
> @@ -677,13 +677,9 @@ static int handle_attach_device(struct
> fsl_dma_domain *dma_domain,
>  	return ret;
>  }
> 
> -static int fsl_pamu_attach_device(struct iommu_domain *domain,
> -				  struct device *dev)
> +static void check_for_pci_dma_device(struct device **dev)
>  {
> -	struct fsl_dma_domain *dma_domain = domain->priv;
> -	const u32 *liodn;
> -	u32 liodn_cnt;
> -	int len, ret = 0;
> +#ifdef CONFIG_PCI
>  	struct pci_dev *pdev = NULL;
>  	struct pci_controller *pci_ctl;
> 
> @@ -691,25 +687,38 @@ static int fsl_pamu_attach_device(struct
> iommu_domain *domain,
>  	 * Use LIODN of the PCI controller while attaching a
>  	 * PCI device.
>  	 */
> -	if (dev->bus == &pci_bus_type) {
> -		pdev = to_pci_dev(dev);
> +	if ((*dev)->bus == &pci_bus_type) {
> +		pdev = to_pci_dev(*dev);
>  		pci_ctl = pci_bus_to_host(pdev->bus);
>  		/*
>  		 * make dev point to pci controller device
>  		 * so we can get the LIODN programmed by
>  		 * u-boot.
>  		 */
> -		dev = pci_ctl->parent;
> +		*dev = pci_ctl->parent;
>  	}
> +#endif
> +}
> 
> -	liodn = of_get_property(dev->of_node, "fsl,liodn", &len);
> +static int fsl_pamu_attach_device(struct iommu_domain *domain,
> +				  struct device *dev)
> +{
> +	struct fsl_dma_domain *dma_domain = domain->priv;
> +	struct device *dma_dev = dev;
> +	const u32 *liodn;
> +	u32 liodn_cnt;
> +	int len, ret = 0;
> +
> +	check_for_pci_dma_device(&dma_dev);
> +
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
> @@ -720,32 +729,18 @@ static void fsl_pamu_detach_device(struct
> iommu_domain *domain,
>  				      struct device *dev)
>  {
>  	struct fsl_dma_domain *dma_domain = domain->priv;
> +	struct device *dma_dev = dev;
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
> +	check_for_pci_dma_device(&dma_dev);
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
>  static  int configure_domain_geometry(struct iommu_domain *domain, void
> *data) @@ -905,6 +900,7 @@ static struct iommu_group
> *get_device_iommu_group(struct device *dev)
>  	return group;
>  }
> 
> +#ifdef CONFIG_PCI
>  static  bool check_pci_ctl_endpt_part(struct pci_controller *pci_ctl)  {
>  	u32 version;
> @@ -945,13 +941,18 @@ static struct iommu_group
> *get_shared_pci_device_group(struct pci_dev *pdev)
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
>  	/* We can partition PCIe devices so assign device group to the
> device */ @@ -1044,11 +1045,11 @@ root_bus:
> 
>  	return group;
>  }
> +#endif
> 
>  static int fsl_pamu_add_device(struct device *dev)  {
>  	struct iommu_group *group = NULL;
> -	struct pci_dev *pdev;
>  	const u32 *prop;
>  	int ret, len;
> 
> @@ -1056,19 +1057,15 @@ static int fsl_pamu_add_device(struct device
> *dev)
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
> @@ -1166,7 +1163,9 @@ int pamu_domain_init()
>  		return ret;
> 
>  	bus_set_iommu(&platform_bus_type, &fsl_pamu_ops);
> +#ifdef CONFIG_PCI
>  	bus_set_iommu(&pci_bus_type, &fsl_pamu_ops);
> +#endif
> 
>  	return ret;
>  }
> --
> 1.7.9.5



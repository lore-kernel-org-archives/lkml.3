Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab3LNE5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 23:57:32 -0500
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:14497
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753403Ab3LNE5b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 23:57:31 -0500
From: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alex Graf <agraf@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v11] PPC: POWERNV: move iommu_add_device earlier
Thread-Topic: [PATCH v11] PPC: POWERNV: move iommu_add_device earlier
Thread-Index: AQHO9w9/BKPewUnplEyTAbOdqbYlTZpTI4bw
Date: Sat, 14 Dec 2013 04:57:27 +0000
Message-ID: <a15376ecd176446f80940104b8a1aa86@BN1PR03MB266.namprd03.prod.outlook.com>
References: <1386834869-15561-1-git-send-email-aik@ozlabs.ru>
In-Reply-To: <1386834869-15561-1-git-send-email-aik@ozlabs.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [122.176.170.137]
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(199002)(377454003)(57704003)(51704005)(13464003)(189002)(74706001)(81342001)(74316001)(80022001)(66066001)(65816001)(74366001)(56816005)(85306002)(90146001)(81542001)(77982001)(79102001)(50986001)(47736001)(59766001)(49866001)(47976001)(4396001)(76482001)(51856001)(53806001)(81816001)(46102001)(54316002)(81686001)(54356001)(69226001)(15975445006)(56776001)(80976001)(74876001)(63696002)(47446002)(83072002)(31966008)(87936001)(74662001)(74502001)(83322001)(19580405001)(2656002)(19580395003)(76786001)(4477795002)(85852003)(33646001)(77096001)(76576001)(76796001)(87266001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB268;H:BN1PR03MB266.namprd03.prod.outlook.com;CLIP:122.176.170.137;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Alexey Kardashevskiy [mailto:aik@ozlabs.ru]
> Sent: Thursday, December 12, 2013 1:24 PM
> To: linuxppc-dev@lists.ozlabs.org
> Cc: Alexey Kardashevskiy; Benjamin Herrenschmidt; Bhushan Bharat-R65777; Alex
> Graf; linux-kernel@vger.kernel.org
> Subject: [PATCH v11] PPC: POWERNV: move iommu_add_device earlier
> 
> The current implementation of IOMMU on sPAPR does not use iommu_ops
> and therefore does not call IOMMU API's bus_set_iommu() which
> 1) sets iommu_ops for a bus
> 2) registers a bus notifier
> Instead, PCI devices are added to IOMMU groups from
> subsys_initcall_sync(tce_iommu_init) which does basically the same
> thing without using iommu_ops callbacks.
> 
> However Freescale PAMU driver (https://lkml.org/lkml/2013/7/1/158)
> implements iommu_ops and when tce_iommu_init is called, every PCI device
> is already added to some group so there is a conflict.
> 
> This patch does 2 things:
> 1. removes the loop in which PCI devices were added to groups and
> adds explicit iommu_add_device() calls to add devices as soon as they get
> the iommu_table pointer assigned to them.
> 2. moves a bus notifier to powernv code in order to avoid conflict with
> the notifier from Freescale driver.
> 
> iommu_add_device() and iommu_del_device() are public now.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
> Changes:
> v11:
> * rebased on upstream
> 
> v10:
> * fixed linker error when IOMMU_API is not enabled
> 
> v9:
> * removed "KVM" from the subject as it is not really a KVM patch so
> PPC mainainter (hi Ben!) can review/include it into his tree
> 
> v8:
> * added the check for iommu_group!=NULL before removing device from a group
> as suggested by Wei Yang <weiyang@linux.vnet.ibm.com>
> 
> v2:
> * added a helper - set_iommu_table_base_and_group - which does
> set_iommu_table_base() and iommu_add_device()
> ---
>  arch/powerpc/include/asm/iommu.h            | 26 ++++++++++++++++++++++++
>  arch/powerpc/kernel/iommu.c                 | 11 ++++------
>  arch/powerpc/platforms/powernv/pci-ioda.c   |  8 ++++----
>  arch/powerpc/platforms/powernv/pci-p5ioc2.c |  2 +-
>  arch/powerpc/platforms/powernv/pci.c        | 31 ++++++++++++++++++++++++++++-
>  arch/powerpc/platforms/pseries/iommu.c      |  8 +++++---
>  6 files changed, 70 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
> index c34656a..774fa27 100644
> --- a/arch/powerpc/include/asm/iommu.h
> +++ b/arch/powerpc/include/asm/iommu.h
> @@ -101,8 +101,34 @@ extern void iommu_free_table(struct iommu_table *tbl, const
> char *node_name);
>   */
>  extern struct iommu_table *iommu_init_table(struct iommu_table * tbl,
>  					    int nid);
> +#ifdef CONFIG_IOMMU_API
>  extern void iommu_register_group(struct iommu_table *tbl,
>  				 int pci_domain_number, unsigned long pe_num);
> +extern int iommu_add_device(struct device *dev);
> +extern void iommu_del_device(struct device *dev);
> +#else
> +static inline void iommu_register_group(struct iommu_table *tbl,
> +					int pci_domain_number,
> +					unsigned long pe_num)
> +{
> +}
> +
> +static inline int iommu_add_device(struct device *dev)
> +{
> +	return 0;
> +}
> +
> +static inline void iommu_del_device(struct device *dev)
> +{
> +}
> +#endif /* !CONFIG_IOMMU_API */
> +
> +static inline void set_iommu_table_base_and_group(struct device *dev,
> +						  void *base)
> +{
> +	set_iommu_table_base(dev, base);
> +	iommu_add_device(dev);
> +}
> 
>  extern int iommu_map_sg(struct device *dev, struct iommu_table *tbl,
>  			struct scatterlist *sglist, int nelems,
> diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
> index 572bb5b..818a092 100644
> --- a/arch/powerpc/kernel/iommu.c
> +++ b/arch/powerpc/kernel/iommu.c
> @@ -1105,7 +1105,7 @@ void iommu_release_ownership(struct iommu_table *tbl)
>  }
>  EXPORT_SYMBOL_GPL(iommu_release_ownership);
> 
> -static int iommu_add_device(struct device *dev)
> +int iommu_add_device(struct device *dev)
>  {
>  	struct iommu_table *tbl;
>  	int ret = 0;
> @@ -1134,11 +1134,13 @@ static int iommu_add_device(struct device *dev)
> 
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(iommu_add_device);
> 
> -static void iommu_del_device(struct device *dev)
> +void iommu_del_device(struct device *dev)
>  {
>  	iommu_group_remove_device(dev);
>  }
> +EXPORT_SYMBOL_GPL(iommu_del_device);
> 
>  static int iommu_bus_notifier(struct notifier_block *nb,
>  			      unsigned long action, void *data)
> @@ -1162,13 +1164,8 @@ static struct notifier_block tce_iommu_bus_nb = {
> 
>  static int __init tce_iommu_init(void)
>  {
> -	struct pci_dev *pdev = NULL;
> -
>  	BUILD_BUG_ON(PAGE_SIZE < IOMMU_PAGE_SIZE);
> 
> -	for_each_pci_dev(pdev)
> -		iommu_add_device(&pdev->dev);
> -
>  	bus_register_notifier(&pci_bus_type, &tce_iommu_bus_nb);
>  	return 0;
>  }

Do we need this bus notifier? We are doing a bus notifier later  .... 


> diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c
> b/arch/powerpc/platforms/powernv/pci-ioda.c
> index 2c6d173..f0e6871 100644
> --- a/arch/powerpc/platforms/powernv/pci-ioda.c
> +++ b/arch/powerpc/platforms/powernv/pci-ioda.c
> @@ -460,7 +460,7 @@ static void pnv_pci_ioda_dma_dev_setup(struct pnv_phb *phb,
> struct pci_dev *pdev
>  		return;
> 
>  	pe = &phb->ioda.pe_array[pdn->pe_number];
> -	set_iommu_table_base(&pdev->dev, &pe->tce32_table);
> +	set_iommu_table_base_and_group(&pdev->dev, &pe->tce32_table);
>  }
> 
>  static void pnv_ioda_setup_bus_dma(struct pnv_ioda_pe *pe, struct pci_bus *bus)
> @@ -468,7 +468,7 @@ static void pnv_ioda_setup_bus_dma(struct pnv_ioda_pe *pe,
> struct pci_bus *bus)
>  	struct pci_dev *dev;
> 
>  	list_for_each_entry(dev, &bus->devices, bus_list) {
> -		set_iommu_table_base(&dev->dev, &pe->tce32_table);
> +		set_iommu_table_base_and_group(&dev->dev, &pe->tce32_table);
>  		if (dev->subordinate)
>  			pnv_ioda_setup_bus_dma(pe, dev->subordinate);
>  	}
> @@ -644,7 +644,7 @@ static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
>  	iommu_register_group(tbl, pci_domain_nr(pe->pbus), pe->pe_number);
> 
>  	if (pe->pdev)
> -		set_iommu_table_base(&pe->pdev->dev, tbl);
> +		set_iommu_table_base_and_group(&pe->pdev->dev, tbl);
>  	else
>  		pnv_ioda_setup_bus_dma(pe, pe->pbus);
> 
> @@ -723,7 +723,7 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
>  	iommu_register_group(tbl, pci_domain_nr(pe->pbus), pe->pe_number);
> 
>  	if (pe->pdev)
> -		set_iommu_table_base(&pe->pdev->dev, tbl);
> +		set_iommu_table_base_and_group(&pe->pdev->dev, tbl);
>  	else
>  		pnv_ioda_setup_bus_dma(pe, pe->pbus);
> 
> diff --git a/arch/powerpc/platforms/powernv/pci-p5ioc2.c
> b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
> index f8b4bd8..e3807d6 100644
> --- a/arch/powerpc/platforms/powernv/pci-p5ioc2.c
> +++ b/arch/powerpc/platforms/powernv/pci-p5ioc2.c
> @@ -92,7 +92,7 @@ static void pnv_pci_p5ioc2_dma_dev_setup(struct pnv_phb *phb,
>  				pci_domain_nr(phb->hose->bus), phb->opal_id);
>  	}
> 
> -	set_iommu_table_base(&pdev->dev, &phb->p5ioc2.iommu_table);
> +	set_iommu_table_base_and_group(&pdev->dev, &phb->p5ioc2.iommu_table);
>  }
> 
>  static void __init pnv_pci_init_p5ioc2_phb(struct device_node *np, u64 hub_id,
> diff --git a/arch/powerpc/platforms/powernv/pci.c
> b/arch/powerpc/platforms/powernv/pci.c
> index 4eb33a9..a78abad 100644
> --- a/arch/powerpc/platforms/powernv/pci.c
> +++ b/arch/powerpc/platforms/powernv/pci.c
> @@ -536,7 +536,7 @@ static void pnv_pci_dma_fallback_setup(struct pci_controller
> *hose,
>  		pdn->iommu_table = pnv_pci_setup_bml_iommu(hose);
>  	if (!pdn->iommu_table)
>  		return;
> -	set_iommu_table_base(&pdev->dev, pdn->iommu_table);
> +	set_iommu_table_base_and_group(&pdev->dev, pdn->iommu_table);
>  }
> 
>  static void pnv_pci_dma_dev_setup(struct pci_dev *pdev)
> @@ -657,3 +657,32 @@ void __init pnv_pci_init(void)
>  	ppc_md.teardown_msi_irqs = pnv_teardown_msi_irqs;
>  #endif
>  }
> +
> +static int tce_iommu_bus_notifier(struct notifier_block *nb,
> +		unsigned long action, void *data)
> +{
> +	struct device *dev = data;
> +
> +	switch (action) {
> +	case BUS_NOTIFY_ADD_DEVICE:
> +		return iommu_add_device(dev);
> +	case BUS_NOTIFY_DEL_DEVICE:
> +		if (dev->iommu_group)
> +			iommu_del_device(dev);
> +		return 0;
> +	default:
> +		return 0;
> +	}
> +}
> +
> +static struct notifier_block tce_iommu_bus_nb = {
> +	.notifier_call = tce_iommu_bus_notifier,
> +};
> +
> +static int __init tce_iommu_bus_notifier_init(void)
> +{
> +	bus_register_notifier(&pci_bus_type, &tce_iommu_bus_nb);

Here  it is, setting up the bus notifier.

Thanks
-Bharat

> +	return 0;
> +}
> +
> +subsys_initcall_sync(tce_iommu_bus_notifier_init);
> diff --git a/arch/powerpc/platforms/pseries/iommu.c
> b/arch/powerpc/platforms/pseries/iommu.c
> index f253361..a80af6c 100644
> --- a/arch/powerpc/platforms/pseries/iommu.c
> +++ b/arch/powerpc/platforms/pseries/iommu.c
> @@ -687,7 +687,8 @@ static void pci_dma_dev_setup_pSeries(struct pci_dev *dev)
>  		iommu_table_setparms(phb, dn, tbl);
>  		PCI_DN(dn)->iommu_table = iommu_init_table(tbl, phb->node);
>  		iommu_register_group(tbl, pci_domain_nr(phb->bus), 0);
> -		set_iommu_table_base(&dev->dev, PCI_DN(dn)->iommu_table);
> +		set_iommu_table_base_and_group(&dev->dev,
> +					       PCI_DN(dn)->iommu_table);
>  		return;
>  	}
> 
> @@ -699,7 +700,8 @@ static void pci_dma_dev_setup_pSeries(struct pci_dev *dev)
>  		dn = dn->parent;
> 
>  	if (dn && PCI_DN(dn))
> -		set_iommu_table_base(&dev->dev, PCI_DN(dn)->iommu_table);
> +		set_iommu_table_base_and_group(&dev->dev,
> +					       PCI_DN(dn)->iommu_table);
>  	else
>  		printk(KERN_WARNING "iommu: Device %s has no iommu table\n",
>  		       pci_name(dev));
> @@ -1193,7 +1195,7 @@ static void pci_dma_dev_setup_pSeriesLP(struct pci_dev
> *dev)
>  		pr_debug("  found DMA window, table: %p\n", pci->iommu_table);
>  	}
> 
> -	set_iommu_table_base(&dev->dev, pci->iommu_table);
> +	set_iommu_table_base_and_group(&dev->dev, pci->iommu_table);
>  }
> 
>  static int dma_set_mask_pSeriesLP(struct device *dev, u64 dma_mask)
> --
> 1.8.4.rc4
> 
> 


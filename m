Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab3LOSWI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 13:22:08 -0500
Received: from mail-bn1lp0149.outbound.protection.outlook.com ([207.46.163.149]:35530
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab3LOSWG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 13:22:06 -0500
From: Varun Sethi <Varun.Sethi@freescale.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
CC: Alex Graf <agraf@suse.de>,
        "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v11] PPC: POWERNV: move iommu_add_device earlier
Thread-Topic: [PATCH v11] PPC: POWERNV: move iommu_add_device earlier
Thread-Index: AQHO9w+DyokYTShU2Em+RBhtU7VA0JpVlDiQ
Date: Sun, 15 Dec 2013 18:22:01 +0000
Message-ID: <647633474c0b4bf5ad00f42fea7e3f15@BL2PR03MB468.namprd03.prod.outlook.com>
References: <1386834869-15561-1-git-send-email-aik@ozlabs.ru>
In-Reply-To: <1386834869-15561-1-git-send-email-aik@ozlabs.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [122.161.134.226]
x-forefront-prvs: 0061C35778
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(377454003)(199002)(189002)(13464003)(51704005)(81342001)(83072002)(87936001)(74502001)(76576001)(76796001)(76786001)(74706001)(46102001)(85852003)(65816001)(69226001)(87266001)(90146001)(56816005)(47446002)(79102001)(63696002)(66066001)(76482001)(56776001)(81542001)(53806001)(54316002)(77982001)(59766001)(74876001)(51856001)(80976001)(2656002)(74366001)(31966008)(74316001)(83322001)(19580405001)(19580395003)(4477795002)(54356001)(80022001)(81686001)(74662001)(33646001)(81816001)(4396001)(15975445006)(47976001)(50986001)(85306002)(49866001)(47736001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB258;H:BL2PR03MB468.namprd03.prod.outlook.com;CLIP:122.161.134.226;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Linuxppc-dev [mailto:linuxppc-dev-
> bounces+varun.sethi=freescale.com@lists.ozlabs.org] On Behalf Of Alexey
> Kardashevskiy
> Sent: Thursday, December 12, 2013 1:24 PM
> To: linuxppc-dev@lists.ozlabs.org
> Cc: Alexey Kardashevskiy; Alex Graf; Bhushan Bharat-R65777; linux-
> kernel@vger.kernel.org
> Subject: [PATCH v11] PPC: POWERNV: move iommu_add_device earlier
> 
> The current implementation of IOMMU on sPAPR does not use iommu_ops and
> therefore does not call IOMMU API's bus_set_iommu() which
> 1) sets iommu_ops for a bus
> 2) registers a bus notifier
> Instead, PCI devices are added to IOMMU groups from
> subsys_initcall_sync(tce_iommu_init) which does basically the same thing
> without using iommu_ops callbacks.
> 
> However Freescale PAMU driver (https://lkml.org/lkml/2013/7/1/158)
> implements iommu_ops and when tce_iommu_init is called, every PCI device
> is already added to some group so there is a conflict.
> 
> This patch does 2 things:
> 1. removes the loop in which PCI devices were added to groups and adds
> explicit iommu_add_device() calls to add devices as soon as they get the
> iommu_table pointer assigned to them.
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
> * removed "KVM" from the subject as it is not really a KVM patch so PPC
> mainainter (hi Ben!) can review/include it into his tree
> 
> v8:
> * added the check for iommu_group!=NULL before removing device from a
> group as suggested by Wei Yang <weiyang@linux.vnet.ibm.com>
> 
> v2:
> * added a helper - set_iommu_table_base_and_group - which does
> set_iommu_table_base() and iommu_add_device()
> ---
>  arch/powerpc/include/asm/iommu.h            | 26
> ++++++++++++++++++++++++
>  arch/powerpc/kernel/iommu.c                 | 11 ++++------
>  arch/powerpc/platforms/powernv/pci-ioda.c   |  8 ++++----
>  arch/powerpc/platforms/powernv/pci-p5ioc2.c |  2 +-
>  arch/powerpc/platforms/powernv/pci.c        | 31
> ++++++++++++++++++++++++++++-
>  arch/powerpc/platforms/pseries/iommu.c      |  8 +++++---
>  6 files changed, 70 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/iommu.h
> b/arch/powerpc/include/asm/iommu.h
> index c34656a..774fa27 100644
> --- a/arch/powerpc/include/asm/iommu.h
> +++ b/arch/powerpc/include/asm/iommu.h
> @@ -101,8 +101,34 @@ extern void iommu_free_table(struct iommu_table
> *tbl, const char *node_name);
>   */
>  extern struct iommu_table *iommu_init_table(struct iommu_table * tbl,
>  					    int nid);
> +#ifdef CONFIG_IOMMU_API
>  extern void iommu_register_group(struct iommu_table *tbl,
>  				 int pci_domain_number, unsigned long pe_num);
> +extern int iommu_add_device(struct device *dev); extern void
> +iommu_del_device(struct device *dev); #else static inline void
> +iommu_register_group(struct iommu_table *tbl,
> +					int pci_domain_number,
> +					unsigned long pe_num)
> +{
> +}
> +
> +static inline int iommu_add_device(struct device *dev) {
> +	return 0;
> +}
> +
> +static inline void iommu_del_device(struct device *dev) { } #endif /*
> +!CONFIG_IOMMU_API */
> +
> +static inline void set_iommu_table_base_and_group(struct device *dev,
> +						  void *base)
> +{
> +	set_iommu_table_base(dev, base);
> +	iommu_add_device(dev);
> +}
> 
>  extern int iommu_map_sg(struct device *dev, struct iommu_table *tbl,
>  			struct scatterlist *sglist, int nelems, diff --git
> a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c index
> 572bb5b..818a092 100644
> --- a/arch/powerpc/kernel/iommu.c
> +++ b/arch/powerpc/kernel/iommu.c
> @@ -1105,7 +1105,7 @@ void iommu_release_ownership(struct iommu_table
> *tbl)  }  EXPORT_SYMBOL_GPL(iommu_release_ownership);
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
>  			      unsigned long action, void *data) @@ -1162,13
> +1164,8 @@ static struct notifier_block tce_iommu_bus_nb = {
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
> diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c
> b/arch/powerpc/platforms/powernv/pci-ioda.c
> index 2c6d173..f0e6871 100644
> --- a/arch/powerpc/platforms/powernv/pci-ioda.c
> +++ b/arch/powerpc/platforms/powernv/pci-ioda.c
> @@ -460,7 +460,7 @@ static void pnv_pci_ioda_dma_dev_setup(struct pnv_phb
> *phb, struct pci_dev *pdev
>  		return;
> 
>  	pe = &phb->ioda.pe_array[pdn->pe_number];
> -	set_iommu_table_base(&pdev->dev, &pe->tce32_table);
> +	set_iommu_table_base_and_group(&pdev->dev, &pe->tce32_table);
>  }
> 
>  static void pnv_ioda_setup_bus_dma(struct pnv_ioda_pe *pe, struct
> pci_bus *bus) @@ -468,7 +468,7 @@ static void
> pnv_ioda_setup_bus_dma(struct pnv_ioda_pe *pe, struct pci_bus *bus)
>  	struct pci_dev *dev;
> 
>  	list_for_each_entry(dev, &bus->devices, bus_list) {
> -		set_iommu_table_base(&dev->dev, &pe->tce32_table);
> +		set_iommu_table_base_and_group(&dev->dev, &pe->tce32_table);
>  		if (dev->subordinate)
>  			pnv_ioda_setup_bus_dma(pe, dev->subordinate);
>  	}
> @@ -644,7 +644,7 @@ static void pnv_pci_ioda_setup_dma_pe(struct pnv_phb
> *phb,
>  	iommu_register_group(tbl, pci_domain_nr(pe->pbus), pe->pe_number);
> 
>  	if (pe->pdev)
> -		set_iommu_table_base(&pe->pdev->dev, tbl);
> +		set_iommu_table_base_and_group(&pe->pdev->dev, tbl);
>  	else
>  		pnv_ioda_setup_bus_dma(pe, pe->pbus);
> 
> @@ -723,7 +723,7 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb
> *phb,
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
> @@ -92,7 +92,7 @@ static void pnv_pci_p5ioc2_dma_dev_setup(struct pnv_phb
> *phb,
>  				pci_domain_nr(phb->hose->bus), phb->opal_id);
>  	}
> 
> -	set_iommu_table_base(&pdev->dev, &phb->p5ioc2.iommu_table);
> +	set_iommu_table_base_and_group(&pdev->dev, &phb-
> >p5ioc2.iommu_table);
>  }
> 
>  static void __init pnv_pci_init_p5ioc2_phb(struct device_node *np, u64
> hub_id, diff --git a/arch/powerpc/platforms/powernv/pci.c
> b/arch/powerpc/platforms/powernv/pci.c
> index 4eb33a9..a78abad 100644
> --- a/arch/powerpc/platforms/powernv/pci.c
> +++ b/arch/powerpc/platforms/powernv/pci.c
> @@ -536,7 +536,7 @@ static void pnv_pci_dma_fallback_setup(struct
> pci_controller *hose,
>  		pdn->iommu_table = pnv_pci_setup_bml_iommu(hose);
>  	if (!pdn->iommu_table)
>  		return;
> -	set_iommu_table_base(&pdev->dev, pdn->iommu_table);
> +	set_iommu_table_base_and_group(&pdev->dev, pdn->iommu_table);
>  }
> 
The iommu add device 

>  static void pnv_pci_dma_dev_setup(struct pci_dev *pdev) @@ -657,3
> +657,32 @@ void __init pnv_pci_init(void)
>  	ppc_md.teardown_msi_irqs = pnv_teardown_msi_irqs;  #endif  }
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
> +	.notifier_call = tce_iommu_bus_notifier, };
> +
> +static int __init tce_iommu_bus_notifier_init(void) {
> +	bus_register_notifier(&pci_bus_type, &tce_iommu_bus_nb);
> +	return 0;
> +}
> +
> +subsys_initcall_sync(tce_iommu_bus_notifier_init);
Why are bus notifiers required in your case, if you are creating iommu groups based on iommu tables? Also, how would you avoid conflict with PAMU iommu group creation code if you use bus notifiers?

-Varun

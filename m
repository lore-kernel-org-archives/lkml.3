Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbaE3JRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 05:17:15 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:45104
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753504AbaE3JRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 05:17:12 -0400
From: Varun Sethi <Varun.Sethi@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "acooks@gmail.com" <acooks@gmail.com>,
        "linux@horizon.com" <linux@horizon.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "eddy0596@gmail.com" <eddy0596@gmail.com>
Subject: RE: [PATCH v4 13/16] iommu/fsl: Use iommu_group_get_for_dev() for
 IOMMU groups
Thread-Topic: [PATCH v4 13/16] iommu/fsl: Use iommu_group_get_for_dev() for
 IOMMU groups
Thread-Index: AQHPdhLKbrGLndB8FEaNPuniipoNSptY42sw
Date: Fri, 30 May 2014 09:17:07 +0000
Message-ID: <878ea3496f194c6ab6198bdc3e0a413c@BL2PR03MB468.namprd03.prod.outlook.com>
References: <20140522230230.2856.40017.stgit@bling.home>
 <20140522230845.2856.95844.stgit@bling.home>
In-Reply-To: <20140522230845.2856.95844.stgit@bling.home>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(51704005)(377454003)(13464003)(199002)(189002)(74316001)(2201001)(81342001)(86362001)(46102001)(76176999)(92566001)(21056001)(79102001)(20776003)(76482001)(80022001)(77982001)(33646001)(99396002)(81542001)(54356999)(2656002)(87936001)(76576001)(66066001)(64706001)(74502001)(50986999)(83322001)(77096999)(85852003)(99286001)(31966008)(19580395003)(19580405001)(74662001)(101416001)(4396001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB468;H:BL2PR03MB468.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Varun.Sethi@freescale.com; 
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4U9HQ9W015363



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Friday, May 23, 2014 4:39 AM
> To: linux-pci@vger.kernel.org; iommu@lists.linux-foundation.org
> Cc: linux-kernel@vger.kernel.org; acooks@gmail.com; linux@horizon.com;
> bhelgaas@google.com; Sethi Varun-B16395; eddy0596@gmail.com
> Subject: [PATCH v4 13/16] iommu/fsl: Use iommu_group_get_for_dev() for
> IOMMU groups
> 
> Drop custom code and use IOMMU provided grouping support for PCI.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Cc: Varun Sethi <varun.sethi@freescale.com>
> ---
>  drivers/iommu/fsl_pamu_domain.c |   66 +--------------------------------
> ------
>  1 file changed, 1 insertion(+), 65 deletions(-)
> 
> diff --git a/drivers/iommu/fsl_pamu_domain.c
> b/drivers/iommu/fsl_pamu_domain.c index 93072ba..d02d668 100644
> --- a/drivers/iommu/fsl_pamu_domain.c
> +++ b/drivers/iommu/fsl_pamu_domain.c
> @@ -38,7 +38,6 @@
>  #include <sysdev/fsl_pci.h>
> 
>  #include "fsl_pamu_domain.h"
> -#include "pci.h"
> 
>  /*
>   * Global spinlock that needs to be held while @@ -892,8 +891,6 @@
> static int fsl_pamu_get_domain_attr(struct iommu_domain *domain,
>  	return ret;
>  }
> 
> -#define REQ_ACS_FLAGS	(PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR |
> PCI_ACS_UF)
> -
>  static struct iommu_group *get_device_iommu_group(struct device *dev)  {
>  	struct iommu_group *group;
> @@ -950,74 +947,13 @@ static struct iommu_group
> *get_pci_device_group(struct pci_dev *pdev)
>  	struct pci_controller *pci_ctl;
>  	bool pci_endpt_partioning;
>  	struct iommu_group *group = NULL;
> -	struct pci_dev *bridge, *dma_pdev = NULL;
> 
>  	pci_ctl = pci_bus_to_host(pdev->bus);
>  	pci_endpt_partioning = check_pci_ctl_endpt_part(pci_ctl);
>  	/* We can partition PCIe devices so assign device group to the
> device */
>  	if (pci_endpt_partioning) {
> -		bridge = pci_find_upstream_pcie_bridge(pdev);
> -		if (bridge) {
> -			if (pci_is_pcie(bridge))
> -				dma_pdev = pci_get_domain_bus_and_slot(
> -						pci_domain_nr(pdev->bus),
> -						bridge->subordinate->number, 0);
> -			if (!dma_pdev)
> -				dma_pdev = pci_dev_get(bridge);
> -		} else
> -			dma_pdev = pci_dev_get(pdev);
> -
> -		/* Account for quirked devices */
> -		swap_pci_ref(&dma_pdev, pci_get_dma_source(dma_pdev));
> -
> -		/*
> -		 * If it's a multifunction device that does not support our
> -		 * required ACS flags, add to the same group as lowest
> numbered
> -		 * function that also does not suport the required ACS flags.
> -		 */
> -		if (dma_pdev->multifunction &&
> -		    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS)) {
> -			u8 i, slot = PCI_SLOT(dma_pdev->devfn);
> -
> -			for (i = 0; i < 8; i++) {
> -				struct pci_dev *tmp;
> -
> -				tmp = pci_get_slot(dma_pdev->bus, PCI_DEVFN(slot,
> i));
> -				if (!tmp)
> -					continue;
> -
> -				if (!pci_acs_enabled(tmp, REQ_ACS_FLAGS)) {
> -					swap_pci_ref(&dma_pdev, tmp);
> -					break;
> -				}
> -				pci_dev_put(tmp);
> -			}
> -		}
> -
> -		/*
> -		 * Devices on the root bus go through the iommu.  If that's
> not us,
> -		 * find the next upstream device and test ACS up to the root
> bus.
> -		 * Finding the next device may require skipping virtual
> buses.
> -		 */
> -		while (!pci_is_root_bus(dma_pdev->bus)) {
> -			struct pci_bus *bus = dma_pdev->bus;
> -
> -			while (!bus->self) {
> -				if (!pci_is_root_bus(bus))
> -					bus = bus->parent;
> -				else
> -					goto root_bus;
> -			}
> -
> -			if (pci_acs_path_enabled(bus->self, NULL,
> REQ_ACS_FLAGS))
> -				break;
> -
> -			swap_pci_ref(&dma_pdev, pci_dev_get(bus->self));
> -		}
> +		group = iommu_group_get_for_dev(&pdev->dev);
> 
> -root_bus:
> -		group = get_device_iommu_group(&dma_pdev->dev);
> -		pci_dev_put(dma_pdev);
>  		/*
>  		 * PCIe controller is not a paritionable entity
>  		 * free the controller device iommu_group.
Acknowledged-by: Varun Sethi <varun.sethi@freescale.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

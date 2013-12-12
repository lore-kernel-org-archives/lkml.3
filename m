Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab3LLXw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 18:52:26 -0500
Received: from [207.46.163.210] ([207.46.163.210]:7159 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752109Ab3LLXwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 18:52:21 -0500
X-Greylist: delayed 1002 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Dec 2013 18:52:20 EST
Date: Thu, 12 Dec 2013 17:35:27 -0600
From: Scott Wood <scottwood@freescale.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
CC: <linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [1/3] powerpc/vfio: Enable on POWERNV platform
Message-ID: <20131212233527.GA16929@home.buserror.net>
References: <1369107191-28547-2-git-send-email-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1369107191-28547-2-git-send-email-aik@ozlabs.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BL2PR03CA016.namprd03.prod.outlook.com (10.141.66.24) To
 DM2PR03MB398.namprd03.prod.outlook.com (10.141.84.140)
X-Forefront-PRVS: 0058ABBBC7
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(24454002)(199002)(189002)(81686001)(63696002)(46406003)(81816001)(47976001)(83322001)(47776003)(49866001)(47736001)(23726002)(4396001)(50986001)(77096001)(79102001)(83072002)(85852003)(56816005)(80976001)(85306002)(51856001)(90146001)(53806001)(42186004)(69226001)(54356001)(46102001)(87976001)(59766001)(83506001)(74366001)(56776001)(76482001)(33656001)(77982001)(54316002)(87266001)(65816001)(76796001)(76786001)(50466002)(74662001)(81542001)(31966008)(74502001)(47446002)(81342001)(74706001)(80022001)(53416003)(74876001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB398;H:home.buserror.net;CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 01:33:09PM +1000, Alexey Kardashevskiy wrote:
> +static int iommu_add_device(struct device *dev)
> +{
> +	struct iommu_table *tbl;
> +	int ret = 0;
> +
> +	if (WARN_ON(dev->iommu_group)) {
> +		pr_warn("iommu_tce: device %s is already in iommu group %d, skipping\n",
> +				dev_name(dev),
> +				iommu_group_id(dev->iommu_group));
> +		return -EBUSY;
> +	}
[snip]
> +static int __init tce_iommu_init(void)
> +{
> +	struct pci_dev *pdev = NULL;
> +
> +	BUILD_BUG_ON(PAGE_SIZE < IOMMU_PAGE_SIZE);
> +
> +	for_each_pci_dev(pdev)
> +		iommu_add_device(&pdev->dev);
> +
> +	bus_register_notifier(&pci_bus_type, &tce_iommu_bus_nb);
> +	return 0;
> +}
> +
> +subsys_initcall_sync(tce_iommu_init);

This is missing a check to see whether the appropriate hardware is
present.  This file should also be renamed to something less generic, and
depend on a kconfig symbol more specific than CONFIG_PPC64.

When this is combined with CONFIG_FSL_PAMU on hardware with a PAMU, I get
a bunch of those "WARN_ON(dev->iommu_group)" dumps because PAMU already
got to them.  Presumably without PAMU it silently (or with just pr_debug)
bails out at some other point.

-Scott

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab3LMVDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 16:03:04 -0500
Received: from [207.46.163.212] ([207.46.163.212]:13749 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752184Ab3LMVDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 16:03:02 -0500
Message-ID: <1386968550.10013.320.camel@snotra.buserror.net>
Subject: Re: [1/3] powerpc/vfio: Enable on POWERNV platform
From: Scott Wood <scottwood@freescale.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
CC: <linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>
Date: Fri, 13 Dec 2013 15:02:30 -0600
In-Reply-To: <52AA78AE.2050800@ozlabs.ru>
References: <1369107191-28547-2-git-send-email-aik@ozlabs.ru>
	 <20131212233527.GA16929@home.buserror.net> <52AA78AE.2050800@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BLUPR08CA008.namprd08.prod.outlook.com (10.255.219.176)
 To DM2PR03MB397.namprd03.prod.outlook.com (10.141.84.139)
X-Forefront-PRVS: 00594E8DBA
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(51704005)(377424004)(479174003)(377454003)(24454002)(189002)(199002)(80022001)(83072002)(85852003)(47446002)(74502001)(31966008)(74662001)(59766001)(77982001)(54316002)(56776001)(23676002)(88136002)(90146001)(89996001)(56816005)(47776003)(33646001)(65816001)(77096001)(77156001)(79102001)(63696002)(83322001)(76482001)(50466002)(69226001)(51856001)(85306002)(42186004)(53806001)(81686001)(81816001)(74706001)(74366001)(80976001)(74876001)(50226001)(49866001)(47736001)(47976001)(87266001)(87286001)(4396001)(87976001)(81542001)(50986001)(81342001)(46102001)(62966002)(76796001)(76786001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB397;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-13 at 14:02 +1100, Alexey Kardashevskiy wrote:
> On 12/13/2013 10:35 AM, Scott Wood wrote:
> > On Tue, May 21, 2013 at 01:33:09PM +1000, Alexey Kardashevskiy wrote:
> >> +static int iommu_add_device(struct device *dev)
> >> +{
> >> +	struct iommu_table *tbl;
> >> +	int ret = 0;
> >> +
> >> +	if (WARN_ON(dev->iommu_group)) {
> >> +		pr_warn("iommu_tce: device %s is already in iommu group %d, skipping\n",
> >> +				dev_name(dev),
> >> +				iommu_group_id(dev->iommu_group));
> >> +		return -EBUSY;
> >> +	}
> > [snip]
> >> +static int __init tce_iommu_init(void)
> >> +{
> >> +	struct pci_dev *pdev = NULL;
> >> +
> >> +	BUILD_BUG_ON(PAGE_SIZE < IOMMU_PAGE_SIZE);
> >> +
> >> +	for_each_pci_dev(pdev)
> >> +		iommu_add_device(&pdev->dev);
> >> +
> >> +	bus_register_notifier(&pci_bus_type, &tce_iommu_bus_nb);
> >> +	return 0;
> >> +}
> >> +
> >> +subsys_initcall_sync(tce_iommu_init);
> > 
> > This is missing a check to see whether the appropriate hardware is
> > present.  This file should also be renamed to something less generic, and
> > depend on a kconfig symbol more specific than CONFIG_PPC64.
> > 
> > When this is combined with CONFIG_FSL_PAMU on hardware with a PAMU, I get
> > a bunch of those "WARN_ON(dev->iommu_group)" dumps because PAMU already
> > got to them.  Presumably without PAMU it silently (or with just pr_debug)
> > bails out at some other point.
> 
> 
> I posted (yet again) yesterday "[PATCH v11] PPC: POWERNV: move
> iommu_add_device earlier" which should fix this. And Bharat asked many
> times for this to get accepted :)

I still get the WARN_ONs even with that patch.  You're still registering
the bus notifier unconditionally.

-Scott



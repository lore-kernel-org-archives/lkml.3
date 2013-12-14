Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab3LNE4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 23:56:12 -0500
Received: from mail-bn1lp0158.outbound.protection.outlook.com ([207.46.163.158]:11701
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab3LNE4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 23:56:11 -0500
From: "Bharat.Bhushan@freescale.com" <Bharat.Bhushan@freescale.com>
To: Scott Wood <scottwood@freescale.com>, Alexey Kardashevskiy <aik@ozlabs.ru>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: RE: [1/3] powerpc/vfio: Enable on POWERNV platform
Thread-Topic: [1/3] powerpc/vfio: Enable on POWERNV platform
Thread-Index: AQHO96/JCZA/d0tGkU2bkIMlHylP2ZpSneUAgACByyA=
Date: Sat, 14 Dec 2013 04:56:06 +0000
Message-ID: <2e087e1f2aa34c0688a6c06420872d5f@BN1PR03MB266.namprd03.prod.outlook.com>
References: <1369107191-28547-2-git-send-email-aik@ozlabs.ru>
	 <20131212233527.GA16929@home.buserror.net> <52AA78AE.2050800@ozlabs.ru>
 <1386968550.10013.320.camel@snotra.buserror.net>
In-Reply-To: <1386968550.10013.320.camel@snotra.buserror.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [122.176.170.137]
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(51704005)(13464003)(377424004)(479174003)(377454003)(24454002)(189002)(199002)(66066001)(80022001)(83072002)(85852003)(47446002)(74502001)(31966008)(74662001)(59766001)(77982001)(54316002)(56776001)(90146001)(56816005)(33646001)(65816001)(77096001)(79102001)(63696002)(19580395003)(19580405001)(83322001)(76482001)(69226001)(51856001)(85306002)(53806001)(54356001)(81686001)(81816001)(74706001)(74366001)(80976001)(74316001)(74876001)(49866001)(47736001)(47976001)(87266001)(76576001)(4396001)(87936001)(81542001)(50986001)(2656002)(81342001)(46102001)(76796001)(76786001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB471;H:BN1PR03MB266.namprd03.prod.outlook.com;CLIP:122.176.170.137;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBE4uIx4014915



> -----Original Message-----
> From: Wood Scott-B07421
> Sent: Saturday, December 14, 2013 2:33 AM
> To: Alexey Kardashevskiy
> Cc: linuxppc-dev@lists.ozlabs.org; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; Alex Williamson; Paul Mackerras; David Gibson; Sethi
> Varun-B16395; Bhushan Bharat-R65777
> Subject: Re: [1/3] powerpc/vfio: Enable on POWERNV platform
> 
> On Fri, 2013-12-13 at 14:02 +1100, Alexey Kardashevskiy wrote:
> > On 12/13/2013 10:35 AM, Scott Wood wrote:
> > > On Tue, May 21, 2013 at 01:33:09PM +1000, Alexey Kardashevskiy wrote:
> > >> +static int iommu_add_device(struct device *dev) {
> > >> +	struct iommu_table *tbl;
> > >> +	int ret = 0;
> > >> +
> > >> +	if (WARN_ON(dev->iommu_group)) {
> > >> +		pr_warn("iommu_tce: device %s is already in iommu group %d,
> skipping\n",
> > >> +				dev_name(dev),
> > >> +				iommu_group_id(dev->iommu_group));
> > >> +		return -EBUSY;
> > >> +	}
> > > [snip]
> > >> +static int __init tce_iommu_init(void) {
> > >> +	struct pci_dev *pdev = NULL;
> > >> +
> > >> +	BUILD_BUG_ON(PAGE_SIZE < IOMMU_PAGE_SIZE);
> > >> +
> > >> +	for_each_pci_dev(pdev)
> > >> +		iommu_add_device(&pdev->dev);
> > >> +
> > >> +	bus_register_notifier(&pci_bus_type, &tce_iommu_bus_nb);
> > >> +	return 0;
> > >> +}
> > >> +
> > >> +subsys_initcall_sync(tce_iommu_init);
> > >
> > > This is missing a check to see whether the appropriate hardware is
> > > present.  This file should also be renamed to something less
> > > generic, and depend on a kconfig symbol more specific than CONFIG_PPC64.
> > >
> > > When this is combined with CONFIG_FSL_PAMU on hardware with a PAMU,
> > > I get a bunch of those "WARN_ON(dev->iommu_group)" dumps because
> > > PAMU already got to them.  Presumably without PAMU it silently (or
> > > with just pr_debug) bails out at some other point.
> >
> >
> > I posted (yet again) yesterday "[PATCH v11] PPC: POWERNV: move
> > iommu_add_device earlier" which should fix this. And Bharat asked many
> > times for this to get accepted :)
> 
> I still get the WARN_ONs even with that patch.  You're still registering the bus
> notifier unconditionally.

I have not tried v11 but tested V9 version of that patch. And yes, in that version the bus notifier was not registered unconditionally in kernel/iommu.c .

Thanks
-Bharat

> 
> -Scott
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

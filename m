Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab3LPIWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 03:22:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:55062 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab3LPIV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 03:21:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,493,1384329600"; 
   d="scan'208";a="450605211"
From: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>
CC: Viresh Kumar <viresh.linux@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] dma: dw: Add suspend and resume handling for PCI mode
 DW_DMAC.
Thread-Topic: [PATCH] dma: dw: Add suspend and resume handling for PCI mode
 DW_DMAC.
Thread-Index: AQHO9ZALDQwoxUs3N0WSdT+GfCUKwppMzJUAgAmy7SA=
Date: Mon, 16 Dec 2013 08:21:47 +0000
Message-ID: <604BF5F4C5D71041942BC7E84ED659EA01520785@PGSMSX103.gar.corp.intel.com>
References: <1386684373-24753-1-git-send-email-chiau.ee.chew@intel.com>
	 <20131210101025.GF29580@intel.com> <1386676582.1871.137.camel@smile>
In-Reply-To: <1386676582.1871.137.camel@smile>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBG8M8Nl023229

Vinod,

As mentioned by Andy, we are using *_noirq  verion of suspend/resume PM callback whereby the callbacks would be executed after IRQ handlers have been disabled. If using SET_SYSTEM_SLEEP_PM_OPS, it would be the normal suspend/resume PM callback. Looking at the Desginware DMAC platform code (drivers/dma/dw/platform.c), it is using the *_noirq suspend/resume PM callback. Is it advisable to use the normal suspend/resume PM callback instead of *_noirq suspend/PM callback? 

Thanks,
Chiau Ee

-----Original Message-----
From: Shevchenko, Andriy 
Sent: Tuesday, December 10, 2013 7:57 PM
To: Koul, Vinod
Cc: Chew, Chiau Ee; Viresh Kumar; Andy Shevchenko; Williams, Dan J; dmaengine@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: dw: Add suspend and resume handling for PCI mode DW_DMAC.

On Tue, 2013-12-10 at 15:40 +0530, Vinod Koul wrote:
> On Tue, Dec 10, 2013 at 10:06:13PM +0800, Chew Chiau Ee wrote:
> > From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> > 
> > This is to disable/enable DW_DMAC hw during suspend/resume.
> > 
> > Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> > Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  drivers/dma/dw/pci.c |   33 +++++++++++++++++++++++++++++++++
> >  1 files changed, 33 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/dma/dw/pci.c b/drivers/dma/dw/pci.c index 
> > e89fc24..97bc3a2 100644
> > --- a/drivers/dma/dw/pci.c
> > +++ b/drivers/dma/dw/pci.c
> > @@ -75,6 +75,36 @@ static void dw_pci_remove(struct pci_dev *pdev)
> >  		dev_warn(&pdev->dev, "can't remove device properly: %d\n", ret);  
> > }
> >  
> > +#ifdef CONFIG_PM_SLEEP
> > +
> > +static int dw_pci_suspend_noirq(struct device *dev) {
> > +	struct pci_dev *pci = to_pci_dev(dev);
> > +	struct dw_dma_chip *chip = pci_get_drvdata(pci);
> > +
> > +	return dw_dma_suspend(chip);
> > +};
> > +
> > +static int dw_pci_resume_noirq(struct device *dev) {
> > +	struct pci_dev *pci = to_pci_dev(dev);
> > +	struct dw_dma_chip *chip = pci_get_drvdata(pci);
> > +
> > +	return dw_dma_resume(chip);
> > +};
> > +
> > +#else /* !CONFIG_PM_SLEEP */
> > +
> > +#define dw_pci_suspend_noirq	NULL
> > +#define dw_pci_resume_noirq	NULL
> > +
> > +#endif /* !CONFIG_PM_SLEEP */
> How about SET_SYSTEM_SLEEP_PM_OPS instead?

So, we are using *_noirq versions of the functions here. What happened when we switch to normal ones? Any side effects?

> 
> --
> ~Vinod
> > +
> > +static const struct dev_pm_ops dw_pci_dev_pm_ops = {
> > +	.suspend_noirq = dw_pci_suspend_noirq,
> > +	.resume_noirq = dw_pci_resume_noirq, };
> > +
> >  static DEFINE_PCI_DEVICE_TABLE(dw_pci_id_table) = {
> >  	/* Medfield */
> >  	{ PCI_VDEVICE(INTEL, 0x0827), (kernel_ulong_t)&dw_pci_pdata }, @@ 
> > -92,6 +122,9 @@ static struct pci_driver dw_pci_driver = {
> >  	.id_table	= dw_pci_id_table,
> >  	.probe		= dw_pci_probe,
> >  	.remove		= dw_pci_remove,
> > +	.driver	= {
> > +		.pm	= &dw_pci_dev_pm_ops,
> > +	},
> >  };
> >  
> >  module_pci_driver(dw_pci_driver);
> > --
> > 1.7.4.4
> > 
> 

--
Andy Shevchenko <andriy.shevchenko@intel.com> Intel Finland Oy
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

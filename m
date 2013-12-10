Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab3LJL5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 06:57:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:58900 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740Ab3LJL5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 06:57:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,865,1378882800"; 
   d="scan'208";a="422249440"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
CC: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dma: dw: Add suspend and resume handling for PCI mode
 DW_DMAC.
Thread-Topic: [PATCH] dma: dw: Add suspend and resume handling for PCI mode
 DW_DMAC.
Thread-Index: AQHO9Z7p9Jc6qxjFmEKtLOANDd+AQQ==
Date: Tue, 10 Dec 2013 11:56:50 +0000
Message-ID: <1386676582.1871.137.camel@smile>
References: <1386684373-24753-1-git-send-email-chiau.ee.chew@intel.com>
	 <20131210101025.GF29580@intel.com>
In-Reply-To: <20131210101025.GF29580@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.173]
Content-Type: text/plain; charset="utf-8"
Content-ID: <07AAAC32D71EEB4B880C4DBEA2E2BC03@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBABvTue015112

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
> > diff --git a/drivers/dma/dw/pci.c b/drivers/dma/dw/pci.c
> > index e89fc24..97bc3a2 100644
> > --- a/drivers/dma/dw/pci.c
> > +++ b/drivers/dma/dw/pci.c
> > @@ -75,6 +75,36 @@ static void dw_pci_remove(struct pci_dev *pdev)
> >  		dev_warn(&pdev->dev, "can't remove device properly: %d\n", ret);
> >  }
> >  
> > +#ifdef CONFIG_PM_SLEEP
> > +
> > +static int dw_pci_suspend_noirq(struct device *dev)
> > +{
> > +	struct pci_dev *pci = to_pci_dev(dev);
> > +	struct dw_dma_chip *chip = pci_get_drvdata(pci);
> > +
> > +	return dw_dma_suspend(chip);
> > +};
> > +
> > +static int dw_pci_resume_noirq(struct device *dev)
> > +{
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

So, we are using *_noirq versions of the functions here. What happened
when we switch to normal ones? Any side effects?

> 
> --
> ~Vinod
> > +
> > +static const struct dev_pm_ops dw_pci_dev_pm_ops = {
> > +	.suspend_noirq = dw_pci_suspend_noirq,
> > +	.resume_noirq = dw_pci_resume_noirq,
> > +};
> > +
> >  static DEFINE_PCI_DEVICE_TABLE(dw_pci_id_table) = {
> >  	/* Medfield */
> >  	{ PCI_VDEVICE(INTEL, 0x0827), (kernel_ulong_t)&dw_pci_pdata },
> > @@ -92,6 +122,9 @@ static struct pci_driver dw_pci_driver = {
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
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

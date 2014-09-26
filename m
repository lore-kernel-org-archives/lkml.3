Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaIZJgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:36:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:51330 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbaIZJga convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:36:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,603,1406617200"; 
   d="scan'208";a="605740191"
From: "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>
To: "'Mika Westerberg'" <mika.westerberg@linux.intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] gpio: sch: Enable IRQ support for Quark X1000
Thread-Topic: [PATCH 3/3] gpio: sch: Enable IRQ support for Quark X1000
Thread-Index: AQHP0zQSih2TMGVJkkyH0NU8qSMEqpwTJk7A//+CvICAAIqjgA==
Date: Fri, 26 Sep 2014 09:36:06 +0000
Message-ID: <50B33AC5ED75F74F991980326F1C438D0FBE89FB@PGSMSX108.gar.corp.intel.com>
References: <1410943745-9354-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1410943745-9354-4-git-send-email-rebecca.swee.fun.chang@intel.com>
 <20140918113122.GO10854@lahna.fi.intel.com>
 <50B33AC5ED75F74F991980326F1C438D0FBE89AD@PGSMSX108.gar.corp.intel.com>
 <20140926091805.GV1786@lahna.fi.intel.com>
In-Reply-To: <20140926091805.GV1786@lahna.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: 'Mika Westerberg' [mailto:mika.westerberg@linux.intel.com]
> Sent: 26 September, 2014 5:18 PM
> To: Chang, Rebecca Swee Fun
> Cc: Linus Walleij; linux-gpio@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 3/3] gpio: sch: Enable IRQ support for Quark X1000
> 
> On Fri, Sep 26, 2014 at 09:14:48AM +0000, Chang, Rebecca Swee Fun wrote:
> > > > @@ -203,6 +376,17 @@ static int sch_gpio_probe(struct
> > > > platform_device
> > > *pdev)
> > > >  				 pdev->name))
> > > >  		return -EBUSY;
> > > >
> > > > +	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> > > > +	sch->irq_support = !!irq;
> > > > +	if (sch->irq_support) {
> > > > +		sch->irq_num = irq->start;
> > > > +		if (sch->irq_num < 0) {
> > > > +			dev_warn(&pdev->dev,
> > > > +				 "failed to obtain irq number for device\n");
> > > > +			sch->irq_support = 0;
> > > > +		}
> > > > +	}
> > > > +
> > > >  	spin_lock_init(&sch->lock);
> > > >  	sch->iobase = res->start;
> > > >  	sch->chip = sch_gpio_chip;
> > > > @@ -251,17 +435,72 @@ static int sch_gpio_probe(struct
> > > > platform_device
> > > *pdev)
> > > >  		return -ENODEV;
> > > >  	}
> > > >
> > > > +	err = gpiochip_add(&sch->chip);
> > > > +	if (err < 0)
> > > > +		goto err_sch_gpio;
> > > > +
> > > > +	if (sch->irq_support) {
> > > > +		sch->irq_base = irq_alloc_descs(-1, 0, sch->chip.ngpio,
> > > > +						NUMA_NO_NODE);
> > > > +		if (sch->irq_base < 0) {
> > > > +			dev_err(&pdev->dev,
> > > > +				"failed to add GPIO IRQ descs\n");
> > > > +			sch->irq_base = -1;
> > > > +			goto err_sch_intr_chip;
> > > > +		}
> > >
> > > Was there some reason why you can't use gpiochip_irqchip_* helpers here?
> >
> > I will look into the helpers function and see what I can change here.
> >
> > >
> > > > +
> > > > +		/* disable interrupts */
> > > > +		sch_gpio_irq_disable_all(sch, sch->chip.ngpio);
> > > > +
> > > > +		err = request_irq(sch->irq_num, sch_gpio_irq_handler,
> > > > +				  IRQF_SHARED, KBUILD_MODNAME, sch);
> > >
> > > This seems weird, typically irqchip drivers don't call request_irq()
> > > directly but instead irq_set_chained_handler() or similar. With
> > > gpiochip_irqchip_* stuff you don't need even that.
> > >
> > Regarding this, gpio-sch is actually using shared interrupts and the
> > IRQ resources are from ACPI SCI. As per my understanding, resources
> > from ACPI SCI might be shared for power management purposes. In this
> > case, irq_set_chained_handler() might not be able to use here. What do
> > you think?
> 
> I think you are right. And then you can't use gpiochip_irqchip_* helpers either :-
> (

Then I shall submit the changes for the first patch in V2 series for further review. Thanks.

Rebecca

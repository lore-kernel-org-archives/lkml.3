Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbaIZJSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:18:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:10409 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbaIZJSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:18:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,603,1406617200"; 
   d="scan'208";a="608991126"
Date: Fri, 26 Sep 2014 12:18:05 +0300
From: "'Mika Westerberg'" <mika.westerberg@linux.intel.com>
To: "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] gpio: sch: Enable IRQ support for Quark X1000
Message-ID: <20140926091805.GV1786@lahna.fi.intel.com>
References: <1410943745-9354-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1410943745-9354-4-git-send-email-rebecca.swee.fun.chang@intel.com>
 <20140918113122.GO10854@lahna.fi.intel.com>
 <50B33AC5ED75F74F991980326F1C438D0FBE89AD@PGSMSX108.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B33AC5ED75F74F991980326F1C438D0FBE89AD@PGSMSX108.gar.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 09:14:48AM +0000, Chang, Rebecca Swee Fun wrote:
> > > @@ -203,6 +376,17 @@ static int sch_gpio_probe(struct platform_device
> > *pdev)
> > >  				 pdev->name))
> > >  		return -EBUSY;
> > >
> > > +	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> > > +	sch->irq_support = !!irq;
> > > +	if (sch->irq_support) {
> > > +		sch->irq_num = irq->start;
> > > +		if (sch->irq_num < 0) {
> > > +			dev_warn(&pdev->dev,
> > > +				 "failed to obtain irq number for device\n");
> > > +			sch->irq_support = 0;
> > > +		}
> > > +	}
> > > +
> > >  	spin_lock_init(&sch->lock);
> > >  	sch->iobase = res->start;
> > >  	sch->chip = sch_gpio_chip;
> > > @@ -251,17 +435,72 @@ static int sch_gpio_probe(struct platform_device
> > *pdev)
> > >  		return -ENODEV;
> > >  	}
> > >
> > > +	err = gpiochip_add(&sch->chip);
> > > +	if (err < 0)
> > > +		goto err_sch_gpio;
> > > +
> > > +	if (sch->irq_support) {
> > > +		sch->irq_base = irq_alloc_descs(-1, 0, sch->chip.ngpio,
> > > +						NUMA_NO_NODE);
> > > +		if (sch->irq_base < 0) {
> > > +			dev_err(&pdev->dev,
> > > +				"failed to add GPIO IRQ descs\n");
> > > +			sch->irq_base = -1;
> > > +			goto err_sch_intr_chip;
> > > +		}
> > 
> > Was there some reason why you can't use gpiochip_irqchip_* helpers here?
> 
> I will look into the helpers function and see what I can change here.
> 
> > 
> > > +
> > > +		/* disable interrupts */
> > > +		sch_gpio_irq_disable_all(sch, sch->chip.ngpio);
> > > +
> > > +		err = request_irq(sch->irq_num, sch_gpio_irq_handler,
> > > +				  IRQF_SHARED, KBUILD_MODNAME, sch);
> > 
> > This seems weird, typically irqchip drivers don't call request_irq() directly but
> > instead irq_set_chained_handler() or similar. With
> > gpiochip_irqchip_* stuff you don't need even that.
> > 
> Regarding this, gpio-sch is actually using shared interrupts and the
> IRQ resources are from ACPI SCI. As per my understanding, resources
> from ACPI SCI might be shared for power management purposes. In this
> case, irq_set_chained_handler() might not be able to use here. What do
> you think?

I think you are right. And then you can't use gpiochip_irqchip_* helpers
either :-(

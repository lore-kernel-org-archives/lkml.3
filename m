Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbaKEJfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:35:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:59982 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbaKEJfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:35:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,319,1413270000"; 
   d="scan'208";a="602606185"
From: "Chang, Rebecca Swee Fun" <rebecca.swee.fun.chang@intel.com>
To: "Westerberg, Mika" <mika.westerberg@intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Denis Turischev <denis.turischev@compulab.co.il>
Subject: RE: [PATCHv3 3/3] gpio: sch: Enable IRQ support for Quark X1000
Thread-Topic: [PATCHv3 3/3] gpio: sch: Enable IRQ support for Quark X1000
Thread-Index: AQHP6SqkKa3j/RcXxUq5NEUuAjnRK5xFTArQ
Date: Wed, 5 Nov 2014 09:33:01 +0000
Message-ID: <50B33AC5ED75F74F991980326F1C438D0FC047C5@PGSMSX108.gar.corp.intel.com>
References: <1413431475-12799-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1413431475-12799-4-git-send-email-rebecca.swee.fun.chang@intel.com>
 <20141016101918.GC2255@lahna.fi.intel.com>
In-Reply-To: <20141016101918.GC2255@lahna.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late reply, was working on something else.

> -----Original Message-----
> From: Westerberg, Mika
> Sent: 16 October, 2014 6:19 PM
> To: Chang, Rebecca Swee Fun
> Cc: Linus Walleij; GPIO Subsystem Mailing List; Linux Kernel Mailing List; Denis
> Turischev
> Subject: Re: [PATCHv3 3/3] gpio: sch: Enable IRQ support for Quark X1000
> 
> On Thu, Oct 16, 2014 at 11:51:15AM +0800, Chang Rebecca Swee Fun wrote:
> > Intel Quark X1000 GPIO controller supports interrupt handling for both
> > core power well and resume power well. This patch is to enable the IRQ
> > support and provide IRQ handling for Intel Quark X1000 GPIO-SCH device
> > driver.
> >
> > This piece of work is derived from Dan O'Donovan's initial work for
> > Quark X1000 enabling.
> >
> > Signed-off-by: Chang Rebecca Swee Fun
> > <rebecca.swee.fun.chang@intel.com>
> 
> In addition to what Varka Bhadram pointed out, I have few comments. See
> below.
> 
> Overall, looks good.
> 
> > ---
> >  drivers/gpio/gpio-sch.c |  257
> > ++++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 245 insertions(+), 12 deletions(-)
> >
(...)

> > +static void sch_gpio_irq_disable(struct irq_data *d) {
> > +	struct sch_gpio *sch = container_of(d, struct sch_gpio, data);
> > +	u32 gpio_num;
> > +
> > +	gpio_num = d->irq - sch->irq_base;
> > +	sch_gpio_register_clear(sch, gpio_num, GGPE); }
> > +
> > +static void sch_gpio_irq_ack(struct irq_data *d) {
> > +	struct sch_gpio *sch = container_of(d, struct sch_gpio, data);
> > +	u32 gpio_num;
> > +
> > +	gpio_num = d->irq - sch->irq_base;
> > +	sch_gpio_reg_set(&(sch->chip), gpio_num, GTS, 1);
> 
> Maybe use the new sch_gpio_register_set() here instead?

According to Alexandre's review feedback, sch_gpio_register_set() and  sch_gpio_register_clear() actually having similar block of codes with sch_gpio_reg_set(). He suggested to call sch_gpio_reg_set(gc, gpio, reg, 1) in place of sch_gpio_register_set() and sch_gpio_reg_set(gc, gpio, reg, 0) for sch_gpio_register_clear(). I'm now in the progress of reworking the patches in that direction.

> 
> > +}
> > +
> > +static int sch_gpio_irq_type(struct irq_data *d, unsigned type) {
> > +	struct sch_gpio *sch = container_of(d, struct sch_gpio, data);
> > +	unsigned long flags;
> > +	u32 gpio_num;
> > +
> > +	if (d == NULL)
> > +		return -EINVAL;
> 
> How can that happen?

This is just to ensure the irq_data struct contains data. If you think this is no needed, I will remove it in next submission.
(...)
> > +
> > +static void sch_gpio_irqs_init(struct sch_gpio *sch, unsigned int
> > +num) {
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < num; i++) {
> > +		irq_set_chip_data(i + sch->irq_base, sch);
> > +		irq_set_chip_and_handler_name(i + sch->irq_base,
> > +					      &sch_irq_chip,
> > +					      handle_simple_irq,
> > +					      "sch_gpio_irq_chip");
> 
> Hmm, I wonder if this
> 
> 		irq_set_chip_and_handler_name(i + sch->irq_base,
> &sch_irq_chip,
> 					handle_simple_irq,
> "sch_gpio_irq_chip");
> 
> looks better. Up to you.
> 
I think I will take what you've suggested. :)

(...)
> >  static int sch_gpio_probe(struct platform_device *pdev)  {
> >  	struct sch_gpio *sch;
> > -	struct resource *res;
> > +	struct resource *res, *irq;
> > +	int err;
> >
> >  	sch = devm_kzalloc(&pdev->dev, sizeof(*sch), GFP_KERNEL);
> >  	if (!sch)
> > @@ -203,6 +376,17 @@ static int sch_gpio_probe(struct platform_device
> *pdev)
> >  				 pdev->name))
> >  		return -EBUSY;
> >
> > +	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> > +	sch->irq_support = !!irq;
> > +	if (sch->irq_support) {
> > +		sch->irq_num = irq->start;
> > +		if (sch->irq_num < 0) {
> 
> Is this really possible? I mean can't you just detect the irq support by looking
> sch->irq_num? If it is > 0 then it has interrupt support. I think that irq 0 is not
> valid.

Yes, I can do that, but the irq_num was being passed from MFD LPC_SCH. This implementation is to avoid enabling irq support if LPC_SCH passed in a negative value.
As for irq 0, I think it is valid. Based on my observation in "cat /proc/interrupt" there is a 0 irq line available.

> 
> > +			dev_warn(&pdev->dev,
> > +				 "failed to obtain irq number for device\n");
> > +			sch->irq_support = false;
> > +		}
> > +	}
> > +
> >  	spin_lock_init(&sch->lock);
> >  	sch->iobase = res->start;
> >  	sch->chip = sch_gpio_chip;
> > @@ -251,15 +435,64 @@ static int sch_gpio_probe(struct platform_device
> *pdev)
> >  		return -ENODEV;
> >  	}
> >
> > +	err = gpiochip_add(&sch->chip);
> > +	if (err < 0)
> > +		goto err_sch_gpio;
> > +
> > +	if (sch->irq_support) {
> > +		sch->irq_base = irq_alloc_descs(-1, 0, sch->chip.ngpio,
> > +						NUMA_NO_NODE);
> > +		if (sch->irq_base < 0) {
> > +			dev_err(&pdev->dev,
> > +				"failed to allocate GPIO IRQ descs\n");
> > +			goto err_sch_intr_chip;
> > +		}
> > +
> > +		/* disable interrupts */
> > +		sch_gpio_irq_disable_all(sch, sch->chip.ngpio);
> > +
> > +		err = request_irq(sch->irq_num, sch_gpio_irq_handler,
> > +				  IRQF_SHARED, KBUILD_MODNAME, sch);
> > +		if (err) {
> > +			dev_err(&pdev->dev,
> > +				"%s failed to request IRQ\n", __func__);
> > +			goto err_sch_request_irq;
> > +		}
> > +
> > +		sch_gpio_irqs_init(sch, sch->chip.ngpio);
> > +	}
> > +
> >  	platform_set_drvdata(pdev, sch);
> >
> > -	return gpiochip_add(&sch->chip);
> > +	return 0;
> > +
> > +err_sch_request_irq:
> > +	irq_free_descs(sch->irq_base, sch->chip.ngpio);
> > +
> > +err_sch_intr_chip:
> > +	if (gpiochip_remove(&sch->chip))
> > +		dev_err(&pdev->dev,
> > +			"%s gpiochip_remove() failed\n", __func__);
> > +
> > +err_sch_gpio:
> > +	release_region(res->start, resource_size(res));
> 
> This is not needed as devm_request_region() will clean it up for you
> automatically. Even if probe() fails.

Noted with thanks.

Rebecca

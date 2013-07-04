Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab3GDVXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 17:23:04 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:58002 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab3GDVXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 17:23:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org
Subject: Re: [PATCH] gpio: em: Add pinctrl support
Date: Thu, 04 Jul 2013 23:23:33 +0200
Message-ID: <2390194.haUC6IOiqJ@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <20130704011601.GB13029@verge.net.au>
References: <20130703041432.7351.45970.sendpatchset@w520> <2134291.KQ1KkPOaiZ@avalon> <20130704011601.GB13029@verge.net.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Thursday 04 July 2013 10:16:02 Simon Horman wrote:
> On Wed, Jul 03, 2013 at 08:59:39PM +0200, Laurent Pinchart wrote:
> > On Wednesday 03 July 2013 13:14:32 Magnus Damm wrote:
> > > From: Magnus Damm <damm@opensource.se>
> > > 
> > > Register the GPIO pin range, and request and free GPIO pins using the
> > > pinctrl API. The pctl_name platform data member should be used by
> > > platform devices to point out which pinctrl device to use.
> > > 
> > > Follows same style as "dc3465a gpio-rcar: Add pinctrl support",
> > > by Laurent Pinchart, thanks to him.
> > > 
> > > Signed-off-by: Magnus Damm <damm@opensource.se>
> > 
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > Linus, now that the v3.12 development cycle will begin, would you like to
> > take the patch through your tree ? If so, how should we handle
> > cross-dependencies between the pinctrl/gpio tree and the Renesas ARM tree
> > ?
> 
> In the case of this patch I believe that any dependencies that are present
> in the renesas tree have been merged into the arm-soc tree and thus should
> appear in v3.11-rcX, where X most likely equals 2 or 3.
> 
> That being so v3.11-rcX could be used as a base.
> 
> Alternatively its likely that one the renesas-*-for-v3.11 tags in my renesas
> tree, all of which have been merged into arm-soc and should appear in v3.11-
> rcX, could be used as a base.
> 
> I'm unsure which one as I'm unsure what the dependencies are but I strongly
> suspect that renesas-gpio-rcar2-for-v3.11 would be a good choice.

I haven't expressed myself clearly, sorry about that. This particular patch is 
fine. My point was that it adds a new field to the gpio-em platform data 
structure. We will thus pretty soon see patches for board code to use that 
field, so you will need to merge a stable pinctrl branch that includes this 
patch into your tree.

We may also encounter similar situations in the reverse direction (pinctrl 
patches that depend on ARM patches) in the future, we should be prepared for 
that as well.

> > > ---
> > > 
> > >  drivers/gpio/gpio-em.c                |   25 +++++++++++++++++++++++++
> > >  include/linux/platform_data/gpio-em.h |    1 +
> > >  2 files changed, 26 insertions(+)
> > > 
> > > --- 0001/drivers/gpio/gpio-em.c
> > > +++ work/drivers/gpio/gpio-em.c	2013-07-03 12:49:55.000000000 +0900
> > > @@ -30,6 +30,7 @@
> > > 
> > >  #include <linux/gpio.h>
> > >  #include <linux/slab.h>
> > >  #include <linux/module.h>
> > > 
> > > +#include <linux/pinctrl/consumer.h>
> > > 
> > >  #include <linux/platform_data/gpio-em.h>
> > >  
> > >  struct em_gio_priv {
> > > 
> > > @@ -216,6 +217,21 @@ static int em_gio_to_irq(struct gpio_chi
> > > 
> > >  	return irq_create_mapping(gpio_to_priv(chip)->irq_domain, offset);
> > >  
> > >  }
> > > 
> > > +static int em_gio_request(struct gpio_chip *chip, unsigned offset)
> > > +{
> > > +	return pinctrl_request_gpio(chip->base + offset);
> > > +}
> > > +
> > > +static void em_gio_free(struct gpio_chip *chip, unsigned offset)
> > > +{
> > > +	pinctrl_free_gpio(chip->base + offset);
> > > +
> > > +	/* Set the GPIO as an input to ensure that the next GPIO request 
won't
> > > +	* drive the GPIO pin as an output.
> > > +	*/
> > > +	em_gio_direction_input(chip, offset);
> > > +}
> > > +
> > > 
> > >  static int em_gio_irq_domain_map(struct irq_domain *h, unsigned int
> > >  virq,
> > >  
> > >  				 irq_hw_number_t hw)
> > >  
> > >  {
> > > 
> > > @@ -308,6 +324,8 @@ static int em_gio_probe(struct platform_
> > > 
> > >  	gpio_chip->direction_output = em_gio_direction_output;
> > >  	gpio_chip->set = em_gio_set;
> > >  	gpio_chip->to_irq = em_gio_to_irq;
> > > 
> > > +	gpio_chip->request = em_gio_request;
> > > +	gpio_chip->free = em_gio_free;
> > > 
> > >  	gpio_chip->label = name;
> > >  	gpio_chip->owner = THIS_MODULE;
> > >  	gpio_chip->base = pdata->gpio_base;
> > > 
> > > @@ -351,6 +369,13 @@ static int em_gio_probe(struct platform_
> > > 
> > >  		dev_err(&pdev->dev, "failed to add GPIO controller\n");
> > >  		goto err1;
> > >  	
> > >  	}
> > > 
> > > +
> > > +	if (pdata->pctl_name) {
> > > +		ret = gpiochip_add_pin_range(gpio_chip, pdata->pctl_name, 0,
> > > +					     gpio_chip->base, gpio_chip->ngpio);
> > > +		if (ret < 0)
> > > +			dev_warn(&pdev->dev, "failed to add pin range\n");
> > > +	}
> > > 
> > >  	return 0;
> > >  
> > >  err1:
> > > --- 0001/include/linux/platform_data/gpio-em.h
> > > +++ work/include/linux/platform_data/gpio-em.h	2013-07-03
> > 
> > 12:45:27.000000000
> > 
> > > +0900 @@ -5,6 +5,7 @@ struct gpio_em_config {
> > > 
> > >  	unsigned int gpio_base;
> > >  	unsigned int irq_base;
> > >  	unsigned int number_of_pins;
> > > 
> > > +	const char *pctl_name;
> > > 
> > >  };
> > >  
> > >  #endif /* __GPIO_EM_H__ */
-- 
Regards,

Laurent Pinchart


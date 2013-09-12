Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab3ILRAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:00:34 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:57172 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab3ILRAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:00:33 -0400
Date: Thu, 12 Sep 2013 10:00:29 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [RFC PATCH 4/6] extcon-gpio: Add devicetree support
Message-ID: <20130912170029.GB12202@roeck-us.net>
References: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
 <1377836978-24082-5-git-send-email-linux@roeck-us.net>
 <20130912164545.GG22013@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912164545.GG22013@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 05:45:45PM +0100, Mark Rutland wrote:
> On Fri, Aug 30, 2013 at 05:29:36AM +0100, Guenter Roeck wrote:
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> >  drivers/extcon/extcon-gpio.c |   59 ++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 57 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
> > index d4e3c89..16951fe 100644
> > --- a/drivers/extcon/extcon-gpio.c
> > +++ b/drivers/extcon/extcon-gpio.c
> > @@ -30,6 +30,8 @@
> >  #include <linux/gpio.h>
> >  #include <linux/extcon.h>
> >  #include <linux/extcon/extcon-gpio.h>
> > +#include <linux/of_gpio.h>
> > +#include <linux/err.h>
> >  
> >  struct gpio_extcon_data {
> >  	struct extcon_dev edev;
> > @@ -77,14 +79,66 @@ static ssize_t extcon_gpio_print_state(struct extcon_dev *edev, char *buf)
> >  	return -EINVAL;
> >  }
> >  
> > +#ifdef CONFIG_OF_GPIO
> > +
> > +static struct gpio_extcon_platform_data *
> > +extcon_gpio_config_of(struct device *dev)
> > +{
> > +	struct gpio_extcon_platform_data *pdata;
> > +	struct device_node *np = dev->of_node;
> > +	enum of_gpio_flags flags;
> > +	int gpio, ret;
> > +	u32 debounce;
> > +
> > +	gpio = of_get_named_gpio_flags(np, "presence-detect-gpios", 0, &flags);
> > +	if (gpio < 0)
> > +		return ERR_PTR(gpio);
> > +
> > +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> > +	if (!pdata)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	pdata->gpio = gpio;
> > +	pdata->gpio_active_low = flags & OF_GPIO_ACTIVE_LOW;
> > +	pdata->irq_flags = IRQ_TYPE_EDGE_BOTH;
> > +
> > +	if (!of_property_read_u32(np, "debounce-interval", &debounce))
> > +		pdata->debounce = debounce;
> > +
> > +	ret = of_property_read_string(np, "name", &pdata->name);
> 
> This wasn't listed in the binding. What's this for?
> 
This returns the node name.
For example, if the bindings are

	my-connector {
		...
	};

it returns the string "my-connector".

I can add a reference to the bindings document if that helps. It is typically
not mentioned in bindings, though, so I didn't do it either.

Thanks,
Guenter

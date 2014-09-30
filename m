Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaI3LYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 07:24:19 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:36128 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaI3LYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 07:24:17 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 30 Sep 2014 13:21:36 +0200
From: Johan Hovold <johan@kernel.org>
To: Muthu Mani <muth@cypress.com>
Cc: Johan Hovold <johan@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Wolfram Sang <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajaram Regupathy <rera@cypress.com>
Subject: Re: [PATCH 3/3] gpio: add support for Cypress CYUSBS234 USB-GPIO
 adapter
Message-ID: <20140930112136.GC17834@localhost>
References: <1411378458-18424-1-git-send-email-muth@cypress.com>
 <20140922114357.GG5237@localhost>
 <7e6ba8fdbdb643c885369e37e2bcd25a@BY2PR06MB076.namprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e6ba8fdbdb643c885369e37e2bcd25a@BY2PR06MB076.namprd06.prod.outlook.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 05:47:11AM +0000, Muthu Mani wrote:
> > -----Original Message-----
> > From: Johan Hovold [mailto:jhovold@gmail.com] On Behalf Of Johan Hovold

> > > +static int cy_gpio_direction_input(struct gpio_chip *chip,
> > > +                                     unsigned offset) {
> > > +     return 0;
> > 
> > Aren't the GPIOs output-only?
> 
> No.

Then you should implement this callback to configure the pin as an
input.

Or can the configuration only be made through your configuration tools
and stored in eeprom?

Then you need to retrieve the actual config and implement these
callbacks (e.g. fail if not matching the eeprom config) along with
get_direction().

> > > +}
> > > +
> > > +static int cy_gpio_direction_output(struct gpio_chip *chip,
> > > +                                     unsigned offset, int value) {
> > > +     return 0;
> > > +}
> > > +
> > > +static int cyusbs23x_gpio_probe(struct platform_device *pdev) {
> > > +     struct cyusbs23x *cyusbs;
> > > +     struct cyusbs_gpio *cy_gpio;
> > > +     int ret = 0;
> > > +
> > > +     dev_dbg(&pdev->dev, "%s\n", __func__);
> > > +
> > > +     cyusbs = dev_get_drvdata(pdev->dev.parent);
> > > +
> > > +     cy_gpio = devm_kzalloc(&pdev->dev, sizeof(*cy_gpio), GFP_KERNEL);
> > > +     if (cy_gpio == NULL)
> > > +             return -ENOMEM;
> > > +
> > > +     cy_gpio->cyusbs = cyusbs;
> > > +     /* registering gpio */
> > > +     cy_gpio->gpio.label = "cyusbs23x gpio";
> > > +     cy_gpio->gpio.dev = &pdev->dev;
> > > +     cy_gpio->gpio.owner = THIS_MODULE;
> > > +     cy_gpio->gpio.base = -1;
> > > +     cy_gpio->gpio.ngpio = 12; /* total GPIOs */
> > 
> > I think you need to read out the gpio config from the device eeprom and
> > implement a request() callback where you verify that a requested gpio is
> > actually available (mode dependent, and there are never more than 10 gpios
> > availble).
> 
> In this initial driver, all GPIOs are made available to user space.
> Additional functionalities will be added in the next version of the driver.

I think this needs to be implemented now. It's needed for direction
handling as well as mentioned above.

> > > +     cy_gpio->gpio.can_sleep = true;
> > > +     cy_gpio->gpio.set = cy_gpio_set;
> > > +     cy_gpio->gpio.get = cy_gpio_get;
> > > +     cy_gpio->gpio.direction_input = cy_gpio_direction_input;
> > > +     cy_gpio->gpio.direction_output = cy_gpio_direction_output;
> > > +     ret = gpiochip_add(&cy_gpio->gpio);
> > > +     if (ret < 0) {
> > > +             dev_err(cy_gpio->gpio.dev, "could not add gpio");
> > > +             goto error;
> > > +     }

Thanks,
Johan

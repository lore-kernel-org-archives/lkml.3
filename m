Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760796AbaJCX6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:58:12 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56442 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755531AbaJCX6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 19:58:09 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 09/15] leds: leds-gpio: Make use of device property API
Date: Sat, 04 Oct 2014 02:18:10 +0200
Message-ID: <3474649.PYuASxQ0V3@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141003140728.GO26643@leverpostej>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <83082601.pjR7TmeO0m@vostro.rjw.lan> <20141003140728.GO26643@leverpostej>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 03, 2014 03:07:28 PM Mark Rutland wrote:
> On Wed, Oct 01, 2014 at 03:16:25AM +0100, Rafael J. Wysocki wrote:
> > From: Max Eliaser <max@meliaserlow.dyndns.tv>
> > 
> > Make use of device property API in this driver so that both OF and ACPI
> > based system can use the same driver.
> > 
> > Signed-off-by: Max Eliaser <max.eliaser@intel.com>
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/leds/leds-gpio.c |   99 +++++++++++++++++++----------------------------
> >  1 file changed, 42 insertions(+), 57 deletions(-)
> > 
> > Index: linux-pm/drivers/leds/leds-gpio.c
> > ===================================================================
> > --- linux-pm.orig/drivers/leds/leds-gpio.c
> > +++ linux-pm/drivers/leds/leds-gpio.c
> > @@ -15,13 +15,11 @@
> >  #include <linux/gpio.h>
> >  #include <linux/gpio/consumer.h>
> >  #include <linux/leds.h>
> > -#include <linux/of.h>
> > -#include <linux/of_platform.h>
> > -#include <linux/of_gpio.h>
> >  #include <linux/slab.h>
> >  #include <linux/workqueue.h>
> >  #include <linux/module.h>
> >  #include <linux/err.h>
> > +#include <linux/property.h>
> >  
> >  struct gpio_led_data {
> >  	struct led_classdev cdev;
> > @@ -171,65 +169,59 @@ static inline int sizeof_gpio_leds_priv(
> >  		(sizeof(struct gpio_led_data) * num_leds);
> >  }
> >  
> > -/* Code to create from OpenFirmware platform devices */
> > -#ifdef CONFIG_OF_GPIO
> > -static struct gpio_leds_priv *gpio_leds_create_of(struct platform_device *pdev)
> > +static int gpio_leds_create_led(struct device *dev, void *child, void *data)
> > +{
> > +	struct gpio_leds_priv *priv = data;
> > +	struct gpio_led led = {};
> > +	const char *state = NULL;
> > +
> > +	led.gpiod = devm_get_named_gpiod_from_child(dev, child, "gpios", 0);
> > +	if (IS_ERR(led.gpiod))
> > +		return PTR_ERR(led.gpiod);
> > +
> > +	device_child_property_read_string(dev, child, "label", &led.name);
> > +	device_child_property_read_string(dev, child, "linux,default-trigger",
> > +					  &led.default_trigger);
> > +
> > +	device_child_property_read_string(dev, child, "linux,default_state",
> > +					  &state);
> 
> Do we really want "linux," properties in ACPI tables?

Yes, we do.

"linux" here need not mean this is Linux-specific.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

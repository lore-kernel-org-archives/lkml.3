Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbaAHKTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:19:07 -0500
Received: from mo3.mail-out.ovh.net ([178.32.228.3]:47407 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbaAHKTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:19:04 -0500
Message-ID: <52CD25FE.8010701@overkiz.com>
Date: Wed, 08 Jan 2014 11:18:38 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Rob Landley <rob@landley.net>, Alexandre Courbot <gnurou@gmail.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [RFC PATCH] gpio: add GPIO hogging mechanism
References: <1387463671-1164-1-git-send-email-b.brezillon@overkiz.com>	<1387463671-1164-2-git-send-email-b.brezillon@overkiz.com> <CACRpkdb=atfrW+Wqbi17a1KhstS7XHkutuXsM24gL2VPEri_cw@mail.gmail.com>
In-Reply-To: <CACRpkdb=atfrW+Wqbi17a1KhstS7XHkutuXsM24gL2VPEri_cw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 2747477249324841181
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrvdelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrvdelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2014 10:37, Linus Walleij wrote:
> On Thu, Dec 19, 2013 at 3:34 PM, Boris BREZILLON
> <b.brezillon@overkiz.com> wrote:
>
>> GPIO hogging is a way to request and configure specific GPIO without
>> explicitly requesting it in the device driver.
>>
>> The request and configuration procedure is handled in the core device
>> driver code before the driver probe function is called.
> Why?

Because I obviously misunderstood your suggestion in our previous
discussion regarding the at91rm9200-ek board case :-)
( https://www.mail-archive.com/devicetree@vger.kernel.org/msg06838.html).

I thought you were suggesting to request GPIOs as PINCTRL configs are
requested, but apparently, you were just suggesting to directly request
the pins within the gpio controller.

Regarding the specific at91rm920-ek case, your solution should work
(as long as the gpio is configured before the SPI or MMC device is probed,
which should be the case), but the dependency between the SPI or MMC
device and the SPI/MMC switch pin is not represented in DT, and I'm not
happy with this.


Anyway, do you want me to rework the gpio hog as described below ?

Best Regards,

Boris
>
> Why can't these hogs be handled right after the gpio chip has been
> added in the end of the gpiochio_add() function?
>
>> +It might contain GPIO hog definitions. GPIO hogging is a mechanism providing
>> +automatic GPIO request and configuration before the device is passed to its
>> +driver probe function (the same mechanism is used for pinctrl pin config).
>> +
>> +Each GPIO hog definition is represented as a child node of the GPIO controller.
>> +Required properties:
>> +- gpio: store the gpio informations (id, flags, ...). Shall contain the
>> +  number of cells specified in its parent node (GPIO controller node).
> This property is alway plural "gpios".
>
>> +- hog-as-input or hog-as-output: a boolean property specifying the GPIO
>> +  direction.
>> +- hog-init-high or hog-init-low: a boolean property specifying the GPIO
>> +  value in case the GPIO is hogged as output.
> What about just having these three:
>
> hog-as-input
> hog-as-output-high
> hog-as-output-low
>
>> +Optional properties:
>> +- open-drain-line: GPIO is configured as an open drain pin.
>> +- open-source-line: GPIO is configured as an open source pin.
> Can you not simply us the flags in the second cell for the gpios
> property for this, normally?
>
>> +- export-line or export-line-fixed: the GPIO is exported to userspace via
>> +  sysfs.
> Move this feature to a separate patch. It is much more controversial
> than the hog concept as such.
>
>> +- line-name: the GPIO label name.
> OK.
>
>> @@ -66,6 +95,19 @@ Example of two SOC GPIO banks defined as gpio-controller nodes:
>>                  compatible = "fsl,qe-pario-bank-a", "fsl,qe-pario-bank";
>>                  reg = <0x1400 0x18>;
>>                  gpio-controller;
>> +               gpio-hogs = <&exported_gpio>;
>> +
>> +               line_a: line-a {
>> +                       gpio = <5 0>;
>> +                       hog-as-input;
>> +                       line-name = "line-a";
>> +               };
>> +
>> +               exported_gpio: exported-gpio {
>> +                       gpio = <6 0>;
>> +                       hog-as-output;
>> +                       line-name = "exported-gpio";
>> +               };
> This looks pretty straight-forward to use, but need the DT maintainers
> to provide input on this.
>
>>          };
>>
>>          qe_pio_e: gpio-controller@1460 {
>> @@ -75,6 +117,11 @@ Example of two SOC GPIO banks defined as gpio-controller nodes:
>>                  gpio-controller;
>>          };
>>
>> +       pio_consumer {
>> +               gpio-hogs = <&line_a>;
>> +               gpio-hog-names = "my-line-a";
>> +       };
> No. No way. That is not what hogs is about. It is not to make consumers
> get their GPIOs grabbed automatically when probing. It is *only* about
> making it possible for the core to set up a few GPIO lines *not* belonging
> to any particular in-kernel device when probing the GPIO chip.
>
> For providing GPIOs to consumers, use the existing OF bindings and
> add code to the drivers to handle them. A device needs to keep track
> of its resources.
>
> In any case, such concepts would be a totally separate patch.
>
>> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> NAK on this, hogs shall be a GPIO-intrinsic.
>
>> @@ -142,6 +175,9 @@ int devm_gpio_request(struct device *dev, unsigned gpio, const char *label)
>>          if (!dr)
>>                  return -ENOMEM;
>>
>> +       if (gpio_is_hogged(dev, gpio))
>> +               return 0;
>> +
>>          rc = gpio_request(gpio, label);
>>          if (rc) {
>>                  devres_free(dr);
>> @@ -172,6 +208,9 @@ int devm_gpio_request_one(struct device *dev, unsigned gpio,
>>          if (!dr)
>>                  return -ENOMEM;
>>
>> +       if (gpio_is_hogged(dev, gpio))
>> +               return 0;
>> +
> This just makes it impossible to release these resources. Don't do this.
>
> Hogs should be tied to a certain GPIO chip, get hogged when the
> chip is added and get removed when the chip is removed.
>
>> + * of_gpio_hog_count() - Count a GPIO hogs on a specific device node
>> + * @np:                device node to get GPIO from
>> + *
>> + * Returns the number of GPIO hogs requested by this device node.
>> + */
>> +int of_gpio_hog_count(struct device_node *np)
>> +{
>> +       int size;
>> +
>> +       if (!of_get_property(np, "gpio-hogs", &size))
>> +               return 0;
>> +
>> +       return size / sizeof(phandle);
>> +}
>> +EXPORT_SYMBOL(of_gpio_hog_count);
> There is no reason to export this, it should be static, gpiolib-internal.
>
>> +EXPORT_SYMBOL(of_get_gpio_hog);
> Dito.
>
>> @@ -1214,6 +1216,17 @@ int gpiochip_add(struct gpio_chip *chip)
>>
>>          of_gpiochip_add(chip);
>>
>> +       /* Instantiate missing GPIO hogs */
>> +       if (chip->dev->gpios) {
>> +               for (i = 0; i < chip->dev->gpios->ngpios; i++) {
>> +                       if (chip->dev->gpios->gpios[i])
>> +                               continue;
>> +                       desc = devm_gpiod_get_hog_index(chip->dev, i);
>> +                       if (!IS_ERR(desc))
>> +                               chip->dev->gpios->gpios[i] = desc;
>> +               }
>> +       }
> This is the only thing you should be doing.
>
>> @@ -2421,6 +2434,7 @@ struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
>>          struct gpio_desc *desc = NULL;
>>          int status;
>>          enum gpio_lookup_flags flags = 0;
>> +       int i;
>>
>>          dev_dbg(dev, "GPIO lookup for consumer %s\n", con_id);
>>
>> @@ -2451,6 +2465,13 @@ struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
>>                  return desc;
>>          }
>>
>> +       if (dev->gpios) {
>> +               for (i = 0; i < dev->gpios->ngpios; i++) {
>> +                       if (dev->gpios->gpios[i] == desc)
>> +                               return desc;
>> +               }
>> +       }
> Don't do this. We already have explicit gpio resource management.
> Don't attempt to make it implicit.
>
>> +EXPORT_SYMBOL_GPL(gpiod_get_hog_index);
> I don't understand this function at all.
>
>> +bool gpio_is_hogged(struct device *dev, unsigned gpio)
>> +{
>> +       return gpiod_is_hogged(dev, gpio_to_desc(gpio));
>> +}
>> +EXPORT_SYMBOL_GPL(gpio_is_hogged);
> This should not be exported.
>
>> +/**
>> + * gpio_hog_count - count number of GPIO hogs requested by a specific device
>> + * @dev:       GPIO consumer
>> + *
>> + * Return the number of GPIO hogs.
>> + */
>> +int gpio_hog_count(struct device *dev)
>> +{
>> +       /* Using device tree? */
>> +       if (IS_ENABLED(CONFIG_OF) && dev && dev->of_node)
>> +               return of_gpio_hog_count(dev->of_node);
>> +       return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(gpio_hog_count);
> Get rid of this.
>
>> +++ b/include/linux/device.h
>> @@ -22,6 +22,7 @@
>>   #include <linux/types.h>
>>   #include <linux/mutex.h>
>>   #include <linux/pinctrl/devinfo.h>
>> +#include <linux/gpio/devinfo.h>
>>   #include <linux/pm.h>
>>   #include <linux/atomic.h>
>>   #include <linux/ratelimit.h>
>> @@ -744,6 +745,10 @@ struct device {
>>          struct dev_pin_info     *pins;
>>   #endif
>>
>> +#ifdef CONFIG_GPIOLIB
>> +       struct dev_gpio_info    *gpios;
>> +#endif
> Don't do this.
>
> Overall it appears you try to make the device core grab all GPIOs automatically
> when devices are probed, this is not what GPIO hogs are about, and we already
> have a resource management model for GPIOs using the descriptors explicitly
> in the drivers, I see no reason to try to push that over to the device core.
>
> Yours,
> Linus Walleij


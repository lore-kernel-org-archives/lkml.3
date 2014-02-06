Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbaBFPzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:55:00 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49173 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaBFPy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:54:58 -0500
Message-ID: <1391702088.5008.19.camel@pizza.hi.pengutronix.de>
Subject: Re: [RFC PATCH] gpiolib: make gpiod_direction_output take a logical
 value, add gpiod_direction_output_raw
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Arnd Bergmann <arnd@arndb.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        kernel@pengutronix.de
Date: Thu, 06 Feb 2014 16:54:48 +0100
In-Reply-To: <CAAVeFuJwmUc3vZa2zVc8FTmStLknXpeZ3Wbc8LE7jday6BFdeQ@mail.gmail.com>
References: <1389094451-16628-1-git-send-email-p.zabel@pengutronix.de>
	 <CAAVeFuJwmUc3vZa2zVc8FTmStLknXpeZ3Wbc8LE7jday6BFdeQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Am Sonntag, den 12.01.2014, 16:44 +0900 schrieb Alexandre Courbot:
> Hi Philipp,
> 
> On Tue, Jan 7, 2014 at 8:34 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > The documentation was not clear about whether gpio_direction_output should take
> > a logical value or the physical level on the output line, i.e. whether the
> > ACTIVE_LOW status would be taken into account.
> > This converts gpiod_direction_output to use the logical level and adds a new
> > gpiod_direction_output_raw for the raw value.
> 
> Thanks for taking the time to craft this! The patch seems to do
> exactly what we discussed and looks good to me. Maybe Linus can let us
> know what he thinks about it? Unless there are reasons against it, I
> think this should be merged ASAP as we want to gpiod API to converge
> to something stable ASAP.
> 
> Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>

could you have a look at this patch?

thanks
Philipp

> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  Documentation/gpio/consumer.txt |  1 +
> >  drivers/gpio/gpiolib.c          | 67 +++++++++++++++++++++++++++++------------
> >  include/asm-generic/gpio.h      |  2 +-
> >  include/linux/gpio/consumer.h   |  7 +++++
> >  4 files changed, 57 insertions(+), 20 deletions(-)
> >
> > diff --git a/Documentation/gpio/consumer.txt b/Documentation/gpio/consumer.txt
> > index 07c74a3..4dc4809 100644
> > --- a/Documentation/gpio/consumer.txt
> > +++ b/Documentation/gpio/consumer.txt
> > @@ -150,6 +150,7 @@ raw line value:
> >         void gpiod_set_raw_value(struct gpio_desc *desc, int value)
> >         int gpiod_get_raw_value_cansleep(const struct gpio_desc *desc)
> >         void gpiod_set_raw_value_cansleep(struct gpio_desc *desc, int value)
> > +       int gpiod_direction_output_raw(struct gpio_desc *desc, int value)
> >
> >  The active-low state of a GPIO can also be queried using the following call:
> >
> > diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> > index 85f772c..f04f1e6 100644
> > --- a/drivers/gpio/gpiolib.c
> > +++ b/drivers/gpio/gpiolib.c
> > @@ -330,9 +330,9 @@ static ssize_t gpio_direction_store(struct device *dev,
> >         if (!test_bit(FLAG_EXPORT, &desc->flags))
> >                 status = -EIO;
> >         else if (sysfs_streq(buf, "high"))
> > -               status = gpiod_direction_output(desc, 1);
> > +               status = gpiod_direction_output_raw(desc, 1);
> >         else if (sysfs_streq(buf, "out") || sysfs_streq(buf, "low"))
> > -               status = gpiod_direction_output(desc, 0);
> > +               status = gpiod_direction_output_raw(desc, 0);
> >         else if (sysfs_streq(buf, "in"))
> >                 status = gpiod_direction_input(desc);
> >         else
> > @@ -1579,7 +1579,7 @@ int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
> >         if (flags & GPIOF_DIR_IN)
> >                 err = gpiod_direction_input(desc);
> >         else
> > -               err = gpiod_direction_output(desc,
> > +               err = gpiod_direction_output_raw(desc,
> >                                 (flags & GPIOF_INIT_HIGH) ? 1 : 0);
> >
> >         if (err)
> > @@ -1744,28 +1744,13 @@ fail:
> >  }
> >  EXPORT_SYMBOL_GPL(gpiod_direction_input);
> >
> > -/**
> > - * gpiod_direction_output - set the GPIO direction to input
> > - * @desc:      GPIO to set to output
> > - * @value:     initial output value of the GPIO
> > - *
> > - * Set the direction of the passed GPIO to output, such as gpiod_set_value() can
> > - * be called safely on it. The initial value of the output must be specified.
> > - *
> > - * Return 0 in case of success, else an error code.
> > - */
> > -int gpiod_direction_output(struct gpio_desc *desc, int value)
> > +static int _gpiod_direction_output_raw(struct gpio_desc *desc, int value)
> >  {
> >         unsigned long           flags;
> >         struct gpio_chip        *chip;
> >         int                     status = -EINVAL;
> >         int offset;
> >
> > -       if (!desc || !desc->chip) {
> > -               pr_warn("%s: invalid GPIO\n", __func__);
> > -               return -EINVAL;
> > -       }
> > -
> >         /* GPIOs used for IRQs shall not be set as output */
> >         if (test_bit(FLAG_USED_AS_IRQ, &desc->flags)) {
> >                 gpiod_err(desc,
> > @@ -1827,6 +1812,50 @@ fail:
> >                 gpiod_dbg(desc, "%s: gpio status %d\n", __func__, status);
> >         return status;
> >  }
> > +
> > +/**
> > + * gpiod_direction_output_raw - set the GPIO direction to output
> > + * @desc:      GPIO to set to output
> > + * @value:     initial output value of the GPIO
> > + *
> > + * Set the direction of the passed GPIO to output, such as gpiod_set_value() can
> > + * be called safely on it. The initial value of the output must be specified
> > + * as raw value on the physical line without regard for the ACTIVE_LOW status.
> > + *
> > + * Return 0 in case of success, else an error code.
> > + */
> > +int gpiod_direction_output_raw(struct gpio_desc *desc, int value)
> > +{
> > +       if (!desc || !desc->chip) {
> > +               pr_warn("%s: invalid GPIO\n", __func__);
> > +               return -EINVAL;
> > +       }
> > +       return _gpiod_direction_output_raw(desc, value);
> > +}
> > +EXPORT_SYMBOL_GPL(gpiod_direction_output_raw);
> > +
> > +/**
> > + * gpiod_direction_output - set the GPIO direction to input
> > + * @desc:      GPIO to set to output
> > + * @value:     initial output value of the GPIO
> > + *
> > + * Set the direction of the passed GPIO to output, such as gpiod_set_value() can
> > + * be called safely on it. The initial value of the output must be specified
> > + * as the logical value of the GPIO, i.e. taking its ACTIVE_LOW status into
> > + * account.
> > + *
> > + * Return 0 in case of success, else an error code.
> > + */
> > +int gpiod_direction_output(struct gpio_desc *desc, int value)
> > +{
> > +       if (!desc || !desc->chip) {
> > +               pr_warn("%s: invalid GPIO\n", __func__);
> > +               return -EINVAL;
> > +       }
> > +       if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
> > +               value = !value;
> > +       return _gpiod_direction_output_raw(desc, value);
> > +}
> >  EXPORT_SYMBOL_GPL(gpiod_direction_output);
> >
> >  /**
> > diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> > index a5f56a0..23e3645 100644
> > --- a/include/asm-generic/gpio.h
> > +++ b/include/asm-generic/gpio.h
> > @@ -69,7 +69,7 @@ static inline int gpio_direction_input(unsigned gpio)
> >  }
> >  static inline int gpio_direction_output(unsigned gpio, int value)
> >  {
> > -       return gpiod_direction_output(gpio_to_desc(gpio), value);
> > +       return gpiod_direction_output_raw(gpio_to_desc(gpio), value);
> >  }
> >
> >  static inline int gpio_set_debounce(unsigned gpio, unsigned debounce)
> > diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
> > index 4d34dbb..3879943 100644
> > --- a/include/linux/gpio/consumer.h
> > +++ b/include/linux/gpio/consumer.h
> > @@ -36,6 +36,7 @@ void devm_gpiod_put(struct device *dev, struct gpio_desc *desc);
> >  int gpiod_get_direction(const struct gpio_desc *desc);
> >  int gpiod_direction_input(struct gpio_desc *desc);
> >  int gpiod_direction_output(struct gpio_desc *desc, int value);
> > +int gpiod_direction_output_raw(struct gpio_desc *desc, int value);
> >
> >  /* Value get/set from non-sleeping context */
> >  int gpiod_get_value(const struct gpio_desc *desc);
> > @@ -121,6 +122,12 @@ static inline int gpiod_direction_output(struct gpio_desc *desc, int value)
> >         WARN_ON(1);
> >         return -ENOSYS;
> >  }
> > +static inline int gpiod_direction_output_raw(struct gpio_desc *desc, int value)
> > +{
> > +       /* GPIO can never have been requested */
> > +       WARN_ON(1);
> > +       return -ENOSYS;
> > +}
> >
> >
> >  static inline int gpiod_get_value(const struct gpio_desc *desc)
> > --
> > 1.8.5.2
> >
> 



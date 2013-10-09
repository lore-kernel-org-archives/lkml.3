Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab3JIHxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 03:53:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:19924 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810Ab3JIHxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 03:53:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1062,1371106800"; 
   d="scan'208";a="372238028"
Date: Wed, 9 Oct 2013 10:58:30 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        rjw@rjwysocki.net, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Rob Landley <rob@landley.net>,
        linux-acpi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] gpiolib / ACPI: convert to gpiod interfaces
Message-ID: <20131009075830.GS3521@intel.com>
References: <1380639537-23406-1-git-send-email-mika.westerberg@linux.intel.com>
 <1380639537-23406-3-git-send-email-mika.westerberg@linux.intel.com>
 <CAAVeFuJZ3TwozZzpuHcYPDLjEsb2D_qvQADf85s3-eywYYHs8A@mail.gmail.com>
 <20131008084508.GI3521@intel.com>
 <CAAVeFu+_EUCs+70+WzCq530JUesrHzULi34mCf7-pRVVP1WV7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVeFu+_EUCs+70+WzCq530JUesrHzULi34mCf7-pRVVP1WV7g@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 09:24:50AM -0700, Alexandre Courbot wrote:
> On Tue, Oct 8, 2013 at 1:45 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > On Mon, Oct 07, 2013 at 09:54:13PM -0700, Alexandre Courbot wrote:
> >> > +struct gpio_desc *acpi_get_gpiod(char *path, int pin)
> >> >  {
> >> >         struct gpio_chip *chip;
> >> >         acpi_handle handle;
> >> > @@ -48,18 +49,15 @@ int acpi_get_gpio(char *path, int pin)
> >> >
> >> >         status = acpi_get_handle(NULL, path, &handle);
> >> >         if (ACPI_FAILURE(status))
> >> > -               return -ENODEV;
> >> > +               return ERR_PTR(-ENODEV);
> >> >
> >> >         chip = gpiochip_find(handle, acpi_gpiochip_find);
> >> >         if (!chip)
> >> > -               return -ENODEV;
> >> > +               return ERR_PTR(-ENODEV);
> >> >
> >> > -       if (!gpio_is_valid(chip->base + pin))
> >> > -               return -EINVAL;
> >> > -
> >> > -       return chip->base + pin;
> >> > +       return gpio_to_desc(chip->base + pin);
> >>
> >> I think you want to avoid using gpio_to_desc(). It is just a
> >> convenience function provided to ease the transition for consumers
> >> that still need to rely on GPIO numbers for some reason. The same
> >> applies to desc_to_gpio(), although the usage you are making of it
> >> (implemented fallbacks for the integer space) is the one that is
> >> intended.
> >>
> >> The last line could be changed to "return &chip->desc[pin];" after
> >> checking that 0 <= pin <= chip->ngpio.
> >
> > I tried that but it doesn't compile anymore :-(
> >
> > drivers/gpio/gpiolib-acpi.c: In function ‘acpi_get_gpiod’:
> > drivers/gpio/gpiolib-acpi.c:61:2: error: invalid use of undefined type ‘struct gpio_desc’
> > drivers/gpio/gpiolib-acpi.c:61:20: error: dereferencing pointer to incomplete type
> 
> Ah right, there is no way to know the size of a gpio_desc from here...
> Maybe I should make a gpiochip_get_desc(index) function accessible to
> drivers only that takes care of this. Another possibility would be to
> move this function into gpiolib.c but there are probably too many
> dependencies with ACPI for that.
> 
> In the long term I would like to see gpio_to_desc()/desc_to_gpio()
> disappear from the consumer interface as they allow unsafe use of GPIO
> descriptors.
> 
> > The DT version also uses gpio_to_desc().
> 
> That seems to speak in favor of that gpiochip_get_desc() function I
> talked about earlier.

OK, I can convert the ACPI code to use that once such function exists. I
the meanwhile, can I use gpio_to_desc() in the next revision of the
patches?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab3JHQZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:25:15 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:33201 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3JHQZL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:25:11 -0400
MIME-Version: 1.0
In-Reply-To: <20131008084508.GI3521@intel.com>
References: <1380639537-23406-1-git-send-email-mika.westerberg@linux.intel.com>
 <1380639537-23406-3-git-send-email-mika.westerberg@linux.intel.com>
 <CAAVeFuJZ3TwozZzpuHcYPDLjEsb2D_qvQADf85s3-eywYYHs8A@mail.gmail.com> <20131008084508.GI3521@intel.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 8 Oct 2013 09:24:50 -0700
Message-ID: <CAAVeFu+_EUCs+70+WzCq530JUesrHzULi34mCf7-pRVVP1WV7g@mail.gmail.com>
Subject: Re: [PATCH 2/5] gpiolib / ACPI: convert to gpiod interfaces
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        rjw@rjwysocki.net, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Rob Landley <rob@landley.net>,
        linux-acpi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 1:45 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Mon, Oct 07, 2013 at 09:54:13PM -0700, Alexandre Courbot wrote:
>> > +struct gpio_desc *acpi_get_gpiod(char *path, int pin)
>> >  {
>> >         struct gpio_chip *chip;
>> >         acpi_handle handle;
>> > @@ -48,18 +49,15 @@ int acpi_get_gpio(char *path, int pin)
>> >
>> >         status = acpi_get_handle(NULL, path, &handle);
>> >         if (ACPI_FAILURE(status))
>> > -               return -ENODEV;
>> > +               return ERR_PTR(-ENODEV);
>> >
>> >         chip = gpiochip_find(handle, acpi_gpiochip_find);
>> >         if (!chip)
>> > -               return -ENODEV;
>> > +               return ERR_PTR(-ENODEV);
>> >
>> > -       if (!gpio_is_valid(chip->base + pin))
>> > -               return -EINVAL;
>> > -
>> > -       return chip->base + pin;
>> > +       return gpio_to_desc(chip->base + pin);
>>
>> I think you want to avoid using gpio_to_desc(). It is just a
>> convenience function provided to ease the transition for consumers
>> that still need to rely on GPIO numbers for some reason. The same
>> applies to desc_to_gpio(), although the usage you are making of it
>> (implemented fallbacks for the integer space) is the one that is
>> intended.
>>
>> The last line could be changed to "return &chip->desc[pin];" after
>> checking that 0 <= pin <= chip->ngpio.
>
> I tried that but it doesn't compile anymore :-(
>
> drivers/gpio/gpiolib-acpi.c: In function ‘acpi_get_gpiod’:
> drivers/gpio/gpiolib-acpi.c:61:2: error: invalid use of undefined type ‘struct gpio_desc’
> drivers/gpio/gpiolib-acpi.c:61:20: error: dereferencing pointer to incomplete type

Ah right, there is no way to know the size of a gpio_desc from here...
Maybe I should make a gpiochip_get_desc(index) function accessible to
drivers only that takes care of this. Another possibility would be to
move this function into gpiolib.c but there are probably too many
dependencies with ACPI for that.

In the long term I would like to see gpio_to_desc()/desc_to_gpio()
disappear from the consumer interface as they allow unsafe use of GPIO
descriptors.

> The DT version also uses gpio_to_desc().

That seems to speak in favor of that gpiochip_get_desc() function I
talked about earlier.

Thanks,
Alex.

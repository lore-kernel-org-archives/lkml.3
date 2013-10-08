Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab3JHEyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 00:54:36 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:53215 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab3JHEye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 00:54:34 -0400
MIME-Version: 1.0
In-Reply-To: <1380639537-23406-3-git-send-email-mika.westerberg@linux.intel.com>
References: <1380639537-23406-1-git-send-email-mika.westerberg@linux.intel.com>
 <1380639537-23406-3-git-send-email-mika.westerberg@linux.intel.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 7 Oct 2013 21:54:13 -0700
Message-ID: <CAAVeFuJZ3TwozZzpuHcYPDLjEsb2D_qvQADf85s3-eywYYHs8A@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 1, 2013 at 7:58 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> The new GPIO descriptor based interface is now preferred over the old
> integer based one. This patch converts the ACPI GPIO helpers to use this
> new interface internally. In addition to that provide compatibility
> functions acpi_get_gpio() and acpi_get_gpio_by_index() that convert the
> returned GPIO descriptors to integers.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/gpio/gpiolib-acpi.c | 51 +++++++++++++++++++++------------------------
>  include/linux/acpi_gpio.h   | 38 ++++++++++++++++++++++++++-------
>  2 files changed, 54 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> index 1745ce5..333297c 100644
> --- a/drivers/gpio/gpiolib-acpi.c
> +++ b/drivers/gpio/gpiolib-acpi.c
> @@ -11,7 +11,7 @@
>   */
>
>  #include <linux/errno.h>
> -#include <linux/gpio.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/export.h>
>  #include <linux/acpi_gpio.h>
>  #include <linux/acpi.h>
> @@ -33,14 +33,15 @@ static int acpi_gpiochip_find(struct gpio_chip *gc, void *data)
>  }
>
>  /**
> - * acpi_get_gpio() - Translate ACPI GPIO pin to GPIO number usable with GPIO API
> + * acpi_get_gpiod() - Translate ACPI GPIO pin to GPIO descriptor usable with GPIO API
>   * @path:      ACPI GPIO controller full path name, (e.g. "\\_SB.GPO1")
>   * @pin:       ACPI GPIO pin number (0-based, controller-relative)
>   *
> - * Returns GPIO number to use with Linux generic GPIO API, or errno error value
> + * Returns GPIO descriptor to use with Linux generic GPIO API, or ERR_PTR
> + * error value
>   */
>
> -int acpi_get_gpio(char *path, int pin)
> +struct gpio_desc *acpi_get_gpiod(char *path, int pin)
>  {
>         struct gpio_chip *chip;
>         acpi_handle handle;
> @@ -48,18 +49,15 @@ int acpi_get_gpio(char *path, int pin)
>
>         status = acpi_get_handle(NULL, path, &handle);
>         if (ACPI_FAILURE(status))
> -               return -ENODEV;
> +               return ERR_PTR(-ENODEV);
>
>         chip = gpiochip_find(handle, acpi_gpiochip_find);
>         if (!chip)
> -               return -ENODEV;
> +               return ERR_PTR(-ENODEV);
>
> -       if (!gpio_is_valid(chip->base + pin))
> -               return -EINVAL;
> -
> -       return chip->base + pin;
> +       return gpio_to_desc(chip->base + pin);

I think you want to avoid using gpio_to_desc(). It is just a
convenience function provided to ease the transition for consumers
that still need to rely on GPIO numbers for some reason. The same
applies to desc_to_gpio(), although the usage you are making of it
(implemented fallbacks for the integer space) is the one that is
intended.

The last line could be changed to "return &chip->desc[pin];" after
checking that 0 <= pin <= chip->ngpio.

This minor issue apart, I really like the fact you are moving this
under the gpiolib APIs (also appreciate the testing of the new API
this patchset provides!).

I also wonder whether you could also avoid exporting acpi_get_gpiod*
(which allow GPIO consumers to shortcut gpiolib) by implementing
acpi_get_gpio* into the C file (maybe even using gpiod_get()). I see a
"char *path" parameter though, so maybe that would not be possible at
the moment.

Once the gpio_to_desc() issue mentioned above is fixed I think I can give my

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>

on patches 2-5.

Thanks,
Alex.

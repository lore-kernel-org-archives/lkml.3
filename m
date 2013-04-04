Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab3DDJT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:19:57 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:52172 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3DDJTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:19:55 -0400
MIME-Version: 1.0
In-Reply-To: <1364986614-15711-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1364986614-15711-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Thu, 4 Apr 2013 11:19:53 +0200
Message-ID: <CAN+gG=F4LMHMsOqVh+BikSLKBJ8V7ni-p4hKi7yRb4jjD7gv0w@mail.gmail.com>
Subject: Re: [PATCH] gpiolib-acpi: introduce acpi_get_gpio_by_index() helper
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mika,

On Wed, Apr 3, 2013 at 12:56 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> Instead of open-coding ACPI GPIO resource lookup in each driver, we provide
> a helper function analogous to Device Tree version that allows drivers to
> specify which GPIO resource they are interested (using an index to the GPIO
> resources). The function then finds out the correct resource, translates
> the ACPI GPIO number to the corresponding Linux GPIO number and returns
> that.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  Documentation/acpi/enumeration.txt |   32 ++++++++++++++-
>  drivers/gpio/gpiolib-acpi.c        |   77 ++++++++++++++++++++++++++++++++++++
>  include/linux/acpi_gpio.h          |   17 ++++++++
>  3 files changed, 125 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/acpi/enumeration.txt b/Documentation/acpi/enumeration.txt
> index 94a6561..b0d5410 100644
> --- a/Documentation/acpi/enumeration.txt
> +++ b/Documentation/acpi/enumeration.txt
> @@ -199,6 +199,8 @@ the device to the driver. For example:
>         {
>                 Name (SBUF, ResourceTemplate()
>                 {
> +                       ...
> +                       // Used to power on/off the device
>                         GpioIo (Exclusive, PullDefault, 0x0000, 0x0000,
>                                 IoRestrictionOutputOnly, "\\_SB.PCI0.GPI0",
>                                 0x00, ResourceConsumer,,)
> @@ -206,10 +208,20 @@ the device to the driver. For example:
>                                 // Pin List
>                                 0x0055
>                         }
> +
> +                       // Interrupt for the device
> +                       GpioInt (Edge, ActiveHigh, ExclusiveAndWake, PullNone,
> +                                0x0000, "\\_SB.PCI0.GPI0", 0x00, ResourceConsumer,,)

Sorry for coming late in the GPIO ACPI discussion, but when I see this
documentation, I wonder:
wouldn't it be feasible to find the correct GPIO by its type? Here, we
have a GpioIo and a GpioInt, and I bet this would be sometime more
useful to request the first GpioInt without knowing the correct order
of declarations.

It may be feasible by walking the tree, but a helper would be of great
help (thinking at i2c-hid here, which can not rely on indexes in the
DSDT).

Cheers,
Benjamin

> +                       {
> +                               // Pin list
> +                               0x0058
> +                       }
> +
>                         ...
>
> -                       Return (SBUF)
>                 }
> +
> +               Return (SBUF)
>         }
>
>  These GPIO numbers are controller relative and path "\\_SB.PCI0.GPI0"
> @@ -220,6 +232,24 @@ The driver can do this by including <linux/acpi_gpio.h> and then calling
>  acpi_get_gpio(path, gpio). This will return the Linux GPIO number or
>  negative errno if there was no translation found.
>
> +In a simple case of just getting the Linux GPIO number from device
> +resources one can use acpi_get_gpio_by_index() helper function. It takes
> +pointer to the device and index of the GpioIo/GpioInt descriptor in the
> +device resources list. For example:
> +
> +       int gpio_irq, gpio_power;
> +       int ret;
> +
> +       gpio_irq = acpi_get_gpio_by_index(dev, 1, NULL);
> +       if (gpio_irq < 0)
> +               /* handle error */
> +
> +       gpio_power = acpi_get_gpio_by_index(dev, 0, NULL);
> +       if (gpio_power < 0)
> +               /* handle error */
> +
> +       /* Now we can use the GPIO numbers */
> +
>  Other GpioIo parameters must be converted first by the driver to be
>  suitable to the gpiolib before passing them.
>
[snipped]

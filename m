Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab3KWJVc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 04:21:32 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:34996 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3KWJV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 04:21:26 -0500
MIME-Version: 1.0
In-Reply-To: <1385122474-14926-7-git-send-email-mika.westerberg@linux.intel.com>
References: <1385122474-14926-1-git-send-email-mika.westerberg@linux.intel.com>
 <1385122474-14926-7-git-send-email-mika.westerberg@linux.intel.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sat, 23 Nov 2013 18:21:03 +0900
Message-ID: <CAAVeFuK_76Rnqa8E0DpME8Eyc3vh63HmyHx=zbeyaKz7aXm=rA@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] gpio / ACPI: get rid of acpi_gpio.h
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 9:14 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> Now that all users of acpi_gpio.h have been moved to user either the GPIO

s/user/use

> descriptor interface or to the internal gpiolib.h we can get rid of

gpiolib.h will also need to be renamed if you follow my suggestion below.

> acpi_gpio.h entirely.
>
> Once this is done the only interface to get GPIOs to drivers enumerated
> from ACPI namespace is the descriptor based interface.

Oh, do I like this. :)

>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/gpio/gpiolib-acpi.c |  4 +++-
>  drivers/gpio/gpiolib.c      |  1 -
>  drivers/gpio/gpiolib.h      | 23 +++++++++++++++++++++++
>  include/linux/acpi_gpio.h   | 45 ---------------------------------------------
>  4 files changed, 26 insertions(+), 47 deletions(-)
>  delete mode 100644 include/linux/acpi_gpio.h
>
> diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> index cb2da66fbbfe..6c158d9a6efa 100644
> --- a/drivers/gpio/gpiolib-acpi.c
> +++ b/drivers/gpio/gpiolib-acpi.c
> @@ -12,11 +12,13 @@
>
>  #include <linux/errno.h>
>  #include <linux/gpio/consumer.h>
> +#include <linux/gpio/driver.h>
>  #include <linux/export.h>
> -#include <linux/acpi_gpio.h>
>  #include <linux/acpi.h>
>  #include <linux/interrupt.h>
>
> +#include "gpiolib.h"
> +
>  struct acpi_gpio_evt_pin {
>         struct list_head node;
>         acpi_handle *evt_handle;
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 70abccf0d144..a6b82413c290 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -10,7 +10,6 @@
>  #include <linux/seq_file.h>
>  #include <linux/gpio.h>
>  #include <linux/of_gpio.h>
> -#include <linux/acpi_gpio.h>
>  #include <linux/idr.h>
>  #include <linux/slab.h>
>  #include <linux/acpi.h>
> diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
> index 2ed23ab8298c..82be586c1f90 100644
> --- a/drivers/gpio/gpiolib.h
> +++ b/drivers/gpio/gpiolib.h
> @@ -12,12 +12,35 @@
>  #ifndef GPIOLIB_H
>  #define GPIOLIB_H
>
> +#include <linux/err.h>
> +#include <linux/device.h>
> +
> +/**
> + * struct acpi_gpio_info - ACPI GPIO specific information
> + * @gpioint: if %true this GPIO is of type GpioInt otherwise type is GpioIo
> + * @active_low: in case of @gpioint, the pin is active low
> + */
> +struct acpi_gpio_info {
> +       bool gpioint;
> +       bool active_low;
> +};
> +
>  #ifdef CONFIG_ACPI
>  void acpi_gpiochip_add(struct gpio_chip *chip);
>  void acpi_gpiochip_remove(struct gpio_chip *chip);
> +
> +struct gpio_desc *acpi_get_gpiod_by_index(struct device *dev, int index,
> +                                         struct acpi_gpio_info *info);
>  #else
>  static inline void acpi_gpiochip_add(struct gpio_chip *chip) { }
>  static inline void acpi_gpiochip_remove(struct gpio_chip *chip) { }
> +
> +static inline struct gpio_desc *
> +acpi_get_gpiod_by_index(struct device *dev, int index,
> +                       struct acpi_gpio_info *info)
> +{
> +       return ERR_PTR(-ENOSYS);
> +}
>  #endif

Since this header contains purely ACPI-related declarations so far, I wonder
if it should not be renamed acpi.h?

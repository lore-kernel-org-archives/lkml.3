Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690Ab3BINMF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 08:12:05 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:52406 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab3BINMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 08:12:03 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 6/9] gpiolib: use descriptors internally
To: Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
In-Reply-To: <1359822572-26009-8-git-send-email-acourbot@nvidia.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com> <1359822572-26009-8-git-send-email-acourbot@nvidia.com>
Date: Sat, 09 Feb 2013 13:11:58 +0000
Message-Id: <20130209131158.22FD53E30EC@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  3 Feb 2013 01:29:29 +0900, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Make sure gpiolib works internally with descriptors and (chip, offset)
> pairs instead of using the global integer namespace. This prepares the
> ground for the removal of the global gpio_desc[] array and the
> introduction of the descriptor-based GPIO API.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpio/gpiolib.c | 493 +++++++++++++++++++++++++++++++------------------
>  1 file changed, 317 insertions(+), 176 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index af4c350..82c40bd 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -78,6 +78,28 @@ static LIST_HEAD(gpio_chips);
>  static DEFINE_IDR(dirent_idr);
>  #endif
>  
> +/*
> + * Internal gpiod_* API using descriptors instead of the integer namespace.
> + * Most of this should eventually go public.
> + */
> +static int gpiod_request(struct gpio_desc *desc, const char *label);
> +static void gpiod_free(struct gpio_desc *desc);
> +static int gpiod_direction_input(struct gpio_desc *desc);
> +static int gpiod_direction_output(struct gpio_desc *desc, int value);
> +static int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce);
> +static int gpiod_get_value_cansleep(struct gpio_desc *desc);
> +static void gpiod_set_value_cansleep(struct gpio_desc *desc, int value);
> +static int gpiod_get_value(struct gpio_desc *desc);
> +static void gpiod_set_value(struct gpio_desc *desc, int value);
> +static int gpiod_cansleep(struct gpio_desc *desc);
> +static int gpiod_to_irq(struct gpio_desc *desc);
> +static int gpiod_export(struct gpio_desc *desc, bool direction_may_change);
> +static int gpiod_export_link(struct device *dev, const char *name,
> +			     struct gpio_desc *desc);
> +static int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value);
> +static void gpiod_unexport(struct gpio_desc *desc);

I've been thinking about the adding of a new API to supplant the old,
and I'm wondering if we're going about this the wrong way around; at
least for the public api. We've moved to a model where device drivers
are really supposed to tread GPIO numbers as opaque handles. Most device
drivers are well behaved on this point. (Others of course are not so
well behaved and either hard code or interpret what a number means, but
those users already need to be fixed before they will work with the
device tree)

Rather than creating a new API with a long-term-plan to move all old
users to the new API - touching a lot of code all over the kernel in the
process - what if we repurposed the existing API in a backwards
compatible way.

I think the maximum GPIO number I've seen in use is 65535, and that was
based on dynamic allocation. What if we did the following:

typedef unsigned long gpio_handle_t;

struct gpio_desc *gpio_handle_to_desc(gpio_handle_t gpio)
{
	if (gpio <= NR_GPIOS)
		return &gpio_desc[gpio];
	return (struct gpio_desc *)gpio;
}

int gpio_get_direction(gpio_handle_t gpio)
{
	struct gpio_desc *desc = gpio_handle_to_desc(gpio);
	if (!desc)
		return -EEXIST;
	return gpiod_get_direction(desc);
}

And do the same for all the other hooks. That will make the gpio changes
much lower impact across the kernel, allow legacy gpio users to keep
doing what they are doing, and encourage driver authors to keep out of
the gpio_desc internals.

Thoughts?

I'm probably going to apply this patch anyway because it only affects
the gpiolib internals, I need to take one more look over it before I
make a decision. I want to get as much of this as possible queued up for
v3.9 to make future work easier.

g.

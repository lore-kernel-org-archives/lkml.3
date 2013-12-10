Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab3LJP3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:29:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:38015 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147Ab3LJP3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:29:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,865,1378882800"; 
   d="scan'208";a="447720678"
Message-ID: <1386689291.1871.169.camel@smile>
Subject: Re: [PATCH v2] gpiolib: return -ENOENT if no GPIO mapping exists
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 10 Dec 2013 17:28:11 +0200
In-Reply-To: <1386686247-24592-1-git-send-email-acourbot@nvidia.com>
References: <1386686247-24592-1-git-send-email-acourbot@nvidia.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 23:37 +0900, Alexandre Courbot wrote:
> Some devices drivers make use of optional GPIO parameters. For such
> drivers, it is important to discriminate between the case where no
> GPIO mapping has been defined for the function they are requesting, and
> the case where a mapping exists but an error occured while resolving it
> or when acquiring the GPIO.
> 
> This patch changes the family of gpiod_get() functions such that they
> will return -ENOENT if and only if no GPIO mapping is defined for the
> requested function. Other error codes are used when an actual error
> occured during the GPIO resolution.
> 

One minor comment below.
Independently on that:

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> Changes since v1:
> - Rebase on top of Linus' devel tree
> - Fixed error reporting as suggested by Andy
> ---
>  Documentation/gpio/consumer.txt |  6 +++++-
>  drivers/gpio/gpiolib.c          | 33 ++++++++++++++++-----------------
>  2 files changed, 21 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/gpio/consumer.txt b/Documentation/gpio/consumer.txt
> index 07c74a3..e42f77d 100644
> --- a/Documentation/gpio/consumer.txt
> +++ b/Documentation/gpio/consumer.txt
> @@ -38,7 +38,11 @@ device that displays digits), an additional index argument can be specified:
>  					  const char *con_id, unsigned int idx)
>  
>  Both functions return either a valid GPIO descriptor, or an error code checkable
> -with IS_ERR(). They will never return a NULL pointer.
> +with IS_ERR() (they will never return a NULL pointer). -ENOENT will be returned
> +if and only if no GPIO has been assigned to the device/function/index triplet,
> +other error codes are used for cases where a GPIO has been assigned but an error
> +occured while trying to acquire it. This is useful to discriminate between mere
> +errors and an absence of GPIO for optional GPIO parameters.
>  
>  Device-managed variants of these functions are also defined:
>  
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 12e47df..32a6e3a 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -2367,7 +2367,7 @@ static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
>  				    unsigned int idx,
>  				    enum gpio_lookup_flags *flags)
>  {
> -	struct gpio_desc *desc = ERR_PTR(-ENODEV);
> +	struct gpio_desc *desc = ERR_PTR(-ENOENT);
>  	struct gpiod_lookup_table *table;
>  	struct gpiod_lookup *p;
>  
> @@ -2389,19 +2389,21 @@ static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
>  		chip = find_chip_by_name(p->chip_label);
>  
>  		if (!chip) {
> -			dev_warn(dev, "cannot find GPIO chip %s\n",
> -				 p->chip_label);
> -			continue;
> +			dev_err(dev, "cannot find GPIO chip %s\n",
> +				p->chip_label);
> +			return ERR_PTR(-ENODEV);
>  		}
>  
>  		if (chip->ngpio <= p->chip_hwnum) {
> -			dev_warn(dev, "GPIO chip %s has %d GPIOs\n",
> -				 chip->label, chip->ngpio);
> -			continue;
> +			dev_err(dev, "requested GPIO %d is out of range [0..%d]"
> +			       " for chip %s\n", idx, chip->ngpio, chip->label);

You may leave string literals over 80 character border. chackpatch.pl
will not complain about.

I might put a) 'dev_warn(dev,', b) '"..."', and c) 'the rest'
on three separate lines.

> +			return ERR_PTR(-EINVAL);
>  		}
>  
>  		desc = gpiochip_offset_to_desc(chip, p->chip_hwnum);
>  		*flags = p->flags;
> +
> +		return desc;
>  	}
>  
>  	return desc;
> @@ -2413,7 +2415,8 @@ static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
>   * @con_id:	function within the GPIO consumer
>   *
>   * Return the GPIO descriptor corresponding to the function con_id of device
> - * dev, or an IS_ERR() condition if an error occured.
> + * dev, -ENOENT if no GPIO has been assigned to the requested function, or
> + * another IS_ERR() code if an error occured while trying to acquire the GPIO.
>   */
>  struct gpio_desc *__must_check gpiod_get(struct device *dev, const char *con_id)
>  {
> @@ -2430,7 +2433,9 @@ EXPORT_SYMBOL_GPL(gpiod_get);
>   * This variant of gpiod_get() allows to access GPIOs other than the first
>   * defined one for functions that define several GPIOs.
>   *
> - * Return a valid GPIO descriptor, or an IS_ERR() condition in case of error.
> + * Return a valid GPIO descriptor, -ENOENT if no GPIO has been assigned to the
> + * requested function and/or index, or another IS_ERR() code if an error
> + * occured while trying to acquire the GPIO.
>   */
>  struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
>  					       const char *con_id,
> @@ -2455,15 +2460,9 @@ struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
>  	 * Either we are not using DT or ACPI, or their lookup did not return
>  	 * a result. In that case, use platform lookup as a fallback.
>  	 */
> -	if (!desc || IS_ERR(desc)) {
> -		struct gpio_desc *pdesc;
> -
> +	if (!desc || desc == ERR_PTR(-ENOENT)) {
>  		dev_dbg(dev, "using lookup tables for GPIO lookup");
> -		pdesc = gpiod_find(dev, con_id, idx, &flags);
> -
> -		/* If used as fallback, do not replace the previous error */
> -		if (!IS_ERR(pdesc) || !desc)
> -			desc = pdesc;
> +		desc = gpiod_find(dev, con_id, idx, &flags);
>  	}
>  
>  	if (IS_ERR(desc)) {

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy


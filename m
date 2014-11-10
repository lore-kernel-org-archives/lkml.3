Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbaKJP3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:29:42 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:55391 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbaKJP3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:29:41 -0500
Date: Mon, 10 Nov 2014 15:29:35 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: tc3589x: get rid of static base
Message-ID: <20141110152935.GG24004@x1>
References: <1414490816-13574-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414490816-13574-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014, Linus Walleij wrote:

> The TC3589x driver is now a device tree-only driver, so we want
> only dynamic IRQs and GPIO numbers from the tc3589x, no static
> assignments.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/gpio/gpio-tc3589x.c | 2 +-
>  drivers/mfd/tc3589x.c       | 9 +++------
>  include/linux/mfd/tc3589x.h | 8 --------
>  3 files changed, 4 insertions(+), 15 deletions(-)

Applied, thanks.

> diff --git a/drivers/gpio/gpio-tc3589x.c b/drivers/gpio/gpio-tc3589x.c
> index ae0f6466eb09..abdcf58935f5 100644
> --- a/drivers/gpio/gpio-tc3589x.c
> +++ b/drivers/gpio/gpio-tc3589x.c
> @@ -262,7 +262,7 @@ static int tc3589x_gpio_probe(struct platform_device *pdev)
>  	tc3589x_gpio->chip = template_chip;
>  	tc3589x_gpio->chip.ngpio = tc3589x->num_gpio;
>  	tc3589x_gpio->chip.dev = &pdev->dev;
> -	tc3589x_gpio->chip.base = (pdata) ? pdata->gpio_base : -1;
> +	tc3589x_gpio->chip.base = -1;
>  
>  #ifdef CONFIG_OF_GPIO
>  	tc3589x_gpio->chip.of_node = np;
> diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
> index 0072e668c208..aacb3720065c 100644
> --- a/drivers/mfd/tc3589x.c
> +++ b/drivers/mfd/tc3589x.c
> @@ -241,10 +241,8 @@ static struct irq_domain_ops tc3589x_irq_ops = {
>  
>  static int tc3589x_irq_init(struct tc3589x *tc3589x, struct device_node *np)
>  {
> -	int base = tc3589x->irq_base;
> -
>  	tc3589x->domain = irq_domain_add_simple(
> -		np, TC3589x_NR_INTERNAL_IRQS, base,
> +		np, TC3589x_NR_INTERNAL_IRQS, 0,
>  		&tc3589x_irq_ops, tc3589x);
>  
>  	if (!tc3589x->domain) {
> @@ -298,7 +296,7 @@ static int tc3589x_device_init(struct tc3589x *tc3589x)
>  	if (blocks & TC3589x_BLOCK_GPIO) {
>  		ret = mfd_add_devices(tc3589x->dev, -1, tc3589x_dev_gpio,
>  				      ARRAY_SIZE(tc3589x_dev_gpio), NULL,
> -				      tc3589x->irq_base, tc3589x->domain);
> +				      0, tc3589x->domain);
>  		if (ret) {
>  			dev_err(tc3589x->dev, "failed to add gpio child\n");
>  			return ret;
> @@ -309,7 +307,7 @@ static int tc3589x_device_init(struct tc3589x *tc3589x)
>  	if (blocks & TC3589x_BLOCK_KEYPAD) {
>  		ret = mfd_add_devices(tc3589x->dev, -1, tc3589x_dev_keypad,
>  				      ARRAY_SIZE(tc3589x_dev_keypad), NULL,
> -				      tc3589x->irq_base, tc3589x->domain);
> +				      0, tc3589x->domain);
>  		if (ret) {
>  			dev_err(tc3589x->dev, "failed to keypad child\n");
>  			return ret;
> @@ -404,7 +402,6 @@ static int tc3589x_probe(struct i2c_client *i2c,
>  	tc3589x->dev = &i2c->dev;
>  	tc3589x->i2c = i2c;
>  	tc3589x->pdata = pdata;
> -	tc3589x->irq_base = pdata->irq_base;
>  
>  	switch (version) {
>  	case TC3589X_TC35893:
> diff --git a/include/linux/mfd/tc3589x.h b/include/linux/mfd/tc3589x.h
> index e6088c2e2092..e1c12d84c26a 100644
> --- a/include/linux/mfd/tc3589x.h
> +++ b/include/linux/mfd/tc3589x.h
> @@ -164,13 +164,10 @@ struct tc3589x_keypad_platform_data {
>  
>  /**
>   * struct tc3589x_gpio_platform_data - TC3589x GPIO platform data
> - * @gpio_base: first gpio number assigned to TC3589x.  A maximum of
> - *	       %TC3589x_NR_GPIOS GPIOs will be allocated.
>   * @setup: callback for board-specific initialization
>   * @remove: callback for board-specific teardown
>   */
>  struct tc3589x_gpio_platform_data {
> -	int gpio_base;
>  	void (*setup)(struct tc3589x *tc3589x, unsigned gpio_base);
>  	void (*remove)(struct tc3589x *tc3589x, unsigned gpio_base);
>  };
> @@ -178,18 +175,13 @@ struct tc3589x_gpio_platform_data {
>  /**
>   * struct tc3589x_platform_data - TC3589x platform data
>   * @block: bitmask of blocks to enable (use TC3589x_BLOCK_*)
> - * @irq_base: base IRQ number.  %TC3589x_NR_IRQS irqs will be used.
>   * @gpio: GPIO-specific platform data
>   * @keypad: keypad-specific platform data
>   */
>  struct tc3589x_platform_data {
>  	unsigned int block;
> -	int irq_base;
>  	struct tc3589x_gpio_platform_data *gpio;
>  	const struct tc3589x_keypad_platform_data *keypad;
>  };
>  
> -#define TC3589x_NR_GPIOS	24
> -#define TC3589x_NR_IRQS		TC3589x_INT_GPIO(TC3589x_NR_GPIOS)
> -
>  #endif

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

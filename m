Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaIXMll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:41:41 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:44159 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbaIXMli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:41:38 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 24 Sep 2014 14:39:05 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org,
        arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v5 4/4] gpio: add support for the Diolan DLN-2 USB GPIO
 driver
Message-ID: <20140924123905.GB16198@localhost>
References: <1411158165-25794-1-git-send-email-octavian.purdila@intel.com>
 <1411158165-25794-5-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411158165-25794-5-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 11:22:45PM +0300, Octavian Purdila wrote:

> +struct dln2_gpio {
> +	struct platform_device *pdev;
> +	struct gpio_chip gpio;
> +
> +	/*
> +	 * Cache pin direction to save us one transfer, since the
> +	 * hardware has separate commands to read the in and out
> +	 * values. Bit set for out, bit clear for in.
> +	 */
> +	DECLARE_BITMAP(pin_dir, DLN2_GPIO_MAX_PINS);

Using the more common name output_enabled might be preferred? Then you
can even get rid of (part of) the comment.

> +
> +	DECLARE_BITMAP(irqs_masked, DLN2_GPIO_MAX_PINS);
> +	DECLARE_BITMAP(irqs_enabled, DLN2_GPIO_MAX_PINS);
> +	DECLARE_BITMAP(irqs_pending, DLN2_GPIO_MAX_PINS);
> +	struct dln2_irq_work *irq_work;
> +};

[...]

> +#define DLN2_GPIO_DIRECTION_IN		0
> +#define DLN2_GPIO_DIRECTION_OUT		1
> +
> +static int dln2_gpio_request(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct dln2_gpio *dln2 = container_of(chip, struct dln2_gpio, gpio);
> +	struct dln2_gpio_pin req = {
> +		.pin = cpu_to_le16(offset),
> +	};
> +	struct dln2_gpio_pin_val rsp;
> +	int len = sizeof(rsp);
> +	int ret;
> +
> +	ret = dln2_gpio_pin_cmd(dln2, DLN2_GPIO_PIN_ENABLE, offset);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* cache the pin direction */
> +	ret = dln2_transfer(dln2->pdev, DLN2_GPIO_PIN_GET_DIRECTION,
> +			    &req, sizeof(req), &rsp, &len);
> +	if (ret < 0)
> +		return ret;
> +	if (len < sizeof(rsp) || req.pin != rsp.pin)
> +		return -EPROTO;

Disable the pin?

> +
> +	switch (rsp.value) {
> +	case DLN2_GPIO_DIRECTION_IN:
> +		clear_bit(offset, dln2->pin_dir);
> +		return 0;
> +	case DLN2_GPIO_DIRECTION_OUT:
> +		set_bit(offset, dln2->pin_dir);
> +		return 0;
> +	default:
> +		return -EPROTO;

Disable the pin?

> +	}
> +}

[...]

> +static struct platform_driver dln2_gpio_driver = {
> +	.driver.name	= "dln2-gpio",
> +	.driver.owner	= THIS_MODULE,

No need to set the owner field when using the module_platform_driver
macro.

> +	.probe		= dln2_gpio_probe,
> +	.remove		= dln2_gpio_remove,
> +};
> +
> +module_platform_driver(dln2_gpio_driver);
> +
> +MODULE_AUTHOR("Daniel Baluta <daniel.baluta@intel.com");
> +MODULE_DESCRIPTION("Driver for the Diolan DLN2 GPIO interface");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:dln2-gpio");

Johan

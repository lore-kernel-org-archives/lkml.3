Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbaITCtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 22:49:15 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:58988 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaITCtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 22:49:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Octavian Purdila <octavian.purdila@intel.com>
Subject: Re: [PATCH v5 4/4] gpio: add support for the Diolan DLN-2 USB GPIO driver
Date: Sat, 20 Sep 2014 04:48:47 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org,
        johan@kernel.org, daniel.baluta@intel.com, laurentiu.palcu@intel.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org
References: <1411158165-25794-1-git-send-email-octavian.purdila@intel.com> <1411158165-25794-5-git-send-email-octavian.purdila@intel.com>
In-Reply-To: <1411158165-25794-5-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201409200448.48180.arnd@arndb.de>
X-Provags-ID: V02:K0:py/RzcqwPDzxCsS0sy7RFSVIB/72iWRS8LE+EgFoDkz
 I4pbQMT1wsEBOES8sz0wzl3C57g8ByTeAz7yGmOtV9jL964oFz
 4CC+swzRFOBmlJi/wKFuoNlbinuzzsAXk1iLOqPLJbOy4dKU++
 LClpSCnZNwGN8T8wvMABtnpvjjE5Inf1OIb9sV5kk1AiQDu+xI
 Q6aCwTj4lXmvYz0dBEPeCliLpMMFuk76jniTRYdKta96iuOMck
 7Ku/PiunX5ixlzrAifDKqszHE6mpk0JwEHkcI3j10A3DDbLW+r
 NbE5xSM4j3MvtsrHyPjCFsfFJZq2QNq6ko8SwX3ghfOBgcrJBT
 teLiOVoh4V+kIdlYrP88=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 September 2014, Octavian Purdila wrote:
> +struct dln2_gpio_pin {
> +	__le16 pin;
> +} __packed;

This does not need to be marked packed, since it is never embedded in another
structure.

> +struct dln2_gpio_pin_val {
> +	__le16 pin;
> +	u8 value;
> +} __packed;

It's enough here to mark just the 'pin' member as packed.

> +static int dln2_gpio_get_pin_count(struct platform_device *pdev)
> +{
> +	int ret;
> +	__le16 count;
> +	int len = sizeof(count);
> +
> +	ret = dln2_transfer(pdev, DLN2_GPIO_GET_PIN_COUNT, NULL, 0, &count,
> +			    &len);

You must not do a USB transaction on stack memory.

> +static int dln2_gpio_pin_cmd(struct dln2_gpio *dln2, int cmd, unsigned pin)
> +{
> +	struct dln2_gpio_pin req = {
> +		.pin = cpu_to_le16(pin),
> +	};
> +
> +	return dln2_transfer(dln2->pdev, cmd, &req, sizeof(req), NULL, NULL);
> +}

Same here

> +static int dln2_gpio_pin_val(struct dln2_gpio *dln2, int cmd, unsigned int pin)
> +{
> +	int ret;
> +	struct dln2_gpio_pin req = {
> +		.pin = cpu_to_le16(pin),
> +	};
> +	struct dln2_gpio_pin_val rsp;

And here.

> +static int dln2_gpio_set_debounce(struct gpio_chip *chip, unsigned offset,
> +				  unsigned debounce)
> +{
> +	struct dln2_gpio *dln2 = container_of(chip, struct dln2_gpio, gpio);
> +	struct {
> +		__le32 duration;
> +	} __packed req = {
> +		.duration = cpu_to_le32(debounce),
> +	};
> +
> +	return dln2_transfer(dln2->pdev, DLN2_GPIO_SET_DEBOUNCE,
> +			     &req, sizeof(req), NULL, NULL);
> +}

Here you also have a strange __packed attribute that makes no sense
for a local variable, in addition to the stack problem.

I think the only correct way to handle these is to add a dynamic
allocation of an entire page for the DMA, which can probably be
part of the dln2_transfer function so you don't have to do it
in each caller.

	Arnd

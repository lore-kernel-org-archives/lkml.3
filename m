Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbbAVQdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:33:24 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:39357 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbbAVQdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:33:19 -0500
Date: Thu, 22 Jan 2015 08:33:13 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Olliver Schinagl <o.schinagl@ultimaker.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Olliver Schinagl <oliver@schinagl.nl>,
        Robin Gong <b38343@freescale.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Grant Likely <grant.likely@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Alexander Shiyan <shc_work@mail.ru>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [PATCH v2 4/4] leds: no longer use unnamed gpios
Message-ID: <20150122163313.GD18153@dtor-ws>
References: <1421876028-22799-1-git-send-email-o.schinagl@ultimaker.com>
 <1421876028-22799-5-git-send-email-o.schinagl@ultimaker.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421876028-22799-5-git-send-email-o.schinagl@ultimaker.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olliver,

On Wed, Jan 21, 2015 at 10:33:48PM +0100, Olliver Schinagl wrote:
> diff --git a/drivers/input/keyboard/gpio_keys_polled.c b/drivers/input/keyboard/gpio_keys_polled.c
> index 097d721..eadb472 100644
> --- a/drivers/input/keyboard/gpio_keys_polled.c
> +++ b/drivers/input/keyboard/gpio_keys_polled.c
> @@ -125,15 +125,19 @@ static struct gpio_keys_platform_data *gpio_keys_polled_get_devtree_pdata(struct
>  	device_for_each_child_node(dev, child) {
>  		struct gpio_desc *desc;
>  
> -		desc = devm_get_gpiod_from_child(dev, NULL, child);
> +		desc = devm_get_gpiod_from_child(dev, "gpio_keys_polled",
> +						 child);
>  		if (IS_ERR(desc)) {
> -			error = PTR_ERR(desc);
> -			if (error != -EPROBE_DEFER)
> -				dev_err(dev,
> -					"Failed to get gpio flags, error: %d\n",
> -					error);
> -			fwnode_handle_put(child);
> -			return ERR_PTR(error);
> +			desc = devm_get_gpiod_from_child(dev, NULL, child);
> +			if (IS_ERR(desc)) {
> +				error = PTR_ERR(desc);
> +				if (error != -EPROBE_DEFER)
> +					dev_err(dev,
> +						"Failed to get gpio flags, error: %d\n",
> +						error);
> +				fwnode_handle_put(child);
> +				return ERR_PTR(error);
> +			}
>  		}
>  

I do not think this is correct. If devm_get_gpiod_from_child(dev,
"gpio_keys_polled", child) retruns -EPROBE_DEFER we'll try
devm_get_gpiod_from_child(dev, NULL, child). If that returns some other
error we'll fail probing entire driver.

Did I mention how *I HATE* the -EPROBE_DEFER (the error that is not an
error)?

Thanks.

-- 
Dmitry

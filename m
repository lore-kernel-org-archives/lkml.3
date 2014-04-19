Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbaDSB5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 21:57:08 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50926 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaDSB5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 21:57:03 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5351D7EC.80902@roeck-us.net>
Date: Fri, 18 Apr 2014 18:57:00 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Mark Brown <broonie@kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v3] regmap: i2c: fallback to SMBus if the adapter does
 not support standard I2C
References: <1397727612-32103-1-git-send-email-boris.brezillon@free-electrons.com> <1397851901-16390-1-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1397851901-16390-1-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2014 01:11 PM, Boris BREZILLON wrote:
> Some I2C adapters are only compatible with the SMBus protocol and do not
> support standard I2C transfers.
>
> Fallback to SMBus transfers if we encounter such kind of adapters.
> The transfer type is chosen according to the val_bits field in the regmap
> config.
>
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---

[ ... ]

>   /**
>    * regmap_init_i2c(): Initialise register map
>    *
> @@ -109,7 +199,12 @@ static struct regmap_bus regmap_i2c = {
>   struct regmap *regmap_init_i2c(struct i2c_client *i2c,
>   			       const struct regmap_config *config)
>   {
> -	return regmap_init(&i2c->dev, &regmap_i2c, &i2c->dev, config);
> +	const struct regmap_bus *bus = regmap_get_i2c_bus(i2c, config);
> +
> +	if (IS_ERR(bus))
> +		return ERR_PTR(PTR_ERR(bus));
> +
This seems clumsy. You should be able to use ERR_CAST() instead.
Also see Documentation/coccinelle.txt and scripts/coccinelle/api/err_cast.cocci.

> +	return regmap_init(&i2c->dev, bus, &i2c->dev, config);
>   }
>   EXPORT_SYMBOL_GPL(regmap_init_i2c);
>
> @@ -126,7 +221,12 @@ EXPORT_SYMBOL_GPL(regmap_init_i2c);
>   struct regmap *devm_regmap_init_i2c(struct i2c_client *i2c,
>   				    const struct regmap_config *config)
>   {
> -	return devm_regmap_init(&i2c->dev, &regmap_i2c, &i2c->dev, config);
> +	const struct regmap_bus *bus = regmap_get_i2c_bus(i2c, config);
> +
> +	if (IS_ERR(bus))
> +		return ERR_PTR(PTR_ERR(bus));
> +
Same here.

Guenter


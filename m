Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659Ab3BKVZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 16:25:56 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51340 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605Ab3BKVZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 16:25:54 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2] gpio: mcp23s08: convert driver to DT
To: Lars Poeschel <larsi@wh2.tu-dresden.de>, poeschel@lemonage.de,
        rob.herring@calxeda.com, rob@landley.net, linus.walleij@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
In-Reply-To: <1360583563-10707-1-git-send-email-larsi@wh2.tu-dresden.de>
References: <1360583563-10707-1-git-send-email-larsi@wh2.tu-dresden.de>
Date: Mon, 11 Feb 2013 21:25:51 +0000
Message-Id: <20130211212551.1002A3E3530@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2013 12:52:42 +0100, Lars Poeschel <larsi@wh2.tu-dresden.de> wrote:
> From: Lars Poeschel <poeschel@lemonage.de>
> 
> This converts the mcp23s08 driver to be able to be used with device
> tree.
> Explicitly allow -1 as a legal value for the
> mcp23s08_platform_data->base. This is the special value lets the
> kernel choose a valid global gpio base number.
> There is a "mcp,chips" device tree property, that correspond to the
> chips member of the struct mcp23s08_platform_data. It can be used for
> multiple mcp23s08/mc23s17 on the same spi chipselect.
> 
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> ---
> v2:
> - squashed booth patches together
> - fixed build warning, when CONFIG_OF is not defined
> - use of_match_ptr macro for of_match_table
> 
>  .../devicetree/bindings/gpio/gpio-mcp23s08.txt     |   36 ++++++++
>  drivers/gpio/gpio-mcp23s08.c                       |   95 ++++++++++++++++++--
>  include/linux/spi/mcp23s08.h                       |    1 +
>  3 files changed, 126 insertions(+), 6 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
> 
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt b/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
> new file mode 100644
> index 0000000..17eb669
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
> @@ -0,0 +1,36 @@
> +Microchip MCP2308/MCP23S08/MCP23017/MCP23S17 driver for
> +8-/16-bit I/O expander with serial interface (I2C/SPI)
> +
> +Required properties:
> +- compatible : Should be
> +    - "mcp,mcp23s08" for  8 GPIO SPI version
> +    - "mcp,mcp23s17" for 16 GPIO SPI version
> +    - "mcp,mcp23008" for  8 GPIO I2C version or
> +    - "mcp,mcp23017" for 16 GPIO I2C version of the chip
> +- #gpio-cells : Should be two.
> +  - first cell is the pin number
> +  - second cell is used to specify optional parameters (currently unused)
> +- gpio-controller : Marks the device node as a GPIO controller.
> +- reg : For an address on its bus
> +
> +Optional device specific properties:
> +- mcp,chips : This is a table with 2 columns and up to 8 entries. The first column
> +	is a is_present flag, that makes only sense for SPI chips. Multiple
> +	chips can share the same chipselect. This flag can be 0 or 1 depending
> +	if there is a chip at this address or not.
> +	The second column is written to the GPPU register, selecting a 100k
> +	pullup resistor or not. Setting a 1 is activating the pullup.
> +	For I2C chips only the first line in this table is used. Further chips
> +	are registered at different addresses at the I2C bus.

Since these are two separate things, I would put them into separate
properties. Perhaps something like:
 - mcp,spi-present-mask = < mask >; /* one bit per chip */
 - mcp,pullup-enable-mask = < enable-value ... >;

However, is the pullup selection per-gpio line? If so, then why not
encode it into the flags field of the gpio specifier?

> +
> +Example:
> +gpiom1: gpio@20 {
> +        compatible = "mcp,mcp23017";
> +        gpio-controller;
> +        #gpio-cells = <2>;
> +        reg = <0x20>;
> +	chips = <
> +	/* is_present  pullups */
> +		1	0x07	/* chip address 0 */
> +	>;
> +};
> diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
> index 3cea0ea..ad08a5a 100644
> --- a/drivers/gpio/gpio-mcp23s08.c
> +++ b/drivers/gpio/gpio-mcp23s08.c
> @@ -12,6 +12,8 @@
>  #include <linux/spi/mcp23s08.h>
>  #include <linux/slab.h>
>  #include <asm/byteorder.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
>  
>  /**
>   * MCP types supported by driver
> @@ -473,17 +475,88 @@ fail:
>  
>  /*----------------------------------------------------------------------*/
>  
> +#ifdef CONFIG_OF
> +static struct of_device_id mcp23s08_of_match[] = {
> +#ifdef CONFIG_SPI_MASTER
> +	{
> +		.compatible = "mcp,mcp23s08",
> +	},
> +	{
> +		.compatible = "mcp,mcp23s17",
> +	},
> +#endif
> +#if IS_ENABLED(CONFIG_I2C)
> +	{
> +		.compatible = "mcp,mcp23008",
> +	},
> +	{
> +		.compatible = "mcp,mcp23017",
> +	},
> +#endif
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, mcp23s08_of_match);

I don't think this is actually what you want. You should use separate
match tables; one for I2C and one for SPI.

> +
> +static struct mcp23s08_platform_data *
> +		of_get_mcp23s08_pdata(struct device *dev)
> +{
> +	struct mcp23s08_platform_data *pdata;
> +	struct device_node *np = dev->of_node;
> +	u32 chips[sizeof(pdata->chip)];
> +	int ret, i, j;
> +
> +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return NULL;
> +
> +	pdata->base = -1;
> +
> +	for (i = ARRAY_SIZE(pdata->chip) * MCP23S08_CHIP_INFO_MEMBERS;
> +				i > 0; i -= MCP23S08_CHIP_INFO_MEMBERS) {
> +		ret = of_property_read_u32_array(np, "mcp,chips", chips, i);
> +		if (ret == -EOVERFLOW)
> +			continue;
> +		break;
> +	}
> +	if (!ret) {
> +		for (j = 0; j < i / MCP23S08_CHIP_INFO_MEMBERS ; j++) {
> +			pdata->chip[j].is_present =
> +				chips[j * MCP23S08_CHIP_INFO_MEMBERS];
> +			pdata->chip[j].pullups =
> +				chips[j * MCP23S08_CHIP_INFO_MEMBERS + 1];
> +		}
> +	}
> +
> +	return pdata;

Using devm is probably overkill since the pdata structure is not touched
again after probe() exits. You could instead just put the
mcp23s08_platform_data structure into the stack of the probe hook.

> +}
> +#else
> +static struct mcp23s08_platform_data *
> +		of_get_mcp23s08_pdata(struct device *dev)
> +{
> +	return NULL;
> +}
> +#endif /* CONFIG_OF */
> +
> +
>  #if IS_ENABLED(CONFIG_I2C)
>  
>  static int mcp230xx_probe(struct i2c_client *client,
>  				    const struct i2c_device_id *id)
>  {
> -	struct mcp23s08_platform_data *pdata;
> +	struct mcp23s08_platform_data *pdata = NULL;
>  	struct mcp23s08 *mcp;
>  	int status;
> +	const struct of_device_id *match;
>  
> -	pdata = client->dev.platform_data;
> -	if (!pdata || !gpio_is_valid(pdata->base)) {
> +	match = of_match_device(of_match_ptr(mcp23s08_of_match), &client->dev);
> +	if (match)
> +		pdata = of_get_mcp23s08_pdata(&client->dev);
> +
> +	/* if there was no pdata in DT, take it the legacy way */
> +	if (!pdata)
> +		pdata = client->dev.platform_data;
> +
> +	if ((!pdata || !gpio_is_valid(pdata->base)) && pdata->base != -1) {
>  		dev_dbg(&client->dev, "invalid or missing platform data\n");
>  		return -EINVAL;
>  	}
> @@ -531,6 +604,7 @@ static struct i2c_driver mcp230xx_driver = {
>  	.driver = {
>  		.name	= "mcp230xx",
>  		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(mcp23s08_of_match),
>  	},
>  	.probe		= mcp230xx_probe,
>  	.remove		= mcp230xx_remove,
> @@ -560,17 +634,25 @@ static void mcp23s08_i2c_exit(void) { }
>  
>  static int mcp23s08_probe(struct spi_device *spi)
>  {
> -	struct mcp23s08_platform_data	*pdata;
> +	struct mcp23s08_platform_data	*pdata = NULL;
>  	unsigned			addr;
>  	unsigned			chips = 0;
>  	struct mcp23s08_driver_data	*data;
>  	int				status, type;
>  	unsigned			base;
> +	const struct			of_device_id *match;
>  
>  	type = spi_get_device_id(spi)->driver_data;
>  
> -	pdata = spi->dev.platform_data;
> -	if (!pdata || !gpio_is_valid(pdata->base)) {
> +	match = of_match_device(of_match_ptr(mcp23s08_of_match), &spi->dev);
> +	if (match)
> +		pdata = of_get_mcp23s08_pdata(&spi->dev);
> +
> +	/* if there was no pdata in DT, take it the legacy way */
> +	if (!pdata)
> +		pdata = spi->dev.platform_data;
> +
> +	if ((!pdata || !gpio_is_valid(pdata->base)) && pdata->base != -1) {
>  		dev_dbg(&spi->dev, "invalid or missing platform data\n");
>  		return -EINVAL;
>  	}
> @@ -668,6 +750,7 @@ static struct spi_driver mcp23s08_driver = {
>  	.driver = {
>  		.name	= "mcp23s08",
>  		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(mcp23s08_of_match),
>  	},
>  };
>  
> diff --git a/include/linux/spi/mcp23s08.h b/include/linux/spi/mcp23s08.h
> index 2d676d5..3969e12 100644
> --- a/include/linux/spi/mcp23s08.h
> +++ b/include/linux/spi/mcp23s08.h
> @@ -1,3 +1,4 @@
> +#define MCP23S08_CHIP_INFO_MEMBERS	2
>  
>  /* FIXME driver should be able to handle IRQs...  */
>  
> -- 
> 1.7.10.4
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.

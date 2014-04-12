Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbaDLJCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 05:02:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49704 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753786AbaDLJCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 05:02:04 -0400
Message-ID: <53490109.5050006@free-electrons.com>
Date: Sat, 12 Apr 2014 11:02:01 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [RFC PATCH] regmap: smbus: add support for regmap over SMBus
References: <1397292335-5516-1-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1397292335-5516-1-git-send-email-boris.brezillon@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/04/2014 10:45, Boris BREZILLON wrote:
> SMBus is a subset of the I2C protocol, oftenly used to access registers on
> external devices.
>
> I2C adpaters are able to access SMBus devices thanks to the SMBus
> emulation layer. In the other hand SMBus adapters may not provide
> regular I2C transfers, and thus you may not be able to expose a regmap
> if your device is connected to such kind of adapter.
> Hence why we need this regmap over SMBus implementation.
>
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
> Hello Mark,
>
> I know you were not in favor of the smbus regmap (according to this thread
> [1]), but I now hit a point where I need this functionnality.
>
> The A31 SoC have an SMBus adatper which do not support regular I2C transfers
> and on some boards (if not all) the AXP221 PMIC is connected to thi adapter.
> Moreover the AXP221 really looks like the AXP209 whose driver is being
> submitting ([2]), and this driver uses regmap to expose PMIC's registers.
>
> I'd like to reuse the driver, and the only thing I need to do so is to add
> support for regmap over SMBus, and patch the axp20x driver to register an
> smbus regmap instead of an i2c one.
>
> Let me now if you still think regmap over SMBus should not be supported, or
> if you've find a better way to achieve my goal.
>
> Best Regards,
>
> Boris
>
> [1] http://comments.gmane.org/gmane.linux.kernel/1167755
Oops, I forgot to add the 2nd reference link:

[2] http://www.spinics.net/lists/linux-input/msg30806.html

>  drivers/base/regmap/Kconfig        |   5 +-
>  drivers/base/regmap/Makefile       |   1 +
>  drivers/base/regmap/regmap-smbus.c | 364 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 369 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/base/regmap/regmap-smbus.c
>
> diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
> index 4251570..450b4c1 100644
> --- a/drivers/base/regmap/Kconfig
> +++ b/drivers/base/regmap/Kconfig
> @@ -3,7 +3,7 @@
>  # subsystems should select the appropriate symbols.
>  
>  config REGMAP
> -	default y if (REGMAP_I2C || REGMAP_SPI || REGMAP_SPMI || REGMAP_MMIO || REGMAP_IRQ)
> +	default y if (REGMAP_I2C || REGMAP_SMBUS || REGMAP_SPI || REGMAP_SPMI || REGMAP_MMIO || REGMAP_IRQ)
>  	select LZO_COMPRESS
>  	select LZO_DECOMPRESS
>  	select IRQ_DOMAIN if REGMAP_IRQ
> @@ -12,6 +12,9 @@ config REGMAP
>  config REGMAP_I2C
>  	tristate
>  
> +config REGMAP_SMBUS
> +	tristate
> +
>  config REGMAP_SPI
>  	tristate
>  
> diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
> index a7c670b..e752b9c 100644
> --- a/drivers/base/regmap/Makefile
> +++ b/drivers/base/regmap/Makefile
> @@ -2,6 +2,7 @@ obj-$(CONFIG_REGMAP) += regmap.o regcache.o
>  obj-$(CONFIG_REGMAP) += regcache-rbtree.o regcache-lzo.o regcache-flat.o
>  obj-$(CONFIG_DEBUG_FS) += regmap-debugfs.o
>  obj-$(CONFIG_REGMAP_I2C) += regmap-i2c.o
> +obj-$(CONFIG_REGMAP_SMBUS) += regmap-smbus.o
>  obj-$(CONFIG_REGMAP_SPI) += regmap-spi.o
>  obj-$(CONFIG_REGMAP_SPMI) += regmap-spmi.o
>  obj-$(CONFIG_REGMAP_MMIO) += regmap-mmio.o
> diff --git a/drivers/base/regmap/regmap-smbus.c b/drivers/base/regmap/regmap-smbus.c
> new file mode 100644
> index 0000000..c8b8075
> --- /dev/null
> +++ b/drivers/base/regmap/regmap-smbus.c
> @@ -0,0 +1,364 @@
> +/*
> + * Register map access API - SMBus support
> + *
> + * Copyright 2014 Free Electrons
> + *
> + * Author: Boris Brezillon <boris.brezillon@free-electrons.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/regmap.h>
> +#include <linux/i2c.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +
> +struct regmap_smbus_context {
> +	struct i2c_client *i2c;
> +	enum regmap_smbus_transfer_type transfer_type;
> +	int val_bytes;
> +};
> +
> +static int regmap_smbus_write(void *context, const void *data, size_t count)
> +{
> +	struct regmap_smbus_context *ctx = context;
> +	int ret = 0;
> +	u8 reg = *(u8 *)data++;
> +
> +	count--;
> +
> +	switch (ctx->transfer_type) {
> +	case REGMAP_SMBUS_BYTE_TRANSFER:
> +		while (count > 0 && !ret) {
> +			ret = i2c_smbus_write_byte_data(ctx->i2c, reg++,
> +							*(u8 *)data++);
> +
> +			count--;
> +		}
> +		break;
> +
> +	case REGMAP_SMBUS_WORD_TRANSFER:
> +		while (count > 0 && !ret) {
> +			ret = i2c_smbus_write_word_data(ctx->i2c, reg,
> +							*(u16 *)data++);
> +
> +			reg += 2;
> +			count -= 2;
> +		}
> +		break;
> +
> +	case REGMAP_SMBUS_BLOCK_TRANSFER:
> +		while (count > 0 && !ret) {
> +			ret = i2c_smbus_write_block_data(ctx->i2c,
> +							 reg,
> +							 ctx->val_bytes,
> +							 (const u8 *)data);
> +
> +			reg += ctx->val_bytes;
> +			count -= ctx->val_bytes;
> +			data += ctx->val_bytes;
> +		}
> +		break;
> +
> +	case REGMAP_SMBUS_I2C_BLOCK_TRANSFER:
> +		while (count > 0 && !ret) {
> +			ret = i2c_smbus_write_i2c_block_data(ctx->i2c,
> +							     reg,
> +							     ctx->val_bytes,
> +							     (const u8 *)data);
> +
> +			reg += ctx->val_bytes;
> +			count -= ctx->val_bytes;
> +			data += ctx->val_bytes;
> +		}
> +		break;
> +
> +	default:
> +		return -ENOTSUPP;
> +	}
> +
> +	return ret;
> +}
> +
> +static int regmap_smbus_gather_write(void *context,
> +				     const void *reg, size_t reg_size,
> +				     const void *val, size_t val_size)
> +{
> +	struct regmap_smbus_context *ctx = context;
> +	u8 smbus_reg;
> +	int ret = 0;
> +
> +	if (reg_size != 1)
> +		return -ENOTSUPP;
> +
> +	smbus_reg = *(u8 *)reg;
> +
> +	switch (ctx->transfer_type) {
> +	case REGMAP_SMBUS_BYTE_TRANSFER:
> +		while (val_size && !ret) {
> +			ret = i2c_smbus_write_byte_data(ctx->i2c,
> +							smbus_reg++,
> +							*(u8 *)val++);
> +
> +			val_size--;
> +		}
> +		break;
> +
> +	case REGMAP_SMBUS_WORD_TRANSFER:
> +		while (val_size && !ret) {
> +			ret = i2c_smbus_write_word_data(ctx->i2c,
> +							smbus_reg,
> +							*(u16 *)val++);
> +
> +			smbus_reg += 2;
> +			val_size -= 2;
> +		}
> +		break;
> +
> +	case REGMAP_SMBUS_BLOCK_TRANSFER:
> +		while (val_size && !ret) {
> +			ret = i2c_smbus_write_block_data(ctx->i2c,
> +							 smbus_reg,
> +							 ctx->val_bytes,
> +							 (const u8 *)val);
> +
> +			smbus_reg += ctx->val_bytes;
> +			val_size -= ctx->val_bytes;
> +			val += ctx->val_bytes;
> +		}
> +		break;
> +
> +	case REGMAP_SMBUS_I2C_BLOCK_TRANSFER:
> +		if (val_size > I2C_SMBUS_BLOCK_MAX)
> +			return -ENOTSUPP;
> +
> +		while (val_size && !ret) {
> +			ret = i2c_smbus_write_i2c_block_data(ctx->i2c,
> +							     smbus_reg,
> +							     ctx->val_bytes,
> +							     (const u8 *)val);
> +
> +			smbus_reg += ctx->val_bytes;
> +			val_size -= ctx->val_bytes;
> +			val += ctx->val_bytes;
> +		}
> +		break;
> +
> +	default:
> +		return -ENOTSUPP;
> +	}
> +
> +	return ret;
> +}
> +
> +static int regmap_smbus_read(void *context,
> +			     const void *reg, size_t reg_size,
> +			     void *val, size_t val_size)
> +{
> +	struct regmap_smbus_context *ctx = context;
> +	u8 buffer[I2C_SMBUS_BLOCK_MAX];
> +	u8 smbus_reg;
> +	int ret = 0;
> +
> +	if (reg_size != 1)
> +		return -ENOTSUPP;
> +
> +	smbus_reg = *(u8 *)reg;
> +
> +	switch (ctx->transfer_type) {
> +	case REGMAP_SMBUS_BYTE_TRANSFER:
> +		while (val_size && ret >= 0) {
> +			ret = i2c_smbus_read_byte_data(ctx->i2c, smbus_reg++);
> +			if (ret >= 0)
> +				*((u8 *)val++) = ret;
> +
> +			val_size--;
> +		}
> +		break;
> +
> +	case REGMAP_SMBUS_WORD_TRANSFER:
> +		while (val_size && ret >= 0) {
> +			ret = i2c_smbus_read_word_data(ctx->i2c, smbus_reg);
> +			if (ret >= 0)
> +				*(u16 *)val++ = ret;
> +
> +			smbus_reg += 2;
> +			val_size -= 2;
> +		}
> +		break;
> +
> +	case REGMAP_SMBUS_BLOCK_TRANSFER:
> +		while (val_size && ret >= 0) {
> +			ret = i2c_smbus_read_block_data(ctx->i2c,
> +							smbus_reg,
> +							buffer);
> +			if (ret >= 0 && ret < ctx->val_bytes) {
> +				ret = -EIO;
> +				break;
> +			}
> +
> +			memcpy(val, buffer, ctx->val_bytes);
> +			smbus_reg += ctx->val_bytes;
> +			val_size -= ctx->val_bytes;
> +			val += ctx->val_bytes;
> +		}
> +		break;
> +
> +	case REGMAP_SMBUS_I2C_BLOCK_TRANSFER:
> +		while (val_size && ret >= 0) {
> +			return -ENOTSUPP;
> +
> +			ret = i2c_smbus_read_i2c_block_data(ctx->i2c,
> +							    smbus_reg,
> +							    ctx->val_bytes,
> +							    (u8 *)val);
> +			if (ret >= 0 && ret < val_size) {
> +				ret = -EIO;
> +				break;
> +			}
> +
> +			smbus_reg += ctx->val_bytes;
> +			val_size -= ctx->val_bytes;
> +			val += ctx->val_bytes;
> +		}
> +		break;
> +
> +	default:
> +		return -ENOTSUPP;
> +	}
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static void regmap_smbus_free_context(void *context)
> +{
> +	kfree(context);
> +}
> +
> +struct regmap_smbus_context *regmap_smbus_gen_context(struct i2c_client *i2c,
> +				const struct regmap_config *config,
> +				enum regmap_smbus_transfer_type transfer_type)
> +{
> +	struct regmap_smbus_context *ctx;
> +	int val_bytes = 0;
> +
> +	if (config->reg_bits != 8 || config->pad_bits != 0)
> +		return ERR_PTR(-ENOTSUPP);
> +
> +	switch (transfer_type) {
> +	case REGMAP_SMBUS_BYTE_TRANSFER:
> +		if (config->val_bits != 8)
> +			return ERR_PTR(-EINVAL);
> +
> +		if (!i2c_check_functionality(i2c->adapter,
> +					     I2C_FUNC_SMBUS_BYTE_DATA))
> +			return ERR_PTR(-ENOTSUPP);
> +		break;
> +
> +	case REGMAP_SMBUS_WORD_TRANSFER:
> +		if (config->val_bits != 16)
> +			return ERR_PTR(-EINVAL);
> +
> +		if (!i2c_check_functionality(i2c->adapter,
> +					     I2C_FUNC_SMBUS_WORD_DATA))
> +			return ERR_PTR(-ENOTSUPP);
> +		break;
> +
> +	case REGMAP_SMBUS_BLOCK_TRANSFER:
> +		if (config->val_bits > (I2C_SMBUS_BLOCK_MAX * 8))
> +			return ERR_PTR(-EINVAL);
> +
> +		val_bytes = DIV_ROUND_UP(config->val_bits, 8);
> +		if (!i2c_check_functionality(i2c->adapter,
> +					     I2C_FUNC_SMBUS_BLOCK_DATA))
> +			return ERR_PTR(-ENOTSUPP);
> +		break;
> +
> +	case REGMAP_SMBUS_I2C_BLOCK_TRANSFER:
> +		if (config->val_bits > (I2C_SMBUS_BLOCK_MAX * 8))
> +			return ERR_PTR(-EINVAL);
> +
> +		val_bytes = DIV_ROUND_UP(config->val_bits, 8);
> +
> +		if (!i2c_check_functionality(i2c->adapter,
> +					     I2C_FUNC_SMBUS_I2C_BLOCK))
> +			return ERR_PTR(-ENOTSUPP);
> +		break;
> +
> +	default:
> +		return ERR_PTR(-ENOTSUPP);
> +	}
> +
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return ERR_PTR(-ENOMEM);
> +
> +	ctx->i2c = i2c;
> +	ctx->transfer_type = transfer_type;
> +	ctx->val_bytes = val_bytes;
> +
> +	return ctx;
> +}
> +
> +static struct regmap_bus regmap_smbus = {
> +	.write = regmap_smbus_write,
> +	.gather_write = regmap_smbus_gather_write,
> +	.read = regmap_smbus_read,
> +	.free_context = regmap_smbus_free_context,
> +};
> +
> +/**
> + * regmap_init_smbus(): Initialise register map
> + *
> + * @i2c: Device that will be interacted with
> + * @config: Configuration for register map
> + * @transfer_type: SMBUS transfer type
> + *
> + * The return value will be an ERR_PTR() on error or a valid pointer to
> + * a struct regmap.
> + */
> +struct regmap *regmap_init_smbus(struct i2c_client *i2c,
> +				 const struct regmap_config *config,
> +				 enum regmap_smbus_transfer_type transfer_type)
> +{
> +	struct regmap_smbus_context *ctx =
> +		regmap_smbus_gen_context(i2c, config, transfer_type);
> +
> +	if (IS_ERR(ctx))
> +		return ERR_PTR(PTR_ERR(ctx));
> +
> +	return regmap_init(&i2c->dev, &regmap_smbus, ctx, config);
> +}
> +EXPORT_SYMBOL_GPL(regmap_init_smbus);
> +
> +/**
> + * devm_regmap_init_smbus(): Initialise managed register map
> + *
> + * @i2c: Device that will be interacted with
> + * @config: Configuration for register map
> + * @transfer_type: SMBUS transfer type
> + *
> + * The return value will be an ERR_PTR() on error or a valid pointer
> + * to a struct regmap.  The regmap will be automatically freed by the
> + * device management code.
> + */
> +struct regmap *devm_regmap_init_smbus(struct i2c_client *i2c,
> +				const struct regmap_config *config,
> +				enum regmap_smbus_transfer_type transfer_type)
> +{
> +	struct regmap_smbus_context *ctx =
> +		regmap_smbus_gen_context(i2c, config, transfer_type);
> +
> +	if (IS_ERR(ctx))
> +		return ERR_PTR(PTR_ERR(ctx));
> +
> +	return devm_regmap_init(&i2c->dev, &regmap_smbus, ctx, config);
> +}
> +EXPORT_SYMBOL_GPL(devm_regmap_init_smbus);
> +
> +MODULE_LICENSE("GPL");

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com


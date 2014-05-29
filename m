Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbaE2Lk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 07:40:59 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:61103 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbaE2Lk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 07:40:58 -0400
Date: Thu, 29 May 2014 12:40:52 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: broonie@kernel.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH v4 1/3] mfd: intel_soc_pmic: Core driver
Message-ID: <20140529114052.GI1954@lee--X1>
References: <1401347968-24410-1-git-send-email-lejun.zhu@linux.intel.com>
 <1401347968-24410-2-git-send-email-lejun.zhu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401347968-24410-2-git-send-email-lejun.zhu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch provides the common I2C driver code for Intel SoC PMICs.
> 
> Signed-off-by: Yang, Bin <bin.yang@intel.com>
> Signed-off-by: Zhu, Lejun <lejun.zhu@linux.intel.com>
> ---
> v2:
> - Use regmap instead of creating our own I2C read/write callbacks.
> - Add one missing EXPORT_SYMBOL.
> - Remove duplicate code and put them into pmic_regmap_load_from_hw.
> v3:
> - Use regmap-irq. Remove our own pmic_regmap_* and IRQ handling code.
> - Remove intel_soc_pmic_dev() and intel_soc_pmic_set_pdata().
> - Use EXPORT_SYMBOL_GPL for exposed APIs.
> - Use gpiod interface instead of gpio numbers.
> - Remove redundant I2C IDs.
> - Use managed allocations.
> v4:
> - Remove all exported APIs which are wrappers of regmap API, export
>   the regmap in data structure instead.
> - Combine I2C and core .c files.
> - Clean up include files.
> - Use intel_soc_pmic_ prefix to replace pmic_ and intel_pmic_.
> - Fix various coding style issues.
> ---
>  drivers/mfd/intel_soc_pmic_core.c  | 164 +++++++++++++++++++++++++++++++++++++
>  drivers/mfd/intel_soc_pmic_core.h  |  32 ++++++++
>  include/linux/mfd/intel_soc_pmic.h |  30 +++++++
>  3 files changed, 226 insertions(+)
>  create mode 100644 drivers/mfd/intel_soc_pmic_core.c
>  create mode 100644 drivers/mfd/intel_soc_pmic_core.h
>  create mode 100644 include/linux/mfd/intel_soc_pmic.h
> 
> diff --git a/drivers/mfd/intel_soc_pmic_core.c b/drivers/mfd/intel_soc_pmic_core.c
> new file mode 100644
> index 0000000..664eaef
> --- /dev/null
> +++ b/drivers/mfd/intel_soc_pmic_core.c
> @@ -0,0 +1,164 @@

[...]

> +static int intel_soc_pmic_find_gpio_irq(struct device *dev)
> +{
> +	struct gpio_desc *desc;
> +	int irq;
> +
> +	desc = devm_gpiod_get_index(dev, KBUILD_MODNAME, 0);

What does "KBUILD_MODNAME" translate to?

> +	if (IS_ERR(desc)) {
> +		dev_dbg(dev, "Not using GPIO as interrupt.\n");

You can't have a debug print, then return an err - use dev_err().

[...]

> +static int intel_soc_pmic_i2c_probe(struct i2c_client *i2c,
> +				    const struct i2c_device_id *id)
> +{
> +	struct device *dev = &i2c->dev;
> +	struct intel_soc_pmic_config *config =
> +		(struct intel_soc_pmic_config *)id->driver_data;
> +	struct intel_soc_pmic *pmic;
> +	int ret;
> +	int irq;
> +
> +	pmic = devm_kzalloc(dev, sizeof(*pmic), GFP_KERNEL);
> +	dev_set_drvdata(dev, pmic);
> +
> +	pmic->regmap = devm_regmap_init_i2c(i2c, config->regmap_config);
> +
> +	irq = intel_soc_pmic_find_gpio_irq(dev);
> +	if (irq < 0)
> +		pmic->irq = i2c->irq;
> +	else
> +		pmic->irq = irq;

pmic->irq = (irq < 0) ? i2c->irq : irq;

> +	ret = regmap_add_irq_chip(pmic->regmap, pmic->irq,
> +				  config->irq_flags | IRQF_ONESHOT,
> +				  0, config->irq_chip,
> +				  &pmic->irq_chip_data);
> +	if (ret)
> +		goto err;

Just return ret here and remove the 'err:' label.

[...]

> +static const struct i2c_device_id intel_soc_pmic_i2c_id[] = {
> +	{"INT33FD:00", (kernel_ulong_t)&intel_soc_pmic_config_crc},
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, intel_soc_pmic_i2c_id);
> +
> +static struct acpi_device_id intel_soc_pmic_acpi_match[] = {
> +	{"INT33FD", (kernel_ulong_t)&intel_soc_pmic_config_crc},
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(acpi, intel_soc_pmic_acpi_match);

Does ACPI have a match function to extact it's .driver_data attribute?

If so, are you using it here? If not, why not?

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

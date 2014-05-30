Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbaE3E6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 00:58:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:55729 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbaE3E6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 00:58:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,938,1392192000"; 
   d="scan'208";a="548723765"
Message-ID: <53880FF5.8070500@linux.intel.com>
Date: Fri, 30 May 2014 12:58:29 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: broonie@kernel.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH v4 1/3] mfd: intel_soc_pmic: Core driver
References: <1401347968-24410-1-git-send-email-lejun.zhu@linux.intel.com> <1401347968-24410-2-git-send-email-lejun.zhu@linux.intel.com> <20140529114052.GI1954@lee--X1>
In-Reply-To: <20140529114052.GI1954@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/29/2014 7:40 PM, Lee Jones wrote:
> [...]
> 
>> +static int intel_soc_pmic_find_gpio_irq(struct device *dev)
>> +{
>> +	struct gpio_desc *desc;
>> +	int irq;
>> +
>> +	desc = devm_gpiod_get_index(dev, KBUILD_MODNAME, 0);
> 
> What does "KBUILD_MODNAME" translate to?

It translates into "intel_soc_pmic".

> 
>> +	if (IS_ERR(desc)) {
>> +		dev_dbg(dev, "Not using GPIO as interrupt.\n");
> 
> You can't have a debug print, then return an err - use dev_err().

Actually returning ENOENT here is just a hardware difference. On some
boards the PMIC interrupt is from a GPIO line exposed by the CPU, on the
rest (e.g. Asus T100TA) it's not. When -ENOENT is returned, probe() will
simply use the IRQ provided by the I2C.

I will remove this line completely, and put a comment before the function.

> 
> [...]
> 
>> +static int intel_soc_pmic_i2c_probe(struct i2c_client *i2c,
>> +				    const struct i2c_device_id *id)
>> +{
>> +	struct device *dev = &i2c->dev;
>> +	struct intel_soc_pmic_config *config =
>> +		(struct intel_soc_pmic_config *)id->driver_data;
>> +	struct intel_soc_pmic *pmic;
>> +	int ret;
>> +	int irq;
>> +
>> +	pmic = devm_kzalloc(dev, sizeof(*pmic), GFP_KERNEL);
>> +	dev_set_drvdata(dev, pmic);
>> +
>> +	pmic->regmap = devm_regmap_init_i2c(i2c, config->regmap_config);
>> +
>> +	irq = intel_soc_pmic_find_gpio_irq(dev);
>> +	if (irq < 0)
>> +		pmic->irq = i2c->irq;
>> +	else
>> +		pmic->irq = irq;
> 
> pmic->irq = (irq < 0) ? i2c->irq : irq;

I'll fix it.

>> +	ret = regmap_add_irq_chip(pmic->regmap, pmic->irq,
>> +				  config->irq_flags | IRQF_ONESHOT,
>> +				  0, config->irq_chip,
>> +				  &pmic->irq_chip_data);
>> +	if (ret)
>> +		goto err;
> 
> Just return ret here and remove the 'err:' label.

I'll fix it.

> 
> [...]
> 
>> +static const struct i2c_device_id intel_soc_pmic_i2c_id[] = {
>> +	{"INT33FD:00", (kernel_ulong_t)&intel_soc_pmic_config_crc},
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(i2c, intel_soc_pmic_i2c_id);
>> +
>> +static struct acpi_device_id intel_soc_pmic_acpi_match[] = {
>> +	{"INT33FD", (kernel_ulong_t)&intel_soc_pmic_config_crc},
>> +	{ },
>> +};
>> +MODULE_DEVICE_TABLE(acpi, intel_soc_pmic_acpi_match);
> 
> Does ACPI have a match function to extact it's .driver_data attribute?
> 
> If so, are you using it here? If not, why not?
> 

The ACPI table is used in i2c_device_match(), and the i2c table is used
in i2c_device_probe(), so the id in the i2c table is actually fed to
intel_soc_pmic_probe(). But I only found out now that having the i2c
table alone is enough, because i2c_device_match will fallback to the i2c
table if there's no ACPI table. So to keep it simple, I'll remove the
ACPI table completely.

By the way, the GPIO child driver got reviewed-by from Linus Walleij,
but can't be merged because it depends on intel_soc_pmic.h. May I
include it in next version of the patch set and have it merged along
with the MFD driver?

Best Regards
Lejun

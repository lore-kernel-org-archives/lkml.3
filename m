Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaEZGCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 02:02:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:51297 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbaEZGCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 02:02:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,910,1392192000"; 
   d="scan'208";a="546497512"
Message-ID: <5382D8A7.7010704@linux.intel.com>
Date: Mon, 26 May 2014 14:01:11 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: lee.jones@linaro.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Subject: Re: [PATCH RESEND v2 1/4] mfd: intel_soc_pmic: Core driver
References: <1400805629-10322-1-git-send-email-lejun.zhu@linux.intel.com> <1400805629-10322-2-git-send-email-lejun.zhu@linux.intel.com> <20140523174925.GH22111@sirena.org.uk>
In-Reply-To: <20140523174925.GH22111@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/24/2014 1:49 AM, Mark Brown wrote:
> On Fri, May 23, 2014 at 08:40:26AM +0800, Zhu, Lejun wrote:
> 
>> +struct device *intel_soc_pmic_dev(void)
>> +{
>> +	return pmic->dev;
>> +}
>> +EXPORT_SYMBOL(intel_soc_pmic_dev);
> 
> Why do you need to take a global reference to this?

It was used by the GPIO driver to get the parent device. The latest
patch use dev.parent instead, so the whole function can be removed.

>> +/*
>> + * Read from a PMIC register
>> + */
>> +int intel_soc_pmic_readb(int reg)
>> +{
>> +	int ret;
>> +	unsigned int val;
>> +
>> +	mutex_lock(&pmic_lock);
>> +
>> +	if (!pmic) {
>> +		ret = -EIO;
>> +	} else {
>> +		ret = regmap_read(pmic->regmap, reg, &val);
>> +		if (!ret)
>> +			ret = val;
>> +	}
>> +
>> +	mutex_unlock(&pmic_lock);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(intel_soc_pmic_readb);
> 
> This is wrapping the EXPORT_SYMBOL_GPL() regmap API with an
> EXPORT_SYMBOL() API.  Don't do that, if you really do need these
> wrappers make them EXPORT_SYMBOL_GPL().

I'll change them to use EXPORT_SYMBOL_GPL().

> There should also be no need to add extra locking around regmap calls,
> the regmap API has locking as standard.

Actually it also protects the pmic variable, so it won't be set to NULL
while there's ongoing read/write.

> It's also not clear why this API exists at all, surely all the
> interaction with the device happens from the core or function drivers
> for the device which ought to be able to get a direct reference to the
> regmap anyway and only be instantiated when one is present.

We created these names to hide the implementation of how read/write is
done from other platform specific patches interacting with this driver.
So when we change the implementation, e.g. from I2C read/write to
regmap, we don't have to touch all these patches.

>> +/*
>> + * Set platform_data of the child devices. Needs to be called before
>> + * the MFD device is added.
>> + */
>> +int intel_soc_pmic_set_pdata(const char *name, void *data, int len)
(...)
>> +EXPORT_SYMBOL(intel_soc_pmic_set_pdata);
> 
> What is going on here, why aren't the normal ways of getting data to the
> devices (such as reading the platform data of the parent device) OK?

For this PMIC (Crystal Cove) it is not used. So I'll remove it.

>> +static void __pmic_regmap_flush(void)
>> +{
>> +	if (cache_write_pending)
>> +		WARN_ON(regmap_write(pmic->regmap, cache_offset,
>> +				     cache_write_val));
> 
>> +static int pmic_regmap_load_from_hw(struct intel_pmic_regmap *map)
>> +{
>> +	int ret;
> 
> This all appears to be an open coded cache layer - there is already
> cache support in regmap, just reuse that.
>
>> +static irqreturn_t pmic_irq_isr(int irq, void *data)
>> +{
>> +	return IRQ_WAKE_THREAD;
>> +}
> 
> Just register the IRQ as IRQF_ONESHOT and only provide the threaded
> handler.

I'll fix it.

>> +static irqreturn_t pmic_irq_thread(int irq, void *data)
>> +{
>> +	int i;
>> +
>> +	mutex_lock(&pmic->irq_lock);
>> +
>> +	for (i = 0; i < pmic->irq_num; i++) {
>> +		if (test_bit(PMIC_IRQ_MASK_BIT(i), &PMIC_IRQ_MASK(pmic, i)))
>> +			continue;
>> +
>> +		if (pmic_regmap_read(&pmic->irq_regmap[i].status)) {
>> +			pmic_regmap_write(&pmic->irq_regmap[i].ack, 1);
>> +			handle_nested_irq(pmic->irq_base + i);
>> +		}
>> +	}
> 
> This looks like you should be using regmap-irq, or at least like there's
> some small additions needed to make it usable.

I'll check if I can convert to regmap-irq. If it works, I won't need
this and the cache layer.

>> +	if (gpio_is_valid(pmic->pmic_int_gpio)) {
>> +		ret = gpio_request_one(pmic->pmic_int_gpio,
>> +				       GPIOF_DIR_IN, "PMIC Interupt");
>> +		if (ret) {
>> +			dev_err(pmic->dev, "Request PMIC_INT gpio error\n");
>> +			goto out_free_desc;
>> +		}
>> +
>> +		pmic->irq = gpio_to_irq(pmic->pmic_int_gpio);
>> +	}
> 
> There should be no need to do this, simply requesting the interrupt
> should be sufficient to ensure the pin is in the correct mode.  If this
> isn't the case the interrupt controller driver probably needs an update,
> there's some support for helping with this in the GPIO framework IIRC.

I'll remove this.

> You're also not using managed (devm) allocations for anything here.

Best Regards
Lejun


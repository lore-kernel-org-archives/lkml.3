Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483Ab3GaL4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:56:38 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44148 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3GaL4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:56:36 -0400
Date: Wed, 31 Jul 2013 12:56:30 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "Samuel Ortiz (sameo@linux.intel.com)" <sameo@linux.intel.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] mfd: add LP3943 MFD driver
Message-ID: <20130731115630.GH13298@lee--X1>
References: <A874F61F95741C4A9BA573A70FE3998F82E849D8@DQHE06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E849D8@DQHE06.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Signed-off-by: Milo Kim <milo.kim@ti.com>
> ---
>  drivers/mfd/Kconfig        |   11 +++
>  drivers/mfd/Makefile       |    1 +
>  drivers/mfd/lp3943.c       |  165 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/lp3943.h |  115 ++++++++++++++++++++++++++++++
>  4 files changed, 292 insertions(+)
>  create mode 100644 drivers/mfd/lp3943.c
>  create mode 100644 include/linux/mfd/lp3943.h

<snip> * looks good up to me up to here *

Although, I think the 0 = 1, 1 = 2 ... stuff is really confusing. Is
there nothing we can do about that?

> +static int lp3943_probe(struct i2c_client *cl, const struct i2c_device_id *id)
> +{
> +	struct lp3943 *lp3943;
> +	int ret;
> +
> +	lp3943 = devm_kzalloc(&cl->dev, sizeof(*lp3943), GFP_KERNEL);
> +	if (!lp3943)
> +		return -ENOMEM;
> +
> +	lp3943->regmap = devm_regmap_init_i2c(cl, &lp3943_regmap_config);
> +	if (IS_ERR(lp3943->regmap)) {
> +		ret = PTR_ERR(lp3943->regmap);

Bit of a nit. 

Why don't you: return PTR_ERR(lp3943->regmap);

> +		dev_err(&cl->dev, "Regmap init error: %d\n", ret);
> +		return ret;
> +	}
> +
> +	lp3943->pdata = cl->dev.platform_data;

Can you change this to use the helper?

dev_get_platdata()

> +	lp3943->dev = &cl->dev;
> +	lp3943->mux_cfg = lp3943_mux_cfg;
> +	i2c_set_clientdata(cl, lp3943);
> +
> +	ret = mfd_add_devices(lp3943->dev, -1, lp3943_devs,
> +			ARRAY_SIZE(lp3943_devs), NULL, 0, NULL);
> +	if (ret) {
> +		dev_err(lp3943->dev, "failed to add MFD devices: %d\n", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int lp3943_remove(struct i2c_client *cl)
> +{
> +	struct lp3943 *lp3943 = i2c_get_clientdata(cl);
> +
> +	mfd_remove_devices(lp3943->dev);
> +	return 0;
> +}
> +
> +static const struct i2c_device_id lp3943_ids[] = {
> +	{ "lp3943", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, lp3943_ids);

Are we expecting this driver to support more devices?

> +static const struct of_device_id lp3943_dt_ids[] = {
> +	{ .compatible = "ti,lp3943", },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, lp3943_dt_ids);
> +
> +static struct i2c_driver lp3943_driver = {
> +	.driver = {
> +		.name = "lp3943",
> +		.owner = THIS_MODULE,
> +		.of_match_table = of_match_ptr(lp3943_dt_ids),
> +	},
> +	.probe = lp3943_probe,
> +	.remove = lp3943_remove,
> +	.id_table = lp3943_ids,
> +};
> +
> +static int __init lp3943_init(void)
> +{
> +	return i2c_add_driver(&lp3943_driver);
> +}
> +subsys_initcall(lp3943_init);
> +
> +static void __exit lp3943_exit(void)
> +{
> +	i2c_del_driver(&lp3943_driver);
> +}
> +module_exit(lp3943_exit);

I think you want to replace:
  lp3943_init()
  lp3943_exit

With:
  module_i2c_driver()

> +MODULE_DESCRIPTION("LP3943 MFD Core Driver");
> +MODULE_AUTHOR("Milo Kim");
> +MODULE_LICENSE("GPL");

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

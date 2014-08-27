Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934682AbaH0Njs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:39:48 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:34127 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933757AbaH0Njp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:39:45 -0400
Date: Wed, 27 Aug 2014 14:39:36 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lgirdwood@gmail.com, broonie@kernel.org,
        a.zummo@towertech.it, mturquette@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, heiko@sntech.de,
        olof@lixom.net, sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com
Subject: Re: [PATCH v6 2/5] MFD: RK808: Add new mfd driver for RK808
Message-ID: <20140827133936.GD6364@lee--X1>
References: <1409062444-12019-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409062444-12019-1-git-send-email-zyw@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Chris Zhong wrote:

> The RK808 chip is a power management IC for multimedia and handheld
> devices. It contains the following components:
> 
> - Regulators
> - RTC
> - Clkout
> 
> The RK808 core driver is registered as a platform driver and provides
> communication through I2C with the host device for the different
> components.
> 
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> Signed-off-by: Zhang Qing <zhangqing@rock-chips.com>
> 
> ---
> 
> Changes in v6:
> Adviced by Lee Jones in v2
> - rk808_i2c_client instead of g_rk808
> - remove pdata form struct rk808
> 
> Changes in v5: None
> Changes in v4:
> Adviced by Lee Jones in v2
> - modify the description in Kconfig
> - remove some unnecessary header files
> - remove dev from struct rk808
> - use enum for define RK808_ID...
> 
> Changes in v3:
> - fix compile err
> 
> Changes in v2:
> Adviced by Mark Browm:
> - use defines for register setting value
> - remove rtc alarm disable in shutdown
> - remove while(1) in shutdown
> - remove read 0x2f in probe
> 
>  drivers/mfd/Kconfig       |   13 +++
>  drivers/mfd/Makefile      |    1 +
>  drivers/mfd/rk808.c       |  257 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/rk808.h |  202 +++++++++++++++++++++++++++++++++++
>  4 files changed, 473 insertions(+)
>  create mode 100644 drivers/mfd/rk808.c
>  create mode 100644 include/linux/mfd/rk808.h

[...]

> diff --git a/drivers/mfd/rk808.c b/drivers/mfd/rk808.c
> new file mode 100644
> index 0000000..f0d6518
> --- /dev/null
> +++ b/drivers/mfd/rk808.c

[...]

> +static int rk808_probe(struct i2c_client *client,
> +		       const struct i2c_device_id *id)
> +{
> +	int ret;
> +	int pm_off = 0;
> +	struct rk808 *rk808;
> +	struct device_node *np = client->dev.of_node;

Are you prepared for np == NULL?

> +	pm_off = of_property_read_bool(np,
> +				       "rockchip,system-power-controller");

Rather than have this floating up here, can you put it down where it
is used?

> +	rk808 = devm_kzalloc(&client->dev, sizeof(*rk808), GFP_KERNEL);
> +	if (!rk808)
> +		return -ENOMEM;
> +
> +	rk808->i2c = client;
> +	i2c_set_clientdata(client, rk808);

I tend to like drive data set at the last moment.  Usually just
before mfd_add_devices().

> +	rk808->regmap = devm_regmap_init_i2c(client, &rk808_regmap_config);
> +	if (IS_ERR(rk808->regmap)) {
> +		dev_err(&client->dev, "regmap initialization failed\n");
> +		return PTR_ERR(rk808->regmap);
> +	}
> +
> +	ret = rk808_pre_init(rk808);
> +	if (ret)
> +		return ret;

Does this need to be a seperate function?  It's only one call to
egmap_update_bits() and is not reused.

> +	if (!client->irq) {
> +		dev_err(&client->dev, "No interrupt support, no core IRQ\n");
> +		return -EINVAL;
> +	}

If this is a show stopper, perhaps you should test for it higher up
before allocating anything else?

> +	ret = regmap_add_irq_chip(rk808->regmap, client->irq,
> +				  IRQF_ONESHOT, -1,
> +				  &rk808_irq_chip, &rk808->irq_data);
> +	if (ret) {
> +		dev_err(&client->dev, "Failed to add irq_chip %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = mfd_add_devices(&client->dev, -1,
> +			      rk808s, ARRAY_SIZE(rk808s),
> +			      NULL, 0, regmap_irq_get_domain(rk808->irq_data));
> +	if (ret) {
> +		dev_err(&client->dev, "failed to add MFD devices %d\n", ret);
> +		goto err_irq;
> +	}
> +
> +	if (pm_off && !pm_power_off) {
> +		rk808_i2c_client = client;
> +		pm_power_off = rk808_device_shutdown;
> +	}
> +
> +	return 0;
> +
> +err_irq:
> +	regmap_del_irq_chip(client->irq, rk808->irq_data);
> +	return ret;
> +}
> +
> +static int rk808_remove(struct i2c_client *client)
> +{
> +	struct rk808 *rk808 = i2c_get_clientdata(client);
> +
> +	regmap_del_irq_chip(client->irq, rk808->irq_data);
> +	mfd_remove_devices(&client->dev);
> +	pm_power_off = NULL;

'\n' here.  No need to squash everything together.

> +	return 0;
> +}
> +
> +static struct of_device_id rk808_of_match[] = {
> +	{ .compatible = "rockchip,rk808" },
> +};
> +MODULE_DEVICE_TABLE(of, rk808_of_match);
> +
> +static const struct i2c_device_id rk808_ids[] = {
> +	 { "rk808" },
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, rk808_ids);

My OCD senses are tingling.  Either have a blank line above the calls
to MODULE_DEVICE_TABLE() or don't.

> +static struct i2c_driver rk808_i2c_driver = {
> +	.driver = {
> +		.name = "rk808",
> +		.of_match_table = of_match_ptr(rk808_of_match),
> +	},
> +	.probe    = rk808_probe,
> +	.remove   = rk808_remove,
> +	.id_table = rk808_ids,
> +};
> +
> +module_i2c_driver(rk808_i2c_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Chris Zhong <zyw@rock-chips.com>");
> +MODULE_AUTHOR("Zhang Qing <zhangqing@rock-chips.com>");
> +MODULE_DESCRIPTION("RK808 PMIC driver");
> diff --git a/include/linux/mfd/rk808.h b/include/linux/mfd/rk808.h
> new file mode 100644
> index 0000000..7af1952
> --- /dev/null
> +++ b/include/linux/mfd/rk808.h
> @@ -0,0 +1,202 @@

[...]

> +struct rk808_board {
> +	struct regulator_init_data *rk808_init_data[RK808_NUM_REGULATORS];
> +	struct device_node *of_node[RK808_NUM_REGULATORS];
> +};

This is only used in the regulator driver.  Do you have a regulator
specific header file that you can define it in instead?

> +struct rk808 {
> +	struct i2c_client *i2c;
> +	struct regmap_irq_chip_data *irq_data;
> +	struct regmap *regmap;
> +};
> +#endif /* __LINUX_REGULATOR_rk808_H */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

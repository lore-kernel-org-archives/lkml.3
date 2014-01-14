Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbaANQbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:31:20 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:44284 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaANQbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:31:15 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-ff-52d5665242bb
Message-id: <52D56650.9070607@samsung.com>
Date: Tue, 14 Jan 2014 17:31:12 +0100
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: anton@enomsg.org, mk7.kang@samsung.com, kmpark@infradead.org
Subject: Re: [PATCH 1/3] power_supply: modelgauge_battery: Maxim ModelGauge ICs
 gauge
References: <1389286145-15375-1-git-send-email-vladimir.barinov@cogentembedded.com>
 <1389286145-15375-2-git-send-email-vladimir.barinov@cogentembedded.com>
In-reply-to: <1389286145-15375-2-git-send-email-vladimir.barinov@cogentembedded.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xa7pBaVeDDBafEbQ4uFXTYv6Rc6wW
	E1dOZrZ4/cLQ4tblVSwWl3fNYbPoONLCaNHXdZHdgcPjwdT/TB4T+j8xemxeoeXRt2UVo8fn
	TXIBrFFcNimpOZllqUX6dglcGZ8mpBS8FKuY8+0VSwPjb8EuRk4OCQETibuzN7FD2GISF+6t
	Z+ti5OIQEljKKNHxqAHK+cwoMW3FM5YuRg4OXgEtie+vKkAaWARUJZaemcgIYrMJGEtsXr6E
	DcQWFYiQeHV2IguIzSsgKPFj8j0WkDkiAt2MEst27AMrYhZwkFhwp4EZxBYWCJdYdHYj1LL5
	jBJ7W1eygiQ4BcIk3k7ezwLRYCbxqGUdM4QtL7F5zVvmCYwCs5AsmYWkbBaSsgWMzKsYRVNL
	kwuKk9JzjfSKE3OLS/PS9ZLzczcxQkL96w7GpcesDjEKcDAq8fD+CL8aJMSaWFZcmXuIUYKD
	WUmEd2Y0UIg3JbGyKrUoP76oNCe1+BAjEwenVANjQ9NerQed7g+LLtZldmi/EW47Xfchcu/2
	iT8m3vuyZvHLxrt9DcfWqm445Na0sWjSqtLaixMbP86d/WnDhPf7FP/OF/rte16d88B2c46g
	J7deudffYGGyWcbqGlrQdm/++cmGFoty7u+xWXTjTMLJjsslt39FfXh2J0rQSbZrRZ7VMv6i
	qVZnFyqxFGckGmoxFxUnAgAxLMs4UwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 05:49 PM, Vladimir Barinov wrote:
> Add Maxim ModelGauge ICs gauge driver for MAX17040/41/43/44/48/49/58/59 chips
>
> Signed-off-by: Vladimir Barinov <vladimir.barinov-M4DtvfQ/ZS1MRgGoP+s0PdBPR1lH4CV8@public.gmane.org>
>
> ---
>   drivers/power/Kconfig                            |    8
>   drivers/power/Makefile                           |    1
>   drivers/power/modelgauge_battery.c               |  875 +++++++++++++++++++++++
>   include/linux/platform_data/battery-modelgauge.h |   44 +
>   4 files changed, 928 insertions(+)
>

[...]

> +static int modelgauge_read_reg(struct i2c_client *client, u8 reg, u16 *value)
> +{
> +	int ret = i2c_smbus_read_word_data(client, reg);
> +
> +	if (ret < 0) {
> +		dev_err(&client->dev, "%s: err %d\n", __func__, ret);
> +		return ret;
> +	}
> +
> +	*value = be16_to_cpu(ret);
> +	return 0;
> +}

Have you considered using regmap for accessing registers? I know that 
other max17* drivers don't use it but it may be this could be the time 
to switch to regmap API?

[...]

> +static int modelgauge_probe(struct i2c_client *client,
> +			    const struct i2c_device_id *id)
> +{
> +	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
> +	struct modelgauge_priv *priv;
> +	int ret;
> +
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
> +		return -EIO;
> +
> +	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	if (client->dev.of_node)
> +		priv->pdata = modelgauge_parse_dt(&client->dev);
> +	else
> +		priv->pdata = client->dev.platform_data;
> +
> +	priv->client	= client;
> +	priv->chip	= id->driver_data;
> +
> +	i2c_set_clientdata(client, priv);
> +
> +	priv->battery.name		= "modelgauge_battery";
> +	priv->battery.type		= POWER_SUPPLY_TYPE_BATTERY;
> +	priv->battery.get_property	= modelgauge_get_property;
> +	priv->battery.properties	= modelgauge_battery_props;
> +	priv->battery.num_properties	= ARRAY_SIZE(modelgauge_battery_props);
> +
> +	INIT_WORK(&priv->load_work, modelgauge_load_model_work);
> +	INIT_DELAYED_WORK(&priv->rcomp_work, modelgauge_update_rcomp_work);
> +
> +	ret = modelgauge_init(priv);
> +	if (ret)
> +		return ret;
> +
> +	ret = power_supply_register(&client->dev, &priv->battery);
> +	if (ret) {
> +		dev_err(&client->dev, "failed: power supply register\n");
> +		goto err_supply;
> +	}
> +
> +	if (client->irq) {
> +		switch (priv->chip) {
> +		case ID_MAX17040:
> +		case ID_MAX17041:
> +			dev_err(&client->dev, "alert line is not supported\n");
> +			ret = -EINVAL;
> +			goto err_irq;
> +		default:
> +			ret = request_threaded_irq(client->irq, NULL,
> +						   modelgauge_irq_handler,
> +						   IRQF_TRIGGER_FALLING,
> +						   priv->battery.name, priv);

I think you may use devm_request_threaded_irq() here.

Best regards,
Krzysztof

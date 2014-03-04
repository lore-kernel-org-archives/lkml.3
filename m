Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbaCDKtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:49:06 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:65104 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230AbaCDKtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:49:04 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-34-5315af9d2099
Message-id: <1393930139.1222.7.camel@AMDC1943>
Subject: Re: [PATCH v2 1/3] power_supply: modelgauge_battery: Maxim ModelGauge
 ICs gauge
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Cc: anton@enomsg.org, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mk7.kang@samsung.com, mark.rutland@arm.com
Date: Tue, 04 Mar 2014 11:48:59 +0100
In-reply-to: <1391293385-27539-2-git-send-email-vladimir.barinov@cogentembedded.com>
References: <1391293385-27539-1-git-send-email-vladimir.barinov@cogentembedded.com>
 <1391293385-27539-2-git-send-email-vladimir.barinov@cogentembedded.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xy7pz14sGG7z8xmRxcKumxfwj51gt
	Jq6czGxxedccNoul1y8yWXQcaWG06Ou6yO7A7rFm3hpGjwdT/zN5TOj/xOixeYWWR9+WVYwe
	nzfJBbBFcdmkpOZklqUW6dslcGWsaZ3BUjBNu+LX9fusDYzPlboYOTgkBEwketsjuxg5gUwx
	iQv31rN1MXJxCAksZZQ4f2EOC4TzmVHi4OcfTCBVvAJ6Eu2/VzOD2MICURILr24Ci7MJGEts
	Xr6EDcQWEbCS2PV2EitIM7PAREaJm09usoFsYxFQlWjb7w1SwykQJtE6+w8rxIL5jBK79naw
	giSYBdQlJs1bxAxxkpLE7vZOdoi4vMTmNW+ZIY4QlPgx+R7LBEaBWUhaZiEpm4WkbAEj8ypG
	0dTS5ILipPRcI73ixNzi0rx0veT83E2MkGD/uoNx6TGrQ4wCHIxKPLwOU0SChVgTy4orcw8x
	SnAwK4nwKi4UDRbiTUmsrEotyo8vKs1JLT7EyMTBKdXAeNH6suS8pVfvPz0d9l14j/6Nid+8
	j5u/vsH8UbYoMWqF172MX84XUlz+/a05uGzn2w/XPL953V6uZNUqsqzy1/QAjUZNh0XzA3Tm
	7W6+KqTrs/v6KtNLmWXmLgHfz268ZbRFcalm1yKXqbe/TOT/3hSbf2Xjgh3fm+ufl8zYnD7T
	/1mh9EXh/H4lluKMREMt5qLiRADAO8EqVAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 2014-02-02 at 02:23 +0400, Vladimir Barinov wrote:
> Index: battery-2.6/drivers/power/modelgauge_battery.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ battery-2.6/drivers/power/modelgauge_battery.c	2014-02-02 01:29:34.314614874 +0400
> @@ -0,0 +1,838 @@
> +/*
> + * Maxim ModelGauge ICs fuel gauge driver
> + *
> + * Author: Vladimir Barinov <source@cogentembedded.com>
> + * Copyright (C) 2013 Cogent Embedded, Inc.
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */

(...)

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
> +	priv->dev	= &client->dev;
> +	priv->chip	= id->driver_data;
> +
> +	i2c_set_clientdata(client, priv);
> +
> +	priv->regmap = devm_regmap_init_i2c(client, &modelgauge_regmap);
> +	if (IS_ERR(priv->regmap))
> +		return PTR_ERR(priv->regmap);
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
> +		dev_err(priv->dev, "failed: power supply register\n");
> +		goto err_supply;
> +	}
> +
> +	if (client->irq) {
> +		switch (priv->chip) {
> +		case ID_MAX17040:
> +		case ID_MAX17041:
> +			dev_err(priv->dev, "alert line is not supported\n");
> +			ret = -EINVAL;
> +			goto err_irq;
> +		default:
> +			ret = devm_request_threaded_irq(priv->dev, client->irq,
> +							NULL,
> +							modelgauge_irq_handler,
> +							IRQF_TRIGGER_FALLING,
> +							priv->battery.name,
> +							priv);

Shouldn't it be also IRQF_ONESHOT? Without this you may get an error:
genirq: Threaded irq requested with handler=NULL and !ONESHOT for irq

> +			if (ret) {
> +				dev_err(priv->dev, "failed to request irq %d\n",
> +					client->irq);
> +				goto err_irq;
> +			}
> +		}
> +	}
> +
> +	return 0;
> +
> +err_irq:
> +	power_supply_unregister(&priv->battery);
> +err_supply:
> +	cancel_work_sync(&priv->load_work);
> +	cancel_delayed_work_sync(&priv->rcomp_work);
> +	return ret;
> +}
> +
> +static int modelgauge_remove(struct i2c_client *client)
> +{
> +	struct modelgauge_priv *priv = i2c_get_clientdata(client);
> +
> +	cancel_work_sync(&priv->load_work);
> +	cancel_delayed_work_sync(&priv->rcomp_work);
> +
> +	power_supply_unregister(&priv->battery);
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int modelgauge_suspend(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct modelgauge_priv *priv = i2c_get_clientdata(client);
> +	struct modelgauge_platform_data *pdata = priv->pdata;
> +
> +	if (pdata && pdata->get_temperature)
> +		cancel_delayed_work_sync(&priv->rcomp_work);
> +
> +	switch (priv->chip) {
> +	case ID_MAX17040:
> +	case ID_MAX17041:
> +		return 0;
> +	default:
> +		if (client->irq) {
> +			disable_irq(client->irq);
> +			enable_irq_wake(client->irq);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int modelgauge_resume(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct modelgauge_priv *priv = i2c_get_clientdata(client);
> +	struct modelgauge_platform_data *pdata = priv->pdata;
> +
> +	if (pdata && pdata->get_temperature)
> +		schedule_delayed_work(&priv->rcomp_work,
> +			    msecs_to_jiffies(MODELGAUGE_RCOMP_UPDATE_DELAY));
> +
> +	switch (priv->chip) {
> +	case ID_MAX17040:
> +	case ID_MAX17041:
> +		return 0;
> +	default:
> +		if (client->irq) {
> +			disable_irq_wake(client->irq);
> +			enable_irq(client->irq);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(modelgauge_pm_ops,
> +			 modelgauge_suspend, modelgauge_resume);
> +#define MODELGAUGE_PM_OPS (&modelgauge_pm_ops)
> +#else
> +#define MODELGAUGE_PM_OPS NULL
> +#endif /* CONFIG_PM_SLEEP */

You can simplify this into:
+}
+#endif /* CONFIG_PM_SLEEP */
+
+static SIMPLE_DEV_PM_OPS(modelgauge_pm_ops,
+			 modelgauge_suspend, modelgauge_resume);

And later:
+static struct i2c_driver modelgauge_i2c_driver = {
+	.driver	= {
+		.name		= DRV_NAME,
+		.of_match_table	= of_match_ptr(modelgauge_match),
+		.pm		= &modelgauge_pm_ops,


Anyway, I like the idea of merging these drivers so I'm happy to test it
further.


Best regards,
Krzysztof


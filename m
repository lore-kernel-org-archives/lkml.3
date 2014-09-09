Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbaIIKct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:32:49 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.140]:36435 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932340AbaIIKcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:32:45 -0400
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-16.tower-179.messagelabs.com!1410258761!37099971!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: Varka Bhadram <varkabhadram@gmail.com>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Support Opensource" <Support.Opensource@diasemi.com>
Subject: RE: [PATCH v2 1/7] mfd: Add support for DA9150 combined charger &
 fuel-gauge device
Thread-Topic: [PATCH v2 1/7] mfd: Add support for DA9150 combined charger &
 fuel-gauge device
Thread-Index: AQHPwq2qx8nTzPhylUOPMOTaGYVHb5vl1XgAgBLXD/A=
Date: Tue, 9 Sep 2014 10:32:40 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A0337AB5144B5@SW-EX-MBX01.diasemi.com>
References: <cover.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
 <d6c7de200c9447dbafa74ee76739da943a0b73b2.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
 <53FF16BC.9050701@gmail.com>
In-Reply-To: <53FF16BC.9050701@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.15]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s89AWrah005610

On August 28, 2014 12:47, Varka Bhadram wrote:

> On 08/28/2014 04:18 PM, Adam Thomson wrote:
> 
> (...)
> 
> > +static int da9150_probe(struct i2c_client *client,
> > +			const struct i2c_device_id *id)
> > +{
> > +	struct da9150 *da9150;
> > +	int ret;
> > +
> > +	da9150 = devm_kzalloc(&client->dev, sizeof(struct da9150), GFP_KERNEL);
> > +	if (da9150 == NULL)
> > +		return -ENOMEM;
> 
> da9150 = devm_kzalloc(&client->dev, sizeof(*da9150), GFP_KERNEL);
> if (!da9150)
> 	return -ENOMEM;

Ok, no real difference, but can change it.

> 
> > +	da9150->dev = &client->dev;
> > +	da9150->irq = client->irq;
> > +	i2c_set_clientdata(client, da9150);
> > +	dev_set_drvdata(da9150->dev, da9150);
> > +
> > +	da9150->regmap = devm_regmap_init_i2c(client, &da9150_regmap_config);
> > +	if (IS_ERR(da9150->regmap)) {
> > +		ret = PTR_ERR(da9150->regmap);
> > +		dev_err(da9150->dev, "Failed to allocate register map: %d\n",
> > +			ret);
> > +		return ret;
> > +	}
> > +
> > +	return da9150_device_init(da9150);
> > +}
> > +
> > +static int da9150_remove(struct i2c_client *client)
> > +{
> > +	struct da9150 *da9150 = i2c_get_clientdata(client);
> > +
> > +	da9150_device_exit(da9150);
> > +
> > +	return 0;
> > +}
> > +
> > +static void da9150_shutdown(struct i2c_client *client)
> > +{
> > +	struct da9150 *da9150 = i2c_get_clientdata(client);
> > +
> > +	da9150_device_shutdown(da9150);
> > +}
> > +
> > +static const struct i2c_device_id da9150_i2c_id[] = {
> > +	{ "da9150", 0 },
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(i2c, da9150_i2c_id);
> > +
> > +static const struct of_device_id da9150_of_match[] = {
> > +	{ .compatible = "dlg,da9150", },
> > +	{ }
> > +};
> > +
> 
> missed MODULE_DEVICE_TABLE(of, ...)   ?

Ok, will add that in.

> 
> > +static struct i2c_driver da9150_driver = {
> > +	.driver	= {
> > +		.name	= "da9150",
> > +		.owner	= THIS_MODULE,
> 
> No need to update this field...

Ok, will remove .owner setting.

> 
> > +		.of_match_table = of_match_ptr(da9150_of_match),
> > +	},
> > +	.probe		= da9150_probe,
> > +	.remove		= da9150_remove,
> > +	.shutdown	= da9150_shutdown,
> > +	.id_table	= da9150_i2c_id,
> > +};
> > +
> > +module_i2c_driver(da9150_driver);
> > +
> > +MODULE_DESCRIPTION("I2C Driver for DA9150");
> > +MODULE_AUTHOR("Adam Thomson
> <Adam.Thomson.Opensource@diasemi.com");
> > +MODULE_LICENSE("GPL");
> >
> --
> Regards,
> Varka Bhadram.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

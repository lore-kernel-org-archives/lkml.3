Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab3K0NKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 08:10:05 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:46744 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3K0NKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:10:03 -0500
Date: Wed, 27 Nov 2013 13:09:54 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: swarren@wwwdotorg.org, thierry.reding@gmail.com, sameo@linux.intel.com,
        dev@lynxeye.de, mark.rutland@arm.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] mfd: tps6586x: add version detection
Message-ID: <20131127130954.GF3296@lee--X1>
References: <cover.1385508112.git.stefan@agner.ch>
 <ef881d39f78b75b4badeebb5be0264edc3906d86.1385508112.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ef881d39f78b75b4badeebb5be0264edc3906d86.1385508112.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>

>  static int __remove_subdev(struct device *dev, void *unused)
>  {
>  	platform_device_unregister(to_platform_device(dev));
> @@ -477,6 +486,7 @@ static int tps6586x_i2c_probe(struct i2c_client *client,
>  {
>  	struct tps6586x_platform_data *pdata = dev_get_platdata(&client->dev);
>  	struct tps6586x *tps6586x;
> +	const char *name = "";

How much memory space does this guarantee?

>  	int ret;
>  
>  	if (!pdata && client->dev.of_node)
> @@ -487,20 +497,39 @@ static int tps6586x_i2c_probe(struct i2c_client *client,
>  		return -ENOTSUPP;
>  	}
>  
> +	tps6586x = devm_kzalloc(&client->dev, sizeof(*tps6586x), GFP_KERNEL);
> +	if (tps6586x == NULL) {

Can you take this oppotunity to change to:
  if (!tps6586x)

> +		dev_err(&client->dev, "memory for tps6586x alloc failed\n");

I'm not keen on -ENOMEM prints, just return -ENOMEM and be done with it.

> +		return -ENOMEM;
> +	}
> +
>  	ret = i2c_smbus_read_byte_data(client, TPS6586X_VERSIONCRC);

If you're going to do this, please change 'ret' to 'version'.

>  	if (ret < 0) {
>  		dev_err(&client->dev, "Chip ID read failed: %d\n", ret);
>  		return -EIO;

Why are you returning an error here when you have a valid enum of:
  TPS6586X_ANY	= -1,

>  	}
>  
> -	dev_info(&client->dev, "VERSIONCRC is %02x\n", ret);
> -
> -	tps6586x = devm_kzalloc(&client->dev, sizeof(*tps6586x), GFP_KERNEL);
> -	if (tps6586x == NULL) {
> -		dev_err(&client->dev, "memory for tps6586x alloc failed\n");
> -		return -ENOMEM;
> +	tps6586x->version = (enum tps6586x_version)ret;
> +	switch (ret) {
> +	case TPS658621A:
> +		name = "TPS658621A";
> +		break;
> +	case TPS658621CD:
> +		name = "TPS658621C/D";
> +		break;
> +	case TPS658623:
> +		name = "TPS658623";
> +		break;
> +	case TPS658643:
> +		name = "TPS658643";
> +		break;
> +	default:
> +		name = "TPS6586X";
> +		break;
>  	}
>  
> +	dev_info(&client->dev, "Found %s, VERSIONCRC is %02x\n", name, ret);
> +

I'd suggest pulling this out of probe() and into a separate subroutine.

<snip>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

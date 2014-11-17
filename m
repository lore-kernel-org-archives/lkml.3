Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaKQO7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:59:36 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40780 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753115AbaKQO7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 09:59:33 -0500
Date: Mon, 17 Nov 2014 16:58:58 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, bcousson@baylibre.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        j.anaszewski@samsung.com
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
Message-ID: <20141117145857.GO8907@valkosipuli.retiisi.org.uk>
References: <20141116075928.GA9763@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141116075928.GA9763@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Sun, Nov 16, 2014 at 08:59:28AM +0100, Pavel Machek wrote:
> For device tree people: Yes, I know I'll have to create file in
> documentation, but does the binding below look acceptable?
> 
> I'll clean up driver code a bit more, remove the printks. Anything
> else obviously wrong?

Jacek Anaszewski is working on flash support for LED devices. I think it'd
be good to sync the DT bindings for the two, as the types of devices
supported by the LED API and the V4L2 flash API are quite similar.

Cc Jacek.

> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> Thanks,
> 								Pavel
> 
> 
> diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
> index 739fcf2..ed0bfc1 100644
> --- a/arch/arm/boot/dts/omap3-n900.dts
> +++ b/arch/arm/boot/dts/omap3-n900.dts
> @@ -553,6 +561,18 @@
>  
>  		ti,usb-charger-detection = <&isp1704>;
>  	};
> +
> +	adp1653: adp1653@30 {
> +		compatible = "ad,adp1653";
> +		reg = <0x30>;
> +
> +		max-flash-timeout-usec = <500000>;
> +		max-flash-intensity-uA    = <320000>;
> +		max-torch-intensity-uA     = <50000>;
> +		max-indicator-intensity-uA = <17500>;
> +
> +		gpios = <&gpio3 24 GPIO_ACTIVE_HIGH>; /* Want 88 */
> +	};
>  };
>  
>  &i2c3 {
> diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
> index 873fe19..e21ed02 100644
> --- a/drivers/media/i2c/adp1653.c
> +++ b/drivers/media/i2c/adp1653.c
> @@ -8,6 +8,7 @@
>   * Contributors:
>   *	Sakari Ailus <sakari.ailus@iki.fi>
>   *	Tuukka Toivonen <tuukkat76@gmail.com>
> + *      Pavel Machek <pavel@ucw.cz>
>   *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public License
> @@ -34,9 +35,12 @@
>  #include <linux/module.h>
>  #include <linux/i2c.h>
>  #include <linux/slab.h>
> +#include <linux/of_gpio.h>
>  #include <media/adp1653.h>
>  #include <media/v4l2-device.h>
>  
> +#include <linux/gpio.h>
> +
>  #define TIMEOUT_MAX		820000
>  #define TIMEOUT_STEP		54600
>  #define TIMEOUT_MIN		(TIMEOUT_MAX - ADP1653_REG_CONFIG_TMR_SET_MAX \
> @@ -308,7 +316,16 @@ __adp1653_set_power(struct adp1653_flash *flash, int on)
>  {
>  	int ret;
>  
> -	ret = flash->platform_data->power(&flash->subdev, on);
> +	if (flash->platform_data->power)
> +		ret = flash->platform_data->power(&flash->subdev, on);
> +	else {
> +		gpio_set_value(flash->platform_data->power_gpio, on);
> +		if (on) {
> +			/* Some delay is apparently required. */
> +			udelay(20);
> +		}
> +	}
> +			
>  	if (ret < 0)
>  		return ret;
>  
> @@ -316,8 +333,13 @@ __adp1653_set_power(struct adp1653_flash *flash, int on)
>  		return 0;
>  
>  	ret = adp1653_init_device(flash);
> -	if (ret < 0)
> +	if (ret >= 0)
> +		return ret;
> +
> +	if (flash->platform_data->power)
>  		flash->platform_data->power(&flash->subdev, 0);
> +	else
> +		gpio_set_value(flash->platform_data->power_gpio, 0);
>  
>  	return ret;
>  }
> @@ -407,21 +429,87 @@ static int adp1653_resume(struct device *dev)
>  
>  #endif /* CONFIG_PM */
>  
> +
> +
> +
> +
> +
> +
> +
> +
> +
> +
> +
> +
> +
> +static int adp1653_of_init(struct i2c_client *client, struct adp1653_flash *flash, 
> +			   struct device_node *node)
> +{
> +	u32 val;
> +	struct adp1653_platform_data *pd;
> +	enum of_gpio_flags flags;
> +	int gpio;
> +
> +	if (!node)
> +		return -EINVAL;
> +
> +	printk("adp1653: no platform data\n");
> +	pd = devm_kzalloc(&client->dev, sizeof(*pd), GFP_KERNEL);
> +	if (!pd)
> +		return -ENOMEM;
> +	flash->platform_data = pd;
> +
> +
> +
> +
> +
> +
> +
> +	if (of_property_read_u32(node, "max-flash-timeout-usec", &val)) return -EINVAL;
> +	pd->max_flash_timeout = val;
> +	if (of_property_read_u32(node, "max-flash-intensity-uA", &val)) return -EINVAL;
> +	pd->max_flash_intensity = val/1000;
> +	if (of_property_read_u32(node, "max-torch-intensity-uA", &val)) return -EINVAL;
> +	pd->max_torch_intensity = val/1000;
> +	if (of_property_read_u32(node, "max-indicator-intensity-uA", &val)) return -EINVAL;
> +	pd->max_indicator_intensity = val;
> +
> +	if (!of_find_property(node, "gpios", NULL)) {
> +		printk("No gpio node\n");
> +		return -EINVAL;
> +	}
> +
> +	gpio = of_get_gpio_flags(node, 0, &flags);
> +	if (gpio < 0) {
> +		printk("Error getting GPIO\n"); 
> +		return -EINVAL;
> +	}
> +
> +	pd->power_gpio = gpio;
> +
> +	return 0;
> +}
> +
> +
>  static int adp1653_probe(struct i2c_client *client,
>  			 const struct i2c_device_id *devid)
>  {
>  	struct adp1653_flash *flash;
>  	int ret;
>  
> -	/* we couldn't work without platform data */
> -	if (client->dev.platform_data == NULL)
> -		return -ENODEV;
> +	printk("adp1653: probe\n");
>  
>  	flash = devm_kzalloc(&client->dev, sizeof(*flash), GFP_KERNEL);
>  	if (flash == NULL)
>  		return -ENOMEM;
>  
> -	flash->platform_data = client->dev.platform_data;
> +	/* we couldn't work without platform data */
> +	if (client->dev.platform_data == NULL) {
> +		ret = adp1653_of_init(client, flash, client->dev.of_node);
> +		if (ret)
> +			return ret;
> +	} else
> +		flash->platform_data = client->dev.platform_data;
>  
>  	mutex_init(&flash->power_lock);
>  
> @@ -439,9 +527,15 @@ static int adp1653_probe(struct i2c_client *client,
>  
>  	flash->subdev.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
>  
> +	__adp1653_set_power(flash, 1);
> +
> +	__adp1653_set_power(flash, 0);
> +	printk("Flash should have blinked\n");
> +
>  	return 0;
>  
>  free_and_quit:
> +	printk("adp1653: something failed registering\n");
>  	v4l2_ctrl_handler_free(&flash->ctrls);
>  	return ret;
>  }
> diff --git a/include/media/adp1653.h b/include/media/adp1653.h
> index 1d9b48a..b556580 100644
> --- a/include/media/adp1653.h
> +++ b/include/media/adp1653.h
> @@ -100,9 +100,11 @@ struct adp1653_platform_data {
>  	int (*power)(struct v4l2_subdev *sd, int on);
>  
>  	u32 max_flash_timeout;		/* flash light timeout in us */
> -	u32 max_flash_intensity;	/* led intensity, flash mode */
> -	u32 max_torch_intensity;	/* led intensity, torch mode */
> -	u32 max_indicator_intensity;	/* indicator led intensity */
> +	u32 max_flash_intensity;	/* led intensity, flash mode, mA */
> +	u32 max_torch_intensity;	/* led intensity, torch mode, mA */
> +	u32 max_indicator_intensity;	/* indicator led intensity, uA */
> +
> +	int power_gpio;			/* for device-tree based boot */
>  };
>  
>  #define to_adp1653_flash(sd)	container_of(sd, struct adp1653_flash, subdev)
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab3FSS0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:26:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37395 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757362Ab3FSS0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:26:19 -0400
Message-ID: <51C1F6C8.30302@ti.com>
Date: Wed, 19 Jun 2013 21:22:00 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [RFC] i2c: add deprecation warning for class based instantiation
References: <20130607090623.GC3428@katana> <1370596166-12404-1-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1370596166-12404-1-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 12:09 PM, Wolfram Sang wrote:
> Class based instantiation can cause huge delays when booting. This
> mechanism was used when it was not possible to describe slaves on I2C
> busses. We now have other mechanisms, so most embedded I2C will not need
> classes and it was explicitly not recommended to use them. Add a
> deprecation warning for drivers who want to disable class based in the
> near future to gain boot-up time, so users relying on this technique can
> switch to something better. They really should.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>   drivers/i2c/busses/i2c-omap.c |    2 +-
>   drivers/i2c/i2c-core.c        |    6 ++++++
>   include/linux/i2c.h           |    1 +
>   3 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index e02f9e3..f06109f 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -1231,7 +1231,7 @@ omap_i2c_probe(struct platform_device *pdev)
>   	adap = &dev->adapter;
>   	i2c_set_adapdata(adap, dev);
>   	adap->owner = THIS_MODULE;
> -	adap->class = I2C_CLASS_HWMON;
> +	adap->class = I2C_CLASS_HWMON | I2C_CLASS_DEPRECATED;
>   	strlcpy(adap->name, "OMAP I2C adapter", sizeof(adap->name));
>   	adap->algo = &omap_i2c_algo;
>   	adap->dev.parent = &pdev->dev;
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 48e31ed..47ea1f0 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -999,6 +999,12 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
>   		return -EINVAL;
>   	}
>   
> +	if (adap->class & I2C_CLASS_DEPRECATED)
> +		dev_warn(&adap->dev, "This adapter will soon drop class based "
> +			"instantiation of slaves\nPlease make sure all its I2C "
> +			"devices are instantiated by other means.\nCheck "
> +			"'Documentation/i2c/instantiating-devices' for details\n");
> +
Seems, this need to be moved down - after     res = 
device_register(&adap->dev);
- or - right before:     bus_for_each_drv(&i2c_bus_type, NULL, adap, 
__process_new_adapter);


>   	rt_mutex_init(&adap->bus_lock);
>   	mutex_init(&adap->userspace_clients_lock);
>   	INIT_LIST_HEAD(&adap->userspace_clients);
> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> index e988fa9..ffab838 100644
> --- a/include/linux/i2c.h
> +++ b/include/linux/i2c.h
> @@ -473,6 +473,7 @@ void i2c_unlock_adapter(struct i2c_adapter *);
>   #define I2C_CLASS_HWMON		(1<<0)	/* lm_sensors, ... */
>   #define I2C_CLASS_DDC		(1<<3)	/* DDC bus on graphics adapters */
>   #define I2C_CLASS_SPD		(1<<7)	/* Memory modules */
> +#define I2C_CLASS_DEPRECATED	(1<<8)	/* Warn users that adapter will stop using classes */
>   
>   /* Internal numbers to terminate lists */
>   #define I2C_CLIENT_END		0xfffeU



- grygorii

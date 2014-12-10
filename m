Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbaLJNsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:48:24 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37582 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753017AbaLJNsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:48:22 -0500
Date: Wed, 10 Dec 2014 15:48:16 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, s.nawrocki@samsung.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH/RFC v9 19/19] leds: aat1290: add support for V4L2 Flash
 sub-device
Message-ID: <20141210134816.GO15559@valkosipuli.retiisi.org.uk>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-20-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417622814-10845-20-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

On Wed, Dec 03, 2014 at 05:06:54PM +0100, Jacek Anaszewski wrote:
> Add support for V4L2 Flash sub-device to the aat1290 LED Flash class
> driver. The support allows for V4L2 Flash sub-device to take the control
> of the LED Flash class device.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/leds/leds-aat1290.c |   61 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 61 insertions(+)
> 
> diff --git a/drivers/leds/leds-aat1290.c b/drivers/leds/leds-aat1290.c
> index 15d969b..81a8f48 100644
> --- a/drivers/leds/leds-aat1290.c
> +++ b/drivers/leds/leds-aat1290.c
> @@ -21,6 +21,7 @@
>  #include <linux/gpio.h>
>  #include <linux/of_gpio.h>
>  #include <linux/of.h>
> +#include <media/v4l2-flash.h>
>  #include <linux/workqueue.h>
>  
>  #define AAT1290_MOVIE_MODE_CURRENT_ADDR	17
> @@ -63,6 +64,7 @@ struct aat1290_led {
>  	struct mutex lock;
>  
>  	struct led_classdev_flash ldev;
> +	struct v4l2_flash *v4l2_flash;
>  
>  	int flen_gpio;
>  	int en_set_gpio;
> @@ -280,11 +282,51 @@ static void aat1290_init_flash_settings(struct aat1290_led *led,
>  	setting->val = setting->max;
>  }
>  
> +#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
> +static void aat1290_init_v4l2_ctrl_config(struct aat1290_led_settings *s,
> +					struct v4l2_flash_ctrl_config *config)
> +{
> +	struct led_flash_setting *setting;
> +	struct v4l2_ctrl_config *c;
> +
> +	c = &config->intensity;
> +	setting = &s->torch_brightness;
> +	c->min = setting->min;
> +	c->max = setting->max;
> +	c->step = setting->step;

Hmm. How does the intensity get configured over the V4L2 controls? Based on
an earlier patch, the intensity control looks very much non-linear.

> +	c->def = setting->val;
> +
> +	c = &config->flash_timeout;
> +	setting = &s->flash_timeout;
> +	c->min = setting->min;
> +	c->max = setting->max;
> +	c->step = setting->step;
> +	c->def = setting->val;
> +
> +	config->has_external_strobe = false;
> +}
> +#else
> +#define aat1290_init_v4l2_ctrl_config(s, config)
> +#endif
> +
>  static const struct led_flash_ops flash_ops = {
>  	.strobe_set = aat1290_led_flash_strobe_set,
>  	.timeout_set = aat1290_led_flash_timeout_set,
>  };
>  
> +#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
> +static const struct v4l2_flash_ops v4l2_flash_ops = {
> +	.external_strobe_set = NULL,
> +};
> +
> +static const struct v4l2_flash_ops *get_v4l2_flash_ops(void)
> +{
> +	return &v4l2_flash_ops;

You can use v4l2_flash_ops directly, no need for a function to return them.

> +}
> +#else
> +#define get_v4l2_flash_ops() (NULL)
> +#endif
> +
>  static int aat1290_led_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
> @@ -292,6 +334,9 @@ static int aat1290_led_probe(struct platform_device *pdev)
>  	struct aat1290_led *led;
>  	struct led_classdev *led_cdev;
>  	struct led_classdev_flash *flash;
> +#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
> +	struct v4l2_flash_ctrl_config v4l2_flash_config;
> +#endif
>  	struct aat1290_led_settings settings;
>  	int flen_gpio, enset_gpio, ret;
>  
> @@ -344,6 +389,9 @@ static int aat1290_led_probe(struct platform_device *pdev)
>  
>  	flash->timeout = settings.flash_timeout;
>  
> +	/* Init V4L2 Flash controls basing on initialized settings */
> +	aat1290_init_v4l2_ctrl_config(&settings, &v4l2_flash_config);
> +
>  	/* Init led class */
>  	led_cdev = &flash->led_cdev;
>  	led_cdev->name = led->label;
> @@ -361,8 +409,20 @@ static int aat1290_led_probe(struct platform_device *pdev)
>  	if (ret < 0)
>  		goto error_gpio_en_set;
>  
> +	/* Create V4L2 Flash subdev. */
> +	led->v4l2_flash = v4l2_flash_init(flash,
> +					  get_v4l2_flash_ops(),
> +					  dev_node,
> +					  &v4l2_flash_config);

Less newlines needed; up to you.

> +	if (IS_ERR(led->v4l2_flash)) {
> +		ret = PTR_ERR(led->v4l2_flash);
> +		goto error_v4l2_flash_init;
> +	}
> +
>  	return 0;
>  
> +error_v4l2_flash_init:
> +	led_classdev_flash_unregister(flash);
>  error_gpio_en_set:
>  	if (gpio_is_valid(enset_gpio))
>  		gpio_free(enset_gpio);
> @@ -378,6 +438,7 @@ static int aat1290_led_remove(struct platform_device *pdev)
>  {
>  	struct aat1290_led *led = platform_get_drvdata(pdev);
>  
> +	v4l2_flash_release(led->v4l2_flash);
>  	led_classdev_flash_unregister(&led->ldev);
>  	cancel_work_sync(&led->work_brightness_set);
>  

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

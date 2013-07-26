Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab3GZTSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 15:18:34 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:46396 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab3GZTSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 15:18:33 -0400
MIME-Version: 1.0
In-Reply-To: <1374703539-9705-11-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org> <1374703539-9705-11-git-send-email-gregkh@linuxfoundation.org>
From: Bryan Wu <cooloney@gmail.com>
Date: Fri, 26 Jul 2013 12:18:11 -0700
Message-ID: <CAK5ve-KeuYLkZtMs9pD2pcwQ34k1nJu4bby_t9vyOcqj69chEw@mail.gmail.com>
Subject: Re: [PATCH 10/36] leds: convert class code to use dev_groups
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 3:05 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> The dev_attrs field of struct class is going away soon, dev_groups
> should be used instead.  This converts the led class code to use the
> correct field.
>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>
> Bryan and Richard, feel free to take this through your tree, or ACK it and I
> can take it through mine.
>

Looks good to me, please take it through yours with my ACK.
Acked-by: Bryan Wu <cooloney@gmail.com>

Thanks,
-Bryan

>  drivers/leds/led-class.c | 38 ++++++++++++++++++++++++++++++--------
>  1 file changed, 30 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index 4336e37a..f37d63cf 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -29,7 +29,7 @@ static void led_update_brightness(struct led_classdev *led_cdev)
>                 led_cdev->brightness = led_cdev->brightness_get(led_cdev);
>  }
>
> -static ssize_t led_brightness_show(struct device *dev,
> +static ssize_t brightness_show(struct device *dev,
>                 struct device_attribute *attr, char *buf)
>  {
>         struct led_classdev *led_cdev = dev_get_drvdata(dev);
> @@ -40,7 +40,7 @@ static ssize_t led_brightness_show(struct device *dev,
>         return sprintf(buf, "%u\n", led_cdev->brightness);
>  }
>
> -static ssize_t led_brightness_store(struct device *dev,
> +static ssize_t brightness_store(struct device *dev,
>                 struct device_attribute *attr, const char *buf, size_t size)
>  {
>         struct led_classdev *led_cdev = dev_get_drvdata(dev);
> @@ -57,6 +57,7 @@ static ssize_t led_brightness_store(struct device *dev,
>
>         return size;
>  }
> +static DEVICE_ATTR_RW(brightness);
>
>  static ssize_t led_max_brightness_show(struct device *dev,
>                 struct device_attribute *attr, char *buf)
> @@ -65,14 +66,35 @@ static ssize_t led_max_brightness_show(struct device *dev,
>
>         return sprintf(buf, "%u\n", led_cdev->max_brightness);
>  }
> +static DEVICE_ATTR(max_brightness, 0444, led_max_brightness_show, NULL);
>
> -static struct device_attribute led_class_attrs[] = {
> -       __ATTR(brightness, 0644, led_brightness_show, led_brightness_store),
> -       __ATTR(max_brightness, 0444, led_max_brightness_show, NULL),
>  #ifdef CONFIG_LEDS_TRIGGERS
> -       __ATTR(trigger, 0644, led_trigger_show, led_trigger_store),
> +static DEVICE_ATTR(trigger, 0644, led_trigger_show, led_trigger_store);
> +static struct attribute *led_trigger_attrs[] = {
> +       &dev_attr_trigger.attr,
> +       NULL,
> +};
> +static const struct attribute_group led_trigger_group = {
> +       .attrs = led_trigger_attrs,
> +};
> +#endif
> +
> +static struct attribute *led_class_attrs[] = {
> +       &dev_attr_brightness.attr,
> +       &dev_attr_max_brightness.attr,
> +       NULL,
> +};
> +
> +static const struct attribute_group led_group = {
> +       .attrs = led_class_attrs,
> +};
> +
> +static const struct attribute_group *led_groups[] = {
> +       &led_group,
> +#ifdef CONFIG_LEDS_TRIGGERS
> +       &led_trigger_group,
>  #endif
> -       __ATTR_NULL,
> +       NULL,
>  };
>
>  static void led_timer_function(unsigned long data)
> @@ -258,7 +280,7 @@ static int __init leds_init(void)
>         if (IS_ERR(leds_class))
>                 return PTR_ERR(leds_class);
>         leds_class->pm = &leds_class_dev_pm_ops;
> -       leds_class->dev_attrs = led_class_attrs;
> +       leds_class->dev_groups = led_groups;
>         return 0;
>  }
>
> --
> 1.8.3.rc0.20.gb99dd2e
>

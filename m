Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbaILBLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 21:11:38 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:57640 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaILBLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 21:11:36 -0400
MIME-Version: 1.0
In-Reply-To: <1408542118-32723-3-git-send-email-j.anaszewski@samsung.com>
References: <1408542118-32723-1-git-send-email-j.anaszewski@samsung.com> <1408542118-32723-3-git-send-email-j.anaszewski@samsung.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 11 Sep 2014 18:11:11 -0700
Message-ID: <CAK5ve-+Trcg+ZL5gBZmpY_Zcqk5VOhP7jowS8Liqcz0pO_UbBQ@mail.gmail.com>
Subject: Re: [PATCH/RFC v5 2/4] leds: implement sysfs interface locking mechanism
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, b.zolnierkie@samsung.com,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 6:41 AM, Jacek Anaszewski
<j.anaszewski@samsung.com> wrote:
> Add a mechanism for locking LED subsystem sysfs interface.
> This patch prepares ground for addition of LED Flash Class
> extension, whose API will be integrated with V4L2 Flash API.
> Such a fusion enforces introducing a locking scheme, which
> will secure consistent access to the LED Flash Class device.
>
> The mechanism being introduced allows for disabling LED
> subsystem sysfs interface by calling led_sysfs_lock function
> and enabling it by calling led_sysfs_unlock. The functions
> alter the LED_SYSFS_LOCK flag state and must be called
> under mutex lock. The state of the lock is checked with use
> of led_sysfs_is_locked function. Such a design allows for
> providing immediate feedback to the user space on whether
> the LED Flash Class device is available or is under V4L2 Flash
> sub-device control.
>
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
>  drivers/leds/led-class.c    |   23 ++++++++++++++++++++---
>  drivers/leds/led-core.c     |   18 ++++++++++++++++++
>  drivers/leds/led-triggers.c |   15 ++++++++++++---
>  include/linux/leds.h        |   32 ++++++++++++++++++++++++++++++++
>  4 files changed, 82 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index 6f82a76..0bc0ba9 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -39,17 +39,31 @@ static ssize_t brightness_store(struct device *dev,
>  {
>         struct led_classdev *led_cdev = dev_get_drvdata(dev);
>         unsigned long state;
> -       ssize_t ret = -EINVAL;
> +       ssize_t ret;
> +
> +#ifdef CONFIG_V4L2_FLASH_LED_CLASS

Can we remove this #ifdef? Following code looks good to the common LED class.

> +       mutex_lock(&led_cdev->led_lock);

Can we choose more meaningful name instead of led_lock here?
Then use led_sysfs_enable() instead of led_sysfs_unlock()
led_sysfs_disable instead of led_sysfs_lock()
led_sysfs_is_disabled instead of led_sysfs_is_locked()

And the flag LED_SYSFS_LOCK -> LED_SYSFS_DISABLE

I was just confused by the name lock and unlock and mutex lock.

The idea looks good to me.

Thanks,
-Bryan

> +
> +       if (led_sysfs_is_locked(led_cdev)) {
> +               ret = -EBUSY;
> +               goto unlock;
> +       }
> +#endif
>
>         ret = kstrtoul(buf, 10, &state);
>         if (ret)
> -               return ret;
> +               goto unlock;
>
>         if (state == LED_OFF)
>                 led_trigger_remove(led_cdev);
>         __led_set_brightness(led_cdev, state);
>
> -       return size;
> +       ret = size;
> +unlock:
> +#ifdef CONFIG_V4L2_FLASH_LED_CLASS
> +       mutex_unlock(&led_cdev->led_lock);
> +#endif
> +       return ret;
>  }
>  static DEVICE_ATTR_RW(brightness);
>
> @@ -215,6 +229,7 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
>  #ifdef CONFIG_LEDS_TRIGGERS
>         init_rwsem(&led_cdev->trigger_lock);
>  #endif
> +       mutex_init(&led_cdev->led_lock);
>         /* add to the list of leds */
>         down_write(&leds_list_lock);
>         list_add_tail(&led_cdev->node, &leds_list);
> @@ -266,6 +281,8 @@ void led_classdev_unregister(struct led_classdev *led_cdev)
>         down_write(&leds_list_lock);
>         list_del(&led_cdev->node);
>         up_write(&leds_list_lock);
> +
> +       mutex_destroy(&led_cdev->led_lock);
>  }
>  EXPORT_SYMBOL_GPL(led_classdev_unregister);
>
> diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
> index 466ce5a..4649ea5 100644
> --- a/drivers/leds/led-core.c
> +++ b/drivers/leds/led-core.c
> @@ -143,3 +143,21 @@ int led_update_brightness(struct led_classdev *led_cdev)
>         return ret;
>  }
>  EXPORT_SYMBOL(led_update_brightness);
> +
> +/* Caller must ensure led_cdev->led_lock held */
> +void led_sysfs_lock(struct led_classdev *led_cdev)
> +{
> +       lockdep_assert_held(&led_cdev->led_lock);
> +
> +       led_cdev->flags |= LED_SYSFS_LOCK;
> +}
> +EXPORT_SYMBOL_GPL(led_sysfs_lock);
> +
> +/* Caller must ensure led_cdev->led_lock held */
> +void led_sysfs_unlock(struct led_classdev *led_cdev)
> +{
> +       lockdep_assert_held(&led_cdev->led_lock);
> +
> +       led_cdev->flags &= ~LED_SYSFS_LOCK;
> +}
> +EXPORT_SYMBOL_GPL(led_sysfs_unlock);
> diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
> index c3734f1..d391a5d 100644
> --- a/drivers/leds/led-triggers.c
> +++ b/drivers/leds/led-triggers.c
> @@ -37,6 +37,11 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
>         char trigger_name[TRIG_NAME_MAX];
>         struct led_trigger *trig;
>         size_t len;
> +       int ret = count;
> +
> +#ifdef CONFIG_V4L2_FLASH_LED_CLASS
> +       mutex_lock(&led_cdev->led_lock);
> +#endif
>
>         trigger_name[sizeof(trigger_name) - 1] = '\0';
>         strncpy(trigger_name, buf, sizeof(trigger_name) - 1);
> @@ -47,7 +52,7 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
>
>         if (!strcmp(trigger_name, "none")) {
>                 led_trigger_remove(led_cdev);
> -               return count;
> +               goto exit_unlock;
>         }
>
>         down_read(&triggers_list_lock);
> @@ -58,12 +63,16 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
>                         up_write(&led_cdev->trigger_lock);
>
>                         up_read(&triggers_list_lock);
> -                       return count;
> +                       goto exit_unlock;
>                 }
>         }
>         up_read(&triggers_list_lock);
>
> -       return -EINVAL;
> +exit_unlock:
> +#ifdef CONFIG_V4L2_FLASH_LED_CLASS
> +       mutex_unlock(&led_cdev->led_lock);
> +#endif
> +       return ret;
>  }
>  EXPORT_SYMBOL_GPL(led_trigger_store);
>
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index cc85b16..ef343f1 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -13,6 +13,7 @@
>  #define __LINUX_LEDS_H_INCLUDED
>
>  #include <linux/list.h>
> +#include <linux/mutex.h>
>  #include <linux/rwsem.h>
>  #include <linux/spinlock.h>
>  #include <linux/workqueue.h>
> @@ -41,6 +42,7 @@ struct led_classdev {
>  #define LED_BLINK_ONESHOT      (1 << 17)
>  #define LED_BLINK_ONESHOT_STOP (1 << 18)
>  #define LED_BLINK_INVERT       (1 << 19)
> +#define LED_SYSFS_LOCK         (1 << 20)
>
>         /* Set LED brightness level */
>         /* Must not sleep, use a workqueue if needed */
> @@ -84,6 +86,9 @@ struct led_classdev {
>         /* true if activated - deactivate routine uses it to do cleanup */
>         bool                    activated;
>  #endif
> +
> +       /* Ensures consistent access to the LED Flash Class device */
> +       struct mutex            led_lock;
>  };
>
>  extern int led_classdev_register(struct device *parent,
> @@ -150,6 +155,33 @@ extern void led_set_brightness(struct led_classdev *led_cdev,
>   */
>  extern int led_update_brightness(struct led_classdev *led_cdev);
>
> +/**
> + * led_sysfs_lock - lock LED sysfs interface
> + * @led_cdev: the LED to set
> + *
> + * Lock the LED's sysfs interface
> + */
> +extern void led_sysfs_lock(struct led_classdev *led_cdev);
> +
> +/**
> + * led_sysfs_unlock - unlock LED sysfs interface
> + * @led_cdev: the LED to set
> + *
> + * Unlock the LED's sysfs interface
> + */
> +extern void led_sysfs_unlock(struct led_classdev *led_cdev);
> +
> +/**
> + * led_sysfs_is_locked
> + * @led_cdev: the LED to query
> + *
> + * Returns: true if the sysfs interface of the led is locked
> + */
> +static inline bool led_sysfs_is_locked(struct led_classdev *led_cdev)
> +{
> +       return led_cdev->flags & LED_SYSFS_LOCK;
> +}
> +
>  /*
>   * LED Triggers
>   */
> --
> 1.7.9.5
>

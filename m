Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbaCaKQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 06:16:54 -0400
Received: from dan.rpsys.net ([93.97.175.187]:64848 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbaCaKQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 06:16:52 -0400
Message-ID: <1396260981.14790.65.camel@ted>
Subject: Re: [PATCH/RFC v2 1/8] leds: Add sysfs and kernel internal API for
 flash LEDs
From: Richard Purdie <richard.purdie@linuxfoundation.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Bryan Wu <cooloney@gmail.com>
Date: Mon, 31 Mar 2014 11:16:21 +0100
In-Reply-To: <1396020545-15727-2-git-send-email-j.anaszewski@samsung.com>
References: <1396020545-15727-1-git-send-email-j.anaszewski@samsung.com>
	 <1396020545-15727-2-git-send-email-j.anaszewski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-28 at 16:28 +0100, Jacek Anaszewski wrote:
> Some LED devices support two operation modes - torch and
> flash. This patch provides support for flash LED devices
> in the LED subsystem by introducing new sysfs attributes
> and kernel internal interface. The attributes being
> introduced are: flash_brightness, flash_strobe, flash_timeout,
> max_flash_timeout, max_flash_brightness, flash_fault and
> hw_triggered. All the flash related features are placed
> in a separate module.
> The modifications aim to be compatible with V4L2 framework
> requirements related to the flash devices management. The
> design assumes that V4L2 sub-device can take of the LED class
> device control and communicate with it through the kernel
> internal interface. The LED sysfs interface is made
> unavailable then.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Bryan Wu <cooloney@gmail.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
>  drivers/leds/Kconfig        |    8 +
>  drivers/leds/Makefile       |    1 +
>  drivers/leds/led-class.c    |   56 +++++--
>  drivers/leds/led-flash.c    |  375 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/leds/led-triggers.c |   16 +-
>  drivers/leds/leds.h         |    3 +
>  include/linux/leds.h        |   24 ++-
>  include/linux/leds_flash.h  |  189 ++++++++++++++++++++++
>  8 files changed, 658 insertions(+), 14 deletions(-)
>  create mode 100644 drivers/leds/led-flash.c
>  create mode 100644 include/linux/leds_flash.h
> 
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 2062682..1e1c81f 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -19,6 +19,14 @@ config LEDS_CLASS
>  	  This option enables the led sysfs class in /sys/class/leds.  You'll
>  	  need this to do anything useful with LEDs.  If unsure, say N.
>  
> +config LEDS_CLASS_FLASH
> +	tristate "Flash LEDs Support"
> +	depends on LEDS_CLASS
> +	help
> +	  This option enables support for flash LED devices. Say Y if you
> +	  want to use flash specific features of a LED device, if they
> +	  are supported.
> +
>  comment "LED drivers"
>  
>  config LEDS_88PM860X
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index 3cd76db..8861b86 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -2,6 +2,7 @@
>  # LED Core
>  obj-$(CONFIG_NEW_LEDS)			+= led-core.o
>  obj-$(CONFIG_LEDS_CLASS)		+= led-class.o
> +obj-$(CONFIG_LEDS_CLASS_FLASH)		+= led-flash.o
>  obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
>  
>  # LED Platform Drivers
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index f37d63c..5bac140 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -9,16 +9,18 @@
>   * published by the Free Software Foundation.
>   */
>  
> -#include <linux/module.h>
> -#include <linux/kernel.h>
> +#include <linux/ctype.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
>  #include <linux/init.h>
> +#include <linux/kernel.h>
>  #include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
>  #include <linux/spinlock.h>
> -#include <linux/device.h>
>  #include <linux/timer.h>
> -#include <linux/err.h>
> -#include <linux/ctype.h>
>  #include <linux/leds.h>
> +#include <linux/leds_flash.h>
>  #include "leds.h"
>  
>  static struct class *leds_class;
> @@ -45,28 +47,38 @@ static ssize_t brightness_store(struct device *dev,
>  {
>  	struct led_classdev *led_cdev = dev_get_drvdata(dev);
>  	unsigned long state;
> -	ssize_t ret = -EINVAL;
> +	ssize_t ret;
> +
> +	mutex_lock(&led_cdev->led_lock);
> +
> +	if (led_sysfs_is_locked(led_cdev)) {
> +		ret = -EBUSY;
> +		goto unlock;
> +	}
>  
>  	ret = kstrtoul(buf, 10, &state);
>  	if (ret)
> -		return ret;
> +		goto unlock;
>  
>  	if (state == LED_OFF)
>  		led_trigger_remove(led_cdev);
>  	__led_set_brightness(led_cdev, state);
> +	ret = size;
>  
> -	return size;
> +unlock:
> +	mutex_unlock(&led_cdev->led_lock);
> +	return ret;
>  }
>  static DEVICE_ATTR_RW(brightness);
>  
> -static ssize_t led_max_brightness_show(struct device *dev,
> +static ssize_t max_brightness_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
>  	struct led_classdev *led_cdev = dev_get_drvdata(dev);
>  
>  	return sprintf(buf, "%u\n", led_cdev->max_brightness);
>  }
> -static DEVICE_ATTR(max_brightness, 0444, led_max_brightness_show, NULL);
> +static DEVICE_ATTR_RO(max_brightness);
>  
>  #ifdef CONFIG_LEDS_TRIGGERS
>  static DEVICE_ATTR(trigger, 0644, led_trigger_show, led_trigger_store);
> @@ -173,7 +185,15 @@ EXPORT_SYMBOL_GPL(led_classdev_suspend);
>   */
>  void led_classdev_resume(struct led_classdev *led_cdev)
>  {
> +	struct led_flash *flash = led_cdev->flash;
> +
>  	led_cdev->brightness_set(led_cdev, led_cdev->brightness);
> +	if (flash) {
> +		call_flash_op(brightness_set, led_cdev,
> +				flash->brightness);
> +		call_flash_op(timeout_set, led_cdev,
> +				&flash->timeout);
> +	}
>  	led_cdev->flags &= ~LED_SUSPENDED;
>  }
>  EXPORT_SYMBOL_GPL(led_classdev_resume);
> @@ -210,14 +230,24 @@ static const struct dev_pm_ops leds_class_dev_pm_ops = {
>   */
>  int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
>  {
> +	int ret;
> +
>  	led_cdev->dev = device_create(leds_class, parent, 0, led_cdev,
>  				      "%s", led_cdev->name);
>  	if (IS_ERR(led_cdev->dev))
>  		return PTR_ERR(led_cdev->dev);
>  
> +	ret = led_classdev_init_flash(led_cdev);
> +	if (ret < 0) {
> +		dev_dbg(parent,
> +			"Flash LED initialization failed for the %s\n device", led_cdev->name);
> +		goto error_flash_init;
> +	}
> +

Thanks for moving things to the separate file, I think it is cleaner.
The trouble is that because of the above call to
led_classdev_init_flash(), you can't have the led core loaded without
the flash module too. There are a few other calls which also give the
same end result.

I guess what I'm wondering is whether this can work the other way
around, the flash class wraps around the led core and extends it for
those devices with flash capable LEDs? There may be some internals need
accessing from led-core but it would mean you can have one module loaded
without the other. This would mean a new registration function for flash
capable LED devices but in reality that shouldn't be much of an issue?

I appreciate this may seem like a small issue since RAM is cheap and who
cares about the kernel size, but these small pieces all mount up. I wish
more people thought about how to make the kernel modules work more
effectively...

Cheers,

Richard




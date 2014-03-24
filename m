Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249AbaCXAJL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 20:09:11 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37590 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750993AbaCXAJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 20:09:08 -0400
Date: Mon, 24 Mar 2014 02:08:34 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH/RFC 4/8] media: Add registration helpers for V4L2 flash
 sub-devices
Message-ID: <20140324000834.GC2054@valkosipuli.retiisi.org.uk>
References: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
 <1395327070-20215-5-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395327070-20215-5-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

On Thu, Mar 20, 2014 at 03:51:06PM +0100, Jacek Anaszewski wrote:
> This patch adds helper functions for registering/unregistering
> LED class flash devices as V4L2 subdevs. The functions should
> be called from the LED subsystem device driver. In case the
> Multimedia Framework support is disabled in the kernel config
> the functions' empty versions will be used.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/v4l2-core/Makefile     |    2 +-
>  drivers/media/v4l2-core/v4l2-flash.c |  320 ++++++++++++++++++++++++++++++++++
>  include/media/v4l2-flash.h           |  102 +++++++++++
>  3 files changed, 423 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
>  create mode 100644 include/media/v4l2-flash.h
> 
> diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
> index c6ae7ba..63e8f03 100644
> --- a/drivers/media/v4l2-core/Makefile
> +++ b/drivers/media/v4l2-core/Makefile
> @@ -6,7 +6,7 @@ tuner-objs	:=	tuner-core.o
>  
>  videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
>  			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o \
> -			v4l2-async.o
> +			v4l2-async.o v4l2-flash.o
>  ifeq ($(CONFIG_COMPAT),y)
>    videodev-objs += v4l2-compat-ioctl32.o
>  endif
> diff --git a/drivers/media/v4l2-core/v4l2-flash.c b/drivers/media/v4l2-core/v4l2-flash.c
> new file mode 100644
> index 0000000..6be0ba9
> --- /dev/null
> +++ b/drivers/media/v4l2-core/v4l2-flash.c
> @@ -0,0 +1,320 @@
> +/*
> + * V4L2 flash LED subdevice registration helpers.
> + *
> + *	Copyright (C) 2014 Samsung Electronics Co., Ltd
> + *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation."
> + */
> +
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-flash.h>
> +#include <media/v4l2-dev.h>

Alphabetical order, please.

> +
> +static int v4l2_flash_g_volatile_ctrl(struct v4l2_ctrl *c)
> +
> +{
> +	struct v4l2_flash *flash = ctrl_to_flash(c);
> +	struct led_classdev *led_cdev = flash->led_cdev;
> +	unsigned int fault;
> +	int ret;
> +
> +	switch (c->id) {
> +	case V4L2_CID_FLASH_STROBE_STATUS:
> +		ret = led_update_brightness(led_cdev);
> +		if (ret < 0)
> +			return ret;
> +		c->val = !!ret;
> +		return 0;
> +	case V4L2_CID_FLASH_FAULT:
> +		/* led faults map directly to V4L2 flash faults */
> +		ret = led_get_flash_fault(led_cdev, &fault);
> +		if (!ret)
> +			c->val = fault;
> +		return ret;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static int v4l2_flash_set_intensity(struct v4l2_flash *flash,
> +				    unsigned int intensity)
> +{
> +	struct led_classdev *led_cdev = flash->led_cdev;
> +	unsigned int fault;
> +	int ret;
> +
> +	ret = led_get_flash_fault(led_cdev, &fault);
> +	if (ret < 0 || fault)
> +		return -EINVAL;

Is it meaningful to check the faults here?

The existing flash controller drivers mostly do not. The responsibility is
left to the user --- something the user should probably do after the strobe
has expectedly finished. This isn't particularly very well documented in the
spec, though.

Also, the presence of every fault does not prevent using the flash.

> +	led_set_brightness(led_cdev, intensity);

Where do you convert between the LED framework brightness and the value used
by the V4L2 controls?

> +
> +	return ret;
> +}
> +
> +static int v4l2_flash_s_ctrl(struct v4l2_ctrl *c)
> +{
> +	struct v4l2_flash *flash = ctrl_to_flash(c);
> +	struct led_classdev *led_cdev = flash->led_cdev;
> +	int ret = 0;
> +
> +	switch (c->id) {
> +	case V4L2_CID_FLASH_LED_MODE:
> +		switch (c->val) {
> +		case V4L2_FLASH_LED_MODE_NONE:
> +			/* clear flash mode on releae */

It's not uncommon for the user to leave the mode to something else than none
when the user goes away. Could there be other ways to mediate access?

> +			ret = led_set_flash_mode(led_cdev, false);
> +			if (ret < 0)
> +				return ret;
> +			mutex_lock(&led_cdev->led_lock);
> +			led_sysfs_unlock(led_cdev);
> +			mutex_unlock(&led_cdev->led_lock);
> +			break;
> +		case V4L2_FLASH_LED_MODE_FLASH:
> +			mutex_lock(&led_cdev->led_lock);
> +			led_sysfs_lock(led_cdev);
> +			mutex_unlock(&led_cdev->led_lock);
> +
> +			ret = led_set_flash_mode(led_cdev, true);
> +			if (ret < 0)
> +				return ret;
> +			if (flash->ctrl.source->val ==
> +					V4L2_FLASH_STROBE_SOURCE_EXTERNAL) {
> +				ret = led_set_hw_triggered(led_cdev, true);
> +				if (ret < 0)
> +					return ret;
> +				ret = v4l2_flash_set_intensity(flash,
> +						       flash->flash_intensity);
> +			} else {
> +				ret = led_set_hw_triggered(led_cdev, false);
> +				if (ret < 0)
> +					return ret;

As the switch() is the last thing you'll do anyway, you could as well just
return here. Same below. Up to you.

> +			}
> +			break;
> +		case V4L2_FLASH_LED_MODE_TORCH:
> +			mutex_lock(&led_cdev->led_lock);
> +			led_sysfs_lock(led_cdev);
> +			mutex_unlock(&led_cdev->led_lock);
> +
> +			ret = led_set_flash_mode(led_cdev, false);
> +			if (ret < 0)
> +				return ret;
> +			/* torch is always triggered by software */
> +			ret = led_set_hw_triggered(led_cdev, false);
> +			if (ret)
> +				return -EINVAL;
> +			ret = v4l2_flash_set_intensity(flash,
> +						       flash->torch_intensity);
> +			break;
> +		}
> +		break;
> +	case V4L2_CID_FLASH_STROBE_SOURCE:
> +		ret = led_set_hw_triggered(led_cdev,
> +				c->val == V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
> +		break;
> +	case V4L2_CID_FLASH_STROBE:
> +		if (flash->ctrl.led_mode->val != V4L2_FLASH_LED_MODE_FLASH ||
> +		   flash->ctrl.source->val != V4L2_FLASH_STROBE_SOURCE_SOFTWARE)
> +			return -EINVAL;
> +		led_set_flash_timeout(led_cdev, flash->flash_timeout);
> +		ret = v4l2_flash_set_intensity(flash,
> +						flash->flash_intensity);

Same comment as on the other patch: strobe should be just strobe, nothing
else.

> +		break;
> +	case V4L2_CID_FLASH_STROBE_STOP:
> +		led_set_brightness(led_cdev, 0);
> +		break;
> +	case V4L2_CID_FLASH_TIMEOUT:
> +		flash->flash_timeout = c->val;
> +		break;
> +	case V4L2_CID_FLASH_INTENSITY:
> +		flash->flash_intensity = c->val;
> +		break;
> +	case V4L2_CID_FLASH_TORCH_INTENSITY:
> +		flash->torch_intensity = c->val;
> +		if (flash->ctrl.led_mode->val == V4L2_FLASH_LED_MODE_TORCH)
> +			ret = v4l2_flash_set_intensity(flash,
> +						       flash->torch_intensity);
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_ctrl_ops v4l2_flash_ctrl_ops = {
> +	.g_volatile_ctrl = v4l2_flash_g_volatile_ctrl,
> +	.s_ctrl = v4l2_flash_s_ctrl,
> +};
> +
> +static int v4l2_flash_init_controls(struct v4l2_flash *flash,
> +				struct v4l2_flash_ctrl_config *config)
> +
> +{
> +	unsigned int mask;
> +	struct v4l2_ctrl *ctrl;
> +	struct v4l2_ctrl_config *ctrl_cfg;
> +	bool has_flash = config->flags & V4L2_FLASH_CFG_LED_FLASH;
> +	bool has_torch = config->flags & V4L2_FLASH_CFG_LED_TORCH;
> +	int ret, num_ctrls;
> +
> +	if (!has_flash && !has_torch)
> +		return -EINVAL;
> +
> +	num_ctrls = has_flash ? 8 : 2;
> +	if (config->flags & V4L2_FLASH_CFG_FAULTS_MASK)
> +		++num_ctrls;
> +
> +	v4l2_ctrl_handler_init(&flash->hdl, num_ctrls);
> +
> +	mask = 1 << V4L2_FLASH_LED_MODE_NONE;
> +	if (has_flash)
> +		mask |= 1 << V4L2_FLASH_LED_MODE_FLASH;
> +	if (has_torch)
> +		mask |= 1 << V4L2_FLASH_LED_MODE_TORCH;

I don't expect to see this on LED flash devices. :-)

> +	/* Configure TORCH_INTENSITY ctrl */
> +	ctrl_cfg = &config->torch_intensity;
> +	ctrl = v4l2_ctrl_new_std(&flash->hdl, &v4l2_flash_ctrl_ops,
> +				 V4L2_CID_FLASH_TORCH_INTENSITY,
> +				 ctrl_cfg->min, ctrl_cfg->max,
> +				 ctrl_cfg->step, ctrl_cfg->def);
> +
> +	if (has_flash) {
> +		/* Configure FLASH_LED_MODE ctrl */
> +		flash->ctrl.led_mode = v4l2_ctrl_new_std_menu(&flash->hdl,
> +				&v4l2_flash_ctrl_ops, V4L2_CID_FLASH_LED_MODE,
> +				V4L2_FLASH_LED_MODE_TORCH, ~mask,
> +				V4L2_FLASH_LED_MODE_NONE);
> +
> +		/* Configure FLASH_STROBE_SOURCE ctrl */
> +		mask = 1 << V4L2_FLASH_STROBE_SOURCE_SOFTWARE |
> +		       1 << V4L2_FLASH_STROBE_SOURCE_EXTERNAL;

Not every implementation supports hardware strobe. It could be that the
flash chip does but the pin isn't connected. That's the case on e.g. the
Nokia N900. The hardware strobe source is typically the sensor but not all
sensors support it. So you just have to cope with what you have. :-)

> +		flash->ctrl.source = v4l2_ctrl_new_std_menu(&flash->hdl,
> +					&v4l2_flash_ctrl_ops,
> +					V4L2_CID_FLASH_STROBE_SOURCE,
> +					V4L2_FLASH_STROBE_SOURCE_EXTERNAL,
> +					~mask,
> +					V4L2_FLASH_STROBE_SOURCE_SOFTWARE);
> +
> +		/* Configure FLASH_STROBE ctrl */
> +		ctrl = v4l2_ctrl_new_std(&flash->hdl, &v4l2_flash_ctrl_ops,
> +					  V4L2_CID_FLASH_STROBE, 0, 1, 1, 0);
> +		if (ctrl)
> +			ctrl->type = V4L2_CTRL_TYPE_BUTTON;

I think this is already handled by the control framework.

> +		/* Configure FLASH_STROBE_STOP ctrl */
> +		ctrl = v4l2_ctrl_new_std(&flash->hdl, &v4l2_flash_ctrl_ops,
> +					  V4L2_CID_FLASH_STROBE_STOP,
> +					  0, 1, 1, 0);
> +		if (ctrl)
> +			ctrl->type = V4L2_CTRL_TYPE_BUTTON;

Same here.

> +		/* Configure FLASH_STROBE_STATUS ctrl */
> +		ctrl = v4l2_ctrl_new_std(&flash->hdl, &v4l2_flash_ctrl_ops,
> +					 V4L2_CID_FLASH_STROBE_STATUS,
> +					 0, 1, 1, 1);
> +		if (ctrl)
> +			ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE |
> +				       V4L2_CTRL_FLAG_READ_ONLY;
> +
> +		/* Configure FLASH_TIMEOUT ctrl */
> +		ctrl_cfg = &config->flash_timeout;
> +		ctrl = v4l2_ctrl_new_std(&flash->hdl, &v4l2_flash_ctrl_ops,
> +					 V4L2_CID_FLASH_TIMEOUT, ctrl_cfg->min,
> +					 ctrl_cfg->max, ctrl_cfg->step,
> +					 ctrl_cfg->def);
> +
> +		/* Configure FLASH_INTENSITY ctrl */
> +		ctrl_cfg = &config->flash_intensity;
> +		ctrl = v4l2_ctrl_new_std(&flash->hdl, &v4l2_flash_ctrl_ops,
> +					 V4L2_CID_FLASH_INTENSITY,
> +					 ctrl_cfg->min, ctrl_cfg->max,
> +					 ctrl_cfg->step, ctrl_cfg->def);
> +
> +		if (config->flags & V4L2_FLASH_CFG_FAULTS_MASK) {
> +			/* Configure FLASH_FAULT ctrl */
> +			ctrl = v4l2_ctrl_new_std(&flash->hdl,
> +						 &v4l2_flash_ctrl_ops,
> +						 V4L2_CID_FLASH_FAULT, 0,
> +						 config->flags &
> +						 V4L2_FLASH_CFG_FAULTS_MASK,
> +						 0, 0);
> +			if (ctrl) {
> +				ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE |
> +					       V4L2_CTRL_FLAG_READ_ONLY;
> +				ctrl->type = V4L2_CTRL_TYPE_BITMASK;

And here.

> +			}
> +		}
> +	}
> +
> +	if (flash->hdl.error) {
> +		ret = flash->hdl.error;
> +		goto error_free;
> +	}
> +
> +	ret = v4l2_ctrl_handler_setup(&flash->hdl);
> +	if (ret < 0)
> +		goto error_free;
> +
> +	flash->subdev.ctrl_handler = &flash->hdl;
> +
> +	return 0;
> +
> +error_free:
> +	v4l2_ctrl_handler_free(&flash->hdl);
> +	return ret;
> +}
> +
> +/* v4l2_subdev_init requires this structure */

...because v4l2_subdev_call() requires it to be set. I might leave the
comment out. Up to you.

> +static struct v4l2_subdev_ops v4l2_flash_subdev_ops = {
> +};
> +
> +int v4l2_flash_init(struct led_classdev *led_cdev, struct v4l2_flash *flash,
> +				struct v4l2_flash_ctrl_config *config)
> +{
> +	struct v4l2_subdev *sd = &flash->subdev;
> +	int ret;
> +
> +	flash->led_cdev = led_cdev;
> +	sd->dev = led_cdev->dev->parent;
> +	v4l2_subdev_init(sd, &v4l2_flash_subdev_ops);
> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	snprintf(sd->name, sizeof(sd->name), led_cdev->name);
> +
> +	ret = v4l2_flash_init_controls(flash, config);
> +	if (ret < 0)
> +		goto err_init_controls;
> +
> +	ret = media_entity_init(&sd->entity, 0, NULL, 0);
> +	if (ret < 0)
> +		goto err_init_entity;
> +
> +	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
> +
> +	ret = v4l2_async_register_subdev(sd);
> +	if (ret < 0)
> +		goto err_init_entity;
> +
> +	return 0;
> +
> +err_init_entity:
> +	media_entity_cleanup(&sd->entity);
> +err_init_controls:
> +	v4l2_ctrl_handler_free(sd->ctrl_handler);
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_flash_init);
> +
> +void v4l2_flash_release(struct v4l2_flash *flash)
> +{
> +	media_entity_cleanup(&flash->subdev.entity);

media_entity_cleanup() has to be called after
v4l2_async_unregister_subdev(). v4l2_device_unregister_subdev() assumes the
entity to be there.

> +	v4l2_ctrl_handler_free(flash->subdev.ctrl_handler);
> +	v4l2_async_unregister_subdev(&flash->subdev);
> +}
> +EXPORT_SYMBOL_GPL(v4l2_flash_release);
> diff --git a/include/media/v4l2-flash.h b/include/media/v4l2-flash.h
> new file mode 100644
> index 0000000..138edae
> --- /dev/null
> +++ b/include/media/v4l2-flash.h
> @@ -0,0 +1,102 @@
> +/*
> + * V4L2 flash LED subdevice registration helpers.
> + *
> + *	Copyright (C) 2014 Samsung Electronics Co., Ltd
> + *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation."
> + */
> +
> +#ifndef _V4L2_FLASH_H
> +#define _V4L2_FLASH_H
> +
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-dev.h>
> +#include <linux/leds.h>

Order, please.

> +
> +/*
> + * Supported led fault and mode bits -
> + * must be kept in synch with V4L2_FLASH_FAULT bits
> + */
> +#define V4L2_FLASH_CFG_FAULT_OVER_VOLTAGE	(1 << 0)
> +#define V4L2_FLASH_CFG_FAULT_TIMEOUT		(1 << 1)
> +#define V4L2_FLASH_CFG_FAULT_OVER_TEMPERATURE	(1 << 2)
> +#define V4L2_FLASH_CFG_FAULT_SHORT_CIRCUIT	(1 << 3)
> +#define V4L2_FLASH_CFG_FAULT_OVER_CURRENT	(1 << 4)
> +#define V4L2_FLASH_CFG_FAULT_INDICATOR		(1 << 5)
> +#define V4L2_FLASH_CFG_FAULTS_MASK		0x3f
> +#define V4L2_FLASH_CFG_LED_FLASH		(1 << 6)
> +#define V4L2_FLASH_CFG_LED_TORCH		(1 << 7)
> +
> +/* Flash control config data initializer */
> +
> +struct v4l2_flash {
> +	struct led_classdev *led_cdev;
> +	struct v4l2_subdev subdev;
> +	struct v4l2_ctrl_handler hdl;
> +
> +	struct {
> +		struct v4l2_ctrl *source;
> +		struct v4l2_ctrl *led_mode;
> +	} ctrl;
> +
> +	unsigned int flash_intensity;
> +	unsigned int torch_intensity;
> +	unsigned int flash_timeout;
> +};
> +
> +struct v4l2_flash_ctrl_config {
> +	struct v4l2_ctrl_config flash_timeout;
> +	struct v4l2_ctrl_config flash_intensity;
> +	struct v4l2_ctrl_config torch_intensity;
> +	unsigned int flags;
> +};
> +
> +static inline struct v4l2_flash *subdev_to_flash(struct v4l2_subdev *sd)

I'd prefer to have at least the v4l2_ prefix in public V4L2 sub-device
framework functions.

> +{
> +	return container_of(sd, struct v4l2_flash, subdev);
> +}
> +
> +static inline struct v4l2_flash *ctrl_to_flash(struct v4l2_ctrl *c)

How about e.g. v4l2_ctrl_to_v4l2_flash?

> +{
> +	return container_of(c->handler, struct v4l2_flash, hdl);
> +}
> +
> +#ifdef CONFIG_VIDEO_V4L2
> +/**
> + * v4l2_flash_init - initialize V4L2 flash led sub-device
> + * @led_cdev: the LED to create subdev upon
> + * @flash: a structure representing V4L2 flash led device
> + * @config: initial data for the flash led subdev controls
> + *
> + * Create V4L2 subdev wrapping given LED subsystem device.
> + */
> +int v4l2_flash_init(struct led_classdev *led_cdev, struct v4l2_flash *flash,
> +				struct v4l2_flash_ctrl_config *config);
> +
> +/**
> + * v4l2_flash_release - release V4L2 flash led sub-device
> + * @flash: a structure representing V4L2 flash led device
> + *
> + * Release V4L2 flash led subdev.
> + */
> +void v4l2_flash_release(struct v4l2_flash *flash);
> +#else
> +static inline int v4l2_flash_init(struct led_classdev *led_cdev,
> +				  struct v4l2_flash *flash,
> +				  struct v4l2_flash_ctrl_config *config)
> +{
> +	return 0;
> +}
> +
> +static inline void v4l2_flash_release(struct v4l2_flash *flash)
> +{
> +}
> +#endif
> +
> +#endif

#endif /* WHATWASIT */ would be nice.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

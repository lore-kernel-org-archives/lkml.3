Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbaDQI1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:27:50 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:18219 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529AbaDQI0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:26:48 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-0b-534f9045e9d8
Message-id: <534F9044.6080508@samsung.com>
Date: Thu, 17 Apr 2014 10:26:44 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH/RFC v3 5/5] media: Add registration helpers for V4L2 flash
 sub-devices
References: <1397228216-6657-1-git-send-email-j.anaszewski@samsung.com>
 <1397228216-6657-6-git-send-email-j.anaszewski@samsung.com>
 <20140416182141.GG8753@valkosipuli.retiisi.org.uk>
In-reply-to: <20140416182141.GG8753@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xa7quE/yDDT4tVrW4te4cq8X8I0Di
	bNMbdovLu+awWWx9s47RomfDVlaLw2/aWS3O7F/J5sDhcfjrQhaPvi2rGD0+b5ILYI7isklJ
	zcksSy3St0vgyriwdQ5rwcnpjBXHLx9la2B8VtnFyMkhIWAi0bXyLxuELSZx4d56IJuLQ0hg
	KaPE1p3TWCCcj4wSFx/fZQGp4hXQktiw8R5YB4uAqsTU9kawOJuAocTPF6+ZQGxRgQiJP6f3
	sULUC0r8mHwPrEZEQE3i6aaHYEOZBQ4ySnzYfgFskLBAjMSyQz8YIbbtYpRY9KqfGSTBKWAv
	cbLxA1gRs4C1xMpJ2xghbHmJzWveMk9gFJiFZMksJGWzkJQtYGRexSiaWppcUJyUnmukV5yY
	W1yal66XnJ+7iRES4l93MC49ZnWIUYCDUYmHN+GvX7AQa2JZcWXuIUYJDmYlEd4lvf7BQrwp
	iZVVqUX58UWlOanFhxiZODilGhivZe2QY74V/4g/j/nYLX+/CsYtVyXmZzxy+3Q74fQj7Ruc
	6tN/LoqOWqnV8XNZcVbx/oBOxccydfmdP6Zf2Dxrn+KElHYby1WN82Ot7l24oWfKdjXVrdj9
	S6y+1ZL7s+btmxT0Lv+F7dz/Mdbrjnsu6djwtlSezySEWyAx3JbrZXfVoSezvh9TYinOSDTU
	Yi4qTgQAyPLRMk8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

Thanks for the review.

On 04/16/2014 08:21 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> Thanks for the update!
>
[...]
>> +static inline enum led_brightness v4l2_flash_intensity_to_led_brightness(
>> +					struct led_ctrl *config,
>> +					u32 intensity)
>
> Fits on a single line.
>
>> +{
>> +	return intensity / config->step;
>
> Shouldn't you first decrement the minimum before the division?

Brightness level 0 means that led is off. Let's consider following case:

intensity - 15625
config->step - 15625
intensity / config->step = 1 (the lowest possible current level)

>> +}
>> +
>> +static inline u32 v4l2_flash_led_brightness_to_intensity(
>> +					struct led_ctrl *config,
>> +					enum led_brightness brightness)
>> +{
>> +	return brightness * config->step;
>
> And do the opposite here?
>
>> +}
>> +
>> +static int v4l2_flash_g_volatile_ctrl(struct v4l2_ctrl *c)
>> +
>> +{
>> +	struct v4l2_flash *v4l2_flash = v4l2_ctrl_to_v4l2_flash(c);
>> +	struct led_classdev *led_cdev = v4l2_flash->led_cdev;
>> +	struct led_flash *flash = led_cdev->flash;
>> +	struct v4l2_flash_ctrl *ctrl = &v4l2_flash->ctrl;
>> +	u32 fault;
>> +	int ret;
>> +
>> +	switch (c->id) {
>> +	case V4L2_CID_FLASH_TORCH_INTENSITY:
>> +		if (ctrl->led_mode->val == V4L2_FLASH_LED_MODE_TORCH) {
>> +			ret = v4l2_call_flash_op(brightness_update, led_cdev);
>> +			if (ret < 0)
>> +				return ret;
>> +			ctrl->torch_intensity->val =
>> +				v4l2_flash_led_brightness_to_intensity(
>> +						&led_cdev->brightness_ctrl,
>> +						led_cdev->brightness);
>> +		}
>> +		return 0;
>> +	case V4L2_CID_FLASH_INTENSITY:
>> +		ret = v4l2_call_flash_op(flash_brightness_update, led_cdev);
>> +		if (ret < 0)
>> +			return ret;
>> +		/* no conversion is needed */
>> +		c->val = flash->brightness.val;
>> +		return 0;
>> +	case V4L2_CID_FLASH_INDICATOR_INTENSITY:
>> +		ret = v4l2_call_flash_op(indicator_brightness_update, led_cdev);
>> +		if (ret < 0)
>> +			return ret;
>> +		/* no conversion is needed */
>> +		c->val = flash->indicator_brightness->val;
>> +		return 0;
>> +	case V4L2_CID_FLASH_STROBE_STATUS:
>> +		ret = v4l2_call_flash_op(strobe_get, led_cdev);
>> +		if (ret < 0)
>> +			return ret;
>> +		c->val = !!ret;
>> +		return 0;
>> +	case V4L2_CID_FLASH_FAULT:
>> +		/* led faults map directly to V4L2 flash faults */
>> +		ret = v4l2_call_flash_op(fault_get, led_cdev, &fault);
>> +		if (!ret)
>
> The return value seems to come all the way from regmap_read() and the bus
> related implementatio. I would just consider negative values errors, as
> above.

I think that ret would be returned if it wasn't equal to 0. But indeed
it should be done the same way as for the other cases.

>> +			c->val = fault;
>> +		return ret;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +}
>> +
>> +static int v4l2_flash_s_ctrl(struct v4l2_ctrl *c)
>> +{
>> +	struct v4l2_flash *v4l2_flash = v4l2_ctrl_to_v4l2_flash(c);
>> +	struct led_classdev *led_cdev = v4l2_flash->led_cdev;
>> +	struct v4l2_flash_ctrl *ctrl = &v4l2_flash->ctrl;
>> +	enum led_brightness torch_brightness;
>> +	bool external_strobe;
>> +	int ret;
>> +
>> +	switch (c->id) {
>> +	case V4L2_CID_FLASH_LED_MODE:
>> +		switch (c->val) {
>> +		case V4L2_FLASH_LED_MODE_NONE:
>> +			v4l2_call_flash_op(brightness_set, led_cdev, 0);
>> +			return v4l2_call_flash_op(strobe_set, led_cdev, false);
>> +		case V4L2_FLASH_LED_MODE_FLASH:
>> +			/* Turn off torch LED */
>> +			v4l2_call_flash_op(brightness_set, led_cdev, 0);
>> +			external_strobe = (ctrl->source->val ==
>> +					V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
>> +			return v4l2_call_flash_op(external_strobe_set, led_cdev,
>> +							external_strobe);
>> +		case V4L2_FLASH_LED_MODE_TORCH:
>> +			/* Stop flash strobing */
>> +			ret = v4l2_call_flash_op(strobe_set, led_cdev, false);
>> +			if (ret)
>> +				return ret;
>> +			/* torch is always triggered by software */
>> +			ret = v4l2_call_flash_op(external_strobe_set, led_cdev,
>> +								false);
>
> Does the LED API not assume this at the moment? I'm not saying it should,
> though. :-)

Actually strobe source should apply only to flash leds. I will
remove this call.

>> +			if (ret)
>> +				return ret;
>> +
>> +			torch_brightness =
>> +				v4l2_flash_intensity_to_led_brightness(
>> +						&led_cdev->brightness_ctrl,
>> +						ctrl->torch_intensity->val);
>> +			v4l2_call_flash_op(brightness_set, led_cdev,
>> +						torch_brightness);
>> +			return ret;
>> +		}
>> +		break;
>> +	case V4L2_CID_FLASH_STROBE_SOURCE:
>> +		return v4l2_call_flash_op(external_strobe_set, led_cdev,
>> +				c->val == V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
>> +	case V4L2_CID_FLASH_STROBE:
>> +		if (ctrl->led_mode->val != V4L2_FLASH_LED_MODE_FLASH ||
>> +		    ctrl->source->val != V4L2_FLASH_STROBE_SOURCE_SOFTWARE)
>
> I vote for -EBUSY instead.

I agree.

>> +			return -EINVAL;
>> +		return v4l2_call_flash_op(strobe_set, led_cdev, true);
>> +	case V4L2_CID_FLASH_STROBE_STOP:
>> +		return v4l2_call_flash_op(strobe_set, led_cdev, false);
>> +	case V4L2_CID_FLASH_TIMEOUT:
>> +		ret =  v4l2_call_flash_op(timeout_set, led_cdev, c->val);
>> +	case V4L2_CID_FLASH_INTENSITY:
>> +		/* no conversion is needed */
>> +		return v4l2_call_flash_op(flash_brightness_set, led_cdev,
>> +								c->val);
>> +	case V4L2_CID_FLASH_INDICATOR_INTENSITY:
>> +		/* no conversion is needed */
>> +		return v4l2_call_flash_op(indicator_brightness_set, led_cdev,
>> +								c->val);
>> +	case V4L2_CID_FLASH_TORCH_INTENSITY:
>> +		if (ctrl->led_mode->val == V4L2_FLASH_LED_MODE_TORCH) {
>> +			torch_brightness =
>> +				v4l2_flash_intensity_to_led_brightness(
>> +						&led_cdev->brightness_ctrl,
>> +						ctrl->torch_intensity->val);
>> +			v4l2_call_flash_op(brightness_set, led_cdev,
>> +						torch_brightness);
>
> I could be missing something but don't torch and indicator require similar
> handling?

Why? Torch units need conversion whereas indicator units don't.
Moreover they have different LED API.

>> +		}
>> +		return 0;
>> +	}
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +static const struct v4l2_ctrl_ops v4l2_flash_ctrl_ops = {
>> +	.g_volatile_ctrl = v4l2_flash_g_volatile_ctrl,
>> +	.s_ctrl = v4l2_flash_s_ctrl,
>> +};
>> +
>> +static int v4l2_flash_init_controls(struct v4l2_flash *v4l2_flash)
>> +
>> +{
>> +	struct led_classdev *led_cdev = v4l2_flash->led_cdev;
>> +	struct led_flash *flash = led_cdev->flash;
>> +	bool has_indicator = flash->indicator_brightness;
>> +	struct v4l2_ctrl *ctrl;
>> +	struct led_ctrl *ctrl_cfg;
>> +	unsigned int mask;
>> +	int ret, max, num_ctrls;
>> +
>> +	num_ctrls = flash->has_flash_led ? 8 : 2;
>> +	if (flash->fault_flags)
>> +		++num_ctrls;
>> +	if (has_indicator)
>> +		++num_ctrls;
>> +
>> +	v4l2_ctrl_handler_init(&v4l2_flash->hdl, num_ctrls);
>> +
>> +	mask = 1 << V4L2_FLASH_LED_MODE_NONE |
>> +	       1 << V4L2_FLASH_LED_MODE_TORCH;
>> +	if (flash->has_flash_led)
>> +		mask |= 1 << V4L2_FLASH_LED_MODE_FLASH;
>> +
>> +	/* Configure FLASH_LED_MODE ctrl */
>> +	v4l2_flash->ctrl.led_mode = v4l2_ctrl_new_std_menu(
>> +			&v4l2_flash->hdl,
>> +			&v4l2_flash_ctrl_ops, V4L2_CID_FLASH_LED_MODE,
>> +			V4L2_FLASH_LED_MODE_TORCH, ~mask,
>> +			V4L2_FLASH_LED_MODE_NONE);
>> +
>> +	/* Configure TORCH_INTENSITY ctrl */
>> +	ctrl_cfg = &led_cdev->brightness_ctrl;
>> +	ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
>> +				 V4L2_CID_FLASH_TORCH_INTENSITY,
>> +				 ctrl_cfg->min, ctrl_cfg->max,
>> +				 ctrl_cfg->step, ctrl_cfg->val);
>> +	if (ctrl)
>> +		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
>> +	v4l2_flash->ctrl.torch_intensity = ctrl;
>> +
>> +	if (flash->has_flash_led) {
>> +		/* Configure FLASH_STROBE_SOURCE ctrl */
>> +		mask = 1 << V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
>> +
>> +		if (flash->has_external_strobe) {
>> +			mask |= 1 << V4L2_FLASH_STROBE_SOURCE_EXTERNAL;
>> +			max = V4L2_FLASH_STROBE_SOURCE_EXTERNAL;
>> +		} else {
>> +			max = V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
>> +		}
>> +
>> +		v4l2_flash->ctrl.source = v4l2_ctrl_new_std_menu(
>> +					&v4l2_flash->hdl,
>> +					&v4l2_flash_ctrl_ops,
>> +					V4L2_CID_FLASH_STROBE_SOURCE,
>> +					max,
>> +					~mask,
>> +					V4L2_FLASH_STROBE_SOURCE_SOFTWARE);
>> +
>> +		/* Configure FLASH_STROBE ctrl */
>> +		ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
>> +					  V4L2_CID_FLASH_STROBE, 0, 1, 1, 0);
>> +
>> +		/* Configure FLASH_STROBE_STOP ctrl */
>> +		ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
>> +					  V4L2_CID_FLASH_STROBE_STOP,
>> +					  0, 1, 1, 0);
>> +
>> +		/* Configure FLASH_STROBE_STATUS ctrl */
>> +		ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
>> +					 V4L2_CID_FLASH_STROBE_STATUS,
>> +					 0, 1, 1, 1);
>> +		if (ctrl)
>> +			ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE |
>> +				       V4L2_CTRL_FLAG_READ_ONLY;
>> +
>> +		/* Configure FLASH_TIMEOUT ctrl */
>> +		ctrl_cfg = &flash->timeout;
>> +		ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
>> +					 V4L2_CID_FLASH_TIMEOUT, ctrl_cfg->min,
>> +					 ctrl_cfg->max, ctrl_cfg->step,
>> +					 ctrl_cfg->val);
>> +		if (ctrl)
>> +			ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
>> +
>> +		/* Configure FLASH_INTENSITY ctrl */
>> +		ctrl_cfg = &flash->brightness;
>> +		ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
>> +					 V4L2_CID_FLASH_INTENSITY,
>> +					 ctrl_cfg->min, ctrl_cfg->max,
>> +					 ctrl_cfg->step, ctrl_cfg->val);
>> +		if (ctrl)
>> +			ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
>> +
>> +		if (flash->fault_flags) {
>> +			/* Configure FLASH_FAULT ctrl */
>> +			ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl,
>> +						 &v4l2_flash_ctrl_ops,
>> +						 V4L2_CID_FLASH_FAULT, 0,
>> +						 flash->fault_flags,
>> +						 0, 0);
>> +			if (ctrl)
>> +				ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE |
>> +					       V4L2_CTRL_FLAG_READ_ONLY;
>> +		}
>> +		if (has_indicator) {
>
> In theory it's possible to have an indicator without the flash. So I'd keep
> the two independent.

OK.

>> +			/* Configure FLASH_INDICATOR_INTENSITY ctrl */
>> +			ctrl_cfg = flash->indicator_brightness;
>> +			ctrl = v4l2_ctrl_new_std(
>> +					&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
>> +					V4L2_CID_FLASH_INDICATOR_INTENSITY,
>> +					ctrl_cfg->min, ctrl_cfg->max,
>> +					ctrl_cfg->step, ctrl_cfg->val);
>> +			if (ctrl)
>> +				ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
>> +		}
>> +	}
>> +
>> +	if (v4l2_flash->hdl.error) {
>> +		ret = v4l2_flash->hdl.error;
>> +		goto error_free;
>> +	}
>> +
>> +	ret = v4l2_ctrl_handler_setup(&v4l2_flash->hdl);
>> +	if (ret < 0)
>> +		goto error_free;
>> +
>> +	v4l2_flash->subdev.ctrl_handler = &v4l2_flash->hdl;
>> +
>> +	return 0;
>> +
>> +error_free:
>> +	v4l2_ctrl_handler_free(&v4l2_flash->hdl);
>> +	return ret;
>> +}
>> +
>> +/*
>> + * V4L2 subdev internal operations
>> + */
>> +
>> +static int v4l2_flash_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>> +{
>> +	struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
>> +	struct led_classdev *led_cdev = v4l2_flash->led_cdev;
>> +
>> +	mutex_lock(&led_cdev->led_lock);
>> +	v4l2_call_flash_op(sysfs_lock, led_cdev);
>
> Have you thought about device power management yet?

Having in mind that the V4L2 Flash sub-device is only a wrapper
for LED driver, shouldn't power management be left to the
drivers?

> Traditionally, the existing flash controller drivers are powered when a file
> handle is opened. Many newer implementations seem to consume so little power
> that it's not worthwhile to try to power them off.
>
> Binding the power state to open file handles isn't very generic either but
> it's very simple and works.
>
> V4L2 sub-devices do not use runtime PM as of yet, so perhaps this could be
> left for later.
>
>> +	mutex_unlock(&led_cdev->led_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +static int v4l2_flash_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>> +{
>> +	struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
>> +	struct led_classdev *led_cdev = v4l2_flash->led_cdev;
>> +
>> +	mutex_lock(&led_cdev->led_lock);
>> +	v4l2_call_flash_op(sysfs_unlock, led_cdev);
>> +	mutex_unlock(&led_cdev->led_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct v4l2_subdev_internal_ops v4l2_flash_subdev_internal_ops = {
>> +	.open = v4l2_flash_open,
>> +	.close = v4l2_flash_close,
>> +};
>> +
>> +static struct v4l2_subdev_ops v4l2_flash_subdev_ops = {
>> +};
>> +
>> +int v4l2_flash_init(struct led_classdev *led_cdev,
>> +		    const struct v4l2_flash_ops *ops)
>> +{
>> +	struct v4l2_flash *flash = &led_cdev->flash->v4l2_flash;
>> +	struct v4l2_subdev *sd = &flash->subdev;
>> +	int ret;
>> +
>> +	if (!led_cdev || !ops)
>> +		return -EINVAL;
>> +
>> +	flash->led_cdev = led_cdev;
>> +	sd->dev = led_cdev->dev->parent;
>> +	v4l2_subdev_init(sd, &v4l2_flash_subdev_ops);
>> +	sd->internal_ops = &v4l2_flash_subdev_internal_ops;
>> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>> +	snprintf(sd->name, sizeof(sd->name), led_cdev->name);
>
> It'd be nice to have the bus address in the name as well. But that would
> belong to the driver which calls v4l2_flash_init(). The existing flash
> controller drivers probably don't do this but many sensor drivers already
> do. The name is expected to be unique in the media device.

Will cover this.

>> +	flash->ops = ops;
>> +
>> +	ret = v4l2_flash_init_controls(flash);
>> +	if (ret < 0)
>> +		goto err_init_controls;
>> +
>> +	ret = media_entity_init(&sd->entity, 0, NULL, 0);
>> +	if (ret < 0)
>> +		goto err_init_entity;
>> +
>> +	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
>> +
>> +	ret = v4l2_async_register_subdev(sd);
>> +	if (ret < 0)
>> +		goto err_init_entity;
>> +
>> +	return 0;
>> +
>> +err_init_entity:
>> +	media_entity_cleanup(&sd->entity);
>> +err_init_controls:
>> +	v4l2_ctrl_handler_free(sd->ctrl_handler);
>> +	return -EINVAL;
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_flash_init);
>> +
>> +void v4l2_flash_release(struct led_classdev *led_cdev)
>> +{
>> +	struct v4l2_flash *flash = &led_cdev->flash->v4l2_flash;
>> +
>> +	v4l2_ctrl_handler_free(flash->subdev.ctrl_handler);
>> +	v4l2_async_unregister_subdev(&flash->subdev);
>> +	media_entity_cleanup(&flash->subdev.entity);
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_flash_release);
>> diff --git a/include/media/v4l2-flash.h b/include/media/v4l2-flash.h
>> new file mode 100644
>> index 0000000..fe16ddd
>> --- /dev/null
>> +++ b/include/media/v4l2-flash.h
>> @@ -0,0 +1,119 @@
>> +/*
>> + * V4L2 Flash LED sub-device registration helpers.
>> + *
>> + *	Copyright (C) 2014 Samsung Electronics Co., Ltd
>> + *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation."
>> + */
>> +
>> +#ifndef _V4L2_FLASH_H
>> +#define _V4L2_FLASH_H
>> +
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-dev.h>
>> +#include <media/v4l2-event.h>
>> +#include <media/v4l2-ioctl.h>
>> +
>> +#define v4l2_call_flash_op(op, args...)		\
>> +	((v4l2_flash)->ops->op(args))		\
>
> Extra backslash above.
>
> I don't think you should assume the caller will have a local variable called
> v4l2_flash. :-)

I assumed that as this macro is only for the module internal use
and aim at simplifying the calling code it can be implemented that way.
But when I look at it now it indeed doesn't seem reasonable.

>> +struct led_classdev;
>> +enum led_brightness;
>> +
>> +struct v4l2_flash_ops {
>> +	void	(*brightness_set)(struct led_classdev *led_cdev,
>> +					enum led_brightness brightness);
>> +	int	(*brightness_update)(struct led_classdev *led_cdev);
>> +	int	(*flash_brightness_set)(struct led_classdev *led_cdev,
>> +					u32 brightness);
>> +	int	(*flash_brightness_update)(struct led_classdev *led_cdev);
>> +	int	(*strobe_set)(struct led_classdev *led_cdev,
>> +					bool state);
>> +	int	(*strobe_get)(struct led_classdev *led_cdev);
>> +	int	(*timeout_set)(struct led_classdev *led_cdev,
>> +					u32 timeout);
>> +	int	(*indicator_brightness_set)(struct led_classdev *led_cdev,
>> +					u32 brightness);
>> +	int	(*indicator_brightness_update)(struct led_classdev *led_cdev);
>> +	int	(*external_strobe_set)(struct led_classdev *led_cdev,
>> +					bool enable);
>> +	int	(*fault_get)(struct led_classdev *led_cdev,
>> +					u32 *fault);
>> +	void	(*sysfs_lock)(struct led_classdev *led_cdev);
>> +	void	(*sysfs_unlock)(struct led_classdev *led_cdev);
>> +};
>> +
>> +/**
>> + * struct v4l2_flash_ctrl - controls that define the sub-dev's state
>> + * @source:		V4L2_CID_FLASH_STROBE_SOURCE control
>> + * @led_mode:		V4L2_CID_FLASH_LED_MODE control
>> + * @torch_intensity:	V4L2_CID_FLASH_TORCH_INTENSITY control
>> + */
>> +struct v4l2_flash_ctrl {
>> +	struct v4l2_ctrl *source;
>> +	struct v4l2_ctrl *led_mode;
>> +	struct v4l2_ctrl *torch_intensity;
>> +};
>> +
>> +/**
>> + * struct v4l2_flash - Flash sub-device context
>> + * @led_cdev:		LED class device controlled by this sub-device
>> + * @ops:		LED class device ops
>> + * @subdev:		V4L2 sub-device
>> + * @hdl:		flash controls handler
>> + * @ctrl:		state defining controls
>> + */
>> +struct v4l2_flash {
>> +	struct led_classdev *led_cdev;
>> +	const struct v4l2_flash_ops *ops;
>> +
>> +	struct v4l2_subdev subdev;
>> +	struct v4l2_ctrl_handler hdl;
>> +	struct v4l2_flash_ctrl ctrl;
>> +};
>> +
>> +static inline struct v4l2_flash *v4l2_subdev_to_v4l2_flash(struct v4l2_subdev *sd)
>
> Over 80 characters per line.
>
>> +{
>> +	return container_of(sd, struct v4l2_flash, subdev);
>> +}
>> +
>> +static inline struct v4l2_flash *v4l2_ctrl_to_v4l2_flash(struct v4l2_ctrl *c)
>> +{
>> +	return container_of(c->handler, struct v4l2_flash, hdl);
>> +}
>> +
>> +#ifdef CONFIG_V4L2_FLASH
>> +/**
>> + * v4l2_flash_init - initialize V4L2 flash led sub-device
>> + * @led_cdev: the LED to create subdev upon
>> + * @ops: LED subsystem callbacks
>> + *
>> + * Create V4L2 subdev wrapping given LED subsystem device.
>> + */
>> +int v4l2_flash_init(struct led_classdev *led_cdev,
>> +		    const struct v4l2_flash_ops *ops);
>> +
>> +/**
>> + * v4l2_flash_release - release V4L2 flash led sub-device
>> + * @flash: a structure representing V4L2 flash led device
>> + *
>> + * Release V4L2 flash led subdev.
>> + */
>> +void v4l2_flash_release(struct led_classdev *led_cdev);
>> +#else
>> +static inline int v4l2_flash_init(struct led_classdev *led_cdev,
>> +				  const struct v4l2_flash_ops *ops)
>> +{
>> +	return 0;
>> +}
>> +
>> +static inline void v4l2_flash_release(struct led_classdev *led_cdev)
>> +{
>> +}
>
> Could you put the two to the first patch? It won't compile otherwise.

Yeah. I didn't make test build after every patch :-/.

>> +#endif /* CONFIG_V4L2_FLASH */
>> +
>> +#endif /* _V4L2_FLASH_H */
>


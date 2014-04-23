Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaDWPZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:25:18 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38035 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751307AbaDWPZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:25:09 -0400
Date: Wed, 23 Apr 2014 18:24:35 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH/RFC v3 5/5] media: Add registration helpers for V4L2
 flash sub-devices
Message-ID: <20140423152435.GJ8753@valkosipuli.retiisi.org.uk>
References: <1397228216-6657-1-git-send-email-j.anaszewski@samsung.com>
 <1397228216-6657-6-git-send-email-j.anaszewski@samsung.com>
 <20140416182141.GG8753@valkosipuli.retiisi.org.uk>
 <534F9044.6080508@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534F9044.6080508@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

On Thu, Apr 17, 2014 at 10:26:44AM +0200, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> Thanks for the review.
> 
> On 04/16/2014 08:21 PM, Sakari Ailus wrote:
> >Hi Jacek,
> >
> >Thanks for the update!
> >
> [...]
> >>+static inline enum led_brightness v4l2_flash_intensity_to_led_brightness(
> >>+					struct led_ctrl *config,
> >>+					u32 intensity)
> >
> >Fits on a single line.
> >
> >>+{
> >>+	return intensity / config->step;
> >
> >Shouldn't you first decrement the minimum before the division?
> 
> Brightness level 0 means that led is off. Let's consider following case:
> 
> intensity - 15625
> config->step - 15625
> intensity / config->step = 1 (the lowest possible current level)

In V4L2 controls the minimum is not off, and zero might not be a possible
value since minimum isn't divisible by step.

I wonder how to best take that into account.

> >>+}
> >>+
> >>+static inline u32 v4l2_flash_led_brightness_to_intensity(
> >>+					struct led_ctrl *config,
> >>+					enum led_brightness brightness)
> >>+{
> >>+	return brightness * config->step;
> >
> >And do the opposite here?

..

> >>+			return -EINVAL;
> >>+		return v4l2_call_flash_op(strobe_set, led_cdev, true);
> >>+	case V4L2_CID_FLASH_STROBE_STOP:
> >>+		return v4l2_call_flash_op(strobe_set, led_cdev, false);
> >>+	case V4L2_CID_FLASH_TIMEOUT:
> >>+		ret =  v4l2_call_flash_op(timeout_set, led_cdev, c->val);
> >>+	case V4L2_CID_FLASH_INTENSITY:
> >>+		/* no conversion is needed */
> >>+		return v4l2_call_flash_op(flash_brightness_set, led_cdev,
> >>+								c->val);
> >>+	case V4L2_CID_FLASH_INDICATOR_INTENSITY:
> >>+		/* no conversion is needed */
> >>+		return v4l2_call_flash_op(indicator_brightness_set, led_cdev,
> >>+								c->val);
> >>+	case V4L2_CID_FLASH_TORCH_INTENSITY:
> >>+		if (ctrl->led_mode->val == V4L2_FLASH_LED_MODE_TORCH) {
> >>+			torch_brightness =
> >>+				v4l2_flash_intensity_to_led_brightness(
> >>+						&led_cdev->brightness_ctrl,
> >>+						ctrl->torch_intensity->val);
> >>+			v4l2_call_flash_op(brightness_set, led_cdev,
> >>+						torch_brightness);
> >
> >I could be missing something but don't torch and indicator require similar
> >handling?
> 
> Why? Torch units need conversion whereas indicator units don't.
> Moreover they have different LED API.

I missed it was already in micro-Amps.

> >>+		}
> >>+		return 0;
> >>+	}
> >>+
> >>+	return -EINVAL;
> >>+}
> >>+
> >>+static const struct v4l2_ctrl_ops v4l2_flash_ctrl_ops = {
> >>+	.g_volatile_ctrl = v4l2_flash_g_volatile_ctrl,
> >>+	.s_ctrl = v4l2_flash_s_ctrl,
> >>+};
> >>+
> >>+static int v4l2_flash_init_controls(struct v4l2_flash *v4l2_flash)
> >>+
> >>+{
> >>+	struct led_classdev *led_cdev = v4l2_flash->led_cdev;
> >>+	struct led_flash *flash = led_cdev->flash;
> >>+	bool has_indicator = flash->indicator_brightness;
> >>+	struct v4l2_ctrl *ctrl;
> >>+	struct led_ctrl *ctrl_cfg;
> >>+	unsigned int mask;
> >>+	int ret, max, num_ctrls;
> >>+
> >>+	num_ctrls = flash->has_flash_led ? 8 : 2;
> >>+	if (flash->fault_flags)
> >>+		++num_ctrls;
> >>+	if (has_indicator)
> >>+		++num_ctrls;
> >>+
> >>+	v4l2_ctrl_handler_init(&v4l2_flash->hdl, num_ctrls);
> >>+
> >>+	mask = 1 << V4L2_FLASH_LED_MODE_NONE |
> >>+	       1 << V4L2_FLASH_LED_MODE_TORCH;
> >>+	if (flash->has_flash_led)
> >>+		mask |= 1 << V4L2_FLASH_LED_MODE_FLASH;
> >>+
> >>+	/* Configure FLASH_LED_MODE ctrl */
> >>+	v4l2_flash->ctrl.led_mode = v4l2_ctrl_new_std_menu(
> >>+			&v4l2_flash->hdl,
> >>+			&v4l2_flash_ctrl_ops, V4L2_CID_FLASH_LED_MODE,
> >>+			V4L2_FLASH_LED_MODE_TORCH, ~mask,
> >>+			V4L2_FLASH_LED_MODE_NONE);
> >>+
> >>+	/* Configure TORCH_INTENSITY ctrl */
> >>+	ctrl_cfg = &led_cdev->brightness_ctrl;
> >>+	ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
> >>+				 V4L2_CID_FLASH_TORCH_INTENSITY,
> >>+				 ctrl_cfg->min, ctrl_cfg->max,
> >>+				 ctrl_cfg->step, ctrl_cfg->val);
> >>+	if (ctrl)
> >>+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
> >>+	v4l2_flash->ctrl.torch_intensity = ctrl;
> >>+
> >>+	if (flash->has_flash_led) {
> >>+		/* Configure FLASH_STROBE_SOURCE ctrl */
> >>+		mask = 1 << V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
> >>+
> >>+		if (flash->has_external_strobe) {
> >>+			mask |= 1 << V4L2_FLASH_STROBE_SOURCE_EXTERNAL;
> >>+			max = V4L2_FLASH_STROBE_SOURCE_EXTERNAL;
> >>+		} else {
> >>+			max = V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
> >>+		}
> >>+
> >>+		v4l2_flash->ctrl.source = v4l2_ctrl_new_std_menu(
> >>+					&v4l2_flash->hdl,
> >>+					&v4l2_flash_ctrl_ops,
> >>+					V4L2_CID_FLASH_STROBE_SOURCE,
> >>+					max,
> >>+					~mask,
> >>+					V4L2_FLASH_STROBE_SOURCE_SOFTWARE);
> >>+
> >>+		/* Configure FLASH_STROBE ctrl */
> >>+		ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
> >>+					  V4L2_CID_FLASH_STROBE, 0, 1, 1, 0);
> >>+
> >>+		/* Configure FLASH_STROBE_STOP ctrl */
> >>+		ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
> >>+					  V4L2_CID_FLASH_STROBE_STOP,
> >>+					  0, 1, 1, 0);
> >>+
> >>+		/* Configure FLASH_STROBE_STATUS ctrl */
> >>+		ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
> >>+					 V4L2_CID_FLASH_STROBE_STATUS,
> >>+					 0, 1, 1, 1);
> >>+		if (ctrl)
> >>+			ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE |
> >>+				       V4L2_CTRL_FLAG_READ_ONLY;
> >>+
> >>+		/* Configure FLASH_TIMEOUT ctrl */
> >>+		ctrl_cfg = &flash->timeout;
> >>+		ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
> >>+					 V4L2_CID_FLASH_TIMEOUT, ctrl_cfg->min,
> >>+					 ctrl_cfg->max, ctrl_cfg->step,
> >>+					 ctrl_cfg->val);
> >>+		if (ctrl)
> >>+			ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
> >>+
> >>+		/* Configure FLASH_INTENSITY ctrl */
> >>+		ctrl_cfg = &flash->brightness;
> >>+		ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
> >>+					 V4L2_CID_FLASH_INTENSITY,
> >>+					 ctrl_cfg->min, ctrl_cfg->max,
> >>+					 ctrl_cfg->step, ctrl_cfg->val);
> >>+		if (ctrl)
> >>+			ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
> >>+
> >>+		if (flash->fault_flags) {
> >>+			/* Configure FLASH_FAULT ctrl */
> >>+			ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl,
> >>+						 &v4l2_flash_ctrl_ops,
> >>+						 V4L2_CID_FLASH_FAULT, 0,
> >>+						 flash->fault_flags,
> >>+						 0, 0);
> >>+			if (ctrl)
> >>+				ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE |
> >>+					       V4L2_CTRL_FLAG_READ_ONLY;
> >>+		}
> >>+		if (has_indicator) {
> >
> >In theory it's possible to have an indicator without the flash. So I'd keep
> >the two independent.
> 
> OK.
> 
> >>+			/* Configure FLASH_INDICATOR_INTENSITY ctrl */
> >>+			ctrl_cfg = flash->indicator_brightness;
> >>+			ctrl = v4l2_ctrl_new_std(
> >>+					&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
> >>+					V4L2_CID_FLASH_INDICATOR_INTENSITY,
> >>+					ctrl_cfg->min, ctrl_cfg->max,
> >>+					ctrl_cfg->step, ctrl_cfg->val);
> >>+			if (ctrl)
> >>+				ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
> >>+		}
> >>+	}
> >>+
> >>+	if (v4l2_flash->hdl.error) {
> >>+		ret = v4l2_flash->hdl.error;
> >>+		goto error_free;
> >>+	}
> >>+
> >>+	ret = v4l2_ctrl_handler_setup(&v4l2_flash->hdl);
> >>+	if (ret < 0)
> >>+		goto error_free;
> >>+
> >>+	v4l2_flash->subdev.ctrl_handler = &v4l2_flash->hdl;
> >>+
> >>+	return 0;
> >>+
> >>+error_free:
> >>+	v4l2_ctrl_handler_free(&v4l2_flash->hdl);
> >>+	return ret;
> >>+}
> >>+
> >>+/*
> >>+ * V4L2 subdev internal operations
> >>+ */
> >>+
> >>+static int v4l2_flash_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> >>+{
> >>+	struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
> >>+	struct led_classdev *led_cdev = v4l2_flash->led_cdev;
> >>+
> >>+	mutex_lock(&led_cdev->led_lock);
> >>+	v4l2_call_flash_op(sysfs_lock, led_cdev);
> >
> >Have you thought about device power management yet?
> 
> Having in mind that the V4L2 Flash sub-device is only a wrapper
> for LED driver, shouldn't power management be left to the
> drivers?

How does the LED controller driver know it needs to power the device up in
that case?

I think an s_power() op which uses PM runtime to set the power state until
V4L2 sub-device switches to it should be enough. But I'm fine leaving it out
from this patchset.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934472AbaEFI2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:28:50 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33643 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934333AbaEFI2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:28:46 -0400
Date: Tue, 6 May 2014 11:28:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        SangYoung Son <hello.son@smasung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH/RFC v3 3/5] leds: Add support for max77693 mfd flash cell
Message-ID: <20140506082839.GA8753@valkosipuli.retiisi.org.uk>
References: <1397228216-6657-1-git-send-email-j.anaszewski@samsung.com>
 <1397228216-6657-4-git-send-email-j.anaszewski@samsung.com>
 <20140416172604.GF8753@valkosipuli.retiisi.org.uk>
 <534F9D7A.6070203@samsung.com>
 <20140423155234.GK8753@valkosipuli.retiisi.org.uk>
 <535E3B1F.4030402@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535E3B1F.4030402@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

On Mon, Apr 28, 2014 at 01:27:27PM +0200, Jacek Anaszewski wrote:
...
> >>>>+static void max77693_brightness_set_work(struct work_struct *work)
> >>>>+{
> >>>>+	struct max77693_led *led =
> >>>>+		container_of(work, struct max77693_led, work_brightness_set);
> >>>>+	int ret;
> >>>>+
> >>>>+	mutex_lock(&led->lock);
> >>>>+
> >>>>+	if (led->torch_brightness == 0) {
> >>>>+		ret = max77693_clear_mode(led, MAX77693_MODE_TORCH);
> >>>>+		if (ret < 0)
> >>>>+			dev_dbg(&led->pdev->dev,
> >>>>+				"Failed to clear torch mode (%d)\n",
> >>>>+				ret);
> >>>>+		goto unlock;
> >>>>+	}
> >>>>+
> >>>>+	ret = max77693_set_torch_current(led, led->torch_brightness *
> >>>>+						MAX77693_TORCH_IOUT_STEP);
> >>>>+	if (ret < 0) {
> >>>>+		dev_dbg(&led->pdev->dev, "Failed to set torch current (%d)\n",
> >>>>+			ret);
> >>>>+		goto unlock;
> >>>>+	}
> >>>>+
> >>>>+	ret = max77693_add_mode(led, MAX77693_MODE_TORCH);
> >>>>+	if (ret < 0)
> >>>>+		dev_dbg(&led->pdev->dev, "Failed to set torch mode (%d)\n",
> >>>>+			ret);
> >>>>+unlock:
> >>>>+	mutex_unlock(&led->lock);
> >>>>+}
> >>>>+
> >>>>+static void max77693_led_brightness_set(struct led_classdev *led_cdev,
> >>>>+				enum led_brightness value)
> >>>>+{
> >>>>+	struct max77693_led *led = ldev_to_led(led_cdev);
> >>>>+
> >>>>+	led->torch_brightness = value;
> >>>>+	schedule_work(&led->work_brightness_set);
> >>>
> >>>Is there a reason not to do this right now (but in a work queue instead)?
> >>
> >>Almost all the drivers in the LED subsystem do it that way.
> >>I think that it is caused by the fact that setting led brightness
> >>should be as fast as possible and non-blocking. The led may be
> >>used e.g. for HD LED (see ledtrig-ide) and activated many times
> >>per second, and thus it could have impact on the system performance
> >>if it wasn't run in a work queue.
> >
> >Fair enough. But the expectation is that the V4L2 control's value has taken
> >effect when the set control handler returns. That is also what virtually all
> >existing implementations do.
> >
> >Could this be handled in the LED framework instead so that the V4L2 controls
> >would function synchronously?
> 
> There could be added an op to the led_flash_ops structure, for setting
> led brightness with guaranteed immediate effect, intended for use only
> by V4L2 flash sub-devs. The Flash LED driver would have to implement two
> ops for setting torch brightness - one for use by led class API,
> using work queue, and the other for use by V4L2 flash sub-dev, without
> work queue.

I think the work queue should be moved to the LED framework. There could be
another op for the driver to implement but the driver should need to
implement only a single one. Alternatively, the work queue implementation
should be moved out of the drivers. Or, if the op is really simple such as a
single register access on a fast bus, the work queue would likely not be
needed at all.

> >
> >I'm ok for postponing this as long as we agree on how it'd be fixed. Perhaps
> >someone from the LED framework side to comment.
> >
> >>>>+}
> >>>>+
> >>>>+static int max77693_led_flash_strobe_get(struct led_classdev *led_cdev)
> >>>>+{
> >>>>+	struct max77693_led *led = ldev_to_led(led_cdev);
> >>>>+	int ret;
> >>>>+
> >>>>+	mutex_lock(&led->lock);
> >>>>+	ret = max77693_strobe_status_get(led);
> >>>>+	mutex_unlock(&led->lock);
> >>>>+
> >>>>+	return ret;
> >>>>+}
> >>>>+
> >>>>+static int max77693_led_flash_fault_get(struct led_classdev *led_cdev,
> >>>>+					u32 *fault)
> >>>>+{
> >>>>+	struct max77693_led *led = ldev_to_led(led_cdev);
> >>>>+	u8 v;
> >>>>+	int ret;
> >>>>+
> >>>>+	mutex_lock(&led->lock);
> >>>>+
> >>>>+	ret = max77693_int_flag_get(led, &v);
> >>>>+	if (ret < 0)
> >>>>+		goto unlock;
> >>>>+
> >>>>+	*fault = 0;
> >>>>+
> >>>>+	if (v & MAX77693_LED_FLASH_INT_FLED2_OPEN ||
> >>>>+	    v & MAX77693_LED_FLASH_INT_FLED1_OPEN)
> >>>>+		*fault |= LED_FAULT_OVER_VOLTAGE;
> >>>>+	if (v & MAX77693_LED_FLASH_INT_FLED2_SHORT ||
> >>>>+	    v & MAX77693_LED_FLASH_INT_FLED1_SHORT)
> >>>>+		*fault |= LED_FAULT_SHORT_CIRCUIT;
> >>>>+	if (v & MAX77693_LED_FLASH_INT_OVER_CURRENT)
> >>>>+		*fault |= LED_FAULT_OVER_CURRENT;
> >>>>+unlock:
> >>>>+	mutex_unlock(&led->lock);
> >>>>+	return ret;
> >>>>+}
> >>>>+
> >>>>+static int max77693_led_flash_strobe_set(struct led_classdev *led_cdev,
> >>>>+						bool state)
> >>>>+{
> >>>>+	struct max77693_led *led = ldev_to_led(led_cdev);
> >>>>+	struct led_flash *flash = led_cdev->flash;
> >>>>+	int ret;
> >>>>+
> >>>>+	mutex_lock(&led->lock);
> >>>>+
> >>>>+	if (flash->external_strobe) {
> >>>>+		ret = -EBUSY;
> >>>>+		goto unlock;
> >>>>+	}
> >>>>+
> >>>>+	if (!state) {
> >>>>+		ret = max77693_clear_mode(led, MAX77693_MODE_FLASH);
> >>>>+		goto unlock;
> >>>>+	}
> >>>>+
> >>>>+	ret = max77693_add_mode(led, MAX77693_MODE_FLASH);
> >>>>+	if (ret < 0)
> >>>>+		goto unlock;
> >>>>+unlock:
> >>>>+	mutex_unlock(&led->lock);
> >>>>+	return ret;
> >>>>+}
> >>>>+
> >>>>+static int max77693_led_external_strobe_set(struct led_classdev *led_cdev,
> >>>>+						bool enable)
> >>>>+{
> >>>>+	struct max77693_led *led = ldev_to_led(led_cdev);
> >>>>+	int ret;
> >>>>+
> >>>>+	mutex_lock(&led->lock);
> >>>>+
> >>>>+	if (enable)
> >>>>+		ret = max77693_add_mode(led, MAX77693_MODE_FLASH_EXTERNAL);
> >>>>+	else
> >>>>+		ret = max77693_clear_mode(led, MAX77693_MODE_FLASH_EXTERNAL);
> >>>>+
> >>>>+	mutex_unlock(&led->lock);
> >>>>+
> >>>>+	return ret;
> >>>>+}
> >>>>+
> >>>>+static int max77693_led_flash_brightness_set(struct led_classdev *led_cdev,
> >>>>+						u32 brightness)
> >>>>+{
> >>>>+	struct max77693_led *led = ldev_to_led(led_cdev);
> >>>>+	int ret;
> >>>>+
> >>>>+	mutex_lock(&led->lock);
> >>>>+
> >>>>+	ret = max77693_set_flash_current(led, brightness);
> >>>>+	if (ret < 0)
> >>>>+		goto unlock;
> >>>>+unlock:
> >>>>+	mutex_unlock(&led->lock);
> >>>>+	return ret;
> >>>>+}
> >>>>+
> >>>>+static int max77693_led_flash_timeout_set(struct led_classdev *led_cdev,
> >>>>+						u32 timeout)
> >>>>+{
> >>>>+	struct max77693_led *led = ldev_to_led(led_cdev);
> >>>>+	int ret;
> >>>>+
> >>>>+	mutex_lock(&led->lock);
> >>>>+
> >>>>+	ret = max77693_set_timeout(led, timeout);
> >>>>+	if (ret < 0)
> >>>>+		goto unlock;
> >>>>+
> >>>>+unlock:
> >>>>+	mutex_unlock(&led->lock);
> >>>>+	return ret;
> >>>>+}
> >>>>+
> >>>>+static void max77693_led_parse_dt(struct max77693_led_platform_data *p,
> >>>>+			    struct device_node *node)
> >>>>+{
> >>>>+	of_property_read_u32_array(node, "maxim,iout", p->iout, 4);
> >>>
> >>>How about separate current for flash and torch modes? They are the same
> >>>LEDs; just the mode is different.
> >>
> >>There are separate currents - 2 for torch and 2 for flash mode.
> >
> >True. But shouldn't they be two different properties as, well, these are
> >different properties of individual hardware devices? :-)
> 
> Sure. I will split them.

Thanks.

> >>>>+	of_property_read_u32_array(node, "maxim,trigger", p->trigger, 4);
> >>>>+	of_property_read_u32_array(node, "maxim,trigger-type", p->trigger_type,
> >>>>+									2);
> >>>>+	of_property_read_u32_array(node, "maxim,timeout", p->timeout, 2);
> >>>>+	of_property_read_u32_array(node, "maxim,boost-mode", p->boost_mode, 2);
> >>>>+	of_property_read_u32(node, "maxim,boost-vout", &p->boost_vout);
> >>>>+	of_property_read_u32(node, "maxim,vsys-min", &p->low_vsys);
> >>>
> >>>Are these values specific to the maxim chip? I'd suppose e.g. timeout and
> >>>iout are something that can be found pretty much in any flash controller.
> >>
> >>Besides the two they are specific. And what with timeout and iout
> >>if they are common for all flash controllers?
> >
> >They should be defined in a way which is not specific to the chip itself.
> >That would also change the property names. I'm not sure how much of this is
> >already done on the LED side.
> 
> I've missed Documentation/devicetree/bindings/leds/common.txt.
> The iout and timeout properties could be added there.

Sounds good to me.

> >>>>+}
> >>>>+
> >>>>+static void clamp_align(u32 *v, u32 min, u32 max, u32 step)
> >>>>+{
> >>>>+	*v = clamp_val(*v, min, max);
> >>>>+	if (step > 1)
> >>>>+		*v = (*v - min) / step * step + min;
> >>>>+}
> >>>>+
> >>>>+static void max77693_led_validate_platform_data(
> >>>>+					struct max77693_led_platform_data *p)
> >>>>+{
> >>>>+	u32 max;
> >>>>+	int i;
> >>>>+
> >>>>+	for (i = 0; i < 2; ++i)
> >>>
> >>>How about using ARRAY_SIZE() here, too?
> >>
> >>OK.
> >>
> >>>
> >>>>+		clamp_align(&p->boost_mode[i], MAX77693_LED_BOOST_NONE,
> >>>>+			    MAX77693_LED_BOOST_FIXED, 1);
> >>>>+	/* boost, if enabled, should be the same on both leds */
> >>>>+	if (p->boost_mode[0] != MAX77693_LED_BOOST_NONE &&
> >>>>+	    p->boost_mode[1] != MAX77693_LED_BOOST_NONE)
> >>>>+		p->boost_mode[1] = p->boost_mode[0];
> >>>>+
> >>>>+	max = (p->boost_mode[FLASH1] && p->boost_mode[FLASH2]) ?
> >>>>+		  MAX77693_FLASH_IOUT_MAX_2LEDS : MAX77693_FLASH_IOUT_MAX_1LED;
> >>>>+
> >>>>+	clamp_align(&p->iout[FLASH1], MAX77693_FLASH_IOUT_MIN,
> >>>>+		    max, MAX77693_FLASH_IOUT_STEP);
> >>>>+	clamp_align(&p->iout[FLASH2], MAX77693_FLASH_IOUT_MIN,
> >>>>+		    max, MAX77693_FLASH_IOUT_STEP);
> >>>>+	clamp_align(&p->iout[TORCH1], MAX77693_TORCH_IOUT_MIN,
> >>>>+		    MAX77693_TORCH_IOUT_MAX, MAX77693_TORCH_IOUT_STEP);
> >>>>+	clamp_align(&p->iout[TORCH2], MAX77693_TORCH_IOUT_MIN,
> >>>>+		    MAX77693_TORCH_IOUT_MAX, MAX77693_TORCH_IOUT_STEP);
> >>>>+
> >>>>+	for (i = 0; i < 4; ++i)
> >>>>+		clamp_align(&p->trigger[i], 0, 7, 1);
> >
> >You can just use clamp() here. Same elsewhere where step == 1.
> >
> >>>>+	for (i = 0; i < 2; ++i)
> >>>>+		clamp_align(&p->trigger_type[i], MAX77693_LED_TRIG_TYPE_EDGE,
> >>>>+			    MAX77693_LED_TRIG_TYPE_LEVEL, 1);
> >>>
> >>>ARRAY_SIZE() would be nicer than using numeric values for the loop
> >>>condition.
> >>>
> >>>>+	clamp_align(&p->timeout[FLASH], MAX77693_FLASH_TIMEOUT_MIN,
> >>>>+		    MAX77693_FLASH_TIMEOUT_MAX, MAX77693_FLASH_TIMEOUT_STEP);
> >>>>+
> >>>>+	if (p->timeout[TORCH]) {
> >>>>+		clamp_align(&p->timeout[TORCH], MAX77693_TORCH_TIMEOUT_MIN,
> >>>>+			    MAX77693_TORCH_TIMEOUT_MAX, 1);
> >>>>+		p->timeout[TORCH] = max77693_torch_timeout_from_reg(
> >>>>+			      max77693_torch_timeout_to_reg(p->timeout[TORCH]));
> >>>>+	}
> >>>>+
> >>>>+	clamp_align(&p->boost_vout, MAX77693_FLASH_VOUT_MIN,
> >>>>+		    MAX77693_FLASH_VOUT_MAX, MAX77693_FLASH_VOUT_STEP);
> >>>>+
> >>>>+	if (p->low_vsys) {
> >
> >Extra braces.
> >
> >>>>+		clamp_align(&p->low_vsys, MAX77693_FLASH_VSYS_MIN,
> >>>>+			    MAX77693_FLASH_VSYS_MAX, MAX77693_FLASH_VSYS_STEP);
> >>>>+	}
> >>>>+}
> >>>>+
> >>>>+static int max77693_led_get_platform_data(struct max77693_led *led)
> >>>>+{
> >>>>+	struct max77693_led_platform_data *p;
> >>>>+	struct device *dev = &led->pdev->dev;
> >>>>+
> >>>>+	if (dev->of_node) {
> >>>>+		p = devm_kzalloc(dev, sizeof(*led->pdata), GFP_KERNEL);
> >>>>+		if (!p)
> >>>>+			return -ENOMEM;
> >>>
> >>>Check for p can be moved out of the if as it's the same for both.
> >>>
> >>>You could also use led->pdata directly. Up to you.
> >>>
> >>>>+		max77693_led_parse_dt(p, dev->of_node);
> >>>>+	} else {
> >>>>+		p = dev_get_platdata(dev);
> >>>>+		if (!p)
> >>>>+			return -ENODEV;
> >>>>+	}
> >>>>+	led->pdata = p;
> >>>>+
> >>>>+	max77693_led_validate_platform_data(p);
> >>>>+
> >>>>+	return 0;
> >>>>+}
> >>>>+
> >>>>+static struct led_flash led_flash = {
> >>>>+	.ops = {
> >>>>+		.brightness_set		= max77693_led_flash_brightness_set,
> >>>>+		.strobe_set		= max77693_led_flash_strobe_set,
> >>>>+		.strobe_get		= max77693_led_flash_strobe_get,
> >>>>+		.timeout_set		= max77693_led_flash_timeout_set,
> >>>>+		.external_strobe_set	= max77693_led_external_strobe_set,
> >>>>+		.fault_get		= max77693_led_flash_fault_get,
> >>>>+	},
> >>>>+	.has_flash_led = true,
> >>>>+};
> >>>>+
> >>>>+static void max77693_init_led_controls(struct led_classdev *led_cdev,
> >>>>+					struct max77693_led_platform_data *p)
> >>>>+{
> >>>>+	struct led_flash *flash = led_cdev->flash;
> >>>>+	struct led_ctrl *c;
> >>>>+
> >>>>+	/*
> >>>>+	 * brightness_ctrl and fault_flags are used only
> >>>>+	 * for initializing related V4L2 controls.
> >>>>+	 */
> >>>>+#ifdef CONFIG_V4L2_FLASH
> >>>>+	flash->fault_flags = V4L2_FLASH_FAULT_OVER_VOLTAGE |
> >>>>+			     V4L2_FLASH_FAULT_SHORT_CIRCUIT |
> >>>>+			     V4L2_FLASH_FAULT_OVER_CURRENT;
> >>>>+
> >>>>+	c = &led_cdev->brightness_ctrl;
> >>>>+	c->min = (p->iout[TORCH1] != 0 && p->iout[TORCH2] != 0) ?
> >>>>+					MAX77693_TORCH_IOUT_MIN * 2 :
> >>>>+					MAX77693_TORCH_IOUT_MIN;
> >>>>+	c->max = p->iout[TORCH1] + p->iout[TORCH2];
> >>>>+	c->step = MAX77693_TORCH_IOUT_STEP;
> >>>>+	c->val = p->iout[TORCH1] + p->iout[TORCH2];
> >>>
> >>>Can you control the current for the two flash LEDs separately?
> >>
> >>Yes.
> >>
> >>>If yes, this
> >>>should be also available on the V4L2 flash API. The lm3560 driver does this,
> >>>for example. (It creates two sub-devices since we can only control a single
> >>>LED using a single sub-device, at least for the time being.)
> >>
> >>So, should I propose new V4L2 flash API for controlling more than
> >>one led? Probably similar improvement should be applied to the
> >>LED subsystem.
> >
> >As said, the V4L2 API exposes two sub-devices currently. That's just a hack,
> >though; I think we need extensions in the V4L2 core API to support this
> >properly: controls are per-(sub)device and we certainly do not want controls
> >such as V4L2_CID_FLASH2_INTENSITY. But I don't think it's an excuse for e.g.
> >LED API not to do it. :-)
> >
> >One option would be to use a matrix control but I'm not sure how much I like
> >that option either: there's nothing in the API that suggests that the index
> >is the LED number, for instance. That is still the only realistic
> >possibility right now. Actually --- this is what I'd suggest right now. Cc
> >Hans.
> >
> >What I'm worried about is that, as this will affect the user space API in a
> >way or another very probably, changing it later on could be a problem. That
> >has been proved multiple times and people are often afraid of even trying to
> >do so. So if we can think of a way how to meaningfully extend the LED API
> >now into this direction and get an acceptance from the LED API developers,
> >that would be highly appreciated.
> >
> 
> As the LED class devices also call led_classdev_register separately
> for every led exposed by the device I propose we would stick to
> this which would also allow to continue exploiting V4L2 hack and
> create separate V4L2 sub-dev for each sub-led.

As we're coupling two kernel frameworks together we shouldn't plan for
continuous use of hacks that will be visible in the user space API.

I think I'm strongly leaning towards using an array of integers for
controlling multiple LEDs where the control applies to an individual LED.
Hans said he's going to update the complex controls support patchset (which
is needed for this) soon.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

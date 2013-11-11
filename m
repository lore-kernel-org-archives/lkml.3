Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab3KKNbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:31:52 -0500
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1850 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab3KKNbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:31:48 -0500
Message-ID: <5280DC31.5060509@xs4all.nl>
Date: Mon, 11 Nov 2013 14:31:29 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Marek Belisko <marek@goldelico.com>
CC: m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, hns@goldelico.com
Subject: Re: [PATCH] media: i2c: Add camera driver for ov9655 chips.
References: <1383947183-11122-1-git-send-email-marek@goldelico.com>
In-Reply-To: <1383947183-11122-1-git-send-email-marek@goldelico.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

Thanks for the patch!

I have a few small comments below...

On 11/08/2013 10:46 PM, Marek Belisko wrote:
> This is a driver for the Omnivision OV9655 camera module
> connected to the OMAP3 parallel camera interface and using
> the ISP (Image Signal Processor). It supports SXGA and VGA
> plus some other modes.
> 
> It was tested on gta04 board.
> 
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> ---
>  drivers/media/i2c/Kconfig  |    8 +
>  drivers/media/i2c/Makefile |    1 +
>  drivers/media/i2c/ov9655.c | 1205 ++++++++++++++++++++++++++++++++++++++++++++
>  include/media/ov9655.h     |   17 +
>  4 files changed, 1231 insertions(+)
>  create mode 100644 drivers/media/i2c/ov9655.c
>  create mode 100644 include/media/ov9655.h
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 842654d..97d5e4e 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -501,6 +501,14 @@ config VIDEO_OV9650
>  	  This is a V4L2 sensor-level driver for the Omnivision
>  	  OV9650 and OV9652 camera sensors.
>  
> +config VIDEO_OV9655
> +	tristate "OmniVision OV9655 sensor support"
> +	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +	depends on MEDIA_CAMERA_SUPPORT
> +	---help---
> +	  This is a Video4Linux2 sensor-level driver for the OmniVision
> +	  OV9655 image sensor.
> +
>  config VIDEO_VS6624
>  	tristate "ST VS6624 sensor support"
>  	depends on VIDEO_V4L2 && I2C
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index e03f177..367ea01 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -57,6 +57,7 @@ obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
>  obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
>  obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
>  obj-$(CONFIG_VIDEO_OV9650) += ov9650.o
> +obj-$(CONFIG_VIDEO_OV9655) += ov9655.o
>  obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
>  obj-$(CONFIG_VIDEO_MT9M032) += mt9m032.o
>  obj-$(CONFIG_VIDEO_MT9P031) += mt9p031.o
> diff --git a/drivers/media/i2c/ov9655.c b/drivers/media/i2c/ov9655.c
> new file mode 100644
> index 0000000..770abfe
> --- /dev/null
> +++ b/drivers/media/i2c/ov9655.c

<snip>

> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 subdev control operations
> + */
> +
> +#define V4L2_CID_BLC_AUTO		(V4L2_CID_USER_BASE | 0x1002)
> +#define V4L2_CID_BLC_TARGET_LEVEL	(V4L2_CID_USER_BASE | 0x1003)
> +#define V4L2_CID_BLC_ANALOG_OFFSET	(V4L2_CID_USER_BASE | 0x1004)
> +#define V4L2_CID_BLC_DIGITAL_OFFSET	(V4L2_CID_USER_BASE | 0x1005)

For private controls you need to reserve a control range in
include/uapi/linux/v4l2-controls.h. Search for V4L2_CID_USER_TI_VPE_BASE to
see how that is done.

Then you can use that BASE define for the controls above.

You also have to document these controls. You can do that in this source somewhere,
but it has to be clear what the controls do.

> +
> +static int ov9655_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct ov9655 *ov9655 =
> +			container_of(ctrl->handler, struct ov9655, ctrls);
> +	int ret;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_TEST_PATTERN:
> +		if (!ctrl->val) {
> +			/* Restore the black level compensation settings. */
> +			if (ov9655->blc_auto->cur.val != 0) {
> +				ret = ov9655_s_ctrl(ov9655->blc_auto);
> +				if (ret < 0)
> +					return ret;
> +			}
> +			if (ov9655->blc_offset->cur.val != 0) {
> +				ret = ov9655_s_ctrl(ov9655->blc_offset);
> +				if (ret < 0)
> +					return ret;
> +			}
> +		}
> +		break;
> +
> +	default:
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct v4l2_ctrl_ops ov9655_ctrl_ops = {
> +	.s_ctrl = ov9655_s_ctrl,
> +};
> +
> +static const char * const ov9655_test_pattern_menu[] = {
> +	"Disabled",
> +	"Color Field",
> +	"Horizontal Gradient",
> +	"Vertical Gradient",
> +	"Diagonal Gradient",
> +	"Classic Test Pattern",
> +	"Walking 1s",
> +	"Monochrome Horizontal Bars",
> +	"Monochrome Vertical Bars",
> +	"Vertical Color Bars",
> +};
> +
> +static const struct v4l2_ctrl_config ov9655_ctrls[] = {
> +	{
> +		.ops		= &ov9655_ctrl_ops,
> +		.id		= V4L2_CID_BLC_AUTO,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "BLC, Auto",
> +		.min		= 0,
> +		.max		= 1,
> +		.step		= 1,
> +		.def		= 1,
> +		.flags		= 0,
> +	}, {
> +		.ops		= &ov9655_ctrl_ops,
> +		.id		= V4L2_CID_BLC_TARGET_LEVEL,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "BLC Target Level",
> +		.min		= 0,
> +		.max		= 4095,
> +		.step		= 1,
> +		.def		= 168,
> +		.flags		= 0,
> +	}, {
> +		.ops		= &ov9655_ctrl_ops,
> +		.id		= V4L2_CID_BLC_ANALOG_OFFSET,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "BLC Analog Offset",
> +		.min		= -255,
> +		.max		= 255,
> +		.step		= 1,
> +		.def		= 32,
> +		.flags		= 0,
> +	}, {
> +		.ops		= &ov9655_ctrl_ops,
> +		.id		= V4L2_CID_BLC_DIGITAL_OFFSET,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "BLC Digital Offset",
> +		.min		= -2048,
> +		.max		= 2047,
> +		.step		= 1,
> +		.def		= 40,
> +		.flags		= 0,
> +	}
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 subdev core operations
> + */
> +
> +static int ov9655_set_power(struct v4l2_subdev *subdev, int on)
> +{
> +	struct ov9655 *ov9655 = to_ov9655(subdev);
> +	int ret = 0;
> +
> +	mutex_lock(&ov9655->power_lock);
> +
> +	/* If the power count is modified from 0 to != 0 or from != 0 to 0,
> +	 * update the power state.
> +	 */
> +	if (ov9655->power_count == !on) {
> +		ret = __ov9655_set_power(ov9655, !!on);
> +		if (ret < 0)
> +			goto out;
> +	}
> +
> +	/* Update the power count. */
> +	ov9655->power_count += on ? 1 : -1;
> +	WARN_ON(ov9655->power_count < 0);
> +
> +out:
> +	mutex_unlock(&ov9655->power_lock);
> +	return ret;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 subdev internal operations
> + */
> +
> +static int ov9655_registered(struct v4l2_subdev *subdev)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> +	struct ov9655 *ov9655 = to_ov9655(subdev);
> +	s32 data;
> +	int ret;
> +
> +	ret = ov9655_power_on(ov9655);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "OV9655 power up failed\n");
> +		return ret;
> +	}
> +
> +	/* Read chip manufacturer register */
> +	data = (ov9655_read(client, OV9655_MIDH) << 8) +
> +		ov9655_read(client, OV9655_MIDL);
> +
> +	if (data < 0) {
> +		dev_err(&client->dev,
> +			"OV9655 not detected, can't read manufacturer id\n");
> +		return -ENODEV;
> +	}
> +
> +	if (data != OV9655_CHIP_MID) {
> +		dev_err(&client->dev,
> +			"OV9655 not detected, wrong manufacturer 0x%04x\n",
> +			(unsigned) data);
> +		return -ENODEV;
> +	}
> +
> +	data = ov9655_read(client, OV9655_PID);
> +	if (data != OV9655_CHIP_PID) {
> +		dev_err(&client->dev,
> +			"OV9655 not detected, wrong part 0x%02x\n",
> +			(unsigned) data);
> +		return -ENODEV;
> +	}
> +
> +	data = ov9655_read(client, OV9655_VER);
> +	if (data != OV9655_CHIP_VER4 && data != OV9655_CHIP_VER5) {
> +		dev_err(&client->dev,
> +			"OV9655 not detected, wrong version 0x%02x\n",
> +			(unsigned) data);
> +		return -ENODEV;
> +	}
> +
> +	ov9655_power_off(ov9655);
> +
> +	dev_info(&client->dev, "OV9655 detected at address 0x%02x\n",
> +		 client->addr);
> +
> +	return ret;
> +}
> +
> +static int ov9655_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
> +{
> +	struct v4l2_mbus_framefmt *format;
> +	struct v4l2_rect *crop;
> +
> +	crop = v4l2_subdev_get_try_crop(fh, 0);
> +	crop->left = OV9655_COLUMN_START_DEF;
> +	crop->top = OV9655_ROW_START_DEF;
> +	crop->width = OV9655_WINDOW_WIDTH_DEF;
> +	crop->height = OV9655_WINDOW_HEIGHT_DEF;
> +
> +	format = v4l2_subdev_get_try_format(fh, 0);
> +
> +	format->code = OV9655_FORMAT;
> +
> +	format->width = OV9655_WINDOW_WIDTH_DEF;
> +	format->height = OV9655_WINDOW_HEIGHT_DEF;
> +	format->field = V4L2_FIELD_NONE;
> +	format->colorspace = V4L2_COLORSPACE_SRGB;
> +
> +	return ov9655_set_power(subdev, 1);
> +}
> +
> +static int ov9655_close(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
> +{
> +	return ov9655_set_power(subdev, 0);
> +}
> +
> +static struct v4l2_subdev_core_ops ov9655_subdev_core_ops = {
> +	.s_power        = ov9655_set_power,
> +};
> +
> +static struct v4l2_subdev_video_ops ov9655_subdev_video_ops = {
> +	.s_stream       = ov9655_s_stream,
> +};
> +
> +static struct v4l2_subdev_pad_ops ov9655_subdev_pad_ops = {
> +	.enum_mbus_code = ov9655_enum_mbus_code,
> +	.enum_frame_size = ov9655_enum_frame_size,
> +	.get_fmt = ov9655_get_format,
> +	.set_fmt = ov9655_set_format,
> +	.get_crop = ov9655_get_crop,
> +	.set_crop = ov9655_set_crop,
> +};
> +
> +static struct v4l2_subdev_ops ov9655_subdev_ops = {
> +	.core   = &ov9655_subdev_core_ops,
> +	.video  = &ov9655_subdev_video_ops,
> +	.pad    = &ov9655_subdev_pad_ops,
> +};
> +
> +static const struct v4l2_subdev_internal_ops ov9655_subdev_internal_ops = {
> +	.registered = ov9655_registered,
> +	.open = ov9655_open,
> +	.close = ov9655_close,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * Driver initialization and probing
> + */
> +
> +static int ov9655_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *did)
> +{
> +	struct ov9655_platform_data *pdata = client->dev.platform_data;
> +	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
> +	struct ov9655 *ov9655;
> +	unsigned int i;
> +	int ret;
> +
> +	if (pdata == NULL) {
> +		dev_err(&client->dev, "No platform data\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA)) {
> +		dev_warn(&client->dev,
> +			"I2C-Adapter doesn't support I2C_FUNC_SMBUS_WORD\n");
> +		return -EIO;
> +	}
> +
> +	ov9655 = devm_kzalloc(&client->dev, sizeof(*ov9655), GFP_KERNEL);
> +	if (ov9655 == NULL)
> +		return -ENOMEM;
> +
> +	ov9655->pdata = pdata;
> +	ov9655->reset = -1;
> +
> +	ov9655->vdd = devm_regulator_get(&client->dev, "vaux3");
> +
> +	if (IS_ERR(ov9655->vdd)) {
> +		dev_err(&client->dev, "Unable to get regulator\n");
> +		return -ENODEV;
> +	}
> +
> +	v4l2_ctrl_handler_init(&ov9655->ctrls, ARRAY_SIZE(ov9655_ctrls) + 6);
> +
> +	/* register custom controls */
> +	v4l2_ctrl_new_std(&ov9655->ctrls, &ov9655_ctrl_ops,
> +			  V4L2_CID_EXPOSURE, OV9655_SHUTTER_WIDTH_MIN,
> +			  OV9655_SHUTTER_WIDTH_MAX, 1,
> +			  OV9655_SHUTTER_WIDTH_DEF);
> +	v4l2_ctrl_new_std(&ov9655->ctrls, &ov9655_ctrl_ops,
> +			  V4L2_CID_GAIN, OV9655_GLOBAL_GAIN_MIN,
> +			  OV9655_GLOBAL_GAIN_MAX, 1, OV9655_GLOBAL_GAIN_DEF);
> +	v4l2_ctrl_new_std(&ov9655->ctrls, &ov9655_ctrl_ops,
> +			  V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_new_std(&ov9655->ctrls, &ov9655_ctrl_ops,
> +			  V4L2_CID_VFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_new_std(&ov9655->ctrls, &ov9655_ctrl_ops,
> +			  V4L2_CID_PIXEL_RATE, CAMERA_TARGET_FREQ,
> +			  CAMERA_TARGET_FREQ, 1, CAMERA_TARGET_FREQ);
> +	v4l2_ctrl_new_std_menu_items(&ov9655->ctrls, &ov9655_ctrl_ops,
> +			  V4L2_CID_TEST_PATTERN,
> +			  ARRAY_SIZE(ov9655_test_pattern_menu) - 1, 0,
> +			  0, ov9655_test_pattern_menu);
> +
> +	for (i = 0; i < ARRAY_SIZE(ov9655_ctrls); ++i)
> +		v4l2_ctrl_new_custom(&ov9655->ctrls, &ov9655_ctrls[i], NULL);
> +
> +	ov9655->subdev.ctrl_handler = &ov9655->ctrls;
> +
> +	if (ov9655->ctrls.error) {
> +		dev_err(&client->dev, "control initialization error %d\n",
> +			ov9655->ctrls.error);
> +		ret = ov9655->ctrls.error;
> +		goto done;
> +	}
> +
> +	ov9655->blc_auto = v4l2_ctrl_find(&ov9655->ctrls, V4L2_CID_BLC_AUTO);
> +	ov9655->blc_offset = v4l2_ctrl_find(&ov9655->ctrls,
> +					     V4L2_CID_BLC_DIGITAL_OFFSET);
> +
> +	mutex_init(&ov9655->power_lock);
> +	v4l2_i2c_subdev_init(&ov9655->subdev, client, &ov9655_subdev_ops);
> +	ov9655->subdev.internal_ops = &ov9655_subdev_internal_ops;
> +
> +	ov9655->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_init(&ov9655->subdev.entity, 1, &ov9655->pad, 0);
> +	if (ret < 0)
> +		goto done;
> +
> +	ov9655->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	ov9655->crop.width = OV9655_WINDOW_WIDTH_DEF;
> +	ov9655->crop.height = OV9655_WINDOW_HEIGHT_DEF;
> +	ov9655->crop.left = OV9655_COLUMN_START_DEF;
> +	ov9655->crop.top = OV9655_ROW_START_DEF;
> +
> +	ov9655->format.code = OV9655_FORMAT;
> +
> +	ov9655->format.width = OV9655_WINDOW_WIDTH_DEF;
> +	ov9655->format.height = OV9655_WINDOW_HEIGHT_DEF;
> +	ov9655->format.field = V4L2_FIELD_NONE;
> +	ov9655->format.colorspace = V4L2_COLORSPACE_SRGB;
> +
> +	if (pdata->reset != -1) {
> +		ret = devm_gpio_request_one(&client->dev, pdata->reset,
> +					GPIOF_OUT_INIT_LOW, "ov9655_rst");
> +		if (ret < 0)
> +			goto done;
> +
> +		ov9655->reset = pdata->reset;
> +	}
> +
> +	ov9655->clk = devm_clk_get(&client->dev, NULL);
> +	if (IS_ERR(ov9655->clk))
> +		return PTR_ERR(ov9655->clk);
> +
> +	clk_set_rate(ov9655->clk, CAMERA_EXT_FREQ /* pdata->ext_freq */);
> +
> +	ret = 0;
> +
> +done:
> +	if (ret < 0) {
> +		v4l2_ctrl_handler_free(&ov9655->ctrls);
> +		media_entity_cleanup(&ov9655->subdev.entity);
> +	}
> +
> +	return ret;
> +}
> +
> +static int ov9655_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> +	struct ov9655 *ov9655 = to_ov9655(subdev);
> +
> +	v4l2_ctrl_handler_free(&ov9655->ctrls);
> +	v4l2_device_unregister_subdev(subdev);
> +	media_entity_cleanup(&subdev->entity);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id ov9655_id[] = {
> +	{ "ov9655", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, ov9655_id);
> +
> +static struct i2c_driver ov9655_i2c_driver = {
> +	.driver = {
> +		.name = "ov9655",
> +	},
> +	.probe          = ov9655_probe,
> +	.remove         = ov9655_remove,
> +	.id_table       = ov9655_id,
> +};
> +
> +module_i2c_driver(ov9655_i2c_driver);
> +
> +MODULE_DESCRIPTION("OmniVision OV9655 Camera driver");
> +MODULE_AUTHOR("H. Nikolaus Schaller <hns@goldelico.com>");
> +MODULE_LICENSE("GPL");
> diff --git a/include/media/ov9655.h b/include/media/ov9655.h
> new file mode 100644
> index 0000000..38c1253
> --- /dev/null
> +++ b/include/media/ov9655.h
> @@ -0,0 +1,17 @@
> +#ifndef __OV9655_H
> +#define __OV9655_H
> +
> +struct v4l2_subdev;
> +
> +/*
> + * struct ov9655_platform_data - OV9655 platform data
> + * @reset: Chip reset GPIO (set to -1 if not used)
> + * @ext_freq: Input clock frequency - not used OV9655 is running at fixed 24 MHz

If it is not used, then why is it here? Just remove it.

> + */
> +struct ov9655_platform_data {
> +	int reset;
> +	int ext_freq;
> +};
> +
> +#endif
> +
> 

Regards,

	Hans

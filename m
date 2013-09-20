Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab3ITV6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 17:58:55 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45248 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753981Ab3ITV6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 17:58:53 -0400
Date: Sat, 21 Sep 2013 00:58:18 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Daniel Jeong <gshark.jeong@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] media: i2c: add driver for dual LED Flash, lm3560.
Message-ID: <20130920215817.GA3368@valkosipuli.retiisi.org.uk>
References: <1378885531-20599-1-git-send-email-gshark.jeong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378885531-20599-1-git-send-email-gshark.jeong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

A few more comments.

On Wed, Sep 11, 2013 at 04:45:31PM +0900, Daniel Jeong wrote:
...
> +struct lm3560_flash {
> +	struct lm3560_platform_data *pdata;
> +	struct regmap *regmap;
> +	struct mutex power_lock;
> +	int power_count;
> +
> +	enum v4l2_flash_led_mode led_mode;
> +	u8 fault;

If you have common properties, you can use v4l2_ctrl_add_handler() to get a
reference of a contro (or controls) from another handler. No tricks needed.

I thik it'd still make sense to 

> +	/* LED1 */
> +	struct v4l2_ctrl_handler ctrls_led1;
> +	struct v4l2_subdev subdev_led1;
> +	/* LED2 */
> +	struct v4l2_ctrl_handler ctrls_led2;
> +	struct v4l2_subdev subdev_led2;
> +};
> +
> +/* i2c access */
> +static int lm3560_read(struct lm3560_flash *flash, unsigned int reg)
> +{
> +	int rval;
> +	unsigned int reg_val;
> +
> +	rval = regmap_read(flash->regmap, reg, &reg_val);
> +	if (rval < 0)
> +		return rval;
> +	return reg_val & 0xFF;

What does lm3650_read() actually do for you?

> +}
> +
> +static int lm3560_update(struct lm3560_flash *flash,
> +			unsigned int reg, unsigned int mask, unsigned int data)
> +{
> +	return regmap_update_bits(flash->regmap, reg, mask, data);
> +}
> +
> +/* enable mode control */
> +static int lm3560_mode_ctrl(struct lm3560_flash *flash)
> +{
> +	int rval = 0;
> +
> +	rval = lm3560_update(flash, REG_FLASH_TOUT,
> +				      PEAK_I_MASK, flash->pdata->peak);
> +	if (rval < 0)
> +		return rval;
> +
> +	switch (flash->led_mode) {
> +	case V4L2_FLASH_LED_MODE_NONE:
> +		rval = lm3560_update(flash,
> +				     REG_ENABLE, ENABLE_MODE_MASK, MODE_SHDN);
> +		break;
> +	case V4L2_FLASH_LED_MODE_TORCH:
> +		rval = lm3560_update(flash,
> +				     REG_ENABLE, ENABLE_MODE_MASK, MODE_TORCH);
> +		break;
> +	case V4L2_FLASH_LED_MODE_FLASH:
> +		rval = lm3560_update(flash,
> +				     REG_ENABLE, ENABLE_MODE_MASK, MODE_FLASH);
> +		break;
> +	}
> +
> +	return rval;
> +}
> +
> +/* led1/2  enable/disable */
> +static int lm3560_enable_ctrl(struct lm3560_flash *flash,
> +			      enum lm3560_led_id led_no, bool on)
f> +{
> +	int rval = 0;
> +
> +	if (led_no == LM3560_LED1) {
> +		if (on == true)
> +			rval = lm3560_update(flash, REG_ENABLE,
> +					     LED1_ENABLE_MASK, LED1_ENABLE);
> +		else
> +			rval = lm3560_update(flash,
> +					     REG_ENABLE, LED1_ENABLE_MASK, 0);
> +	} else {
> +		if (on == true)
> +			rval = lm3560_update(flash, REG_ENABLE,
> +					     LED2_ENABLE_MASK, LED2_ENABLE);
> +		else
> +			rval = lm3560_update(flash,
> +					     REG_ENABLE, LED2_ENABLE_MASK, 0);
> +	}
> +	return rval;
> +}
> +
> +/* torch1/2 brightness control */
> +static int lm3560_torch_brt_ctrl(struct lm3560_flash *flash,
> +				 enum lm3560_led_id led_no, unsigned int brt)
> +{
> +	int rval;
> +	u8 br_bits;
> +
> +	if (brt < LM3560_TORCH_BRT_MIN) {
> +		rval = lm3560_enable_ctrl(flash, led_no, false);
> +		goto out;
> +	} else {
> +		rval = lm3560_enable_ctrl(flash, led_no, true);
> +	}
> +
> +	br_bits = LM3560_TORCH_BRT_uA_TO_REG(brt);
> +	if (led_no == LM3560_LED1) {
> +		rval = lm3560_update(flash, REG_TORCH_BR,
> +				     TORCH1_BR_MASK, TORCH1_BR_DATA(br_bits));
> +		if (rval < 0)
> +			goto out;
> +	} else {
> +		rval = lm3560_update(flash, REG_TORCH_BR,
> +				     TORCH2_BR_MASK, TORCH2_BR_DATA(br_bits));
> +		if (rval < 0)
> +			goto out;
> +	}
> +out:
> +	return rval;
> +}
> +
> +/* flash1/2 brightness control */
> +static int lm3560_flash_brt_ctrl(struct lm3560_flash *flash,
> +				 enum lm3560_led_id led_no, unsigned int brt)
> +{
> +	int rval;
> +	u8 br_bits;
> +
> +	if (brt < LM3560_FLASH_BRT_MIN) {
> +		rval = lm3560_enable_ctrl(flash, led_no, false);
> +		goto out;
> +	} else {
> +		rval = lm3560_enable_ctrl(flash, led_no, true);
> +	}
> +
> +	br_bits = LM3560_FLASH_BRT_uA_TO_REG(brt);
> +	if (led_no == LM3560_LED1) {
> +		rval = lm3560_update(flash, REG_FLASH_BR,
> +				     FLASH1_BR_MASK, FLASH1_BR_DATA(br_bits));
> +		if (rval < 0)
> +			goto out;
> +	} else {
> +		rval = lm3560_update(flash, REG_FLASH_BR,
> +				     FLASH2_BR_MASK, FLASH2_BR_DATA(br_bits));
> +		if (rval < 0)
> +			goto out;
> +	}
> +out:
> +	return rval;
> +}
> +
> +/* LED1 - V4L2 controls  */
> +static int lm3560_get_ctrl(struct v4l2_ctrl *ctrl, enum lm3560_led_id led_no)
> +{
> +	int rval;

Return values and temporary variables are usually good to define as last.

> +	s32 fault = 0;

If you want to keep the if below, you can move fault inside.

> +	struct lm3560_flash *flash = (led_no == LM3560_LED1) ?
> +	    container_of(ctrl->handler, struct lm3560_flash, ctrls_led1) :
> +	    container_of(ctrl->handler, struct lm3560_flash, ctrls_led2);
> +
> +	if (ctrl->id == V4L2_CID_FLASH_FAULT) {
> +		rval = lm3560_read(flash, REG_FLAG);
> +		if (rval < 0)
> +			return rval;
> +		flash->fault |= rval;
> +		if (rval & FAULT_SHORT_CIRCUIT)
> +			fault |= V4L2_FLASH_FAULT_SHORT_CIRCUIT;
> +		if (rval & FAULT_OVERTEMP)
> +			fault |= V4L2_FLASH_FAULT_OVER_TEMPERATURE;
> +		if (rval & FAULT_TIMEOUT)
> +			fault |= V4L2_FLASH_FAULT_TIMEOUT;
> +		flash->fault = 0;

What do you need flash->fault for?

> +
> +		ctrl->cur.val = fault;
> +	}
> +	return 0;

If you want to check for the validit5 of the id you should return -EINVAL if
there's no match.

> +}
> +
> +static int lm3560_set_ctrl(struct v4l2_ctrl *ctrl, enum lm3560_led_id led_no)
> +{
> +	int rval = 0;
> +	u8 tout_bits;
> +	struct lm3560_flash *flash = (led_no == LM3560_LED1) ?
> +	    container_of(ctrl->handler, struct lm3560_flash, ctrls_led1) :
> +	    container_of(ctrl->handler, struct lm3560_flash, ctrls_led2);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_FLASH_LED_MODE:
> +		flash->led_mode = ctrl->val;
> +		if (flash->led_mode != V4L2_FLASH_LED_MODE_FLASH)
> +			rval = lm3560_mode_ctrl(flash);
> +		break;
> +
> +	case V4L2_CID_FLASH_STROBE_SOURCE:
> +		rval = lm3560_update(flash, REG_CONFIG1,
> +				     STROBE_EN_MASK, STROBE_EN_DATA(ctrl->val));
> +		if (rval < 0)
> +			goto err_out;
> +		break;
> +
> +	case V4L2_CID_FLASH_STROBE:
> +		if (flash->led_mode != V4L2_FLASH_LED_MODE_FLASH)
> +			return -EBUSY;
> +		flash->led_mode = V4L2_FLASH_LED_MODE_FLASH;
> +		rval = lm3560_mode_ctrl(flash);
> +		break;
> +
> +	case V4L2_CID_FLASH_STROBE_STOP:
> +		if (flash->led_mode != V4L2_FLASH_LED_MODE_FLASH)
> +			return -EBUSY;
> +		flash->led_mode = V4L2_FLASH_LED_MODE_NONE;
> +		rval = lm3560_mode_ctrl(flash);
> +		break;
> +
> +	case V4L2_CID_FLASH_TIMEOUT:
> +		tout_bits = LM3560_FLASH_TOUT_ms_TO_REG(ctrl->val);
> +		rval = lm3560_update(flash, REG_FLASH_TOUT,
> +				     FLASH_TOUT_MASK, tout_bits);
> +		break;
> +
> +	case V4L2_CID_FLASH_INTENSITY:
> +		rval = lm3560_flash_brt_ctrl(flash, led_no, ctrl->val);
> +		break;
> +
> +	case V4L2_CID_FLASH_TORCH_INTENSITY:
> +		rval = lm3560_torch_brt_ctrl(flash, led_no, ctrl->val);
> +		break;
> +	}
> +	if (rval < 0)
> +		goto err_out;
> +
> +	rval = lm3560_read(flash, REG_FLAG);
> +	if (rval < 0)
> +		goto err_out;
> +	flash->fault |= rval;
> +	return 0;
> +err_out:
> +	return rval;
> +}
> +
> +/* led 1 */
> +static int lm3560_led1_get_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	return lm3560_get_ctrl(ctrl, LM3560_LED1);
> +}
> +
> +static int lm3560_led1_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	return lm3560_set_ctrl(ctrl, LM3560_LED1);
> +}
> +
> +static const struct v4l2_ctrl_ops lm3560_led1_ctrl_ops = {
> +	.g_volatile_ctrl = lm3560_led1_get_ctrl,
> +	.s_ctrl = lm3560_led1_set_ctrl,
> +};
> +
> +/* led 2 */
> +static int lm3560_led2_get_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	return lm3560_get_ctrl(ctrl, LM3560_LED2);
> +}
> +
> +static int lm3560_led2_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	return lm3560_set_ctrl(ctrl, LM3560_LED2);
> +}
> +
> +static const struct v4l2_ctrl_ops lm3560_led2_ctrl_ops = {
> +	.g_volatile_ctrl = lm3560_led2_get_ctrl,
> +	.s_ctrl = lm3560_led2_set_ctrl,
> +};
> +
> +static int lm3560_init_controls(struct lm3560_flash *flash,
> +				enum lm3560_led_id led_no)
> +{
> +	u32 max_flash_brt;
> +	u32 max_torch_brt;
> +	struct v4l2_ctrl *fault;
> +	struct v4l2_ctrl_handler *hdl;
> +	const struct v4l2_ctrl_ops *ops;
> +
> +	if (led_no == LM3560_LED1) {
> +		hdl = &flash->ctrls_led1;
> +		ops = &lm3560_led1_ctrl_ops;
> +		max_torch_brt = flash->pdata->max_torch1_brt;
> +		max_flash_brt = flash->pdata->max_flash1_brt;
> +	} else {
> +		hdl = &flash->ctrls_led2;
> +		ops = &lm3560_led2_ctrl_ops;
> +		max_torch_brt = flash->pdata->max_torch2_brt;
> +		max_flash_brt = flash->pdata->max_flash2_brt;
> +	}
> +
> +	v4l2_ctrl_handler_init(hdl, 8);
> +	/* flash mode */
> +	v4l2_ctrl_new_std_menu(hdl, ops, V4L2_CID_FLASH_LED_MODE,
> +			       V4L2_FLASH_LED_MODE_TORCH, ~0x7,
> +			       V4L2_FLASH_LED_MODE_NONE);
> +	flash->led_mode = V4L2_FLASH_LED_MODE_NONE;
> +
> +	/* flash source */
> +	v4l2_ctrl_new_std_menu(hdl, ops, V4L2_CID_FLASH_STROBE_SOURCE,
> +			       0x1, ~0x3, V4L2_FLASH_STROBE_SOURCE_SOFTWARE);
> +
> +	/* flash strobe */
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FLASH_STROBE, 0, 0, 0, 0);
> +	/* flash strobe stop */
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FLASH_STROBE_STOP, 0, 0, 0, 0);
> +
> +	/* flash strobe timeout */
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FLASH_TIMEOUT,
> +			  LM3560_FLASH_TOUT_MIN,
> +			  flash->pdata->max_flash_timeout,
> +			  LM3560_FLASH_TOUT_STEP,
> +			  flash->pdata->max_flash_timeout);
> +
> +	/* flash brt */
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FLASH_INTENSITY, 0, max_flash_brt,
> +			  LM3560_FLASH_BRT_STEP, max_flash_brt);
> +
> +	/* torch brt */
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FLASH_TORCH_INTENSITY, 0,
> +			  max_torch_brt, LM3560_TORCH_BRT_STEP, max_torch_brt);
> +
> +	/* fault */
> +	fault = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FLASH_FAULT, 0,
> +				  V4L2_FLASH_FAULT_OVER_VOLTAGE
> +				  | V4L2_FLASH_FAULT_OVER_TEMPERATURE
> +				  | V4L2_FLASH_FAULT_SHORT_CIRCUIT
> +				  | V4L2_FLASH_FAULT_TIMEOUT, 0, 0);
> +	if (fault != NULL)
> +		fault->flags |= V4L2_CTRL_FLAG_VOLATILE;
> +
> +	if (hdl->error)
> +		return hdl->error;
> +
> +	if (led_no == LM3560_LED1)
> +		flash->subdev_led1.ctrl_handler = hdl;
> +	else
> +		flash->subdev_led2.ctrl_handler = hdl;
> +
> +	return 0;
> +}
> +
> +/*V4L2 subdev operations */
> +static int lm3560_init_device(struct lm3560_flash *flash,
> +			      enum lm3560_led_id led_no)
> +{
> +	int rval;
> +
> +	/* Reset faults */
> +	rval = lm3560_read(flash, REG_FLAG);
> +	if (rval < 0)
> +		return rval;
> +	/* output disable */
> +	flash->led_mode = V4L2_FLASH_LED_MODE_NONE;
> +	rval = lm3560_mode_ctrl(flash);
> +	return rval;
> +}
> +
> +static int __lm3560_set_power(struct lm3560_flash *flash, int on,
> +			      enum lm3560_led_id led_no)
> +{
> +	int rval = 0;
> +	struct v4l2_subdev *sd = (led_no == LM3560_LED1) ?
> +	    &flash->subdev_led1 : &flash->subdev_led2;
> +
> +	if (!on) {
> +		flash->led_mode = V4L2_FLASH_LED_MODE_NONE;
> +		rval = lm3560_mode_ctrl(flash);
> +		if (rval < 0)
> +			return rval;
> +	}
> +
> +	if (flash->pdata->set_power != NULL) {
> +		rval = flash->pdata->set_power(sd, on, led_no);
> +		if (rval < 0)
> +			return rval;
> +	}
> +
> +	if (on) {
> +		rval = lm3560_init_device(flash, led_no);
> +		if ((rval < 0) && (flash->pdata->set_power != NULL))
> +			flash->pdata->set_power(sd, 0, led_no);
> +	}
> +	return rval;
> +}
> +
> +static int lm3560_set_power(struct v4l2_subdev *subdev,
> +			    int on, enum lm3560_led_id led_no)
> +{
> +	int rval = 0;
> +	struct lm3560_flash *flash = (led_no == LM3560_LED1) ?
> +	    to_lm3560_led_flash(subdev, 1) : to_lm3560_led_flash(subdev, 2);
> +
> +	mutex_lock(&flash->power_lock);
> +	if (flash->power_count == !on) {
> +		rval = __lm3560_set_power(flash, !!on, led_no);
> +		if (rval < 0)
> +			goto out;
> +	}
> +	flash->power_count += on ? 1 : -1;
> +	WARN_ON(flash->power_count < 0);
> +out:
> +	mutex_unlock(&flash->power_lock);
> +	return rval;
> +}
> +
> +/* led 1 */
> +static int lm3560_led1_set_power(struct v4l2_subdev *subdev, int on)
> +{
> +	return lm3560_set_power(subdev, on, LM3560_LED1);
> +}
> +
> +static int lm3560_led1_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	return lm3560_set_power(sd, 1, LM3560_LED1);
> +}
> +
> +static int lm3560_led1_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	return lm3560_set_power(sd, 0, LM3560_LED1);
> +}
> +
> +static const struct v4l2_subdev_core_ops lm3560_led1_core_ops = {
> +	.s_power = lm3560_led1_set_power,
> +};
> +
> +static const struct v4l2_subdev_ops lm3560_led1_ops = {
> +	.core = &lm3560_led1_core_ops,
> +};
> +
> +static const struct v4l2_subdev_internal_ops lm3560_led1_internal_ops = {
> +	.open = lm3560_led1_open,
> +	.close = lm3560_led1_close,
> +};
> +
> +/* led 2 */
> +static int lm3560_led2_set_power(struct v4l2_subdev *subdev, int on)
> +{
> +	return lm3560_set_power(subdev, on, LM3560_LED2);
> +}
> +
> +static int lm3560_led2_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	return lm3560_set_power(sd, 1, LM3560_LED2);
> +}
> +
> +static int lm3560_led2_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	return lm3560_set_power(sd, 0, LM3560_LED2);
> +}
> +
> +static const struct v4l2_subdev_core_ops lm3560_led2_core_ops = {
> +	.s_power = lm3560_led2_set_power,
> +};
> +
> +static const struct v4l2_subdev_ops lm3560_led2_ops = {
> +	.core = &lm3560_led2_core_ops,
> +};
> +
> +static const struct v4l2_subdev_internal_ops lm3560_led2_internal_ops = {
> +	.open = lm3560_led2_open,
> +	.close = lm3560_led2_close,
> +};
> +
> +#ifdef CONFIG_PM
> +static int lm3560_suspend(struct device *dev)
> +{
> +	int rval;
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> +	struct lm3560_flash *flash1 = to_lm3560_led_flash(subdev, 1);
> +	struct lm3560_flash *flash2 = to_lm3560_led_flash(subdev, 2);
> +
> +	if (flash1->power_count == 0)
> +		return 0;
> +	rval = __lm3560_set_power(flash1, 0, LM3560_LED1);
> +	if (rval < 0)
> +		return rval;
> +	return __lm3560_set_power(flash2, 0, LM3560_LED2);
> +}
> +
> +static int lm3560_resume(struct device *dev)
> +{
> +	int rval;
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> +	struct lm3560_flash *flash1 = to_lm3560_led_flash(subdev, 1);
> +	struct lm3560_flash *flash2 = to_lm3560_led_flash(subdev, 2);
> +
> +	if (flash1->power_count == 0)
> +		return 0;
> +	rval = __lm3560_set_power(flash1, 1, LM3560_LED1);
> +	if (rval < 0)
> +		return rval;
> +	return __lm3560_set_power(flash2, 1, LM3560_LED2);
> +}
> +#else
> +
> +#define lm3560_suspend	NULL
> +#define lm3560_resume	NULL
> +
> +#endif
> +
> +static const struct regmap_config lm3560_regmap = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.max_register = 0xFF,
> +};
> +
> +static int lm3560_probe(struct i2c_client *client,
> +			const struct i2c_device_id *devid)
> +{
> +	int rval;
> +	struct lm3560_flash *flash;
> +	flash = devm_kzalloc(&client->dev, sizeof(*flash), GFP_KERNEL);
> +	if (flash == NULL)
> +		return -ENOMEM;
> +
> +	flash->regmap = devm_regmap_init_i2c(client, &lm3560_regmap);
> +	if (IS_ERR(flash->regmap)) {
> +		rval = PTR_ERR(flash->regmap);
> +		return rval;
> +	}
> +
> +	/* if there is no platform data, use chip default value */
> +	if (client->dev.platform_data == NULL) {
> +		flash->pdata =
> +		    kzalloc(sizeof(struct lm3560_platform_data), GFP_KERNEL);
> +		if (flash->pdata == NULL)
> +			return -ENODEV;
> +		flash->pdata->set_power = NULL;
> +		flash->pdata->peak = LM3560_PEAK_3600mA;
> +		flash->pdata->max_flash_timeout = LM3560_FLASH_TOUT_MAX;
> +		/* led 1 */
> +		flash->pdata->max_flash1_brt = LM3560_FLASH_BRT_MAX;
> +		flash->pdata->max_torch1_brt = LM3560_TORCH_BRT_MAX;
> +		/* led 2 */
> +		flash->pdata->max_flash2_brt = LM3560_FLASH_BRT_MAX;
> +		flash->pdata->max_torch2_brt = LM3560_TORCH_BRT_MAX;
> +	} else {
> +		flash->pdata = dev_get_platdata(&client->dev);
> +	}
> +
> +	mutex_init(&flash->power_lock);
> +
> +	/* led 1 */
> +	v4l2_i2c_subdev_init(&flash->subdev_led1, client, &lm3560_led1_ops);

You have two subdevs but just a single device with a common set of
resources.. How about using a common mutex for both? (See e.g. how the
smiapp driver does it.)

> +	flash->subdev_led1.internal_ops = &lm3560_led1_internal_ops;
> +	flash->subdev_led1.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	strcpy(flash->subdev_led1.name, "lm3560-led1");
> +	rval = lm3560_init_controls(flash, LM3560_LED1);
> +	if (rval < 0)
> +		goto err_out_led1;
> +	rval = media_entity_init(&flash->subdev_led1.entity, 0, NULL, 0);
> +	if (rval < 0)
> +		goto err_out_led1;
> +	flash->subdev_led1.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
> +
> +	/* led 2 */
> +	v4l2_i2c_subdev_init(&flash->subdev_led2, client, &lm3560_led2_ops);
> +	flash->subdev_led2.internal_ops = &lm3560_led2_internal_ops;
> +	flash->subdev_led2.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	strcpy(flash->subdev_led2.name, "lm3560-led2");
> +	rval = lm3560_init_controls(flash, LM3560_LED2);
> +	if (rval)
> +		goto err_out_led2;
> +	rval = media_entity_init(&flash->subdev_led2.entity, 0, NULL, 0);
> +	if (rval < 0)
> +		goto err_out_led2;
> +	flash->subdev_led2.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
> +
> +	return rval;
> +
> +err_out_led2:
> +	v4l2_ctrl_handler_free(&flash->ctrls_led2);
> +err_out_led1:
> +	v4l2_ctrl_handler_free(&flash->ctrls_led1);
> +	return rval;
> +}
> +
> +static int lm3560_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> +	struct lm3560_flash *flash1 = to_lm3560_led_flash(subdev, 1);
> +	struct lm3560_flash *flash2 = to_lm3560_led_flash(subdev, 2);
> +
> +	/* led 2 */
> +	v4l2_device_unregister_subdev(&flash2->subdev_led2);
> +	v4l2_ctrl_handler_free(&flash2->ctrls_led2);
> +	media_entity_cleanup(&flash2->subdev_led2.entity);
> +
> +	/* led 1 */
> +	v4l2_device_unregister_subdev(&flash1->subdev_led1);
> +	v4l2_ctrl_handler_free(&flash1->ctrls_led1);
> +	media_entity_cleanup(&flash1->subdev_led1.entity);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id lm3560_id_table[] = {
> +	{LM3560_NAME, 0},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, lm3560_id_table);
> +
> +static const struct dev_pm_ops lm3560_pm_ops = {
> +	.suspend = lm3560_suspend,
> +	.resume = lm3560_resume,
> +};
> +
> +static struct i2c_driver lm3560_i2c_driver = {
> +	.driver = {
> +		   .name = LM3560_NAME,
> +		   .pm = &lm3560_pm_ops,
> +		   },
> +	.probe = lm3560_probe,
> +	.remove = lm3560_remove,
> +	.id_table = lm3560_id_table,
> +};
> +
> +module_i2c_driver(lm3560_i2c_driver);
> +
> +MODULE_AUTHOR("Daniel Jeong <gshark.jeong@gmail.com>");
> +MODULE_AUTHOR("LDD MLP <ldd-mlp@list.ti.com>");
> +MODULE_DESCRIPTION("Texas Instruments LM3560 Dual LED flash driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/media/lm3560.h b/include/media/lm3560.h
> new file mode 100644
> index 0000000..824dbf4
> --- /dev/null
> +++ b/include/media/lm3560.h
> @@ -0,0 +1,103 @@
> +/*
> + * include/media/lm3560.h
> + *
> + * Copyright (C) 2013 Texas Instruments
> + *
> + * Contact: Daniel Jeong <gshark.jeong@gmail.com>
> + *          LDD-MLP <ldd-mlp@list.ti.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + *
> + */
> +
> +#ifndef __LM3560_H__
> +#define __LM3560_H__
> +
> +#include <media/v4l2-subdev.h>
> +
> +#define LM3560_NAME				"lm3560"
> +#define LM3560_I2C_ADDR			(0x53)
> +
> +/*  FLASH Brightness
> + *	min 62500uA, step 62500uA, max 1000000uA
> + */
> +#define LM3560_FLASH_BRT_MIN 62500
> +#define LM3560_FLASH_BRT_STEP 62500
> +#define LM3560_FLASH_BRT_MAX 1000000
> +#define LM3560_FLASH_BRT_uA_TO_REG(a)	\
> +	((a) < LM3560_FLASH_BRT_MIN ? 0 :	\
> +	 (((a) - LM3560_FLASH_BRT_MIN) / LM3560_FLASH_BRT_STEP))
> +#define LM3560_FLASH_BRT_REG_TO_uA(a)		\
> +	((a) * LM3560_FLASH_BRT_STEP + LM3560_FLASH_BRT_MIN)
> +
> +/*  FLASH TIMEOUT DURATION
> + *	min 32ms, step 32ms, max 1024ms
> + */
> +#define LM3560_FLASH_TOUT_MIN 32
> +#define LM3560_FLASH_TOUT_STEP 32
> +#define LM3560_FLASH_TOUT_MAX 1024
> +#define LM3560_FLASH_TOUT_ms_TO_REG(a)	\
> +	((a) < LM3560_FLASH_TOUT_MIN ? 0 :	\
> +	 (((a) - LM3560_FLASH_TOUT_MIN) / LM3560_FLASH_TOUT_STEP))
> +#define LM3560_FLASH_TOUT_REG_TO_ms(a)		\
> +	((a) * LM3560_FLASH_TOUT_STEP + LM3560_FLASH_TOUT_MIN)
> +
> +/*  TORCH BRT
> + *	min 31250uA, step 31250uA, max 250000uA
> + */
> +#define LM3560_TORCH_BRT_MIN 31250
> +#define LM3560_TORCH_BRT_STEP 31250
> +#define LM3560_TORCH_BRT_MAX 250000
> +#define LM3560_TORCH_BRT_uA_TO_REG(a)	\
> +	((a) < LM3560_TORCH_BRT_MIN ? 0 :	\
> +	 (((a) - LM3560_TORCH_BRT_MIN) / LM3560_TORCH_BRT_STEP))
> +#define LM3560_TORCH_BRT_REG_TO_uA(a)		\
> +	((a) * LM3560_TORCH_BRT_STEP + LM3560_TORCH_BRT_MIN)
> +
> +enum lm3560_led_id {
> +	LM3560_LED1 = 0,
> +	LM3560_LED2
> +};
> +
> +enum lm3560_peak_current {
> +	LM3560_PEAK_1600mA = 0x00,
> +	LM3560_PEAK_2300mA = 0x20,
> +	LM3560_PEAK_3000mA = 0x40,
> +	LM3560_PEAK_3600mA = 0x60
> +};
> +
> +/*
> + * lm3560 platform data
> + *@peak : peak current 1.6, 2.3, 3.0, 3.6A
> + *@set_power : power callback.
> + *@max_flash_timeout : max flash time out(ms < 1024)
> + *@max_flash1_brt : max brightness led 1 flash mode(uA < 1000000uA)
> + *@max_torch1_brt : max brightness led 1 torch mode(uA < 250000uA)
> + *@max_flash2_brt : max brightness led 2 flash mode(uA < 1000000uA)
> + *@max_torch2_brt : max brightness led 2 torch mode(uA < 250000uA)
> + */
> +struct lm3560_platform_data {
> +	enum lm3560_peak_current peak;
> +	int (*set_power) (struct v4l2_subdev *sd, int on,
> +			  enum lm3560_led_id led_no);
> +
> +	u32 max_flash_timeout;
> +	u32 max_flash1_brt;
> +	u32 max_torch1_brt;
> +	u32 max_flash2_brt;
> +	u32 max_torch2_brt;
> +};
> +
> +#endif /* __LM3560_H__ */

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

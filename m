Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaA2PTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 10:19:34 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40613 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750936AbaA2PTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 10:19:33 -0500
Date: Wed, 29 Jan 2014 17:18:57 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Daniel Jeong <gshark.jeong@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFCv2,2/2] i2c: add new dual Flash driver,LM3646
Message-ID: <20140129151856.GC14729@valkosipuli.retiisi.org.uk>
References: <1390892158-5646-1-git-send-email-gshark.jeong@gmail.com>
 <1390892158-5646-2-git-send-email-gshark.jeong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390892158-5646-2-git-send-email-gshark.jeong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Thanks for the update. The driver is very nicely written in general btw. One
comment below.

On Tue, Jan 28, 2014 at 03:55:58PM +0900, Daniel Jeong wrote:
...
> +/*
> + * struct lm3646_flash
> + *
> + * @pdata: platform data
> + * @regmap: reg. map for i2c
> + * @lock: muxtex for serial access.
> + * @led_mode: V4L2 LED mode
> + * @ctrls_led: V4L2 contols
> + * @subdev_led: V4L2 subdev
> + */
> +struct lm3646_flash {
> +	struct device *dev;
> +	struct lm3646_platform_data *pdata;
> +	struct regmap *regmap;
> +
> +	enum v4l2_flash_led_mode led_mode;
> +	struct v4l2_ctrl_handler ctrls_led;
> +	struct v4l2_subdev subdev_led;
> +};
> +
> +#define to_lm3646_flash(_ctrl)	\
> +	container_of(_ctrl->handler, struct lm3646_flash, ctrls_led)
> +
> +/* enable mode control */
> +static int lm3646_mode_ctrl(struct lm3646_flash *flash)
> +{
> +	int rval = -EINVAL;
> +
> +	switch (flash->led_mode) {
> +	case V4L2_FLASH_LED_MODE_NONE:
> +		rval = regmap_update_bits(flash->regmap,
> +					  REG_ENABLE, MASK_ENABLE, MODE_SHDN);
> +		break;
> +	case V4L2_FLASH_LED_MODE_TORCH:
> +		rval = regmap_update_bits(flash->regmap,
> +					  REG_ENABLE, MASK_ENABLE, MODE_TORCH);
> +		break;
> +	case V4L2_FLASH_LED_MODE_FLASH:
> +		rval = regmap_update_bits(flash->regmap,
> +					  REG_ENABLE, MASK_ENABLE, MODE_FLASH);
> +		break;
> +	}
> +	return rval;
> +}
> +
> +/* V4L2 controls  */
> +static int lm3646_get_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct lm3646_flash *flash = to_lm3646_flash(ctrl);
> +	int rval = -EINVAL;
> +
> +	if (ctrl->id == V4L2_CID_FLASH_FAULT) {
> +		s32 fault = 0;
> +		unsigned int reg_val;
> +		rval = regmap_read(flash->regmap, REG_FLAG, &reg_val);
> +		if (rval < 0)
> +			return rval;
> +
> +		if (reg_val & FAULT_TIMEOUT)
> +			fault |= V4L2_FLASH_FAULT_TIMEOUT;
> +		if (reg_val & FAULT_SHORT_CIRCUIT)
> +			fault |= V4L2_FLASH_FAULT_SHORT_CIRCUIT;
> +		if (reg_val & FAULT_UVLO)
> +			fault |= V4L2_FLASH_FAULT_UVLO;
> +		if (reg_val & FAULT_IVFM)
> +			fault |= V4L2_FLASH_FAULT_IVFM;
> +		if (reg_val & FAULT_OCP)
> +			fault |= V4L2_FLASH_FAULT_OVER_CURRENT;
> +		if (reg_val & FAULT_OVERTEMP)
> +			fault |= V4L2_FLASH_FAULT_OVER_TEMPERATURE;
> +		if (reg_val & FAULT_NTC_TRIP)
> +			fault |= V4L2_FLASH_FAULT_NTC_TRIP;
> +		if (reg_val & FAULT_OVP)
> +			fault |= V4L2_FLASH_FAULT_OVER_VOLTAGE;
> +
> +		ctrl->cur.val = fault;
> +	}
> +
> +	return rval;
> +}
> +
> +static int lm3646_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct lm3646_flash *flash = to_lm3646_flash(ctrl);
> +	u8 bval;
> +	int rval = -EINVAL;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_FLASH_LED_MODE:
> +		flash->led_mode = ctrl->val;

Do you need to keep led_mode in struct lm3646_flash? Could you access the
value in struct v4l2_ctrl directly? (See smiapp-core.c for an example.)

> +		if (flash->led_mode != V4L2_FLASH_LED_MODE_FLASH)
> +			rval = lm3646_mode_ctrl(flash);
> +		break;
> +
> +	case V4L2_CID_FLASH_STROBE_SOURCE:
> +		rval = regmap_update_bits(flash->regmap,
> +					  REG_STROBE_SRC, MASK_STROBE_SRC,
> +					  (ctrl->val) << 7);
> +		break;
> +
> +	case V4L2_CID_FLASH_STROBE:
> +		if (flash->led_mode != V4L2_FLASH_LED_MODE_FLASH)
> +			return rval;
> +		rval = lm3646_mode_ctrl(flash);
> +		break;
> +
> +	case V4L2_CID_FLASH_STROBE_STOP:
> +		if (flash->led_mode != V4L2_FLASH_LED_MODE_FLASH)
> +			return rval;
> +		flash->led_mode = V4L2_FLASH_LED_MODE_NONE;
> +		rval = lm3646_mode_ctrl(flash);
> +		break;
> +
> +	case V4L2_CID_FLASH_TIMEOUT:
> +		bval = LM3646_FLASH_TOUT_ms_TO_REG(ctrl->val);
> +		rval = regmap_update_bits(flash->regmap,
> +					  REG_FLASH_TOUT, MASK_FLASH_TOUT,
> +					  bval);
> +		break;
> +
> +	case V4L2_CID_FLASH_INTENSITY:
> +		bval = LM3646_TOTAL_FLASH_BRT_uA_TO_REG(ctrl->val);
> +		rval = regmap_update_bits(flash->regmap,
> +					  REG_FLASH_BR, MASK_FLASH_BR, bval);
> +		break;
> +
> +	case V4L2_CID_FLASH_TORCH_INTENSITY:
> +		bval = LM3646_TOTAL_TORCH_BRT_uA_TO_REG(ctrl->val);
> +		rval = regmap_update_bits(flash->regmap,
> +					  REG_TORCH_BR, MASK_TORCH_BR,
> +					  bval << 4);
> +		break;
> +	}
> +
> +	return rval;
> +}

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

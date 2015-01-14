Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbbANXAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 18:00:10 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:43791 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbbANXAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 18:00:07 -0500
Date: Wed, 14 Jan 2015 15:00:02 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dirk Hohndel <dirk@hohndel.org>, Nick Dyer <nick.dyer@itdev.co.uk>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.18 126/150] Revert "Input: atmel_mxt_ts - use deep
 sleep mode when stopped"
Message-ID: <20150114230002.GA9134@dtor-ws>
References: <20150114072055.842408181@linuxfoundation.org>
 <20150114072101.550487263@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150114072101.550487263@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tue, Jan 13, 2015 at 11:23:17PM -0800, Greg Kroah-Hartman wrote:
> 3.18-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Linus Torvalds <torvalds@linux-foundation.org>
> 
> commit 7f4054836d811c650c51f9c93088f8ebd61b0020 upstream.
> 
> This reverts commit 9d469d033d135d80742a4e39e6bbb4519dd5eee1.
> 
> It breaks the Chromebook Pixel touchpad (and touchscreen).
> 
> Reported-by: Dirk Hohndel <dirk@hohndel.org>
> Bisected-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Nick Dyer <nick.dyer@itdev.co.uk>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Yufeng Shen <miletus@chromium.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I'd rather we did not apply this to stable just yet - the patch does not
fix Dirk's Pixel and Linus's still flaky and I have another patch I'm
waiting on them to try out.

Thanks.

> 
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c |   99 ++++++++-----------------------
>  1 file changed, 26 insertions(+), 73 deletions(-)
> 
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -99,13 +99,9 @@
>  #define MXT_T6_STATUS_COMSERR	(1 << 2)
>  
>  /* MXT_GEN_POWER_T7 field */
> -struct t7_config {
> -	u8 idle;
> -	u8 active;
> -} __packed;
> -
> -#define MXT_POWER_CFG_RUN		0
> -#define MXT_POWER_CFG_DEEPSLEEP		1
> +#define MXT_POWER_IDLEACQINT	0
> +#define MXT_POWER_ACTVACQINT	1
> +#define MXT_POWER_ACTV2IDLETO	2
>  
>  /* MXT_GEN_ACQUIRE_T8 field */
>  #define MXT_ACQUIRE_CHRGTIME	0
> @@ -117,6 +113,7 @@ struct t7_config {
>  #define MXT_ACQUIRE_ATCHCALSTHR	7
>  
>  /* MXT_TOUCH_MULTI_T9 field */
> +#define MXT_TOUCH_CTRL		0
>  #define MXT_T9_ORIENT		9
>  #define MXT_T9_RANGE		18
>  
> @@ -256,7 +253,6 @@ struct mxt_data {
>  	bool update_input;
>  	u8 last_message_count;
>  	u8 num_touchids;
> -	struct t7_config t7_cfg;
>  
>  	/* Cached parameters from object table */
>  	u16 T5_address;
> @@ -672,6 +668,20 @@ static void mxt_proc_t6_messages(struct
>  	data->t6_status = status;
>  }
>  
> +static int mxt_write_object(struct mxt_data *data,
> +				 u8 type, u8 offset, u8 val)
> +{
> +	struct mxt_object *object;
> +	u16 reg;
> +
> +	object = mxt_get_object(data, type);
> +	if (!object || offset >= mxt_obj_size(object))
> +		return -EINVAL;
> +
> +	reg = object->start_address;
> +	return mxt_write_reg(data->client, reg + offset, val);
> +}
> +
>  static void mxt_input_button(struct mxt_data *data, u8 *message)
>  {
>  	struct input_dev *input = data->input_dev;
> @@ -1742,60 +1752,6 @@ err_free_object_table:
>  	return error;
>  }
>  
> -static int mxt_set_t7_power_cfg(struct mxt_data *data, u8 sleep)
> -{
> -	struct device *dev = &data->client->dev;
> -	int error;
> -	struct t7_config *new_config;
> -	struct t7_config deepsleep = { .active = 0, .idle = 0 };
> -
> -	if (sleep == MXT_POWER_CFG_DEEPSLEEP)
> -		new_config = &deepsleep;
> -	else
> -		new_config = &data->t7_cfg;
> -
> -	error = __mxt_write_reg(data->client, data->T7_address,
> -				sizeof(data->t7_cfg), new_config);
> -	if (error)
> -		return error;
> -
> -	dev_dbg(dev, "Set T7 ACTV:%d IDLE:%d\n",
> -		new_config->active, new_config->idle);
> -
> -	return 0;
> -}
> -
> -static int mxt_init_t7_power_cfg(struct mxt_data *data)
> -{
> -	struct device *dev = &data->client->dev;
> -	int error;
> -	bool retry = false;
> -
> -recheck:
> -	error = __mxt_read_reg(data->client, data->T7_address,
> -				sizeof(data->t7_cfg), &data->t7_cfg);
> -	if (error)
> -		return error;
> -
> -	if (data->t7_cfg.active == 0 || data->t7_cfg.idle == 0) {
> -		if (!retry) {
> -			dev_dbg(dev, "T7 cfg zero, resetting\n");
> -			mxt_soft_reset(data);
> -			retry = true;
> -			goto recheck;
> -		} else {
> -			dev_dbg(dev, "T7 cfg zero after reset, overriding\n");
> -			data->t7_cfg.active = 20;
> -			data->t7_cfg.idle = 100;
> -			return mxt_set_t7_power_cfg(data, MXT_POWER_CFG_RUN);
> -		}
> -	}
> -
> -	dev_dbg(dev, "Initialized power cfg: ACTV %d, IDLE %d\n",
> -		data->t7_cfg.active, data->t7_cfg.idle);
> -	return 0;
> -}
> -
>  static int mxt_configure_objects(struct mxt_data *data,
>  				 const struct firmware *cfg)
>  {
> @@ -1809,12 +1765,6 @@ static int mxt_configure_objects(struct
>  			dev_warn(dev, "Error %d updating config\n", error);
>  	}
>  
> -	error = mxt_init_t7_power_cfg(data);
> -	if (error) {
> -		dev_err(dev, "Failed to initialize power cfg\n");
> -		return error;
> -	}
> -
>  	error = mxt_initialize_t9_input_device(data);
>  	if (error)
>  		return error;
> @@ -2093,15 +2043,16 @@ static const struct attribute_group mxt_
>  
>  static void mxt_start(struct mxt_data *data)
>  {
> -	mxt_set_t7_power_cfg(data, MXT_POWER_CFG_RUN);
> -
> -	/* Recalibrate since chip has been in deep sleep */
> -	mxt_t6_command(data, MXT_COMMAND_CALIBRATE, 1, false);
> +	/* Touch enable */
> +	mxt_write_object(data,
> +			MXT_TOUCH_MULTI_T9, MXT_TOUCH_CTRL, 0x83);
>  }
>  
>  static void mxt_stop(struct mxt_data *data)
>  {
> -	mxt_set_t7_power_cfg(data, MXT_POWER_CFG_DEEPSLEEP);
> +	/* Touch disable */
> +	mxt_write_object(data,
> +			MXT_TOUCH_MULTI_T9, MXT_TOUCH_CTRL, 0);
>  }
>  
>  static int mxt_input_open(struct input_dev *dev)
> @@ -2267,6 +2218,8 @@ static int mxt_resume(struct device *dev
>  	struct mxt_data *data = i2c_get_clientdata(client);
>  	struct input_dev *input_dev = data->input_dev;
>  
> +	mxt_soft_reset(data);
> +
>  	mutex_lock(&input_dev->mutex);
>  
>  	if (input_dev->users)
> 
> 

-- 
Dmitry

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964858Ab3GRR26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 13:28:58 -0400
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:60163 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540Ab3GRR24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 13:28:56 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlJmAK8l6FFV5qu1PGdsb2JhbABTB4MGgyKFI7h+BAGBERcDAQEBATg1giQBAQQBJxMcEwEPBQsIAxgJJQ8FJQoaE4gKCrY6Fo5ODoEdB4N8A5dchjODcIo/OoEsIw
X-IronPort-AV: E=Sophos;i="4.89,695,1367964000"; 
   d="scan'208";a="586740510"
From: rydberg@euromail.se
Date: Thu, 18 Jul 2013 19:29:53 +0200
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH 45/51] Input: atmel_mxt_ts - Release touch state during
 suspend
Message-ID: <20130718172953.GI32381@polaris.bitmath.org>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
 <1372337366-9286-46-git-send-email-nick.dyer@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372337366-9286-46-git-send-email-nick.dyer@itdev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 01:49:20PM +0100, Nick Dyer wrote:
> If fingers are down as the MXT chip goes into suspend it does not send a lift
> message. In addition, it may not complete its final measurement cycle
> immediately, which means touch messages may be received by the interrupt
> handler after mxt_stop() has completed.

How long is the window of possible stray interrupts? Could this be
done with a small delay instead of keeping track of the suspend state?

> So:
> - disable irq during suspend
> - flush any messages created after suspend
> - tell app layer that slots were released at suspend
> 
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> Acked-by: Benson Leung <bleung@chromium.org>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c |   46 ++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index ceb090a..b4ecd1d 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -249,6 +249,9 @@ struct mxt_data {
>  
>  	/* Enable reporting of input events */
>  	bool enable_reporting;
> +
> +	/* Indicates whether device is in suspend */
> +	bool suspended;
>  };
>  
>  static inline size_t mxt_obj_size(const struct mxt_object *obj)
> @@ -2025,6 +2028,11 @@ static int mxt_load_fw(struct device *dev, const char *fn)
>  	if (ret)
>  		goto release_firmware;
>  
> +	if (data->suspended) {
> +		enable_irq(data->irq);
> +		data->suspended = false;
> +	}
> +
>  	if (!data->in_bootloader) {
>  		/* Change to the bootloader mode */
>  		data->in_bootloader = true;
> @@ -2137,6 +2145,8 @@ static ssize_t mxt_update_fw_store(struct device *dev,
>  	} else {
>  		dev_info(dev, "The firmware update succeeded\n");
>  
> +		data->suspended = false;
> +
>  		error = mxt_initialize(data);
>  		if (error)
>  			return error;
> @@ -2162,17 +2172,53 @@ static const struct attribute_group mxt_attr_group = {
>  	.attrs = mxt_attrs,
>  };
>  
> +static void mxt_reset_slots(struct mxt_data *data)
> +{
> +	struct input_dev *input_dev = data->input_dev;
> +	unsigned int num_mt_slots;
> +	int id;
> +
> +	num_mt_slots = data->num_touchids + data->num_stylusids;
> +
> +	for (id = 0; id < num_mt_slots; id++) {
> +		input_mt_slot(input_dev, id);
> +		input_mt_report_slot_state(input_dev, MT_TOOL_FINGER, 0);
> +	}
> +
> +	mxt_input_sync(input_dev);
> +}
> +
>  static void mxt_start(struct mxt_data *data)
>  {
> +	if (!data->suspended || data->in_bootloader)
> +		return;
> +
> +	/* Discard any touch messages still in message buffer from before chip
> +	 * went to sleep */
> +	mxt_process_messages_until_invalid(data);
> +
>  	mxt_set_t7_power_cfg(data, MXT_POWER_CFG_RUN);
>  
>  	/* Recalibrate since chip has been in deep sleep */
>  	mxt_t6_command(data, MXT_COMMAND_CALIBRATE, 1, false);
> +
> +	mxt_acquire_irq(data);
> +	data->enable_reporting = true;
> +	data->suspended = false;
>  }
>  
>  static void mxt_stop(struct mxt_data *data)
>  {
> +	if (data->suspended || data->in_bootloader)
> +		return;
> +
> +	data->enable_reporting = false;
> +	disable_irq(data->irq);
> +
>  	mxt_set_t7_power_cfg(data, MXT_POWER_CFG_DEEPSLEEP);
> +
> +	mxt_reset_slots(data);
> +	data->suspended = true;
>  }
>  
>  static int mxt_input_open(struct input_dev *dev)
> -- 
> 1.7.10.4
> 

    Reviewed-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934000AbaEFFVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 01:21:54 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40752 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaEFFVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 01:21:52 -0400
Date: Mon, 5 May 2014 22:21:48 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Roger Quadros <rogerq@ti.com>
Cc: rydberg@euromail.se, balbi@ti.com, dmurphy@ti.com, mugunthanvnm@ti.com,
        nsekhar@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 6/7] Input: pixcir_i2c_ts: Implement wakeup from
 suspend
Message-ID: <20140506052148.GB2608@core.coreip.homeip.net>
References: <1399280678-23925-1-git-send-email-rogerq@ti.com>
 <1399280678-23925-7-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399280678-23925-7-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 12:04:37PM +0300, Roger Quadros wrote:
> Improve the suspend and resume handlers to allow the device
> to wakeup the system from suspend.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Acked-by: Mugunthan V N <mugunthanvnm@ti.com>
> ---
>  drivers/input/touchscreen/pixcir_i2c_ts.c | 53 ++++++++++++++++++++++++++++---
>  1 file changed, 49 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/pixcir_i2c_ts.c b/drivers/input/touchscreen/pixcir_i2c_ts.c
> index 927aed1..5f6a27e 100644
> --- a/drivers/input/touchscreen/pixcir_i2c_ts.c
> +++ b/drivers/input/touchscreen/pixcir_i2c_ts.c
> @@ -348,21 +348,66 @@ static void pixcir_input_close(struct input_dev *dev)
>  static int pixcir_i2c_ts_suspend(struct device *dev)
>  {
>  	struct i2c_client *client = to_i2c_client(dev);
> +	struct pixcir_i2c_ts_data *ts = i2c_get_clientdata(client);
> +	struct input_dev *input = ts->input;
> +	int ret = 0;
> +
> +	mutex_lock(&input->mutex);
> +
> +	if (input->users) {
> +		ret = pixcir_stop(ts);
> +		if (ret)
> +			goto unlock;
> +	}
> +
> +	/*
> +	 * If wakeup is enabled we need to enable interrupt generation
> +	 * but don't need to process any reports i.e. ts->exiting must be true.
> +	 */
> +	if (device_may_wakeup(&client->dev)) {
> +		/* enable wakeup interrupt generation */
> +		ret = pixcir_int_enable(ts, 1);
> +		if (ret) {
> +			dev_err(dev, "Failed to enable interrupt generation\n");
> +			goto unlock;
> +		}

I am not sure why we need to disable event processing here. Why not do

	if (device_may_wakeup(&client->dev)) {
		enable_irq_wake(client->irq); 
		ret = pixcir_int_enable(ts, true);
		...
	} else if (input->users) {
		ret = pixcir_stop(ts);
	}

like many of the drivers do?

Thanks.

-- 
Dmitry

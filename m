Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaESF4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 01:56:00 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:60737 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaESFz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 01:55:58 -0400
Date: Sun, 18 May 2014 22:55:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Roger Quadros <rogerq@ti.com>
Cc: rydberg@euromail.se, balbi@ti.com, dmurphy@ti.com, mugunthanvnm@ti.com,
        nsekhar@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 6/7] Input: pixcir_i2c_ts: Implement wakeup from
 suspend
Message-ID: <20140519055555.GK29386@core.coreip.homeip.net>
References: <1399374372-29123-1-git-send-email-rogerq@ti.com>
 <1399374372-29123-7-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399374372-29123-7-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 02:06:11PM +0300, Roger Quadros wrote:
> Improve the suspend and resume handlers to allow the device
> to wakeup the system from suspend.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Acked-by: Mugunthan V N <mugunthanvnm@ti.com>

Applied, thank you.

> ---
>  drivers/input/touchscreen/pixcir_i2c_ts.c | 47 ++++++++++++++++++++++++++++---
>  1 file changed, 43 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/pixcir_i2c_ts.c b/drivers/input/touchscreen/pixcir_i2c_ts.c
> index 0728c04..b0f7680 100644
> --- a/drivers/input/touchscreen/pixcir_i2c_ts.c
> +++ b/drivers/input/touchscreen/pixcir_i2c_ts.c
> @@ -348,21 +348,59 @@ static void pixcir_input_close(struct input_dev *dev)
>  static int pixcir_i2c_ts_suspend(struct device *dev)
>  {
>  	struct i2c_client *client = to_i2c_client(dev);
> +	struct pixcir_i2c_ts_data *ts = i2c_get_clientdata(client);
> +	struct input_dev *input = ts->input;
> +	int ret = 0;
> +
> +	mutex_lock(&input->mutex);
> +
> +	if (device_may_wakeup(&client->dev)) {
> +		if (!input->users) {
> +			ret = pixcir_start(ts);
> +			if (ret) {
> +				dev_err(dev, "Failed to start\n");
> +				goto unlock;
> +			}
> +		}
>  
> -	if (device_may_wakeup(&client->dev))
>  		enable_irq_wake(client->irq);
> +	} else if (input->users) {
> +		ret = pixcir_stop(ts);
> +	}
>  
> -	return 0;
> +unlock:
> +	mutex_unlock(&input->mutex);
> +
> +	return ret;
>  }
>  
>  static int pixcir_i2c_ts_resume(struct device *dev)
>  {
>  	struct i2c_client *client = to_i2c_client(dev);
> +	struct pixcir_i2c_ts_data *ts = i2c_get_clientdata(client);
> +	struct input_dev *input = ts->input;
> +	int ret = 0;
> +
> +	mutex_lock(&input->mutex);
>  
> -	if (device_may_wakeup(&client->dev))
> +	if (device_may_wakeup(&client->dev)) {
>  		disable_irq_wake(client->irq);
>  
> -	return 0;
> +		if (!input->users) {
> +			ret = pixcir_stop(ts);
> +			if (ret) {
> +				dev_err(dev, "Failed to stop\n");
> +				goto unlock;
> +			}
> +		}
> +	} else if (input->users) {
> +		ret = pixcir_start(ts);
> +	}
> +
> +unlock:
> +	mutex_unlock(&input->mutex);
> +
> +	return ret;
>  }
>  #endif
>  
> @@ -469,6 +507,7 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
>  	if (error)
>  		return error;
>  
> +	i2c_set_clientdata(client, tsdata);
>  	device_init_wakeup(&client->dev, 1);
>  
>  	return 0;
> -- 
> 1.8.3.2
> 

-- 
Dmitry

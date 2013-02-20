Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935852Ab3BTUgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:36:15 -0500
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:43846 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934126Ab3BTUgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:36:13 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap1GAHoyJVFV5qjOOWdsb2JhbABFhWCFILVfgQEXAwEBAQEhFzSCHwEBBAEnExwTAQ8FCwgDDhMlDwUlChoKCYgMCsBjFY55B4JfYQOWK4YCg1mKCQ
X-IronPort-AV: E=Sophos;i="4.84,704,1355094000"; 
   d="scan'208";a="500976741"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 20 Feb 2013 21:37:35 +0100
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, Nick Dyer <nick.dyer@itdev.co.uk>,
        Benson Leung <bleung@chromium.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH v2] Input: atmel_mxt_ts - refactor i2c error handling
Message-ID: <20130220203735.GA1435@polaris.bitmath.org>
References: <1360940155-17619-1-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360940155-17619-1-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> A recent patch refactored i2c error handling in the register read/write
> path.  This adds similar handling to the other i2c paths used in fw_update
> and bootloader state detection.
> 
> The generic i2c layer can return values indicating a partial transaction.
> From the atmel_mxt driver's perspective, this is an IO error, so we use
> some helper functions to convert these partial transfers to -EIO in a
> uniform way.  Other error codes might still be useful, though, so we pass
> them up unmodified.  Note that in the partial transfer case, we log the
> number of bytes partially transferred, and not -EIO.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
> Changes from V1:
> - simplified implied logic (thanks Henrik!)
> - error print the partial number of bytes received, not -EIO
> 
>  drivers/input/touchscreen/atmel_mxt_ts.c | 83 +++++++++++++++++---------------
>  1 file changed, 45 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index d04f810..3d56d5f 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -324,16 +324,53 @@ static void mxt_dump_message(struct device *dev,
>  		message->reportid, 7, message->message);
>  }
>  
> +static int mxt_i2c_recv(struct i2c_client *client, u8 *buf, size_t count)
> +{
> +	int ret;
> +
> +	ret = i2c_master_recv(client, buf, count);
> +	if (ret == count)
> +		return 0;
> +
> +	dev_err(&client->dev, "i2c recv failed (%d)\n", ret);
> +	return (ret < 0) ? ret : -EIO;
> +}
> +
> +static int mxt_i2c_send(struct i2c_client *client, const u8 *buf, size_t count)
> +{
> +	int ret;
> +
> +	ret = i2c_master_send(client, buf, count);
> +	if (ret == count)
> +		return 0;
> +
> +	dev_err(&client->dev, "i2c send failed (%d)\n", ret);
> +	return (ret < 0) ? ret : -EIO;
> +}
> +
> +static int mxt_i2c_transfer(struct i2c_client *client, struct i2c_msg *msgs,
> +		size_t count)
> +{
> +	int ret;
> +
> +	ret = i2c_transfer(client->adapter, msgs, count);
> +	if (ret == count)
> +		return 0;
> +
> +	dev_err(&client->dev, "i2c transfer failed (%d)\n", ret);
> +	return (ret < 0) ? ret : -EIO;
> +}
> +
>  static int mxt_check_bootloader(struct i2c_client *client,
>  				     unsigned int state)
>  {
>  	u8 val;
> +	int ret;
>  
>  recheck:
> -	if (i2c_master_recv(client, &val, 1) != 1) {
> -		dev_err(&client->dev, "%s: i2c recv failed\n", __func__);
> -		return -EIO;
> -	}
> +	ret = mxt_i2c_recv(client, &val, 1);
> +	if (ret)
> +		return ret;
>  
>  	switch (state) {
>  	case MXT_WAITING_BOOTLOAD_CMD:
> @@ -363,23 +400,13 @@ static int mxt_unlock_bootloader(struct i2c_client *client)
>  	buf[0] = MXT_UNLOCK_CMD_LSB;
>  	buf[1] = MXT_UNLOCK_CMD_MSB;
>  
> -	if (i2c_master_send(client, buf, 2) != 2) {
> -		dev_err(&client->dev, "%s: i2c send failed\n", __func__);
> -		return -EIO;
> -	}
> -
> -	return 0;
> +	return mxt_i2c_send(client, buf, 2);
>  }
>  
>  static int mxt_fw_write(struct i2c_client *client,
>  			     const u8 *data, unsigned int frame_size)
>  {
> -	if (i2c_master_send(client, data, frame_size) != frame_size) {
> -		dev_err(&client->dev, "%s: i2c send failed\n", __func__);
> -		return -EIO;
> -	}
> -
> -	return 0;
> +	return mxt_i2c_send(client, data, frame_size);
>  }
>  
>  static int __mxt_read_reg(struct i2c_client *client,
> @@ -387,7 +414,6 @@ static int __mxt_read_reg(struct i2c_client *client,
>  {
>  	struct i2c_msg xfer[2];
>  	u8 buf[2];
> -	int ret;
>  
>  	buf[0] = reg & 0xff;
>  	buf[1] = (reg >> 8) & 0xff;
> @@ -404,17 +430,7 @@ static int __mxt_read_reg(struct i2c_client *client,
>  	xfer[1].len = len;
>  	xfer[1].buf = val;
>  
> -	ret = i2c_transfer(client->adapter, xfer, 2);
> -	if (ret == 2) {
> -		ret = 0;
> -	} else {
> -		if (ret >= 0)
> -			ret = -EIO;
> -		dev_err(&client->dev, "%s: i2c transfer failed (%d)\n",
> -			__func__, ret);
> -	}
> -
> -	return ret;
> +	return mxt_i2c_transfer(client, xfer, 2);
>  }
>  
>  static int mxt_read_reg(struct i2c_client *client, u16 reg, u8 *val)
> @@ -438,16 +454,7 @@ static int __mxt_write_reg(struct i2c_client *client, u16 reg, u16 len,
>  	buf[1] = (reg >> 8) & 0xff;
>  	memcpy(&buf[2], val, len);
>  
> -	ret = i2c_master_send(client, buf, count);
> -	if (ret == count) {
> -		ret = 0;
> -	} else {
> -		if (ret >= 0)
> -			ret = -EIO;
> -		dev_err(&client->dev, "%s: i2c send failed (%d)\n",
> -			__func__, ret);
> -	}
> -
> +	ret = mxt_i2c_send(client, buf, count);
>  	kfree(buf);
>  	return ret;
>  }
> -- 
> 1.8.1
> 

    Reviewed-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik

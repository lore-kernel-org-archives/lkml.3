Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916Ab3BMVqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 16:46:48 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:60789 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab3BMVqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 16:46:46 -0500
Date: Wed, 13 Feb 2013 13:46:42 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Henrik Rydberg <rydberg@euromail.se>, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>,
        Joonyoung Shim <jy0922.shim@samsung.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org
Subject: Re: [PATCH 04/10] Input: atmel_mxt_ts - handle bootloader mode at
 probe
Message-ID: <20130213214642.GC23390@core.coreip.homeip.net>
References: <1359706312-24642-1-git-send-email-djkurtz@chromium.org>
 <1359706312-24642-5-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359706312-24642-5-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 04:11:46PM +0800, Daniel Kurtz wrote:
> In some cases it is possible for a device to be in its bootloader at
> driver probe time.  This is detected by the driver when probe() is called
> with an i2c_client which has one of the Atmel Bootloader i2c addresses.
> 
> In this case, we should load enough driver functionality to still loading
> new firmware using:
>   echo 1 > update_fw
> 
> However, we must be very careful not to follow any code paths that would try
> to access the as-yet uninitialized object table or input device.
> In particular:
>  1) mxt_remove calls input_unregister_device on input_dev.
>  2) mxt_suspend/resume reads and writes from the object table.
>  3) Spurious or bootloader induced interrupts
> 
> Signed-off-by: Benson Leung <bleung@chromium.org>
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c | 51 +++++++++++++++++++++++++-------
>  1 file changed, 40 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index 9afc26e..6c2c712 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -324,6 +324,12 @@ static void mxt_dump_message(struct device *dev,
>  		message->reportid, 7, message->message);
>  }
>  
> +static bool mxt_in_bootloader(struct mxt_data *data)
> +{
> +	struct i2c_client *client = data->client;
> +	return (client->addr == MXT_BOOT_LOW || client->addr == MXT_BOOT_HIGH);
> +}
> +
>  static int mxt_i2c_recv(struct i2c_client *client, u8 *buf, size_t count)
>  {
>  	int ret;
> @@ -584,6 +590,9 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
>  	u8 reportid;
>  	bool update_input = false;
>  
> +	if (mxt_in_bootloader(data))
> +		goto end;
> +
>  	do {
>  		if (mxt_read_message(data, &message)) {
>  			dev_err(dev, "Failed to read message\n");
> @@ -975,6 +984,9 @@ static int mxt_load_fw(struct device *dev, const char *fn)
>  		return ret;
>  	}
>  
> +	if (mxt_in_bootloader(data))
> +		goto bootloader_ready;
> +
>  	/* Change to the bootloader mode */
>  	mxt_write_object(data, MXT_GEN_COMMAND_T6,
>  			MXT_COMMAND_RESET, MXT_BOOT_VALUE);
> @@ -986,6 +998,7 @@ static int mxt_load_fw(struct device *dev, const char *fn)
>  	else
>  		client->addr = MXT_BOOT_HIGH;
>  
> +bootloader_ready:
>  	ret = mxt_check_bootloader(client, MXT_WAITING_BOOTLOAD_CMD);
>  	if (ret)
>  		goto out;
> @@ -1196,25 +1209,34 @@ static int __devinit mxt_probe(struct i2c_client *client,
>  
>  	mxt_calc_resolution(data);
>  
> -	error = mxt_initialize(data);
> -	if (error)
> -		goto err_free_mem;
> +	if (mxt_in_bootloader(data)) {
> +		dev_info(&client->dev, "Device in bootloader at probe\n");
> +	} else {
> +		error = mxt_initialize(data);
> +		if (error)
> +			goto err_free_mem;
>  
> -	error = mxt_input_dev_create(data);
> -	if (error)
> -		goto err_free_object;
> +		error = mxt_input_dev_create(data);
> +		if (error)
> +			goto err_free_object;
> +	}
>  
>  	error = request_threaded_irq(client->irq, NULL, mxt_interrupt,
>  				     pdata->irqflags | IRQF_ONESHOT,
>  				     client->name, data);
>  	if (error) {
>  		dev_err(&client->dev, "Failed to register interrupt\n");
> -		goto err_unregister_device;
> +		if (mxt_in_bootloader(data))
> +			goto err_free_mem;
> +		else
> +			goto err_unregister_device;
>  	}
>  
> -	error = mxt_make_highchg(data);
> -	if (error)
> -		goto err_free_irq;
> +	if (!mxt_in_bootloader(data)) {
> +		error = mxt_make_highchg(data);
> +		if (error)
> +			goto err_free_irq;
> +	}
>  
>  	error = sysfs_create_group(&client->dev.kobj, &mxt_attr_group);
>  	if (error)
> @@ -1239,7 +1261,8 @@ static int mxt_remove(struct i2c_client *client)
>  
>  	sysfs_remove_group(&client->dev.kobj, &mxt_attr_group);
>  	free_irq(data->irq, data);
> -	input_unregister_device(data->input_dev);
> +	if (data->input_dev)
> +		input_unregister_device(data->input_dev);
>  	kfree(data->object_table);
>  	kfree(data);
>  
> @@ -1253,6 +1276,9 @@ static int mxt_suspend(struct device *dev)
>  	struct mxt_data *data = i2c_get_clientdata(client);
>  	struct input_dev *input_dev = data->input_dev;
>  
> +	if (mxt_in_bootloader(data))
> +		return 0;
> +

Hmm, so what happens if we suspend while in bootloader and maybe even
trying to flash the device? Maybe we should refuse suspend instead?

>  	mutex_lock(&input_dev->mutex);
>  
>  	if (input_dev->users)
> @@ -1269,6 +1295,9 @@ static int mxt_resume(struct device *dev)
>  	struct mxt_data *data = i2c_get_clientdata(client);
>  	struct input_dev *input_dev = data->input_dev;
>  
> +	if (mxt_in_bootloader(data))
> +		return 0;
> +
>  	/* Soft reset */
>  	mxt_write_object(data, MXT_GEN_COMMAND_T6,
>  			MXT_COMMAND_RESET, 1);
> -- 
> 1.8.1
> 

-- 
Dmitry

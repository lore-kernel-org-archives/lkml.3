Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab3GGFeM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 01:34:12 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:48424 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3GGFeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 01:34:11 -0400
Date: Sat, 6 Jul 2013 22:34:07 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH 26/51] Input: atmel_mxt_ts - Move input device init into
 separate function
Message-ID: <20130707053407.GC15453@core.coreip.homeip.net>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
 <1372337366-9286-27-git-send-email-nick.dyer@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372337366-9286-27-git-send-email-nick.dyer@itdev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 01:49:01PM +0100, Nick Dyer wrote:
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>

So before we allocated input device before requesting IRQ, now we fo it
afterwards so there is moment where the interrupt is requested and not
disabled and input device is not allocated yet. Is it possible for
interrupt to happen at that moment?

Thanks.

> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c |  129 +++++++++++++++++-------------
>  1 file changed, 75 insertions(+), 54 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index 8632133..030ebc5 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -1728,73 +1728,39 @@ static int mxt_handle_pdata(struct mxt_data *data)
>  	return 0;
>  }
>  
> -static int mxt_probe(struct i2c_client *client,
> -		const struct i2c_device_id *id)
> +static int mxt_initialize_t9_input_device(struct mxt_data *data)
>  {
> -	struct mxt_data *data;
> +	struct device *dev = &data->client->dev;
> +	const struct mxt_platform_data *pdata = data->pdata;
>  	struct input_dev *input_dev;
>  	int error;
>  	unsigned int num_mt_slots;
>  	unsigned int mt_flags = 0;
>  	int i;
>  
> -	data = kzalloc(sizeof(struct mxt_data), GFP_KERNEL);
>  	input_dev = input_allocate_device();
> -	if (!data || !input_dev) {
> -		dev_err(&client->dev, "Failed to allocate memory\n");
> -		error = -ENOMEM;
> -		goto err_free_mem;
> +	if (!input_dev) {
> +		dev_err(dev, "Failed to allocate memory\n");
> +		return -ENOMEM;
>  	}
>  
>  	input_dev->name = "Atmel maXTouch Touchscreen";
> -	snprintf(data->phys, sizeof(data->phys), "i2c-%u-%04x/input0",
> -		 client->adapter->nr, client->addr);
> -
>  	input_dev->phys = data->phys;
> -
>  	input_dev->id.bustype = BUS_I2C;
> -	input_dev->dev.parent = &client->dev;
> +	input_dev->dev.parent = dev;
>  	input_dev->open = mxt_input_open;
>  	input_dev->close = mxt_input_close;
>  
> -	data->client = client;
> -	data->input_dev = input_dev;
> -	data->irq = client->irq;
> -	i2c_set_clientdata(client, data);
> -
> -	error = mxt_handle_pdata(data);
> -	if (error)
> -		goto err_free_mem;
> -
> -	init_completion(&data->bl_completion);
> -	init_completion(&data->reset_completion);
> -	init_completion(&data->crc_completion);
> -
> -	error = request_threaded_irq(data->irq, NULL, mxt_interrupt,
> -				     data->pdata->irqflags | IRQF_ONESHOT,
> -				     client->name, data);
> -	if (error) {
> -		dev_err(&client->dev, "Failed to register interrupt\n");
> -		goto err_free_pdata;
> -	}
> -
> -	disable_irq(client->irq);
> -
> -	error = mxt_initialize(data);
> -	if (error)
> -		goto err_free_irq;
> -
>  	__set_bit(EV_ABS, input_dev->evbit);
> -	__set_bit(EV_KEY, input_dev->evbit);
> -	__set_bit(BTN_TOUCH, input_dev->keybit);
> +	input_set_capability(input_dev, EV_KEY, BTN_TOUCH);
>  
> -	if (data->pdata->t19_num_keys) {
> +	if (pdata->t19_num_keys) {
>  		__set_bit(INPUT_PROP_BUTTONPAD, input_dev->propbit);
>  
> -		for (i = 0; i < data->pdata->t19_num_keys; i++)
> -			if (data->pdata->t19_keymap[i] != KEY_RESERVED)
> +		for (i = 0; i < pdata->t19_num_keys; i++)
> +			if (pdata->t19_keymap[i] != KEY_RESERVED)
>  				input_set_capability(input_dev, EV_KEY,
> -						data->pdata->t19_keymap[i]);
> +						     pdata->t19_keymap[i]);
>  
>  		mt_flags |= INPUT_MT_POINTER;
>  
> @@ -1819,8 +1785,11 @@ static int mxt_probe(struct i2c_client *client,
>  	/* For multi touch */
>  	num_mt_slots = data->T9_reportid_max - data->T9_reportid_min + 1;
>  	error = input_mt_init_slots(input_dev, num_mt_slots, mt_flags);
> -	if (error)
> -		goto err_free_object;
> +	if (error) {
> +		dev_err(dev, "Error %d initialising slots\n", error);
> +		goto err_free_mem;
> +	}
> +
>  	input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR,
>  			     0, MXT_MAX_AREA, 0, 0);
>  	input_set_abs_params(input_dev, ABS_MT_POSITION_X,
> @@ -1834,11 +1803,64 @@ static int mxt_probe(struct i2c_client *client,
>  
>  	error = input_register_device(input_dev);
>  	if (error) {
> -		dev_err(&client->dev, "Error %d registering input device\n",
> -			error);
> -		goto err_free_object;
> +		dev_err(dev, "Error %d registering input device\n", error);
> +		goto err_free_mem;
>  	}
>  
> +	data->input_dev = input_dev;
> +
> +	return 0;
> +
> +err_free_mem:
> +	input_free_device(input_dev);
> +	return error;
> +}
> +
> +static int mxt_probe(struct i2c_client *client,
> +		const struct i2c_device_id *id)
> +{
> +	struct mxt_data *data;
> +	int error;
> +
> +	data = kzalloc(sizeof(struct mxt_data), GFP_KERNEL);
> +	if (!data) {
> +		dev_err(&client->dev, "Failed to allocate memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	snprintf(data->phys, sizeof(data->phys), "i2c-%u-%04x/input0",
> +		 client->adapter->nr, client->addr);
> +
> +	data->client = client;
> +	data->irq = client->irq;
> +	i2c_set_clientdata(client, data);
> +
> +	error = mxt_handle_pdata(data);
> +	if (error)
> +		goto err_free_mem;
> +
> +	init_completion(&data->bl_completion);
> +	init_completion(&data->reset_completion);
> +	init_completion(&data->crc_completion);
> +
> +	error = request_threaded_irq(data->irq, NULL, mxt_interrupt,
> +				     data->pdata->irqflags | IRQF_ONESHOT,
> +				     client->name, data);
> +	if (error) {
> +		dev_err(&client->dev, "Failed to register interrupt\n");
> +		goto err_free_pdata;
> +	}
> +
> +	disable_irq(data->irq);
> +
> +	error = mxt_initialize(data);
> +	if (error)
> +		goto err_free_irq;
> +
> +	error = mxt_initialize_t9_input_device(data);
> +	if (error)
> +		goto err_free_object;
> +
>  	error = sysfs_create_group(&client->dev.kobj, &mxt_attr_group);
>  	if (error) {
>  		dev_err(&client->dev, "Failure %d creating sysfs group\n",
> @@ -1849,8 +1871,8 @@ static int mxt_probe(struct i2c_client *client,
>  	return 0;
>  
>  err_unregister_device:
> -	input_unregister_device(input_dev);
> -	input_dev = NULL;
> +	input_unregister_device(data->input_dev);
> +	data->input_dev = NULL;
>  err_free_object:
>  	kfree(data->object_table);
>  err_free_irq:
> @@ -1859,7 +1881,6 @@ err_free_pdata:
>  	if (!dev_get_platdata(&data->client->dev))
>  		kfree(data->pdata);
>  err_free_mem:
> -	input_free_device(input_dev);
>  	kfree(data);
>  	return error;
>  }
> -- 
> 1.7.10.4
> 

-- 
Dmitry

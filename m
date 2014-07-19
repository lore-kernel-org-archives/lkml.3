Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbaGSXUx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 19:20:53 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60826 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaGSXUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 19:20:52 -0400
Date: Sat, 19 Jul 2014 16:20:48 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] Input: max7359 - Introduce the use of managed interfaces
Message-ID: <20140719232048.GC19006@core.coreip.homeip.net>
References: <20140719100654.GA18035@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140719100654.GA18035@himangi-Dell>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 03:36:54PM +0530, Himangi Saraogi wrote:
> This patch introduces the use of managed interfaces like devm_kzalloc,
> devm_input_allocate_device, devm_request_threaded_irq etc. and does away
> with the calls to free the allocated memory. The remove function is no
> longer required and is completely done away with. Also, the labels in
> the probe function are removed.
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied, thank you.

> ---
>  drivers/input/keyboard/max7359_keypad.c | 38 +++++++++------------------------
>  1 file changed, 10 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/input/keyboard/max7359_keypad.c b/drivers/input/keyboard/max7359_keypad.c
> index 430b545..b0ef607 100644
> --- a/drivers/input/keyboard/max7359_keypad.c
> +++ b/drivers/input/keyboard/max7359_keypad.c
> @@ -203,12 +203,12 @@ static int max7359_probe(struct i2c_client *client,
>  
>  	dev_dbg(&client->dev, "keys FIFO is 0x%02x\n", ret);
>  
> -	keypad = kzalloc(sizeof(struct max7359_keypad), GFP_KERNEL);
> -	input_dev = input_allocate_device();
> +	keypad = devm_kzalloc(&client->dev, sizeof(struct max7359_keypad),
> +			      GFP_KERNEL);
> +	input_dev = devm_input_allocate_device(&client->dev);
>  	if (!keypad || !input_dev) {
>  		dev_err(&client->dev, "failed to allocate memory\n");
> -		error = -ENOMEM;
> -		goto failed_free_mem;
> +		return -ENOMEM;
>  	}
>  
>  	keypad->client = client;
> @@ -230,19 +230,20 @@ static int max7359_probe(struct i2c_client *client,
>  
>  	max7359_build_keycode(keypad, keymap_data);
>  
> -	error = request_threaded_irq(client->irq, NULL, max7359_interrupt,
> -				     IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> -				     client->name, keypad);
> +	error = devm_request_threaded_irq(&client->dev, client->irq, NULL,
> +					  max7359_interrupt,
> +					  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> +					  client->name, keypad);
>  	if (error) {
>  		dev_err(&client->dev, "failed to register interrupt\n");
> -		goto failed_free_mem;
> +		return error;
>  	}
>  
>  	/* Register the input device */
>  	error = input_register_device(input_dev);
>  	if (error) {
>  		dev_err(&client->dev, "failed to register input device\n");
> -		goto failed_free_irq;
> +		return error;
>  	}
>  
>  	/* Initialize MAX7359 */
> @@ -252,24 +253,6 @@ static int max7359_probe(struct i2c_client *client,
>  	device_init_wakeup(&client->dev, 1);
>  
>  	return 0;
> -
> -failed_free_irq:
> -	free_irq(client->irq, keypad);
> -failed_free_mem:
> -	input_free_device(input_dev);
> -	kfree(keypad);
> -	return error;
> -}
> -
> -static int max7359_remove(struct i2c_client *client)
> -{
> -	struct max7359_keypad *keypad = i2c_get_clientdata(client);
> -
> -	free_irq(client->irq, keypad);
> -	input_unregister_device(keypad->input_dev);
> -	kfree(keypad);
> -
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> @@ -313,7 +296,6 @@ static struct i2c_driver max7359_i2c_driver = {
>  		.pm   = &max7359_pm,
>  	},
>  	.probe		= max7359_probe,
> -	.remove		= max7359_remove,
>  	.id_table	= max7359_ids,
>  };
>  
> -- 
> 1.9.1
> 

-- 
Dmitry

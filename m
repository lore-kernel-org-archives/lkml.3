Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab3KWSGg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 13:06:36 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:49109 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab3KWSGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 13:06:34 -0500
Date: Sat, 23 Nov 2013 10:06:23 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: andrew.liu200917@gmail.com
Cc: michael.hennerich@analog.com, device-drivers-devel@blackfin.uclinux.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] input:keyboard: "keycode & KEY_MAX" changes some keycode
 value.
Message-ID: <20131123180621.GA15116@core.coreip.homeip.net>
References: <1385214345-10385-1-git-send-email-andrew.liu200917@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385214345-10385-1-git-send-email-andrew.liu200917@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Sat, Nov 23, 2013 at 09:45:45PM +0800, andrew.liu200917@gmail.com wrote:
> From: Andrew Liu <andrew.liu200917@gmail.com>
> 
> For exmaple, keycode: KEY_OK(0x160) is changed by "and" operation with
> KEY_MAX(0x2ff) to KEY_KPENTER(96).
> 
> Signed-off-by: Andrew Liu <andrew.liu200917@gmail.com>
> ---
>  drivers/input/keyboard/adp5588-keys.c |    8 ++++++--
>  drivers/input/keyboard/adp5589-keys.c |    8 ++++++--
>  drivers/input/keyboard/bf54x-keys.c   |    8 ++++++--
>  drivers/input/misc/pcf8574_keypad.c   |    6 +++++-
>  drivers/media/pci/ttpci/av7110_ir.c   |    1 +
>  5 files changed, 24 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/input/keyboard/adp5588-keys.c b/drivers/input/keyboard/adp5588-keys.c
> index dbd2047..1ce559e 100644
> --- a/drivers/input/keyboard/adp5588-keys.c
> +++ b/drivers/input/keyboard/adp5588-keys.c
> @@ -535,8 +535,12 @@ static int adp5588_probe(struct i2c_client *client,
>  	if (pdata->repeat)
>  		__set_bit(EV_REP, input->evbit);
>  
> -	for (i = 0; i < input->keycodemax; i++)
> -		__set_bit(kpad->keycode[i] & KEY_MAX, input->keybit);
> +	for (i = 0; i < input->keycodemax; i++) {
> +		if (kpad->keycode[i] > KEY_MAX)
> +			kpad->keycode[i] = 0;

There is no need to reset keymap entires to 0, not setting keybit is
enough.

> +		else if (kpad->keycode[i] > KEY_RESERVED)
> +			__set_bit(kpad->keycode[i], input->keybit);
> +	}
>  	__clear_bit(KEY_RESERVED, input->keybit);
>  
>  	if (kpad->gpimapsize)
> diff --git a/drivers/input/keyboard/adp5589-keys.c b/drivers/input/keyboard/adp5589-keys.c
> index 67d12b3..22ca2a5 100644
> --- a/drivers/input/keyboard/adp5589-keys.c
> +++ b/drivers/input/keyboard/adp5589-keys.c
> @@ -991,8 +991,12 @@ static int adp5589_probe(struct i2c_client *client,
>  	if (pdata->repeat)
>  		__set_bit(EV_REP, input->evbit);
>  
> -	for (i = 0; i < input->keycodemax; i++)
> -		__set_bit(kpad->keycode[i] & KEY_MAX, input->keybit);
> +	for (i = 0; i < input->keycodemax; i++) {
> +		if (kpad->keycode[i] > KEY_MAX)
> +			kpad->keycode[i] = 0;
> +		else if (kpad->keycode[i] > KEY_RESERVED)
> +			__set_bit(kpad->keycode[i], input->keybit);
> +	}
>  	__clear_bit(KEY_RESERVED, input->keybit);
>  
>  	if (kpad->gpimapsize)
> diff --git a/drivers/input/keyboard/bf54x-keys.c b/drivers/input/keyboard/bf54x-keys.c
> index fc88fb4..96f54e7 100644
> --- a/drivers/input/keyboard/bf54x-keys.c
> +++ b/drivers/input/keyboard/bf54x-keys.c
> @@ -288,8 +288,12 @@ static int bfin_kpad_probe(struct platform_device *pdev)
>  	if (pdata->repeat)
>  		__set_bit(EV_REP, input->evbit);
>  
> -	for (i = 0; i < input->keycodemax; i++)
> -		__set_bit(bf54x_kpad->keycode[i] & KEY_MAX, input->keybit);
> +	for (i = 0; i < input->keycodemax; i++) {
> +		if (bf54x_kpad->keycode[i] > KEY_MAX)
> +			bf54x_kpad->keycode[i] = 0;
> +		else if (bf54x_kpad->keycode[i] > KEY_RESERVED)
> +			__set_bit(bf54x_kpad->keycode[i], input->keybit);
> +	}
>  	__clear_bit(KEY_RESERVED, input->keybit);
>  
>  	error = input_register_device(input);
> diff --git a/drivers/input/misc/pcf8574_keypad.c b/drivers/input/misc/pcf8574_keypad.c
> index e373929..48829f3 100644
> --- a/drivers/input/misc/pcf8574_keypad.c
> +++ b/drivers/input/misc/pcf8574_keypad.c
> @@ -114,8 +114,12 @@ static int pcf8574_kp_probe(struct i2c_client *client, const struct i2c_device_i
>  
>  	for (i = 0; i < ARRAY_SIZE(pcf8574_kp_btncode); i++) {
>  		lp->btncode[i] = pcf8574_kp_btncode[i];
> -		__set_bit(lp->btncode[i] & KEY_MAX, idev->keybit);
> +		if (lp->btncode[i] > KEY_MAX)
> +			lp->btncode[i] = 0;
> +		else if (lp->btncode[i] > KEY_RESERVED)
> +			__set_bit(lp->btncode[i], idev->keybit);
>  	}
> +	__clear_bit(KEY_RESERVED, idev->keybit);
>  
>  	sprintf(lp->name, DRV_NAME);
>  	sprintf(lp->phys, "kp_data/input0");
> diff --git a/drivers/media/pci/ttpci/av7110_ir.c b/drivers/media/pci/ttpci/av7110_ir.c
> index 0e763a7..7fdac45 100644
> --- a/drivers/media/pci/ttpci/av7110_ir.c
> +++ b/drivers/media/pci/ttpci/av7110_ir.c
> @@ -201,6 +201,7 @@ static void input_register_keys(struct infrared *ir)
>  		else if (ir->key_map[i] > KEY_RESERVED)
>  			set_bit(ir->key_map[i], ir->input_dev->keybit);
>  	}
> +	__clear_bit(KEY_RESERVED, ir->input_dev->keybit);

Here we only setting bits for keycodes above KEY_RESERVED so we do not
need to clear KEY_RESERVED bit.

>  
>  	ir->input_dev->keycode = ir->key_map;
>  	ir->input_dev->keycodesize = sizeof(ir->key_map[0]);
> -- 
> 1.7.1
> 

Edited and applied, thank you.

-- 
Dmitry

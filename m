Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab3CPTf6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 15:35:58 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:58245 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3CPTf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 15:35:56 -0400
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqBwAMDIRFFV5qjOPGdsb2JhbABDh0uFILhDAgIBgWwXAwEBAQE4NYIqAQEEAScTHCMFCwgDDhMlDwUlChoTiA4Kwn8VjVEUVEcHgl9hA5Zdhg2DYIohO4EuIw
X-IronPort-AV: E=Sophos;i="4.84,857,1355094000"; 
   d="scan'208";a="220097695"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 16 Mar 2013 20:40:05 +0100
To: Benson Leung <bleung@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, olofj@chromium.org, djkurtz@chromium.org,
        dudl@cypress.com
Subject: Re: [PATCH 1/4] Input: cyapa - Move common initialization to
 cyapa_detect
Message-ID: <20130316194005.GA6086@polaris.bitmath.org>
References: <1363218651-22457-1-git-send-email-bleung@chromium.org>
 <1363218651-22457-2-git-send-email-bleung@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363218651-22457-2-git-send-email-bleung@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benson,

> cyapa_check_is_operational and cyapa_create_input_dev are common to
> the probe and firmware update paths. Pull those out into
> cyapa_detect.
> 
> Signed-off-by: Benson Leung <bleung@chromium.org>
> ---
>  drivers/input/mouse/cyapa.c | 57 +++++++++++++++++++++++++++++++--------------
>  1 file changed, 39 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
> index b409c3d..a631aca 100644
> --- a/drivers/input/mouse/cyapa.c
> +++ b/drivers/input/mouse/cyapa.c
> @@ -823,6 +823,40 @@ err_free_device:
>  	return ret;
>  }
>  
> +static void cyapa_detect(struct cyapa *cyapa)

No error return here?

> +{
> +	struct device *dev = &cyapa->client->dev;
> +	int ret;
> +
> +	ret = cyapa_check_is_operational(cyapa);
> +	if (ret == -ETIMEDOUT)
> +		dev_err(dev, "no device detected, %d\n", ret);
> +	else if (ret)
> +		dev_err(dev, "device detected, but not operational, %d\n", ret);
> +
> +	if (!cyapa->input) {

Return here saves you the ugly indentation.

> +		ret = cyapa_create_input_dev(cyapa);
> +		if (ret)
> +			dev_err(dev, "create input_dev instance failed, %d\n",
> +				ret);
> +
> +		enable_irq(cyapa->irq);
> +		/*
> +		 * On some systems, a system crash / warm boot does not reset
> +		 * the device's current power mode to FULL_ACTIVE.
> +		 * If such an event happens during suspend, after the device
> +		 * has been put in a low power mode, the device will still be
> +		 * in low power mode on a subsequent boot, since there was
> +		 * never a matching resume().
> +		 * Handle this by always forcing full power here, when a
> +		 * device is first detected to be in operational mode.
> +		 */
> +		ret = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
> +		if (ret)
> +			dev_warn(dev, "set active power failed, %d\n", ret);
> +	}
> +}
> +
>  static int cyapa_probe(struct i2c_client *client,
>  		       const struct i2c_device_id *dev_id)
>  {
> @@ -853,23 +887,8 @@ static int cyapa_probe(struct i2c_client *client,
>  	if (adapter_func == CYAPA_ADAPTER_FUNC_SMBUS)
>  		cyapa->smbus = true;
>  	cyapa->state = CYAPA_STATE_NO_DEVICE;
> -	ret = cyapa_check_is_operational(cyapa);
> -	if (ret) {
> -		dev_err(dev, "device not operational, %d\n", ret);
> -		goto err_mem_free;
> -	}
>  
> -	ret = cyapa_create_input_dev(cyapa);
> -	if (ret) {
> -		dev_err(dev, "create input_dev instance failed, %d\n", ret);
> -		goto err_mem_free;
> -	}
> -
> -	ret = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
> -	if (ret) {
> -		dev_err(dev, "set active power failed, %d\n", ret);
> -		goto err_unregister_device;
> -	}
> +	cyapa_detect(cyapa);

Replacing proper error handling with a silent function seems wrong.

>  
>  	cyapa->irq = client->irq;
>  	ret = request_threaded_irq(cyapa->irq,
> @@ -886,8 +905,8 @@ static int cyapa_probe(struct i2c_client *client,
>  	return 0;
>  
>  err_unregister_device:
> -	input_unregister_device(cyapa->input);
> -err_mem_free:
> +	if (cyapa->input)
> +		input_unregister_device(cyapa->input);
>  	kfree(cyapa);
>  
>  	return ret;
> @@ -937,6 +956,8 @@ static int cyapa_resume(struct device *dev)
>  	if (device_may_wakeup(dev) && cyapa->irq_wake)
>  		disable_irq_wake(cyapa->irq);
>  
> +	cyapa_detect(cyapa);
> +

Ditto.

>  	ret = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
>  	if (ret)
>  		dev_warn(dev, "resume active power failed, %d\n", ret);
> -- 
> 1.8.1.3
> 

Thanks,
Henrik

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaKJIqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 03:46:06 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37067 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaKJIqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 03:46:03 -0500
Date: Mon, 10 Nov 2014 09:46:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v5 18/48] mfd: twl4030-power: Register with kernel
 power-off handler
Message-ID: <20141110084600.GA2582@amd>
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
 <1415292213-28652-19-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415292213-28652-19-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> @@ -611,7 +611,7 @@ twl4030_power_configure_resources(const struct twl4030_power_data *pdata)
>   * After a successful execution, TWL shuts down the power to the SoC
>   * and all peripherals connected to it.
>   */
> -void twl4030_power_off(void)
> +static void twl4030_power_off(struct power_off_handler_block *this)
>  {
>  	int err;
>  
> @@ -621,6 +621,11 @@ void twl4030_power_off(void)
>  		pr_err("TWL4030 Unable to power off\n");
>  }
>  
> +static struct power_off_handler_block twl4030_power_off_hb = {
> +	.handler = twl4030_power_off,
> +	.priority = POWER_OFF_PRIORITY_LOW,
> +};
> +
>  static bool twl4030_power_use_poweroff(const struct twl4030_power_data *pdata,
>  					struct device_node *node)
>  {
> @@ -839,7 +844,9 @@ static int twl4030_power_probe(struct platform_device *pdev)
>  	}
>  
>  	/* Board has to be wired properly to use this feature */
> -	if (twl4030_power_use_poweroff(pdata, node) && !pm_power_off) {
> +	if (twl4030_power_use_poweroff(pdata, node)) {
> +		int ret;
> +
>  		/* Default for SEQ_OFFSYNC is set, lets ensure this */
>  		err = twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &val,
>  				      TWL4030_PM_MASTER_CFG_P123_TRANSITION);
> @@ -856,7 +863,11 @@ static int twl4030_power_probe(struct platform_device *pdev)
>  			}
>  		}
>  
> -		pm_power_off = twl4030_power_off;
> +		ret = devm_register_power_off_handler(&pdev->dev,
> +						      &twl4030_power_off_hb);
> +		if (ret)
> +			dev_warn(&pdev->dev,
> +				 "Failed to register power-off handler\n");
>  	}
>  

Could we get rid of the "struct power_off_handler_block" and guarantee
that register_power_off never fails (or print message from the
register_power_off...)? That way, your patch would be an cleanup.

You could then add priorities if they turn out to be really
neccessary, later...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

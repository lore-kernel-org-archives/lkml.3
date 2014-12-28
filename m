Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaL1PZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 10:25:26 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62954 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaL1PZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 10:25:25 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 3/3] i8k: Remove laptop specific config data (fan_mult, fan_max) from driver
Date: Sun, 28 Dec 2014 16:25:21 +0100
Message-ID: <2326199.sB2oUjFZgt@xps13>
User-Agent: KMail/4.14.2 (Linux/3.19.0-rc1+; KDE/4.14.2; x86_64; ; )
In-Reply-To: <201412280946.19550@pali>
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <20141228082820.GB31346@roeck-us.net> <201412280946.19550@pali>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 December 2014 09:46:19 Pali Rohár wrote:
> Ok, here are new patches for testing... Those you are still reading this email thread and have your Dell 
> machines near, can you test them (ideally with disabling dmi config data)?

Could you please tell me exactly against what should I apply these
patches? I can see that they depend on other patches in this thread,
but I can't find any tree that includes them.

> diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> index 8ec4c37..d6e8a26 100644
> --- a/drivers/char/i8k.c
> +++ b/drivers/char/i8k.c
> @@ -64,9 +64,9 @@ static DEFINE_MUTEX(i8k_mutex);
>  static char bios_version[4];
>  static struct device *i8k_hwmon_dev;
>  static u32 i8k_hwmon_flags;
> -static int i8k_fan_mult;
> -static int i8k_pwm_mult;
> -static int i8k_fan_max = I8K_FAN_HIGH;
> +static uint i8k_fan_mult;
> +static uint i8k_pwm_mult;
> +static uint i8k_fan_max = I8K_FAN_HIGH;
>  
>  #define I8K_HWMON_HAVE_TEMP1	(1 << 0)
>  #define I8K_HWMON_HAVE_TEMP2	(1 << 1)
> @@ -95,12 +95,12 @@ static bool power_status;
>  module_param(power_status, bool, 0600);
>  MODULE_PARM_DESC(power_status, "Report power status in /proc/i8k");
>  
> -static int fan_mult = I8K_FAN_MULT;
> -module_param(fan_mult, int, 0);
> +static uint fan_mult = I8K_FAN_MULT;
> +module_param(fan_mult, uint, 0);
>  MODULE_PARM_DESC(fan_mult, "Factor to multiply fan speed with");
>  
> -static int fan_max = I8K_FAN_HIGH;
> -module_param(fan_max, int, 0);
> +static uint fan_max = I8K_FAN_HIGH;
> +module_param(fan_max, uint, 0);
>  MODULE_PARM_DESC(fan_max, "Maximum configurable fan speed");
>  
>  static int i8k_open_fs(struct inode *inode, struct file *file);
> @@ -696,8 +696,8 @@ static int __init i8k_init_hwmon(void)
>  }
>  
>  struct i8k_config_data {
> -	int fan_mult;
> -	int fan_max;
> +	uint fan_mult;
> +	uint fan_max;
>  };
>  
>  enum i8k_configs {
> 
> 
> 
> diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> index d6e8a26..6ad0872 100644
> --- a/drivers/char/i8k.c
> +++ b/drivers/char/i8k.c
> @@ -6,6 +6,7 @@
>   * Hwmon integration:
>   * Copyright (C) 2011  Jean Delvare <jdelvare@suse.de>
>   * Copyright (C) 2013, 2014  Guenter Roeck <linux@roeck-us.net>
> + * Copyright (C) 2014  Pali Rohár <pali.rohar@gmail.com>
>   *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms of the GNU General Public License as published by the
> @@ -42,12 +43,14 @@
>  #define I8K_SMM_SET_FAN		0x01a3
>  #define I8K_SMM_GET_FAN		0x00a3
>  #define I8K_SMM_GET_SPEED	0x02a3
> +#define I8K_SMM_GET_NOM_SPEED	0x04a3
>  #define I8K_SMM_GET_TEMP	0x10a3
>  #define I8K_SMM_GET_TEMP_TYPE	0x11a3
>  #define I8K_SMM_GET_DELL_SIG1	0xfea3
>  #define I8K_SMM_GET_DELL_SIG2	0xffa3
>  
>  #define I8K_FAN_MULT		30
> +#define I8K_FAN_MAX_RPM		30000
>  #define I8K_MAX_TEMP		127
>  
>  #define I8K_FN_NONE		0x00
> @@ -64,7 +67,7 @@ static DEFINE_MUTEX(i8k_mutex);
>  static char bios_version[4];
>  static struct device *i8k_hwmon_dev;
>  static u32 i8k_hwmon_flags;
> -static uint i8k_fan_mult;
> +static uint i8k_fan_mult = I8K_FAN_MULT;
>  static uint i8k_pwm_mult;
>  static uint i8k_fan_max = I8K_FAN_HIGH;
>  
> @@ -95,13 +98,13 @@ static bool power_status;
>  module_param(power_status, bool, 0600);
>  MODULE_PARM_DESC(power_status, "Report power status in /proc/i8k");
>  
> -static uint fan_mult = I8K_FAN_MULT;
> +static uint fan_mult;
>  module_param(fan_mult, uint, 0);
> -MODULE_PARM_DESC(fan_mult, "Factor to multiply fan speed with");
> +MODULE_PARM_DESC(fan_mult, "Factor to multiply fan speed with (default: autodetect)");
>  
> -static uint fan_max = I8K_FAN_HIGH;
> +static uint fan_max;
>  module_param(fan_max, uint, 0);
> -MODULE_PARM_DESC(fan_max, "Maximum configurable fan speed");
> +MODULE_PARM_DESC(fan_max, "Maximum configurable fan speed (default: autodetect)");
>  
>  static int i8k_open_fs(struct inode *inode, struct file *file);
>  static long i8k_ioctl(struct file *, unsigned int, unsigned long);
> @@ -276,6 +279,17 @@ static int i8k_get_fan_speed(int fan)
>  }
>  
>  /*
> + * Read the fan nominal rpm for specific fan speed.
> + */
> +static int i8k_get_fan_nominal_speed(int fan, int speed)
> +{
> +	struct smm_regs regs = { .eax = I8K_SMM_GET_NOM_SPEED, };
> +
> +	regs.ebx = (fan & 0xff) | (speed << 8);
> +	return i8k_smm(&regs) ? : (regs.eax & 0xffff) * i8k_fan_mult;
> +}
> +
> +/*
>   * Set the fan speed (off, low, high). Returns the new fan status.
>   */
>  static int i8k_set_fan(int fan, int speed)
> @@ -863,6 +877,7 @@ MODULE_DEVICE_TABLE(dmi, i8k_dmi_table);
>  static int __init i8k_probe(void)
>  {
>  	const struct dmi_system_id *id;
> +	int fan, ret;
>  
>  	/*
>  	 * Get DMI information
> @@ -891,19 +906,40 @@ static int __init i8k_probe(void)
>  			return -ENODEV;
>  	}
>  
> -	i8k_fan_mult = fan_mult;
> -	i8k_fan_max = fan_max ? : I8K_FAN_HIGH;	/* Must not be 0 */
> +	/*
> +	 * Set fan multiplier and maximal fan speed from dmi config
> +	 * Values specified in module parameters override values from dmi
> +	 */
>  	id = dmi_first_match(i8k_dmi_table);
>  	if (id && id->driver_data) {
>  		const struct i8k_config_data *conf = id->driver_data;
> -
> -		if (fan_mult == I8K_FAN_MULT && conf->fan_mult)
> -			i8k_fan_mult = conf->fan_mult;
> -		if (fan_max == I8K_FAN_HIGH && conf->fan_max)
> -			i8k_fan_max = conf->fan_max;
> +		if (!fan_mult && conf->fan_mult)
> +			fan_mult = conf->fan_mult;
> +		if (!fan_max && conf->fan_max)
> +			fan_max = conf->fan_max;
>  	}
> +
> +	i8k_fan_max = fan_max ? : I8K_FAN_HIGH;	/* Must not be 0 */
>  	i8k_pwm_mult = DIV_ROUND_UP(255, i8k_fan_max);
>  
> +	if (!fan_mult) {
> +		/*
> +		 * Autodetect fan multiplier based on nominal rpm
> +		 * If fan reports rpm value too high then set multiplier to 1
> +		 */
> +		for (fan = 0; fan < 2; ++fan) {
> +			ret = i8k_get_fan_nominal_speed(fan, i8k_fan_max);
> +			if (ret < 0)
> +				continue;
> +			if (ret > I8K_FAN_MAX_RPM)
> +				i8k_fan_mult = 1;
> +			break;
> +		}
> +	} else {
> +		/* Fan multiplier was specified in module param or in dmi */
> +		i8k_fan_mult = fan_mult;
> +	}
> +
>  	return 0;
>  }
>  
> 
> 


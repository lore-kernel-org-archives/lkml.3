Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaLUL5j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 06:57:39 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:43106 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaLUL5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 06:57:37 -0500
Message-ID: <5496B594.6050205@roeck-us.net>
Date: Sun, 21 Dec 2014 03:57:08 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>
Subject: Re: [PATCH v3] i8k: Autodetect maximal fan speed and fan RPM multiplier
References: <1419012268-20805-1-git-send-email-pali.rohar@gmail.com> <1419153618-6930-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1419153618-6930-1-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.5496B5CE.013E,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 6
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2014 01:20 AM, Pali Rohár wrote:
> This patch adds new function i8k_get_fan_nominal_speed() for doing SMM call
> which will return nominal fan RPM for specified fan speed. It returns nominal
> RPM value at which fan operate when speed (0, 1, 2, 3) is set. It looks like
> RPM value is not accurate, but still provides very useful information.
>
> First it can be used to validate if certain fan speed could be accepted by SMM
> for setting fan speed and we can use this routine to detect maximal fan speed.
>
> Second it returns RPM value, so we can check if value looks correct with
> multiplier 30 or multiplier 1 (until now only these two multiplier were used).
> If RPM value with multiplier 30 is too high, then multiplier 1 is used.
>
> In case when SMM reports that new function is not supported we will fallback
> to old hardcoded values. Maximal fan speed would be 2 and RPM multiplier 30.
>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Tested-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>   drivers/char/i8k.c |   89 ++++++++++++++++++++++++++++++++++++++++++++--------
>   1 file changed, 76 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> index 48d701c..ce2147c 100644
> --- a/drivers/char/i8k.c
> +++ b/drivers/char/i8k.c
> @@ -6,6 +6,7 @@
>    * Hwmon integration:
>    * Copyright (C) 2011  Jean Delvare <jdelvare@suse.de>
>    * Copyright (C) 2013, 2014  Guenter Roeck <linux@roeck-us.net>
> + * Copyright (C) 2014  Pali Rohár <pali.rohar@gmail.com>
>    *
>    * This program is free software; you can redistribute it and/or modify it
>    * under the terms of the GNU General Public License as published by the
> @@ -42,12 +43,13 @@
>   #define I8K_SMM_SET_FAN		0x01a3
>   #define I8K_SMM_GET_FAN		0x00a3
>   #define I8K_SMM_GET_SPEED	0x02a3
> +#define I8K_SMM_GET_NOM_SPEED	0x04a3
>   #define I8K_SMM_GET_TEMP	0x10a3
>   #define I8K_SMM_GET_TEMP_TYPE	0x11a3
>   #define I8K_SMM_GET_DELL_SIG1	0xfea3
>   #define I8K_SMM_GET_DELL_SIG2	0xffa3
>
> -#define I8K_FAN_MULT		30
> +#define I8K_FAN_MAX_RPM		30000
>   #define I8K_MAX_TEMP		127
>
>   #define I8K_FN_NONE		0x00
> @@ -64,7 +66,7 @@ static DEFINE_MUTEX(i8k_mutex);
>   static char bios_version[4];
>   static struct device *i8k_hwmon_dev;
>   static u32 i8k_hwmon_flags;
> -static int i8k_fan_mult;
> +static int i8k_fan_mult = 30;

Why did you drop I8K_FAN_MULT ?

>   static int i8k_pwm_mult;
>   static int i8k_fan_max = I8K_FAN_HIGH;
>
> @@ -95,13 +97,13 @@ static bool power_status;
>   module_param(power_status, bool, 0600);
>   MODULE_PARM_DESC(power_status, "Report power status in /proc/i8k");
>
> -static int fan_mult = I8K_FAN_MULT;
> +static int fan_mult;
>   module_param(fan_mult, int, 0);
> -MODULE_PARM_DESC(fan_mult, "Factor to multiply fan speed with");
> +MODULE_PARM_DESC(fan_mult, "Factor to multiply fan speed with (default: autodetect)");
>
> -static int fan_max = I8K_FAN_HIGH;
> +static int fan_max;
>   module_param(fan_max, int, 0);
> -MODULE_PARM_DESC(fan_max, "Maximum configurable fan speed");
> +MODULE_PARM_DESC(fan_max, "Maximum configurable fan speed (default: autodetect)");
>
>   static int i8k_open_fs(struct inode *inode, struct file *file);
>   static long i8k_ioctl(struct file *, unsigned int, unsigned long);
> @@ -276,6 +278,17 @@ static int i8k_get_fan_speed(int fan)
>   }
>
>   /*
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
>    * Set the fan speed (off, low, high). Returns the new fan status.
>    */
>   static int i8k_set_fan(int fan, int speed)
> @@ -854,7 +867,9 @@ MODULE_DEVICE_TABLE(dmi, i8k_dmi_table);
>    */
>   static int __init i8k_probe(void)
>   {
> +	const struct i8k_config_data *conf;

Why did you move this variable declaration ?

>   	const struct dmi_system_id *id;
> +	int fan, val, ret;
>
>   	/*
>   	 * Get DMI information
> @@ -883,19 +898,67 @@ static int __init i8k_probe(void)
>   			return -ENODEV;
>   	}
>
> -	i8k_fan_mult = fan_mult;
> -	i8k_fan_max = fan_max ? : I8K_FAN_HIGH;	/* Must not be 0 */
> +	/*
> +	 * Autodetect fan multiplier and maximal fan speed from dmi config
> +	 * Values specified in module parameters override values from dmi
> +	 */
>   	id = dmi_first_match(i8k_dmi_table);
>   	if (id && id->driver_data) {
> -		const struct i8k_config_data *conf = id->driver_data;
> +		conf = id->driver_data;
> +		if (fan_mult <= 0 && conf->fan_mult > 0)

I still don't see the value in accepting fan_mult < 0 (compeared to == 0).

> +			fan_mult = conf->fan_mult;
> +		if (fan_max <= 0 && conf->fan_max > 0)

Same for fan_max < 0.

> +			fan_max = conf->fan_max;
> +	}
>
> -		if (fan_mult == I8K_FAN_MULT && conf->fan_mult)
> -			i8k_fan_mult = conf->fan_mult;
> -		if (fan_max == I8K_FAN_HIGH && conf->fan_max)
> -			i8k_fan_max = conf->fan_max;
> +	if (fan_max <= 0) {

Same here.

> +		/*
> +		 * Autodetect maximal fan speed value
> +		 * Speed value is valid if i8k_get_fan_nominal_speed() not fail
> +		 */
> +		for (fan = 0; fan < 2; ++fan) {
> +			for (val = 1; val < 256; ++val) {
> +				if (i8k_get_fan_nominal_speed(fan, val) < 0)
> +					break;
> +				fan_max = val; /* Must not be 0 */
> +			}
> +			if (fan_max != 0) {
> +				i8k_fan_max = fan_max;
> +				break;
> +			}
> +		}
> +	} else {
> +		/* Maximal fan speed was specified in module param or in dmi */
> +		i8k_fan_max = fan_max;
>   	}
> +
>   	i8k_pwm_mult = DIV_ROUND_UP(255, i8k_fan_max);
>
> +	if (fan_mult <= 0) {

Same here.

Thanks,
Guenter


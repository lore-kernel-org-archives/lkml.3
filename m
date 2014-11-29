Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaK2QYP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 11:24:15 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:54287 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaK2QYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 11:24:13 -0500
Message-ID: <5479F328.7080304@roeck-us.net>
Date: Sat, 29 Nov 2014 08:24:08 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Steven Honeyman <stevenhoneyman@gmail.com>, linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.5479F32C.01C8,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
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

On 11/29/2014 08:04 AM, Pali Rohár wrote:
> This patch adds labels for temperature sensors if SMM function with EAX register
> 0x11a3 reports it. These informations was taken from DOS binary NBSVC.MDM.
>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>   drivers/char/i8k.c |  110 +++++++++++++++++++++++++++++++++++++++++-----------
>   1 file changed, 88 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> index e34a019..77af46b 100644
> --- a/drivers/char/i8k.c
> +++ b/drivers/char/i8k.c
> @@ -42,6 +42,7 @@
>   #define I8K_SMM_GET_FAN		0x00a3
>   #define I8K_SMM_GET_SPEED	0x02a3
>   #define I8K_SMM_GET_TEMP	0x10a3
> +#define I8K_SMM_GET_TEMP_TYPE	0x11a3
>   #define I8K_SMM_GET_DELL_SIG1	0xfea3
>   #define I8K_SMM_GET_DELL_SIG2	0xffa3
>
> @@ -288,6 +289,14 @@ static int i8k_set_fan(int fan, int speed)
>   	return i8k_smm(&regs) ? : i8k_get_fan_status(fan);
>   }
>
> +static int i8k_get_temp_type(int sensor)
> +{
> +	struct smm_regs regs = { .eax = I8K_SMM_GET_TEMP_TYPE, };
> +
> +	regs.ebx = sensor & 0xff;
> +	return i8k_smm(&regs) ? : regs.eax & 0xff;
> +}
> +
>   /*
>    * Read the cpu temperature.
>    */
> @@ -493,6 +502,29 @@ static int i8k_open_fs(struct inode *inode, struct file *file)
>    * Hwmon interface
>    */
>
> +static ssize_t i8k_hwmon_show_temp_label(struct device *dev,
> +				   struct device_attribute *devattr,
> +				   char *buf)
> +{
> +	static const char * const labels[] = {
> +		"CPU",
> +		"GPU",
> +		"SODIMM",
> +		"Other",
> +		"Ambient",
> +		"Other",
> +	};
> +	int index = to_sensor_dev_attr(devattr)->index;
> +	int type;
> +
> +	type = i8k_get_temp_type(index);
> +	if (type < 0)
> +		return type;
> +	if (type >= ARRAY_SIZE(labels))
> +		type = ARRAY_SIZE(labels) - 1;
> +	return sprintf(buf, "%s\n", labels[type]);
> +}
> +
>   static ssize_t i8k_hwmon_show_temp(struct device *dev,
>   				   struct device_attribute *devattr,
>   				   char *buf)
> @@ -555,9 +587,13 @@ static ssize_t i8k_hwmon_set_pwm(struct device *dev,
>   }
>
>   static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, i8k_hwmon_show_temp, NULL, 0);
> +static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, i8k_hwmon_show_temp_label, NULL, 0);
>   static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO, i8k_hwmon_show_temp, NULL, 1);
> +static SENSOR_DEVICE_ATTR(temp2_label, S_IRUGO, i8k_hwmon_show_temp_label, NULL, 1);
>   static SENSOR_DEVICE_ATTR(temp3_input, S_IRUGO, i8k_hwmon_show_temp, NULL, 2);
> +static SENSOR_DEVICE_ATTR(temp3_label, S_IRUGO, i8k_hwmon_show_temp_label, NULL, 2);
>   static SENSOR_DEVICE_ATTR(temp4_input, S_IRUGO, i8k_hwmon_show_temp, NULL, 3);
> +static SENSOR_DEVICE_ATTR(temp4_label, S_IRUGO, i8k_hwmon_show_temp_label, NULL, 3);
>   static SENSOR_DEVICE_ATTR(fan1_input, S_IRUGO, i8k_hwmon_show_fan, NULL,
>   			  I8K_FAN_LEFT);
>   static SENSOR_DEVICE_ATTR(pwm1, S_IRUGO | S_IWUSR, i8k_hwmon_show_pwm,
> @@ -569,31 +605,35 @@ static SENSOR_DEVICE_ATTR(pwm2, S_IRUGO | S_IWUSR, i8k_hwmon_show_pwm,
>
>   static struct attribute *i8k_attrs[] = {
>   	&sensor_dev_attr_temp1_input.dev_attr.attr,	/* 0 */
> -	&sensor_dev_attr_temp2_input.dev_attr.attr,	/* 1 */
> -	&sensor_dev_attr_temp3_input.dev_attr.attr,	/* 2 */
> -	&sensor_dev_attr_temp4_input.dev_attr.attr,	/* 3 */
> -	&sensor_dev_attr_fan1_input.dev_attr.attr,	/* 4 */
> -	&sensor_dev_attr_pwm1.dev_attr.attr,		/* 5 */
> -	&sensor_dev_attr_fan2_input.dev_attr.attr,	/* 6 */
> -	&sensor_dev_attr_pwm2.dev_attr.attr,		/* 7 */
> +	&sensor_dev_attr_temp1_label.dev_attr.attr,	/* 1 */
> +	&sensor_dev_attr_temp2_input.dev_attr.attr,	/* 2 */
> +	&sensor_dev_attr_temp2_label.dev_attr.attr,	/* 3 */
> +	&sensor_dev_attr_temp3_input.dev_attr.attr,	/* 4 */
> +	&sensor_dev_attr_temp3_label.dev_attr.attr,	/* 5 */
> +	&sensor_dev_attr_temp4_input.dev_attr.attr,	/* 6 */
> +	&sensor_dev_attr_temp4_label.dev_attr.attr,	/* 7 */
> +	&sensor_dev_attr_fan1_input.dev_attr.attr,	/* 8 */
> +	&sensor_dev_attr_pwm1.dev_attr.attr,		/* 9 */
> +	&sensor_dev_attr_fan2_input.dev_attr.attr,	/* 10 */
> +	&sensor_dev_attr_pwm2.dev_attr.attr,		/* 11 */
>   	NULL
>   };
>
>   static umode_t i8k_is_visible(struct kobject *kobj, struct attribute *attr,
>   			      int index)
>   {
> -	if (index == 0 && !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP1))
> +	if (index >= 0 && index <= 1 && !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP1))
>   		return 0;
> -	if (index == 1 && !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP2))
> +	if (index >= 2 && index <= 3 && !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP2))
>   		return 0;
> -	if (index == 2 && !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP3))
> +	if (index >= 4 && index <= 5 && !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP3))
>   		return 0;
> -	if (index == 3 && !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP4))
> +	if (index >= 6 && index <= 7 && !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP4))
>   		return 0;
> -	if (index >= 4 && index <= 5 &&
> +	if (index >= 8 && index <= 9 &&
>   	    !(i8k_hwmon_flags & I8K_HWMON_HAVE_FAN1))
>   		return 0;
> -	if (index >= 6 && index <= 7 &&
> +	if (index >= 10 && index <= 11 &&
>   	    !(i8k_hwmon_flags & I8K_HWMON_HAVE_FAN2))
>   		return 0;
>
> @@ -606,6 +646,37 @@ static const struct attribute_group i8k_group = {
>   };
>   __ATTRIBUTE_GROUPS(i8k);
>
> +static bool __init i8k_check_temp(int sensor)
> +{
> +	int err;
> +
> +	/*
> +	 * Check if temperature sensor type is valid.
> +	 *
> +	 * If it is valid then sensor should work. But some sensors are not
> +	 * available at any time. E.g GPU sensor on Optimus/PowerExpress/Enduro
> +	 * card does not work (or return bogus value) when card is turned off.
> +	 * So this function should not fail in this case.
> +	 */
> +	err = i8k_get_temp_type(sensor);
> +	if (err >= 0)
> +		return true;
> +
Are you sure this function is provided for all systems ?
I am a bit concerned that we may wrongly disable sensors this way,
especially on older systems.

It might be safer to create another set of flags and enable the labels
only if the sensor is known to exist and if reading its type (label) works.

> +	/*
> +	 * Check if temperatrue reading does not fail.
> +	 *
temperature

> +	 * Sometimes detection of temperature sensor type does not work but
> +	 * reading temperature working fine. Sometimes temperature value is too
> +	 * high and i8k_get_temp() returns -ERANGE. But there is no reason to
> +	 * ignore these temperature sensors.
> +	 */
> +	err = i8k_get_temp(sensor);
> +	if (err >= 0 || err == -ERANGE)
> +		return true;
> +

Please simplify to
	return err >= 0 || err == -ERANGE;

> +	return false;
> +}
> +
>   static int __init i8k_init_hwmon(void)
>   {
>   	int err;
> @@ -613,18 +684,13 @@ static int __init i8k_init_hwmon(void)
>   	i8k_hwmon_flags = 0;
>
>   	/* CPU temperature attributes, if temperature reading is OK */
> -	err = i8k_get_temp(0);
> -	if (err >= 0 || err == -ERANGE)
> +	if (i8k_check_temp(0))

The introduction of i8k_check_temp() should be a separate patch.

Thanks,
Guenter

>   		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP1;
> -	/* check for additional temperature sensors */
> -	err = i8k_get_temp(1);
> -	if (err >= 0 || err == -ERANGE)
> +	if (i8k_check_temp(1))
>   		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP2;
> -	err = i8k_get_temp(2);
> -	if (err >= 0 || err == -ERANGE)
> +	if (i8k_check_temp(2))
>   		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP3;
> -	err = i8k_get_temp(3);
> -	if (err >= 0 || err == -ERANGE)
> +	if (i8k_check_temp(3))
>   		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP4;
>
>   	/* Left fan attributes, if left fan is present */
>


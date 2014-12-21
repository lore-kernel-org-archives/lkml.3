Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbaLUXBy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 18:01:54 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:47088 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbaLUXBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 18:01:53 -0500
Message-ID: <5497515D.9060106@roeck-us.net>
Date: Sun, 21 Dec 2014 15:01:49 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] i8k: Add support for fan labels
References: <1419191683-31435-1-git-send-email-pali.rohar@gmail.com> <1419191683-31435-11-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1419191683-31435-11-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.54975161.010B,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 9
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

On 12/21/2014 11:54 AM, Pali Rohár wrote:
> This patch adds labels support for fans if SMM function with EAX register
> 0x03a3 reports it. This information was taken from DOS binary NBSVC.MDM.
>
> Additionally this patch change detection of fan presece. Instead reading fan
> status now detection is based on new label SMM function. Dell DOS binary
> NBSVC.MDM is doing similar checks, so we should do that too.
>
> This patch also remove I8K_FAN_LEFT and I8K_FAN_RIGHT usage from hwmon driver
> part because that names does not make sense anymore. So numeric constants are
> used instead. Original /proc/i8k ioctl part was not changed for compatibility
> reasons.
>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>   drivers/char/i8k.c |   76 ++++++++++++++++++++++++++++++++++++++++++----------
>   1 file changed, 62 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> index 9288edb..ca4203c 100644
> --- a/drivers/char/i8k.c
> +++ b/drivers/char/i8k.c
> @@ -43,6 +43,7 @@
>   #define I8K_SMM_SET_FAN		0x01a3
>   #define I8K_SMM_GET_FAN		0x00a3
>   #define I8K_SMM_GET_SPEED	0x02a3
> +#define I8K_SMM_GET_FAN_TYPE	0x03a3
>   #define I8K_SMM_GET_NOM_SPEED	0x04a3
>   #define I8K_SMM_GET_TEMP	0x10a3
>   #define I8K_SMM_GET_TEMP_TYPE	0x11a3
> @@ -279,6 +280,17 @@ static int i8k_get_fan_speed(int fan)
>   }
>
>   /*
> + * Read the fan type.
> + */
> +static int i8k_get_fan_type(int fan)
> +{
> +	struct smm_regs regs = { .eax = I8K_SMM_GET_FAN_TYPE, };
> +
> +	regs.ebx = fan & 0xff;
> +	return i8k_smm(&regs) ? : regs.eax & 0xff;
> +}
> +
> +/*
>    * Read the fan nominal rpm for specific fan speed.
>    */
>   static int i8k_get_fan_nominal_speed(int fan, int speed)
> @@ -553,6 +565,37 @@ static ssize_t i8k_hwmon_show_temp(struct device *dev,
>   	return sprintf(buf, "%d\n", temp * 1000);
>   }
>
> +static ssize_t i8k_hwmon_show_fan_label(struct device *dev,
> +					struct device_attribute *devattr,
> +					char *buf)
> +{
> +	static const char * const labels[] = {
> +		"Processor Fan",
> +		"Motherboard Fan",
> +		"Video Fan",
> +		"Power Supply Fan",
> +		"Chipset Fan",
> +		"Other Fan",
> +	};
> +	int index = to_sensor_dev_attr(devattr)->index;
> +	bool dock = false;
> +	int type;
> +
> +	type = i8k_get_fan_type(index);
> +	if (type < 0)
> +		return type;
> +
> +	if (type & 0x10) {
> +		dock = true;
> +		type &= 0x0F;
> +	}
> +
What if bit 5..7 is set ? This would result in a result of "other fan",
which given the above does not seem to be correct. Given that, I wonder
why the type mask is only applied if bit 4 is set and not unconditionally.

Thanks,
Guenter

> +	if (type >= ARRAY_SIZE(labels))
> +		type = (ARRAY_SIZE(labels) - 1);
> +
> +	return sprintf(buf, "%s%s\n", (dock ? "Docking " : ""), labels[type]);
> +}
> +
>   static ssize_t i8k_hwmon_show_fan(struct device *dev,
>   				  struct device_attribute *devattr,
>   				  char *buf)
> @@ -611,14 +654,17 @@ static SENSOR_DEVICE_ATTR(temp3_label, S_IRUGO, i8k_hwmon_show_temp_label, NULL,
>   static SENSOR_DEVICE_ATTR(temp4_input, S_IRUGO, i8k_hwmon_show_temp, NULL, 3);
>   static SENSOR_DEVICE_ATTR(temp4_label, S_IRUGO, i8k_hwmon_show_temp_label, NULL,
>   			  3);
> -static SENSOR_DEVICE_ATTR(fan1_input, S_IRUGO, i8k_hwmon_show_fan, NULL,
> -			  I8K_FAN_LEFT);
> +static SENSOR_DEVICE_ATTR(fan1_input, S_IRUGO, i8k_hwmon_show_fan, NULL, 0);
> +static SENSOR_DEVICE_ATTR(fan1_label, S_IRUGO, i8k_hwmon_show_fan_label, NULL,
> +			  0);
>   static SENSOR_DEVICE_ATTR(pwm1, S_IRUGO | S_IWUSR, i8k_hwmon_show_pwm,
> -			  i8k_hwmon_set_pwm, I8K_FAN_LEFT);
> +			  i8k_hwmon_set_pwm, 0);
>   static SENSOR_DEVICE_ATTR(fan2_input, S_IRUGO, i8k_hwmon_show_fan, NULL,
> -			  I8K_FAN_RIGHT);
> +			  1);
> +static SENSOR_DEVICE_ATTR(fan2_label, S_IRUGO, i8k_hwmon_show_fan_label, NULL,
> +			  1);
>   static SENSOR_DEVICE_ATTR(pwm2, S_IRUGO | S_IWUSR, i8k_hwmon_show_pwm,
> -			  i8k_hwmon_set_pwm, I8K_FAN_RIGHT);
> +			  i8k_hwmon_set_pwm, 1);
>
>   static struct attribute *i8k_attrs[] = {
>   	&sensor_dev_attr_temp1_input.dev_attr.attr,	/* 0 */
> @@ -630,9 +676,11 @@ static struct attribute *i8k_attrs[] = {
>   	&sensor_dev_attr_temp4_input.dev_attr.attr,	/* 6 */
>   	&sensor_dev_attr_temp4_label.dev_attr.attr,	/* 7 */
>   	&sensor_dev_attr_fan1_input.dev_attr.attr,	/* 8 */
> -	&sensor_dev_attr_pwm1.dev_attr.attr,		/* 9 */
> -	&sensor_dev_attr_fan2_input.dev_attr.attr,	/* 10 */
> -	&sensor_dev_attr_pwm2.dev_attr.attr,		/* 11 */
> +	&sensor_dev_attr_fan1_label.dev_attr.attr,	/* 9 */
> +	&sensor_dev_attr_pwm1.dev_attr.attr,		/* 10 */
> +	&sensor_dev_attr_fan2_input.dev_attr.attr,	/* 11 */
> +	&sensor_dev_attr_fan2_label.dev_attr.attr,	/* 12 */
> +	&sensor_dev_attr_pwm2.dev_attr.attr,		/* 13 */
>   	NULL
>   };
>
> @@ -651,10 +699,10 @@ static umode_t i8k_is_visible(struct kobject *kobj, struct attribute *attr,
>   	if (index >= 6 && index <= 7 &&
>   	    !(i8k_hwmon_flags & I8K_HWMON_HAVE_TEMP4))
>   		return 0;
> -	if (index >= 8 && index <= 9 &&
> +	if (index >= 8 && index <= 10 &&
>   	    !(i8k_hwmon_flags & I8K_HWMON_HAVE_FAN1))
>   		return 0;
> -	if (index >= 10 && index <= 11 &&
> +	if (index >= 11 && index <= 13 &&
>   	    !(i8k_hwmon_flags & I8K_HWMON_HAVE_FAN2))
>   		return 0;
>
> @@ -688,13 +736,13 @@ static int __init i8k_init_hwmon(void)
>   	if (err >= 0)
>   		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP4;
>
> -	/* Left fan attributes, if left fan is present */
> -	err = i8k_get_fan_status(I8K_FAN_LEFT);
> +	/* First fan attributes, if fan type is OK */
> +	err = i8k_get_fan_type(0);
>   	if (err >= 0)
>   		i8k_hwmon_flags |= I8K_HWMON_HAVE_FAN1;
>
> -	/* Right fan attributes, if right fan is present */
> -	err = i8k_get_fan_status(I8K_FAN_RIGHT);
> +	/* Second fan attributes, if fan type is OK */
> +	err = i8k_get_fan_type(1);
>   	if (err >= 0)
>   		i8k_hwmon_flags |= I8K_HWMON_HAVE_FAN2;
>
>


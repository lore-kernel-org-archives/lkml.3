Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbaLJOVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:21:46 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:49138 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbaLJOVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:21:44 -0500
Message-ID: <548856AF.8090805@roeck-us.net>
Date: Wed, 10 Dec 2014 06:20:31 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v5 1/3] hwmon: ina2xx: make shunt resistance configurable
 at run-time
References: <1418207937-11648-1-git-send-email-bgolaszewski@baylibre.com> <1418207937-11648-2-git-send-email-bgolaszewski@baylibre.com>
In-Reply-To: <1418207937-11648-2-git-send-email-bgolaszewski@baylibre.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.548856F7.03AD,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 5
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

On 12/10/2014 02:38 AM, Bartosz Golaszewski wrote:
> The shunt resistance can only be set via platform_data or device tree. This
> isn't suitable for devices in which the shunt resistance can change/isn't
> known at boot-time.
>
> Add a sysfs attribute that allows to read and set the shunt resistance.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>   drivers/hwmon/ina2xx.c | 74 ++++++++++++++++++++++++++++++++++++++++++++------
>   1 file changed, 65 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
> index e01feba..6e73add 100644
> --- a/drivers/hwmon/ina2xx.c
> +++ b/drivers/hwmon/ina2xx.c
> @@ -51,7 +51,6 @@
>   #define INA226_ALERT_LIMIT		0x07
>   #define INA226_DIE_ID			0xFF
>
> -

While nice, this is an unrelated change.

>   /* register count */
>   #define INA219_REGISTERS		6
>   #define INA226_REGISTERS		8
> @@ -65,6 +64,9 @@
>   /* worst case is 68.10 ms (~14.6Hz, ina219) */
>   #define INA2XX_CONVERSION_RATE		15
>
> +/* default shunt resistance */
> +#define INA2XX_RSHUNT_DEFAULT		10000
> +
>   enum ina2xx_ids { ina219, ina226 };
>
>   struct ina2xx_config {
> @@ -87,6 +89,8 @@ struct ina2xx_data {
>
>   	int kind;
>   	u16 regs[INA2XX_MAX_REGISTERS];
> +
> +	long rshunt;
>   };
>
>   static const struct ina2xx_config ina2xx_config[] = {
> @@ -110,6 +114,11 @@ static const struct ina2xx_config ina2xx_config[] = {
>   	},
>   };
>
> +static u16 ina2xx_calibration_val(const struct ina2xx_data *data)
> +{
> +	return data->config->calibration_factor / data->rshunt;
> +}
> +
>   static struct ina2xx_data *ina2xx_update_device(struct device *dev)
>   {
>   	struct ina2xx_data *data = dev_get_drvdata(dev);
> @@ -164,6 +173,13 @@ static int ina2xx_get_value(struct ina2xx_data *data, u8 reg)
>   		/* signed register, LSB=1mA (selected), in mA */
>   		val = (s16)data->regs[reg];
>   		break;
> +	case INA2XX_CALIBRATION:
> +		if (data->regs[reg] == 0)
> +			val = 0;
> +		else
> +			val = data->config->calibration_factor
> +						/ data->regs[reg];
> +		break;

This doesn't really make sense. What you want to show is rshunt, not the above.
I think it would be better to write a separate show function to display it.

>   	default:
>   		/* programmer goofed */
>   		WARN_ON_ONCE(1);
> @@ -187,6 +203,38 @@ static ssize_t ina2xx_show_value(struct device *dev,
>   			ina2xx_get_value(data, attr->index));
>   }
>
> +static ssize_t ina2xx_set_shunt(struct device *dev,
> +				struct device_attribute *da,
> +				const char *buf, size_t count)
> +{
> +	struct ina2xx_data *data = ina2xx_update_device(dev);
> +	unsigned long val;
> +	int status;
> +
> +	if (IS_ERR(data))
> +		return PTR_ERR(data);
> +
> +	status = kstrtoul(buf, 10, &val);
> +	if (status < 0)
> +		return status;
> +
> +	if (val == 0 ||
> +	    /* Values greater than the calibration factor make no sense. */
> +	    val > data->config->calibration_factor ||
> +	    val > LONG_MAX)

data->config->calibration_factor is <= LONG_MAX, so the second check is unnecessary.
Actually, given that calibration_factor is chip dependent and not necessarily known
by the user, it would make more sense to only bail out on == 0 and then use clamp_val
to limit the range to (1, data->config->calibration_factor).

Guenter


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbbAIOf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:35:26 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:39606 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbbAIOfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:35:25 -0500
Message-ID: <54AFE6E3.4050603@roeck-us.net>
Date: Fri, 09 Jan 2015 06:34:11 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCHv2] hwmon: (ina2xx) implement update_interval attribute
 for ina226
References: <1420804980-11637-1-git-send-email-bgolaszewski@baylibre.com>
In-Reply-To: <1420804980-11637-1-git-send-email-bgolaszewski@baylibre.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.54AFE742.0235,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
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

On 01/09/2015 04:03 AM, Bartosz Golaszewski wrote:
> This attribute allows to configure the update interval of ina226. Although
> the bus and shunt voltage conversion times remain hardcoded to 1.1 ms, we can
> now modify said interval by changing the averaging rate.
>
> While we're at it - add an additional variable to ina2xx_data, which holds
> the current configuration settings - this way we'll be able to restore the
> configuration in case of an unexpected chip reset.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>   Documentation/hwmon/ina2xx |   7 +++
>   drivers/hwmon/ina2xx.c     | 140 ++++++++++++++++++++++++++++++++++++++++++---
>   2 files changed, 140 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/hwmon/ina2xx b/Documentation/hwmon/ina2xx
> index 320dd69..450e3cc 100644
> --- a/Documentation/hwmon/ina2xx
> +++ b/Documentation/hwmon/ina2xx
> @@ -48,3 +48,10 @@ The shunt value in micro-ohms can be set via platform data or device tree at
>   compile-time or via the shunt_resistor attribute in sysfs at run-time. Please
>   refer to the Documentation/devicetree/bindings/i2c/ina2xx.txt for bindings
>   if the device tree is used.
> +
> +Additionally ina226 supports update_interval attribute as described in
> +Documentation/hwmon/sysfs-interface. Internally the interval is the sum of
> +bus and shunt voltage conversion times multiplied by the averaging rate. We
> +don't touch the conversion times and only modify the number of averages. The
> +lower limit of the update_interval is 2 ms, the upper limit is 2253 ms.
> +The actual programmed interval may vary from the desired value.
> diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
> index 49537ea..ce0319a 100644
> --- a/drivers/hwmon/ina2xx.c
> +++ b/drivers/hwmon/ina2xx.c
> @@ -68,6 +68,21 @@
>
>   #define INA2XX_RSHUNT_DEFAULT		10000
>
> +/* bit mask for reading the averaging setting in the configuration register */
> +#define INA226_AVG_RD_MASK		0x0E00
> +
> +#define INA226_READ_AVG(reg)		(((reg) & INA226_AVG_RD_MASK) >> 9)
> +#define INA226_SHIFT_AVG(val)		((val) << 9)
> +
> +/* common attrs, ina226 attrs and NULL */
> +#define INA2XX_MAX_ATTRIBUTE_GROUPS	3
> +
> +/*
> + * Both bus voltage and shunt voltage conversion times for ina226 are set
> + * to 0b0100 on POR, which translates to 2200 microseconds in total.
> + */
> +#define INA226_TOTAL_CONV_TIME_DEFAULT	2200
> +
>   enum ina2xx_ids { ina219, ina226 };
>
>   struct ina2xx_config {
> @@ -85,12 +100,14 @@ struct ina2xx_data {
>   	const struct ina2xx_config *config;
>
>   	long rshunt;
> +	u16 curr_config;
>
>   	struct mutex update_lock;
>   	bool valid;
>   	unsigned long last_updated;
>
>   	int kind;
> +	const struct attribute_group *groups[INA2XX_MAX_ATTRIBUTE_GROUPS];
>   	u16 regs[INA2XX_MAX_REGISTERS];
>   };
>
> @@ -115,6 +132,49 @@ static const struct ina2xx_config ina2xx_config[] = {
>   	},
>   };
>
> +/*
> + * Available averaging rates for ina226. The indices correspond with
> + * the bit values expected by the chip (according to the ina226 datasheet,
> + * table 3 AVG bit settings, found at
> + * http://www.ti.com/lit/ds/symlink/ina226.pdf.
> + */
> +static const int ina226_avg_tab[] = { 1, 4, 16, 64, 128, 256, 512, 1024 };
> +
> +static int ina226_avg_bits(int avg)
> +{
> +	int i;
> +
> +	/* Get the closest average from the tab. */
> +	for (i = 0; i < ARRAY_SIZE(ina226_avg_tab) - 1; i++) {
> +		if (avg <= (ina226_avg_tab[i] + ina226_avg_tab[i + 1]) / 2)
> +			break;
> +	}
> +
> +	return i; /* Return 0b0111 for values greater than 1024. */
> +}
> +
> +static int ina226_reg_to_interval(u16 config)
> +{
> +	int avg = ina226_avg_tab[INA226_READ_AVG(config)];
> +
> +	/*
> +	 * Multiply the total conversion time by the number of averages.
> +	 * Return the result in milliseconds.
> +	 */
> +	return DIV_ROUND_CLOSEST(avg * INA226_TOTAL_CONV_TIME_DEFAULT, 1000);
> +}
> +
> +static u16 ina226_interval_to_reg(int interval, u16 config)
> +{
> +	int avg, avg_bits;
> +
> +	avg = DIV_ROUND_CLOSEST(interval * 1000,
> +				INA226_TOTAL_CONV_TIME_DEFAULT);
> +	avg_bits = ina226_avg_bits(avg);
> +
> +	return (config & ~INA226_AVG_RD_MASK) | INA226_SHIFT_AVG(avg_bits);
> +}
> +
>   static int ina2xx_calibrate(struct ina2xx_data *data)
>   {
>   	return i2c_smbus_write_word_swapped(data->client, INA2XX_CALIBRATION,
> @@ -131,7 +191,7 @@ static int ina2xx_init(struct ina2xx_data *data)
>
>   	/* device configuration */
>   	ret = i2c_smbus_write_word_swapped(client, INA2XX_CONFIG,
> -					   data->config->config_default);
> +					   data->curr_config);
>   	if (ret < 0)
>   		return ret;
>
> @@ -199,12 +259,12 @@ static struct ina2xx_data *ina2xx_update_device(struct device *dev)
>   {
>   	struct ina2xx_data *data = dev_get_drvdata(dev);
>   	struct ina2xx_data *ret = data;
> -	int rv;
> +	int rv, ui;
>
>   	mutex_lock(&data->update_lock);
>
> -	if (time_after(jiffies, data->last_updated +
> -		       HZ / INA2XX_CONVERSION_RATE) || !data->valid) {
> +	ui = ina226_reg_to_interval(data->curr_config) * HZ / 1000;

Unfortunately that only applies to INA226 and not INA219, where the time is static
(at least so far).

I think we'll need to store the time in ina2xx_data and use the old (constant)
value for ina219. Maybe add another variable into the configuration data
for the initial value and copy it from there during probe.

Also, it would be better to use msecs_to_jiffies() for the now dynamic
conversion to jiffies.

Thanks,
Guenter


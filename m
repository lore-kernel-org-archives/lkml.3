Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbbAHRF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:05:29 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:32973 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268AbbAHRFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:05:24 -0500
Date: Thu, 8 Jan 2015 09:05:19 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] hwmon: (ina2xx) implement update_interval attribute for
 ina226
Message-ID: <20150108170519.GA30248@roeck-us.net>
References: <1420734313-24546-1-git-send-email-bgolaszewski@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420734313-24546-1-git-send-email-bgolaszewski@baylibre.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54AEB8E0.030F,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Thu, Jan 08, 2015 at 05:25:13PM +0100, Bartosz Golaszewski wrote:
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
>  Documentation/hwmon/ina2xx |   3 +
>  drivers/hwmon/ina2xx.c     | 133 +++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 132 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/hwmon/ina2xx b/Documentation/hwmon/ina2xx
> index 320dd69..f4f2696 100644
> --- a/Documentation/hwmon/ina2xx
> +++ b/Documentation/hwmon/ina2xx
> @@ -48,3 +48,6 @@ The shunt value in micro-ohms can be set via platform data or device tree at
>  compile-time or via the shunt_resistor attribute in sysfs at run-time. Please
>  refer to the Documentation/devicetree/bindings/i2c/ina2xx.txt for bindings
>  if the device tree is used.
> +
> +Additionally ina226 supports update_interval attribute as described in
> +Documentation/hwmon/sysfs-interface.

Hi Bartosz,

A more detailed explanation, describing how the update interval translates to
the number of averages, would be helpful.

> diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
> index 49537ea..048c229 100644
> --- a/drivers/hwmon/ina2xx.c
> +++ b/drivers/hwmon/ina2xx.c
> @@ -68,6 +68,21 @@
>  
>  #define INA2XX_RSHUNT_DEFAULT		10000
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
> + * to 0b0100 on POR, which translates to 1100 microseconds.
> + */
> +#define INA226_CONV_TIME_DEFAULT	1100
> +
>  enum ina2xx_ids { ina219, ina226 };
>  
>  struct ina2xx_config {
> @@ -85,12 +100,14 @@ struct ina2xx_data {
>  	const struct ina2xx_config *config;
>  
>  	long rshunt;
> +	u16 curr_config;
>  
>  	struct mutex update_lock;
>  	bool valid;
>  	unsigned long last_updated;
>  
>  	int kind;
> +	const struct attribute_group *groups[INA2XX_MAX_ATTRIBUTE_GROUPS];
>  	u16 regs[INA2XX_MAX_REGISTERS];
>  };
>  
> @@ -115,6 +132,48 @@ static const struct ina2xx_config ina2xx_config[] = {
>  	},
>  };
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
> +	 * Add bus and shunt voltage conversion times and multiple them
> +	 * by the averaging rate. Return the result in milliseconds.
> +	 */
> +	return (avg * 2 * INA226_CONV_TIME_DEFAULT) / 1000;

What is the purpose of multiplying the calculated average by 2 ?

Using DIV_ROUND_CLOSEST() might be a better choice to reduce rounding errors.

> +}
> +
> +static u16 ina226_interval_to_reg(int interval, u16 config)
> +{
> +	int avg, avg_bits;
> +
> +	avg = (interval * 1000) / (2 * INA226_CONV_TIME_DEFAULT);

Another multiplication by 2 without explanation.

Using DIV_ROUND_CLOSEST() might be a better choice.

You should use the actual update interval in ina2xx_update_device(),
since it no longer makes sense to use the static 'HZ / INA2XX_CONVERSION_RATE'.

Thanks,
Guenter

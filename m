Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab3J3PlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:41:25 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:34458 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab3J3PlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:41:24 -0400
Date: Wed, 30 Oct 2013 16:41:13 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Wei Ni <wni@nvidia.com>
Cc: <linux@roeck-us.net>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] hwmon: (lm90) Define status bits
Message-ID: <20131030164113.1396964e@endymion.delvare>
In-Reply-To: <1375856306-14415-2-git-send-email-wni@nvidia.com>
References: <1375856306-14415-1-git-send-email-wni@nvidia.com>
	<1375856306-14415-2-git-send-email-wni@nvidia.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On Wed, 7 Aug 2013 14:18:24 +0800, Wei Ni wrote:
> Add bit defines for the status register. And add a function
> lm90_is_tripped() which will read status register and return
> tripped or not, then lm90_alert can call it directly, and in the
> future the IRQ thread also can use it.
> 
> Signed-off-by: Wei Ni <wni@nvidia.com>
> ---
>  drivers/hwmon/lm90.c |   75 +++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 50 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
> index cdff742..1da2eff 100644
> --- a/drivers/hwmon/lm90.c
> +++ b/drivers/hwmon/lm90.c
> @@ -179,6 +179,18 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
>  #define LM90_HAVE_TEMP3		(1 << 6) /* 3rd temperature sensor	*/
>  #define LM90_HAVE_BROKEN_ALERT	(1 << 7) /* Broken alert		*/
>  
> +/* LM90 status */
> +#define LM90_STATUS_LTHRM	(1 << 0) /* local THERM limit tripped */
> +#define LM90_STATUS_RTHRM	(1 << 1) /* remote THERM limit tripped */
> +#define LM90_STATUS_OPEN	(1 << 2) /* remote is an open circuit */
> +#define LM90_STATUS_RLOW	(1 << 3) /* remote low temp limit tripped */
> +#define LM90_STATUS_RHIGH	(1 << 4) /* remote high temp limit tripped */
> +#define LM90_STATUS_LLOW	(1 << 5) /* local low temp limit tripped */
> +#define LM90_STATUS_LHIGH	(1 << 6) /* local high temp limit tripped */
> +
> +#define MAX6696_STATUS2_RLOW	(1 << 3) /* remote2 low temp limit tripped */
> +#define MAX6696_STATUS2_RHIGH	(1 << 4) /* remote2 high temp limit tripped */
> +
>  /*
>   * Driver data (common to all clients)
>   */
> @@ -1391,6 +1403,36 @@ static void lm90_init_client(struct i2c_client *client)
>  		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1, config);
>  }
>  
> +static bool lm90_is_tripped(struct i2c_client *client)
> +{
> +	struct lm90_data *data = i2c_get_clientdata(client);
> +	u8 status, status2 = 0;
> +
> +	lm90_read_reg(client, LM90_REG_R_STATUS, &status);
> +
> +	if (data->kind == max6696)
> +		lm90_read_reg(client, MAX6696_REG_R_STATUS2, &status2);
> +
> +	if ((status & 0x7f) == 0 && (status2 & 0xfe) == 0)
> +		return false;
> +
> +	if (status & (LM90_STATUS_LLOW | LM90_STATUS_LHIGH | LM90_STATUS_LTHRM))
> +		dev_warn(&client->dev,
> +			 "temp%d out of range, please check!\n", 1);
> +	if (status & (LM90_STATUS_RLOW | LM90_STATUS_RHIGH | LM90_STATUS_RTHRM))
> +		dev_warn(&client->dev,
> +			 "temp%d out of range, please check!\n", 2);
> +	if (status & LM90_STATUS_OPEN)
> +		dev_warn(&client->dev,
> +			 "temp%d diode open, please check!\n", 2);
> +
> +	if (status2 & (MAX6696_STATUS2_RLOW | MAX6696_STATUS2_RHIGH))
> +		dev_warn(&client->dev,
> +			 "temp%d out of range, please check!\n", 3);
> +
> +	return true;
> +}
> +
>  static int lm90_probe(struct i2c_client *client,
>  		      const struct i2c_device_id *id)
>  {
> @@ -1489,36 +1531,17 @@ static int lm90_remove(struct i2c_client *client)
>  
>  static void lm90_alert(struct i2c_client *client, unsigned int flag)
>  {
> -	struct lm90_data *data = i2c_get_clientdata(client);
> -	u8 config, alarms, alarms2 = 0;
> -
> -	lm90_read_reg(client, LM90_REG_R_STATUS, &alarms);
> -
> -	if (data->kind == max6696)
> -		lm90_read_reg(client, MAX6696_REG_R_STATUS2, &alarms2);
> -
> -	if ((alarms & 0x7f) == 0 && (alarms2 & 0xfe) == 0) {
> -		dev_info(&client->dev, "Everything OK\n");
> -	} else {
> -		if (alarms & 0x61)
> -			dev_warn(&client->dev,
> -				 "temp%d out of range, please check!\n", 1);
> -		if (alarms & 0x1a)
> -			dev_warn(&client->dev,
> -				 "temp%d out of range, please check!\n", 2);
> -		if (alarms & 0x04)
> -			dev_warn(&client->dev,
> -				 "temp%d diode open, please check!\n", 2);
> -
> -		if (alarms2 & 0x18)
> -			dev_warn(&client->dev,
> -				 "temp%d out of range, please check!\n", 3);
> -
> +	if (lm90_is_tripped(client)) {

You are reading LM90_REG_R_STATUS here...

>  		/*
>  		 * Disable ALERT# output, because these chips don't implement
>  		 * SMBus alert correctly; they should only hold the alert line
>  		 * low briefly.
>  		 */
> +		struct lm90_data *data = i2c_get_clientdata(client);
> +		u8 config, alarms;
> +
> +		lm90_read_reg(client, LM90_REG_R_STATUS, &alarms);

... and here again. I already complained about this in my previous
review of this patch, and you were supposed to address it, but you did
not. As a result I am still not happy with this patch and I can't apply
it, sorry.

> +
>  		if ((data->flags & LM90_HAVE_BROKEN_ALERT)
>  		 && (alarms & data->alert_alarms)) {
>  			dev_dbg(&client->dev, "Disabling ALERT#\n");
> @@ -1526,6 +1549,8 @@ static void lm90_alert(struct i2c_client *client, unsigned int flag)
>  			i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
>  						  config | 0x80);
>  		}
> +	} else {
> +		dev_info(&client->dev, "Everything OK\n");
>  	}
>  }
>  

-- 
Jean Delvare

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118AbaKYP6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:58:44 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:46006 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaKYP6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:58:43 -0500
Message-ID: <5474A72D.2000309@roeck-us.net>
Date: Tue, 25 Nov 2014 07:58:37 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>
Subject: Re: [PATCH 1/5] hwmon: ina2xx: bail-out from ina2xx_probe() in case
 of configuration errors
References: <1416930423-12179-1-git-send-email-bgolaszewski@baylibre.com> <1416930423-12179-2-git-send-email-bgolaszewski@baylibre.com>
In-Reply-To: <1416930423-12179-2-git-send-email-bgolaszewski@baylibre.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.5474A732.02B6,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
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

On 11/25/2014 07:46 AM, Bartosz Golaszewski wrote:
> The return value of i2c_smbus_write_word_swapped() isn't checked in
> ina2xx_probe(). This leads to devices being registered even if they can not
> be physically detected (e.g. device is not powered-up at boot-time).
>
> Even after restoring power to such device, it is left unconfigured as the
> configuration has never been actually written to the register.
>
> Error out in case of write errors in probe and notify the user.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>   drivers/hwmon/ina2xx.c | 49 +++++++++++++++++++++++++++++++++++++++++++------
>   1 file changed, 43 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
> index bfd3f3e..660f8ca 100644
> --- a/drivers/hwmon/ina2xx.c
> +++ b/drivers/hwmon/ina2xx.c
> @@ -110,6 +110,40 @@ static const struct ina2xx_config ina2xx_config[] = {
>   	},
>   };
>
> +static int ina2xx_write_register(const struct i2c_client *client,
> +						u8 reg, u16 value)
> +{
> +	return i2c_smbus_write_word_swapped(client, reg, value);
> +}
> +
> +static int ina2xx_configure(const struct i2c_client *client, u16 value)
> +{
> +	int status;
> +
> +	status = ina2xx_write_register(client, INA2XX_CONFIG, value);
> +	if (status < 0) {
> +		dev_err(&client->dev,
> +			"error writing to configuration register: %d\n",
> +			status);
> +	}
> +
> +	return status;
> +}
> +
> +static int ina2xx_calibrate(const struct i2c_client *client, u16 value)
> +{
> +	int status;
> +
> +	status = ina2xx_write_register(client, INA2XX_CALIBRATION, value);
> +	if (status < 0) {
> +		dev_err(&client->dev,
> +			"error writing to calibration register: %d\n",
> +			status);
> +	}
> +
> +	return status;
> +}
> +

You are introducing those two functions with the same code just to display
a different error message. That does not provide enough value to have extra
functions and just increases code size.

Just check the return code from ina2xx_write_register directly in the probe
function and bail out there.

Thanks,
Guenter


>   static struct ina2xx_data *ina2xx_update_device(struct device *dev)
>   {
>   	struct ina2xx_data *data = dev_get_drvdata(dev);
> @@ -247,12 +281,15 @@ static int ina2xx_probe(struct i2c_client *client,
>   	data->config = &ina2xx_config[data->kind];
>
>   	/* device configuration */
> -	i2c_smbus_write_word_swapped(client, INA2XX_CONFIG,
> -				     data->config->config_default);
> -	/* set current LSB to 1mA, shunt is in uOhms */
> -	/* (equation 13 in datasheet) */
> -	i2c_smbus_write_word_swapped(client, INA2XX_CALIBRATION,
> -				     data->config->calibration_factor / shunt);
> +	if (ina2xx_configure(client, data->config->config_default) < 0)
> +		return -ENODEV;
> +
> +	/* Set current LSB to 1mA, shunt is in uOhms
> +	 * (equation 13 in datasheet).
> +	 */
> +	if (ina2xx_calibrate(client,
> +			data->config->calibration_factor / shunt) < 0)
> +		return -ENODEV;
>
>   	data->client = client;
>   	mutex_init(&data->update_lock);
>


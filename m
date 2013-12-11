Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab3LKB2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:28:09 -0500
Received: from mail.active-venture.com ([67.228.131.205]:55741 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab3LKB2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:28:05 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52A7BFA4.2080402@roeck-us.net>
Date: Tue, 10 Dec 2013 17:28:04 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: =?UTF-8?B?Sm9zw6kgTWlndWVsIEdvbsOnYWx2ZXM=?= 
	<jose.goncalves@inov.pt>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] hwmon: HIH-6130: Support I2C bus drivers
 without I2C_FUNC_SMBUS_QUICK
References: <1386723462-21388-1-git-send-email-jose.goncalves@inov.pt>
In-Reply-To: <1386723462-21388-1-git-send-email-jose.goncalves@inov.pt>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 04:57 PM, José Miguel Gonçalves wrote:
> Some I2C bus drivers do not allow zero-lenght data transfers which are

s/lenght/length/

> required to start a mesurement with the HIH6130/1 sensor. Nevertheless,

s/mesurement/measurement/

> we can overcome this limitation by writing a zero dummy byte. This byte
> is ignored by the sensor and was verified to be working with the OMAP
> I2C bus driver in a BeagleBone board.
>
> Signed-off-by: José Miguel Gonçalves <jose.goncalves@inov.pt>
> ---
>   drivers/hwmon/hih6130.c |   16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/hwmon/hih6130.c b/drivers/hwmon/hih6130.c
> index 2dc37c7..a860cc4 100644
> --- a/drivers/hwmon/hih6130.c
> +++ b/drivers/hwmon/hih6130.c
> @@ -121,8 +121,20 @@ static int hih6130_update_measurements(struct i2c_client *client)
>   	 */
>   	if (time_after(jiffies, hih6130->last_update + HZ) || !hih6130->valid) {
>
> -		/* write to slave address, no data, to request a measurement */
> -		ret = i2c_master_send(client, tmp, 0);
> +		/*
> +		 * Write to slave address, to request a measurement.

s/,//

> +		 * According with the datasheet it should be with no data, but
> +		 * for systems with I2C bus drivers that do not allow zero
> +		 * length packets we write one dummy byte to allow sensor
> +		 * measurements on them.
> +		 */
> +		if (i2c_get_functionality(client->adapter) &
> +		    I2C_FUNC_SMBUS_QUICK) {
> +			ret = i2c_master_send(client, tmp, 0);
> +		} else {
> +			tmp[0] = 0;
> +			ret = i2c_master_send(client, tmp, 1);
> +		}

You can simplify this code by introducing a variable to hold
the write length into struct hih6130. This variable can be
initialized with 1 or 0 in the probe function.

	if (i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_QUICK))
		hih6130->write_length = 0;
	else
		hih6130->write_length = 1;

Then replace above code with

	tmp[0] = 0;
	ret = i2c_master_send(client, tmp, hih6130->write_length);

This way you don't have to call i2c_{get,check}_functionality() repeatedly.

Thanks,
Guenter
	
>   		if (ret < 0)
>   			goto out;
>
>


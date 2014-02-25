Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaBYGdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 01:33:04 -0500
Received: from mail.active-venture.com ([67.228.131.205]:53332 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaBYGdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 01:33:02 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <530C391B.5090206@roeck-us.net>
Date: Mon, 24 Feb 2014 22:32:59 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>, khali@linux-fr.org
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hwmon: (lm90) split set&show temp as common codes
References: <1393309301-28337-1-git-send-email-wni@nvidia.com> <1393309301-28337-2-git-send-email-wni@nvidia.com>
In-Reply-To: <1393309301-28337-2-git-send-email-wni@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 10:21 PM, Wei Ni wrote:
> Split set&show temp codes as common functions, so we can use it
> directly when implement linux thermal framework.
> And handle error return value for the lm90_select_remote_channel
> and write_tempx, then set_temp8 and set_temp11 could return it
> to user-space.
>
> Signed-off-by: Wei Ni <wni@nvidia.com>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
>   drivers/hwmon/lm90.c |  170 ++++++++++++++++++++++++++++++++++----------------
>   1 file changed, 115 insertions(+), 55 deletions(-)
>
> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
> index c9ff08d..fb9e224 100644
> --- a/drivers/hwmon/lm90.c
> +++ b/drivers/hwmon/lm90.c
> @@ -473,20 +473,29 @@ static int lm90_read16(struct i2c_client *client, u8 regh, u8 regl, u16 *value)
>    * various registers have different meanings as a result of selecting a
>    * non-default remote channel.
>    */
> -static inline void lm90_select_remote_channel(struct i2c_client *client,
> -					      struct lm90_data *data,
> -					      int channel)
> +static inline int lm90_select_remote_channel(struct i2c_client *client,
> +					     struct lm90_data *data,
> +					     int channel)
>   {
>   	u8 config;
> +	int err;
>
>   	if (data->kind == max6696) {
>   		lm90_read_reg(client, LM90_REG_R_CONFIG1, &config);
>   		config &= ~0x08;
>   		if (channel)
>   			config |= 0x08;
> -		i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
> -					  config);
> +		err = i2c_smbus_write_byte_data(client, LM90_REG_W_CONFIG1,
> +						config);
> +		if (err < 0) {
> +			dev_err(&client->dev,
> +				"Failed to select remote channel %d, err %d\n",
> +				channel, err);
> +			return err;

Not my call to make, but I really dislike all that new noisiness.
Sure, it is ok to pass the error back, but in my opinion that is
good enough. If every driver in the kernel would be that noisy,
the log would be all but useless.

Guenter


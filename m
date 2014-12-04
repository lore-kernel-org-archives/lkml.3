Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbaLDOWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:22:07 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:58275 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbaLDOWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:22:05 -0500
Message-ID: <54806DC9.9040704@roeck-us.net>
Date: Thu, 04 Dec 2014 06:20:57 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 2/2] hwmon: tmp401: bail-out from tmp401_probe() in case
 of write errors
References: <1417687048-21455-1-git-send-email-bgolaszewski@baylibre.com> <1417687048-21455-3-git-send-email-bgolaszewski@baylibre.com>
In-Reply-To: <1417687048-21455-3-git-send-email-bgolaszewski@baylibre.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.54806E0C.0257,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 12/04/2014 01:57 AM, Bartosz Golaszewski wrote:
> The return value of i2c_smbus_read_byte_data() is checked in
> tmp401_init_client(), but only a warning is printed and the device is
> registered anyway. This leads to devices being registered even if they
> cannot be physically detected.
>
> Bail-out from probe in case of write errors and notify the user.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>   drivers/hwmon/tmp401.c | 16 ++++++++++------
>   1 file changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/hwmon/tmp401.c b/drivers/hwmon/tmp401.c
> index 5a72d7f..75b3210 100644
> --- a/drivers/hwmon/tmp401.c
> +++ b/drivers/hwmon/tmp401.c
> @@ -618,8 +618,8 @@ static const struct attribute_group tmp432_group = {
>    * Begin non sysfs callback code (aka Real code)
>    */
>
> -static void tmp401_init_client(struct tmp401_data *data,
> -			       struct i2c_client *client)
> +static int tmp401_init_client(struct tmp401_data *data,
> +			      struct i2c_client *client)
>   {
>   	int config, config_orig;
>
> @@ -630,8 +630,8 @@ static void tmp401_init_client(struct tmp401_data *data,
>   	/* Start conversions (disable shutdown if necessary) */
>   	config = i2c_smbus_read_byte_data(client, TMP401_CONFIG_READ);
>   	if (config < 0) {
> -		dev_warn(&client->dev, "Initialization failed!\n");
> -		return;
> +		dev_err(&client->dev, "Initialization failed!");
> +		return config;
>   	}
>
>   	config_orig = config;
> @@ -639,6 +639,8 @@ static void tmp401_init_client(struct tmp401_data *data,
>
>   	if (config != config_orig)
>   		i2c_smbus_write_byte_data(client, TMP401_CONFIG_WRITE, config);

No error check and return here ?

Guenter

> +
> +	return 0;
>   }
>
>   static int tmp401_detect(struct i2c_client *client,
> @@ -721,7 +723,7 @@ static int tmp401_probe(struct i2c_client *client,
>   	struct device *dev = &client->dev;
>   	struct device *hwmon_dev;
>   	struct tmp401_data *data;
> -	int groups = 0;
> +	int groups = 0, status;
>
>   	data = devm_kzalloc(dev, sizeof(struct tmp401_data), GFP_KERNEL);
>   	if (!data)
> @@ -732,7 +734,9 @@ static int tmp401_probe(struct i2c_client *client,
>   	data->kind = id->driver_data;
>
>   	/* Initialize the TMP401 chip */
> -	tmp401_init_client(data, client);
> +	status = tmp401_init_client(data, client);
> +	if (status < 0)
> +		return status;
>
>   	/* Register sysfs hooks */
>   	data->groups[groups++] = &tmp401_group;
>


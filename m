Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbaLDOUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:20:49 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:58085 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbaLDOUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:20:48 -0500
Message-ID: <54806D6C.7060009@roeck-us.net>
Date: Thu, 04 Dec 2014 06:19:24 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 1/2] hwmon: tmp401: add support for TI TMP435
References: <1417687048-21455-1-git-send-email-bgolaszewski@baylibre.com> <1417687048-21455-2-git-send-email-bgolaszewski@baylibre.com>
In-Reply-To: <1417687048-21455-2-git-send-email-bgolaszewski@baylibre.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.54806DB5.00BC,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 12/04/2014 01:57 AM, Bartosz Golaszewski wrote:
> From: Patrick Titiano <ptitiano@baylibre.com>
>
> Signed-off-by: Patrick Titiano <ptitiano@baylibre.com>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>   drivers/hwmon/tmp401.c | 16 ++++++++++++++--

Please also update Kconfig and Documentation/hwmon/tmp401.

>   1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/hwmon/tmp401.c b/drivers/hwmon/tmp401.c
> index 7fa6e7d..5a72d7f 100644
> --- a/drivers/hwmon/tmp401.c
> +++ b/drivers/hwmon/tmp401.c
> @@ -8,6 +8,9 @@
>    * Cleanup and support for TMP431 and TMP432 by Guenter Roeck
>    * Copyright (c) 2013 Guenter Roeck <linux@roeck-us.net>
>    *
> + * Support for TMP435 by Patrick Titiano
> + * Copyright (c) 2014 Patrick Titiano <ptitiano@baylibre.com>
> + *
>    * This program is free software; you can redistribute it and/or modify
>    * it under the terms of the GNU General Public License as published by
>    * the Free Software Foundation; either version 2 of the License, or
> @@ -46,7 +49,7 @@
>   /* Addresses to scan */
>   static const unsigned short normal_i2c[] = { 0x4c, 0x4d, 0x4e, I2C_CLIENT_END };
>
> -enum chips { tmp401, tmp411, tmp431, tmp432 };
> +enum chips { tmp401, tmp411, tmp431, tmp432, tmp435 };
>
>   /*
>    * The TMP401 registers, note some registers have different addresses for
> @@ -136,6 +139,7 @@ static const u8 TMP432_STATUS_REG[] = {
>   #define TMP411C_DEVICE_ID			0x10
>   #define TMP431_DEVICE_ID			0x31
>   #define TMP432_DEVICE_ID			0x32
> +#define TMP435_DEVICE_ID			0x35

The datasheet claims otherwise (0x31, specifically).
Is this based on real chip information ?
Can you send me the output from i2cdump for the chip ?

Thanks,
Guenter

>
>   /*
>    * Driver data (common to all clients)
> @@ -146,6 +150,7 @@ static const struct i2c_device_id tmp401_id[] = {
>   	{ "tmp411", tmp411 },
>   	{ "tmp431", tmp431 },
>   	{ "tmp432", tmp432 },
> +	{ "tmp435", tmp435 },
>   	{ }
>   };
>   MODULE_DEVICE_TABLE(i2c, tmp401_id);
> @@ -684,6 +689,11 @@ static int tmp401_detect(struct i2c_client *client,
>   			return -ENODEV;
>   		kind = tmp432;
>   		break;
> +	case TMP435_DEVICE_ID:
> +		if (client->addr != 0x4c)
> +			return -ENODEV;
> +		kind = tmp435;
> +		break;
>   	default:
>   		return -ENODEV;
>   	}
> @@ -705,7 +715,9 @@ static int tmp401_detect(struct i2c_client *client,
>   static int tmp401_probe(struct i2c_client *client,
>   			const struct i2c_device_id *id)
>   {
> -	const char *names[] = { "TMP401", "TMP411", "TMP431", "TMP432" };
> +	static const char *names[] = {
> +		"TMP401", "TMP411", "TMP431", "TMP432", "TMP435"
> +	};
>   	struct device *dev = &client->dev;
>   	struct device *hwmon_dev;
>   	struct tmp401_data *data;
>


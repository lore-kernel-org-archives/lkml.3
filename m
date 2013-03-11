Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab3CKSFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:05:55 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14750 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab3CKSFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:05:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 11 Mar 2013 11:05:43 -0700
Message-ID: <513E1CF6.5070408@nvidia.com>
Date: Mon, 11 Mar 2013 14:05:42 -0400
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] power: sbs-battery: Use dev_pm_ops
References: <1362922449-27531-1-git-send-email-lars@metafoo.de> <1362922449-27531-3-git-send-email-lars@metafoo.de>
In-Reply-To: <1362922449-27531-3-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/10/2013 9:34 AM, Lars-Peter Clausen wrote:
> Use dev_pm_ops instead of the deprecated legacy suspend/resume callbacks.
>
> Cc: Rhyland Klein <rklein@nvidia.com>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>   drivers/power/sbs-battery.c | 18 ++++++++++--------
>   1 file changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
> index 3960f0b..6a2e335 100644
> --- a/drivers/power/sbs-battery.c
> +++ b/drivers/power/sbs-battery.c
> @@ -820,10 +820,11 @@ static int sbs_remove(struct i2c_client *client)
>   	return 0;
>   }
>   
> -#if defined CONFIG_PM
> -static int sbs_suspend(struct i2c_client *client,
> -	pm_message_t state)
> +#if defined CONFIG_PM_SLEEP
> +
> +static int sbs_suspend(struct device *dev)
>   {
> +	struct i2c_client *client = to_i2c_client(dev);
>   	struct sbs_info *chip = i2c_get_clientdata(client);
>   	s32 ret;
>   
> @@ -838,11 +839,13 @@ static int sbs_suspend(struct i2c_client *client,
>   
>   	return 0;
>   }
> +
> +static SIMPLE_DEV_PM_OPS(sbs_pm_ops, sbs_suspend, NULL);
> +#define SBS_PM_OPS (&sbs_pm_ops)
> +
>   #else
> -#define sbs_suspend		NULL
> +#define SBS_PM_OPS NULL
>   #endif
> -/* any smbus transaction will wake up sbs */
> -#define sbs_resume		NULL
>   
>   static const struct i2c_device_id sbs_id[] = {
>   	{ "bq20z75", 0 },
> @@ -854,12 +857,11 @@ MODULE_DEVICE_TABLE(i2c, sbs_id);
>   static struct i2c_driver sbs_battery_driver = {
>   	.probe		= sbs_probe,
>   	.remove		= sbs_remove,
> -	.suspend	= sbs_suspend,
> -	.resume		= sbs_resume,
>   	.id_table	= sbs_id,
>   	.driver = {
>   		.name	= "sbs-battery",
>   		.of_match_table = sbs_dt_ids,
> +		.pm	= SBS_PM_OPS,
>   	},
>   };
>   module_i2c_driver(sbs_battery_driver);
Looks got to me!
Acked-By Rhyland Klein <rklein@nvidia.com>

-- 
nvpublic


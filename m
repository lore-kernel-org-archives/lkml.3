Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaKFOSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:18:16 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:39273 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaKFOR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:17:57 -0500
Message-ID: <545B830F.2020002@roeck-us.net>
Date: Thu, 06 Nov 2014 06:17:51 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michael Thalmeier <michael.thalmeier@hale.at>, jdelvare@suse.de
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: (lm75) put chip into shutdown mode on shutdown
References: <1415282432-3256-1-git-send-email-michael.thalmeier@hale.at>
In-Reply-To: <1415282432-3256-1-git-send-email-michael.thalmeier@hale.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.545B8313.02F2,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
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

On 11/06/2014 06:00 AM, Michael Thalmeier wrote:
> In addition to going into shutdown mode on suspend also go into shutdown mode
> on system shutdown. This way we can save a few mA when the main CPU is powered
> off and the lm75 is still powered but not used any more.
>
You can do this in a more comprehensive way using SIMPLE_DEV_PM_OPS.

Guenter

> Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>
> ---
>   drivers/hwmon/lm75.c | 19 +++++++++++++++++--
>   1 file changed, 17 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
> index 7ec5ccd..d860af9 100644
> --- a/drivers/hwmon/lm75.c
> +++ b/drivers/hwmon/lm75.c
> @@ -433,10 +433,10 @@ static int lm75_detect(struct i2c_client *new_client,
>   }
>
>   #ifdef CONFIG_PM
> -static int lm75_suspend(struct device *dev)
> +
> +static int _lm75_shutdown(struct i2c_client *client)
>   {
>   	int status;
> -	struct i2c_client *client = to_i2c_client(dev);
>   	status = lm75_read_value(client, LM75_REG_CONF);
>   	if (status < 0) {
>   		dev_dbg(&client->dev, "Can't read config? %d\n", status);
> @@ -447,6 +447,18 @@ static int lm75_suspend(struct device *dev)
>   	return 0;
>   }
>
> +static void lm75_shutdown(struct i2c_client *client)
> +{
> +	_lm75_shutdown(client);
> +}
> +
> +static int lm75_suspend(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +
> +	return _lm75_shutdown(client);
> +}
> +
>   static int lm75_resume(struct device *dev)
>   {
>   	int status;
> @@ -466,8 +478,10 @@ static const struct dev_pm_ops lm75_dev_pm_ops = {
>   	.resume		= lm75_resume,
>   };
>   #define LM75_DEV_PM_OPS (&lm75_dev_pm_ops)
> +#define LM75_SHUTDOWN_OP lm75_shutdown
>   #else
>   #define LM75_DEV_PM_OPS NULL
> +#define LM75_SHUTDOWN_OP NULL
>   #endif /* CONFIG_PM */
>
>   static struct i2c_driver lm75_driver = {
> @@ -478,6 +492,7 @@ static struct i2c_driver lm75_driver = {
>   	},
>   	.probe		= lm75_probe,
>   	.remove		= lm75_remove,
> +	.shutdown	= LM75_SHUTDOWN_OP,
>   	.id_table	= lm75_ids,
>   	.detect		= lm75_detect,
>   	.address_list	= normal_i2c,
>


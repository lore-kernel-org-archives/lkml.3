Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbaLDQZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:25:25 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:47188 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaLDQZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:25:24 -0500
Date: Thu, 4 Dec 2014 08:25:21 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v2 3/3] hwmon: tmp401: bail-out from tmp401_probe() in
 case of write errors
Message-ID: <20141204162521.GD7385@roeck-us.net>
References: <1417706574-1023-1-git-send-email-bgolaszewski@baylibre.com>
 <1417706574-1023-4-git-send-email-bgolaszewski@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417706574-1023-4-git-send-email-bgolaszewski@baylibre.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.54808AF4.0034,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 7
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

On Thu, Dec 04, 2014 at 04:22:54PM +0100, Bartosz Golaszewski wrote:
> The return value of i2c_smbus_read_byte_data() is checked in
> tmp401_init_client(), but only a warning is printed and the device is
> registered anyway. This leads to devices being registered even if they
> cannot be physically detected.
> 
> Bail-out from probe in case of write errors and notify the user.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  drivers/hwmon/tmp401.c | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/hwmon/tmp401.c b/drivers/hwmon/tmp401.c
> index a5f0973..ce7e579 100644
> --- a/drivers/hwmon/tmp401.c
> +++ b/drivers/hwmon/tmp401.c
> @@ -618,10 +618,10 @@ static const struct attribute_group tmp432_group = {
>   * Begin non sysfs callback code (aka Real code)
>   */
>  
> -static void tmp401_init_client(struct tmp401_data *data,
> -			       struct i2c_client *client)
> +static int tmp401_init_client(struct tmp401_data *data,
> +			      struct i2c_client *client)
>  {
> -	int config, config_orig;
> +	int config, config_orig, status;
>  
>  	/* Set the conversion rate to 2 Hz */
>  	i2c_smbus_write_byte_data(client, TMP401_CONVERSION_RATE_WRITE, 5);
> @@ -629,16 +629,21 @@ static void tmp401_init_client(struct tmp401_data *data,
>  
>  	/* Start conversions (disable shutdown if necessary) */
>  	config = i2c_smbus_read_byte_data(client, TMP401_CONFIG_READ);
> -	if (config < 0) {
> -		dev_warn(&client->dev, "Initialization failed!\n");
> -		return;
> -	}
> +	if (config < 0)
> +		return config;
>  
>  	config_orig = config;
>  	config &= ~TMP401_CONFIG_SHUTDOWN;
>  
> -	if (config != config_orig)
> -		i2c_smbus_write_byte_data(client, TMP401_CONFIG_WRITE, config);
> +	if (config != config_orig) {
> +		status = i2c_smbus_write_byte_data(client,
> +						   TMP401_CONFIG_WRITE,
> +						   config);
> +		if (status < 0)
> +			return status;

Just pre-initialize status to 0 and return status unconditionally.

Thanks,
Guenter

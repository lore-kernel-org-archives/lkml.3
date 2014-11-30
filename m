Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaK3JAE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 04:00:04 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:50382 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaK3JAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 04:00:02 -0500
Message-ID: <547ADC90.8000507@roeck-us.net>
Date: Sun, 30 Nov 2014 01:00:00 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Steven Honeyman <stevenhoneyman@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i8k: Fix temperature bug handling in i8k_get_temp()
References: <201411181546.51284@pali> <1416322614-10308-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1416322614-10308-1-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.547ADC91.00DB,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 11/18/2014 06:56 AM, Pali Rohár wrote:
> Static array prev[] was incorrectly initialized. It should be initialized to
> some "invalid" temperature value (above I8K_MAX_TEMP).
>
> Next, function should store "invalid" value to prev[] (above I8K_MAX_TEMP),
> not valid (= I8K_MAX_TEMP) because whole temperature bug handling will not
> work.
>
> And last part, to not break existing detection of temperature sensors, register
> them also if i8k report too high temperature (above I8K_MAX_TEMP). This is
> needed because some sensors are sometimes turned off (e.g sensor on GPU which
> can be turned off/on) and in this case SMM report too high value.
>
> To prevent reporting "invalid" values to userspace, return -EINVAL. In this case
> sensors which are currently turned off (e.g optimus/powerexpress/enduro gpu)
> are reported as "N/A" by lm-sensors package.
>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>   drivers/char/i8k.c |   16 ++++++++++------
>   1 file changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> index 7272b08..e34a019 100644
> --- a/drivers/char/i8k.c
> +++ b/drivers/char/i8k.c
> @@ -298,7 +298,7 @@ static int i8k_get_temp(int sensor)
>   	int temp;
>
>   #ifdef I8K_TEMPERATURE_BUG
> -	static int prev[4];
> +	static int prev[4] = { I8K_MAX_TEMP+1, I8K_MAX_TEMP+1, I8K_MAX_TEMP+1, I8K_MAX_TEMP+1 };
>   #endif
>   	regs.ebx = sensor & 0xff;
>   	rc = i8k_smm(&regs);
> @@ -317,10 +317,12 @@ static int i8k_get_temp(int sensor)
>   	 */
>   	if (temp > I8K_MAX_TEMP) {
>   		temp = prev[sensor];
> -		prev[sensor] = I8K_MAX_TEMP;
> +		prev[sensor] = I8K_MAX_TEMP+1;
>   	} else {
>   		prev[sensor] = temp;
>   	}
> +	if (temp > I8K_MAX_TEMP)
> +		return -ERANGE;

Can we return -ENODATA in this case ? I think that would be more appropriate.

>   #endif
>
>   	return temp;
> @@ -499,6 +501,8 @@ static ssize_t i8k_hwmon_show_temp(struct device *dev,
>   	int temp;
>
>   	temp = i8k_get_temp(index);
> +	if (temp == -ERANGE)
> +		return -EINVAL;

and can we also return -ENODATA to user space ?
This would make the code a bit cleaner.

Thanks,
Guenter


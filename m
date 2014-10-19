Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaJSPNf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 11:13:35 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:55328 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaJSPNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 11:13:33 -0400
Message-ID: <5443D519.1090408@roeck-us.net>
Date: Sun, 19 Oct 2014 08:13:29 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Steven Honeyman <stevenhoneyman@gmail.com>
Subject: Re: [PATCH] i8k: Ignore temperature sensors which report invalid
 values
References: <1413730014-30945-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1413730014-30945-1-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.5443D51D.0090,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
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

On 10/19/2014 07:46 AM, Pali Rohár wrote:
> On some machines some temperature sensors report too high values which are

What is "too high", and what is "some machines" ?
Would be great if you can be more specific.

> invalid. When value is invalid function i8k_get_temp() returns previous
> value and at next call it returns I8K_MAX_TEMP.
>
> With this patch also firt i8k_get_temp() call returns I8K_MAX_TEMP and

fix ? Also, I am not entirely sure I understand what exactly you are fixing here.

> i8k_init_hwmon() will ignore all sensor ids which report incorrect values.
>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>   drivers/char/i8k.c |   10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> index 7272b08..bc327fa 100644
> --- a/drivers/char/i8k.c
> +++ b/drivers/char/i8k.c
> @@ -298,7 +298,7 @@ static int i8k_get_temp(int sensor)
>   	int temp;
>
>   #ifdef I8K_TEMPERATURE_BUG
> -	static int prev[4];
> +	static int prev[4] = { I8K_MAX_TEMP, I8K_MAX_TEMP, I8K_MAX_TEMP, I8K_MAX_TEMP };

I am not sure I understand what this change is expected to accomplish.
Please explain.

>   #endif
>   	regs.ebx = sensor & 0xff;
>   	rc = i8k_smm(&regs);
> @@ -610,17 +610,17 @@ static int __init i8k_init_hwmon(void)
>
>   	/* CPU temperature attributes, if temperature reading is OK */
>   	err = i8k_get_temp(0);
> -	if (err >= 0)
> +	if (err >= 0 && err < I8K_MAX_TEMP)

I8K_MAX_TEMP is, at least in theory, a valid temperature, so this
should be "<=".

It would be important to understand what the "too high" temperature is
to possibly be able to distinguish it from the buggy temperature
that the code is trying to fix.

Thanks,
Guenter

>   		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP1;
>   	/* check for additional temperature sensors */
>   	err = i8k_get_temp(1);
> -	if (err >= 0)
> +	if (err >= 0 && err < I8K_MAX_TEMP)
>   		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP2;
>   	err = i8k_get_temp(2);
> -	if (err >= 0)
> +	if (err >= 0 && err < I8K_MAX_TEMP)
>   		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP3;
>   	err = i8k_get_temp(3);
> -	if (err >= 0)
> +	if (err >= 0 && err < I8K_MAX_TEMP)
>   		i8k_hwmon_flags |= I8K_HWMON_HAVE_TEMP4;
>
>   	/* Left fan attributes, if left fan is present */
>


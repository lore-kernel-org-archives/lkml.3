Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaIHLCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 07:02:09 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:45752 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaIHLCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 07:02:07 -0400
Message-ID: <540D8CA8.5020104@cogentembedded.com>
Date: Mon, 08 Sep 2014 15:02:00 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Alessandro Zummo <a.zummo@towertech.it>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: pcf8563: fix uninitialized use warning
References: <3640058.m4Rfp1dmTJ@wuerfel>
In-Reply-To: <3640058.m4Rfp1dmTJ@wuerfel>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 9/8/2014 12:42 AM, Arnd Bergmann wrote:

> gcc-4.9 found a potential condition under which the 'pending'
> variable may be used uninitialized:

> drivers/rtc/rtc-pcf8563.c: In function 'pcf8563_irq':
> drivers/rtc/rtc-pcf8563.c:173:5: warning: 'pending' may be used uninitialized in this function [-Wmaybe-uninitialized]

> This is because in the pcf8563_get_alarm_mode() function, we
> check any nonzero return of pcf8563_read_block_data, but
> in the irq function we only check for negative values, so
> a possible positive value does not get detected if the compiler
> chooses not to inline the entire call chain.

> Checking for any non-zero value in the interrupt handler as well
> is just as correct and lets the compiler know what we are doing,
> without needing a bogus initialization.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
> index 5a197d9dc7e7..3a6f994c4da8 100644
> --- a/drivers/rtc/rtc-pcf8563.c
> +++ b/drivers/rtc/rtc-pcf8563.c
> @@ -167,7 +167,7 @@ static irqreturn_t pcf8563_irq(int irq, void *dev_id)
>   	char pending;
>
>   	err = pcf8563_get_alarm_mode(pcf8563->client, NULL, &pending);
> -	if (err < 0)
> +	if (err)
>   		return err;

    Returning negative values from the IRQ handler doesn't seem valid.
Arbitrary positive value aren't good either. Perhaps should return IRQ_NONE 
instead?

WBR, Sergei


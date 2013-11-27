Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab3K0BEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:04:16 -0500
Received: from mail.active-venture.com ([67.228.131.205]:65175 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759023Ab3K0BEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:04:10 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52954509.1060508@roeck-us.net>
Date: Tue, 26 Nov 2013 17:04:09 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Wim Van Sebroeck <wim@iguana.be>
CC: Leela Krishna Amudala <l.krishna@samsung.com>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] watchdog: s3c2410_wdt: Handle rounding a little better
 for timeout
References: <1385490637-10306-1-git-send-email-dianders@chromium.org> <1385513839-17181-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1385513839-17181-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 04:57 PM, Doug Anderson wrote:
> The existing watchdog timeout worked OK but didn't deal with
> rounding in an ideal way when dividing out all of its clocks.
>
> Specifically if you had a timeout of 32 seconds and an input clock of
> 66666666, you'd end up setting a timeout of 31.9998 seconds and
> reporting a timeout of 31 seconds.
>
> Specifically DBG printouts showed:
>    s3c2410wdt_set_heartbeat: count=16666656, timeout=32, freq=520833
>    s3c2410wdt_set_heartbeat: timeout=32, divisor=255, count=16666656 (0000ff4f)
> and the final timeout reported to the user was:
>    ((count / divisor) * divisor) / freq
>    (0xff4f * 255) / 520833 = 31 (truncated from 31.9998)
> the technically "correct" value is:
>    (0xff4f * 255) / (66666666.0 / 128) = 31.9998
>
> By using "DIV_ROUND_UP" we can be a little more correct.
>    s3c2410wdt_set_heartbeat: count=16666688, timeout=32, freq=520834
>    s3c2410wdt_set_heartbeat: timeout=32, divisor=255, count=16666688 (0000ff50)
> and the final timeout reported to the user:
>    (0xff50 * 255) / 520834 = 32
> the technically "correct" value is:
>    (0xff50 * 255) / (66666666.0 / 128) = 32.0003
>
> We'll use a DIV_ROUND_UP to solve this, generally erroring on the side
> of reporting shorter values to the user and setting the watchdog to
> slightly longer than requested:
> * Round input frequency up to assume watchdog is counting faster.
> * Round divisions by divisor up to give us extra time.
>
> At the same time we can avoid a for loop by just doing the right math.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
> Changes in v2:
> - Avoid a for loop as per Guenter.
>
>   drivers/watchdog/s3c2410_wdt.c | 13 +++++--------
>   1 file changed, 5 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
> index 7d8fd04..d9bcd6e 100644
> --- a/drivers/watchdog/s3c2410_wdt.c
> +++ b/drivers/watchdog/s3c2410_wdt.c
> @@ -188,7 +188,7 @@ static int s3c2410wdt_set_heartbeat(struct watchdog_device *wdd, unsigned timeou
>   	if (timeout < 1)
>   		return -EINVAL;
>
> -	freq /= 128;
> +	freq = DIV_ROUND_UP(freq, 128);
>   	count = timeout * freq;
>
>   	DBG("%s: count=%d, timeout=%d, freq=%lu\n",
> @@ -200,21 +200,18 @@ static int s3c2410wdt_set_heartbeat(struct watchdog_device *wdd, unsigned timeou
>   	*/
>
>   	if (count >= 0x10000) {
> -		for (divisor = 1; divisor <= 0x100; divisor++) {
> -			if ((count / divisor) < 0x10000)
> -				break;
> -		}
> +		divisor = DIV_ROUND_UP(count, 0xffff);
>
> -		if ((count / divisor) >= 0x10000) {
> +		if (divisor > 0x100) {
>   			dev_err(wdt->dev, "timeout %d too big\n", timeout);
>   			return -EINVAL;
>   		}
>   	}
>
>   	DBG("%s: timeout=%d, divisor=%d, count=%d (%08x)\n",
> -	    __func__, timeout, divisor, count, count/divisor);
> +	    __func__, timeout, divisor, count, DIV_ROUND_UP(count, divisor));
>
> -	count /= divisor;
> +	count = DIV_ROUND_UP(count, divisor);
>   	wdt->count = count;
>
>   	/* update the pre-scaler */
>


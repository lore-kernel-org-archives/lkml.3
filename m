Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3KQCWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 21:22:18 -0500
Received: from mail.active-venture.com ([67.228.131.205]:63965 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab3KQCWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 21:22:06 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <5288284A.4020803@roeck-us.net>
Date: Sat, 16 Nov 2013 18:22:02 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>, wim@iguana.be,
        nsekhar@ti.com, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org
CC: grant.likely@linaro.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, galak@kernel.crashing.org,
        ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Fwd: [PATCH 3/8] watchdog: davinci: add GET_TIMELEFT option support
References: <1383680783-12114-4-git-send-email-ivan.khoronzhuk@ti.com> <527A28AF.9040308@ti.com>
In-Reply-To: <527A28AF.9040308@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 03:31 AM, ivan.khoronzhuk wrote:
> Currently, the davinci watchdog can be read while counting,
> so we can add ability to report the remaining time before
> the system will reboot.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
>   drivers/watchdog/davinci_wdt.c |   28 ++++++++++++++++++++++++++++
>   1 file changed, 28 insertions(+)
>
> diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
> index 1fc2093..6cbf2e1 100644
> --- a/drivers/watchdog/davinci_wdt.c
> +++ b/drivers/watchdog/davinci_wdt.c
> @@ -117,6 +117,33 @@ static int davinci_wdt_ping(struct watchdog_device *wdd)
>   	return 0;
>   }
>
> +static unsigned int davinci_wdt_get_timeleft(struct watchdog_device *wdd)
> +{
> +	u64 timer_counter;
> +	unsigned long freq;
> +	u32 val;
> +	struct davinci_wdt_device *davinci_wdt = watchdog_get_drvdata(wdd);
> +
> +	/* if timeout is occured then return 0 */

is -> has ?

> +	val = ioread32(davinci_wdt->base + WDTCR);
> +	if (val & WDFLAG)
> +		return 0;
> +
> +	freq = clk_get_rate(davinci_wdt->clk);
> +
> +	if (!freq) {
> +		dev_err(wdd->dev, "clock freq is not set\n");
> +		return 0;
> +	}
> +
This error check doesn't make sense to me; elsewhere the clock rate is not validated.
I would suggest to just return 0 here.

> +	timer_counter = ioread32(davinci_wdt->base + TIM12);
> +	timer_counter |= ((u64)ioread32(davinci_wdt->base + TIM34) << 32);
> +
> +	do_div(timer_counter, freq);
> +
> +	return wdd->timeout - timer_counter;
> +}
> +
>   static const struct watchdog_info davinci_wdt_info = {
>   	.options = WDIOF_KEEPALIVEPING,
>   	.identity = "DaVinci Watchdog",
> @@ -127,6 +154,7 @@ static const struct watchdog_ops davinci_wdt_ops = {
>   	.start		= davinci_wdt_start,
>   	.stop		= davinci_wdt_ping,
>   	.ping		= davinci_wdt_ping,
> +	.get_timeleft	= davinci_wdt_get_timeleft,
>   };
>
>   static int davinci_wdt_probe(struct platform_device *pdev)
>


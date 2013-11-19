Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab3KSFOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 00:14:42 -0500
Received: from mail.active-venture.com ([67.228.131.205]:50302 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3KSFOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 00:14:37 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <528AF3BB.5020305@roeck-us.net>
Date: Mon, 18 Nov 2013 21:14:35 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Wim Van Sebroeck <wim@iguana.be>, Sekhar Nori <nsekhar@ti.com>,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Strashko Grygorii <grygorii.strashko@ti.com>
Subject: Re: [PATCH 3/6] watchdog: davinci: add GET_TIMELEFT option support
References: <1384795139-19466-1-git-send-email-ivan.khoronzhuk@ti.com> <1384795139-19466-4-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1384795139-19466-4-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 09:18 AM, Ivan Khoronzhuk wrote:
> Currently, the davinci watchdog can be read while counting,
> so we can add ability to report the remaining time before
> the system will reboot.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>   drivers/watchdog/davinci_wdt.c |   26 ++++++++++++++++++++++++++
>   1 file changed, 26 insertions(+)
>
> diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
> index b353df5..55deaf8 100644
> --- a/drivers/watchdog/davinci_wdt.c
> +++ b/drivers/watchdog/davinci_wdt.c
> @@ -116,6 +116,31 @@ static int davinci_wdt_ping(struct watchdog_device *wdd)
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
> +	/* if timeout has occured then return 0 */
> +	val = ioread32(davinci_wdt->base + WDTCR);
> +	if (val & WDFLAG)
> +		return 0;
> +
> +	freq = clk_get_rate(davinci_wdt->clk);
> +
> +	if (!freq)
> +		return 0;
> +
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
> @@ -126,6 +151,7 @@ static const struct watchdog_ops davinci_wdt_ops = {
>   	.start		= davinci_wdt_start,
>   	.stop		= davinci_wdt_ping,
>   	.ping		= davinci_wdt_ping,
> +	.get_timeleft	= davinci_wdt_get_timeleft,
>   };
>
>   static int davinci_wdt_probe(struct platform_device *pdev)
>


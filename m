Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab3LPKen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:34:43 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:63897 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab3LPKel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:34:41 -0500
Message-ID: <52AED73E.5090507@linaro.org>
Date: Mon, 16 Dec 2013 11:34:38 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Tim Kryger <tim.kryger@linaro.org>, Christian Daudt <bcm@fixthebug.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        Axel Lin <axel.lin@ingics.com>
CC: Device Tree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Subject: Re: [PATCH v4 7/8] clocksource: kona: Add basic use of external clock
References: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org> <1386271244-3927-8-git-send-email-tim.kryger@linaro.org>
In-Reply-To: <1386271244-3927-8-git-send-email-tim.kryger@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 08:20 PM, Tim Kryger wrote:
> When an clock is specified in the device tree, enable it and use it to
> determine the external clock frequency.
>
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>   drivers/clocksource/bcm_kona_timer.c | 14 +++++++++++---
>   1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/clocksource/bcm_kona_timer.c b/drivers/clocksource/bcm_kona_timer.c
> index 0d7d8c3..8a4ab36 100644
> --- a/drivers/clocksource/bcm_kona_timer.c
> +++ b/drivers/clocksource/bcm_kona_timer.c
> @@ -17,6 +17,7 @@
>   #include <linux/jiffies.h>
>   #include <linux/clockchips.h>
>   #include <linux/types.h>
> +#include <linux/clk.h>
>
>   #include <linux/io.h>
>   #include <asm/mach/time.h>
> @@ -107,11 +108,18 @@ static const struct of_device_id bcm_timer_ids[] __initconst = {
>   static void __init kona_timers_init(struct device_node *node)
>   {
>   	u32 freq;
> +	struct clk *external_clk;
>
> -	if (!of_property_read_u32(node, "clock-frequency", &freq))
> +	external_clk = of_clk_get_by_name(node, NULL);
> +
> +	if (!IS_ERR(external_clk)) {
> +		arch_timer_rate = clk_get_rate(external_clk);
> +		clk_prepare_enable(external_clk);
> +	} else if (!of_property_read_u32(node, "clock-frequency", &freq)) {
>   		arch_timer_rate = freq;
> -	else
> -		panic("clock-frequency not set in the .dts file");
> +	} else {
> +		panic("unable to determine clock-frequency");
> +	}
>
>   	/* Setup IRQ numbers */
>   	timers.tmr_irq = irq_of_parse_and_map(node, 0);
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


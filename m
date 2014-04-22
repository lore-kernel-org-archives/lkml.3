Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbaDVK0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:26:43 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:60069 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaDVK0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:26:41 -0400
Message-ID: <535643FA.1080908@linaro.org>
Date: Tue, 22 Apr 2014 12:27:06 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: fix clocksource_mmio_readX_down
References: <1397726874-6349-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1397726874-6349-1-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 11:27 AM, Xiubo Li wrote:
> For some clocksource devices, for example, the registers are 32-bit, while
> the lower 16-bit is used for timer counting(And reading the upper 16-bit
> will return 0).
>
> For example, when the counter value is 0x00001111, and then the
> ~readl_relaxed(to_mmio_clksrc(c)->reg) will return the value of 0xFFFFEEEE,
> but it should be 0x0000EEEE.
>
> So just using the c->mask to mask the unused bits.
>
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>   drivers/clocksource/mmio.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/clocksource/mmio.c b/drivers/clocksource/mmio.c
> index c0e2512..f17a0d1 100644
> --- a/drivers/clocksource/mmio.c
> +++ b/drivers/clocksource/mmio.c
> @@ -27,7 +27,7 @@ cycle_t clocksource_mmio_readl_up(struct clocksource *c)
>
>   cycle_t clocksource_mmio_readl_down(struct clocksource *c)
>   {
> -	return ~readl_relaxed(to_mmio_clksrc(c)->reg);
> +	return ~readl_relaxed(to_mmio_clksrc(c)->reg) & c->mask;
>   }
>
>   cycle_t clocksource_mmio_readw_up(struct clocksource *c)
> @@ -37,7 +37,7 @@ cycle_t clocksource_mmio_readw_up(struct clocksource *c)
>
>   cycle_t clocksource_mmio_readw_down(struct clocksource *c)
>   {
> -	return ~(unsigned)readw_relaxed(to_mmio_clksrc(c)->reg);
> +	return ~(unsigned)readw_relaxed(to_mmio_clksrc(c)->reg) & c->mask;
>   }
>
>   /**


Hi,

I realize there is some type confusion here:

cycle_t -> u64
readl_relaxed -> u32
readw_relaxed -> u16

and clocksource_mmio_readw_down returns a cast to unsigned (u32)

This patch makes sense but it obfuscate more the types in these 
functions. Worth to clarify the functions first ?


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaIZHEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:04:34 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:37953 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaIZHEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:04:33 -0400
Message-ID: <54250FFE.2050605@linaro.org>
Date: Fri, 26 Sep 2014 09:04:30 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Nathan Lynch <nathan_lynch@mentor.com>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sonny Rao <sonnyrao@chromium.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] clocksource: arm_arch_timer: change clocksource
 name if CP15 unavailable
References: <1411052390-27238-1-git-send-email-nathan_lynch@mentor.com> <1411052390-27238-2-git-send-email-nathan_lynch@mentor.com>
In-Reply-To: <1411052390-27238-2-git-send-email-nathan_lynch@mentor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2014 04:59 PM, Nathan Lynch wrote:
> The arm and arm64 VDSOs need CP15 access to the architected counter.
> If this is unavailable (which is allowed by ARM v7), indicate this by
> changing the clocksource name to "arch_mem_counter" before registering
> the clocksource.
>
> Suggested by Stephen Boyd.
>
> Signed-off-by: Nathan Lynch <nathan_lynch@mentor.com>
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

Hi Nathan,

is it possible to have the acked-by of the different maintainers for the 
other patches ?

Are these patches targeted to be merged for 3.18 ?

Thanks
   -- Daniel

> ---
>   drivers/clocksource/arm_arch_timer.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index 5163ec13429d..c99afdf12e98 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -429,11 +429,19 @@ static void __init arch_counter_register(unsigned type)
>   	u64 start_count;
>
>   	/* Register the CP15 based counter if we have one */
> -	if (type & ARCH_CP15_TIMER)
> +	if (type & ARCH_CP15_TIMER) {
>   		arch_timer_read_counter = arch_counter_get_cntvct;
> -	else
> +	} else {
>   		arch_timer_read_counter = arch_counter_get_cntvct_mem;
>
> +		/* If the clocksource name is "arch_sys_counter" the
> +		 * VDSO will attempt to read the CP15-based counter.
> +		 * Ensure this does not happen when CP15-based
> +		 * counter is not available.
> +		 */
> +		clocksource_counter.name = "arch_mem_counter";
> +	}
> +
>   	start_count = arch_timer_read_counter();
>   	clocksource_register_hz(&clocksource_counter, arch_timer_rate);
>   	cyclecounter.mult = clocksource_counter.mult;
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


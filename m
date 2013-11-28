Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab3K1Lzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:55:41 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:49029 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758097Ab3K1Lze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:55:34 -0500
Message-ID: <52972F3A.9090103@linaro.org>
Date: Thu, 28 Nov 2013 12:55:38 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 4/9] clocksource/cadence_ttc: Use enable/disable_irq
References: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com> <1385514296-26702-5-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1385514296-26702-5-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 02:04 AM, Soren Brinkmann wrote:
> To ensure that the timer interrupt is properly enabled/disabled across
> the whole CPU cluster use enable/disable_irq() instead of
> local_irq_disable().
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>   drivers/clocksource/cadence_ttc_timer.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
> index a92350b55d32..246d018d1e63 100644
> --- a/drivers/clocksource/cadence_ttc_timer.c
> +++ b/drivers/clocksource/cadence_ttc_timer.c
> @@ -322,18 +322,16 @@ static int ttc_rate_change_clockevent_cb(struct notifier_block *nb,
>   	switch (event) {
>   	case POST_RATE_CHANGE:
>   	{
> -		unsigned long flags;
> -
>   		/*
>   		 * clockevents_update_freq should be called with IRQ disabled on
>   		 * the CPU the timer provides events for. The timer we use is
>   		 * common to both CPUs, not sure if we need to run on both
>   		 * cores.
>   		 */
> -		local_irq_save(flags);
> +		disable_irq(ttcce->ce.irq);
>   		clockevents_update_freq(&ttcce->ce,
>   				ndata->new_rate / PRESCALE);
> -		local_irq_restore(flags);
> +		enable_irq(ttcce->ce.irq);
>
>   		/* update cached frequency */
>   		ttc->freq = ndata->new_rate;
>

I am worried about the 'disable_irq' function calling 'synchronize_irq'. 
Isn't possible to deadlock with the ondemand cpufreq governor ? I added 
Viresh in Cc, he knows better than me the code path.

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


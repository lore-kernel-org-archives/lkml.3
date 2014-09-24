Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbaIXPQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:16:54 -0400
Received: from service87.mimecast.com ([91.220.42.44]:54115 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaIXPQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:16:52 -0400
Message-ID: <5422E05F.4070405@arm.com>
Date: Wed, 24 Sep 2014 16:16:47 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v2] clocksource: arm_arch_timer: discard unavailable timers
 correctly
References: <1410911445-19067-1-git-send-email-sudeep.holla@arm.com> <1410982774-4724-1-git-send-email-sudeep.holla@arm.com>
In-Reply-To: <1410982774-4724-1-git-send-email-sudeep.holla@arm.com>
X-OriginalArrivalTime: 24 Sep 2014 15:16:47.0460 (UTC) FILETIME=[8ED48A40:01CFD80A]
X-MC-Unique: 114092416164905001
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 17/09/14 20:39, Sudeep Holla wrote:
> Currently we wait until both cp15 and mem timers are probed if we
> have both timer device nodes present in the device tree without
> checking if the device is actually available. If one of the timer
> device node present is disabled, the system locks up on the boot
> as no timer gets registered.
>
> This patch adds the check for the availablity of the timer device
> so that we unavailable timers are discarded correctly. It also adds
> the missing of_node_put.
>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Mark Rutland <mark.rutland@arm.com>

If your are fine with this, can I ask Daniel you pick this up ?

Regards,
Sudeep

> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> ---
>   drivers/clocksource/arm_arch_timer.c | 20 ++++++++++++++++----
>   1 file changed, 16 insertions(+), 4 deletions(-)
>
> Changes v1->v2:
> 	- Added missing of_node_put in the original code
> 	- Updated the commit log as suggested
>
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index 5163ec13429d..7e267e3990ab 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -616,17 +616,29 @@ static const struct of_device_id arch_timer_mem_of_match[] __initconst = {
>   	{},
>   };
>
> +static bool __init
> +arch_timer_probed(int type, const struct of_device_id *matches)
> +{
> +	struct device_node *dn;
> +	bool probed = false;
> +
> +	dn = of_find_matching_node(NULL, matches);
> +	if (dn && of_device_is_available(dn) && (arch_timers_present & type))
> +		probed = true;
> +	of_node_put(dn);
> +
> +	return probed;
> +}
> +
>   static void __init arch_timer_common_init(void)
>   {
>   	unsigned mask = ARCH_CP15_TIMER | ARCH_MEM_TIMER;
>
>   	/* Wait until both nodes are probed if we have two timers */
>   	if ((arch_timers_present & mask) != mask) {
> -		if (of_find_matching_node(NULL, arch_timer_mem_of_match) &&
> -				!(arch_timers_present & ARCH_MEM_TIMER))
> +		if (!arch_timer_probed(ARCH_MEM_TIMER, arch_timer_mem_of_match))
>   			return;
> -		if (of_find_matching_node(NULL, arch_timer_of_match) &&
> -				!(arch_timers_present & ARCH_CP15_TIMER))
> +		if (!arch_timer_probed(ARCH_CP15_TIMER, arch_timer_of_match))
>   			return;
>   	}
>
>


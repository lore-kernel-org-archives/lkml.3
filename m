Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaJSTlt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 15:41:49 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46689 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751980AbaJSTls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 15:41:48 -0400
Date: Sun, 19 Oct 2014 20:40:55 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clocksource: arm_arch_timer: fix system hang
Message-ID: <20141019194055.GA24830@leverpostej>
References: <1413732164-19545-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413732164-19545-1-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, Oct 19, 2014 at 04:22:44PM +0100, Mark Salter wrote:
> Arm allows for two possible architectural clock sources. One memory mapped
> and the other coprocessor based. If both timers exist, then the driver waits
> for both to be probed before registering a clocksource.
> 
> Commit c387f07e6205 ("clocksource: arm_arch_timer: Discard unavailable timers
> correctly") attempted to fix a hang occurring when one of the two possible
> timers had a device node, but was disabled. In that case, the second probe
> would never occur and the system would hang without a clocksource being
> registered.
> 
> Unfortunately, incorrect logic in that commit made things worse such that
> a hang would occur unless both timers had a device node and were enabled.
> This patch fixes the logic so that we don't wait to probe a second timer
> unless it exists and is enabled.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>

Marc Zyngier had a similar fix for this issue a few days ago [1].

> ---
>  drivers/clocksource/arm_arch_timer.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index d1a5e35..b73392b 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -666,13 +666,14 @@ static bool __init
>  arch_timer_probed(int type, const struct of_device_id *matches)
>  {
>  	struct device_node *dn;
> -	bool probed = false;
> +	bool probed = true;
>  
>  	dn = of_find_matching_node(NULL, matches);
> -	if (dn && of_device_is_available(dn) && (arch_timers_present & type))
> -		probed = true;
> -	of_node_put(dn);
> -
> +	if (dn) {
> +		if (of_device_is_available(dn) && !(arch_timers_present & type))
> +			probed = false;
> +		of_node_put(dn);
> +	}

Other than the addition of the NULL check, this looks identical to
Marc's fix. There's already a NULL check in of_device_is_available, so I
don't think it's necessary to add one here. Are you seeing some failure
with a NULL np?

Thanks,
Mark.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/294744.html

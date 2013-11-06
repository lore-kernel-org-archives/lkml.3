Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab3KFVGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:06:43 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:46830 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab3KFVGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:06:41 -0500
Message-ID: <527AAF5E.6080709@linaro.org>
Date: Wed, 06 Nov 2013 22:06:38 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
CC: michael@ellerman.id.au, scottwood@freescale.com,
        srivatsa.bhat@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com,
        linux-pm@lists.linux-foundation.org, svaidy@linux.vnet.ibm.com
Subject: Re: [PATCH V7 6/7] POWER/cpuidle: Enable powernv cpuidle support.
References: <20131029110052.31547.82682.stgit@deepthi.in.ibm.com> <20131029110154.31547.94129.stgit@deepthi.in.ibm.com>
In-Reply-To: <20131029110154.31547.94129.stgit@deepthi.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 12:01 PM, Deepthi Dharwar wrote:
> The following patch extends the current power backend
> idle driver to the powernv platform.
>
> Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>   drivers/cpuidle/cpuidle-ibm-power.c |   39 ++++++++++++++++++++++++++++++++---
>   1 file changed, 36 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/cpuidle/cpuidle-ibm-power.c b/drivers/cpuidle/cpuidle-ibm-power.c
> index 5b92242..f790ea2 100644
> --- a/drivers/cpuidle/cpuidle-ibm-power.c
> +++ b/drivers/cpuidle/cpuidle-ibm-power.c
> @@ -52,9 +52,10 @@ static int snooze_loop(struct cpuidle_device *dev,
>   			struct cpuidle_driver *drv,
>   			int index)
>   {
> -	unsigned long in_purr;
> +	unsigned long in_purr = 0;
>
> -	idle_loop_prolog(&in_purr);
> +	if (firmware_has_feature(FW_FEATURE_SPLPAR))
> +		idle_loop_prolog(&in_purr);
>   	local_irq_enable();
>   	set_thread_flag(TIF_POLLING_NRFLAG);
>
> @@ -68,7 +69,8 @@ static int snooze_loop(struct cpuidle_device *dev,
>   	clear_thread_flag(TIF_POLLING_NRFLAG);
>   	smp_mb();
>
> -	idle_loop_epilog(in_purr);
> +	if (firmware_has_feature(FW_FEATURE_SPLPAR))
> +		idle_loop_epilog(in_purr);
>
>   	return index;
>   }
> @@ -132,6 +134,15 @@ static int shared_cede_loop(struct cpuidle_device *dev,
>   	return index;
>   }
>
> +static int nap_loop(struct cpuidle_device *dev,
> +			struct cpuidle_driver *drv,
> +			int index)
> +{
> +	ppc64_runlatch_off();
> +	power7_idle();
> +	return index;
> +}
> +
>   /*
>    * States for dedicated partition case.
>    */
> @@ -165,6 +176,23 @@ static struct cpuidle_state shared_states[] = {
>   		.enter = &shared_cede_loop },
>   };
>
> +static struct cpuidle_state powernv_states[] = {
> +	{ /* Snooze */
> +		.name = "snooze",
> +		.desc = "snooze",
> +		.flags = CPUIDLE_FLAG_TIME_VALID,
> +		.exit_latency = 0,
> +		.target_residency = 0,
> +		.enter = &snooze_loop },
> +	{ /* NAP */
> +		.name = "NAP",
> +		.desc = "NAP",
> +		.flags = CPUIDLE_FLAG_TIME_VALID,
> +		.exit_latency = 10,
> +		.target_residency = 100,
> +		.enter = &nap_loop },
> +};
> +
>   void update_smt_snooze_delay(int cpu, int residency)
>   {
>   	struct cpuidle_driver *drv = cpuidle_get_driver();
> @@ -258,6 +286,11 @@ static int power_idle_probe(void)
>   			cpuidle_state_table = dedicated_states;
>   			max_idle_state = ARRAY_SIZE(dedicated_states);
>   		}
> +
> +	} else if (firmware_has_feature(FW_FEATURE_OPALv3)) {
> +		cpuidle_state_table = powernv_states;
> +		max_idle_state = ARRAY_SIZE(powernv_states);
> +
>   	} else
>   		return -ENODEV;
>
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


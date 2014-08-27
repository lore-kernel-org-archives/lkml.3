Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935317AbaH0TNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:13:14 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:54384 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaH0TNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:13:12 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Nishanth Menon <nm@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Keerthy <j-keerthy@ti.com>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        daniel.lezcano@linaro.org
Subject: Re: [PATCH 08/10] ARM: OMAP5/DRA7: PM: cpuidle MPU CSWR support
Organization: Deep Root Systems, LLC
References: <1408716154-26101-1-git-send-email-nm@ti.com>
	<1408716154-26101-9-git-send-email-nm@ti.com>
Date: Wed, 27 Aug 2014 12:13:06 -0700
In-Reply-To: <1408716154-26101-9-git-send-email-nm@ti.com> (Nishanth Menon's
	message of "Fri, 22 Aug 2014 09:02:32 -0500")
Message-ID: <7hvbpdbvb1.fsf@paris.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Daniel (cpuidle maintainer)

Nishanth Menon <nm@ti.com> writes:

> From: Santosh Shilimkar <santosh.shilimkar@ti.com>
>
> Add OMAP5/DRA74/72 CPUIDLE support.
>
> This patch adds MPUSS low power states in cpuidle.
>
>         C1 - CPU0 WFI + CPU1 WFI + MPU ON
>         C2 - CPU0 RET + CPU1 RET + MPU CSWR
>
> Tested on DRA74/72-EVM for C1 and C2 states.
>
> NOTE: DRA7 does not do voltage scaling as part of retention transition
> and has Mercury which speeds up transition paths - Latency numbers are
> based on measurements done by toggling GPIOs.
>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> [ j-keerthy@ti.com rework on 3.14]
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> [nm@ti.com: updates based on profiling, OMAP5 squashed]
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>  arch/arm/mach-omap2/cpuidle44xx.c |   82 ++++++++++++++++++++++++++++++++++++-
>  arch/arm/mach-omap2/pm44xx.c      |    2 +-
>  2 files changed, 82 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/cpuidle44xx.c b/arch/arm/mach-omap2/cpuidle44xx.c
> index 2498ab0..8ad4f44 100644
> --- a/arch/arm/mach-omap2/cpuidle44xx.c
> +++ b/arch/arm/mach-omap2/cpuidle44xx.c
> @@ -22,6 +22,7 @@
>  #include "common.h"
>  #include "pm.h"
>  #include "prm.h"
> +#include "soc.h"
>  #include "clockdomain.h"
>  
>  #define MAX_CPUS	2
> @@ -31,6 +32,7 @@ struct idle_statedata {
>  	u32 cpu_state;
>  	u32 mpu_logic_state;
>  	u32 mpu_state;
> +	u32 mpu_state_vote;
>  };
>  
>  static struct idle_statedata omap4_idle_data[] = {
> @@ -51,12 +53,26 @@ static struct idle_statedata omap4_idle_data[] = {
>  	},
>  };
>  
> +static struct idle_statedata dra7_idle_data[] = {
> +	{
> +		.cpu_state = PWRDM_POWER_ON,
> +		.mpu_state = PWRDM_POWER_ON,
> +		.mpu_logic_state = PWRDM_POWER_ON,
> +	},
> +	{
> +		.cpu_state = PWRDM_POWER_RET,
> +		.mpu_state = PWRDM_POWER_RET,
> +		.mpu_logic_state = PWRDM_POWER_RET,
> +	},
> +};
> +
>  static struct powerdomain *mpu_pd, *cpu_pd[MAX_CPUS];
>  static struct clockdomain *cpu_clkdm[MAX_CPUS];
>  
>  static atomic_t abort_barrier;
>  static bool cpu_done[MAX_CPUS];
>  static struct idle_statedata *state_ptr = &omap4_idle_data[0];
> +static DEFINE_RAW_SPINLOCK(mpu_lock);
>  
>  /* Private functions */
>  
> @@ -78,6 +94,32 @@ static int omap_enter_idle_simple(struct cpuidle_device *dev,
>  	return index;
>  }
>  
> +static int omap_enter_idle_smp(struct cpuidle_device *dev,
> +			       struct cpuidle_driver *drv,
> +			       int index)
> +{
> +	struct idle_statedata *cx = state_ptr + index;
> +	unsigned long flag;
> +
> +	raw_spin_lock_irqsave(&mpu_lock, flag);
> +	cx->mpu_state_vote++;
> +	if (cx->mpu_state_vote == num_online_cpus()) {
> +		pwrdm_set_logic_retst(mpu_pd, cx->mpu_logic_state);
> +		omap_set_pwrdm_state(mpu_pd, cx->mpu_state);
> +	}
> +	raw_spin_unlock_irqrestore(&mpu_lock, flag);
> +
> +	omap4_enter_lowpower(dev->cpu, cx->cpu_state);
> +
> +	raw_spin_lock_irqsave(&mpu_lock, flag);
> +	if (cx->mpu_state_vote == num_online_cpus())
> +		omap_set_pwrdm_state(mpu_pd, PWRDM_POWER_ON);
> +	cx->mpu_state_vote--;
> +	raw_spin_unlock_irqrestore(&mpu_lock, flag);
> +
> +	return index;
> +}

Hmm, maybe OMAP5/DRA7 CPUidle driver should be a new one based on MCPM?

Kevin

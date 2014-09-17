Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbaIQXUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 19:20:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57288 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbaIQXUo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 19:20:44 -0400
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>, "Menon, Nishanth" <nm@ti.com>,
        Tony Lindgren <tony@atomide.com>, "Kristo, Tero" <t-kristo@ti.com>,
        "Paul Walmsley" <paul@pwsan.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "J, KEERTHY" <j-keerthy@ti.com>,
        =?iso-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>
Subject: RE: [PATCH 08/10] ARM: OMAP5/DRA7: PM: cpuidle MPU CSWR support
Thread-Topic: [PATCH 08/10] ARM: OMAP5/DRA7: PM: cpuidle MPU CSWR support
Thread-Index: AQHPvhG8IMkGuPSFcU+pa0gvRTGwoZwFd+aAgAClgO4=
Date: Wed, 17 Sep 2014 23:20:09 +0000
Message-ID: <448912EABC71F84BBCADFD3C67C4BE52CAC748@DBDE04.ent.ti.com>
References: <1408716154-26101-1-git-send-email-nm@ti.com>
 <1408716154-26101-9-git-send-email-nm@ti.com>,<5419D7BD.30003@linaro.org>
In-Reply-To: <5419D7BD.30003@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.56]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the format. Emailing from webmail.
________________________________________
From: Daniel Lezcano [daniel.lezcano@linaro.org]
Sent: Wednesday, September 17, 2014 2:49 PM
To: Menon, Nishanth; Shilimkar, Santosh; Tony Lindgren; Kristo, Tero; Paul Walmsley
Cc: Kevin Hilman; linux-arm-kernel@lists.infradead.org; linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org; J, KEERTHY; Benoît Cousson
Subject: Re: [PATCH 08/10] ARM: OMAP5/DRA7: PM: cpuidle MPU CSWR support

On 08/22/2014 07:02 AM, Nishanth Menon wrote:
> From: Santosh Shilimkar <santosh.shilimkar@ti.com>
>
> Add OMAP5/DRA74/72 CPUIDLE support.
>
> This patch adds MPUSS low power states in cpuidle.
>
>          C1 - CPU0 WFI + CPU1 WFI + MPU ON
>          C2 - CPU0 RET + CPU1 RET + MPU CSWR
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
>   arch/arm/mach-omap2/cpuidle44xx.c |   82 ++++++++++++++++++++++++++++++++++++-
>   arch/arm/mach-omap2/pm44xx.c      |    2 +-
>   2 files changed, 82 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/cpuidle44xx.c b/arch/arm/mach-omap2/cpuidle44xx.c
> index 2498ab0..8ad4f44 100644
> --- a/arch/arm/mach-omap2/cpuidle44xx.c
> +++ b/arch/arm/mach-omap2/cpuidle44xx.c
> @@ -22,6 +22,7 @@
>   #include "common.h"
>   #include "pm.h"
>   #include "prm.h"
> +#include "soc.h"
>   #include "clockdomain.h"
>
>   #define MAX_CPUS    2
> @@ -31,6 +32,7 @@ struct idle_statedata {
>       u32 cpu_state;
>       u32 mpu_logic_state;
>       u32 mpu_state;
> +     u32 mpu_state_vote;
>   };
>
>   static struct idle_statedata omap4_idle_data[] = {
> @@ -51,12 +53,26 @@ static struct idle_statedata omap4_idle_data[] = {
>       },
>   };
>
> +static struct idle_statedata dra7_idle_data[] = {
> +     {
> +             .cpu_state = PWRDM_POWER_ON,
> +             .mpu_state = PWRDM_POWER_ON,
> +             .mpu_logic_state = PWRDM_POWER_ON,
> +     },
> +     {
> +             .cpu_state = PWRDM_POWER_RET,
> +             .mpu_state = PWRDM_POWER_RET,
> +             .mpu_logic_state = PWRDM_POWER_RET,
> +     },
> +};
> +
>   static struct powerdomain *mpu_pd, *cpu_pd[MAX_CPUS];
>   static struct clockdomain *cpu_clkdm[MAX_CPUS];
>
>   static atomic_t abort_barrier;
>   static bool cpu_done[MAX_CPUS];
>   static struct idle_statedata *state_ptr = &omap4_idle_data[0];
> +static DEFINE_RAW_SPINLOCK(mpu_lock);
>
>   /* Private functions */
>
> @@ -78,6 +94,32 @@ static int omap_enter_idle_simple(struct cpuidle_device *dev,
>       return index;
>   }
>
> +static int omap_enter_idle_smp(struct cpuidle_device *dev,
> +                            struct cpuidle_driver *drv,
> +                            int index)
> +{
> +     struct idle_statedata *cx = state_ptr + index;
> +     unsigned long flag;
> +
> +     raw_spin_lock_irqsave(&mpu_lock, flag);

Why do you need this spin_lock_irqsave ? Aren't the local irqs already
disabled ?

[Santosh] Actually at one point of time before the idle consolidation the local
irq disable was inside the idle drivers. Now with that moved to core layer,
I think plain spin_lock/unlock() should work.

> +     cx->mpu_state_vote++;
> +     if (cx->mpu_state_vote == num_online_cpus()) {
> +             pwrdm_set_logic_retst(mpu_pd, cx->mpu_logic_state);
> +             omap_set_pwrdm_state(mpu_pd, cx->mpu_state);
> +     }
> +     raw_spin_unlock_irqrestore(&mpu_lock, flag);
> +
> +     omap4_enter_lowpower(dev->cpu, cx->cpu_state);
> +
> +     raw_spin_lock_irqsave(&mpu_lock, flag);
> +     if (cx->mpu_state_vote == num_online_cpus())
> +             omap_set_pwrdm_state(mpu_pd, PWRDM_POWER_ON);
> +     cx->mpu_state_vote--;
> +     raw_spin_unlock_irqrestore(&mpu_lock, flag);

I am not sure that will work. What happens if a cpu exits idle and then
re-enter idle immediately ?

[Santosh] It works and that case is already taken care. CPU exist the idle and then votes
out for cluster state and if it reenters with the right targeted state, the cluster state would
be picked.


Could you try a long run of this little program:

https://git.linaro.org/power/pm-qa.git/blob/HEAD:/cpuidle/cpuidle_killer.c

[Santosh] I am sure there will not be any issue with the long run test case here.
Lets see if Nishant sees anything otherwise

Regards,
Santosh
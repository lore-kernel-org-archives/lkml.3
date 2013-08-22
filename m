Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab3HVEeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 00:34:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:38646 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab3HVEeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 00:34:10 -0400
Message-ID: <1377142130.25016.273.camel@pasglop>
Subject: Re: [RFC V2 PATCH 4/6] cpuidle/ppc: Add longnap state to the idle
 states on powernv
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: fweisbec@gmail.com, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, galak@kernel.crashing.org,
        deepthi@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, rjw@sisk.pl,
        john.stultz@linaro.org, tglx@linutronix.de, chenhui.zhao@freescale.com,
        michael@ellerman.id.au, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Date: Thu, 22 Aug 2013 13:28:50 +1000
In-Reply-To: <20130814115623.5193.36974.stgit@preeti.in.ibm.com>
References: <20130814115311.5193.32212.stgit@preeti.in.ibm.com>
	 <20130814115623.5193.36974.stgit@preeti.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-14 at 17:26 +0530, Preeti U Murthy wrote:
> This patch hooks into the existing broadcast framework along with the support
> that this patchset introduces for ppc, and the cpuidle driver backend
> for powernv(posted out by Deepthi Dharwar:https://lkml.org/lkml/2013/7/23/128)
> to add sleep state as one of the deep idle states, in which the decrementer
> is switched off.
> 
> However in this patch, we only emulate sleep by going into a state which does
> a nap with the decrementer interrupts disabled, termed as longnap. This enables
> focus on the timer broadcast framework for ppc in this series of patches ,
> which is required as a first step to enable sleep on ppc.

This is only for debug / proof of concept right ? We should use a real
sleep here.

If we need to know whether the FW supports it (PORE etc...) we shall add
a device-tree property from the FW to indicate that fact.

Cheers,
Ben.

> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> ---
> 
>  arch/powerpc/platforms/powernv/processor_idle.c |   48 +++++++++++++++++++++++
>  1 file changed, 47 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/platforms/powernv/processor_idle.c b/arch/powerpc/platforms/powernv/processor_idle.c
> index f43ad91a..9aca502 100644
> --- a/arch/powerpc/platforms/powernv/processor_idle.c
> +++ b/arch/powerpc/platforms/powernv/processor_idle.c
> @@ -9,16 +9,18 @@
>  #include <linux/cpuidle.h>
>  #include <linux/cpu.h>
>  #include <linux/notifier.h>
> +#include <linux/clockchips.h>
>  
>  #include <asm/machdep.h>
>  #include <asm/runlatch.h>
> +#include <asm/time.h>
>  
>  struct cpuidle_driver powernv_idle_driver = {
>  	.name =		"powernv_idle",
>  	.owner =	THIS_MODULE,
>  };
>  
> -#define MAX_IDLE_STATE_COUNT	2
> +#define MAX_IDLE_STATE_COUNT	3
>  
>  static int max_idle_state = MAX_IDLE_STATE_COUNT - 1;
>  static struct cpuidle_device __percpu *powernv_cpuidle_devices;
> @@ -54,6 +56,43 @@ static int nap_loop(struct cpuidle_device *dev,
>  	return index;
>  }
>  
> +/* Emulate sleep, with long nap.
> + * During sleep, the core does not receive decrementer interrupts.
> + * Emulate sleep using long nap with decrementers interrupts disabled.
> + * This is an initial prototype to test the timer offload framework for ppc.
> + * We will eventually introduce the sleep state once the timer offload framework
> + * for ppc is stable.
> + */
> +static int longnap_loop(struct cpuidle_device *dev,
> +				struct cpuidle_driver *drv,
> +				int index)
> +{
> +	int cpu = dev->cpu;
> +
> +	unsigned long lpcr = mfspr(SPRN_LPCR);
> +
> +	lpcr &= ~(LPCR_MER | LPCR_PECE); /* lpcr[mer] must be 0 */
> +
> +	/* exit powersave upon external interrupt, but not decrementer
> +	 * interrupt, Emulate sleep.
> +	 */
> +	lpcr |= LPCR_PECE0;
> +
> +	if (cpu != bc_cpu) {
> +		mtspr(SPRN_LPCR, lpcr);
> +		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
> +		power7_nap();
> +		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
> +	} else {
> +		/* Wakeup on a decrementer interrupt, Do a nap */
> +		lpcr |= LPCR_PECE1;
> +		mtspr(SPRN_LPCR, lpcr);
> +		power7_nap();
> +	}
> +
> +	return index;
> +}
> +
>  /*
>   * States for dedicated partition case.
>   */
> @@ -72,6 +111,13 @@ static struct cpuidle_state powernv_states[MAX_IDLE_STATE_COUNT] = {
>  		.exit_latency = 10,
>  		.target_residency = 100,
>  		.enter = &nap_loop },
> +	 { /* LongNap */
> +		.name = "LongNap",
> +		.desc = "LongNap",
> +		.flags = CPUIDLE_FLAG_TIME_VALID,
> +		.exit_latency = 10,
> +		.target_residency = 100,
> +		.enter = &longnap_loop },
>  };
>  
>  static int powernv_cpuidle_add_cpu_notifier(struct notifier_block *n,



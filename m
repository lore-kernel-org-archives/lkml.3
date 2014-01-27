Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaA0IfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 03:35:06 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:53484 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaA0IfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 03:35:04 -0500
Message-ID: <52E61A37.1070207@linaro.org>
Date: Mon, 27 Jan 2014 09:35:03 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9] PPC: remove redundant cpuidle_idle_call()
References: <1390802904-28399-1-git-send-email-nicolas.pitre@linaro.org> <1390802904-28399-7-git-send-email-nicolas.pitre@linaro.org>
In-Reply-To: <1390802904-28399-7-git-send-email-nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 07:08 AM, Nicolas Pitre wrote:
> The core idle loop now takes care of it.  However a few things need
> checking:
>
> - Invocation of cpuidle_idle_call() in pseries_lpar_idle() happened
>    through arch_cpu_idle() and was therefore always preceded by a call
>    to ppc64_runlatch_off().  To preserve this property now that
>    cpuidle_idle_call() is invoked directly from core code, a call to
>    ppc64_runlatch_off() has been added to idle_loop_prolog() in
>    platforms/pseries/processor_idle.c.
>
> - Similarly, cpuidle_idle_call() was followed by ppc64_runlatch_off()
>    so a call to the later has been added to idle_loop_epilog().
>
> - And since arch_cpu_idle() always made sure to re-enable IRQs if they
>    were not enabled, this is now
>    done in idle_loop_epilog() as well.
>
> The above was made in order to keep the execution flow close to the
> original.  I don't know if that was strictly necessary. Someone well
> aquainted with the platform details might find some room for possible
> optimizations.
>
> Signed-off-by: Nicolas Pitre <nico@linaro.org>

Added Preeti U Murthy as recipient.

> ---
>   arch/powerpc/platforms/pseries/processor_idle.c |  5 ++++
>   arch/powerpc/platforms/pseries/setup.c          | 34 ++++++++++---------------
>   2 files changed, 19 insertions(+), 20 deletions(-)
>
> diff --git a/arch/powerpc/platforms/pseries/processor_idle.c b/arch/powerpc/platforms/pseries/processor_idle.c
> index a166e38bd6..72ddfe3d2f 100644
> --- a/arch/powerpc/platforms/pseries/processor_idle.c
> +++ b/arch/powerpc/platforms/pseries/processor_idle.c
> @@ -33,6 +33,7 @@ static struct cpuidle_state *cpuidle_state_table;
>
>   static inline void idle_loop_prolog(unsigned long *in_purr)
>   {
> +	ppc64_runlatch_off();
>   	*in_purr = mfspr(SPRN_PURR);
>   	/*
>   	 * Indicate to the HV that we are idle. Now would be
> @@ -49,6 +50,10 @@ static inline void idle_loop_epilog(unsigned long in_purr)
>   	wait_cycles += mfspr(SPRN_PURR) - in_purr;
>   	get_lppaca()->wait_state_cycles = cpu_to_be64(wait_cycles);
>   	get_lppaca()->idle = 0;
> +
> +	if (irqs_disabled())
> +		local_irq_enable();
> +	ppc64_runlatch_on();
>   }
>
>   static int snooze_loop(struct cpuidle_device *dev,
> diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
> index c1f1908587..7604c19d54 100644
> --- a/arch/powerpc/platforms/pseries/setup.c
> +++ b/arch/powerpc/platforms/pseries/setup.c
> @@ -39,7 +39,6 @@
>   #include <linux/irq.h>
>   #include <linux/seq_file.h>
>   #include <linux/root_dev.h>
> -#include <linux/cpuidle.h>
>   #include <linux/of.h>
>   #include <linux/kexec.h>
>
> @@ -356,29 +355,24 @@ early_initcall(alloc_dispatch_log_kmem_cache);
>
>   static void pseries_lpar_idle(void)
>   {
> -	/* This would call on the cpuidle framework, and the back-end pseries
> -	 * driver to  go to idle states
> +	/*
> +	 * Default handler to go into low thread priority and possibly
> +	 * low power mode by cedeing processor to hypervisor
>   	 */
> -	if (cpuidle_idle_call()) {
> -		/* On error, execute default handler
> -		 * to go into low thread priority and possibly
> -		 * low power mode by cedeing processor to hypervisor
> -		 */
>
> -		/* Indicate to hypervisor that we are idle. */
> -		get_lppaca()->idle = 1;
> +	/* Indicate to hypervisor that we are idle. */
> +	get_lppaca()->idle = 1;
>
> -		/*
> -		 * Yield the processor to the hypervisor.  We return if
> -		 * an external interrupt occurs (which are driven prior
> -		 * to returning here) or if a prod occurs from another
> -		 * processor. When returning here, external interrupts
> -		 * are enabled.
> -		 */
> -		cede_processor();
> +	/*
> +	 * Yield the processor to the hypervisor.  We return if
> +	 * an external interrupt occurs (which are driven prior
> +	 * to returning here) or if a prod occurs from another
> +	 * processor. When returning here, external interrupts
> +	 * are enabled.
> +	 */
> +	cede_processor();
>
> -		get_lppaca()->idle = 0;
> -	}
> +	get_lppaca()->idle = 0;
>   }
>
>   /*
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


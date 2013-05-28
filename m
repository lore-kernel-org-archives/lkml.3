Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab3E1UYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 16:24:21 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:62020 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab3E1UYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 16:24:20 -0400
Message-ID: <51A51271.2070506@linaro.org>
Date: Tue, 28 May 2013 13:24:17 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [RFC PATCH 2/2] clocksource: dw_apb: allow build for architectures
 other than arm
References: <1369570367-994-2-git-send-email-baruch@tkos.co.il>
In-Reply-To: <1369570367-994-2-git-send-email-baruch@tkos.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2013 05:12 AM, Baruch Siach wrote:
> ARM is the only architecture providing sched_clock.h and setup_sched_clock().
> Implement sched_clock() for use by other architectures.
>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jamie Iles <jamie@jamieiles.com>
> Cc: Dinh Nguyen <dinguyen@altera.com>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>   arch/arm/Kconfig                      |    1 +
>   drivers/clocksource/Kconfig           |    3 +++
>   drivers/clocksource/dw_apb_timer_of.c |   18 ++++++++++++++++++
>   3 files changed, 22 insertions(+)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 1cacda4..7489604 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -47,6 +47,7 @@ config ARM
>   	select HAVE_OPROFILE if (HAVE_PERF_EVENTS)
>   	select HAVE_PERF_EVENTS
>   	select HAVE_REGS_AND_STACK_ACCESS_API
> +	select HAVE_SETUP_SCHED_CLOCK
>   	select HAVE_SYSCALL_TRACEPOINTS
>   	select HAVE_UID16
>   	select KTIME_SCALAR
> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> index e507ab7..0fd6d13 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -1,3 +1,6 @@
> +config HAVE_SETUP_SCHED_CLOCK
> +	bool
> +
>   config CLKSRC_OF
>   	bool
>   
> diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
> index 5a61ebc..9fdb4d3 100644
> --- a/drivers/clocksource/dw_apb_timer_of.c
> +++ b/drivers/clocksource/dw_apb_timer_of.c
> @@ -21,7 +21,11 @@
>   #include <linux/of_address.h>
>   #include <linux/of_irq.h>
>   
> +#ifdef CONFIG_HAVE_SETUP_SCHED_CLOCK
>   #include <asm/sched_clock.h>
> +#else
> +#include <linux/sched.h>
> +#endif
>   
>   static void timer_get_base_and_rate(struct device_node *np,
>   				    void __iomem **base, u32 *rate)
> @@ -73,6 +77,9 @@ static void add_clocksource(struct device_node *source_timer)
>   }
>   
>   static void __iomem *sched_io_base;
> +#ifndef CONFIG_HAVE_SETUP_SCHED_CLOCK
> +static u64 sched_clock_mult __read_mostly;
> +#endif
>   
>   static u32 read_sched_clock(void)
>   {
> @@ -97,7 +104,11 @@ static void init_sched_clock(void)
>   	timer_get_base_and_rate(sched_timer, &sched_io_base, &rate);
>   	of_node_put(sched_timer);
>   
> +#ifdef CONFIG_HAVE_SETUP_SCHED_CLOCK
>   	setup_sched_clock(read_sched_clock, 32, rate);
> +#else
> +	sched_clock_mult = NSEC_PER_SEC / rate;
> +#endif
>   }

Can you rework this to not use #ifdefs within the function? They make it 
annoying to read the code.

Instead maybe have a local setup_sched_clock() function that sets the 
mult value for the !CONFIG_HAVE_SETUP_SCHED_CLOCK case?

>   
>   static const struct of_device_id osctimer_ids[] __initconst = {
> @@ -124,3 +135,10 @@ void __init dw_apb_timer_init(void)
>   
>   	init_sched_clock();
>   }
> +
> +#ifndef CONFIG_HAVE_SETUP_SCHED_CLOCK
> +unsigned long long notrace sched_clock()
> +{
> +	return read_sched_clock() * sched_clock_mult;
> +}
> +#endif

Also, can you try to condense the number of #ifndef 
CONFIG_HAVE_SETUP_SCHED_CLOCK checks to one, and consolidate the needed 
functions all in that one conditional?

thanks
-john


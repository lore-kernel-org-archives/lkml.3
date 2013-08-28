Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab3H1Kz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:55:29 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33089 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab3H1Kz1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:55:27 -0400
Message-ID: <521DD72D.7070000@arm.com>
Date: Wed, 28 Aug 2013 11:55:41 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v5 5/5] drivers: clocksource: add CPU PM notifier for
 ARM architected timer
References: <1377686689-30828-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1377686689-30828-6-git-send-email-Sudeep.KarkadaNagesha@arm.com>
In-Reply-To: <1377686689-30828-6-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 28 Aug 2013 10:55:24.0328 (UTC) FILETIME=[19068280:01CEA3DD]
X-MC-Unique: 113082811552600601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/08/13 11:44, Sudeep KarkadaNagesha wrote:
> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> Few control settings done in architected timer as part of initialisation
> can be lost when CPU enters deeper power states. They need to be
> re-initialised when the CPU is (warm)reset again.
> 
> This patch adds CPU PM notifiers to do the timer initialisation on warm
> resets. It also save the event stream divider value calculated during
> cold reset and uses the same in warm reset path.
> 
Ah, forgot to update the commit log. It's now updated:

Few control settings done in architected timer as part of initialisation
can be lost when CPU enters deeper power states. They need to be
restored when the CPU is (warm)reset again.

This patch adds CPU PM notifiers to save the counter control register
when entering low power modes and restore it when CPU exits low power.

> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Reviewed-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> ---
>  drivers/clocksource/arm_arch_timer.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index f42bef4..ffb0bfb 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -13,6 +13,7 @@
>  #include <linux/device.h>
>  #include <linux/smp.h>
>  #include <linux/cpu.h>
> +#include <linux/cpu_pm.h>
>  #include <linux/clockchips.h>
>  #include <linux/interrupt.h>
>  #include <linux/of_irq.h>
> @@ -281,6 +282,33 @@ static struct notifier_block arch_timer_cpu_nb = {
>  	.notifier_call = arch_timer_cpu_notify,
>  };
>  
> +#ifdef CONFIG_CPU_PM
> +static unsigned int saved_cntkctl;
> +static int arch_timer_cpu_pm_notify(struct notifier_block *self,
> +				    unsigned long action, void *hcpu)
> +{
> +	if (action == CPU_PM_ENTER)
> +		saved_cntkctl = arch_timer_get_cntkctl();
> +	else if (action == CPU_PM_ENTER_FAILED || action == CPU_PM_EXIT)
> +		arch_timer_set_cntkctl(saved_cntkctl);
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block arch_timer_cpu_pm_notifier = {
> +	.notifier_call = arch_timer_cpu_pm_notify,
> +};
> +
> +static int __init arch_timer_cpu_pm_init(void)
> +{
> +	return cpu_pm_register_notifier(&arch_timer_cpu_pm_notifier);
> +}
> +#else
> +static int __init arch_timer_cpu_pm_init(void)
> +{
> +	return 0;
> +}
> +#endif
> +
>  static int __init arch_timer_register(void)
>  {
>  	int err;
> @@ -330,11 +358,17 @@ static int __init arch_timer_register(void)
>  	if (err)
>  		goto out_free_irq;
>  
> +	err = arch_timer_cpu_pm_init();
> +	if (err)
> +		goto out_unreg_notify;
> +
>  	/* Immediately configure the timer on the boot CPU */
>  	arch_timer_setup(this_cpu_ptr(arch_timer_evt));
>  
>  	return 0;
>  
> +out_unreg_notify:
> +	unregister_cpu_notifier(&arch_timer_cpu_nb);
>  out_free_irq:
>  	if (arch_timer_use_virtual)
>  		free_percpu_irq(arch_timer_ppi[VIRT_PPI], arch_timer_evt);
> 



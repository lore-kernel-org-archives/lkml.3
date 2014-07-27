Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751009AbaG0XAL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 19:00:11 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62537 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750771AbaG0XAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 19:00:06 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH RFC v2] PM / sleep: Fix racing timers
Date: Mon, 28 Jul 2014 01:18:35 +0200
Message-ID: <1461880.klCWmqfb3F@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1406322408-15408-1-git-send-email-soren.brinkmann@xilinx.com>
References: <53D083C5.2000501@linaro.org> <1406322408-15408-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 25, 2014 02:06:48 PM Soren Brinkmann wrote:
> On platforms that do not power off during suspend, successfully entering
> suspend races with timers.
> 
> The race happening in a couple of location is:
> 
>   1. disable IRQs   		(e.g. arch_suspend_disable_irqs())
>      ...
>   2. syscore_suspend()
>       -> timekeeping_suspend()
>        -> clockevents_notify(SUSPEND)
>         -> tick_suspend()   	(timers are turned off here)
>      ...
>   3. wfi            		(wait for wake-IRQ here)
> 
> Between steps 1 and 2 the timers can still generate interrupts that are
> not handled and stay pending until step 3. That pending IRQ causes an
> immediate - spurious - wake.
> 
> The solution is to move the clockevents suspend/resume notification
> out of the syscore_suspend step and explictly call them at the appropriate
> time in the suspend/hibernation paths. I.e. timers are suspend _before_
> IRQs get disabled. And accordingly in the resume path.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> Hi,
> 
> This is my second shot at this. I followed John's suggestion to keep the
> timekeeping suspend where it is and just move the shutdown of the clockevent
> devices around.

John, what do you think?


>  kernel/power/hibernate.c  | 9 +++++++++
>  kernel/power/suspend.c    | 5 +++++
>  kernel/time/timekeeping.c | 1 -
>  3 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index fcc2611d3f14..ab9f807e2ccb 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -285,6 +285,8 @@ static int create_image(int platform_mode)
>  	if (error || hibernation_test(TEST_CPUS))
>  		goto Enable_cpus;
>  
> +	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
> +
>  	local_irq_disable();
>  
>  	error = syscore_suspend();
> @@ -316,6 +318,7 @@ static int create_image(int platform_mode)
>  	syscore_resume();
>  
>   Enable_irqs:
> +	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
>  	local_irq_enable();
>  
>   Enable_cpus:
> @@ -440,6 +443,8 @@ static int resume_target_kernel(bool platform_mode)
>  	if (error)
>  		goto Enable_cpus;
>  
> +	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
> +
>  	local_irq_disable();
>  
>  	error = syscore_suspend();
> @@ -474,6 +479,7 @@ static int resume_target_kernel(bool platform_mode)
>  	syscore_resume();
>  
>   Enable_irqs:
> +	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
>  	local_irq_enable();
>  
>   Enable_cpus:
> @@ -555,6 +561,8 @@ int hibernation_platform_enter(void)
>  	if (error)
>  		goto Platform_finish;
>  
> +	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
> +
>  	local_irq_disable();
>  	syscore_suspend();
>  	if (pm_wakeup_pending()) {
> @@ -568,6 +576,7 @@ int hibernation_platform_enter(void)
>  
>   Power_up:
>  	syscore_resume();
> +	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
>  	local_irq_enable();
>  	enable_nonboot_cpus();
>  
> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index ed35a4790afe..ca6c56a87ea3 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -12,6 +12,7 @@
>  #include <linux/delay.h>
>  #include <linux/errno.h>
>  #include <linux/init.h>
> +#include <linux/clockchips.h>
>  #include <linux/console.h>
>  #include <linux/cpu.h>
>  #include <linux/cpuidle.h>
> @@ -253,6 +254,8 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
>  	if (error || suspend_test(TEST_CPUS))
>  		goto Enable_cpus;
>  
> +	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
> +
>  	arch_suspend_disable_irqs();
>  	BUG_ON(!irqs_disabled());
>  
> @@ -270,6 +273,8 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
>  		syscore_resume();
>  	}
>  
> +	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
> +
>  	arch_suspend_enable_irqs();
>  	BUG_ON(irqs_disabled());
>  
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 32d8d6aaedb8..d2f21cbe2bfd 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -1032,7 +1032,6 @@ static int timekeeping_suspend(void)
>  	write_seqcount_end(&timekeeper_seq);
>  	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
>  
> -	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
>  	clocksource_suspend();
>  	clockevents_suspend();
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

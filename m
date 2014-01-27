Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaA0IXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 03:23:49 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63204 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbaA0IXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 03:23:48 -0500
Message-ID: <52E61793.4020608@linaro.org>
Date: Mon, 27 Jan 2014 09:23:47 +0100
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
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 2/9] ARM64: get rid of arch_cpu_idle_prepare()
References: <1390802904-28399-1-git-send-email-nicolas.pitre@linaro.org> <1390802904-28399-3-git-send-email-nicolas.pitre@linaro.org>
In-Reply-To: <1390802904-28399-3-git-send-email-nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 07:08 AM, Nicolas Pitre wrote:
> ARM and ARM64 are the only two architectures implementing
> arch_cpu_idle_prepare() simply to call local_fiq_enable().
>
> We have secondary_start_kernel() already calling local_fiq_enable() and
> this is done a second time in arch_cpu_idle_prepare() in that case. And
> enabling FIQs has nothing to do with idling the CPU to start with.
>
> So let's introduce init_fiq_boot_cpu() to take care of FIQs on the boot
> CPU and remove arch_cpu_idle_prepare(). This is now done a bit earlier
> at late_initcall time but this shouldn't make a difference in practice
> given that FIQs are not currently used on ARM64.
>
> Signed-off-by: Nicolas Pitre <nico@linaro.org>

Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>   arch/arm64/kernel/process.c | 5 -----
>   arch/arm64/kernel/setup.c   | 7 +++++++
>   2 files changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index de17c89985..f6c733da67 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -84,11 +84,6 @@ EXPORT_SYMBOL_GPL(pm_power_off);
>   void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
>   EXPORT_SYMBOL_GPL(arm_pm_restart);
>
> -void arch_cpu_idle_prepare(void)
> -{
> -	local_fiq_enable();
> -}
> -
>   /*
>    * This is our default idle handler.
>    */
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index bd9bbd0e44..259557983a 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -255,6 +255,13 @@ static int __init arm64_device_init(void)
>   }
>   arch_initcall(arm64_device_init);
>
> +static int __init init_fiq_boot_cpu(void)
> +{
> +	local_fiq_enable();
> +	return 0;
> +}
> +late_initcall(init_fiq_boot_cpu);
> +
>   static DEFINE_PER_CPU(struct cpu, cpu_data);
>
>   static int __init topology_init(void)
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


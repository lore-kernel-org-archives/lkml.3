Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaAOJ3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:29:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57923 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaAOJ3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:29:06 -0500
Message-ID: <1389778131.6223.4.camel@marge.simpson.net>
Subject: Re: [PATCH REGRESSION FIX] x86 idle: restore mwait_idle()
From: Mike Galbraith <bitbucket@online.de>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Ian Malone <ibmalone@gmail.com>,
        Josh Boyer <jwboyer@redhat.com>, stable@vger.kernel.org
Date: Wed, 15 Jan 2014 10:28:51 +0100
In-Reply-To: <345254a551eb5a6a866e048d7ab570fd2193aca4.1389763084.git.len.brown@intel.com>
References: <1ae2a8af42281d6b9888ac8c76bab7bd2f431d44.1389763084.git.len.brown@intel.com>
	 <345254a551eb5a6a866e048d7ab570fd2193aca4.1389763084.git.len.brown@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:e/0g3/7mDvPXo8ZS8gwf68QrIcXbx917QlQsqQ+Z1Jh
 yT8PA9KqrG+DwKXiQJedQU3B4xxjm36C7htYlAPxQpxW3bGd9L
 qaGLt9MMAcmK6CG8hOW55F0VBXmYdlMLeTY0ScTnZojeesLL1F
 9agkApCipcwGfJPq6DgaB0qUibYnMgBy9V2wR/VWH50YYdWOR+
 4Bw970n40YKUz4A4IMmg9THHs4Wg5D7P0uL3Fgib+Ei6MtrLiH
 +DdL/4iiXs0udqQ5EodIhxe+aVYz4d8ATSeJB+tn5h0smVx7p8
 c1qI9Di8Yni6n6G6JAt4WZmTQ5yrGBOqXIbZUGDgeHoeiWvbpr
 Hj5rKK8+XRVxM1hHIvNDpktED+vlrP43nv3ecrXZ3S8TAhlq8H
 WgTF7vwD05U8g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-15 at 00:37 -0500, Len Brown wrote: 
> From: Len Brown <len.brown@intel.com>
> 
> In Linux-3.9 we removed the mwait_idle() loop:
> 'x86 idle: remove mwait_idle() and "idle=mwait" cmdline param'
> (69fb3676df3329a7142803bb3502fa59dc0db2e3)
> 
> The reasoning was that modern machines should be sufficiently
> happy during the boot process using the default_idle() HALT loop,
> until cpuidle loads and either acpi_idle or intel_idle
> invoke the newer MWAIT-with-hints idle loop.
> 
> But two machines reported problems:
> 1. Certain Core2-era machines support MWAIT-C1 and HALT only.
>    MWAIT-C1 is preferred for optimal power and performance.
>    But if they support just C1, cpuidle never loads and
>    so they use the boot-time default idle loop forever.

Q6600 box (allegedly) has a slightly greenish tinge again.

Tested-by: Mike Galbraith <bitbucket@online.de>

> 2. Some laptops will boot-hang if HALT is used,
>    but will boot successfully if MWAIT is used.
>    This appears to be a hidden assumption in BIOS SMI,
>    that is presumably valid on the proprietary OS
>    where the BIOS was validated.
> 
>    https://bugzilla.kernel.org/show_bug.cgi?id=60770
> 
> So here we effectively revert the patch above, restoring
> the mwait_idle() loop.  However, we don't bother restoring
> the idle=mwait cmdline parameter, since it appears to add
> no value.
> 
> Maintainer notes:
> For 3.9, simply revert 69fb3676df
> for 3.10, patch -F3 applies, fuzz needed due to __cpuinit use in context
> For 3.11, 3.12, 3.13, this patch applies cleanly
> 
> Cc: Mike Galbraith <bitbucket@online.de>
> Cc: Ian Malone <ibmalone@gmail.com>
> Cc: Josh Boyer <jwboyer@redhat.com>
> Cc: <stable@vger.kernel.org> # 3.9, 3.10, 3.11, 3.12, 3.13
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  arch/x86/kernel/process.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 3fb8d95..db471a8 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -398,6 +398,49 @@ static void amd_e400_idle(void)
>  		default_idle();
>  }
>  
> +/*
> + * Intel Core2 and older machines prefer MWAIT over HALT for C1.
> + * We can't rely on cpuidle installing MWAIT, because it will not load
> + * on systems that support only C1 -- so the boot default must be MWAIT.
> + *  
> + * Some AMD machines are the opposite, they depend on using HALT.
> + *
> + * So for default C1, which is used during boot until cpuidle loads,
> + * use MWAIT-C1 on Intel HW that has it, else use HALT.
> + */
> +static int prefer_mwait_c1_over_halt(const struct cpuinfo_x86 *c)
> +{
> +	if (c->x86_vendor != X86_VENDOR_INTEL)
> +		return 0;
> +
> +	if (!cpu_has(c, X86_FEATURE_MWAIT))
> +		return 0;
> +
> +	return 1;
> +}
> +
> +/*
> + * MONITOR/MWAIT with no hints, used for default default C1 state.
> + * This invokes MWAIT with interrutps enabled and no flags,
> + * which is backwards compatible with the original MWAIT implementation.
> + */
> +
> +static void mwait_idle(void)
> +{
> +	if (!need_resched()) {
> +		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
> +			clflush((void *)&current_thread_info()->flags);
> +
> +		__monitor((void *)&current_thread_info()->flags, 0, 0);
> +		smp_mb();
> +		if (!need_resched())
> +			__sti_mwait(0, 0);
> +		else
> +			local_irq_enable();
> +	} else
> +		local_irq_enable();
> +}
> +
>  void select_idle_routine(const struct cpuinfo_x86 *c)
>  {
>  #ifdef CONFIG_SMP
> @@ -411,6 +454,9 @@ void select_idle_routine(const struct cpuinfo_x86 *c)
>  		/* E400: APIC timer interrupt does not wake up CPU from C1e */
>  		pr_info("using AMD E400 aware idle routine\n");
>  		x86_idle = amd_e400_idle;
> +	} else if (prefer_mwait_c1_over_halt(c)) {
> +		pr_info("using mwait in idle threads\n");
> +		x86_idle = mwait_idle;
>  	} else
>  		x86_idle = default_idle;
>  }



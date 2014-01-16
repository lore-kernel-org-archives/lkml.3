Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbaAPWAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 17:00:32 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:39259 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaAPWA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 17:00:29 -0500
Message-ID: <52D8567A.8090308@mit.edu>
Date: Thu, 16 Jan 2014 14:00:26 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>, x86@kernel.org
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Mike Galbraith <bitbucket@online.de>,
        Ian Malone <ibmalone@gmail.com>, Josh Boyer <jwboyer@redhat.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH REGRESSION FIX] x86 idle: restore mwait_idle()
References: <1ae2a8af42281d6b9888ac8c76bab7bd2f431d44.1389763084.git.len.brown@intel.com> <345254a551eb5a6a866e048d7ab570fd2193aca4.1389763084.git.len.brown@intel.com>
In-Reply-To: <345254a551eb5a6a866e048d7ab570fd2193aca4.1389763084.git.len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 09:37 PM, Len Brown wrote:
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
> 
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

Admittedly, there may be relatively few users left, but SMP users on
C1-only Core 2 machines can, in principle, benefit from the monitor
functionality of mwait to avoid rescheduling IPIs.  This stuff changed
recently so it now works with the cpuidle drivers (it used to be
terminally broken).  Should something be twiddling TS_POLLING
differently so that HLT gets the IPIs but mwait doesn't?

--Andy

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
> 


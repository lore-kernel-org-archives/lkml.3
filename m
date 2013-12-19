Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab3LSMXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:23:07 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:38364 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab3LSMXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:23:02 -0500
Date: Thu, 19 Dec 2013 13:22:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86 idle: repair large-server 50-watt idle-power
 regression
Message-ID: <20131219122257.GC11279@gmail.com>
References: <baff264285f6e585df757d58b17788feabc68918.1387403066.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <baff264285f6e585df757d58b17788feabc68918.1387403066.git.len.brown@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> From: Len Brown <len.brown@intel.com>
> 
> Linux 3.10 changed the timing of how thread_info->flags is touched:
> 
> 	x86: Use generic idle loop
> 	(7d1a941731fabf27e5fb6edbebb79fe856edb4e5)
> 
> This caused Intel NHM-EX and WSM-EX servers to experience a large number
> of immediate MONITOR/MWAIT break wakeups, which caused cpuidle to demote
> from deep C-states to shallow C-states, which caused these platforms
> to experience a significant increase in idle power.
> 
> Note that this issue was already present before the commit above,
> however, it wasn't seen often enough to be noticed in power measurements.
> 
> Here we extend an errata workaround from the Core2 EX "Dunnington"
> to extend to NHM-EX and WSM-EX, to prevent these immediate
> returns from MWAIT, reducing idle power on these platforms.
> 
> While only acpi_idle ran on Dunnington, intel_idle
> may also run on these two newer systems.
> As of today, there are no other models that are known
> to need this tweak.
> 
> ref: https://lkml.org/lkml/2013/12/7/22
> Signed-off-by: Len Brown <len.brown@intel.com>
> Cc: <stable@vger.kernel.org> # 3.12.x, 3.11.x, 3.10.x
> ---
>  arch/x86/kernel/cpu/intel.c | 3 ++-
>  drivers/idle/intel_idle.c   | 3 +++
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index dc1ec0d..ea04b34 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -387,7 +387,8 @@ static void init_intel(struct cpuinfo_x86 *c)
>  			set_cpu_cap(c, X86_FEATURE_PEBS);
>  	}
>  
> -	if (c->x86 == 6 && c->x86_model == 29 && cpu_has_clflush)
> +	if (c->x86 == 6 && cpu_has_clflush &&
> +	    (c->x86_model == 29 || c->x86_model == 46 || c->x86_model == 47))
>  		set_cpu_cap(c, X86_FEATURE_CLFLUSH_MONITOR);
>  
>  #ifdef CONFIG_X86_64
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index 92d1206..f80b700 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -377,6 +377,9 @@ static int intel_idle(struct cpuidle_device *dev,
>  
>  	if (!current_set_polling_and_test()) {
>  
> +		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
> +			clflush((void *)&current_thread_info()->flags);
> +
>  		__monitor((void *)&current_thread_info()->flags, 0, 0);

I don't think either of these casts to '(void *)' is needed, both the 
clflush() and __monitor() will take pointers.

Looks good to me otherwise - except that maybe the best way to 
represent this quirk would be for the CLFLUSH+MONITOR sequence to be a 
single 'instruction' which is patched in dynamically during bootup, 
using our usual alternatives framework.

On non-affected CPUs a NOP would remain in place of the CLFLUSH, 
eliminating the branch above.

So the whole thing could be thought of as a slightly more complex 
'monitor' instruction - not exposing the quirk details to actual usage 
sites.

Thanks,

	Ingo

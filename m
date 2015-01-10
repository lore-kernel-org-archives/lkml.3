Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbbAJLY0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 06:24:26 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40009 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbbAJLYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 06:24:24 -0500
Date: Sat, 10 Jan 2015 12:24:19 +0100
From: Dongsu Park <dongsu.park@profitbricks.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kan Liang <kan.liang@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>,
        Mark Davies <junk@eslaf.co.uk>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 3.12 11/78] perf/x86/intel: Protect LBR and extra_regs
 against KVM lying
Message-ID: <20150110112419.GA4000@posteo.de>
References: <cover.1420799385.git.jslaby@suse.cz>
 <304ed40ae03a8e72934efc935247780d1b0ada66.1420799385.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <304ed40ae03a8e72934efc935247780d1b0ada66.1420799385.git.jslaby@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiry,

On 09.01.2015 11:31, Jiri Slaby wrote:
> From: Kan Liang <kan.liang@intel.com>
> 
> 3.12-stable review patch.  If anyone has any objections, please let me know.

Thanks for taking this patch to 3.12-stable.
I've just tested 3.12.36 from your stable-3.12-queue tree.
Unfortunately, the kernel still crashes at intel_pmu_init().

It turns out that this commit alone is not enough for fixing the bug.
Actually you also need commit c9b08884c9c98929ec2d8abafd78e89062d01ee7
("perf/x86: Correctly use FEATURE_PDCM").
Can you please pick that commit too?

Thanks,
Dongsu

p.s. In contrast, that commit didn't have to be backported to kernel
3.14.27, as it was already included in 3.14 tree. So situation was
slightly different between 3.12 and 3.14. This also explains why I
haven't been able to get it working in 3.10 so far.
I'll send a separate mail to stable@.

> ===============
> 
> commit 338b522ca43cfd32d11a370f4203bcd089c6c877 upstream.
> 
> With -cpu host, KVM reports LBR and extra_regs support, if the host has
> support.
> 
> When the guest perf driver tries to access LBR or extra_regs MSR,
> it #GPs all MSR accesses,since KVM doesn't handle LBR and extra_regs support.
> So check the related MSRs access right once at initialization time to avoid
> the error access at runtime.
> 
> For reproducing the issue, please build the kernel with CONFIG_KVM_INTEL = y
> (for host kernel).
> And CONFIG_PARAVIRT = n and CONFIG_KVM_GUEST = n (for guest kernel).
> Start the guest with -cpu host.
> Run perf record with --branch-any or --branch-filter in guest to trigger LBR
> Run perf stat offcore events (E.g. LLC-loads/LLC-load-misses ...) in guest to
> trigger offcore_rsp #GP
> 
> Signed-off-by: Kan Liang <kan.liang@intel.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
> Cc: Mark Davies <junk@eslaf.co.uk>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Yan, Zheng <zheng.z.yan@intel.com>
> Link: http://lkml.kernel.org/r/1405365957-20202-1-git-send-email-kan.liang@intel.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---
>  arch/x86/kernel/cpu/perf_event.c       |  3 ++
>  arch/x86/kernel/cpu/perf_event.h       | 12 ++++---
>  arch/x86/kernel/cpu/perf_event_intel.c | 66 +++++++++++++++++++++++++++++++++-
>  3 files changed, 75 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 5edd3c0b437a..c7106f116fb0 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -118,6 +118,9 @@ static int x86_pmu_extra_regs(u64 config, struct perf_event *event)
>  			continue;
>  		if (event->attr.config1 & ~er->valid_mask)
>  			return -EINVAL;
> +		/* Check if the extra msrs can be safely accessed*/
> +		if (!er->extra_msr_access)
> +			return -ENXIO;
>  
>  		reg->idx = er->idx;
>  		reg->config = event->attr.config1;
> diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
> index cc16faae0538..53bd2726f4cd 100644
> --- a/arch/x86/kernel/cpu/perf_event.h
> +++ b/arch/x86/kernel/cpu/perf_event.h
> @@ -279,14 +279,16 @@ struct extra_reg {
>  	u64			config_mask;
>  	u64			valid_mask;
>  	int			idx;  /* per_xxx->regs[] reg index */
> +	bool			extra_msr_access;
>  };
>  
>  #define EVENT_EXTRA_REG(e, ms, m, vm, i) {	\
> -	.event = (e),		\
> -	.msr = (ms),		\
> -	.config_mask = (m),	\
> -	.valid_mask = (vm),	\
> -	.idx = EXTRA_REG_##i,	\
> +	.event = (e),			\
> +	.msr = (ms),			\
> +	.config_mask = (m),		\
> +	.valid_mask = (vm),		\
> +	.idx = EXTRA_REG_##i,		\
> +	.extra_msr_access = true,	\
>  	}
>  
>  #define INTEL_EVENT_EXTRA_REG(event, msr, vm, idx)	\
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 959bbf204dae..02554ddf8481 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -2144,6 +2144,41 @@ static void intel_snb_check_microcode(void)
>  	}
>  }
>  
> +/*
> + * Under certain circumstances, access certain MSR may cause #GP.
> + * The function tests if the input MSR can be safely accessed.
> + */
> +static bool check_msr(unsigned long msr, u64 mask)
> +{
> +	u64 val_old, val_new, val_tmp;
> +
> +	/*
> +	 * Read the current value, change it and read it back to see if it
> +	 * matches, this is needed to detect certain hardware emulators
> +	 * (qemu/kvm) that don't trap on the MSR access and always return 0s.
> +	 */
> +	if (rdmsrl_safe(msr, &val_old))
> +		return false;
> +
> +	/*
> +	 * Only change the bits which can be updated by wrmsrl.
> +	 */
> +	val_tmp = val_old ^ mask;
> +	if (wrmsrl_safe(msr, val_tmp) ||
> +	    rdmsrl_safe(msr, &val_new))
> +		return false;
> +
> +	if (val_new != val_tmp)
> +		return false;
> +
> +	/* Here it's sure that the MSR can be safely accessed.
> +	 * Restore the old value and return.
> +	 */
> +	wrmsrl(msr, val_old);
> +
> +	return true;
> +}
> +
>  static __init void intel_sandybridge_quirk(void)
>  {
>  	x86_pmu.check_microcode = intel_snb_check_microcode;
> @@ -2207,7 +2242,8 @@ __init int intel_pmu_init(void)
>  	union cpuid10_ebx ebx;
>  	struct event_constraint *c;
>  	unsigned int unused;
> -	int version;
> +	struct extra_reg *er;
> +	int version, i;
>  
>  	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
>  		switch (boot_cpu_data.x86) {
> @@ -2515,6 +2551,34 @@ __init int intel_pmu_init(void)
>  		}
>  	}
>  
> +	/*
> +	 * Access LBR MSR may cause #GP under certain circumstances.
> +	 * E.g. KVM doesn't support LBR MSR
> +	 * Check all LBT MSR here.
> +	 * Disable LBR access if any LBR MSRs can not be accessed.
> +	 */
> +	if (x86_pmu.lbr_nr && !check_msr(x86_pmu.lbr_tos, 0x3UL))
> +		x86_pmu.lbr_nr = 0;
> +	for (i = 0; i < x86_pmu.lbr_nr; i++) {
> +		if (!(check_msr(x86_pmu.lbr_from + i, 0xffffUL) &&
> +		      check_msr(x86_pmu.lbr_to + i, 0xffffUL)))
> +			x86_pmu.lbr_nr = 0;
> +	}
> +
> +	/*
> +	 * Access extra MSR may cause #GP under certain circumstances.
> +	 * E.g. KVM doesn't support offcore event
> +	 * Check all extra_regs here.
> +	 */
> +	if (x86_pmu.extra_regs) {
> +		for (er = x86_pmu.extra_regs; er->msr; er++) {
> +			er->extra_msr_access = check_msr(er->msr, 0x1ffUL);
> +			/* Disable LBR select mapping */
> +			if ((er->idx == EXTRA_REG_LBR) && !er->extra_msr_access)
> +				x86_pmu.lbr_sel_map = NULL;
> +		}
> +	}
> +
>  	/* Support full width counters using alternative MSR range */
>  	if (x86_pmu.intel_cap.full_width_write) {
>  		x86_pmu.max_period = x86_pmu.cntval_mask;
> -- 
> 2.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

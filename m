Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab3A0PY6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 10:24:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab3A0PY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 10:24:56 -0500
Date: Sun, 27 Jan 2013 17:24:38 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 02/18] perf, kvm: Support the intx/intx_cp modifiers in
 KVM arch perfmon emulation v5
Message-ID: <20130127152438.GA27509@redhat.com>
References: <1359153192-13409-1-git-send-email-andi@firstfloor.org>
 <1359153192-13409-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359153192-13409-3-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 02:32:56PM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> This is not arch perfmon, but older CPUs will just ignore it. This makes
> it possible to do at least some TSX measurements from a KVM guest
> 
> Cc: gleb@redhat.com
> v2: Various fixes to address review feedback
> v3: Ignore the bits when no CPUID. No #GP. Force raw events with TSX bits.
> v4: Use reserved bits for #GP
> v5: Remove obsolete argument
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Gleb Natapov <gleb@redhat.com>

I suppose it will go through tip tree with all the other patches this one
depends on.

> ---
>  arch/x86/include/asm/kvm_host.h |    1 +
>  arch/x86/kvm/pmu.c              |   25 ++++++++++++++++++++-----
>  2 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index dc87b65..703a1f8 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -320,6 +320,7 @@ struct kvm_pmu {
>  	u64 global_ovf_ctrl;
>  	u64 counter_bitmask[2];
>  	u64 global_ctrl_mask;
> +	u64 reserved_bits;
>  	u8 version;
>  	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
>  	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index cfc258a..9317c43 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -160,7 +160,7 @@ static void stop_counter(struct kvm_pmc *pmc)
>  
>  static void reprogram_counter(struct kvm_pmc *pmc, u32 type,
>  		unsigned config, bool exclude_user, bool exclude_kernel,
> -		bool intr)
> +		bool intr, bool intx, bool intx_cp)
>  {
>  	struct perf_event *event;
>  	struct perf_event_attr attr = {
> @@ -173,6 +173,10 @@ static void reprogram_counter(struct kvm_pmc *pmc, u32 type,
>  		.exclude_kernel = exclude_kernel,
>  		.config = config,
>  	};
> +	if (intx)
> +		attr.config |= HSW_INTX;
> +	if (intx_cp)
> +		attr.config |= HSW_INTX_CHECKPOINTED;
>  
>  	attr.sample_period = (-pmc->counter) & pmc_bitmask(pmc);
>  
> @@ -226,7 +230,9 @@ static void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>  
>  	if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
>  				ARCH_PERFMON_EVENTSEL_INV |
> -				ARCH_PERFMON_EVENTSEL_CMASK))) {
> +				ARCH_PERFMON_EVENTSEL_CMASK |
> +				HSW_INTX |
> +				HSW_INTX_CHECKPOINTED))) {
>  		config = find_arch_event(&pmc->vcpu->arch.pmu, event_select,
>  				unit_mask);
>  		if (config != PERF_COUNT_HW_MAX)
> @@ -239,7 +245,9 @@ static void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>  	reprogram_counter(pmc, type, config,
>  			!(eventsel & ARCH_PERFMON_EVENTSEL_USR),
>  			!(eventsel & ARCH_PERFMON_EVENTSEL_OS),
> -			eventsel & ARCH_PERFMON_EVENTSEL_INT);
> +			eventsel & ARCH_PERFMON_EVENTSEL_INT,
> +			(eventsel & HSW_INTX),
> +			(eventsel & HSW_INTX_CHECKPOINTED));
>  }
>  
>  static void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 en_pmi, int idx)
> @@ -256,7 +264,7 @@ static void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 en_pmi, int idx)
>  			arch_events[fixed_pmc_events[idx]].event_type,
>  			!(en & 0x2), /* exclude user */
>  			!(en & 0x1), /* exclude kernel */
> -			pmi);
> +			pmi, false, false);
>  }
>  
>  static inline u8 fixed_en_pmi(u64 ctrl, int idx)
> @@ -400,7 +408,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
>  		} else if ((pmc = get_gp_pmc(pmu, index, MSR_P6_EVNTSEL0))) {
>  			if (data == pmc->eventsel)
>  				return 0;
> -			if (!(data & 0xffffffff00200000ull)) {
> +			if (!(data & pmu->reserved_bits)) {
>  				reprogram_gp_counter(pmc, data);
>  				return 0;
>  			}
> @@ -442,6 +450,7 @@ void kvm_pmu_cpuid_update(struct kvm_vcpu *vcpu)
>  	pmu->counter_bitmask[KVM_PMC_GP] = 0;
>  	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
>  	pmu->version = 0;
> +	pmu->reserved_bits = 0xffffffff00200000ull;
>  
>  	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
>  	if (!entry)
> @@ -470,6 +479,12 @@ void kvm_pmu_cpuid_update(struct kvm_vcpu *vcpu)
>  	pmu->global_ctrl = ((1 << pmu->nr_arch_gp_counters) - 1) |
>  		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED);
>  	pmu->global_ctrl_mask = ~pmu->global_ctrl;
> +
> +	entry = kvm_find_cpuid_entry(vcpu, 7, 0);
> +	if (entry &&
> +	    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) &&
> +	    (entry->ebx & (X86_FEATURE_HLE|X86_FEATURE_RTM)))
> +		pmu->reserved_bits ^= HSW_INTX|HSW_INTX_CHECKPOINTED;
>  }
>  
>  void kvm_pmu_init(struct kvm_vcpu *vcpu)
> -- 
> 1.7.7.6

--
			Gleb.

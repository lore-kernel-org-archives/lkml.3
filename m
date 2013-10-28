Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab3J1NBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:01:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303Ab3J1NBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:01:31 -0400
Date: Mon, 28 Oct 2013 15:00:56 +0200
From: Gleb Natapov <gleb@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        yoshihiro.yunomae.ez@hitachi.com
Subject: Re: RFC: paravirtualizing perf_clock
Message-ID: <20131028130056.GT15657@redhat.com>
References: <526DBD7F.1010807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526DBD7F.1010807@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 07:27:27PM -0600, David Ahern wrote:
> Often when debugging performance problems in a virtualized
> environment you need to correlate what is happening in the guest
> with what is happening in the host. To correlate events you need a
> common time basis (or the ability to directly correlate the two).
> 
> The attached patch paravirtualizes perf_clock, pulling the
> timestamps in VMs from the host using an MSR read if the option is
> available (exposed via KVM feature flag). I realize this is not the
> correct end code but it illustrates what I would like to see -- host
> and guests using the same perf_clock so timestamps directly
> correlate.
> 
> Any suggestions on how to do this and without impacting performance.
> I noticed the MSR path seems to take about twice as long as the
> current implementation (which I believe results in rdtsc in the VM
> for x86 with stable TSC).
> 
Yoshihiro YUNOMAE (copied) has a tool that merges guest's and host's
traces using tsc timestamp. His commit 489223edf29b adds a trace point
that reports current guest's tsc offset to support that.

> David
> 

> 
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 94dc8ca434e0..5a023ddf085e 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -24,6 +24,7 @@
>  #define KVM_FEATURE_STEAL_TIME		5
>  #define KVM_FEATURE_PV_EOI		6
>  #define KVM_FEATURE_PV_UNHALT		7
> +#define KVM_FEATURE_PV_PERF_CLOCK	8
>  
>  /* The last 8 bits are used to indicate how to interpret the flags field
>   * in pvclock structure. If no bits are set, all flags are ignored.
> @@ -40,6 +41,7 @@
>  #define MSR_KVM_ASYNC_PF_EN 0x4b564d02
>  #define MSR_KVM_STEAL_TIME  0x4b564d03
>  #define MSR_KVM_PV_EOI_EN      0x4b564d04
> +#define MSR_KVM_PV_PERF_CLOCK      0x4b564d05
>  
>  struct kvm_steal_time {
>  	__u64 steal;
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 9d8449158cf9..fb7824a64823 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -25,6 +25,7 @@
>  #include <linux/cpu.h>
>  #include <linux/bitops.h>
>  #include <linux/device.h>
> +#include <linux/kvm_para.h>
>  
>  #include <asm/apic.h>
>  #include <asm/stacktrace.h>
> @@ -34,6 +35,7 @@
>  #include <asm/timer.h>
>  #include <asm/desc.h>
>  #include <asm/ldt.h>
> +#include <asm/kvm_para.h>
>  
>  #include "perf_event.h"
>  
> @@ -52,6 +54,38 @@ u64 __read_mostly hw_cache_extra_regs
>  				[PERF_COUNT_HW_CACHE_OP_MAX]
>  				[PERF_COUNT_HW_CACHE_RESULT_MAX];
>  
> +
> +#ifdef CONFIG_PARAVIRT
> +
> +static int have_pv_perf_clock;
> +
> +static void __init perf_clock_init(void)
> +{
> +	if (kvm_para_available() &&
> +		kvm_para_has_feature(KVM_FEATURE_PV_PERF_CLOCK)) {
> +		have_pv_perf_clock = 1;
> +	}
> +}
> +
> +u64 perf_clock(void)
> +{
> +	if (have_pv_perf_clock)
> +		return native_read_msr(MSR_KVM_PV_PERF_CLOCK);
> +
> +	/* otherwise return local_clock */
> +	return local_clock();
> +}
> +
> +#else
> +u64 perf_clock(void)
> +{
> +	return local_clock();
> +}
> +
> +static inline void __init perf_clock_init(void)
> +{
> +}
> +#endif
>  /*
>   * Propagate event elapsed time into the generic event.
>   * Can only be executed on the CPU where the event is active.
> @@ -1496,6 +1530,8 @@ static int __init init_hw_perf_events(void)
>  	struct x86_pmu_quirk *quirk;
>  	int err;
>  
> +	perf_clock_init();
> +
>  	pr_info("Performance Events: ");
>  
>  	switch (boot_cpu_data.x86_vendor) {
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b110fe6c03d4..5b258a18f9c0 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -414,7 +414,8 @@ static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  			     (1 << KVM_FEATURE_ASYNC_PF) |
>  			     (1 << KVM_FEATURE_PV_EOI) |
>  			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
> -			     (1 << KVM_FEATURE_PV_UNHALT);
> +			     (1 << KVM_FEATURE_PV_UNHALT) |
> +			     (1 << KVM_FEATURE_PV_PERF_CLOCK);
>  
>  		if (sched_info_on())
>  			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e5ca72a5cdb6..61ec1f1c7d38 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2418,6 +2418,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
>  	case MSR_KVM_PV_EOI_EN:
>  		data = vcpu->arch.pv_eoi.msr_val;
>  		break;
> +	case MSR_KVM_PV_PERF_CLOCK:
> +		data = perf_clock();
> +		break;
>  	case MSR_IA32_P5_MC_ADDR:
>  	case MSR_IA32_P5_MC_TYPE:
>  	case MSR_IA32_MCG_CAP:
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index c8ba627c1d60..c8a51954ea9e 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -865,4 +865,7 @@ _name##_show(struct device *dev,					\
>  									\
>  static struct device_attribute format_attr_##_name = __ATTR_RO(_name)
>  
> +#if defined(CONFIG_X86_64)
> +u64 perf_clock(void);
> +#endif
>  #endif /* _LINUX_PERF_EVENT_H */
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index d49a9d29334c..b073975af05a 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -290,10 +290,18 @@ extern __weak const char *perf_pmu_name(void)
>  	return "pmu";
>  }
>  
> +#if defined(CONFIG_X86_64)
> +__weak u64 perf_clock(void)
> +{
> +	return local_clock();
> +}
> +EXPORT_SYMBOL(perf_clock);
> +#else
>  static inline u64 perf_clock(void)
>  {
>  	return local_clock();
>  }
> +#endif
>  
>  static inline struct perf_cpu_context *
>  __get_cpu_context(struct perf_event_context *ctx)
> -- 
> 1.7.12.4 (Apple Git-37)
> 


--
			Gleb.

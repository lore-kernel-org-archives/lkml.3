Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbaE3IVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 04:21:51 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56688 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbaE3IVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 04:21:44 -0400
Date: Fri, 30 May 2014 11:21:37 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: peterz@infradead.org, pbonzini@redhat.com, eranian@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/4] kvm: Implement PEBS virtualization
Message-ID: <20140530082136.GA4715@minantech.com>
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
 <1401412327-14810-5-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=cp1255
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1401412327-14810-5-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 06:12:07PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> PEBS (Precise Event Bases Sampling) profiling is very powerful,
> allowing improved sampling precision and much additional information,
> like address or TSX abort profiling. cycles:p and :pp uses PEBS.
> 
> This patch enables PEBS profiling in KVM guests.
That sounds really cool!

> 
> PEBS writes profiling records to a virtual address in memory. Since
> the guest controls the virtual address space the PEBS record
> is directly delivered to the guest buffer. We set up the PEBS state
> that is works correctly.The CPU cannot handle any kinds of faults during
> these guest writes.
> 
> To avoid any problems with guest pages being swapped by the host we
> pin the pages when the PEBS buffer is setup, by intercepting
> that MSR.
It will avoid guest page to be swapped, but shadow paging code may still drop
shadow PT pages that build a mapping from DS virtual address to the guest page.
With EPT it is less likely to happen (but still possible IIRC depending on memory
pressure and how much memory shadow paging code is allowed to use), without EPT
it will happen for sure.

> 
> Typically profilers only set up a single page, so pinning that is not
> a big problem. The pinning is limited to 17 pages currently (64K+1)
> 
> In theory the guest can change its own page tables after the PEBS
> setup. The host has no way to track that with EPT. But if a guest
> would do that it could only crash itself. It's not expected
> that normal profilers do that.
Spec says:

 The following restrictions should be applied to the DS save area.
   • The three DS save area sections should be allocated from a
   non-paged pool, and marked accessed and dirty. It is the responsibility
   of the operating system to keep the pages that contain the buffer
   present and to mark them accessed and dirty. The implication is that
   the operating system cannot do “lazy” page-table entry propagation
   for these pages.

There is nothing, as far as I can see, that says what will happen if the
condition is not met. I always interpreted it as undefined behaviour so
anything can happen including CPU dies completely.  You are saying above
on one hand that CPU cannot handle any kinds of faults during write to
DS area, but on the other hand a guest could only crash itself. Is this
architecturally guarantied?


> 
> The patch also adds the basic glue to enable the PEBS CPUIDs
> and other PEBS MSRs, and ask perf to enable PEBS as needed.
> 
> Due to various limitations it currently only works on Silvermont
> based systems.
> 
> This patch doesn't implement the extended MSRs some CPUs support.
> For example latency profiling on SLM will not work at this point.
> 
> Timing:
> 
> The emulation is somewhat more expensive than a real PMU. This
> may trigger the expensive PMI detection in the guest.
> Usually this can be disabled with
> echo 0 > /proc/sys/kernel/perf_cpu_time_max_percent
> 
> Migration:
> 
> In theory it should should be possible (as long as we migrate to
> a host with the same PEBS event and the same PEBS format), but I'm not
> sure the basic KVM PMU code supports it correctly: no code to
> save/restore state, unless I'm missing something. Once the PMU
> code grows proper migration support it should be straight forward
> to handle the PEBS state too.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h       |   6 ++
>  arch/x86/include/uapi/asm/msr-index.h |   4 +
>  arch/x86/kvm/cpuid.c                  |  10 +-
>  arch/x86/kvm/pmu.c                    | 184 ++++++++++++++++++++++++++++++++--
>  arch/x86/kvm/vmx.c                    |   6 ++
>  5 files changed, 196 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7de069af..d87cb66 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -319,6 +319,8 @@ struct kvm_pmc {
>  	struct kvm_vcpu *vcpu;
>  };
>  
> +#define MAX_PINNED_PAGES 17 /* 64k buffer + ds */
> +
>  struct kvm_pmu {
>  	unsigned nr_arch_gp_counters;
>  	unsigned nr_arch_fixed_counters;
> @@ -335,6 +337,10 @@ struct kvm_pmu {
>  	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
>  	struct irq_work irq_work;
>  	u64 reprogram_pmi;
> +	u64 pebs_enable;
> +	u64 ds_area;
> +	struct page *pinned_pages[MAX_PINNED_PAGES];
> +	unsigned num_pinned_pages;
>  };
>  
>  enum {
> diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
> index fcf2b3a..409a582 100644
> --- a/arch/x86/include/uapi/asm/msr-index.h
> +++ b/arch/x86/include/uapi/asm/msr-index.h
> @@ -72,6 +72,10 @@
>  #define MSR_IA32_PEBS_ENABLE		0x000003f1
>  #define MSR_IA32_DS_AREA		0x00000600
>  #define MSR_IA32_PERF_CAPABILITIES	0x00000345
> +#define PERF_CAP_PEBS_TRAP		(1U << 6)
> +#define PERF_CAP_ARCH_REG		(1U << 7)
> +#define PERF_CAP_PEBS_FORMAT		(0xf << 8)
> +
>  #define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
>  
>  #define MSR_MTRRfix64K_00000		0x00000250
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index f47a104..c8cc76b 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -260,6 +260,10 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  	unsigned f_rdtscp = kvm_x86_ops->rdtscp_supported() ? F(RDTSCP) : 0;
>  	unsigned f_invpcid = kvm_x86_ops->invpcid_supported() ? F(INVPCID) : 0;
>  	unsigned f_mpx = kvm_x86_ops->mpx_supported() ? F(MPX) : 0;
> +	bool pebs = perf_pebs_virtualization();
> +	unsigned f_ds = pebs ? F(DS) : 0;
> +	unsigned f_pdcm = pebs ? F(PDCM) : 0;
> +	unsigned f_dtes64 = pebs ? F(DTES64) : 0;
>  
>  	/* cpuid 1.edx */
>  	const u32 kvm_supported_word0_x86_features =
> @@ -268,7 +272,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SEP) |
>  		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
>  		F(PAT) | F(PSE36) | 0 /* PSN */ | F(CLFLUSH) |
> -		0 /* Reserved, DS, ACPI */ | F(MMX) |
> +		f_ds /* Reserved, ACPI */ | F(MMX) |
>  		F(FXSR) | F(XMM) | F(XMM2) | F(SELFSNOOP) |
>  		0 /* HTT, TM, Reserved, PBE */;
>  	/* cpuid 0x80000001.edx */
> @@ -283,10 +287,10 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  		0 /* Reserved */ | f_lm | F(3DNOWEXT) | F(3DNOW);
>  	/* cpuid 1.ecx */
>  	const u32 kvm_supported_word4_x86_features =
> -		F(XMM3) | F(PCLMULQDQ) | 0 /* DTES64, MONITOR */ |
> +		F(XMM3) | F(PCLMULQDQ) | f_dtes64 /* MONITOR */ |
>  		0 /* DS-CPL, VMX, SMX, EST */ |
>  		0 /* TM2 */ | F(SSSE3) | 0 /* CNXT-ID */ | 0 /* Reserved */ |
> -		F(FMA) | F(CX16) | 0 /* xTPR Update, PDCM */ |
> +		F(FMA) | F(CX16) | f_pdcm /* xTPR Update */ |
>  		F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
>  		F(XMM4_2) | F(X2APIC) | F(MOVBE) | F(POPCNT) |
>  		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 4c6f417..6362db7 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -15,9 +15,11 @@
>  #include <linux/types.h>
>  #include <linux/kvm_host.h>
>  #include <linux/perf_event.h>
> +#include <linux/highmem.h>
>  #include "x86.h"
>  #include "cpuid.h"
>  #include "lapic.h"
> +#include "mmu.h"
>  
>  static struct kvm_arch_event_perf_mapping {
>  	u8 eventsel;
> @@ -36,9 +38,23 @@ static struct kvm_arch_event_perf_mapping {
>  	[7] = { 0x00, 0x30, PERF_COUNT_HW_REF_CPU_CYCLES },
>  };
>  
> +struct debug_store {
> +	u64	bts_buffer_base;
> +	u64	bts_index;
> +	u64	bts_absolute_maximum;
> +	u64	bts_interrupt_threshold;
> +	u64	pebs_buffer_base;
> +	u64	pebs_index;
> +	u64	pebs_absolute_maximum;
> +	u64	pebs_interrupt_threshold;
> +	u64	pebs_event_reset[4];
> +};
> +
>  /* mapping between fixed pmc index and arch_events array */
>  int fixed_pmc_events[] = {1, 0, 7};
>  
> +static u64 host_perf_cap __read_mostly;
> +
>  static bool pmc_is_gp(struct kvm_pmc *pmc)
>  {
>  	return pmc->type == KVM_PMC_GP;
> @@ -108,7 +124,10 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
>  {
>  	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
>  	struct kvm_pmu *pmu = &pmc->vcpu->arch.pmu;
> -	__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
> +	if (perf_event->attr.precise_ip)
> +		__set_bit(62, (unsigned long *)&pmu->global_status);
> +	else
> +		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
>  }
>  
>  static void kvm_perf_overflow_intr(struct perf_event *perf_event,
> @@ -160,7 +179,7 @@ static void stop_counter(struct kvm_pmc *pmc)
>  
>  static void reprogram_counter(struct kvm_pmc *pmc, u32 type,
>  		unsigned config, bool exclude_user, bool exclude_kernel,
> -		bool intr, bool in_tx, bool in_tx_cp)
> +		bool intr, bool in_tx, bool in_tx_cp, bool pebs)
>  {
>  	struct perf_event *event;
>  	struct perf_event_attr attr = {
> @@ -177,18 +196,20 @@ static void reprogram_counter(struct kvm_pmc *pmc, u32 type,
>  		attr.config |= HSW_IN_TX;
>  	if (in_tx_cp)
>  		attr.config |= HSW_IN_TX_CHECKPOINTED;
> +	if (pebs)
> +		attr.precise_ip = 1;
>  
>  	attr.sample_period = (-pmc->counter) & pmc_bitmask(pmc);
>  
> -	event = perf_event_create_kernel_counter(&attr, -1, current,
> -						 intr ? kvm_perf_overflow_intr :
> -						 kvm_perf_overflow, pmc);
> +	event = __perf_event_create_kernel_counter(&attr, -1, current,
> +						 (intr || pebs) ?
> +						 kvm_perf_overflow_intr :
> +						 kvm_perf_overflow, pmc, true);
>  	if (IS_ERR(event)) {
>  		printk_once("kvm: pmu event creation failed %ld\n",
>  				PTR_ERR(event));
>  		return;
>  	}
> -	event->guest_owned = true;
>  
>  	pmc->perf_event = event;
>  	clear_bit(pmc->idx, (unsigned long*)&pmc->vcpu->arch.pmu.reprogram_pmi);
> @@ -211,7 +232,8 @@ static unsigned find_arch_event(struct kvm_pmu *pmu, u8 event_select,
>  	return arch_events[i].event_type;
>  }
>  
> -static void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
> +static void reprogram_gp_counter(struct kvm_pmu *pmu, struct kvm_pmc *pmc,
> +				 u64 eventsel)
>  {
>  	unsigned config, type = PERF_TYPE_RAW;
>  	u8 event_select, unit_mask;
> @@ -248,7 +270,8 @@ static void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>  			!(eventsel & ARCH_PERFMON_EVENTSEL_OS),
>  			eventsel & ARCH_PERFMON_EVENTSEL_INT,
>  			(eventsel & HSW_IN_TX),
> -			(eventsel & HSW_IN_TX_CHECKPOINTED));
> +			(eventsel & HSW_IN_TX_CHECKPOINTED),
> +			test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable));
>  }
>  
>  static void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 en_pmi, int idx)
> @@ -265,7 +288,7 @@ static void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 en_pmi, int idx)
>  			arch_events[fixed_pmc_events[idx]].event_type,
>  			!(en & 0x2), /* exclude user */
>  			!(en & 0x1), /* exclude kernel */
> -			pmi, false, false);
> +			pmi, false, false, false);
>  }
>  
>  static inline u8 fixed_en_pmi(u64 ctrl, int idx)
> @@ -298,7 +321,7 @@ static void reprogram_idx(struct kvm_pmu *pmu, int idx)
>  		return;
>  
>  	if (pmc_is_gp(pmc))
> -		reprogram_gp_counter(pmc, pmc->eventsel);
> +		reprogram_gp_counter(pmu, pmc, pmc->eventsel);
>  	else {
>  		int fidx = idx - INTEL_PMC_IDX_FIXED;
>  		reprogram_fixed_counter(pmc,
> @@ -323,6 +346,12 @@ bool kvm_pmu_msr(struct kvm_vcpu *vcpu, u32 msr)
>  	int ret;
>  
>  	switch (msr) {
> +	case MSR_IA32_DS_AREA:
> +	case MSR_IA32_PEBS_ENABLE:
> +	case MSR_IA32_PERF_CAPABILITIES:
> +		ret = perf_pebs_virtualization() ? 1 : 0;
> +		break;
> +
>  	case MSR_CORE_PERF_FIXED_CTR_CTRL:
>  	case MSR_CORE_PERF_GLOBAL_STATUS:
>  	case MSR_CORE_PERF_GLOBAL_CTRL:
> @@ -356,6 +385,18 @@ int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data)
>  	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
>  		*data = pmu->global_ovf_ctrl;
>  		return 0;
> +	case MSR_IA32_DS_AREA:
> +		*data = pmu->ds_area;
> +		return 0;
> +	case MSR_IA32_PEBS_ENABLE:
> +		*data = pmu->pebs_enable;
> +		return 0;
> +	case MSR_IA32_PERF_CAPABILITIES:
> +		/* Report host PEBS format to guest */
> +		*data = host_perf_cap &
> +			(PERF_CAP_PEBS_TRAP | PERF_CAP_ARCH_REG |
> +			 PERF_CAP_PEBS_FORMAT);
> +		return 0;
>  	default:
>  		if ((pmc = get_gp_pmc(pmu, index, MSR_IA32_PERFCTR0)) ||
>  				(pmc = get_fixed_pmc(pmu, index))) {
> @@ -369,6 +410,109 @@ int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data)
>  	return 1;
>  }
>  
> +static void kvm_pmu_release_pin(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	int i;
> +
> +	for (i = 0; i < pmu->num_pinned_pages; i++)
> +		put_page(pmu->pinned_pages[i]);
> +	pmu->num_pinned_pages = 0;
> +}
> +
> +static struct page *get_guest_page(struct kvm_vcpu *vcpu,
> +				   unsigned long addr)
> +{
> +	unsigned long pfn;
> +	struct x86_exception exception;
> +	gpa_t gpa = vcpu->arch.walk_mmu->gva_to_gpa(vcpu, addr,
> +						    PFERR_WRITE_MASK,
> +						    &exception);
> +
> +	if (gpa == UNMAPPED_GVA) {
> +		printk_once("Cannot translate guest page %lx\n", addr);
> +		return NULL;
> +	}
> +	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
> +	if (is_error_noslot_pfn(pfn)) {
> +		printk_once("gfn_to_pfn failed for %llx\n", gpa);
> +		return NULL;
> +	}
> +	return pfn_to_page(pfn);
> +}
> +
> +static int pin_and_copy(struct kvm_vcpu *vcpu,
> +			unsigned long addr, void *dst, int len,
> +			struct page **p)
> +{
> +	unsigned long offset = addr & ~PAGE_MASK;
> +	void *map;
> +
> +	*p = get_guest_page(vcpu, addr);
> +	if (!*p)
> +		return -EIO;
> +	map = kmap(*p);
> +	memcpy(dst, map + offset, len);
> +	kunmap(map);
> +	return 0;
> +}
> +
> +/*
> + * Pin the DS area and the PEBS buffer while PEBS is active,
> + * because the CPU cannot tolerate EPT faults for PEBS updates.
> + *
> + * We assume that any guest who changes the DS buffer disables
> + * PEBS first and does not change the page tables during operation.
> + *
> + * When the guest violates these assumptions it may crash itself.
> + * This is expected to not happen with standard profilers.
> + *
> + * No need to clean up anything, as the caller will always eventually
> + * unpin pages.
> + */
> +
> +static void kvm_pmu_pebs_pin(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct debug_store ds;
> +	int pg;
> +	unsigned len;
> +	unsigned long offset;
> +	unsigned long addr;
> +
> +	offset = pmu->ds_area & ~PAGE_MASK;
> +	len = sizeof(struct debug_store);
> +	len = min_t(unsigned, PAGE_SIZE - offset, len);
> +	if (pin_and_copy(vcpu, pmu->ds_area, &ds, len,
> +			 &pmu->pinned_pages[0]) < 0) {
> +		printk_once("Cannot pin ds area %llx\n", pmu->ds_area);
> +		return;
> +	}
> +	pmu->num_pinned_pages++;
> +	if (len < sizeof(struct debug_store)) {
> +		if (pin_and_copy(vcpu, pmu->ds_area + len, (void *)&ds + len,
> +				  sizeof(struct debug_store) - len,
> +				  &pmu->pinned_pages[1]) < 0)
> +			return;
> +		pmu->num_pinned_pages++;
> +	}
> +
> +	pg = pmu->num_pinned_pages;
> +	for (addr = ds.pebs_buffer_base;
> +	     addr < ds.pebs_absolute_maximum && pg < MAX_PINNED_PAGES;
> +	     addr += PAGE_SIZE, pg++) {
> +		pmu->pinned_pages[pg] = get_guest_page(vcpu, addr);
> +		if (!pmu->pinned_pages[pg]) {
> +			printk_once("Cannot pin PEBS buffer %lx (%llx-%llx)\n",
> +				 addr,
> +				 ds.pebs_buffer_base,
> +				 ds.pebs_absolute_maximum);
> +			break;
> +		}
> +	}
> +	pmu->num_pinned_pages = pg;
> +}
> +
>  int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  {
>  	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> @@ -407,6 +551,20 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			return 0;
>  		}
>  		break;
> +	case MSR_IA32_DS_AREA:
> +		pmu->ds_area = data;
> +		return 0;
> +	case MSR_IA32_PEBS_ENABLE:
> +		if (data & ~0xf0000000fULL)
> +			break;
> +		if (data && data != pmu->pebs_enable) {
> +			kvm_pmu_release_pin(vcpu);
> +			kvm_pmu_pebs_pin(vcpu);
> +		} else if (data == 0 && pmu->pebs_enable) {
> +			kvm_pmu_release_pin(vcpu);
> +		}
> +		pmu->pebs_enable = data;
> +		return 0;
>  	default:
>  		if ((pmc = get_gp_pmc(pmu, index, MSR_IA32_PERFCTR0)) ||
>  				(pmc = get_fixed_pmc(pmu, index))) {
> @@ -418,7 +576,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			if (data == pmc->eventsel)
>  				return 0;
>  			if (!(data & pmu->reserved_bits)) {
> -				reprogram_gp_counter(pmc, data);
> +				reprogram_gp_counter(pmu, pmc, data);
>  				return 0;
>  			}
>  		}
> @@ -514,6 +672,9 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
>  	}
>  	init_irq_work(&pmu->irq_work, trigger_pmi);
>  	kvm_pmu_cpuid_update(vcpu);
> +
> +	if (boot_cpu_has(X86_FEATURE_PDCM))
> +		rdmsrl_safe(MSR_IA32_PERF_CAPABILITIES, &host_perf_cap);
>  }
>  
>  void kvm_pmu_reset(struct kvm_vcpu *vcpu)
> @@ -538,6 +699,7 @@ void kvm_pmu_reset(struct kvm_vcpu *vcpu)
>  void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
>  {
>  	kvm_pmu_reset(vcpu);
> +	kvm_pmu_release_pin(vcpu);
>  }
>  
>  void kvm_handle_pmu_event(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 33e8c02..4f39917 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -7288,6 +7288,12 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	atomic_switch_perf_msrs(vmx);
>  	debugctlmsr = get_debugctlmsr();
>  
> +	/* Move this somewhere else? */
> +	if (vcpu->arch.pmu.ds_area)
> +		add_atomic_switch_msr(vmx, MSR_IA32_DS_AREA,
> +				      vcpu->arch.pmu.ds_area,
> +				      perf_get_ds_area());
> +
>  	vmx->__launched = vmx->loaded_vmcs->launched;
>  	asm(
>  		/* Store host registers */
> -- 
> 1.9.0
> 

--
			Gleb.

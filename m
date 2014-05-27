Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaE0Nx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:53:57 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:38022 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaE0Nxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:53:55 -0400
Date: Tue, 27 May 2014 15:53:49 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Jungseok Lee <jays.lee@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: Re: [PATCH v6 6/7] arm64: KVM: Set physical address size related
 factors in runtime
Message-ID: <20140527135349.GJ31431@lvm>
References: <000501cf6dc6$44fac0f0$cef042d0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000501cf6dc6$44fac0f0$cef042d0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 06:40:54PM +0900, Jungseok Lee wrote:
> This patch sets TCR_EL2.PS, VTCR_EL2.T0SZ and vttbr_baddr_mask in runtime,
> not compile time.
> 
> In ARMv8, EL2 physical address size (TCR_EL2.PS) and stage2 input address
> size (VTCR_EL2.T0SZE) cannot be determined in compile time since they
> depends on hardware capability.

s/depends/depend/

> 
> According to Table D4-23 and Table D4-25 in ARM DDI 0487A.b document,
> vttbr_x is calculated using different hard-coded values with consideration

super nit: I guess this is fixed values, and not hard-coded values

> of T0SZ, granule size and the level of translation tables. Therefore,
> vttbr_baddr_mask should be determined dynamically.

so I think there's a deeper issue here, which is that we're not
currently considering that for a given supported physical address size
(run-time) and given page granularity (compile-time), we may have some
flexibility in choosing the VTCR_EL2.SL0 field, and thereby the size of
the initial stage2 pgd, by concatinating the initial level page tables.

Additionally, the combinations of the givens may also force us to choose
a specific SL0 value.

Policy-wise, I would say we should concatenate as many initial level page
tables as possible when using 4K pages, iow. always set VTCR_EL2.SL0 to
the lowest possible value given the PARange and page size config we have
at hand.  That should always provide increased performance for VMs at
the cost of maximum 16 concatenated tables, which is a 64K contiguous
allocation and alignment, for 4K pages.

For 64K pages, it becomes a 256K alignment and contiguous allocation
requirement.  One could argue that if this is not possible on your
system, then you have no business runninng VMs on there, but I want to
leave this open for comments...

> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
> Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
> ---
>  arch/arm/kvm/arm.c               |   82 +++++++++++++++++++++++++++++++++++++-
>  arch/arm64/include/asm/kvm_arm.h |   17 ++------
>  arch/arm64/kvm/hyp-init.S        |   20 +++++++---
>  3 files changed, 98 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index f0e50a0..9f19f2c 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -37,6 +37,7 @@
>  #include <asm/mman.h>
>  #include <asm/tlbflush.h>
>  #include <asm/cacheflush.h>
> +#include <asm/cputype.h>
>  #include <asm/virt.h>
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
> @@ -61,6 +62,9 @@ static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
>  static u8 kvm_next_vmid;
>  static DEFINE_SPINLOCK(kvm_vmid_lock);
>  
> +/* VTTBR mask cannot be determined in complie time under ARMv8 */
> +static u64 vttbr_baddr_mask;
> +
>  static bool vgic_present;
>  
>  static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
> @@ -412,6 +416,75 @@ static bool need_new_vmid_gen(struct kvm *kvm)
>  }
>  
>  /**
> + * set_vttbr_baddr_mask - set mask value for vttbr base address
> + *
> + * In ARMv8, vttbr_baddr_mask cannot be determined in compile time since stage2

the stage2 input address size

> + * input address size depends on hardware capability. Thus, it is needed to read

Thus, we first need to read... considering both the translation granule
and the level...

> + * ID_AA64MMFR0_EL1.PARange first and then set vttbr_baddr_mask with consideration
> + * of both granule size and the level of translation tables.
> + */
> +static int set_vttbr_baddr_mask(void)
> +{
> +#ifndef CONFIG_ARM64

We have completely avoided this kind of ifdef's so far.

The end calculation of the alignment requirements for the VTTBR.BADDR
field is the same for arm and arm64, so either providing a lookup table or
static inlines in kvm_arm.h for the two archs should work.

> +	vttbr_baddr_mask = VTTBR_BADDR_MASK;
> +#else
> +	int pa_range, t0sz, vttbr_x;
> +
> +	pa_range = read_cpuid(ID_AA64MMFR0_EL1) & 0xf;
> +
> +	switch (pa_range) {
> +	case 0:
> +		t0sz = VTCR_EL2_T0SZ(32);
> +		break;
> +	case 1:
> +		t0sz = VTCR_EL2_T0SZ(36);
> +		break;
> +	case 2:
> +		t0sz = VTCR_EL2_T0SZ(40);
> +		break;
> +	case 3:
> +		t0sz = VTCR_EL2_T0SZ(42);
> +		break;
> +	case 4:
> +		t0sz = VTCR_EL2_T0SZ(44);
> +		break;
> +	default:
> +		t0sz = VTCR_EL2_T0SZ(48);

why default? this would be 'case 5', and then

default:
	kvm_err("Unknown PARange: %d, hardware is weird\n", pa_range);
	return -EFAULT;

> +	}
> +
> +	/*
> +	 * See Table D4-23 and Table D4-25 in ARM DDI 0487A.b to figure out
> +	 * the origin of the hardcoded values, 38 and 37.
> +	 */
> +#ifdef CONFIG_ARM64_64K_PAGES
> +	/*
> +	 * 16 <= T0SZ <= 21 is valid under 3 level of translation tables
> +	 * 18 <= T0SZ <= 34 is valid under 2 level of translation tables
> +	 * 31 <= T0SZ <= 39 is valid under 1 level of transltaion tables
> +	 */
> +	if (t0sz <= 17) {
> +		kvm_err("Cannot support %d-bit address space\n", 64 - t0sz);
> +		return -EINVAL;
> +	}

I don't think this is what we want.  You want to adjust your initial
lookup level (VTCR_EL2.SL0) accordingly.

> +	vttbr_x = 38 - t0sz;
> +#else
> +	/*
> +	 * 16 <= T0SZ <= 24 is valid under 4 level of translation tables
> +	 * 21 <= T0SZ <= 30 is valid under 3 level of translation tables
> +	 * 30 <= T0SZ <= 39 is valid under 2 level of translation tables
> +	 */
> +	if (t0sz <= 20) {
> +		kvm_err("Cannot support %d-bit address space\n", 64 - t0sz);
> +		return -EINVAL;
> +	}

same as above

> +	vttbr_x = 37 - t0sz;
> +#endif
> +	vttbr_baddr_mask = (((1LLU << (48 - vttbr_x)) - 1) << (vttbr_x - 1));
> +#endif
> +	return 0;
> +}
> +
> +/**
>   * update_vttbr - Update the VTTBR with a valid VMID before the guest runs
>   * @kvm	The guest that we are about to run
>   *
> @@ -465,7 +538,7 @@ static void update_vttbr(struct kvm *kvm)
>  	/* update vttbr to be used with the new vmid */
>  	pgd_phys = virt_to_phys(kvm->arch.pgd);
>  	vmid = ((u64)(kvm->arch.vmid) << VTTBR_VMID_SHIFT) & VTTBR_VMID_MASK;
> -	kvm->arch.vttbr = pgd_phys & VTTBR_BADDR_MASK;
> +	kvm->arch.vttbr = pgd_phys & vttbr_baddr_mask;

We should really check that we're not actually masking off any set bits
in pgd_phys here, because then I think we're overwriting kernel memory,
which would be bad.

See my other comments above, I think we need a more flexible scheme for
allocating the pdg, and if not (if we stick to never using concatenated
initial level stage-2 page tables), then this should be a check and a
BUG_ON() instead of just a mask.  Right?

>  	kvm->arch.vttbr |= vmid;
>  
>  	spin_unlock(&kvm_vmid_lock);
> @@ -1051,6 +1124,12 @@ int kvm_arch_init(void *opaque)
>  		}
>  	}
>  
> +	err = set_vttbr_baddr_mask();
> +	if (err) {
> +		kvm_err("Cannot set vttbr_baddr_mask\n");
> +		return -EINVAL;
> +	}
> +
>  	cpu_notifier_register_begin();
>  
>  	err = init_hyp_mode();
> @@ -1068,6 +1147,7 @@ int kvm_arch_init(void *opaque)
>  	hyp_cpu_pm_init();
>  
>  	kvm_coproc_table_init();
> +
>  	return 0;
>  out_err:
>  	cpu_notifier_register_done();
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 3d69030..8dbef70 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -94,7 +94,6 @@
>  /* TCR_EL2 Registers bits */
>  #define TCR_EL2_TBI	(1 << 20)
>  #define TCR_EL2_PS	(7 << 16)
> -#define TCR_EL2_PS_40B	(2 << 16)
>  #define TCR_EL2_TG0	(1 << 14)
>  #define TCR_EL2_SH0	(3 << 12)
>  #define TCR_EL2_ORGN0	(3 << 10)
> @@ -103,8 +102,6 @@
>  #define TCR_EL2_MASK	(TCR_EL2_TG0 | TCR_EL2_SH0 | \
>  			 TCR_EL2_ORGN0 | TCR_EL2_IRGN0 | TCR_EL2_T0SZ)
>  
> -#define TCR_EL2_FLAGS	(TCR_EL2_PS_40B)
> -
>  /* VTCR_EL2 Registers bits */
>  #define VTCR_EL2_PS_MASK	(7 << 16)
>  #define VTCR_EL2_TG0_MASK	(1 << 14)
> @@ -119,36 +116,28 @@
>  #define VTCR_EL2_SL0_MASK	(3 << 6)
>  #define VTCR_EL2_SL0_LVL1	(1 << 6)
>  #define VTCR_EL2_T0SZ_MASK	0x3f
> -#define VTCR_EL2_T0SZ_40B	24
> +#define VTCR_EL2_T0SZ(bits)	(64 - (bits))
>  
>  #ifdef CONFIG_ARM64_64K_PAGES
>  /*
>   * Stage2 translation configuration:
> - * 40bits output (PS = 2)
> - * 40bits input  (T0SZ = 24)
>   * 64kB pages (TG0 = 1)
>   * 2 level page tables (SL = 1)
>   */
>  #define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_64K | VTCR_EL2_SH0_INNER | \
>  				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
> -				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B)
> -#define VTTBR_X		(38 - VTCR_EL2_T0SZ_40B)
> +				 VTCR_EL2_SL0_LVL1)
>  #else
>  /*
>   * Stage2 translation configuration:
> - * 40bits output (PS = 2)
> - * 40bits input  (T0SZ = 24)
>   * 4kB pages (TG0 = 0)
>   * 3 level page tables (SL = 1)
>   */
>  #define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SH0_INNER | \
>  				 VTCR_EL2_ORGN0_WBWA | VTCR_EL2_IRGN0_WBWA | \
> -				 VTCR_EL2_SL0_LVL1 | VTCR_EL2_T0SZ_40B)
> -#define VTTBR_X		(37 - VTCR_EL2_T0SZ_40B)
> +				 VTCR_EL2_SL0_LVL1)
>  #endif
>  
> -#define VTTBR_BADDR_SHIFT (VTTBR_X - 1)
> -#define VTTBR_BADDR_MASK  (((1LLU << (40 - VTTBR_X)) - 1) << VTTBR_BADDR_SHIFT)
>  #define VTTBR_VMID_SHIFT  (48LLU)
>  #define VTTBR_VMID_MASK	  (0xffLLU << VTTBR_VMID_SHIFT)
>  
> diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
> index d968796..c0f7634 100644
> --- a/arch/arm64/kvm/hyp-init.S
> +++ b/arch/arm64/kvm/hyp-init.S
> @@ -63,17 +63,21 @@ __do_hyp_init:
>  	mrs	x4, tcr_el1
>  	ldr	x5, =TCR_EL2_MASK
>  	and	x4, x4, x5
> -	ldr	x5, =TCR_EL2_FLAGS
> -	orr	x4, x4, x5
> -	msr	tcr_el2, x4
> -
> -	ldr	x4, =VTCR_EL2_FLAGS
>  	/*
>  	 * Read the PARange bits from ID_AA64MMFR0_EL1 and set the PS bits in
> -	 * VTCR_EL2.
> +	 * TCR_EL2 and both PS bits and T0SZ bits in VTCR_EL2.

and the PS and T0SZ bits in VTCR_EL2.

>  	 */
>  	mrs	x5, ID_AA64MMFR0_EL1
>  	bfi	x4, x5, #16, #3
> +	msr	tcr_el2, x4

put a comment: // set TCR_EL2.PS to ID_AA64MMFR0_EL1.PARange


> +
> +	ldr	x4, =VTCR_EL2_FLAGS
> +	bfi	x4, x5, #16, #3

put the same comment here, except that it is VTCR_EL2.PS

> +	and	x5, x5, #0xf
> +	adr	x6, t0sz
> +	add	x6, x6, x5, lsl #2
> +	ldr	w5, [x6]
> +	orr	x4, x4, x5
>  	msr	vtcr_el2, x4
>  
>  	mrs	x4, mair_el1
> @@ -109,6 +113,10 @@ target: /* We're now in the trampoline code, switch page tables */
>  
>  	/* Hello, World! */
>  	eret
> +
> +t0sz:
> +	.word	VTCR_EL2_T0SZ(32), VTCR_EL2_T0SZ(36), VTCR_EL2_T0SZ(40)
> +	.word	VTCR_EL2_T0SZ(42), VTCR_EL2_T0SZ(44), VTCR_EL2_T0SZ(48)
>  ENDPROC(__kvm_hyp_init)
>  
>  	.ltorg
> -- 
> 1.7.10.4
> 
> 

Thanks,
-Christoffer

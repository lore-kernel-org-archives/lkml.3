Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab3IZJGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 05:06:49 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:36943 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab3IZJGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 05:06:45 -0400
Message-ID: <5243F933.7000907@redhat.com>
Date: Thu, 26 Sep 2013 11:06:59 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, gleb@redhat.com, agraf@suse.de,
        mpm@selenic.com, herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
References: <1380177066-3835-1-git-send-email-michael@ellerman.id.au> <1380177066-3835-3-git-send-email-michael@ellerman.id.au>
In-Reply-To: <1380177066-3835-3-git-send-email-michael@ellerman.id.au>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 26/09/2013 08:31, Michael Ellerman ha scritto:
> Some powernv systems include a hwrng. Guests can access it via the
> H_RANDOM hcall.
> 
> We add a real mode implementation of H_RANDOM when a hwrng is found.
> Userspace can detect the presence of the hwrng by quering the
> KVM_CAP_PPC_HWRNG capability.
> 
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
> ---
>  arch/powerpc/include/asm/archrandom.h   |  11 ++-
>  arch/powerpc/include/asm/kvm_ppc.h      |   2 +
>  arch/powerpc/kvm/book3s_hv_builtin.c    |  15 ++++
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S | 119 ++++++++++++++++++++++++++++++++
>  arch/powerpc/kvm/powerpc.c              |   3 +
>  arch/powerpc/platforms/powernv/rng.c    |  25 +++++++
>  include/uapi/linux/kvm.h                |   1 +
>  7 files changed, 174 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/archrandom.h b/arch/powerpc/include/asm/archrandom.h
> index d853d16..86296d5 100644
> --- a/arch/powerpc/include/asm/archrandom.h
> +++ b/arch/powerpc/include/asm/archrandom.h
> @@ -25,8 +25,15 @@ static inline int arch_get_random_int(unsigned int *v)
>  	return rc;
>  }
>  
> -int powernv_get_random_long(unsigned long *v);
> -
>  #endif /* CONFIG_ARCH_RANDOM */
>  
> +#ifdef CONFIG_PPC_POWERNV
> +int powernv_hwrng_present(void);
> +int powernv_get_random_long(unsigned long *v);
> +int powernv_get_random_real_mode(unsigned long *v);
> +#else
> +static inline int powernv_hwrng_present(void) { return 0; }
> +static inline int powernv_get_random_real_mode(unsigned long *v) { return 0; }
> +#endif
> +
>  #endif /* _ASM_POWERPC_ARCHRANDOM_H */
> diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
> index b15554a..51966fd 100644
> --- a/arch/powerpc/include/asm/kvm_ppc.h
> +++ b/arch/powerpc/include/asm/kvm_ppc.h
> @@ -177,6 +177,8 @@ extern int kvmppc_xics_get_xive(struct kvm *kvm, u32 irq, u32 *server,
>  extern int kvmppc_xics_int_on(struct kvm *kvm, u32 irq);
>  extern int kvmppc_xics_int_off(struct kvm *kvm, u32 irq);
>  
> +extern int kvmppc_hwrng_present(void);
> +
>  /*
>   * Cuts out inst bits with ordering according to spec.
>   * That means the leftmost bit is zero. All given bits are included.
> diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
> index 8cd0dae..de12592 100644
> --- a/arch/powerpc/kvm/book3s_hv_builtin.c
> +++ b/arch/powerpc/kvm/book3s_hv_builtin.c
> @@ -19,6 +19,7 @@
>  #include <asm/cputable.h>
>  #include <asm/kvm_ppc.h>
>  #include <asm/kvm_book3s.h>
> +#include <asm/archrandom.h>
>  
>  #include "book3s_hv_cma.h"
>  /*
> @@ -181,3 +182,17 @@ void __init kvm_cma_reserve(void)
>  		kvm_cma_declare_contiguous(selected_size, align_size);
>  	}
>  }
> +
> +int kvmppc_hwrng_present(void)
> +{
> +	return powernv_hwrng_present();
> +}
> +EXPORT_SYMBOL_GPL(kvmppc_hwrng_present);
> +
> +long kvmppc_h_random(struct kvm_vcpu *vcpu)
> +{
> +	if (powernv_get_random_real_mode(&vcpu->arch.gpr[4]))
> +		return H_SUCCESS;
> +
> +	return H_HARDWARE;
> +}
> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> index 294b7af..35ce59e 100644
> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> @@ -1502,6 +1502,125 @@ hcall_real_table:
>  	.long	0		/* 0x11c */
>  	.long	0		/* 0x120 */
>  	.long	.kvmppc_h_bulk_remove - hcall_real_table
> +	.long	0		/* 0x128 */
> +	.long	0		/* 0x12c */
> +	.long	0		/* 0x130 */
> +	.long	0		/* 0x134 */
> +	.long	0		/* 0x138 */
> +	.long	0		/* 0x13c */
> +	.long	0		/* 0x140 */
> +	.long	0		/* 0x144 */
> +	.long	0		/* 0x148 */
> +	.long	0		/* 0x14c */
> +	.long	0		/* 0x150 */
> +	.long	0		/* 0x154 */
> +	.long	0		/* 0x158 */
> +	.long	0		/* 0x15c */
> +	.long	0		/* 0x160 */
> +	.long	0		/* 0x164 */
> +	.long	0		/* 0x168 */
> +	.long	0		/* 0x16c */
> +	.long	0		/* 0x170 */
> +	.long	0		/* 0x174 */
> +	.long	0		/* 0x178 */
> +	.long	0		/* 0x17c */
> +	.long	0		/* 0x180 */
> +	.long	0		/* 0x184 */
> +	.long	0		/* 0x188 */
> +	.long	0		/* 0x18c */
> +	.long	0		/* 0x190 */
> +	.long	0		/* 0x194 */
> +	.long	0		/* 0x198 */
> +	.long	0		/* 0x19c */
> +	.long	0		/* 0x1a0 */
> +	.long	0		/* 0x1a4 */
> +	.long	0		/* 0x1a8 */
> +	.long	0		/* 0x1ac */
> +	.long	0		/* 0x1b0 */
> +	.long	0		/* 0x1b4 */
> +	.long	0		/* 0x1b8 */
> +	.long	0		/* 0x1bc */
> +	.long	0		/* 0x1c0 */
> +	.long	0		/* 0x1c4 */
> +	.long	0		/* 0x1c8 */
> +	.long	0		/* 0x1cc */
> +	.long	0		/* 0x1d0 */
> +	.long	0		/* 0x1d4 */
> +	.long	0		/* 0x1d8 */
> +	.long	0		/* 0x1dc */
> +	.long	0		/* 0x1e0 */
> +	.long	0		/* 0x1e4 */
> +	.long	0		/* 0x1e8 */
> +	.long	0		/* 0x1ec */
> +	.long	0		/* 0x1f0 */
> +	.long	0		/* 0x1f4 */
> +	.long	0		/* 0x1f8 */
> +	.long	0		/* 0x1fc */
> +	.long	0		/* 0x200 */
> +	.long	0		/* 0x204 */
> +	.long	0		/* 0x208 */
> +	.long	0		/* 0x20c */
> +	.long	0		/* 0x210 */
> +	.long	0		/* 0x214 */
> +	.long	0		/* 0x218 */
> +	.long	0		/* 0x21c */
> +	.long	0		/* 0x220 */
> +	.long	0		/* 0x224 */
> +	.long	0		/* 0x228 */
> +	.long	0		/* 0x22c */
> +	.long	0		/* 0x230 */
> +	.long	0		/* 0x234 */
> +	.long	0		/* 0x238 */
> +	.long	0		/* 0x23c */
> +	.long	0		/* 0x240 */
> +	.long	0		/* 0x244 */
> +	.long	0		/* 0x248 */
> +	.long	0		/* 0x24c */
> +	.long	0		/* 0x250 */
> +	.long	0		/* 0x254 */
> +	.long	0		/* 0x258 */
> +	.long	0		/* 0x25c */
> +	.long	0		/* 0x260 */
> +	.long	0		/* 0x264 */
> +	.long	0		/* 0x268 */
> +	.long	0		/* 0x26c */
> +	.long	0		/* 0x270 */
> +	.long	0		/* 0x274 */
> +	.long	0		/* 0x278 */
> +	.long	0		/* 0x27c */
> +	.long	0		/* 0x280 */
> +	.long	0		/* 0x284 */
> +	.long	0		/* 0x288 */
> +	.long	0		/* 0x28c */
> +	.long	0		/* 0x290 */
> +	.long	0		/* 0x294 */
> +	.long	0		/* 0x298 */
> +	.long	0		/* 0x29c */
> +	.long	0		/* 0x2a0 */
> +	.long	0		/* 0x2a4 */
> +	.long	0		/* 0x2a8 */
> +	.long	0		/* 0x2ac */
> +	.long	0		/* 0x2b0 */
> +	.long	0		/* 0x2b4 */
> +	.long	0		/* 0x2b8 */
> +	.long	0		/* 0x2bc */
> +	.long	0		/* 0x2c0 */
> +	.long	0		/* 0x2c4 */
> +	.long	0		/* 0x2c8 */
> +	.long	0		/* 0x2cc */
> +	.long	0		/* 0x2d0 */
> +	.long	0		/* 0x2d4 */
> +	.long	0		/* 0x2d8 */
> +	.long	0		/* 0x2dc */
> +	.long	0		/* 0x2e0 */
> +	.long	0		/* 0x2e4 */
> +	.long	0		/* 0x2e8 */
> +	.long	0		/* 0x2ec */
> +	.long	0		/* 0x2f0 */
> +	.long	0		/* 0x2f4 */
> +	.long	0		/* 0x2f8 */
> +	.long	0		/* 0x2fc */
> +	.long	.kvmppc_h_random - hcall_real_table
>  hcall_real_table_end:
>  
>  ignore_hdec:
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 07c0106..0d7208e 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -356,6 +356,9 @@ int kvm_dev_ioctl_check_extension(long ext)
>  		if (cpu_has_feature(CPU_FTR_ARCH_201))
>  			r = 2;
>  		break;
> +	case KVM_CAP_PPC_HWRNG:
> +		r = kvmppc_hwrng_present();
> +		break;
>  #endif
>  	case KVM_CAP_SYNC_MMU:
>  #ifdef CONFIG_KVM_BOOK3S_64_HV
> diff --git a/arch/powerpc/platforms/powernv/rng.c b/arch/powerpc/platforms/powernv/rng.c
> index 51d2e6a..ea7e5cd 100644
> --- a/arch/powerpc/platforms/powernv/rng.c
> +++ b/arch/powerpc/platforms/powernv/rng.c
> @@ -20,12 +20,18 @@
>  
>  struct powernv_rng {
>  	void __iomem *regs;
> +	void __iomem *regs_real;
>  	unsigned long mask;
>  };
>  
>  static DEFINE_PER_CPU(struct powernv_rng *, powernv_rng);
>  
>  
> +int powernv_hwrng_present(void)
> +{
> +	return __raw_get_cpu_var(powernv_rng) != NULL;
> +}
> +
>  static unsigned long rng_whiten(struct powernv_rng *rng, unsigned long val)
>  {
>  	unsigned long parity;
> @@ -42,6 +48,17 @@ static unsigned long rng_whiten(struct powernv_rng *rng, unsigned long val)
>  	return val;
>  }
>  
> +int powernv_get_random_real_mode(unsigned long *v)
> +{
> +	struct powernv_rng *rng;
> +
> +	rng = __raw_get_cpu_var(powernv_rng);
> +
> +	*v = rng_whiten(rng, in_rm64(rng->regs_real));
> +
> +	return 1;
> +}
> +
>  int powernv_get_random_long(unsigned long *v)
>  {
>  	struct powernv_rng *rng;
> @@ -76,12 +93,20 @@ static __init void rng_init_per_cpu(struct powernv_rng *rng,
>  static __init int rng_create(struct device_node *dn)
>  {
>  	struct powernv_rng *rng;
> +	struct resource res;
>  	unsigned long val;
>  
>  	rng = kzalloc(sizeof(*rng), GFP_KERNEL);
>  	if (!rng)
>  		return -ENOMEM;
>  
> +	if (of_address_to_resource(dn, 0, &res)) {
> +		kfree(rng);
> +		return -ENXIO;
> +	}
> +
> +	rng->regs_real = (void __iomem *)res.start;
> +
>  	rng->regs = of_iomap(dn, 0);
>  	if (!rng->regs) {
>  		kfree(rng);
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 99c2533..493a409 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -668,6 +668,7 @@ struct kvm_ppc_smmu_info {
>  #define KVM_CAP_IRQ_XICS 92
>  #define KVM_CAP_ARM_EL1_32BIT 93
>  #define KVM_CAP_SPAPR_MULTITCE 94
> +#define KVM_CAP_PPC_HWRNG 95
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> 

Is there any reason to do this in the kernel?  It does not have to be a
particularly fast path; on x86, we are simply forwarding /dev/hwrng or
/dev/random data to the guest.  You can simply use virtio-rng.

If you really want to have the hypercall, implementing it in QEMU means
that you can support it on all systems, in fact even when running
without KVM.  The QEMU command line would be something like "-object
rng-random,filename=/dev/random,id=rng0 -device spapr-rng,rng=rng0".

Paolo

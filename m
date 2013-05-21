Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab3EUPiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 11:38:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab3EUPiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 11:38:15 -0400
Date: Tue, 21 May 2013 18:37:52 +0300
From: Gleb Natapov <gleb@redhat.com>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v3 5/5] mips/kvm: Fix ABI by moving manipulation of CP0
 registers to KVM_{G,S}ET_MSRS
Message-ID: <20130521153752.GD14287@redhat.com>
References: <1369083686-27524-1-git-send-email-ddaney.cavm@gmail.com>
 <1369083686-27524-6-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369083686-27524-6-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 02:01:26PM -0700, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> Because not all 256 CP0 registers are ever implemented, we need a
> different method of manipulating them.  Use the
> KVM_GET_MSRS/KVM_SET_MSRS mechanism as x86 does for its MSRs.
> 
Have you looked at KVM_(GET|SET)_ONE_REG interface (not used by x86, but is
used bu arm/ppc/s390). It looks like it is more suitable for your case.
Actually you can use it instead of KVM_(GET|SET)_REGS for all registers.

> Code related to implementing KVM_GET_MSRS/KVM_SET_MSRS is consolidated
> in to kvm_trap_emul.c, now unused code and definitions are removed.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  arch/mips/include/asm/kvm.h      |  69 ++++++--
>  arch/mips/include/asm/kvm_host.h |   4 -
>  arch/mips/kvm/kvm_mips.c         |  92 +----------
>  arch/mips/kvm/kvm_trap_emul.c    | 330 ++++++++++++++++++++++++++++++++++-----
>  4 files changed, 350 insertions(+), 145 deletions(-)
> 
> diff --git a/arch/mips/include/asm/kvm.h b/arch/mips/include/asm/kvm.h
> index d145ead..cae080c 100644
> --- a/arch/mips/include/asm/kvm.h
> +++ b/arch/mips/include/asm/kvm.h
> @@ -13,10 +13,11 @@
>  
>  #include <linux/types.h>
>  
> -#define __KVM_MIPS
> -
> -#define N_MIPS_COPROC_REGS      32
> -#define N_MIPS_COPROC_SEL   	8
> +/*
> + * KVM MIPS specific structures and definitions.
> + *
> + * Some parts derived from the x86 version of this file.
> + */
>  
>  /*
>   * for KVM_GET_REGS and KVM_SET_REGS
> @@ -31,12 +32,6 @@ struct kvm_regs {
>  	__u64 hi;
>  	__u64 lo;
>  	__u64 pc;
> -
> -	__u32 cp0reg[N_MIPS_COPROC_REGS][N_MIPS_COPROC_SEL];
> -};
> -
> -/* for KVM_GET_SREGS and KVM_SET_SREGS */
> -struct kvm_sregs {
>  };
>  
>  /*
> @@ -55,21 +50,67 @@ struct kvm_fpu {
>  	__u32 pad;
>  };
>  
> +
> +/*
> + * For MIPS, we use the same APIs as x86, where 'msr' corresponds to a
> + * CP0 register.  The index field is broken down as follows:
> + *
> + *  bits[2..0]   - Register 'sel' index.
> + *  bits[7..3]   - Register 'rd'  index.
> + *  bits[15..8]  - Must be zero.
> + *  bits[31..16] - 0 -> CP0 registers.
> + *
> + * Other sets registers may be added in the future.  Each set would
> + * have its own identifier in bits[31..16].
> + *
> + * For MSRs that are narrower than 64-bits, the value is stored in the
> + * low order bits of the data field, and sign extended to 64-bits.
> + */
> +#define KVM_MIPS_MSR_CP0 0
> +struct kvm_msr_entry {
> +	__u32 index;
> +	__u32 reserved;
> +	__u64 data;
> +};
> +
> +/* for KVM_GET_MSRS and KVM_SET_MSRS */
> +struct kvm_msrs {
> +	__u32 nmsrs; /* number of msrs in entries */
> +	__u32 pad;
> +
> +	struct kvm_msr_entry entries[0];
> +};
> +
> +/* for KVM_GET_MSR_INDEX_LIST */
> +struct kvm_msr_list {
> +	__u32 nmsrs; /* number of msrs in entries */
> +	__u32 indices[0];
> +};
> +
> +/*
> + * KVM MIPS specific structures and definitions
> + *
> + */
>  struct kvm_debug_exit_arch {
> +	__u64 epc;
>  };
>  
>  /* for KVM_SET_GUEST_DEBUG */
>  struct kvm_guest_debug_arch {
>  };
>  
> +/* definition of registers in kvm_run */
> +struct kvm_sync_regs {
> +};
> +
> +/* dummy definition */
> +struct kvm_sregs {
> +};
> +
>  struct kvm_mips_interrupt {
>  	/* in */
>  	__u32 cpu;
>  	__u32 irq;
>  };
>  
> -/* definition of registers in kvm_run */
> -struct kvm_sync_regs {
> -};
> -
>  #endif /* __LINUX_KVM_MIPS_H */
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 143875c..4d6fa0b 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -496,10 +496,6 @@ struct kvm_mips_callbacks {
>  			    uint32_t cause);
>  	int (*irq_clear) (struct kvm_vcpu *vcpu, unsigned int priority,
>  			  uint32_t cause);
> -	int (*vcpu_ioctl_get_regs) (struct kvm_vcpu *vcpu,
> -				    struct kvm_regs *regs);
> -	int (*vcpu_ioctl_set_regs) (struct kvm_vcpu *vcpu,
> -				    struct kvm_regs *regs);
>  };
>  extern struct kvm_mips_callbacks *kvm_mips_callbacks;
>  int kvm_mips_emulation_init(struct kvm_mips_callbacks **install_callbacks);
> diff --git a/arch/mips/kvm/kvm_mips.c b/arch/mips/kvm/kvm_mips.c
> index 71a1fc1..26a40e3 100644
> --- a/arch/mips/kvm/kvm_mips.c
> +++ b/arch/mips/kvm/kvm_mips.c
> @@ -51,16 +51,6 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>  	{NULL}
>  };
>  
> -static int kvm_mips_reset_vcpu(struct kvm_vcpu *vcpu)
> -{
> -	int i;
> -	for_each_possible_cpu(i) {
> -		vcpu->arch.guest_kernel_asid[i] = 0;
> -		vcpu->arch.guest_user_asid[i] = 0;
> -	}
> -	return 0;
> -}
> -
>  gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
>  {
>  	return gfn;
> @@ -192,12 +182,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  	}
>  }
>  
> -long
> -kvm_arch_dev_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> -{
> -	return -EINVAL;
> -}
> -
>  void kvm_arch_free_memslot(struct kvm_memory_slot *free,
>  			   struct kvm_memory_slot *dont)
>  {
> @@ -435,42 +419,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  	return r;
>  }
> -
> -int
> -kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, struct kvm_mips_interrupt *irq)
> -{
> -	int intr = (int)irq->irq;
> -	struct kvm_vcpu *dvcpu = NULL;
> -
> -	if (intr == 3 || intr == -3 || intr == 4 || intr == -4)
> -		kvm_debug("%s: CPU: %d, INTR: %d\n", __func__, irq->cpu,
> -			  (int)intr);
> -
> -	if (irq->cpu == -1)
> -		dvcpu = vcpu;
> -	else
> -		dvcpu = vcpu->kvm->vcpus[irq->cpu];
> -
> -	if (intr == 2 || intr == 3 || intr == 4) {
> -		kvm_mips_callbacks->queue_io_int(dvcpu, irq);
> -
> -	} else if (intr == -2 || intr == -3 || intr == -4) {
> -		kvm_mips_callbacks->dequeue_io_int(dvcpu, irq);
> -	} else {
> -		kvm_err("%s: invalid interrupt ioctl (%d:%d)\n", __func__,
> -			irq->cpu, irq->irq);
> -		return -EINVAL;
> -	}
> -
> -	dvcpu->arch.wait = 0;
> -
> -	if (waitqueue_active(&dvcpu->wq)) {
> -		wake_up_interruptible(&dvcpu->wq);
> -	}
> -
> -	return 0;
> -}
> -
>  int
>  kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
>  				struct kvm_mp_state *mp_state)
> @@ -485,42 +433,6 @@ kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
>  	return -EINVAL;
>  }
>  
> -long
> -kvm_arch_vcpu_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> -{
> -	struct kvm_vcpu *vcpu = filp->private_data;
> -	void __user *argp = (void __user *)arg;
> -	long r;
> -	int intr;
> -
> -	switch (ioctl) {
> -	case KVM_NMI:
> -		/* Treat the NMI as a CPU reset */
> -		r = kvm_mips_reset_vcpu(vcpu);
> -		break;
> -	case KVM_INTERRUPT:
> -		{
> -			struct kvm_mips_interrupt irq;
> -			r = -EFAULT;
> -			if (copy_from_user(&irq, argp, sizeof(irq)))
> -				goto out;
> -
> -			intr = (int)irq.irq;
> -
> -			kvm_debug("[%d] %s: irq: %d\n", vcpu->vcpu_id, __func__,
> -				  irq.irq);
> -
> -			r = kvm_vcpu_ioctl_interrupt(vcpu, &irq);
> -			break;
> -		}
> -	default:
> -		r = -EINVAL;
> -	}
> -
> -out:
> -	return r;
> -}
> -
>  /*
>   * Get (and clear) the dirty memory log for a memory slot.
>   */
> @@ -684,7 +596,7 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>  	vcpu->arch.lo = regs->lo;
>  	vcpu->arch.pc = regs->pc;
>  
> -	return kvm_mips_callbacks->vcpu_ioctl_set_regs(vcpu, regs);
> +	return 0;
>  }
>  
>  int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
> @@ -698,7 +610,7 @@ int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>  	regs->lo = vcpu->arch.lo;
>  	regs->pc = vcpu->arch.pc;
>  
> -	return kvm_mips_callbacks->vcpu_ioctl_get_regs(vcpu, regs);
> +	return 0;
>  }
>  
>  void kvm_mips_comparecount_func(unsigned long data)
> diff --git a/arch/mips/kvm/kvm_trap_emul.c b/arch/mips/kvm/kvm_trap_emul.c
> index 466aeef..df98dcb 100644
> --- a/arch/mips/kvm/kvm_trap_emul.c
> +++ b/arch/mips/kvm/kvm_trap_emul.c
> @@ -13,7 +13,7 @@
>  #include <linux/err.h>
>  #include <linux/module.h>
>  #include <linux/vmalloc.h>
> -
> +#include <linux/fs.h>
>  #include <linux/kvm_host.h>
>  
>  #include "kvm_mips_opcode.h"
> @@ -345,54 +345,312 @@ static int kvm_trap_emul_handle_break(struct kvm_vcpu *vcpu)
>  	return ret;
>  }
>  
> -static int
> -kvm_trap_emul_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
> +#define MSR_MIPS_CP0_INDEX (8 * 0 + 0)
> +#define MSR_MIPS_CP0_ENTRYLO0 (8 * 2 + 0)
> +#define MSR_MIPS_CP0_ENTRYLO1 (8 * 3 + 0)
> +#define MSR_MIPS_CP0_CONTEXT (8 * 4 + 0)
> +#define MSR_MIPS_CP0_USERLOCAL (8 * 4 + 2)
> +#define MSR_MIPS_CP0_PAGEMASK (8 * 5 + 0)
> +#define MSR_MIPS_CP0_PAGEGRAIN (8 * 5 + 1)
> +#define MSR_MIPS_CP0_WIRED (8 * 6 + 0)
> +#define MSR_MIPS_CP0_HWRENA (8 * 7 + 0)
> +#define MSR_MIPS_CP0_BADVADDR (8 * 8 + 0)
> +#define MSR_MIPS_CP0_COUNT (8 * 9 + 0)
> +#define MSR_MIPS_CP0_ENTRYHI (8 * 10 + 0)
> +#define MSR_MIPS_CP0_COMPARE (8 * 11 + 0)
> +#define MSR_MIPS_CP0_STATUS (8 * 12 + 0)
> +#define MSR_MIPS_CP0_CAUSE (8 * 13 + 0)
> +#define MSR_MIPS_CP0_EBASE (8 * 15 + 1)
> +#define MSR_MIPS_CP0_CONFIG (8 * 16 + 0)
> +#define MSR_MIPS_CP0_CONFIG1 (8 * 16 + 1)
> +#define MSR_MIPS_CP0_CONFIG2 (8 * 16 + 2)
> +#define MSR_MIPS_CP0_CONFIG3 (8 * 16 + 3)
> +#define MSR_MIPS_CP0_CONFIG7 (8 * 16 + 7)
> +#define MSR_MIPS_CP0_XCONTEXT (8 * 20 + 0)
> +#define MSR_MIPS_CP0_ERROREPC (8 * 30 + 0)
> +
> +static u32 msrs_to_save[] = {
> +	MSR_MIPS_CP0_INDEX,
> +	MSR_MIPS_CP0_CONTEXT,
> +	MSR_MIPS_CP0_PAGEMASK,
> +	MSR_MIPS_CP0_WIRED,
> +	MSR_MIPS_CP0_BADVADDR,
> +	MSR_MIPS_CP0_ENTRYHI,
> +	MSR_MIPS_CP0_STATUS,
> +	MSR_MIPS_CP0_CAUSE,
> +	/* EPC set via kvm_regs, et al. */
> +	MSR_MIPS_CP0_CONFIG,
> +	MSR_MIPS_CP0_CONFIG1,
> +	MSR_MIPS_CP0_CONFIG2,
> +	MSR_MIPS_CP0_CONFIG3,
> +	MSR_MIPS_CP0_CONFIG7,
> +	MSR_MIPS_CP0_XCONTEXT,
> +	MSR_MIPS_CP0_ERROREPC
> +};
> +
> +#define MAX_IO_MSRS 128
> +
> +static int mipsvz_get_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
>  {
>  	struct mips_coproc *cop0 = vcpu->arch.cop0;
> +	s64 v;
>  
> -	kvm_write_c0_guest_index(cop0, regs->cp0reg[MIPS_CP0_TLB_INDEX][0]);
> -	kvm_write_c0_guest_context(cop0, regs->cp0reg[MIPS_CP0_TLB_CONTEXT][0]);
> -	kvm_write_c0_guest_badvaddr(cop0, regs->cp0reg[MIPS_CP0_BAD_VADDR][0]);
> -	kvm_write_c0_guest_entryhi(cop0, regs->cp0reg[MIPS_CP0_TLB_HI][0]);
> -	kvm_write_c0_guest_epc(cop0, regs->cp0reg[MIPS_CP0_EXC_PC][0]);
> +	switch (index) {
> +	case MSR_MIPS_CP0_INDEX:
> +		v = (long)kvm_read_c0_guest_index(cop0);
> +		break;
> +	case MSR_MIPS_CP0_CONTEXT:
> +		v = (long)kvm_read_c0_guest_context(cop0);
> +		break;
> +	case MSR_MIPS_CP0_PAGEMASK:
> +		v = (long)kvm_read_c0_guest_pagemask(cop0);
> +		break;
> +	case MSR_MIPS_CP0_WIRED:
> +		v = (long)kvm_read_c0_guest_wired(cop0);
> +		break;
> +	case MSR_MIPS_CP0_BADVADDR:
> +		v = (long)kvm_read_c0_guest_badvaddr(cop0);
> +		break;
> +	case MSR_MIPS_CP0_ENTRYHI:
> +		v = (long)kvm_read_c0_guest_entryhi(cop0);
> +		break;
> +	case MSR_MIPS_CP0_STATUS:
> +		v = (long)kvm_read_c0_guest_status(cop0);
> +		break;
> +	case MSR_MIPS_CP0_CAUSE:
> +		v = (long)kvm_read_c0_guest_cause(cop0);
> +		break;
> +	case MSR_MIPS_CP0_ERROREPC:
> +		v = (long)kvm_read_c0_guest_errorepc(cop0);
> +		break;
> +	case MSR_MIPS_CP0_CONFIG:
> +		v = (long)kvm_read_c0_guest_config(cop0);
> +		break;
> +	case MSR_MIPS_CP0_CONFIG1:
> +		v = (long)kvm_read_c0_guest_config1(cop0);
> +		break;
> +	case MSR_MIPS_CP0_CONFIG2:
> +		v = (long)kvm_read_c0_guest_config2(cop0);
> +		break;
> +	case MSR_MIPS_CP0_CONFIG3:
> +		v = (long)kvm_read_c0_guest_config3(cop0);
> +		break;
> +	case MSR_MIPS_CP0_CONFIG7:
> +		v = (long)kvm_read_c0_guest_config7(cop0);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	*data = v;
> +	return 0;
> +}
>  
> -	kvm_write_c0_guest_status(cop0, regs->cp0reg[MIPS_CP0_STATUS][0]);
> -	kvm_write_c0_guest_cause(cop0, regs->cp0reg[MIPS_CP0_CAUSE][0]);
> -	kvm_write_c0_guest_pagemask(cop0,
> -				    regs->cp0reg[MIPS_CP0_TLB_PG_MASK][0]);
> -	kvm_write_c0_guest_wired(cop0, regs->cp0reg[MIPS_CP0_TLB_WIRED][0]);
> -	kvm_write_c0_guest_errorepc(cop0, regs->cp0reg[MIPS_CP0_ERROR_PC][0]);
> +static int mipsvz_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
> +{
> +	struct mips_coproc *cop0 = vcpu->arch.cop0;
> +	u64 v = *data;
>  
> +	switch (index) {
> +	case MSR_MIPS_CP0_INDEX:
> +		kvm_write_c0_guest_index(cop0, v);
> +		break;
> +	case MSR_MIPS_CP0_CONTEXT:
> +		kvm_write_c0_guest_context(cop0, v);
> +		break;
> +	case MSR_MIPS_CP0_PAGEMASK:
> +		kvm_write_c0_guest_pagemask(cop0, v);
> +		break;
> +	case MSR_MIPS_CP0_WIRED:
> +		kvm_write_c0_guest_wired(cop0, v);
> +		break;
> +	case MSR_MIPS_CP0_BADVADDR:
> +		kvm_write_c0_guest_badvaddr(cop0, v);
> +		break;
> +	case MSR_MIPS_CP0_ENTRYHI:
> +		kvm_write_c0_guest_entryhi(cop0, v);
> +		break;
> +	case MSR_MIPS_CP0_STATUS:
> +		kvm_write_c0_guest_status(cop0, v);
> +		break;
> +	case MSR_MIPS_CP0_CAUSE:
> +		kvm_write_c0_guest_cause(cop0, v);
> +		break;
> +	case MSR_MIPS_CP0_ERROREPC:
> +		kvm_write_c0_guest_errorepc(cop0, v);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
>  	return 0;
>  }
>  
> -static int
> -kvm_trap_emul_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
> +/*
> + * Read or write a bunch of msrs. Parameters are user addresses.
> + *
> + * @return number of msrs set successfully.
> + */
> +static int msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs __user *user_msrs,
> +		  int (*do_msr)(struct kvm_vcpu *vcpu,
> +				unsigned index, u64 *data),
> +		  bool writeback)
>  {
> -	struct mips_coproc *cop0 = vcpu->arch.cop0;
> +	struct kvm_msrs msrs;
> +	struct kvm_msr_entry *entries;
> +	int r, n;
> +	unsigned size;
> +
> +	r = -EFAULT;
> +	if (copy_from_user(&msrs, user_msrs, sizeof(msrs)))
> +		goto out;
> +
> +	r = -E2BIG;
> +	if (msrs.nmsrs >= MAX_IO_MSRS)
> +		goto out;
> +
> +	size = sizeof(struct kvm_msr_entry) * msrs.nmsrs;
> +	entries = memdup_user(user_msrs->entries, size);
> +	if (IS_ERR(entries)) {
> +		r = PTR_ERR(entries);
> +		goto out;
> +	}
>  
> -	regs->cp0reg[MIPS_CP0_TLB_INDEX][0] = kvm_read_c0_guest_index(cop0);
> -	regs->cp0reg[MIPS_CP0_TLB_CONTEXT][0] = kvm_read_c0_guest_context(cop0);
> -	regs->cp0reg[MIPS_CP0_BAD_VADDR][0] = kvm_read_c0_guest_badvaddr(cop0);
> -	regs->cp0reg[MIPS_CP0_TLB_HI][0] = kvm_read_c0_guest_entryhi(cop0);
> -	regs->cp0reg[MIPS_CP0_EXC_PC][0] = kvm_read_c0_guest_epc(cop0);
> -
> -	regs->cp0reg[MIPS_CP0_STATUS][0] = kvm_read_c0_guest_status(cop0);
> -	regs->cp0reg[MIPS_CP0_CAUSE][0] = kvm_read_c0_guest_cause(cop0);
> -	regs->cp0reg[MIPS_CP0_TLB_PG_MASK][0] =
> -	    kvm_read_c0_guest_pagemask(cop0);
> -	regs->cp0reg[MIPS_CP0_TLB_WIRED][0] = kvm_read_c0_guest_wired(cop0);
> -	regs->cp0reg[MIPS_CP0_ERROR_PC][0] = kvm_read_c0_guest_errorepc(cop0);
> -
> -	regs->cp0reg[MIPS_CP0_CONFIG][0] = kvm_read_c0_guest_config(cop0);
> -	regs->cp0reg[MIPS_CP0_CONFIG][1] = kvm_read_c0_guest_config1(cop0);
> -	regs->cp0reg[MIPS_CP0_CONFIG][2] = kvm_read_c0_guest_config2(cop0);
> -	regs->cp0reg[MIPS_CP0_CONFIG][3] = kvm_read_c0_guest_config3(cop0);
> -	regs->cp0reg[MIPS_CP0_CONFIG][7] = kvm_read_c0_guest_config7(cop0);
> +	for (n = 0; n < msrs.nmsrs; ++n)
> +		if (do_msr(vcpu, entries[n].index, &entries[n].data))
> +			break;
> +
> +	r = -EFAULT;
> +	if (writeback && copy_to_user(user_msrs->entries, entries, size))
> +		goto out_free;
> +
> +	r = n;
> +
> +out_free:
> +	kfree(entries);
> +out:
> +	return r;
> +}
> +
> +static int kvm_mips_reset_vcpu(struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +	for_each_possible_cpu(i) {
> +		vcpu->arch.guest_kernel_asid[i] = 0;
> +		vcpu->arch.guest_user_asid[i] = 0;
> +	}
> +	return 0;
> +}
> +
> +int
> +kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, struct kvm_mips_interrupt *irq)
> +{
> +	int intr = (int)irq->irq;
> +	struct kvm_vcpu *dvcpu = NULL;
> +
> +	if (intr == 3 || intr == -3 || intr == 4 || intr == -4)
> +		kvm_debug("%s: CPU: %d, INTR: %d\n", __func__, irq->cpu,
> +			  (int)intr);
> +
> +	if (irq->cpu == -1)
> +		dvcpu = vcpu;
> +	else
> +		dvcpu = vcpu->kvm->vcpus[irq->cpu];
> +
> +	if (intr == 2 || intr == 3 || intr == 4) {
> +		kvm_mips_callbacks->queue_io_int(dvcpu, irq);
> +
> +	} else if (intr == -2 || intr == -3 || intr == -4) {
> +		kvm_mips_callbacks->dequeue_io_int(dvcpu, irq);
> +	} else {
> +		kvm_err("%s: invalid interrupt ioctl (%d:%d)\n", __func__,
> +			irq->cpu, irq->irq);
> +		return -EINVAL;
> +	}
> +
> +	dvcpu->arch.wait = 0;
> +
> +	if (waitqueue_active(&dvcpu->wq))
> +		wake_up_interruptible(&dvcpu->wq);
>  
>  	return 0;
>  }
>  
> +long
> +kvm_arch_vcpu_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> +{
> +	struct kvm_vcpu *vcpu = filp->private_data;
> +	void __user *argp = (void __user *)arg;
> +	long r;
> +
> +	switch (ioctl) {
> +	case KVM_GET_MSRS:
> +		r = msr_io(vcpu, argp, mipsvz_get_msr, true);
> +		break;
> +	case KVM_SET_MSRS:
> +		r = msr_io(vcpu, argp, mipsvz_set_msr, false);
> +		break;
> +	case KVM_NMI:
> +		/* Treat the NMI as a CPU reset */
> +		r = kvm_mips_reset_vcpu(vcpu);
> +		break;
> +	case KVM_INTERRUPT:
> +		{
> +			struct kvm_mips_interrupt irq;
> +			r = -EFAULT;
> +			if (copy_from_user(&irq, argp, sizeof(irq)))
> +				goto out;
> +
> +			kvm_debug("[%d] %s: irq: %d\n", vcpu->vcpu_id, __func__,
> +				  irq.irq);
> +
> +			r = kvm_vcpu_ioctl_interrupt(vcpu, &irq);
> +			break;
> +		}
> +	default:
> +		r = -ENOIOCTLCMD;
> +	}
> +
> +out:
> +	return r;
> +}
> +
> +long kvm_arch_dev_ioctl(struct file *filp,
> +			unsigned int ioctl, unsigned long arg)
> +{
> +	long r;
> +	void __user *argp = (void __user *)arg;
> +
> +	switch (ioctl) {
> +	case KVM_GET_MSR_INDEX_LIST: {
> +		struct kvm_msr_list __user *user_msr_list = argp;
> +		struct kvm_msr_list msr_list;
> +		unsigned n;
> +		unsigned num_msrs_to_save;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&msr_list, user_msr_list, sizeof(msr_list)))
> +			goto out;
> +		n = msr_list.nmsrs;
> +		msr_list.nmsrs = ARRAY_SIZE(msrs_to_save);
> +		num_msrs_to_save = min(n, msr_list.nmsrs);
> +		if (copy_to_user(user_msr_list, &msr_list, sizeof(msr_list)))
> +			goto out;
> +		r = -E2BIG;
> +		if (n < msr_list.nmsrs)
> +			goto out;
> +		r = -EFAULT;
> +		if (copy_to_user(user_msr_list->indices, &msrs_to_save,
> +				 num_msrs_to_save * sizeof(u32)))
> +			goto out;
> +		r = 0;
> +		break;
> +	}
> +	default:
> +		r = -ENOIOCTLCMD;
> +	}
> +out:
> +	return r;
> +}
> +
>  static int kvm_trap_emul_vm_init(struct kvm *kvm)
>  {
>  	return 0;
> @@ -471,8 +729,6 @@ static struct kvm_mips_callbacks kvm_trap_emul_callbacks = {
>  	.dequeue_io_int = kvm_mips_dequeue_io_int_cb,
>  	.irq_deliver = kvm_mips_irq_deliver_cb,
>  	.irq_clear = kvm_mips_irq_clear_cb,
> -	.vcpu_ioctl_get_regs = kvm_trap_emul_ioctl_get_regs,
> -	.vcpu_ioctl_set_regs = kvm_trap_emul_ioctl_set_regs,
>  };
>  
>  int kvm_mips_emulation_init(struct kvm_mips_callbacks **install_callbacks)
> -- 
> 1.7.11.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.

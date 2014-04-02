Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbaDBAnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:43:12 -0400
Received: from ozlabs.org ([203.10.76.45]:42730 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbaDBAnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 20:43:09 -0400
From: Michael Neuling <mikey@neuling.org>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
Subject: Re: [RFC] powerpc, ptrace: Add few more ptrace request macros
In-reply-to: <1396350893-4456-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1396350893-4456-1-git-send-email-khandual@linux.vnet.ibm.com>
Comments: In-reply-to Anshuman Khandual <khandual@linux.vnet.ibm.com>
   message dated "Tue, 01 Apr 2014 16:44:53 +0530."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Wed, 02 Apr 2014 11:43:07 +1100
Message-ID: <25834.1396399387@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Anshuman Khandual <khandual@linux.vnet.ibm.com> wrote:
> This patch adds few more ptrace request macros expanding
> the existing capability. These ptrace requests macros can
> be classified into two categories.

Why is this only an RFC?

Also, please share the test case that you wrote for this.

Mikey


> 
> (1) Transactional memory
> 
> 	/* TM special purpose registers */
> 	PTRACE_GETTM_SPRREGS
> 	PTRACE_SETTM_SPRREGS
> 
> 	/* Checkpointed GPR registers */
> 	PTRACE_GETTM_CGPRREGS
> 	PTRACE_SETTM_CGPRREGS
> 
> 	/* Checkpointed FPR registers */
> 	PTRACE_GETTM_CFPRREGS
> 	PTRACE_SETTM_CFPRREGS
> 
> 	/* Checkpointed VMX registers */
> 	PTRACE_GETTM_CVMXREGS
> 	PTRACE_SETTM_CVMXREGS
> 
> (2) Miscellaneous
> 
> 	/* TAR, PPR, DSCR registers */
> 	PTRACE_GETMSCREGS
> 	PTRACE_SETMSCREGS
> 
> This patch also adds mutliple new generic ELF core note sections in
> this regard which can be listed as follows.
> 
> 	NT_PPC_TM_SPR	/* Transactional memory specific registers */
> 	NT_PPC_TM_CGPR	/* Transactional memory checkpointed GPR */
> 	NT_PPC_TM_CFPR	/* Transactional memory checkpointed FPR */
> 	NT_PPC_TM_CVMX	/* Transactional memory checkpointed VMX */
> 	NT_PPC_MISC	/* Miscellaneous registers */
> 
> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> ---
>  arch/powerpc/include/asm/switch_to.h   |   8 +
>  arch/powerpc/include/uapi/asm/ptrace.h |  61 +++
>  arch/powerpc/kernel/process.c          |  24 ++
>  arch/powerpc/kernel/ptrace.c           | 658 +++++++++++++++++++++++++++++++--
>  include/uapi/linux/elf.h               |   5 +
>  5 files changed, 729 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/switch_to.h b/arch/powerpc/include/asm/switch_to.h
> index 0e83e7d..73e2601 100644
> --- a/arch/powerpc/include/asm/switch_to.h
> +++ b/arch/powerpc/include/asm/switch_to.h
> @@ -80,6 +80,14 @@ static inline void flush_spe_to_thread(struct task_struct *t)
>  }
>  #endif
>  
> +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> +extern void flush_tmreg_to_thread(struct task_struct *);
> +#else
> +static inline void flush_tmreg_to_thread(struct task_struct *t)
> +{
> +}
> +#endif
> +
>  static inline void clear_task_ebb(struct task_struct *t)
>  {
>  #ifdef CONFIG_PPC_BOOK3S_64
> diff --git a/arch/powerpc/include/uapi/asm/ptrace.h b/arch/powerpc/include/uapi/asm/ptrace.h
> index 77d2ed3..fd962d6 100644
> --- a/arch/powerpc/include/uapi/asm/ptrace.h
> +++ b/arch/powerpc/include/uapi/asm/ptrace.h
> @@ -190,6 +190,67 @@ struct pt_regs {
>  #define PPC_PTRACE_SETHWDEBUG	0x88
>  #define PPC_PTRACE_DELHWDEBUG	0x87
>  
> +/* Transactional memory registers */
> +
> +/*
> + * SPR
> + *
> + * struct data {
> + * 	u64		tm_tfhar;
> + *	u64		tm_texasr;
> + *	u64		tm_tfiar;
> + *	unsigned long   tm_orig_msr;
> + *	u64		tm_tar;
> + *	u64		tm_ppr;
> + *	u64		tm_dscr;
> + * };
> + */
> +#define PTRACE_GETTM_SPRREGS	0x70
> +#define PTRACE_SETTM_SPRREGS	0x71
> +
> +/* 
> + * Checkpointed GPR
> + *
> + * struct data {
> + *	struct pt_regs	ckpt_regs;
> + * };
> + */
> +#define PTRACE_GETTM_CGPRREGS	0x72
> +#define PTRACE_SETTM_CGPRREGS	0x73
> +
> +/*
> + * Checkpointed FPR
> + *
> + * struct data {
> + * 	u64	fpr[32];
> + * 	u64	fpscr;
> + * };
> + */
> +#define PTRACE_GETTM_CFPRREGS	0x74
> +#define PTRACE_SETTM_CFPRREGS	0x75
> +
> +/* 
> + * Checkpointed VMX
> + *
> + * struct data {
> + *	vector128	vr[32];
> + *	vector128	vscr;
> + *	unsigned long	vrsave; 
> + *};
> + */
> +#define PTRACE_GETTM_CVMXREGS	0x76
> +#define PTRACE_SETTM_CVMXREGS	0x77
> +
> +/* Miscellaneous registers */
> +#define PTRACE_GETMSCREGS	0x78
> +#define PTRACE_SETMSCREGS	0x79
> +
> +/*
> + * XXX: A note to application developers. The existing data layout
> + * of the above four ptrace requests can change when new registers
> + * are available for each category in forthcoming processors.
> + */
> +
>  #ifndef __ASSEMBLY__
>  
>  struct ppc_debug_info {
> diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
> index af064d2..e5dfd8e 100644
> --- a/arch/powerpc/kernel/process.c
> +++ b/arch/powerpc/kernel/process.c
> @@ -673,6 +673,30 @@ static inline void __switch_to_tm(struct task_struct *prev)
>  	}
>  }
>  
> +void flush_tmreg_to_thread(struct task_struct *tsk)
> +{
> +	/*
> + 	 * If task is not current, it should have been flushed
> + 	 * already to it's thread_struct during __switch_to().
> + 	 */
> +	if (tsk != current)
> +		return;
> +
> +	preempt_disable();
> +	if (tsk->thread.regs) {
> +		/* 
> + 		 * If we are still current, the TM state need to
> + 		 * be flushed to thread_struct as it will be still
> + 		 * present in the current cpu
> + 		 */
> +		if (MSR_TM_ACTIVE(tsk->thread.regs->msr)) {
> +			__switch_to_tm(tsk);
> +			tm_recheckpoint_new_task(tsk);
> +		}
> +	}
> +	preempt_enable();
> +}
> +
>  /*
>   * This is called if we are on the way out to userspace and the
>   * TIF_RESTORE_TM flag is set.  It checks if we need to reload
> diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
> index 2e3d2bf..cb4d5bf 100644
> --- a/arch/powerpc/kernel/ptrace.c
> +++ b/arch/powerpc/kernel/ptrace.c
> @@ -357,6 +357,17 @@ static int gpr_set(struct task_struct *target, const struct user_regset *regset,
>  	return ret;
>  }
>  
> +/*
> + * When any transaction is active, thread_struct->transact_fp holds
> + * the current running value of all FPR registers and thread_struct->
> + * fp_state hold the last checkpointed FPR state for the given
> + * transaction.
> + *
> + * struct data {
> + * 	u64	fpr[32];
> + * 	u64	fpscr;	
> + * };
> + */
>  static int fpr_get(struct task_struct *target, const struct user_regset *regset,
>  		   unsigned int pos, unsigned int count,
>  		   void *kbuf, void __user *ubuf)
> @@ -365,21 +376,41 @@ static int fpr_get(struct task_struct *target, const struct user_regset *regset,
>  	u64 buf[33];
>  	int i;
>  #endif
> -	flush_fp_to_thread(target);
> +	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
> +		flush_fp_to_thread(target);
> +		flush_altivec_to_thread(target);
> +		flush_tmreg_to_thread(target);
> +	} else {
> +		flush_fp_to_thread(target);
> +	}
>  
>  #ifdef CONFIG_VSX
>  	/* copy to local buffer then write that out */
> -	for (i = 0; i < 32 ; i++)
> -		buf[i] = target->thread.TS_FPR(i);
> -	buf[32] = target->thread.fp_state.fpscr;
> +	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
> +		for (i = 0; i < 32 ; i++)
> +			buf[i] = target->thread.TS_TRANS_FPR(i);
> +		buf[32] = target->thread.transact_fp.fpscr;
> +	} else {
> +		for (i = 0; i < 32 ; i++)
> +			buf[i] = target->thread.TS_FPR(i);
> +		buf[32] = target->thread.fp_state.fpscr;
> +	}
>  	return user_regset_copyout(&pos, &count, &kbuf, &ubuf, buf, 0, -1);
>  
>  #else
> -	BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
> -		     offsetof(struct thread_fp_state, fpr[32][0]));
> +	if (MSR_TM_ACTIVE(tsk->thread.regs->msr)) {
> +		BUILD_BUG_ON(offsetof(struct transact_fp, fpscr) !=
> +				offsetof(struct transact_fp, fpr[32][0]));
>  
> -	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +				   &target->thread.transact_fp, 0, -1);
> +	} esle {
> +		BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
> +			     offsetof(struct thread_fp_state, fpr[32][0]));
> +
> +		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
>  				   &target->thread.fp_state, 0, -1);
> +	}
>  #endif
>  }
>  
> @@ -391,23 +422,44 @@ static int fpr_set(struct task_struct *target, const struct user_regset *regset,
>  	u64 buf[33];
>  	int i;
>  #endif
> -	flush_fp_to_thread(target);
> +	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
> +		flush_fp_to_thread(target);
> +		flush_altivec_to_thread(target);
> +		flush_tmreg_to_thread(target);
> +	} else {
> +		flush_fp_to_thread(target);
> +	}
>  
>  #ifdef CONFIG_VSX
>  	/* copy to local buffer then write that out */
>  	i = user_regset_copyin(&pos, &count, &kbuf, &ubuf, buf, 0, -1);
>  	if (i)
>  		return i;
> -	for (i = 0; i < 32 ; i++)
> -		target->thread.TS_FPR(i) = buf[i];
> -	target->thread.fp_state.fpscr = buf[32];
> +	for (i = 0; i < 32 ; i++) {
> +		if (MSR_TM_ACTIVE(target->thread.regs->msr))
> +			target->thread.TS_TRANS_FPR(i) = buf[i];
> +		else
> +			target->thread.TS_FPR(i) = buf[i];
> +	}
> +	if (MSR_TM_ACTIVE(target->thread.regs->msr))
> +		target->thread.transact_fp.fpscr = buf[32];
> +	else
> +		target->thread.fp_state.fpscr = buf[32];
>  	return 0;
>  #else
> -	BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
> -		     offsetof(struct thread_fp_state, fpr[32][0]));
> +	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
> +		BUILD_BUG_ON(offsetof(struct transact_fp, fpscr) !=
> +			     offsetof(struct transact_fp, fpr[32][0]));
>  
> -	return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> -				  &target->thread.fp_state, 0, -1);
> +		return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +					  &target->thread.transact_fp, 0, -1);
> +	} else {
> +		BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
> +			     offsetof(struct thread_fp_state, fpr[32][0]));
> +
> +		return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +				&target->thread.fp_state, 0, -1);
> +	}
>  #endif
>  }
>  
> @@ -432,20 +484,44 @@ static int vr_active(struct task_struct *target,
>  	return target->thread.used_vr ? regset->n : 0;
>  }
>  
> +/*
> + * When any transaction is active, thread_struct->transact_vr holds
> + * the current running value of all VMX registers and thread_struct->
> + * vr_state hold the last checkpointed VMX state for the given
> + * transaction.
> + *
> + * struct data {
> + * 	vector128	vr[32];
> + * 	vector128	vscr;
> + * 	vector128	vrsave;
> + * };
> + */
>  static int vr_get(struct task_struct *target, const struct user_regset *regset,
>  		  unsigned int pos, unsigned int count,
>  		  void *kbuf, void __user *ubuf)
>  {
>  	int ret;
> +	struct thread_vr_state *addr;
>  
> -	flush_altivec_to_thread(target);
> +	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
> +		flush_fp_to_thread(target);
> +		flush_altivec_to_thread(target);
> +		flush_tmreg_to_thread(target);
> +	} else {
> +		flush_altivec_to_thread(target);
> +	}
>  
>  	BUILD_BUG_ON(offsetof(struct thread_vr_state, vscr) !=
>  		     offsetof(struct thread_vr_state, vr[32]));
>  
> +	if (MSR_TM_ACTIVE(target->thread.regs->msr))
> +		addr = &target->thread.transact_vr;
> +	else
> +		addr = &target->thread.vr_state;
> +
>  	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> -				  &target->thread.vr_state, 0,
> -				  33 * sizeof(vector128));
> +				addr, 0, 33 * sizeof(vector128));
> +
>  	if (!ret) {
>  		/*
>  		 * Copy out only the low-order word of vrsave.
> @@ -455,11 +531,14 @@ static int vr_get(struct task_struct *target, const struct user_regset *regset,
>  			u32 word;
>  		} vrsave;
>  		memset(&vrsave, 0, sizeof(vrsave));
> -		vrsave.word = target->thread.vrsave;
> +		if (MSR_TM_ACTIVE(target->thread.regs->msr))
> +			vrsave.word = target->thread.transact_vrsave;
> +		else
> +			vrsave.word = target->thread.vrsave;
> +
>  		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, &vrsave,
>  					  33 * sizeof(vector128), -1);
>  	}
> -
>  	return ret;
>  }
>  
> @@ -467,16 +546,27 @@ static int vr_set(struct task_struct *target, const struct user_regset *regset,
>  		  unsigned int pos, unsigned int count,
>  		  const void *kbuf, const void __user *ubuf)
>  {
> +	struct thread_vr_state *addr;
>  	int ret;
>  
> -	flush_altivec_to_thread(target);
> +	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
> +		flush_fp_to_thread(target);
> +		flush_altivec_to_thread(target);
> +		flush_tmreg_to_thread(target);
> +	} else {
> +		flush_altivec_to_thread(target);
> +	}
>  
>  	BUILD_BUG_ON(offsetof(struct thread_vr_state, vscr) !=
>  		     offsetof(struct thread_vr_state, vr[32]));
>  
> +	if (MSR_TM_ACTIVE(target->thread.regs->msr))
> +		addr = &target->thread.transact_vr;
> +	else
> +		addr = &target->thread.vr_state;
>  	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> -				 &target->thread.vr_state, 0,
> -				 33 * sizeof(vector128));
> +			addr, 0, 33 * sizeof(vector128));
> +
>  	if (!ret && count > 0) {
>  		/*
>  		 * We use only the first word of vrsave.
> @@ -486,13 +576,21 @@ static int vr_set(struct task_struct *target, const struct user_regset *regset,
>  			u32 word;
>  		} vrsave;
>  		memset(&vrsave, 0, sizeof(vrsave));
> -		vrsave.word = target->thread.vrsave;
> +
> +		if (MSR_TM_ACTIVE(target->thread.regs->msr))
> +			vrsave.word = target->thread.transact_vrsave;
> +		else
> +			vrsave.word = target->thread.vrsave;
> +
>  		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &vrsave,
>  					 33 * sizeof(vector128), -1);
> -		if (!ret)
> -			target->thread.vrsave = vrsave.word;
> +		if (!ret) {
> +			if (MSR_TM_ACTIVE(target->thread.regs->msr))
> +				target->thread.transact_vrsave = vrsave.word;
> +			else
> +				target->thread.vrsave = vrsave.word;
> +		}
>  	}
> -
>  	return ret;
>  }
>  #endif /* CONFIG_ALTIVEC */
> @@ -613,6 +711,417 @@ static int evr_set(struct task_struct *target, const struct user_regset *regset,
>  }
>  #endif /* CONFIG_SPE */
>  
> +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> +
> +/*
> + *  Transactional SPR
> + *
> + * struct {
> + * 	u64		tm_tfhar;
> + *	u64		tm_texasr;
> + *	u64		tm_tfiar;
> + *	unsigned long	tm_orig_msr;
> + * 	unsigned long	tm_tar;
> + *	unsigned long	tm_ppr;
> + *	unsigned long	tm_dscr;
> + * };
> + */
> +static int tm_spr_get(struct task_struct *target, const struct user_regset *regset,
> +		   unsigned int pos, unsigned int count,
> +		   void *kbuf, void __user *ubuf)
> +{
> +	int ret;
> +
> +	flush_fp_to_thread(target);
> +	flush_altivec_to_thread(target);
> +	flush_tmreg_to_thread(target);
> +
> +	/* TFHAR register */
> +	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +			&target->thread.tm_tfhar, 0, sizeof(u64));
> +
> +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_tfhar) +
> +			sizeof(u64) != offsetof(struct thread_struct, tm_texasr));
> +
> +	/* TEXASR register */
> +	if (!ret)
> +		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +			&target->thread.tm_texasr, sizeof(u64), 2 * sizeof(u64));
> +
> +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_texasr) +
> +			sizeof(u64) != offsetof(struct thread_struct, tm_tfiar));
> +
> +	/* TFIAR register */
> +	if (!ret)
> +		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +			&target->thread.tm_tfiar, 2 * sizeof(u64), 3 * sizeof(u64));
> +
> +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_tfiar) +
> +			sizeof(u64) != offsetof(struct thread_struct, tm_orig_msr));
> +
> +	/* TM checkpointed original MSR */
> +	if (!ret)
> +		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +			&target->thread.tm_orig_msr, 3 * sizeof(u64),
> +				3 * sizeof(u64) + sizeof(unsigned long));
> +
> +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_orig_msr) +
> +			sizeof(unsigned long) + sizeof(struct pt_regs)
> +				!= offsetof(struct thread_struct, tm_tar));
> +
> +	/* TM checkpointed TAR register */
> +	if (!ret)
> +		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +			&target->thread.tm_tar, 3 * sizeof(u64) +
> +				sizeof(unsigned long) , 3 * sizeof(u64) +
> +					2 * sizeof(unsigned long));
> +
> +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_tar)
> +			+ sizeof(unsigned long) !=
> +				offsetof(struct thread_struct, tm_ppr));
> +
> +	/* TM checkpointed PPR register */
> +	if (!ret)
> +		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, 
> +				&target->thread.tm_ppr, 3 * sizeof(u64) +
> +					2 * sizeof(unsigned long), 3 * sizeof(u64) +
> +						3 * sizeof(unsigned long));
> +
> +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_ppr) +
> +			sizeof(unsigned long) !=
> +				offsetof(struct thread_struct, tm_dscr));
> +
> +	/* TM checkpointed DSCR register */
> +	if (!ret)
> +		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +			&target->thread.tm_dscr, 3 * sizeof(u64)
> +				+ 3 * sizeof(unsigned long), 3 * sizeof(u64)
> +						+ 4 * sizeof(unsigned long));
> +	return ret;
> +}
> +
> +static int tm_spr_set(struct task_struct *target, const struct user_regset *regset,
> +		   unsigned int pos, unsigned int count,
> +		   const void *kbuf, const void __user *ubuf)
> +{
> +	int ret;
> +
> +	flush_fp_to_thread(target);
> +	flush_altivec_to_thread(target);
> +	flush_tmreg_to_thread(target);
> +
> +	/* TFHAR register */
> +	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +				&target->thread.tm_tfhar, 0, sizeof(u64));
> +
> +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_tfhar)
> +		+ sizeof(u64) != offsetof(struct thread_struct, tm_texasr));
> +
> +	/* TEXASR register */
> +	if (!ret)
> +		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +			&target->thread.tm_texasr, sizeof(u64), 2 * sizeof(u64));
> +
> +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_texasr)
> +		+ sizeof(u64) != offsetof(struct thread_struct, tm_tfiar));
> +
> +	/* TFIAR register */
> +	if (!ret)
> +		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +			&target->thread.tm_tfiar, 2 * sizeof(u64), 3 * sizeof(u64));
> +
> +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_tfiar)
> +		+ sizeof(u64) != offsetof(struct thread_struct, tm_orig_msr));
> +
> +	/* TM checkpointed orig MSR */
> +	if (!ret)
> +		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +			&target->thread.tm_orig_msr, 3 * sizeof(u64),
> +				3 * sizeof(u64) + sizeof(unsigned long));
> +	
> +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_orig_msr)
> +		+ sizeof(unsigned long) + sizeof(struct pt_regs) !=
> +			offsetof(struct thread_struct, tm_tar));
> +
> +	/* TM checkpointed TAR register */
> +	if (!ret)
> +		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +			&target->thread.tm_tar, 3 * sizeof(u64) +
> +				sizeof(unsigned long), 3 * sizeof(u64) +
> +					2 * sizeof(unsigned long));
> +
> +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_tar)
> +			+ sizeof(unsigned long) != offsetof(struct thread_struct, tm_ppr));
> +
> +	/* TM checkpointed PPR register */
> +	if (!ret)
> +		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +				&target->thread.tm_ppr, 3 * sizeof(u64)
> +					+ 2 * sizeof(unsigned long), 3 * sizeof(u64)
> +					+ 3 * sizeof(unsigned long));
> +
> +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_ppr) +
> +			sizeof(unsigned long) !=
> +				offsetof(struct thread_struct, tm_dscr));
> +
> +	/* TM checkpointed DSCR register */
> +	if (!ret)
> +		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +				&target->thread.tm_dscr,
> +					3 * sizeof(u64) + 3 * sizeof(unsigned long),
> +					3 * sizeof(u64) + 4 * sizeof(unsigned long));
> +
> +	return ret;
> +}
> +
> +/*
> + * Checkpointed GPR
> + *
> + * struct data {
> + * 	struct pt_regs ckpt_regs;
> + * };
> + */
> +static int tm_cgpr_get(struct task_struct *target, const struct user_regset *regset,
> +		   unsigned int pos, unsigned int count,
> +		   void *kbuf, void __user *ubuf)
> +{
> +	int ret;
> +
> +	flush_fp_to_thread(target);
> +	flush_altivec_to_thread(target);
> +	flush_tmreg_to_thread(target);
> +	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +			&target->thread.ckpt_regs, 0,
> +				sizeof(struct pt_regs));
> +	return ret;
> +}
> +
> +static int tm_cgpr_set(struct task_struct *target, const struct user_regset *regset,
> +		   unsigned int pos, unsigned int count,
> +		   const void *kbuf, const void __user *ubuf)
> +{
> +	int ret;
> +
> +	flush_fp_to_thread(target);
> +	flush_altivec_to_thread(target);
> +	flush_tmreg_to_thread(target);
> +	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +					&target->thread.ckpt_regs, 0,
> +						sizeof(struct pt_regs));
> +	return ret;
> +}
> +
> +/*
> + * Checkpointed FPR
> + *
> + * struct data {
> + * 	u64	fpr[32];
> + * 	u64	fpscr;
> + * };
> + */
> +static int tm_cfpr_get(struct task_struct *target, const struct user_regset *regset,
> +		   unsigned int pos, unsigned int count,
> +		   void *kbuf, void __user *ubuf)
> +{
> +#ifdef CONFIG_VSX
> +	u64 buf[33];
> +	int i;
> +#endif
> +	flush_fp_to_thread(target);
> +	flush_altivec_to_thread(target);
> +	flush_tmreg_to_thread(target);
> +
> +#ifdef CONFIG_VSX
> +	/* copy to local buffer then write that out */
> +	for (i = 0; i < 32 ; i++)
> +		buf[i] = target->thread.TS_FPR(i);
> +	buf[32] = target->thread.fp_state.fpscr;
> +	return user_regset_copyout(&pos, &count, &kbuf, &ubuf, buf, 0, -1);
> +
> +#else
> +	BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
> +		offsetof(struct thread_fp_state, fpr[32][0]));
> +
> +	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +			&target->thread.thread_fp_state, 0, -1);
> +#endif
> +}
> +
> +static int tm_cfpr_set(struct task_struct *target, const struct user_regset *regset,
> +		   unsigned int pos, unsigned int count,
> +		   const void *kbuf, const void __user *ubuf)
> +{
> +#ifdef CONFIG_VSX
> +	u64 buf[33];
> +	int i;
> +#endif
> +	flush_fp_to_thread(target);
> +	flush_altivec_to_thread(target);
> +	flush_tmreg_to_thread(target);
> +
> +#ifdef CONFIG_VSX
> +	/* copy to local buffer then write that out */
> +	i = user_regset_copyin(&pos, &count, &kbuf, &ubuf, buf, 0, -1);
> +	if (i)
> +		return i;
> +	for (i = 0; i < 32 ; i++)
> +		target->thread.TS_FPR(i) = buf[i];
> +	target->thread.fp_state.fpscr = buf[32];
> +        return 0;
> +#else
> +	BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
> +		      offsetof(struct thread_fp_state, fpr[32][0]));
> +
> +	return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +				&target->thread.fp_state, 0, -1);
> +#endif
> +}
> +
> +/*
> + * Checkpointed VMX
> + *
> + * struct data {
> + * 	vector128	vr[32];
> + * 	vector128	vscr;
> + * 	vector128	vrsave;	
> + *};
> + */
> +static int tm_cvmx_get(struct task_struct *target, const struct user_regset *regset,
> +		   unsigned int pos, unsigned int count,
> +		   void *kbuf, void __user *ubuf)
> +{
> +	int ret;
> +
> +	flush_fp_to_thread(target);
> +	flush_altivec_to_thread(target);
> +	flush_tmreg_to_thread(target);
> +
> +	BUILD_BUG_ON(offsetof(struct thread_vr_state, vscr) !=
> +		     offsetof(struct thread_vr_state, vr[32]));
> +
> +	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +				  &target->thread.vr_state, 0,
> +				  33 * sizeof(vector128));
> +	if (!ret) {
> +		/*
> +		 * Copy out only the low-order word of vrsave.
> +		 */
> +		union {
> +			elf_vrreg_t reg;
> +			u32 word;
> +		} vrsave;
> +		memset(&vrsave, 0, sizeof(vrsave));
> +		vrsave.word = target->thread.vrsave;
> +		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, &vrsave,
> +					  33 * sizeof(vector128), -1);
> +	}
> +	return ret;
> +}
> +
> +static int tm_cvmx_set(struct task_struct *target, const struct user_regset *regset,
> +		   unsigned int pos, unsigned int count,
> +		   const void *kbuf, const void __user *ubuf)
> +{
> +	int ret;
> +
> +	flush_fp_to_thread(target);
> +	flush_altivec_to_thread(target);
> +	flush_tmreg_to_thread(target);
> +
> +	BUILD_BUG_ON(offsetof(struct thread_vr_state, vscr) !=
> +		offsetof(struct thread_vr_state, vr[32]));
> +
> +	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +				 &target->thread.vr_state, 0,
> +				 33 * sizeof(vector128));
> +	if (!ret && count > 0) {
> +		/*
> +		 * We use only the first word of vrsave.
> +		 */
> +		union {
> +			elf_vrreg_t reg;
> +			u32 word;
> +		} vrsave;
> +		memset(&vrsave, 0, sizeof(vrsave));
> +		vrsave.word = target->thread.vrsave;
> +		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &vrsave,
> +					 33 * sizeof(vector128), -1);
> +		if (!ret)
> +			target->thread.vrsave = vrsave.word;
> +	}
> +	return ret;
> +}
> +#endif	/* CONFIG_PPC_TRANSACTIONAL_MEM */
> +
> +/*
> + * Miscellaneous Registers
> + *
> + * struct {
> + * 	unsigned long dscr;
> + *	unsigned long ppr;
> + * 	unsigned long tar;
> + * };
> + */
> +static int misc_get(struct task_struct *target, const struct user_regset *regset,
> +		   unsigned int pos, unsigned int count,
> +		   void *kbuf, void __user *ubuf)
> +{
> +	int ret;
> +
> +	/* DSCR register */
> +	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +					&target->thread.dscr, 0,
> +					sizeof(unsigned long));
> +
> +	BUILD_BUG_ON(offsetof(struct thread_struct, dscr) + sizeof(unsigned long) +
> +		     		sizeof(unsigned long) != offsetof(struct thread_struct, ppr));
> +
> +	/* PPR register */
> +	if (!ret)
> +		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +					  &target->thread.ppr, sizeof(unsigned long),
> +					  2 * sizeof(unsigned long));
> +
> +	BUILD_BUG_ON(offsetof(struct thread_struct, ppr) + sizeof(unsigned long)
> +		     			!= offsetof(struct thread_struct, tar));
> +	/* TAR register */
> +	if (!ret)
> +		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> +					  &target->thread.tar, 2 * sizeof(unsigned long),
> +					  3 * sizeof(unsigned long));
> +	return ret;
> +}
> +
> +static int misc_set(struct task_struct *target, const struct user_regset *regset,
> +		   unsigned int pos, unsigned int count,
> +		   const void *kbuf, const void __user *ubuf)
> +{
> +	int ret;
> +
> +	/* DSCR register */
> +	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +					&target->thread.dscr, 0,
> +					sizeof(unsigned long));
> +
> +	BUILD_BUG_ON(offsetof(struct thread_struct, dscr) + sizeof(unsigned long) +
> +		     	sizeof(unsigned long) != offsetof(struct thread_struct, ppr));
> +
> +	/* PPR register */
> +	if (!ret)
> +		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +						&target->thread.ppr, sizeof(unsigned long),
> +						2 * sizeof(unsigned long));
> +
> +	BUILD_BUG_ON(offsetof(struct thread_struct, ppr) + sizeof(unsigned long)
> +						!= offsetof(struct thread_struct, tar));
> +
> +	/* TAR register */
> +	if (!ret)
> +		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +						&target->thread.tar, 2 * sizeof(unsigned long),
> +						3 * sizeof(unsigned long));
> +	return ret;
> +}
>  
>  /*
>   * These are our native regset flavors.
> @@ -629,6 +1138,13 @@ enum powerpc_regset {
>  #ifdef CONFIG_SPE
>  	REGSET_SPE,
>  #endif
> +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> +	REGSET_TM_SPR,		/* TM generic SPR */
> +	REGSET_TM_CGPR,		/* TM checkpointed GPR */
> +	REGSET_TM_CFPR,		/* TM checkpointed FPR */
> +	REGSET_TM_CVMX,		/* TM checkpointed VMX */
> +#endif
> +	REGSET_MISC		/* Miscellaneous */
>  };
>  
>  static const struct user_regset native_regsets[] = {
> @@ -663,6 +1179,33 @@ static const struct user_regset native_regsets[] = {
>  		.active = evr_active, .get = evr_get, .set = evr_set
>  	},
>  #endif
> +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> +	[REGSET_TM_SPR] = {
> +		.core_note_type = NT_PPC_TM_SPR, .n = 7,
> +		.size = sizeof(u64), .align = sizeof(u64),
> +		.get = tm_spr_get, .set = tm_spr_set
> +	},
> +	[REGSET_TM_CGPR] = {
> +		.core_note_type = NT_PPC_TM_CGPR, .n = 14,
> +		.size = sizeof(u64), .align = sizeof(u64),
> +		.get = tm_cgpr_get, .set = tm_cgpr_set
> +	},
> +	[REGSET_TM_CFPR] = {
> +		.core_note_type = NT_PPC_TM_CFPR, .n = ELF_NFPREG,
> +		.size = sizeof(double), .align = sizeof(double),
> +		.get = tm_cfpr_get, .set = tm_cfpr_set
> +	},
> +	[REGSET_TM_CVMX] = {
> +		.core_note_type = NT_PPC_TM_CVMX, .n = 34,
> +		.size = sizeof(vector128), .align = sizeof(vector128),
> +		.get = tm_cvmx_get, .set = tm_cvmx_set
> +	},
> +#endif
> +	[REGSET_MISC] = {
> +		.core_note_type = NT_PPC_MISC, .n = 3,
> +		.size = sizeof(u64), .align = sizeof(u64),
> +		.get = misc_get, .set = misc_set
> +	},
>  };
>  
>  static const struct user_regset_view user_ppc_native_view = {
> @@ -831,6 +1374,33 @@ static const struct user_regset compat_regsets[] = {
>  		.active = evr_active, .get = evr_get, .set = evr_set
>  	},
>  #endif
> +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> +	[REGSET_TM_SPR] = {
> +		.core_note_type = NT_PPC_TM_SPR, .n = 7,
> +		.size = sizeof(u64), .align = sizeof(u64),
> +		.get = tm_spr_get, .set = tm_spr_set
> +	},
> +	[REGSET_TM_CGPR] = {
> +		.core_note_type = NT_PPC_TM_CGPR, .n = 14,
> +		.size = sizeof(u64), .align = sizeof(u64),
> +		.get = tm_cgpr_get, .set = tm_cgpr_set
> +	},
> +	[REGSET_TM_CFPR] = {
> +		.core_note_type = NT_PPC_TM_CFPR, .n = ELF_NFPREG,
> +		.size = sizeof(double), .align = sizeof(double),
> +		.get = tm_cfpr_get, .set = tm_cfpr_set
> +	},
> +	[REGSET_TM_CVMX] = {
> +		.core_note_type = NT_PPC_TM_CVMX, .n = 34,
> +		.size = sizeof(vector128), .align = sizeof(vector128),
> +		.get = tm_cvmx_get, .set = tm_cvmx_set
> +	},
> +#endif
> +	[REGSET_MISC] = {
> +		.core_note_type = NT_PPC_MISC, .n = 3,
> +		.size = sizeof(u64), .align = sizeof(u64),
> +		.get = misc_get, .set = misc_set
> +	},
>  };
>  
>  static const struct user_regset_view user_ppc_compat_view = {
> @@ -1754,7 +2324,41 @@ long arch_ptrace(struct task_struct *child, long request,
>  					     REGSET_SPE, 0, 35 * sizeof(u32),
>  					     datavp);
>  #endif
> +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> +	case PTRACE_GETTM_SPRREGS:
> +		return copy_regset_to_user(child, &user_ppc_native_view,
> +					   REGSET_TM_SPR, 0, 6 * sizeof(u64) + sizeof(unsigned long), datavp);
> +	case PTRACE_SETTM_SPRREGS:
> +		return copy_regset_from_user(child, &user_ppc_native_view,
> +					   REGSET_TM_SPR, 0, 6 * sizeof(u64) + sizeof(unsigned long), datavp);
> +	case PTRACE_GETTM_CGPRREGS:
> +		return copy_regset_to_user(child, &user_ppc_native_view,
> +					   REGSET_TM_CGPR, 0, sizeof(struct pt_regs), datavp);
> +	case PTRACE_SETTM_CGPRREGS:
> +		return copy_regset_from_user(child, &user_ppc_native_view,
> +					   REGSET_TM_CGPR, 0, sizeof(struct pt_regs), datavp);
> +	case PTRACE_GETTM_CFPRREGS:
> +		return copy_regset_to_user(child, &user_ppc_native_view,
> +					   REGSET_TM_CFPR, 0, sizeof(elf_fpregset_t), datavp);
> +	case PTRACE_SETTM_CFPRREGS:
> +		return copy_regset_from_user(child, &user_ppc_native_view,
> +					   REGSET_TM_CFPR, 0, sizeof(elf_fpregset_t), datavp);
> +	case PTRACE_GETTM_CVMXREGS:
> +		return copy_regset_to_user(child, &user_ppc_native_view,
> +					   REGSET_TM_CVMX, 0, (33 * sizeof(vector128) + sizeof(u32)), datavp);
> +	case PTRACE_SETTM_CVMXREGS:
> +		return copy_regset_from_user(child, &user_ppc_native_view,
> +					   REGSET_TM_CVMX, 0, (33 * sizeof(vector128) + sizeof(u32)), datavp);
> +#endif /* CONFIG_PPC_TRANSACTIONAL_MEM */
>  
> +	case PTRACE_GETMSCREGS:
> +		return copy_regset_to_user(child, &user_ppc_native_view,
> +					   REGSET_MISC, 0, 3 * sizeof(u64),
> +					   datavp);
> +	case PTRACE_SETMSCREGS:
> +		return copy_regset_from_user(child, &user_ppc_native_view,
> +					   REGSET_MISC, 0, 3 * sizeof(u64),
> +					   datavp);
>  	default:
>  		ret = ptrace_request(child, request, addr, data);
>  		break;
> diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
> index ef6103b..13090e3 100644
> --- a/include/uapi/linux/elf.h
> +++ b/include/uapi/linux/elf.h
> @@ -379,6 +379,11 @@ typedef struct elf64_shdr {
>  #define NT_PPC_VMX	0x100		/* PowerPC Altivec/VMX registers */
>  #define NT_PPC_SPE	0x101		/* PowerPC SPE/EVR registers */
>  #define NT_PPC_VSX	0x102		/* PowerPC VSX registers */
> +#define NT_PPC_TM_SPR	0x103		/* PowerPC transactional memory specific registers */
> +#define NT_PPC_TM_CGPR	0x104		/* PowerpC transactional memory checkpointed GPR */
> +#define NT_PPC_TM_CFPR	0x105		/* PowerPC transactional memory checkpointed FPR */
> +#define NT_PPC_TM_CVMX	0x106		/* PowerPC transactional memory checkpointed VMX */
> +#define NT_PPC_MISC	0x107		/* PowerPC miscellaneous registers */
>  #define NT_386_TLS	0x200		/* i386 TLS slots (struct user_desc) */
>  #define NT_386_IOPERM	0x201		/* x86 io permission bitmap (1=deny) */
>  #define NT_X86_XSTATE	0x202		/* x86 extended state using xsave */
> -- 
> 1.7.11.7
> 

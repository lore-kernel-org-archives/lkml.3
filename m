Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750834AbaJIFEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 01:04:51 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:34235 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaJIFEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 01:04:44 -0400
Message-ID: <54361763.70603@linux.vnet.ibm.com>
Date: Thu, 09 Oct 2014 10:34:35 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        mikey@neuling.org, james.hogan@imgtec.com, avagin@openvz.org,
        Paul.Clothier@imgtec.com, palves@redhat.com, oleg@redhat.com,
        dhowells@redhat.com, davej@redhat.com, davem@davemloft.net
Subject: Re: [PATCH V3 2/3] powerpc, ptrace: Enable support for transactional
 memory register sets
References: <1400858138-3939-1-git-send-email-khandual@linux.vnet.ibm.com> <1400858138-3939-3-git-send-email-khandual@linux.vnet.ibm.com> <20140827213514.GA11489@us.ibm.com>
In-Reply-To: <20140827213514.GA11489@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100905-0017-0000-0000-0000018DFD08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2014 03:05 AM, Sukadev Bhattiprolu wrote:
> Anshuman Khandual [khandual@linux.vnet.ibm.com] wrote:
> | This patch enables get and set of transactional memory related register
> | sets through PTRACE_GETREGSET/PTRACE_SETREGSET interface by implementing
> | four new powerpc specific register sets i.e REGSET_TM_SPR, REGSET_TM_CGPR,
> | REGSET_TM_CFPR, REGSET_CVMX support corresponding to these following new
> | ELF core note types added previously in this regard.
> | 
> | 	(1) NT_PPC_TM_SPR
> | 	(2) NT_PPC_TM_CGPR
> | 	(3) NT_PPC_TM_CFPR
> | 	(4) NT_PPC_TM_CVMX
> | 
> | Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> | ---
> |  arch/powerpc/include/asm/switch_to.h |   8 +
> |  arch/powerpc/kernel/process.c        |  24 ++
> |  arch/powerpc/kernel/ptrace.c         | 792 +++++++++++++++++++++++++++++++++--
> |  3 files changed, 795 insertions(+), 29 deletions(-)
> | 
> | diff --git a/arch/powerpc/include/asm/switch_to.h b/arch/powerpc/include/asm/switch_to.h
> | index 0e83e7d..2737f46 100644
> | --- a/arch/powerpc/include/asm/switch_to.h
> | +++ b/arch/powerpc/include/asm/switch_to.h
> | @@ -80,6 +80,14 @@ static inline void flush_spe_to_thread(struct task_struct *t)
> |  }
> |  #endif
> |  
> | +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> | +extern void flush_tmregs_to_thread(struct task_struct *);
> | +#else
> | +static inline void flush_tmregs_to_thread(struct task_struct *t)
> | +{
> | +}
> | +#endif /* CONFIG_PPC_TRANSACTIONAL_MEM */
> | +
> |  static inline void clear_task_ebb(struct task_struct *t)
> |  {
> |  #ifdef CONFIG_PPC_BOOK3S_64
> | diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
> | index 31d0215..e247898 100644
> | --- a/arch/powerpc/kernel/process.c
> | +++ b/arch/powerpc/kernel/process.c
> | @@ -695,6 +695,30 @@ static inline void __switch_to_tm(struct task_struct *prev)
> |  	}
> |  }
> |  
> | +void flush_tmregs_to_thread(struct task_struct *tsk)
> | +{
> | +	/*
> | +	 * If task is not current, it should have been flushed
> | +	 * already to it's thread_struct during __switch_to().
> | +	 */
> | +	if (tsk != current)
> | +		return;
> | +
> | +	preempt_disable();
> | +	if (tsk->thread.regs) {
> | +		/*
> | +		 * If we are still current, the TM state need to
> | +		 * be flushed to thread_struct as it will be still
> | +		 * present in the current cpu.
> | +		 */
> | +		if (MSR_TM_ACTIVE(tsk->thread.regs->msr)) {
> | +			__switch_to_tm(tsk);
> | +			tm_recheckpoint_new_task(tsk);
> | +		}
> | +	}
> | +	preempt_enable();
> | +}
> | +
> |  /*
> |   * This is called if we are on the way out to userspace and the
> |   * TIF_RESTORE_TM flag is set.  It checks if we need to reload
> | diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
> | index 2e3d2bf..17642ef 100644
> | --- a/arch/powerpc/kernel/ptrace.c
> | +++ b/arch/powerpc/kernel/ptrace.c
> | @@ -357,6 +357,17 @@ static int gpr_set(struct task_struct *target, const struct user_regset *regset,
> |  	return ret;
> |  }
> |  
> | +/*
> | + * When any transaction is active, "thread_struct->transact_fp" holds
> | + * the current running value of all FPR registers and "thread_struct->
> | + * fp_state" holds the last checkpointed FPR registers state for the
> | + * current transaction.
> | + *
> | + * struct data {
> | + * 	u64	fpr[32];
> | + * 	u64	fpscr;
> | + * };
> | + */
> 
> Maybe a reference to 'struct thread_fp_state' in the comments will help ?

Okay, will try to add.

> 
> 
> |  static int fpr_get(struct task_struct *target, const struct user_regset *regset,
> |  		   unsigned int pos, unsigned int count,
> |  		   void *kbuf, void __user *ubuf)
> | @@ -365,21 +376,41 @@ static int fpr_get(struct task_struct *target, const struct user_regset *regset,
> |  	u64 buf[33];
> |  	int i;
> |  #endif
> | -	flush_fp_to_thread(target);
> | +	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
> | +		flush_fp_to_thread(target);
> | +		flush_altivec_to_thread(target);
> | +		flush_tmregs_to_thread(target);
> | +	} else {
> | +		flush_fp_to_thread(target);
> | +	}
> 
> flush_fp_to_thread(target) is uncondtional - so could be outside
> the if and else blocks ?

yes

> 
> |  
> |  #ifdef CONFIG_VSX
> |  	/* copy to local buffer then write that out */
> | -	for (i = 0; i < 32 ; i++)
> | -		buf[i] = target->thread.TS_FPR(i);
> | -	buf[32] = target->thread.fp_state.fpscr;
> | +	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
> | +		for (i = 0; i < 32 ; i++)
> | +			buf[i] = target->thread.TS_TRANS_FPR(i);
> | +		buf[32] = target->thread.transact_fp.fpscr;
> | +	} else {
> | +		for (i = 0; i < 32 ; i++)
> | +			buf[i] = target->thread.TS_FPR(i);
> | +		buf[32] = target->thread.fp_state.fpscr;
> | +	}
> |  	return user_regset_copyout(&pos, &count, &kbuf, &ubuf, buf, 0, -1);
> |  
> |  #else
> | -	BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
> | -		     offsetof(struct thread_fp_state, fpr[32][0]));
> | +	if (MSR_TM_ACTIVE(tsk->thread.regs->msr)) {
> | +		BUILD_BUG_ON(offsetof(struct transact_fp, fpscr) !=
> | +				offsetof(struct transact_fp, fpr[32][0]));
> 
> Is MSR_TM_ACTIVE() a run time check or compile time ?

Its a run time check.

> ie is there a reason to move the compile time check into the if block ?

Have cleaned up all of these.

> 
> |  
> | -	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> | +		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> | +				   &target->thread.transact_fp, 0, -1);
> | +	} esle {
> | +		BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
> | +			     offsetof(struct thread_fp_state, fpr[32][0]));
> | +
> | +		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> |  				   &target->thread.fp_state, 0, -1);
> | +	}
> |  #endif
> |  }
> |  
> | @@ -391,23 +422,44 @@ static int fpr_set(struct task_struct *target, const struct user_regset *regset,
> |  	u64 buf[33];
> |  	int i;
> |  #endif
> | -	flush_fp_to_thread(target);
> | +	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
> | +		flush_fp_to_thread(target);
> | +		flush_altivec_to_thread(target);
> | +		flush_tmregs_to_thread(target);
> | +	} else {
> | +		flush_fp_to_thread(target);
> | +	}
> |  
> 
> As mentioned above, flush_fp_to_thread() could be outside the if block.

sure

> |  #ifdef CONFIG_VSX
> |  	/* copy to local buffer then write that out */
> |  	i = user_regset_copyin(&pos, &count, &kbuf, &ubuf, buf, 0, -1);
> |  	if (i)
> |  		return i;
> | -	for (i = 0; i < 32 ; i++)
> | -		target->thread.TS_FPR(i) = buf[i];
> | -	target->thread.fp_state.fpscr = buf[32];
> | +	for (i = 0; i < 32 ; i++) {
> | +		if (MSR_TM_ACTIVE(target->thread.regs->msr))
> | +			target->thread.TS_TRANS_FPR(i) = buf[i];
> | +		else
> | +			target->thread.TS_FPR(i) = buf[i];
> | +	}
> | +	if (MSR_TM_ACTIVE(target->thread.regs->msr))
> | +		target->thread.transact_fp.fpscr = buf[32];
> | +	else
> | +		target->thread.fp_state.fpscr = buf[32];
> 
> I think this code is easier to read than the similar code above
> in fpr_get() where you have the 'for' loop in both if and else blocks.

Have done some modifications here.

> 
> |  	return 0;
> |  #else
> | -	BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
> | -		     offsetof(struct thread_fp_state, fpr[32][0]));
> | +	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
> | +		BUILD_BUG_ON(offsetof(struct transact_fp, fpscr) !=
> | +			     offsetof(struct transact_fp, fpr[32][0]));
> |  
> | -	return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> | -				  &target->thread.fp_state, 0, -1);
> | +		return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> | +					  &target->thread.transact_fp, 0, -1);
> | +	} else {
> | +		BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
> | +			     offsetof(struct thread_fp_state, fpr[32][0]));
> | +
> | +		return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> | +				&target->thread.fp_state, 0, -1);
> | +	}
> |  #endif
> |  }
> |  
> | @@ -432,20 +484,44 @@ static int vr_active(struct task_struct *target,
> |  	return target->thread.used_vr ? regset->n : 0;
> |  }
> |  
> | +/*
> | + * When any transaction is active, "thread_struct->transact_vr" holds
> | + * the current running value of all VMX registers and "thread_struct->
> | + * vr_state" holds the last checkpointed value of VMX registers for the
> | + * current transaction.
> | + *
> | + * struct data {
> | + * 	vector128	vr[32];
> | + * 	vector128	vscr;
> | + * 	vector128	vrsave;
> | + * };
> | + */
> |  static int vr_get(struct task_struct *target, const struct user_regset *regset,
> |  		  unsigned int pos, unsigned int count,
> |  		  void *kbuf, void __user *ubuf)
> |  {
> |  	int ret;
> | +	struct thread_vr_state *addr;
> |  
> | -	flush_altivec_to_thread(target);
> | +	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
> | +		flush_fp_to_thread(target);
> | +		flush_altivec_to_thread(target);
> 
> Is order of flush_fp_to_thread() and flush_altivec_to_thread()
> significant or can we call flush_altivec_to_thread() unconditionally
> outside the if block ?

We can move it outside the if block.

> | +		flush_tmregs_to_thread(target);
> | +	} else {
> | +		flush_altivec_to_thread(target);
> | +	}
> |  
> |  	BUILD_BUG_ON(offsetof(struct thread_vr_state, vscr) !=
> |  		     offsetof(struct thread_vr_state, vr[32]));
> |  
> | +	if (MSR_TM_ACTIVE(target->thread.regs->msr))
> | +		addr = &target->thread.transact_vr;
> | +	else
> | +		addr = &target->thread.vr_state;
> | +
> |  	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> | -				  &target->thread.vr_state, 0,
> | -				  33 * sizeof(vector128));
> | +				addr, 0, 33 * sizeof(vector128));
> | +
> |  	if (!ret) {
> |  		/*
> |  		 * Copy out only the low-order word of vrsave.
> | @@ -455,11 +531,14 @@ static int vr_get(struct task_struct *target, const struct user_regset *regset,
> |  			u32 word;
> |  		} vrsave;
> |  		memset(&vrsave, 0, sizeof(vrsave));
> | -		vrsave.word = target->thread.vrsave;
> | +		if (MSR_TM_ACTIVE(target->thread.regs->msr))
> | +			vrsave.word = target->thread.transact_vrsave;
> | +		else
> | +			vrsave.word = target->thread.vrsave;
> | +
> |  		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, &vrsave,
> |  					  33 * sizeof(vector128), -1);
> |  	}
> | -
> |  	return ret;
> |  }
> |  
> | @@ -467,16 +546,27 @@ static int vr_set(struct task_struct *target, const struct user_regset *regset,
> |  		  unsigned int pos, unsigned int count,
> |  		  const void *kbuf, const void __user *ubuf)
> |  {
> | +	struct thread_vr_state *addr;
> |  	int ret;
> |  
> | -	flush_altivec_to_thread(target);
> | +	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
> | +		flush_fp_to_thread(target);
> | +		flush_altivec_to_thread(target);
> | +		flush_tmregs_to_thread(target);
> | +	} else {
> | +		flush_altivec_to_thread(target);
> | +	}
> |  
> |  	BUILD_BUG_ON(offsetof(struct thread_vr_state, vscr) !=
> |  		     offsetof(struct thread_vr_state, vr[32]));
> |  
> | +	if (MSR_TM_ACTIVE(target->thread.regs->msr))
> | +		addr = &target->thread.transact_vr;
> | +	else
> | +		addr = &target->thread.vr_state;
> |  	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> | -				 &target->thread.vr_state, 0,
> | -				 33 * sizeof(vector128));
> | +			addr, 0, 33 * sizeof(vector128));
> | +
> |  	if (!ret && count > 0) {
> |  		/*
> |  		 * We use only the first word of vrsave.
> | @@ -486,13 +576,21 @@ static int vr_set(struct task_struct *target, const struct user_regset *regset,
> |  			u32 word;
> |  		} vrsave;
> |  		memset(&vrsave, 0, sizeof(vrsave));
> | -		vrsave.word = target->thread.vrsave;
> | +
> | +		if (MSR_TM_ACTIVE(target->thread.regs->msr))
> | +			vrsave.word = target->thread.transact_vrsave;
> | +		else
> | +			vrsave.word = target->thread.vrsave;
> | +
> |  		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &vrsave,
> |  					 33 * sizeof(vector128), -1);
> | -		if (!ret)
> | -			target->thread.vrsave = vrsave.word;
> | +		if (!ret) {
> | +			if (MSR_TM_ACTIVE(target->thread.regs->msr))
> | +				target->thread.transact_vrsave = vrsave.word;
> | +			else
> | +				target->thread.vrsave = vrsave.word;
> | +		}
> |  	}
> | -
> |  	return ret;
> |  }
> |  #endif /* CONFIG_ALTIVEC */
> | @@ -613,6 +711,442 @@ static int evr_set(struct task_struct *target, const struct user_regset *regset,
> |  }
> |  #endif /* CONFIG_SPE */
> |  
> | +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> | +
> | +static int tm_spr_active(struct task_struct *target,
> | +				const struct user_regset *regset)
> | +{
> | +	if (!cpu_has_feature(CPU_FTR_TM))
> | +		return -ENODEV;
> | +
> | +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> | +		return 0;
> | +
> | +	return regset->n;
> | +}
> | +/*
> | + *  Transactional memory SPR
> | + *
> | + * struct {
> | + * 	u64		tm_tfhar;
> | + *	u64		tm_texasr;
> | + *	u64		tm_tfiar;
> | + *	unsigned long	tm_orig_msr;
> | + * 	unsigned long	tm_tar;
> | + *	unsigned long	tm_ppr;
> | + *	unsigned long	tm_dscr;
> | + * };
> | + */
> | +static int tm_spr_get(struct task_struct *target, const struct user_regset *regset,
> | +		   unsigned int pos, unsigned int count,
> | +		   void *kbuf, void __user *ubuf)
> | +{
> | +	int ret;
> | +
> | +	if (!cpu_has_feature(CPU_FTR_TM))
> | +		return -ENODEV;
> | +
> | +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> | +		return -ENODATA;
> | +
> | +	flush_fp_to_thread(target);
> | +	flush_altivec_to_thread(target);
> | +	flush_tmregs_to_thread(target);
> | +
> 
> Can we copy all the values ot a local buf and then do a single
> copyout to user space ?

In the present code, it can copy out registers to user space
till one attempt fails. Just one copy out to user space will
not give this opportunity. Either all of them go or none of
them goes.

> 
> | +	/* TFHAR register */
> | +	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> | +			&target->thread.tm_tfhar, 0, sizeof(u64));
> | +
> | +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_tfhar) +
> | +			sizeof(u64) != offsetof(struct thread_struct, tm_texasr));
> | +
> | +	/* TEXASR register */
> | +	if (!ret)
> | +		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> | +			&target->thread.tm_texasr, sizeof(u64), 2 * sizeof(u64));
> | +
> | +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_texasr) +
> | +			sizeof(u64) != offsetof(struct thread_struct, tm_tfiar));
> | +
> | +	/* TFIAR register */
> | +	if (!ret)
> | +		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> | +			&target->thread.tm_tfiar, 2 * sizeof(u64), 3 * sizeof(u64));
> | +
> | +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_tfiar) +
> | +			sizeof(u64) != offsetof(struct thread_struct, tm_orig_msr));
> | +
> | +	/* TM checkpointed original MSR */
> | +	if (!ret)
> | +		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> | +			&target->thread.tm_orig_msr, 3 * sizeof(u64),
> | +				3 * sizeof(u64) + sizeof(unsigned long));
> | +
> | +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_orig_msr) +
> | +			sizeof(unsigned long) + sizeof(struct pt_regs)
> | +				!= offsetof(struct thread_struct, tm_tar));
> | +
> | +	/* TM checkpointed TAR register */
> | +	if (!ret)
> | +		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> | +			&target->thread.tm_tar, 3 * sizeof(u64) +
> | +				sizeof(unsigned long) , 3 * sizeof(u64) +
> | +					2 * sizeof(unsigned long));
> | +
> | +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_tar)
> | +			+ sizeof(unsigned long) !=
> | +				offsetof(struct thread_struct, tm_ppr));
> | +
> | +	/* TM checkpointed PPR register */
> | +	if (!ret)
> | +		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> | +				&target->thread.tm_ppr, 3 * sizeof(u64) +
> | +					2 * sizeof(unsigned long), 3 * sizeof(u64) +
> | +						3 * sizeof(unsigned long));
> | +
> | +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_ppr) +
> | +			sizeof(unsigned long) !=
> | +				offsetof(struct thread_struct, tm_dscr));
> | +
> | +	/* TM checkpointed DSCR register */
> | +	if (!ret)
> | +		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> | +			&target->thread.tm_dscr, 3 * sizeof(u64)
> | +				+ 3 * sizeof(unsigned long), 3 * sizeof(u64)
> | +						+ 4 * sizeof(unsigned long));
> | +	return ret;
> | +}
> | +
> | +static int tm_spr_set(struct task_struct *target, const struct user_regset *regset,
> | +		   unsigned int pos, unsigned int count,
> | +		   const void *kbuf, const void __user *ubuf)
> | +{
> | +	int ret;
> | +
> | +	if (!cpu_has_feature(CPU_FTR_TM))
> | +		return -ENODEV;
> | +
> | +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> | +		return -ENODATA;
> | +
> | +	flush_fp_to_thread(target);
> | +	flush_altivec_to_thread(target);
> | +	flush_tmregs_to_thread(target);
> | +
> | +	/* TFHAR register */
> | +	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> | +				&target->thread.tm_tfhar, 0, sizeof(u64));
> | +
> | +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_tfhar)
> | +		+ sizeof(u64) != offsetof(struct thread_struct, tm_texasr));
> 
> A single copyin into a local buffer followed by a local assignment would
> be easier to read ?

I guess the same logic applies here as well.

> 
> It could be easier to read if all BUILD_BUG_ON() calls are in one place
> maybe near the beginning of the function or in the header file.

Will move them to the beginning of the function.
> 
> | +
> | +	/* TEXASR register */
> | +	if (!ret)
> | +		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> | +			&target->thread.tm_texasr, sizeof(u64), 2 * sizeof(u64));
> | +
> | +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_texasr)
> | +		+ sizeof(u64) != offsetof(struct thread_struct, tm_tfiar));
> | +
> | +	/* TFIAR register */
> | +	if (!ret)
> | +		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> | +			&target->thread.tm_tfiar, 2 * sizeof(u64), 3 * sizeof(u64));
> | +
> | +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_tfiar)
> | +		+ sizeof(u64) != offsetof(struct thread_struct, tm_orig_msr));
> | +
> | +	/* TM checkpointed orig MSR */
> | +	if (!ret)
> | +		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> | +			&target->thread.tm_orig_msr, 3 * sizeof(u64),
> | +				3 * sizeof(u64) + sizeof(unsigned long));
> | +
> | +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_orig_msr)
> | +		+ sizeof(unsigned long) + sizeof(struct pt_regs) !=
> | +			offsetof(struct thread_struct, tm_tar));
> | +
> | +	/* TM checkpointed TAR register */
> | +	if (!ret)
> | +		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> | +			&target->thread.tm_tar, 3 * sizeof(u64) +
> | +				sizeof(unsigned long), 3 * sizeof(u64) +
> | +					2 * sizeof(unsigned long));
> | +
> | +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_tar)
> | +			+ sizeof(unsigned long) != offsetof(struct thread_struct, tm_ppr));
> | +
> | +	/* TM checkpointed PPR register */
> | +	if (!ret)
> | +		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> | +				&target->thread.tm_ppr, 3 * sizeof(u64)
> | +					+ 2 * sizeof(unsigned long), 3 * sizeof(u64)
> | +					+ 3 * sizeof(unsigned long));
> | +
> | +	BUILD_BUG_ON(offsetof(struct thread_struct, tm_ppr) +
> | +			sizeof(unsigned long) !=
> | +				offsetof(struct thread_struct, tm_dscr));
> | +
> | +	/* TM checkpointed DSCR register */
> | +	if (!ret)
> | +		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> | +				&target->thread.tm_dscr,
> | +					3 * sizeof(u64) + 3 * sizeof(unsigned long),
> | +					3 * sizeof(u64) + 4 * sizeof(unsigned long));
> | +
> | +	return ret;
> | +}
> | +
> | +static int tm_cgpr_active(struct task_struct *target,
> | +				const struct user_regset *regset)
> | +{
> | +	if (!cpu_has_feature(CPU_FTR_TM))
> | +		return -ENODEV;
> | +
> | +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> | +		return 0;
> | +
> | +	return regset->n;
> | +}
> | +
> | +/*
> | + * TM Checkpointed GPR
> | + *
> | + * struct data {
> | + * 	struct pt_regs ckpt_regs;
> | + * };
> | + */
> | +static int tm_cgpr_get(struct task_struct *target, const struct user_regset *regset,
> | +		   unsigned int pos, unsigned int count,
> | +		   void *kbuf, void __user *ubuf)
> | +{
> | +	int ret;
> | +
> | +	if (!cpu_has_feature(CPU_FTR_TM))
> | +		return -ENODEV;
> | +
> | +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> | +		return -ENODATA;
> | +
> | +	flush_fp_to_thread(target);
> | +	flush_altivec_to_thread(target);
> | +	flush_tmregs_to_thread(target);
> | +	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> | +			&target->thread.ckpt_regs, 0,
> | +				sizeof(struct pt_regs));
> | +	return ret;
> | +}
> | +
> | +static int tm_cgpr_set(struct task_struct *target, const struct user_regset *regset,
> | +		   unsigned int pos, unsigned int count,
> | +		   const void *kbuf, const void __user *ubuf)
> | +{
> | +	int ret;
> | +
> | +	if (!cpu_has_feature(CPU_FTR_TM))
> | +		return -ENODEV;
> | +
> | +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> | +		return -ENODATA;
> | +
> | +	flush_fp_to_thread(target);
> | +	flush_altivec_to_thread(target);
> | +	flush_tmregs_to_thread(target);
> | +	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> | +					&target->thread.ckpt_regs, 0,
> | +						sizeof(struct pt_regs));
> | +	return ret;
> | +}
> | +
> | +static int tm_cfpr_active(struct task_struct *target,
> | +				const struct user_regset *regset)
> | +{
> | +	if (!cpu_has_feature(CPU_FTR_TM))
> | +		return -ENODEV;
> | +
> | +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> | +		return 0;
> | +
> | +	return regset->n;
> | +}
> | +
> | +/*
> | + * TM Checkpointed FPR
> | + *
> | + * struct data {
> | + * 	u64	fpr[32];
> | + * 	u64	fpscr;
> | + * };
> | + */
> | +static int tm_cfpr_get(struct task_struct *target, const struct user_regset *regset,
> | +		   unsigned int pos, unsigned int count,
> | +		   void *kbuf, void __user *ubuf)
> | +{
> | +#ifdef CONFIG_VSX
> | +	u64 buf[33];
> | +	int i;
> | +#endif
> | +	if (!cpu_has_feature(CPU_FTR_TM))
> | +		return -ENODEV;
> | +
> | +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> | +		return -ENODATA;
> | +
> | +	flush_fp_to_thread(target);
> | +	flush_altivec_to_thread(target);
> | +	flush_tmregs_to_thread(target);
> | +
> | +#ifdef CONFIG_VSX
> | +	/* copy to local buffer then write that out */
> | +	for (i = 0; i < 32 ; i++)
> | +		buf[i] = target->thread.TS_FPR(i);
> | +	buf[32] = target->thread.fp_state.fpscr;
> | +	return user_regset_copyout(&pos, &count, &kbuf, &ubuf, buf, 0, -1);
> | +
> | +#else
> | +	BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
> | +		offsetof(struct thread_fp_state, fpr[32][0]));
> | +
> | +	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> | +			&target->thread.thread_fp_state, 0, -1);
> | +#endif
> | +}
> | +
> | +static int tm_cfpr_set(struct task_struct *target, const struct user_regset *regset,
> | +		   unsigned int pos, unsigned int count,
> | +		   const void *kbuf, const void __user *ubuf)
> | +{
> | +#ifdef CONFIG_VSX
> | +	u64 buf[33];
> | +	int i;
> | +#endif
> | +	if (!cpu_has_feature(CPU_FTR_TM))
> | +		return -ENODEV;
> | +
> | +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> | +		return -ENODATA;
> | +
> | +	flush_fp_to_thread(target);
> | +	flush_altivec_to_thread(target);
> | +	flush_tmregs_to_thread(target);
> | +
> | +#ifdef CONFIG_VSX
> | +	/* copy to local buffer then write that out */
> | +	i = user_regset_copyin(&pos, &count, &kbuf, &ubuf, buf, 0, -1);
> | +	if (i)
> | +		return i;
> | +	for (i = 0; i < 32 ; i++)
> | +		target->thread.TS_FPR(i) = buf[i];
> | +	target->thread.fp_state.fpscr = buf[32];
> | +	return 0;
> | +#else
> | +	BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
> | +		      offsetof(struct thread_fp_state, fpr[32][0]));
> | +
> | +	return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> | +				&target->thread.fp_state, 0, -1);
> | +#endif
> | +}
> | +
> | +static int tm_cvmx_active(struct task_struct *target,
> | +				const struct user_regset *regset)
> | +{
> | +	if (!cpu_has_feature(CPU_FTR_TM))
> | +		return -ENODEV;
> | +
> | +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> | +		return 0;
> | +
> | +	return regset->n;
> | +}
> 
> All these tm_*_active() functions do the same checks - maybe they could all
> call a common function ?

Will look into it.

> 
> | +
> | +/*
> | + * TM Checkpointed VMX
> | + *
> | + * struct data {
> | + * 	vector128	vr[32];
> | + * 	vector128	vscr;
> | + * 	vector128	vrsave;
> | + *};
> | + */
> | +static int tm_cvmx_get(struct task_struct *target, const struct user_regset *regset,
> | +		   unsigned int pos, unsigned int count,
> | +		   void *kbuf, void __user *ubuf)
> | +{
> | +	int ret;
> | +
> | +	if (!cpu_has_feature(CPU_FTR_TM))
> | +		return -ENODEV;
> | +
> | +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> | +		return -ENODATA;
> | +
> | +	flush_fp_to_thread(target);
> | +	flush_altivec_to_thread(target);
> | +	flush_tmregs_to_thread(target);
> | +
> | +	BUILD_BUG_ON(offsetof(struct thread_vr_state, vscr) !=
> | +		     offsetof(struct thread_vr_state, vr[32]));
> | +
> | +	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> | +				  &target->thread.vr_state, 0,
> | +				  33 * sizeof(vector128));
> | +	if (!ret) {
> | +		/*
> | +		 * Copy out only the low-order word of vrsave.
> | +		 */
> | +		union {
> | +			elf_vrreg_t reg;
> | +			u32 word;
> | +		} vrsave;
> | +		memset(&vrsave, 0, sizeof(vrsave));
> | +		vrsave.word = target->thread.vrsave;
> | +		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, &vrsave,
> | +					  33 * sizeof(vector128), -1);
> | +	}
> | +	return ret;
> | +}
> | +
> | +static int tm_cvmx_set(struct task_struct *target, const struct user_regset *regset,
> | +		   unsigned int pos, unsigned int count,
> | +		   const void *kbuf, const void __user *ubuf)
> | +{
> | +	int ret;
> | +
> | +	if (!cpu_has_feature(CPU_FTR_TM))
> | +		return -ENODEV;
> | +
> | +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> | +		return -ENODATA;
> | +
> | +	flush_fp_to_thread(target);
> | +	flush_altivec_to_thread(target);
> | +	flush_tmregs_to_thread(target);
> | +
> | +	BUILD_BUG_ON(offsetof(struct thread_vr_state, vscr) !=
> | +		offsetof(struct thread_vr_state, vr[32]));
> | +
> | +	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> | +				 &target->thread.vr_state, 0,
> | +				 33 * sizeof(vector128));
> | +	if (!ret && count > 0) {
> | +		/*
> | +		 * We use only the first word of vrsave.
> | +		 */
> | +		union {
> | +			elf_vrreg_t reg;
> | +			u32 word;
> | +		} vrsave;
> | +		memset(&vrsave, 0, sizeof(vrsave));
> | +		vrsave.word = target->thread.vrsave;
> | +		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &vrsave,
> | +					 33 * sizeof(vector128), -1);
> | +		if (!ret)
> | +			target->thread.vrsave = vrsave.word;
> | +	}
> | +	return ret;
> | +}
> | +#endif	/* CONFIG_PPC_TRANSACTIONAL_MEM */
> |  
> |  /*
> |   * These are our native regset flavors.
> | @@ -629,6 +1163,12 @@ enum powerpc_regset {
> |  #ifdef CONFIG_SPE
> |  	REGSET_SPE,
> |  #endif
> | +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> | +	REGSET_TM_SPR,		/* TM specific SPR */
> | +	REGSET_TM_CGPR,		/* TM checkpointed GPR */
> | +	REGSET_TM_CFPR,		/* TM checkpointed FPR */
> | +	REGSET_TM_CVMX,		/* TM checkpointed VMX */
> | +#endif
> |  };
> |  
> |  static const struct user_regset native_regsets[] = {
> | @@ -663,6 +1203,28 @@ static const struct user_regset native_regsets[] = {
> |  		.active = evr_active, .get = evr_get, .set = evr_set
> |  	},
> |  #endif
> | +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> | +	[REGSET_TM_SPR] = {
> | +		.core_note_type = NT_PPC_TM_SPR, .n = 7,
> 
> How about adding a macro ELF_NSPRREG for the 7 special registers ?

Will do that.

> 
> | +		.size = sizeof(u64), .align = sizeof(u64),
> | +		.active = tm_spr_active, .get = tm_spr_get, .set = tm_spr_set
> | +	},
> | +	[REGSET_TM_CGPR] = {
> | +		.core_note_type = NT_PPC_TM_CGPR, .n = ELF_NGREG,
> | +		.size = sizeof(long), .align = sizeof(long),
> | +		.active = tm_cgpr_active, .get = tm_cgpr_get, .set = tm_cgpr_set
> | +	},
> | +	[REGSET_TM_CFPR] = {
> | +		.core_note_type = NT_PPC_TM_CFPR, .n = ELF_NFPREG,
> | +		.size = sizeof(double), .align = sizeof(double),
> | +		.active = tm_cfpr_active, .get = tm_cfpr_get, .set = tm_cfpr_set
> | +	},
> | +	[REGSET_TM_CVMX] = {
> | +		.core_note_type = NT_PPC_TM_CVMX, .n = 34,
> 
> Similarly for the .n = 34

Sure.


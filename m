Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934266AbaGXG4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 02:56:41 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:46797 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934061AbaGXG4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 02:56:40 -0400
Message-ID: <53D0AE21.9030901@au1.ibm.com>
Date: Thu, 24 Jul 2014 16:56:33 +1000
From: Sam Bobroff <sam.bobroff@au1.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de
CC: mikey@neuling.org, james.hogan@imgtec.com, avagin@openvz.org,
        Paul.Clothier@imgtec.com, palves@redhat.com, oleg@redhat.com,
        dhowells@redhat.com, davej@redhat.com, davem@davemloft.net
Subject: Re: [PATCH V3 2/3] powerpc, ptrace: Enable support for transactional
 memory register sets
References: <1400858138-3939-1-git-send-email-khandual@linux.vnet.ibm.com> <1400858138-3939-3-git-send-email-khandual@linux.vnet.ibm.com>
In-Reply-To: <1400858138-3939-3-git-send-email-khandual@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072406-5490-0000-0000-00000076CB34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/05/14 01:15, Anshuman Khandual wrote:
> This patch enables get and set of transactional memory related register
> sets through PTRACE_GETREGSET/PTRACE_SETREGSET interface by implementing
> four new powerpc specific register sets i.e REGSET_TM_SPR, REGSET_TM_CGPR,
> REGSET_TM_CFPR, REGSET_CVMX support corresponding to these following new
> ELF core note types added previously in this regard.
> 
> 	(1) NT_PPC_TM_SPR
> 	(2) NT_PPC_TM_CGPR
> 	(3) NT_PPC_TM_CFPR
> 	(4) NT_PPC_TM_CVMX
> 
> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>

Hi Anshuman,

I'm not Ben but I've reviewed your patch as well as I can and I have
some comments that might be useful to you.

First of all, I couldn't get this to compile without CONFIG_VSX and
CONFIG_PPC_TRANSACTIONAL_MEM defined: there are obvious typos ("esle"
instead of "else") and references to fields that aren't defined for
those cases. I haven't mentioned any of those issues below as the
compiler will do that but you should definitely test those configurations.

Also some of the code seems to assume that if CONFIG_VSX is defined then
CONFIG_PPC_TRANSACTIONAL_MEM must also be defined, but that isn't the
case (it's the other way round: CONFIG_PPC_TRANSACTIONAL_MEM implies
CONFIG_VSX).

> ---
>  arch/powerpc/include/asm/switch_to.h |   8 +
>  arch/powerpc/kernel/process.c        |  24 ++
>  arch/powerpc/kernel/ptrace.c         | 792 +++++++++++++++++++++++++++++++++--
>  3 files changed, 795 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/switch_to.h b/arch/powerpc/include/asm/switch_to.h
> index 0e83e7d..2737f46 100644
> --- a/arch/powerpc/include/asm/switch_to.h
> +++ b/arch/powerpc/include/asm/switch_to.h
> @@ -80,6 +80,14 @@ static inline void flush_spe_to_thread(struct task_struct *t)
>  }
>  #endif
>  
> +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> +extern void flush_tmregs_to_thread(struct task_struct *);
> +#else
> +static inline void flush_tmregs_to_thread(struct task_struct *t)
> +{
> +}
> +#endif /* CONFIG_PPC_TRANSACTIONAL_MEM */
> +
>  static inline void clear_task_ebb(struct task_struct *t)
>  {
>  #ifdef CONFIG_PPC_BOOK3S_64
> diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
> index 31d0215..e247898 100644
> --- a/arch/powerpc/kernel/process.c
> +++ b/arch/powerpc/kernel/process.c
> @@ -695,6 +695,30 @@ static inline void __switch_to_tm(struct task_struct *prev)
>  	}
>  }
>  
> +void flush_tmregs_to_thread(struct task_struct *tsk)
> +{
> +	/*
> +	 * If task is not current, it should have been flushed
> +	 * already to it's thread_struct during __switch_to().
> +	 */
> +	if (tsk != current)
> +		return;
> +
> +	preempt_disable();
> +	if (tsk->thread.regs) {
> +		/*
> +		 * If we are still current, the TM state need to
> +		 * be flushed to thread_struct as it will be still
> +		 * present in the current cpu.
> +		 */
> +		if (MSR_TM_ACTIVE(tsk->thread.regs->msr)) {
> +			__switch_to_tm(tsk);
> +			tm_recheckpoint_new_task(tsk);

There is at least one other usage of this pair of calls in order to
"flush" the TM state (in arch_dup_task_struct()), so rather than copying
it you might want to create a new function and call it from both places.
(And include the nice comment from arch_dup_task_struct() that explains
how it works and why.)

> +		}
> +	}
> +	preempt_enable();
> +}
> +
>  /*
>   * This is called if we are on the way out to userspace and the
>   * TIF_RESTORE_TM flag is set.  It checks if we need to reload
> diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
> index 2e3d2bf..17642ef 100644
> --- a/arch/powerpc/kernel/ptrace.c
> +++ b/arch/powerpc/kernel/ptrace.c
> @@ -357,6 +357,17 @@ static int gpr_set(struct task_struct *target, const struct user_regset *regset,
>  	return ret;
>  }
>  
> +/*
> + * When any transaction is active, "thread_struct->transact_fp" holds
> + * the current running value of all FPR registers and "thread_struct->
> + * fp_state" holds the last checkpointed FPR registers state for the
> + * current transaction.
> + *
> + * struct data {
> + * 	u64	fpr[32];
> + * 	u64	fpscr;
> + * };

It would be nice to say why you've included "struct data" in the comment.

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
> +		flush_tmregs_to_thread(target);
> +	} else {
> +		flush_fp_to_thread(target);
> +	}

I don't see why you need the else. Could this be:

	flush_fp_to_thread(target);
	if (MSR_TM_ACTIVE(target->thread.regs->msr)) {
		flush_altivec_to_thread(target);
		flush_tmregs_to_thread(target);
	}

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

I see several cases of similar code needing to access either fp_state or
transact_fp, or other similar pairs, so maybe you could use a macro.
Something like this (I'm not sure about the name!):

#define MABYE_TM(TSK,X,TM_X) \
((MSR_TM_ACTIVE((TSK)->thread.regs->msr) \
? &((TSK)->thread.(TM_X) \
: &((TSK)->thread.(X))

Then you could do this:

	struct thread_fp_state *fp;

	fp = MAYBE_TM(target,fp_state,transact_fp);
	for (i = 0; i < 32; i++)
		buf[i] = (*fp)[i][TS_FPROFFSET];

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

The BUILD_BUG_ON() statements don't need to be in the "if", since
they're compile-time (and "struct transact_fp" is not a type so that one
isn't needed), and you could use the utility function (above) to shorten
this a lot, i.e.:
	BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
		     offsetof(struct thread_fp_state, fpr[32][0]));
	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
				  MAYBE_TM(target,fp_state,transact_fp)
				   , 0, -1);

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
> +		flush_tmregs_to_thread(target);
> +	} else {
> +		flush_fp_to_thread(target);
> +	}

This could be simplified like the similar case above.

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

This could be shorted using the above macro.

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

... as could this.

>  }
>  
> @@ -432,20 +484,44 @@ static int vr_active(struct task_struct *target,
>  	return target->thread.used_vr ? regset->n : 0;
>  }
>  
> +/*
> + * When any transaction is active, "thread_struct->transact_vr" holds
> + * the current running value of all VMX registers and "thread_struct->
> + * vr_state" holds the last checkpointed value of VMX registers for the
> + * current transaction.
> + *
> + * struct data {
> + * 	vector128	vr[32];
> + * 	vector128	vscr;
> + * 	vector128	vrsave;
> + * };
> + */

Again a comment about "struct data" would be nice.

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
> +		flush_tmregs_to_thread(target);
> +	} else {
> +		flush_altivec_to_thread(target);
> +	}

As above.

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

As above.

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

As above.

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
> +		flush_tmregs_to_thread(target);
> +	} else {
> +		flush_altivec_to_thread(target);
> +	}

Could flush_altivec_to_thread() be pulled out of the "if" or is it
important to call flush_fp_to_thread() first?

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

As above, and as a result you could remove "addr".

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

As above.

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

As above.

>  	}
> -
>  	return ret;
>  }
>  #endif /* CONFIG_ALTIVEC */
> @@ -613,6 +711,442 @@ static int evr_set(struct task_struct *target, const struct user_regset *regset,
>  }
>  #endif /* CONFIG_SPE */
>  
> +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> +
> +static int tm_spr_active(struct task_struct *target,
> +				const struct user_regset *regset)
> +{
> +	if (!cpu_has_feature(CPU_FTR_TM))
> +		return -ENODEV;
> +
> +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> +		return 0;
> +
> +	return regset->n;
> +}
> +/*
> + *  Transactional memory SPR
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
> +	if (!cpu_has_feature(CPU_FTR_TM))
> +		return -ENODEV;
> +
> +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> +		return -ENODATA;
> +
> +	flush_fp_to_thread(target);
> +	flush_altivec_to_thread(target);
> +	flush_tmregs_to_thread(target);
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
> +	if (!cpu_has_feature(CPU_FTR_TM))
> +		return -ENODEV;
> +
> +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> +		return -ENODATA;
> +
> +	flush_fp_to_thread(target);
> +	flush_altivec_to_thread(target);
> +	flush_tmregs_to_thread(target);
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

I don't understand why tm_spr_set() and tm_spr_get() are structured like
this. It looks like they're expecting user_regset_copyin() to fail part
of the way through and are being careful to set the registers until that
point, even if it's going to return a failure.

This seems strange because other functions are careful to construct an
intermediate buffer so that they can either succeed or fail entirely. If
there's a reason that this needs to be this way, it might be a good idea
to explain that in a comment.

If they dont need to act like that, wouldn't all the BUILD_BUG_ONs
guarantee that the thread_struct registers are contiguous and therefore
you could set them all with a single call to user_regset_copyin()? If
you don't need them to be contiguous then what are the BUILD_BUG_ONs for?

> +
> +static int tm_cgpr_active(struct task_struct *target,
> +				const struct user_regset *regset)
> +{
> +	if (!cpu_has_feature(CPU_FTR_TM))
> +		return -ENODEV;
> +
> +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> +		return 0;
> +
> +	return regset->n;
> +}
> +
> +/*
> + * TM Checkpointed GPR
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
> +	if (!cpu_has_feature(CPU_FTR_TM))
> +		return -ENODEV;
> +
> +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> +		return -ENODATA;
> +
> +	flush_fp_to_thread(target);
> +	flush_altivec_to_thread(target);
> +	flush_tmregs_to_thread(target);

I see this pattern of checking for TM and calling flush_fp_to_thread(),
flush_altivec_to_thread() and flush_tmregs_to_thread() in many places;
maybe it should be factored out to a function.

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
> +	if (!cpu_has_feature(CPU_FTR_TM))
> +		return -ENODEV;
> +
> +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> +		return -ENODATA;
> +
> +	flush_fp_to_thread(target);
> +	flush_altivec_to_thread(target);
> +	flush_tmregs_to_thread(target);
> +	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +					&target->thread.ckpt_regs, 0,
> +						sizeof(struct pt_regs));
> +	return ret;
> +}
> +
> +static int tm_cfpr_active(struct task_struct *target,
> +				const struct user_regset *regset)
> +{
> +	if (!cpu_has_feature(CPU_FTR_TM))
> +		return -ENODEV;
> +
> +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> +		return 0;
> +
> +	return regset->n;
> +}
> +
> +/*
> + * TM Checkpointed FPR
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
> +	if (!cpu_has_feature(CPU_FTR_TM))
> +		return -ENODEV;
> +
> +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> +		return -ENODATA;
> +
> +	flush_fp_to_thread(target);
> +	flush_altivec_to_thread(target);
> +	flush_tmregs_to_thread(target);
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
> +	if (!cpu_has_feature(CPU_FTR_TM))
> +		return -ENODEV;
> +
> +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> +		return -ENODATA;
> +
> +	flush_fp_to_thread(target);
> +	flush_altivec_to_thread(target);
> +	flush_tmregs_to_thread(target);
> +
> +#ifdef CONFIG_VSX
> +	/* copy to local buffer then write that out */
> +	i = user_regset_copyin(&pos, &count, &kbuf, &ubuf, buf, 0, -1);
> +	if (i)
> +		return i;
> +	for (i = 0; i < 32 ; i++)
> +		target->thread.TS_FPR(i) = buf[i];
> +	target->thread.fp_state.fpscr = buf[32];
> +	return 0;
> +#else
> +	BUILD_BUG_ON(offsetof(struct thread_fp_state, fpscr) !=
> +		      offsetof(struct thread_fp_state, fpr[32][0]));
> +
> +	return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> +				&target->thread.fp_state, 0, -1);
> +#endif
> +}
> +
> +static int tm_cvmx_active(struct task_struct *target,
> +				const struct user_regset *regset)
> +{
> +	if (!cpu_has_feature(CPU_FTR_TM))
> +		return -ENODEV;
> +
> +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> +		return 0;
> +
> +	return regset->n;
> +}
> +
> +/*
> + * TM Checkpointed VMX
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
> +	if (!cpu_has_feature(CPU_FTR_TM))
> +		return -ENODEV;
> +
> +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> +		return -ENODATA;
> +
> +	flush_fp_to_thread(target);
> +	flush_altivec_to_thread(target);
> +	flush_tmregs_to_thread(target);
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

I see this pattern of returning only the low-order word several times.
Maybe it should be factored out, or there is already a function
somewhere to do this (it seems like a fairly generic operation).

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
> +	if (!cpu_has_feature(CPU_FTR_TM))
> +		return -ENODEV;
> +
> +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> +		return -ENODATA;
> +
> +	flush_fp_to_thread(target);
> +	flush_altivec_to_thread(target);
> +	flush_tmregs_to_thread(target);
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
>  
>  /*
>   * These are our native regset flavors.
> @@ -629,6 +1163,12 @@ enum powerpc_regset {
>  #ifdef CONFIG_SPE
>  	REGSET_SPE,
>  #endif
> +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> +	REGSET_TM_SPR,		/* TM specific SPR */
> +	REGSET_TM_CGPR,		/* TM checkpointed GPR */
> +	REGSET_TM_CFPR,		/* TM checkpointed FPR */
> +	REGSET_TM_CVMX,		/* TM checkpointed VMX */
> +#endif
>  };
>  
>  static const struct user_regset native_regsets[] = {
> @@ -663,6 +1203,28 @@ static const struct user_regset native_regsets[] = {
>  		.active = evr_active, .get = evr_get, .set = evr_set
>  	},
>  #endif
> +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> +	[REGSET_TM_SPR] = {
> +		.core_note_type = NT_PPC_TM_SPR, .n = 7,
> +		.size = sizeof(u64), .align = sizeof(u64),
> +		.active = tm_spr_active, .get = tm_spr_get, .set = tm_spr_set
> +	},
> +	[REGSET_TM_CGPR] = {
> +		.core_note_type = NT_PPC_TM_CGPR, .n = ELF_NGREG,
> +		.size = sizeof(long), .align = sizeof(long),
> +		.active = tm_cgpr_active, .get = tm_cgpr_get, .set = tm_cgpr_set
> +	},
> +	[REGSET_TM_CFPR] = {
> +		.core_note_type = NT_PPC_TM_CFPR, .n = ELF_NFPREG,
> +		.size = sizeof(double), .align = sizeof(double),
> +		.active = tm_cfpr_active, .get = tm_cfpr_get, .set = tm_cfpr_set
> +	},
> +	[REGSET_TM_CVMX] = {
> +		.core_note_type = NT_PPC_TM_CVMX, .n = 34,
> +		.size = sizeof(vector128), .align = sizeof(vector128),
> +		.active = tm_cvmx_active, .get = tm_cvmx_get, .set = tm_cvmx_set
> +	},
> +#endif
>  };
>  
>  static const struct user_regset_view user_ppc_native_view = {
> @@ -690,7 +1252,7 @@ static int gpr32_get(struct task_struct *target,
>  	if (!FULL_REGS(target->thread.regs)) {
>  		/* We have a partial register set.  Fill 14-31 with bogus values */
>  		for (i = 14; i < 32; i++)
> -			target->thread.regs->gpr[i] = NV_REG_POISON; 
> +			target->thread.regs->gpr[i] = NV_REG_POISON;
>  	}
>  
>  	pos /= sizeof(reg);
> @@ -803,6 +1365,157 @@ static int gpr32_set(struct task_struct *target,
>  					 (PT_TRAP + 1) * sizeof(reg), -1);
>  }
>  
> +static int tm_cgpr32_get(struct task_struct *target,
> +		     const struct user_regset *regset,
> +		     unsigned int pos, unsigned int count,
> +		     void *kbuf, void __user *ubuf)
> +{
> +	const unsigned long *regs = &target->thread.ckpt_regs.gpr[0];
> +	compat_ulong_t *k = kbuf;
> +	compat_ulong_t __user *u = ubuf;
> +	compat_ulong_t reg;
> +	int i;
> +
> +	if (!cpu_has_feature(CPU_FTR_TM))
> +		return -ENODEV;
> +
> +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> +		return -ENODATA;
> +
> +	flush_fp_to_thread(target);
> +	flush_altivec_to_thread(target);
> +	flush_tmregs_to_thread(target);
> +
> +	if (target->thread.regs == NULL)
> +		return -EIO;
> +
> +	if (!FULL_REGS(target->thread.regs)) {
> +		/* We have a partial register set.  Fill 14-31 with bogus values */
> +		for (i = 14; i < 32; i++)
> +			target->thread.regs->gpr[i] = NV_REG_POISON; 

The line above adds a whitespace error. (Did you run it through
checkpatch.pl?)

> +	}
> +
> +	pos /= sizeof(reg);
> +	count /= sizeof(reg);
> +
> +	if (kbuf)
> +		for (; count > 0 && pos < PT_MSR; --count)
> +			*k++ = regs[pos++];
> +	else
> +		for (; count > 0 && pos < PT_MSR; --count)
> +			if (__put_user((compat_ulong_t) regs[pos++], u++))
> +				return -EFAULT;
> +
> +	if (count > 0 && pos == PT_MSR) {
> +		reg = get_user_msr(target);
> +		if (kbuf)
> +			*k++ = reg;
> +		else if (__put_user(reg, u++))
> +			return -EFAULT;
> +		++pos;
> +		--count;
> +	}
> +
> +	if (kbuf)
> +		for (; count > 0 && pos < PT_REGS_COUNT; --count)
> +			*k++ = regs[pos++];
> +	else
> +		for (; count > 0 && pos < PT_REGS_COUNT; --count)
> +			if (__put_user((compat_ulong_t) regs[pos++], u++))
> +				return -EFAULT;
> +
> +	kbuf = k;
> +	ubuf = u;
> +	pos *= sizeof(reg);
> +	count *= sizeof(reg);
> +	return user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
> +					PT_REGS_COUNT * sizeof(reg), -1);
> +}
> +
> +static int tm_cgpr32_set(struct task_struct *target,
> +		     const struct user_regset *regset,
> +		     unsigned int pos, unsigned int count,
> +		     const void *kbuf, const void __user *ubuf)
> +{
> +	unsigned long *regs = &target->thread.ckpt_regs.gpr[0];
> +	const compat_ulong_t *k = kbuf;
> +	const compat_ulong_t __user *u = ubuf;
> +	compat_ulong_t reg;
> +
> +	if (!cpu_has_feature(CPU_FTR_TM))
> +		return -ENODEV;
> +
> +	if(!MSR_TM_ACTIVE(target->thread.regs->msr))
> +		return -ENODATA;
> +
> +	flush_fp_to_thread(target);
> +	flush_altivec_to_thread(target);
> +	flush_tmregs_to_thread(target);
> +
> +	if (target->thread.regs == NULL)
> +		return -EIO;
> +
> +	CHECK_FULL_REGS(target->thread.regs);
> +
> +	pos /= sizeof(reg);
> +	count /= sizeof(reg);
> +
> +	if (kbuf)
> +		for (; count > 0 && pos < PT_MSR; --count)
> +			regs[pos++] = *k++;
> +	else
> +		for (; count > 0 && pos < PT_MSR; --count) {
> +			if (__get_user(reg, u++))
> +				return -EFAULT;
> +			regs[pos++] = reg;
> +		}
> +
> +
> +	if (count > 0 && pos == PT_MSR) {
> +		if (kbuf)
> +			reg = *k++;
> +		else if (__get_user(reg, u++))
> +			return -EFAULT;
> +		set_user_msr(target, reg);
> +		++pos;
> +		--count;
> +	}
> +
> +	if (kbuf) {
> +		for (; count > 0 && pos <= PT_MAX_PUT_REG; --count)
> +			regs[pos++] = *k++;
> +		for (; count > 0 && pos < PT_TRAP; --count, ++pos)
> +			++k;
> +	} else {
> +		for (; count > 0 && pos <= PT_MAX_PUT_REG; --count) {
> +			if (__get_user(reg, u++))
> +				return -EFAULT;
> +			regs[pos++] = reg;
> +		}
> +		for (; count > 0 && pos < PT_TRAP; --count, ++pos)
> +			if (__get_user(reg, u++))
> +				return -EFAULT;
> +	}
> +
> +	if (count > 0 && pos == PT_TRAP) {
> +		if (kbuf)
> +			reg = *k++;
> +		else if (__get_user(reg, u++))
> +			return -EFAULT;
> +		set_user_trap(target, reg);
> +		++pos;
> +		--count;
> +	}
> +
> +	kbuf = k;
> +	ubuf = u;
> +	pos *= sizeof(reg);
> +	count *= sizeof(reg);
> +	return user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
> +					 (PT_TRAP + 1) * sizeof(reg), -1);
> +}
> +
> +
>  /*
>   * These are the regset flavors matching the CONFIG_PPC32 native set.
>   */
> @@ -831,6 +1544,28 @@ static const struct user_regset compat_regsets[] = {
>  		.active = evr_active, .get = evr_get, .set = evr_set
>  	},
>  #endif
> +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
> +	[REGSET_TM_SPR] = {
> +		.core_note_type = NT_PPC_TM_SPR, .n = 7,
> +		.size = sizeof(u64), .align = sizeof(u64),
> +		.active = tm_spr_active, .get = tm_spr_get, .set = tm_spr_set
> +	},
> +	[REGSET_TM_CGPR] = {
> +		.core_note_type = NT_PPC_TM_CGPR, .n = ELF_NGREG,
> +		.size = sizeof(long), .align = sizeof(long),
> +		.active = tm_cgpr_active, .get = tm_cgpr32_get, .set = tm_cgpr32_set
> +	},
> +	[REGSET_TM_CFPR] = {
> +		.core_note_type = NT_PPC_TM_CFPR, .n = ELF_NFPREG,
> +		.size = sizeof(double), .align = sizeof(double),
> +		.active = tm_cfpr_active, .get = tm_cfpr_get, .set = tm_cfpr_set
> +	},
> +	[REGSET_TM_CVMX] = {
> +		.core_note_type = NT_PPC_TM_CVMX, .n = 34,
> +		.size = sizeof(vector128), .align = sizeof(vector128),
> +		.active = tm_cvmx_active, .get = tm_cvmx_get, .set = tm_cvmx_set
> +	},
> +#endif
>  };
>  
>  static const struct user_regset_view user_ppc_compat_view = {
> @@ -1754,7 +2489,6 @@ long arch_ptrace(struct task_struct *child, long request,
>  					     REGSET_SPE, 0, 35 * sizeof(u32),
>  					     datavp);
>  #endif
> -
>  	default:
>  		ret = ptrace_request(child, request, addr, data);
>  		break;
> 


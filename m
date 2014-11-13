Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281AbaKMO3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 09:29:40 -0500
Received: from www.linutronix.de ([62.245.132.108]:47260 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932910AbaKMO3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:29:38 -0500
Date: Thu, 13 Nov 2014 15:29:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Hansen <dave@sr71.net>
cc: hpa@zytor.com, mingo@redhat.com, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-mips@linux-mips.org, qiaowei.ren@intel.com,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH 09/11] x86, mpx: on-demand kernel allocation of bounds
 tables
In-Reply-To: <20141112170510.3D07BA53@viggo.jf.intel.com>
Message-ID: <alpine.DEB.2.11.1411131454130.3935@nanos>
References: <20141112170443.B4BD0899@viggo.jf.intel.com> <20141112170510.3D07BA53@viggo.jf.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2014, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Thomas, I know you're not a huge fan of using mm->mmap_sem for serializing
> this stuff.  But, now that we are not adding an additional lock a la
> mm->bd_sem, I can't quite justify adding another lock and trying to
> reconcile the interactions and ording with mmap_sem.
> 
> We are only adding two spots where we acquire mmap_sem and did not. All of
> the other "use" is in places where it is held already.  Those two points
> of new use are *tiny* and can easily be replaced in the future.

I'm fine with that as long as we dont have the "drop, reacquire, handle
races of all sorts" dance.


> +static inline void arch_bprm_mm_init(struct mm_struct *mm,
> +		struct vm_area_struct *vma)
> +{
> +#ifdef CONFIG_X86_INTEL_MPX
> +	mm->bd_addr = MPX_INVALID_BOUNDS_DIR;
> +#endif
> +}
> +

I'd rather have in mpx.h

static inline void mpx_mm_init(struct mm_struct *mm)
{
#ifdef CONFIG_X86_INTEL_MPX
 	mm->bd_addr = MPX_INVALID_BOUNDS_DIR;
#endif
}

and make this

static inline void arch_bprm_mm_init(struct mm_struct *mm,
       		   		     struct vm_area_struct *vma)
{
	mpx_mm_init(mm);
}

So this #ifdef can be replaced

> +++ b/arch/x86/kernel/setup.c	2014-11-12 08:49:26.494916477 -0800
> @@ -959,6 +959,13 @@ void __init setup_arch(char **cmdline_p)
>  	init_mm.end_code = (unsigned long) _etext;
>  	init_mm.end_data = (unsigned long) _edata;
>  	init_mm.brk = _brk_end;
> +#ifdef CONFIG_X86_INTEL_MPX
> +	/*
> +	 * NULL is theoretically a valid place to put the bounds
> +	 * directory, so point this at an invalid address.
> +	 */
> +	init_mm.bd_addr = MPX_INVALID_BOUNDS_DIR;
> +#endif

with

	mpx_mm_init(&init_mm);

> +dotraplinkage void do_bounds(struct pt_regs *regs, long error_code)
> +{
> +	enum ctx_state prev_state;
> +	struct bndcsr *bndcsr;
> +	struct xsave_struct *xsave_buf;
> +	struct task_struct *tsk = current;
> +	siginfo_t *info;
> +
> +	prev_state = exception_enter();
> +	if (notify_die(DIE_TRAP, "bounds", regs, error_code,
> +			X86_TRAP_BR, SIGSEGV) == NOTIFY_STOP)
> +		goto exit;
> +	conditional_sti(regs);
> +
> +	if (!user_mode(regs))
> +		die("bounds", regs, error_code);
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_MPX)) {
> +		/* The exception is not from Intel MPX */
> +		goto exit_trap;
> +	}
> +
> +	fpu_save_init(&tsk->thread.fpu);

That lacks a comment why we need to do an xsave here.

> +	xsave_buf = &(tsk->thread.fpu.state->xsave);
> +	bndcsr = get_xsave_addr(xsave_buf, XSTATE_BNDCSR);
> +	if (!bndcsr)
> +		goto exit_trap;

...

> +exit:
> +	exception_exit(prev_state);

And this lacks a:

    	 return;

Otherwise you can avoid the whole exercise above and just jump to
exit_trap :)

> +exit_trap:
> +	/*
> +	 * This path out is for all the cases where we could not
> +	 * handle the exception in some way (like allocating a
> +	 * table or telling userspace about it.  We will also end
> +	 * up here if the kernel has MPX turned off at compile
> +	 * time..
> +	 */
> +	do_trap(X86_TRAP_BR, SIGSEGV, "bounds", regs, error_code, NULL);
> +	exception_exit(prev_state);
> +}

> +int mpx_handle_bd_fault(struct xsave_struct *xsave_buf)
> +{
> +	int ret = 0;
> +	/*
> +	 * Userspace never asked us to manage the bounds tables,
> +	 * so refuse to help.
> +	 */
> +	if (!kernel_managing_mpx_tables(current->mm)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	ret = do_mpx_bt_fault(xsave_buf);
> +	if (ret) {
> +		force_sig(SIGSEGV, current);
> +		/*
> +		 * The force_sig() is essentially "handling" this
> +		 * exception.  Return 0 so that the traps.c code
> +		 * does not take any further action.
> +		 */
> +		ret = 0;
> +	}
> +out:
> +	return ret;

Wee. That's convoluted.

	if (!kernel_managing_mpx_tables(current->mm))
		return -EINVAL;
	if (do_mpx_bt_fault(xsave_buf)) {
		/* Add comment */
		force_sig(SIGSEGV, current);
	}
	return 0;

Does the same thing in a readable form :)

Thanks,

	tglx

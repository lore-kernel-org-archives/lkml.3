Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934119AbaCSNWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:22:24 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22175 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933771AbaCSNWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:22:21 -0400
Date: Wed, 19 Mar 2014 09:21:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>, hpa@zytor.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, Sarah Newman <srn@prgmr.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xen.org,
        Ingo Molnar <mingo@redhat.com>, Suresh Siddha <sbsiddha@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCHv1] x86: don't schedule when handling #NM
 exception
Message-ID: <20140319132156.GA12574@phenom.dumpdata.com>
References: <1394468273-13676-1-git-send-email-david.vrabel@citrix.com>
 <531DEB11.2070709@zytor.com>
 <531DF319.6010800@citrix.com>
 <53266841.6090308@prgmr.com>
 <1ebfa80c-4a68-4602-bc98-e5d5f0893998@email.android.com>
 <53266D94.70902@prgmr.com>
 <53266F56.9030909@zytor.com>
 <5326F89F.8010404@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5326F89F.8010404@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 01:29:03PM +0000, David Vrabel wrote:
> On 17/03/14 03:43, H. Peter Anvin wrote:
> > On 03/16/2014 08:35 PM, Sarah Newman wrote:
> >> Can you please review my patch first?  It's only enabled when absolutely required.
> > 
> > It doesn't help.  It means you're running on Xen, and you will have
> > processes subjected to random SIGKILL because they happen to touch the
> > FPU when the atomic pool is low.
> > 
> > However, there is probably a happy medium: you don't actually need eager
> > FPU restore, you just need eager FPU *allocation*.  We have been
> > intending to allocate the FPU state at task creation time for eagerfpu,
> > and Suresh Siddha has already produced such a patch; it just needs some
> > minor fixups due to an __init failure.
> > 
> > http://lkml.kernel.org/r/1391325599.6481.5.camel@europa
> > 
> > In the Xen case we could turn on eager allocation but not eager fpu.  In
> > fact, it might be justified to *always* do eager allocation...
> 
> The following patch does the always eager allocation.  It's a fixup of
> Suresh's original patch.
> 

Hey Peter,

I think this is the solution you were looking for?

Or are there some other subtle issues that you think lurk around?

Thanks!
> v2:
> - Allocate initial fpu state after xsave_init().
> - Only allocate initial FPU state on boot cpu.
> 
> 8<-----------------------
> x86, fpu: remove the logic of non-eager fpu mem allocation at the first usage
> 
> From: Suresh Siddha <sbsiddha@gmail.com>
> 
> For non-eager fpu mode, thread's fpu state is allocated during the first
> fpu usage (in the context of device not available exception). This can be
> a blocking call and hence we enable interrupts (which were originally
> disabled when the exception happened), allocate memory and disable
> interrupts etc. While this saves 512 bytes or so per-thread, there
> are some issues in general.
> 
> a.  Most of the future cases will be anyway using eager
> FPU (because of processor features like xsaveopt, LWP, MPX etc) and
> they do the allocation at the thread creation itself. Nice to have
> one common mechanism as all the state save/restore code is
> shared. Avoids the confusion and minimizes the subtle bugs
> in the core piece involved with context-switch.
> 
> b. If a parent thread uses FPU, during fork() we allocate
> the FPU state in the child and copy the state etc. Shortly after this,
> during exec() we free it up, so that we can later allocate during
> the first usage of FPU. So this free/allocate might be slower
> for some workloads.
> 
> c. math_state_restore() is called from multiple places
> and it is error pone if the caller expects interrupts to be disabled
> throughout the execution of math_state_restore(). Can lead to subtle
> bugs like Ubuntu bug #1265841.
> 
> Memory savings will be small anyways and the code complexity
> introducing subtle bugs is not worth it. So remove
> the logic of non-eager fpu mem allocation at the first usage.
> 
> Signed-off-by: Suresh Siddha <sbsiddha@gmail.com>
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> ---
>  arch/x86/kernel/i387.c    |   22 +++++++++++++---------
>  arch/x86/kernel/process.c |    6 ------
>  arch/x86/kernel/traps.c   |   16 ++--------------
>  arch/x86/kernel/xsave.c   |    2 --
>  4 files changed, 15 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
> index e8368c6..05aeae2 100644
> --- a/arch/x86/kernel/i387.c
> +++ b/arch/x86/kernel/i387.c
> @@ -5,6 +5,7 @@
>   *  General FPU state handling cleanups
>   *	Gareth Hughes <gareth@valinux.com>, May 2000
>   */
> +#include <linux/bootmem.h>
>  #include <linux/module.h>
>  #include <linux/regset.h>
>  #include <linux/sched.h>
> @@ -153,8 +154,15 @@ static void init_thread_xstate(void)
>   * into all processes.
>   */
>  
> +static void __init fpu_init_boot_cpu(void)
> +{
> +	current->thread.fpu.state =
> +		alloc_bootmem_align(xstate_size, __alignof__(struct xsave_struct));
> +}
> +
>  void fpu_init(void)
>  {
> +	static __refdata void (*boot_func)(void) = fpu_init_boot_cpu;
>  	unsigned long cr0;
>  	unsigned long cr4_mask = 0;
>  
> @@ -189,6 +197,11 @@ void fpu_init(void)
>  	mxcsr_feature_mask_init();
>  	xsave_init();
>  	eager_fpu_init();
> +
> +	if (boot_func) {
> +		boot_func();
> +		boot_func = NULL;
> +	}
>  }
>  
>  void fpu_finit(struct fpu *fpu)
> @@ -219,8 +232,6 @@ EXPORT_SYMBOL_GPL(fpu_finit);
>   */
>  int init_fpu(struct task_struct *tsk)
>  {
> -	int ret;
> -
>  	if (tsk_used_math(tsk)) {
>  		if (cpu_has_fpu && tsk == current)
>  			unlazy_fpu(tsk);
> @@ -228,13 +239,6 @@ int init_fpu(struct task_struct *tsk)
>  		return 0;
>  	}
>  
> -	/*
> -	 * Memory allocation at the first usage of the FPU and other state.
> -	 */
> -	ret = fpu_alloc(&tsk->thread.fpu);
> -	if (ret)
> -		return ret;
> -
>  	fpu_finit(&tsk->thread.fpu);
>  
>  	set_stopped_child_used_math(tsk);
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 3fb8d95..cd9c190 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -128,12 +128,6 @@ void flush_thread(void)
>  	flush_ptrace_hw_breakpoint(tsk);
>  	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
>  	drop_init_fpu(tsk);
> -	/*
> -	 * Free the FPU state for non xsave platforms. They get reallocated
> -	 * lazily at the first use.
> -	 */
> -	if (!use_eager_fpu())
> -		free_thread_xstate(tsk);
>  }
>  
>  static void hard_disable_TSC(void)
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 57409f6..3265429 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -623,20 +623,8 @@ void math_state_restore(void)
>  {
>  	struct task_struct *tsk = current;
>  
> -	if (!tsk_used_math(tsk)) {
> -		local_irq_enable();
> -		/*
> -		 * does a slab alloc which can sleep
> -		 */
> -		if (init_fpu(tsk)) {
> -			/*
> -			 * ran out of memory!
> -			 */
> -			do_group_exit(SIGKILL);
> -			return;
> -		}
> -		local_irq_disable();
> -	}
> +	if (!tsk_used_math(tsk))
> +		init_fpu(tsk);
>  
>  	__thread_fpu_begin(tsk);
>  
> diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
> index a4b451c..46f6266 100644
> --- a/arch/x86/kernel/xsave.c
> +++ b/arch/x86/kernel/xsave.c
> @@ -598,8 +598,6 @@ void xsave_init(void)
>  
>  static inline void __init eager_fpu_init_bp(void)
>  {
> -	current->thread.fpu.state =
> -	    alloc_bootmem_align(xstate_size, __alignof__(struct xsave_struct));
>  	if (!init_xstate_buf)
>  		setup_init_fpu_buf();
>  }
> -- 
> 1.7.2.5
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel

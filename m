Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbbAMPZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:25:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbbAMPZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:25:10 -0500
Date: Tue, 13 Jan 2015 16:24:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [RFC PATCH 02/11] x86,fpu: replace fpu_switch_t with a thread
	flag
Message-ID: <20150113152409.GA23134@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-3-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421012793-30106-3-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik,

I can't review this series, I forgot almost everything I learned about
this code. The only thing I can recall is that it needs cleanups and
fixes ;) Just a couple of random questions.

On 01/11, riel@redhat.com wrote:
>
> +static inline void switch_fpu_prepare(struct task_struct *old, struct task_struct *new, int cpu)
>  {
> -	fpu_switch_t fpu;
> -
>  	/*
>  	 * If the task has used the math, pre-load the FPU on xsave processors
>  	 * or if the past 5 consecutive context-switches used math.
>  	 */
> -	fpu.preload = tsk_used_math(new) && (use_eager_fpu() ||
> +	bool preload = tsk_used_math(new) && (use_eager_fpu() ||
>  					     new->thread.fpu_counter > 5);
>  	if (__thread_has_fpu(old)) {
>  		if (!__save_init_fpu(old))
> @@ -433,8 +417,9 @@ static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct ta
>  		old->thread.fpu.has_fpu = 0;	/* But leave fpu_owner_task! */
>
>  		/* Don't change CR0.TS if we just switch! */
> -		if (fpu.preload) {
> +		if (preload) {
>  			new->thread.fpu_counter++;
> +			set_thread_flag(TIF_LOAD_FPU);
>  			__thread_set_has_fpu(new);
>  			prefetch(new->thread.fpu.state);
>  		} else if (!use_eager_fpu())
> @@ -442,16 +427,19 @@ static inline fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct ta
>  	} else {
>  		old->thread.fpu_counter = 0;
>  		old->thread.fpu.last_cpu = ~0;
> -		if (fpu.preload) {
> +		if (preload) {
>  			new->thread.fpu_counter++;
>  			if (!use_eager_fpu() && fpu_lazy_restore(new, cpu))
> -				fpu.preload = 0;
> -			else
> +				/* XXX: is this safe against ptrace??? */

Could you explain your concerns?

> +				__thread_fpu_begin(new);

this looks strange/unnecessary, there is another unconditonal
__thread_fpu_begin(new) below.

OK, the next patch moves it to switch_fpu_finish(), so perhaps this change
should go into 3/11.

And I am not sure I understand set_thread_flag(TIF_LOAD_FPU). This is called
before __switch_to() updates kernel_stack, so it seems that the old thread
gets this flag set, not new?

Even if this is correct, perhaps set_tsk_thread_flag(new) will look better?

The same for switch_fpu_finish(). I guess this should actually work after
this patch, because switch_fpu_finish() is called before
this_cpu_write(kernel_stack) too and thus both prepare/finish will use the
same thread_info, but this looks confusing at least.

> --- a/arch/x86/include/asm/thread_info.h
> +++ b/arch/x86/include/asm/thread_info.h
> @@ -91,6 +91,7 @@ struct thread_info {
>  #define TIF_SYSCALL_TRACEPOINT	28	/* syscall tracepoint instrumentation */
>  #define TIF_ADDR32		29	/* 32-bit address space on 64 bits */
>  #define TIF_X32			30	/* 32-bit native x86-64 binary */
> +#define TIF_LOAD_FPU		31	/* load FPU on return to userspace */

Well, the comment is wrong after this patch, but I see 4/11...

>  #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
>  #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
> @@ -115,6 +116,7 @@ struct thread_info {
>  #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
>  #define _TIF_ADDR32		(1 << TIF_ADDR32)
>  #define _TIF_X32		(1 << TIF_X32)
> +#define _TIF_LOAD_FPU		(1 << TIF_LOAD_FPU)
>
>  /* work to do in syscall_trace_enter() */
>  #define _TIF_WORK_SYSCALL_ENTRY	\
> @@ -141,7 +143,7 @@ struct thread_info {
>  /* Only used for 64 bit */
>  #define _TIF_DO_NOTIFY_MASK						\
>  	(_TIF_SIGPENDING | _TIF_MCE_NOTIFY | _TIF_NOTIFY_RESUME |	\
> -	 _TIF_USER_RETURN_NOTIFY | _TIF_UPROBE)
> +	 _TIF_USER_RETURN_NOTIFY | _TIF_UPROBE | _TIF_LOAD_FPU)

This too. I mean, this change has no effect until 4/11.

Oleg.


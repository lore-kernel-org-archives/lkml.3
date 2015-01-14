Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbbANShM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:37:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235AbbANShH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:37:07 -0500
Date: Wed, 14 Jan 2015 19:36:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [RFC PATCH 06/11] x86,fpu: lazily skip fpu restore with eager
	fpu mode, too
Message-ID: <20150114183606.GA16024@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-7-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421012793-30106-7-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11, riel@redhat.com wrote:
>
> If the next task still has its FPU state present in the FPU registers,
> there is no need to restore it from memory.

Another patch I can't understand...

> --- a/arch/x86/include/asm/fpu-internal.h
> +++ b/arch/x86/include/asm/fpu-internal.h
> @@ -435,13 +435,9 @@ static inline void switch_fpu_prepare(struct task_struct *old, struct task_struc
>  		old->thread.fpu.last_cpu = ~0;
>  		if (preload) {
>  			new->thread.fpu_counter++;
> -			if (!use_eager_fpu() && fpu_lazy_restore(new, cpu))
> -				/* XXX: is this safe against ptrace??? */
> -				__thread_fpu_begin(new);
> -			else {
> +			set_thread_flag(TIF_LOAD_FPU);
> +			if (!fpu_lazy_restore(new, cpu))
>  				prefetch(new->thread.fpu.state);
> -				set_thread_flag(TIF_LOAD_FPU);
> -			}

It is not clear to me why do we set TIF_LOAD_FPU if fpu_lazy_restore()
succeeds. __thread_fpu_begin() is cheap.

At the same time, if switch_fpu_finish() does fpu_lazy_restore() anyway,
why this patch doesn't remove it from switch_fpu_prepare() ?

However,

> @@ -466,6 +462,10 @@ static inline void switch_fpu_finish(void)
>
>  	__thread_fpu_begin(tsk);
>
> +	/* The FPU registers already have this task's FPU state. */
> +	if (fpu_lazy_restore(tsk, raw_smp_processor_id()))
> +		return;
> +

Now that this is called before return to user-mode, I am not sure this is
correct. Note that __kernel_fpu_begin() doesn't clear fpu_owner_task if
use_eager_fpu().

OK, interrupted_kernel_fpu_idle() should fail in this case... but as we
already discussed this means the perfomance regression, so this should
be changed.

Oleg.


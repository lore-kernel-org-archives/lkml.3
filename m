Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbbAMPyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:54:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbbAMPyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:54:38 -0500
Date: Tue, 13 Jan 2015 16:53:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [RFC PATCH 04/11] x86,fpu: defer FPU restore until return to
	userspace
Message-ID: <20150113155335.GA24518@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-5-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421012793-30106-5-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11, riel@redhat.com wrote:
>
> @@ -382,6 +382,7 @@ static inline void drop_init_fpu(struct task_struct *tsk)
>  		else
>  			fxrstor_checking(&init_xstate_buf->i387);
>  	}
> +	clear_thread_flag(TIF_LOAD_FPU);

OK, in this case tsk should be current. Still I think clear_tsk_thread_flag()
will look more consistent.

> @@ -435,24 +436,32 @@ static inline void switch_fpu_prepare(struct task_struct *old, struct task_struc
>  				prefetch(new->thread.fpu.state);

I am wondering if these prefetch()es in switch_fpu_prepare() make
sense after this patch.

> +		} else
> +			/*
> +			 * The new task does not want an FPU state restore,
> +			 * and may not even have an FPU state. However, the
> +			 * old task may have left TIF_LOAD_FPU set.
> +			 * Clear it to avoid trouble.
> +			 *
> +			 * CR0.TS is still set from a previous FPU switch
> +			 */
> +			clear_thread_flag(TIF_LOAD_FPU);

I got lost ;) Simply can't understand what this change tries to do.

And it looks "obviously wrong"... OK, suppose that a TIF_LOAD_FPU task
schedules before it returns to user mode (and calls switch_fpu_finish).
Why should we clear its flag if the new task doesn't want FPU ?

"CR0.TS is still set" is not true if use_eager_fpu()... OTOH, .TS can
be also set even if preload == T above, when we set TIF_LOAD_FPU.

> -static inline void switch_fpu_finish(struct task_struct *new)
> +static inline void switch_fpu_finish(void)
>  {
> -	if (test_and_clear_thread_flag(TIF_LOAD_FPU)) {
> -		__thread_fpu_begin(new);
> -		if (unlikely(restore_fpu_checking(new)))
> -			drop_init_fpu(new);
> -	}
> +	struct task_struct *tsk = current;
> +
> +	__thread_fpu_begin(tsk);
> +
> +	if (unlikely(restore_fpu_checking(tsk)))
> +		drop_init_fpu(tsk);
>  }

Again, I am totally confused. After this patch the usage of set_thread_flag()
in switch_fpu_prepare() becomes wrong (see my reply to 2/11), but it is quite
possible I misunderstood these patches.

Oleg.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbbAMPZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:25:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbbAMPZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:25:30 -0500
Date: Tue, 13 Jan 2015 16:24:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [RFC PATCH 03/11] x86,fpu: move __thread_fpu_begin to when the
	task has the fpu
Message-ID: <20150113152430.GB23134@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-4-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421012793-30106-4-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11, riel@redhat.com wrote:
>
> --- a/arch/x86/include/asm/fpu-internal.h
> +++ b/arch/x86/include/asm/fpu-internal.h
> @@ -420,7 +420,6 @@ static inline void switch_fpu_prepare(struct task_struct *old, struct task_struc
>  		if (preload) {
>  			new->thread.fpu_counter++;
>  			set_thread_flag(TIF_LOAD_FPU);
> -			__thread_set_has_fpu(new);
>  			prefetch(new->thread.fpu.state);
>  		} else if (!use_eager_fpu())
>  			stts();
> @@ -436,7 +435,6 @@ static inline void switch_fpu_prepare(struct task_struct *old, struct task_struc
>  				prefetch(new->thread.fpu.state);
>  				set_thread_flag(TIF_LOAD_FPU);
>  			}
> -			__thread_fpu_begin(new);
>  		}
>  		/* else: CR0.TS is still set from a previous FPU switch */
>  	}
> @@ -451,6 +449,7 @@ static inline void switch_fpu_prepare(struct task_struct *old, struct task_struc
>  static inline void switch_fpu_finish(struct task_struct *new)
>  {
>  	if (test_and_clear_thread_flag(TIF_LOAD_FPU)) {
> +		__thread_fpu_begin(new);
>  		if (unlikely(restore_fpu_checking(new)))
>  			drop_init_fpu(new);
>  	}

Then perhaps it makes sense to move fpu_lazy_restore() to fpu_finish() too ?

Either way, afaics we do not need use_eager_fpu() before fpu_lazy_restore(),
and this reminds me that every use_eager_fpu() check in switch_fpu_prepare()
looks confusing.

Oleg.


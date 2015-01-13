Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbbAMRLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:11:40 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:63942 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbbAMRLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:11:39 -0500
MIME-Version: 1.0
In-Reply-To: <1421012793-30106-7-git-send-email-riel@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-7-git-send-email-riel@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 13 Jan 2015 09:11:17 -0800
Message-ID: <CALCETrWWLzdPrmGdw7+g68Sy2m9Fs6U5nO3dWAOHt8XAxXSb3g@mail.gmail.com>
Subject: Re: [RFC PATCH 06/11] x86,fpu: lazily skip fpu restore with eager fpu
 mode, too
To: Rik van Riel <riel@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@suse.de>,
        Oleg Nesterov <oleg@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 1:46 PM,  <riel@redhat.com> wrote:
> From: Rik van Riel <riel@redhat.com>
>
> If the next task still has its FPU state present in the FPU registers,
> there is no need to restore it from memory.
>
> This is no big deal on bare metal, where XSAVEOPT / XRSTOR are heavily
> optimized, but those optimizations do not carry across VMENTER / VMEXIT.
>
> Skipping the call to fpu_restore_checking when the FPU state is already
> loaded in the CPU could save a little bit of overhead on bare metal too,
> so this is not just a KVM optimization.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  arch/x86/include/asm/fpu-internal.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
> index 4db8781..a5a40c7 100644
> --- a/arch/x86/include/asm/fpu-internal.h
> +++ b/arch/x86/include/asm/fpu-internal.h
> @@ -435,13 +435,9 @@ static inline void switch_fpu_prepare(struct task_struct *old, struct task_struc
>                 old->thread.fpu.last_cpu = ~0;
>                 if (preload) {
>                         new->thread.fpu_counter++;
> -                       if (!use_eager_fpu() && fpu_lazy_restore(new, cpu))
> -                               /* XXX: is this safe against ptrace??? */
> -                               __thread_fpu_begin(new);
> -                       else {
> +                       set_thread_flag(TIF_LOAD_FPU);
> +                       if (!fpu_lazy_restore(new, cpu))
>                                 prefetch(new->thread.fpu.state);

Is this prefetch still worth keeping?  Wouldn't prefetching the fpu
effectively require grabbing more than one cacheline anyway?

--Andy

> -                               set_thread_flag(TIF_LOAD_FPU);
> -                       }
>                 } else
>                         /*
>                          * The new task does not want an FPU state restore,
> @@ -466,6 +462,10 @@ static inline void switch_fpu_finish(void)
>
>         __thread_fpu_begin(tsk);
>
> +       /* The FPU registers already have this task's FPU state. */
> +       if (fpu_lazy_restore(tsk, raw_smp_processor_id()))
> +               return;
> +
>         if (unlikely(restore_fpu_checking(tsk)))
>                 drop_init_fpu(tsk);
>  }
> --
> 1.9.3
>



-- 
Andy Lutomirski
AMA Capital Management, LLC

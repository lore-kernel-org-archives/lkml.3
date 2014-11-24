Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbaKXPyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:54:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48974 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194AbaKXPys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:54:48 -0500
Date: Mon, 24 Nov 2014 16:54:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v4 5/5] x86, traps: Add ist_begin_non_atomic and
 ist_end_non_atomic
Message-ID: <20141124155444.GC20296@pd.tnic>
References: <cover.1416604491.git.luto@amacapital.net>
 <7ddd4ff60524d065af84b9d70b1128967b37fa7b.1416604491.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7ddd4ff60524d065af84b9d70b1128967b37fa7b.1416604491.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 01:26:11PM -0800, Andy Lutomirski wrote:
> In some IST handlers, if the interrupt came from user mode,
> we can safely enable preemption.  Add helpers to do it safely.
> 
> This is intended to be used my the memory failure code in
> do_machine_check.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  arch/x86/include/asm/traps.h |  2 ++
>  arch/x86/kernel/traps.c      | 38 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 40 insertions(+)
> 
> diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
> index eb16a61bfd06..04ba537fc721 100644
> --- a/arch/x86/include/asm/traps.h
> +++ b/arch/x86/include/asm/traps.h
> @@ -112,6 +112,8 @@ asmlinkage void mce_threshold_interrupt(void);
>  
>  extern enum ctx_state ist_enter(struct pt_regs *regs);
>  extern void ist_exit(struct pt_regs *regs, enum ctx_state prev_state);
> +extern void ist_begin_non_atomic(struct pt_regs *regs);
> +extern void ist_end_non_atomic(void);
>  
>  /* Interrupts/Exceptions */
>  enum {
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 6a02760df7b4..2b5f2e038e3f 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -140,6 +140,44 @@ void ist_exit(struct pt_regs *regs, enum ctx_state prev_state)
>  		rcu_nmi_exit();
>  }
>  
> +/**
> + * ist_begin_non_atomic() - begin a non-atomic section in an IST exception
> + * @regs:	regs passed to the IST exception handler
> + *
> + * IST exception handlers normally cannot schedule.  As a special
> + * exception, if the exception interrupted userspace code (i.e.
> + * user_mode_vm(regs) would return true) and the exception was not
> + * a double fault, it can be safe to schedule.  ist_begin_non_atomic()
> + * begins a non-atomic section within an ist_enter()/ist_exit() region.
> + * Callers are responsible for enabling interrupts themselves inside
> + * the non-atomic section, and callers must call is_end_non_atomic()
> + * before ist_exit().
> + */

Ok, I guess this is is fine, albeit a bit circumstantial:

I need to do

	ist_enter()
	ist_begin_non_atomic()

In here, I still need to do

	if (user_mode_vm()) {
		# do non-atomic stuff
	}

AFAICT, right?

	ist_end_non_atomic()
	ist_exit()

and this whole fun for the context tracking exception_enter/_exit()
calls.

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

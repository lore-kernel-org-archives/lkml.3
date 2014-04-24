Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbaDXL1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:27:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50174 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbaDXL06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:26:58 -0400
Date: Thu, 24 Apr 2014 13:26:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, seiji.aguchi@hds.com, keescook@chromium.org,
        masami.hiramatsu.pt@hitachi.com, akpm@linux-foundation.org,
        rostedt@goodmis.org, jlebon@redhat.com, tglx@linutronix.de, bp@suse.de
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/kprobes] kprobes/x86:  Call exception handlers directly
 from do_int3/do_debug
In-Reply-To: <tip-6f6343f53d133bae516caf3d254bce37d8774625@git.kernel.org>
Message-ID: <alpine.LNX.2.00.1404241326470.3265@pobox.suse.cz>
References: <20140417081733.26341.24423.stgit@ltc230.yrl.intra.hitachi.co.jp> <tip-6f6343f53d133bae516caf3d254bce37d8774625@git.kernel.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014, tip-bot for Masami Hiramatsu wrote:

> Commit-ID:  6f6343f53d133bae516caf3d254bce37d8774625
> Gitweb:     http://git.kernel.org/tip/6f6343f53d133bae516caf3d254bce37d8774625
> Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> AuthorDate: Thu, 17 Apr 2014 17:17:33 +0900
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Thu, 24 Apr 2014 10:02:59 +0200
> 
> kprobes/x86: Call exception handlers directly from do_int3/do_debug
> 
> To avoid a kernel crash by probing on lockdep code, call
> kprobe_int3_handler() and kprobe_debug_handler()(which was
> formerly called post_kprobe_handler()) directly from
> do_int3 and do_debug.
> 
> Currently kprobes uses notify_die() to hook the int3/debug
> exceptoins. Since there is a locking code in notify_die,
> the lockdep code can be invoked. And because the lockdep
> involves printk() related things, theoretically, we need to
> prohibit probing on such code, which means much longer blacklist
> we'll have. Instead, hooking the int3/debug for kprobes before
> notify_die() can avoid this problem.
> 
> Anyway, most of the int3 handlers in the kernel are already
> called from do_int3 directly, e.g. ftrace_int3_handler,
> poke_int3_handler, kgdb_ll_trap. Actually only
> kprobe_exceptions_notify is on the notifier_call_chain.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Jiri Kosina <jkosina@suse.cz>

Reviewed-by: Jiri Kosina <jkosina@suse.cz>

> Cc: Jonathan Lebon <jlebon@redhat.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Seiji Aguchi <seiji.aguchi@hds.com>
> Link: http://lkml.kernel.org/r/20140417081733.26341.24423.stgit@ltc230.yrl.intra.hitachi.co.jp
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/include/asm/kprobes.h |  2 ++
>  arch/x86/kernel/kprobes/core.c | 24 +++---------------------
>  arch/x86/kernel/traps.c        | 10 ++++++++++
>  3 files changed, 15 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
> index 9454c16..53cdfb2 100644
> --- a/arch/x86/include/asm/kprobes.h
> +++ b/arch/x86/include/asm/kprobes.h
> @@ -116,4 +116,6 @@ struct kprobe_ctlblk {
>  extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
>  extern int kprobe_exceptions_notify(struct notifier_block *self,
>  				    unsigned long val, void *data);
> +extern int kprobe_int3_handler(struct pt_regs *regs);
> +extern int kprobe_debug_handler(struct pt_regs *regs);
>  #endif /* _ASM_X86_KPROBES_H */
> diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
> index 7751b3d..9b80aec 100644
> --- a/arch/x86/kernel/kprobes/core.c
> +++ b/arch/x86/kernel/kprobes/core.c
> @@ -559,7 +559,7 @@ reenter_kprobe(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb
>   * Interrupts are disabled on entry as trap3 is an interrupt gate and they
>   * remain disabled throughout this function.
>   */
> -static int __kprobes kprobe_handler(struct pt_regs *regs)
> +int __kprobes kprobe_int3_handler(struct pt_regs *regs)
>  {
>  	kprobe_opcode_t *addr;
>  	struct kprobe *p;
> @@ -857,7 +857,7 @@ no_change:
>   * Interrupts are disabled on entry as trap1 is an interrupt gate and they
>   * remain disabled throughout this function.
>   */
> -static int __kprobes post_kprobe_handler(struct pt_regs *regs)
> +int __kprobes kprobe_debug_handler(struct pt_regs *regs)
>  {
>  	struct kprobe *cur = kprobe_running();
>  	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
> @@ -963,22 +963,7 @@ kprobe_exceptions_notify(struct notifier_block *self, unsigned long val, void *d
>  	if (args->regs && user_mode_vm(args->regs))
>  		return ret;
>  
> -	switch (val) {
> -	case DIE_INT3:
> -		if (kprobe_handler(args->regs))
> -			ret = NOTIFY_STOP;
> -		break;
> -	case DIE_DEBUG:
> -		if (post_kprobe_handler(args->regs)) {
> -			/*
> -			 * Reset the BS bit in dr6 (pointed by args->err) to
> -			 * denote completion of processing
> -			 */
> -			(*(unsigned long *)ERR_PTR(args->err)) &= ~DR_STEP;
> -			ret = NOTIFY_STOP;
> -		}
> -		break;
> -	case DIE_GPF:
> +	if (val == DIE_GPF) {
>  		/*
>  		 * To be potentially processing a kprobe fault and to
>  		 * trust the result from kprobe_running(), we have
> @@ -987,9 +972,6 @@ kprobe_exceptions_notify(struct notifier_block *self, unsigned long val, void *d
>  		if (!preemptible() && kprobe_running() &&
>  		    kprobe_fault_handler(args->regs, args->trapnr))
>  			ret = NOTIFY_STOP;
> -		break;
> -	default:
> -		break;
>  	}
>  	return ret;
>  }
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 57409f6..e5d4a70 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -334,6 +334,11 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
>  		goto exit;
>  #endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
>  
> +#ifdef CONFIG_KPROBES
> +	if (kprobe_int3_handler(regs))
> +		return;
> +#endif
> +
>  	if (notify_die(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
>  			SIGTRAP) == NOTIFY_STOP)
>  		goto exit;
> @@ -440,6 +445,11 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>  	/* Store the virtualized DR6 value */
>  	tsk->thread.debugreg6 = dr6;
>  
> +#ifdef CONFIG_KPROBES
> +	if (kprobe_debug_handler(regs))
> +		goto exit;
> +#endif
> +
>  	if (notify_die(DIE_DEBUG, "debug", regs, (long)&dr6, error_code,
>  							SIGTRAP) == NOTIFY_STOP)
>  		goto exit;
> 

-- 
Jiri Kosina
SUSE Labs

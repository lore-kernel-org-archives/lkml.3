Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaCVBFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 21:05:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:30925 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750994AbaCVBFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 21:05:11 -0400
Date: Fri, 21 Mar 2014 21:05:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip v8 08/26] kprobes/x86: Call exception handlers
 directly from do_int3/do_debug
Message-ID: <20140321210508.358c30ee@gandalf.local.home>
In-Reply-To: <20140305115939.22766.21199.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140305115939.22766.21199.stgit@ltc230.yrl.intra.hitachi.co.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2014 20:59:39 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> To avoid a kernel crash by probing on lockdep code, call
> kprobe_int3_handler and kprobe_debug_handler directly
> from do_int3 and do_debug. Since there is a locking code
> in notify_die, lockdep code can be invoked. And because
> the lockdep involves printk() related things, theoretically,
> we need to prohibit probing on much more code...
> 
> Anyway, most of the int3 handlers in the kernel are already
> called from do_int3 directly, e.g. ftrace_int3_handler,
> poke_int3_handler, kgdb_ll_trap. Actually only
> kprobe_exceptions_notify is on the notifier_call_chain.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Sasha Levin <sasha.levin@oracle.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Seiji Aguchi <seiji.aguchi@hds.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  arch/x86/include/asm/kprobes.h |    2 ++
>  arch/x86/kernel/kprobes/core.c |   24 +++---------------------
>  arch/x86/kernel/traps.c        |   10 ++++++++++
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
> index 4708d6e..566958e 100644
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
> @@ -960,22 +960,7 @@ kprobe_exceptions_notify(struct notifier_block *self, unsigned long val, void *d
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

The DIE_DEBUG case is removed but not added anyplace else. The change
log doesn't say why this was removed.

-- Steve

> -		break;
> -	case DIE_GPF:
> +	if (val == DIE_GPF) {
>  		/*
>  		 * To be potentially processing a kprobe fault and to
>  		 * trust the result from kprobe_running(), we have
> @@ -984,9 +969,6 @@ kprobe_exceptions_notify(struct notifier_block *self, unsigned long val, void *d
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


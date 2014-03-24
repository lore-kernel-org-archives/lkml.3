Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbaCXTqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:46:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:51893 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754272AbaCXTpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:45:20 -0400
Date: Mon, 24 Mar 2014 15:45:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Oleg Nesterov <oleg@redhat.com>, fche@redhat.com, mingo@redhat.com,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>, systemtap@sourceware.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH -tip v8 14/26] x86: Use NOKPROBE_SYMBOL() instead of
 __kprobes annotation
Message-ID: <20140324154518.77096045@gandalf.local.home>
In-Reply-To: <20140305120021.22766.59.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<20140305120021.22766.59.stgit@ltc230.yrl.intra.hitachi.co.jp>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2014 21:00:21 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
  
>  /*
>   * This is gone through when something in the kernel has done something bad
> diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
> index ae5aafb..d00103a 100644
> --- a/arch/x86/kernel/kprobes/core.c
> +++ b/arch/x86/kernel/kprobes/core.c
> @@ -112,7 +112,8 @@ struct kretprobe_blackpoint kretprobe_blacklist[] = {
>  
>  const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
>  
> -static void __kprobes __synthesize_relative_insn(void *from, void *to, u8 op)
> +static nokprobe_inline
> +void __synthesize_relative_insn(void *from, void *to, u8 op)

I believe the proper way to break this up is:

static nokprobe_inline void
__synthesize_relative_insn(...)


  
> -static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
> +static nokprobe_inline
> +void save_previous_kprobe(struct kprobe_ctlblk *kcb)

Here too.

>  {
>  	kcb->prev_kprobe.kp = kprobe_running();
>  	kcb->prev_kprobe.status = kcb->kprobe_status;
> @@ -433,7 +438,8 @@ static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
>  	kcb->prev_kprobe.saved_flags = kcb->kprobe_saved_flags;
>  }
>  
> -static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
> +static nokprobe_inline
> +void restore_previous_kprobe(struct kprobe_ctlblk *kcb)

and again.

>  {
>  	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
>  	kcb->kprobe_status = kcb->prev_kprobe.status;
> @@ -441,8 +447,9 @@ static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
>  	kcb->kprobe_saved_flags = kcb->prev_kprobe.saved_flags;
>  }
>  
> -static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
> -				struct kprobe_ctlblk *kcb)
> +static nokprobe_inline
> +void set_current_kprobe(struct kprobe *p, struct pt_regs *regs,

and again.

> +			struct kprobe_ctlblk *kcb)
>  {
>  	__this_cpu_write(current_kprobe, p);
>  	kcb->kprobe_saved_flags = kcb->kprobe_old_flags
> @@ -451,7 +458,7 @@ static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
>  		kcb->kprobe_saved_flags &= ~X86_EFLAGS_IF;
>  }



> diff --git a/arch/x86/kernel/kprobes/ftrace.c b/arch/x86/kernel/kprobes/ftrace.c
> index dcaa131..717b02a 100644
> --- a/arch/x86/kernel/kprobes/ftrace.c
> +++ b/arch/x86/kernel/kprobes/ftrace.c
> @@ -25,8 +25,9 @@
>  
>  #include "common.h"
>  
> -static int __skip_singlestep(struct kprobe *p, struct pt_regs *regs,
> -			     struct kprobe_ctlblk *kcb)
> +static nokprobe_inline
> +int __skip_singlestep(struct kprobe *p, struct pt_regs *regs,

Here too.

> +		      struct kprobe_ctlblk *kcb)
>  {
>  	/*
>  	 * Emulate singlestep (and also recover regs->ip)
> @@ -41,18 +42,19 @@ static int __skip_singlestep(struct kprobe *p, struct pt_regs *regs,
>  	return 1;
>  }
>  



> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index ba9abe9..3c8ae7d 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -106,7 +106,7 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
>  	preempt_count_dec();
>  }
>  
> -static int __kprobes
> +static nokprobe_inline int
>  do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,

Here you do it correctly :-)

>  		  struct pt_regs *regs,	long error_code)
>  {
> @@ -136,7 +136,7 @@ do_trap_no_signal(struct task_struct *tsk, int trapnr, char *str,
>  	return -1;
>  }
>  


-- Steve


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaFMROI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:14:08 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:35679 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbaFMROE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:14:04 -0400
MIME-Version: 1.0
In-Reply-To: <tip-ecd50f714c421c759354632dd00f70c718c95b10@git.kernel.org>
References: <20140417081740.26341.10894.stgit@ltc230.yrl.intra.hitachi.co.jp>
	<tip-ecd50f714c421c759354632dd00f70c718c95b10@git.kernel.org>
Date: Fri, 13 Jun 2014 19:14:02 +0200
Message-ID: <CAFTL4hyYa7=h3DE+kkpNpWxp4VtaJ07tkkj96W+ZAmKtZD+pkA@mail.gmail.com>
Subject: Re: [tip:perf/kprobes] kprobes, x86: Call exception_enter after
 kprobes handled
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>, seiji.aguchi@hds.com,
        Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

2014-04-24 12:59 GMT+02:00 tip-bot for Masami Hiramatsu <tipbot@zytor.com>:
> Commit-ID:  ecd50f714c421c759354632dd00f70c718c95b10
> Gitweb:     http://git.kernel.org/tip/ecd50f714c421c759354632dd00f70c718c95b10
> Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> AuthorDate: Thu, 17 Apr 2014 17:17:40 +0900
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Thu, 24 Apr 2014 10:03:00 +0200
>
> kprobes, x86: Call exception_enter after kprobes handled
>
> Move exception_enter() call after kprobes handler
> is done. Since the exception_enter() involves
> many other functions (like printk), it can cause
> recursive int3/break loop when kprobes probe such
> functions.
>
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Seiji Aguchi <seiji.aguchi@hds.com>
> Link: http://lkml.kernel.org/r/20140417081740.26341.10894.stgit@ltc230.yrl.intra.hitachi.co.jp
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

This patch results in exception_enter/exception_exit imbalances:

arch/x86/kernel/traps.c: In function ‘do_debug’:
include/linux/context_tracking.h:46:6: warning: ‘prev_state’ may be
used uninitialized in this function [-Wmaybe-uninitialized]
   if (prev_ctx == IN_USER)
      ^
arch/x86/kernel/traps.c:431:17: note: ‘prev_state’ was declared here
  enum ctx_state prev_state;

An obvious solution would be to change all the goto exit before
exception_enter() to return from do_debug(). But if there are any user
of RCU before exception_enter() this won't work. Does
kprobe_debug_handle() use RCU read side critical sections? I'm also
worried about kmemcheck...

> ---
>  arch/x86/kernel/traps.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index e5d4a70..ba9abe9 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -327,7 +327,6 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
>         if (poke_int3_handler(regs))
>                 return;
>
> -       prev_state = exception_enter();
>  #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
>         if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
>                                 SIGTRAP) == NOTIFY_STOP)
> @@ -338,6 +337,7 @@ dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_co
>         if (kprobe_int3_handler(regs))
>                 return;
>  #endif
> +       prev_state = exception_enter();
>
>         if (notify_die(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
>                         SIGTRAP) == NOTIFY_STOP)
> @@ -415,8 +415,6 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>         unsigned long dr6;
>         int si_code;
>
> -       prev_state = exception_enter();
> -
>         get_debugreg(dr6, 6);
>
>         /* Filter out all the reserved bits which are preset to 1 */
> @@ -449,6 +447,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
>         if (kprobe_debug_handler(regs))
>                 goto exit;
>  #endif
> +       prev_state = exception_enter();
>
>         if (notify_die(DIE_DEBUG, "debug", regs, (long)&dr6, error_code,
>                                                         SIGTRAP) == NOTIFY_STOP)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tip-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

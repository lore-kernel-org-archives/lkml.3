Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631AbaDINyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:54:18 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:37539 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933143AbaDINyP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:54:15 -0400
Date: Wed, 9 Apr 2014 09:54:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix: sparse warnings in tracepoint.c
Message-ID: <20140409095412.74c4d3de@gandalf.local.home>
In-Reply-To: <1397049883-28692-1-git-send-email-mathieu.desnoyers@efficios.com>
References: <1397049883-28692-1-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Apr 2014 09:24:43 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Fix the following sparse warnings:
> 
>   CHECK   kernel/tracepoint.c
> kernel/tracepoint.c:184:18: warning: incorrect type in assignment (different address spaces)
> kernel/tracepoint.c:184:18:    expected struct tracepoint_func *tp_funcs
> kernel/tracepoint.c:184:18:    got struct tracepoint_func [noderef] <asn:4>*funcs
> kernel/tracepoint.c:216:18: warning: incorrect type in assignment (different address spaces)
> kernel/tracepoint.c:216:18:    expected struct tracepoint_func *tp_funcs
> kernel/tracepoint.c:216:18:    got struct tracepoint_func [noderef] <asn:4>*funcs
> kernel/tracepoint.c:392:24: error: return expression in void function
>   CC      kernel/tracepoint.o
> kernel/tracepoint.c: In function ‘tracepoint_module_going’:
> kernel/tracepoint.c:392:3: warning: ‘return’ with a value, in function returning void [enabled by default]
> kernel/tracepoint.c:491:6: warning: symbol 'syscall_regfunc' was not declared. Should it be static?
> kernel/tracepoint.c:508:6: warning: symbol 'syscall_unregfunc' was not declared. Should it be static?

Hmm, I push yesterday and haven't seen any sparse warnings yet.

> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/tracepoint.h      |    5 +++++
>  include/trace/events/syscalls.h |    3 ---
>  kernel/tracepoint.c             |    8 +++++---
>  3 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index 08150e2..abab285 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -81,6 +81,11 @@ static inline void tracepoint_synchronize_unregister(void)
>  	synchronize_sched();
>  }
>  
> +#ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
> +extern void syscall_regfunc(void);
> +extern void syscall_unregfunc(void);
> +#endif /* CONFIG_HAVE_SYSCALL_TRACEPOINTS */
> +
>  #define PARAMS(args...) args
>  
>  #endif /* _LINUX_TRACEPOINT_H */
> diff --git a/include/trace/events/syscalls.h b/include/trace/events/syscalls.h
> index 5a4c04a..14e49c7 100644
> --- a/include/trace/events/syscalls.h
> +++ b/include/trace/events/syscalls.h
> @@ -13,9 +13,6 @@
>  
>  #ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
>  
> -extern void syscall_regfunc(void);
> -extern void syscall_unregfunc(void);
> -
>  TRACE_EVENT_FN(sys_enter,
>  
>  	TP_PROTO(struct pt_regs *regs, long id),
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 8c4f2f4..f39bb79 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -181,7 +181,8 @@ static int tracepoint_add_func(struct tracepoint *tp,
>  	if (tp->regfunc && !static_key_enabled(&tp->key))
>  		tp->regfunc();
>  
> -	tp_funcs = tp->funcs;
> +	tp_funcs = rcu_dereference_protected(tp->funcs,
> +			lockdep_is_held(&tracepoints_mutex));
>  	old = func_add(&tp_funcs, func);
>  	if (IS_ERR(old)) {
>  		WARN_ON_ONCE(1);
> @@ -213,7 +214,8 @@ static int tracepoint_remove_func(struct tracepoint *tp,
>  {
>  	struct tracepoint_func *old, *tp_funcs;
>  
> -	tp_funcs = tp->funcs;
> +	tp_funcs = rcu_dereference_protected(tp->funcs,
> +			lockdep_is_held(&tracepoints_mutex));
>  	old = func_remove(&tp_funcs, func);
>  	if (IS_ERR(old)) {
>  		WARN_ON_ONCE(1);
> @@ -389,7 +391,7 @@ static void tracepoint_module_going(struct module *mod)
>  	struct tp_module *tp_mod;
>  
>  	if (!mod->num_tracepoints)
> -		return 0;
> +		return;

My tests caught this, and fixed it manually (noting I did so in the
change log). I wanted to get this finished, and such a slight change
didn't require asking you to resubmit again ;-)

I'll pull in the rest of this and start testing it. I'll push what I
have to Linux next now.

-- Steve

>  
>  	mutex_lock(&tracepoint_module_list_mutex);
>  	list_for_each_entry(tp_mod, &tracepoint_module_list, list) {


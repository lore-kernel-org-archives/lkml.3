Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab3LLBel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 20:34:41 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:32168 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751203Ab3LLBej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 20:34:39 -0500
Date: Wed, 11 Dec 2013 20:34:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-arch@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v5.1 12/18] ftrace/kprobes: Use NOKPROBE_SYMBOL
 macro in ftrace
Message-ID: <20131211203435.43531ca5@gandalf.local.home>
In-Reply-To: <20131210095714.8225.57495.stgit@kbuild-fedora.novalocal>
References: <20131209120450.4da43296@gandalf.local.home>
	<20131210095714.8225.57495.stgit@kbuild-fedora.novalocal>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013 09:57:14 +0000
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:


> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -51,45 +51,45 @@ struct event_file_link {
>  	(sizeof(struct probe_arg) * (n)))
>  
>  
> -static __kprobes bool trace_probe_is_return(struct trace_probe *tp)
> +static __always_inline bool trace_probe_is_return(struct trace_probe *tp)

I wonder if we should have a comment somewhere explaining why we are
using __always_inline.  Maybe we should add a new annotation:

#define kprobes_inline   __always_inline

?

The above would be self documenting, and we can also include a comment
with the define that states why it is there. Otherwise 10 years from
now, someone is going to see these and say "WTF!" and remove them.

>  {
>  	return tp->rp.handler != NULL;
>  }
>  
> -static __kprobes const char *trace_probe_symbol(struct trace_probe *tp)
> +static __always_inline const char *trace_probe_symbol(struct trace_probe *tp)
>  {
>  	return tp->symbol ? tp->symbol : "unknown";
>  }
>  
> -static __kprobes unsigned long trace_probe_offset(struct trace_probe *tp)
> +static __always_inline unsigned long trace_probe_offset(struct trace_probe *tp)
>  {
>  	return tp->rp.kp.offset;
>  }
>  
> -static __kprobes bool trace_probe_is_enabled(struct trace_probe *tp)
> +static __always_inline bool trace_probe_is_enabled(struct trace_probe *tp)
>  {
>  	return !!(tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE));
>  }
>  
> -static __kprobes bool trace_probe_is_registered(struct trace_probe *tp)
> +static __always_inline bool trace_probe_is_registered(struct trace_probe *tp)
>  {
>  	return !!(tp->flags & TP_FLAG_REGISTERED);
>  }
>  
> -static __kprobes bool trace_probe_has_gone(struct trace_probe *tp)
> +static __always_inline bool trace_probe_has_gone(struct trace_probe *tp)
>  {
>  	return !!(kprobe_gone(&tp->rp.kp));
>  }
>  
> -static __kprobes bool trace_probe_within_module(struct trace_probe *tp,
> -						struct module *mod)
> +static __always_inline bool trace_probe_within_module(struct trace_probe *tp,
> +						      struct module *mod)
>  {
>  	int len = strlen(mod->name);
>  	const char *name = trace_probe_symbol(tp);
>  	return strncmp(mod->name, name, len) == 0 && name[len] == ':';
>  }
>  
> -static __kprobes bool trace_probe_is_on_module(struct trace_probe *tp)
> +static __always_inline bool trace_probe_is_on_module(struct trace_probe *tp)
>  {
>  	return !!strchr(trace_probe_symbol(tp), ':');
>  }
> @@ -755,8 +755,8 @@ static const struct file_operations kprobe_profile_ops = {
>  };
>  
>  /* Sum up total data length for dynamic arraies (strings) */
> -static __kprobes int __get_data_size(struct trace_probe *tp,
> -				     struct pt_regs *regs)
> +static __always_inline
> +int __get_data_size(struct trace_probe *tp, struct pt_regs *regs)

This function is used 4 times within the file and is not that small. I
think it's a bit too big for an inline, and qualifies for a normal
function with a NOKPROBE_SYMBOL() attached. 

>  {
>  	int i, ret = 0;
>  	u32 len;
> @@ -771,9 +771,9 @@ static __kprobes int __get_data_size(struct trace_probe *tp,
>  }
>  
>  /* Store the value of each argument */
> -static __kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
> -				       struct pt_regs *regs,
> -				       u8 *data, int maxlen)
> +static __always_inline
> +void store_trace_args(int ent_size, struct trace_probe *tp,
> +		      struct pt_regs *regs, u8 *data, int maxlen)

Same here (even more so!)

>  {
>  	int i;
>  	u32 end = tp->size;
> @@ -803,7 +803,7 @@ static __kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
>  }
>  
>  /* Kprobe handler */
> -static __kprobes void
> +static __always_inline void
>  __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
>  		    struct ftrace_event_file *ftrace_file)

OK, this one is big, but it's only used once.

-- Steve

>  {
> @@ -840,7 +840,7 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
>  						irq_flags, pc, regs);
>  }
>  
> -static __kprobes void
> +static void
>  kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs)
>  {
>  	struct event_file_link *link;
> @@ -848,9 +848,10 @@ kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs)
>  	list_for_each_entry_rcu(link, &tp->files, list)
>  		__kprobe_trace_func(tp, regs, link->file);
>  }
> +NOKPROBE_SYMBOL(kprobe_trace_func);
>  
>  /* Kretprobe handler */
> -static __kprobes void
> +static __always_inline void
>  __kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
>  		       struct pt_regs *regs,
>  		       struct ftrace_event_file *ftrace_file)
> @@ -889,7 +890,7 @@ __kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
>  						irq_flags, pc, regs);
>  }
>  
> -static __kprobes void
> +static void
>  kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
>  		     struct pt_regs *regs)
>  {
> @@ -898,6 +899,7 @@ kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
>  	list_for_each_entry_rcu(link, &tp->files, list)
>  		__kretprobe_trace_func(tp, ri, regs, link->file);
>  }
> +NOKPROBE_SYMBOL(kretprobe_trace_func);
>  
>  /* Event entry printers */
>  static enum print_line_t
> @@ -1086,7 +1088,7 @@ static int set_print_fmt(struct trace_probe *tp)
>  #ifdef CONFIG_PERF_EVENTS
>  
>  /* Kprobe profile handler */
> -static __kprobes void
> +static void
>  kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
>  {
>  	struct ftrace_event_call *call = &tp->call;
> @@ -1113,9 +1115,10 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
>  	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
>  	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
>  }
> +NOKPROBE_SYMBOL(kprobe_perf_func);
>  
>  /* Kretprobe profile handler */
> -static __kprobes void
> +static void
>  kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
>  		    struct pt_regs *regs)
>  {
> @@ -1143,6 +1146,7 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
>  	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
>  	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
>  }
> +NOKPROBE_SYMBOL(kretprobe_perf_func);
>  #endif	/* CONFIG_PERF_EVENTS */
>  
>  /*
> @@ -1179,8 +1183,7 @@ int kprobe_register(struct ftrace_event_call *event,
>  	return 0;
>  }
>  
> -static __kprobes
> -int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
> +static int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
>  {
>  	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
>  
> @@ -1194,8 +1197,9 @@ int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
>  #endif
>  	return 0;	/* We don't tweek kernel, so just return 0 */
>  }
> +NOKPROBE_SYMBOL(kprobe_dispatcher);
>  
> -static __kprobes
> +static
>  int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
>  {
>  	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
> @@ -1210,6 +1214,7 @@ int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
>  #endif
>  	return 0;	/* We don't tweek kernel, so just return 0 */
>  }
> +NOKPROBE_SYMBOL(kretprobe_dispatcher);
>  
>  static struct trace_event_functions kretprobe_funcs = {
>  	.trace		= print_kretprobe_event

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3HEGqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 02:46:22 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41059 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab3HEGqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 02:46:20 -0400
Message-ID: <51FF4A34.1000400@hitachi.com>
Date: Mon, 05 Aug 2013 15:46:12 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 07/13] tracing/kprobes: Remove duplicate set_print_fmt()
References: <1375261410-11219-1-git-send-email-namhyung@kernel.org> <1375261410-11219-8-git-send-email-namhyung@kernel.org>
In-Reply-To: <1375261410-11219-8-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove? or Integrate? :)

(2013/07/31 18:03), Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The set_print_fmt() functions are implemented almost same for
> [ku]probes.  Move it to a common place and get rid of the duplication.

Anyway this looks good for me;)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/trace_kprobe.c | 63 +--------------------------------------------
>  kernel/trace/trace_probe.c  | 62 ++++++++++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_probe.h  |  1 +
>  kernel/trace/trace_uprobe.c | 55 +--------------------------------------
>  4 files changed, 65 insertions(+), 116 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index d4c10fb8b8f8..40018618cc08 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -1069,67 +1069,6 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
>  	return 0;
>  }
>  
> -static int __set_print_fmt(struct trace_kprobe *tp, char *buf, int len)
> -{
> -	int i;
> -	int pos = 0;
> -
> -	const char *fmt, *arg;
> -
> -	if (!trace_kprobe_is_return(tp)) {
> -		fmt = "(%lx)";
> -		arg = "REC->" FIELD_STRING_IP;
> -	} else {
> -		fmt = "(%lx <- %lx)";
> -		arg = "REC->" FIELD_STRING_FUNC ", REC->" FIELD_STRING_RETIP;
> -	}
> -
> -	/* When len=0, we just calculate the needed length */
> -#define LEN_OR_ZERO (len ? len - pos : 0)
> -
> -	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"%s", fmt);
> -
> -	for (i = 0; i < tp->p.nr_args; i++) {
> -		pos += snprintf(buf + pos, LEN_OR_ZERO, " %s=%s",
> -				tp->p.args[i].name, tp->p.args[i].type->fmt);
> -	}
> -
> -	pos += snprintf(buf + pos, LEN_OR_ZERO, "\", %s", arg);
> -
> -	for (i = 0; i < tp->p.nr_args; i++) {
> -		if (strcmp(tp->p.args[i].type->name, "string") == 0)
> -			pos += snprintf(buf + pos, LEN_OR_ZERO,
> -					", __get_str(%s)",
> -					tp->p.args[i].name);
> -		else
> -			pos += snprintf(buf + pos, LEN_OR_ZERO, ", REC->%s",
> -					tp->p.args[i].name);
> -	}
> -
> -#undef LEN_OR_ZERO
> -
> -	/* return the length of print_fmt */
> -	return pos;
> -}
> -
> -static int set_print_fmt(struct trace_kprobe *tp)
> -{
> -	int len;
> -	char *print_fmt;
> -
> -	/* First: called with 0 length to calculate the needed length */
> -	len = __set_print_fmt(tp, NULL, 0);
> -	print_fmt = kmalloc(len + 1, GFP_KERNEL);
> -	if (!print_fmt)
> -		return -ENOMEM;
> -
> -	/* Second: actually write the @print_fmt */
> -	__set_print_fmt(tp, print_fmt, len + 1);
> -	tp->p.call.print_fmt = print_fmt;
> -
> -	return 0;
> -}
> -
>  #ifdef CONFIG_PERF_EVENTS
>  
>  /* Kprobe profile handler */
> @@ -1280,7 +1219,7 @@ static int register_probe_event(struct trace_kprobe *tp)
>  		call->event.funcs = &kprobe_funcs;
>  		call->class->define_fields = kprobe_event_define_fields;
>  	}
> -	if (set_print_fmt(tp) < 0)
> +	if (set_print_fmt(&tp->p, trace_kprobe_is_return(tp)) < 0)
>  		return -ENOMEM;
>  	ret = register_ftrace_event(&call->event);
>  	if (!ret) {
> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> index 5e491d82b6ad..76ab02143b5a 100644
> --- a/kernel/trace/trace_probe.c
> +++ b/kernel/trace/trace_probe.c
> @@ -747,3 +747,65 @@ __kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
>  				   data + tp->args[i].offset);
>  	}
>  }
> +
> +static int __set_print_fmt(struct trace_probe *tp, char *buf, int len,
> +			   bool is_return)
> +{
> +	int i;
> +	int pos = 0;
> +
> +	const char *fmt, *arg;
> +
> +	if (!is_return) {
> +		fmt = "(%lx)";
> +		arg = "REC->" FIELD_STRING_IP;
> +	} else {
> +		fmt = "(%lx <- %lx)";
> +		arg = "REC->" FIELD_STRING_FUNC ", REC->" FIELD_STRING_RETIP;
> +	}
> +
> +	/* When len=0, we just calculate the needed length */
> +#define LEN_OR_ZERO (len ? len - pos : 0)
> +
> +	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"%s", fmt);
> +
> +	for (i = 0; i < tp->nr_args; i++) {
> +		pos += snprintf(buf + pos, LEN_OR_ZERO, " %s=%s",
> +				tp->args[i].name, tp->args[i].type->fmt);
> +	}
> +
> +	pos += snprintf(buf + pos, LEN_OR_ZERO, "\", %s", arg);
> +
> +	for (i = 0; i < tp->nr_args; i++) {
> +		if (strcmp(tp->args[i].type->name, "string") == 0)
> +			pos += snprintf(buf + pos, LEN_OR_ZERO,
> +					", __get_str(%s)",
> +					tp->args[i].name);
> +		else
> +			pos += snprintf(buf + pos, LEN_OR_ZERO, ", REC->%s",
> +					tp->args[i].name);
> +	}
> +
> +#undef LEN_OR_ZERO
> +
> +	/* return the length of print_fmt */
> +	return pos;
> +}
> +
> +int set_print_fmt(struct trace_probe *tp, bool is_return)
> +{
> +	int len;
> +	char *print_fmt;
> +
> +	/* First: called with 0 length to calculate the needed length */
> +	len = __set_print_fmt(tp, NULL, 0, is_return);
> +	print_fmt = kmalloc(len + 1, GFP_KERNEL);
> +	if (!print_fmt)
> +		return -ENOMEM;
> +
> +	/* Second: actually write the @print_fmt */
> +	__set_print_fmt(tp, print_fmt, len + 1, is_return);
> +	tp->call.print_fmt = print_fmt;
> +
> +	return 0;
> +}
> diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
> index 888cd7d4cd3c..ec18e1b1487e 100644
> --- a/kernel/trace/trace_probe.h
> +++ b/kernel/trace/trace_probe.h
> @@ -301,3 +301,4 @@ extern int traceprobe_command(const char *buf, int (*createfn)(int, char**));
>  extern int __get_data_size(struct trace_probe *tp, struct pt_regs *regs);
>  extern void store_trace_args(int ent_size, struct trace_probe *tp,
>  			     struct pt_regs *regs, u8 *data, int maxlen);
> +extern int set_print_fmt(struct trace_probe *tp, bool is_return);
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index cbb2ad76fd8c..bcc7bd300c99 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -661,59 +661,6 @@ static int uprobe_event_define_fields(struct ftrace_event_call *event_call)
>  	return 0;
>  }
>  
> -#define LEN_OR_ZERO		(len ? len - pos : 0)
> -static int __set_print_fmt(struct trace_uprobe *tu, char *buf, int len)
> -{
> -	const char *fmt, *arg;
> -	int i;
> -	int pos = 0;
> -
> -	if (is_ret_probe(tu)) {
> -		fmt = "(%lx <- %lx)";
> -		arg = "REC->" FIELD_STRING_FUNC ", REC->" FIELD_STRING_RETIP;
> -	} else {
> -		fmt = "(%lx)";
> -		arg = "REC->" FIELD_STRING_IP;
> -	}
> -
> -	/* When len=0, we just calculate the needed length */
> -
> -	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"%s", fmt);
> -
> -	for (i = 0; i < tu->p.nr_args; i++) {
> -		pos += snprintf(buf + pos, LEN_OR_ZERO, " %s=%s",
> -				tu->p.args[i].name, tu->p.args[i].type->fmt);
> -	}
> -
> -	pos += snprintf(buf + pos, LEN_OR_ZERO, "\", %s", arg);
> -
> -	for (i = 0; i < tu->p.nr_args; i++) {
> -		pos += snprintf(buf + pos, LEN_OR_ZERO, ", REC->%s",
> -				tu->p.args[i].name);
> -	}
> -
> -	return pos;	/* return the length of print_fmt */
> -}
> -#undef LEN_OR_ZERO
> -
> -static int set_print_fmt(struct trace_uprobe *tu)
> -{
> -	char *print_fmt;
> -	int len;
> -
> -	/* First: called with 0 length to calculate the needed length */
> -	len = __set_print_fmt(tu, NULL, 0);
> -	print_fmt = kmalloc(len + 1, GFP_KERNEL);
> -	if (!print_fmt)
> -		return -ENOMEM;
> -
> -	/* Second: actually write the @print_fmt */
> -	__set_print_fmt(tu, print_fmt, len + 1);
> -	tu->p.call.print_fmt = print_fmt;
> -
> -	return 0;
> -}
> -
>  #ifdef CONFIG_PERF_EVENTS
>  static bool
>  __uprobe_perf_filter(struct trace_uprobe_filter *filter, struct mm_struct *mm)
> @@ -945,7 +892,7 @@ static int register_uprobe_event(struct trace_uprobe *tu)
>  	call->event.funcs = &uprobe_funcs;
>  	call->class->define_fields = uprobe_event_define_fields;
>  
> -	if (set_print_fmt(tu) < 0)
> +	if (set_print_fmt(&tu->p, is_ret_probe(tu)) < 0)
>  		return -ENOMEM;
>  
>  	ret = register_ftrace_event(&call->event);
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



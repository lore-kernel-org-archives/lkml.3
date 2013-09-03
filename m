Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759756Ab3ICJsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 05:48:50 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:43121 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab3ICJss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 05:48:48 -0400
Message-ID: <5225B07C.9020102@hitachi.com>
Date: Tue, 03 Sep 2013 18:48:44 +0900
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
Subject: Re: [PATCH 13/13] tracing/uprobes: Add support for full argument
 access methods
References: <1378187054-27401-1-git-send-email-namhyung@kernel.org> <1378187054-27401-14-git-send-email-namhyung@kernel.org>
In-Reply-To: <1378187054-27401-14-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/09/03 14:44), Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Enable to fetch other types of argument for the uprobes.  IOW, we can
> access stack, memory, deref, bitfield and retval from uprobes now.
> 
> The format for the argument types are same as kprobes (but @SYMBOL
> type is not supported for uprobes), i.e:
> 
>   @ADDR   : Fetch memory at ADDR
>   $stackN : Fetch Nth entry of stack (N >= 0)
>   $stack  : Fetch stack address
>   $retval : Fetch return value
>   +|-offs(FETCHARG) : Fetch memory at FETCHARG +|- offs address
> 
> Note that the retval only can be used with uretprobes.

Look good for me :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> 
> Original-patch-by: Hyeoncheol Lee <cheol.lee@lge.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  Documentation/trace/uprobetracer.txt | 25 +++++++++++++++++++++++++
>  kernel/trace/trace_probe.c           | 36 +++++++++++++++++++++++-------------
>  2 files changed, 48 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/trace/uprobetracer.txt b/Documentation/trace/uprobetracer.txt
> index 8f1a8b8956fc..6e5cff263e2b 100644
> --- a/Documentation/trace/uprobetracer.txt
> +++ b/Documentation/trace/uprobetracer.txt
> @@ -31,6 +31,31 @@ Synopsis of uprobe_tracer
>  
>    FETCHARGS     : Arguments. Each probe can have up to 128 args.
>     %REG         : Fetch register REG
> +   @ADDR	: Fetch memory at ADDR (ADDR should be in userspace)
> +   $stackN	: Fetch Nth entry of stack (N >= 0)
> +   $stack	: Fetch stack address.
> +   $retval	: Fetch return value.(*)
> +   +|-offs(FETCHARG) : Fetch memory at FETCHARG +|- offs address.(**)
> +   NAME=FETCHARG     : Set NAME as the argument name of FETCHARG.
> +   FETCHARG:TYPE     : Set TYPE as the type of FETCHARG. Currently, basic types
> +		       (u8/u16/u32/u64/s8/s16/s32/s64), "string" and bitfield
> +		       are supported.
> +
> +  (*) only for return probe.
> +  (**) this is useful for fetching a field of data structures.
> +
> +Types
> +-----
> +Several types are supported for fetch-args. Uprobe tracer will access memory
> +by given type. Prefix 's' and 'u' means those types are signed and unsigned
> +respectively. Traced arguments are shown in decimal (signed) or hex (unsigned).
> +String type is a special type, which fetches a "null-terminated" string from
> +user space.
> +Bitfield is another special type, which takes 3 parameters, bit-width, bit-
> +offset, and container-size (usually 32). The syntax is;
> +
> + b<bit-width>@<bit-offset>/<container-size>
> +
>  
>  Event Profiling
>  ---------------
> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> index 70cd3bfde5a6..8c77825e87e6 100644
> --- a/kernel/trace/trace_probe.c
> +++ b/kernel/trace/trace_probe.c
> @@ -253,12 +253,18 @@ fail:
>  }
>  
>  /* Special function : only accept unsigned long */
> -static __kprobes void fetch_stack_address(struct pt_regs *regs,
> +static __kprobes void fetch_kernel_stack_address(struct pt_regs *regs,
>  					  void *dummy, void *dest, void *priv)
>  {
>  	*(unsigned long *)dest = kernel_stack_pointer(regs);
>  }
>  
> +static __kprobes void fetch_user_stack_address(struct pt_regs *regs,
> +					  void *dummy, void *dest, void *priv)
> +{
> +	*(unsigned long *)dest = user_stack_pointer(regs);
> +}
> +
>  static fetch_func_t get_fetch_size_function(const struct fetch_type *type,
>  					    fetch_func_t orig_fn,
>  					    const struct fetch_type *ttbl)
> @@ -303,7 +309,8 @@ int traceprobe_split_symbol_offset(char *symbol, unsigned long *offset)
>  #define PARAM_MAX_STACK (THREAD_SIZE / sizeof(unsigned long))
>  
>  static int parse_probe_vars(char *arg, const struct fetch_type *t,
> -			    struct fetch_param *f, bool is_return)
> +			    struct fetch_param *f, bool is_return,
> +			    bool is_kprobe)
>  {
>  	int ret = 0;
>  	unsigned long param;
> @@ -315,13 +322,16 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
>  			ret = -EINVAL;
>  	} else if (strncmp(arg, "stack", 5) == 0) {
>  		if (arg[5] == '\0') {
> -			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR) == 0)
> -				f->fn = fetch_stack_address;
> +			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR))
> +				return -EINVAL;
> +
> +			if (is_kprobe)
> +				f->fn = fetch_kernel_stack_address;
>  			else
> -				ret = -EINVAL;
> +				f->fn = fetch_user_stack_address;
>  		} else if (isdigit(arg[5])) {
>  			ret = kstrtoul(arg + 5, 10, &param);
> -			if (ret || param > PARAM_MAX_STACK)
> +			if (ret || (is_kprobe && param > PARAM_MAX_STACK))
>  				ret = -EINVAL;
>  			else {
>  				f->fn = t->fetch[FETCH_MTD_stack];
> @@ -345,17 +355,13 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
>  	int ret;
>  	const struct fetch_type *ttbl;
>  
> -	ttbl = kprobes_fetch_type_table;
> +	ttbl = is_kprobe ? kprobes_fetch_type_table : uprobes_fetch_type_table;
>  
>  	ret = 0;
>  
> -	/* Until uprobe_events supports only reg arguments */
> -	if (!is_kprobe && arg[0] != '%')
> -		return -EINVAL;
> -
>  	switch (arg[0]) {
>  	case '$':
> -		ret = parse_probe_vars(arg + 1, t, f, is_return);
> +		ret = parse_probe_vars(arg + 1, t, f, is_return, is_kprobe);
>  		break;
>  
>  	case '%':	/* named register */
> @@ -376,6 +382,10 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
>  			f->fn = t->fetch[FETCH_MTD_memory];
>  			f->data = (void *)param;
>  		} else {
> +			/* uprobes don't support symbols */
> +			if (!is_kprobe)
> +				return -EINVAL;
> +
>  			ret = traceprobe_split_symbol_offset(arg + 1, &offset);
>  			if (ret)
>  				break;
> @@ -482,7 +492,7 @@ int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
>  	int ret;
>  	const struct fetch_type *ttbl;
>  
> -	ttbl = kprobes_fetch_type_table;
> +	ttbl = is_kprobe ? kprobes_fetch_type_table : uprobes_fetch_type_table;
>  
>  	if (strlen(arg) > MAX_ARGSTR_LEN) {
>  		pr_info("Argument is too long.: %s\n",  arg);
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



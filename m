Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966823Ab3HIKYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:24:01 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:49845 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966414Ab3HIKX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:23:59 -0400
Message-ID: <5204C337.8040905@hitachi.com>
Date: Fri, 09 Aug 2013 19:23:51 +0900
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
References: <1376037909-17797-1-git-send-email-namhyung@kernel.org> <1376037909-17797-14-git-send-email-namhyung@kernel.org>
In-Reply-To: <1376037909-17797-14-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/09 17:45), Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Enable to fetch other types of argument for the uprobes.  IOW, we can
> access stack, memory, deref, bitfield and retval from uprobes now.

Could you also add more detail descriptions about what syntax
uprobe-event will accept now and what is not?
And also, you should update Documentation/trace/uprobetracer.txt
according to your effort too. :)

Thank you,

> Original-patch-by: Hyeoncheol Lee <cheol.lee@lge.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/trace_probe.c | 34 ++++++++++++++++++++--------------
>  1 file changed, 20 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> index 70cd3bfde5a6..b68ceb7cad6e 100644
> --- a/kernel/trace/trace_probe.c
> +++ b/kernel/trace/trace_probe.c
> @@ -253,7 +253,7 @@ fail:
>  }
>  
>  /* Special function : only accept unsigned long */
> -static __kprobes void fetch_stack_address(struct pt_regs *regs,
> +static __kprobes void fetch_kernel_stack_address(struct pt_regs *regs,
>  					  void *dummy, void *dest, void *priv)
>  {
>  	*(unsigned long *)dest = kernel_stack_pointer(regs);
> @@ -303,7 +303,8 @@ int traceprobe_split_symbol_offset(char *symbol, unsigned long *offset)
>  #define PARAM_MAX_STACK (THREAD_SIZE / sizeof(unsigned long))
>  
>  static int parse_probe_vars(char *arg, const struct fetch_type *t,
> -			    struct fetch_param *f, bool is_return)
> +			    struct fetch_param *f, bool is_return,
> +			    bool is_kprobe)
>  {
>  	int ret = 0;
>  	unsigned long param;
> @@ -315,13 +316,18 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
>  			ret = -EINVAL;
>  	} else if (strncmp(arg, "stack", 5) == 0) {
>  		if (arg[5] == '\0') {
> -			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR) == 0)
> -				f->fn = fetch_stack_address;
> -			else
> -				ret = -EINVAL;
> +			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR))
> +				return -EINVAL;
> +
> +			if (is_kprobe)
> +				f->fn = fetch_kernel_stack_address;
> +			else {
> +				f->fn = t->fetch[FETCH_MTD_stack];
> +				f->data = (void *)0;
> +			}
>  		} else if (isdigit(arg[5])) {
>  			ret = kstrtoul(arg + 5, 10, &param);
> -			if (ret || param > PARAM_MAX_STACK)
> +			if (ret || (is_kprobe && param > PARAM_MAX_STACK))
>  				ret = -EINVAL;
>  			else {
>  				f->fn = t->fetch[FETCH_MTD_stack];
> @@ -345,17 +351,13 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
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
> @@ -376,6 +378,10 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
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
> @@ -482,7 +488,7 @@ int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
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



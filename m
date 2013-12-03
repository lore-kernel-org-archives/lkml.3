Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab3LCJdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:33:05 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51655 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab3LCJdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:33:00 -0500
Message-ID: <529DA544.6000102@hitachi.com>
Date: Tue, 03 Dec 2013 18:32:52 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH/RFC 17/17] tracing/uprobes: Add @+file_offset fetch method
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org> <1385533203-10014-18-git-send-email-namhyung@kernel.org> <20131127185546.GA30544@redhat.com> <877gbtq7rb.fsf@sejong.aot.lge.com> <20131128163148.GA15985@redhat.com> <87ob54oxzt.fsf@sejong.aot.lge.com> <20131129165106.GA5224@redhat.com> <87mwkimp0i.fsf@sejong.aot.lge.com>
In-Reply-To: <87mwkimp0i.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/03 15:23), Namhyung Kim wrote:
>>> So do you want me to change to make it simpler without a fetch_param?
>>
>> Yes, yes. Assuming that you agree, of course.
> 
> Okay, here goes v8 then. :)
> 
> I also push it (with other changes come from Srikar) to the
> uprobe/fetch-v8 branch in my tree for your convenience. :)

This looks good for me :)

>>From 25bc2bab14e9461f8b15e34f26d1de51f96e44e1 Mon Sep 17 00:00:00 2001
> From: Namhyung Kim <namhyung.kim@lge.com>
> Date: Mon, 25 Nov 2013 13:42:47 +0900
> Subject: [PATCH v8 17/17] tracing/uprobes: Add @+file_offset fetch method
> 
> Enable to fetch data from a file offset.  Currently it only supports
> fetching from same binary uprobe set.  It'll translate the file offset
> to a proper virtual address in the process.
> 
> The syntax is "@+OFFSET" as it does similar to normal memory fetching
> (@ADDR) which does no address translation.
> 
> To do it, change fifth argument to receive 'void *priv' and make it
> set only for uprobes so that we can determine the arg is for kprobes
> or uprobes easily.
> 
> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> ---
>  Documentation/trace/uprobetracer.txt |  1 +
>  kernel/trace/trace_kprobe.c          |  8 ++++++++
>  kernel/trace/trace_probe.c           | 13 +++++++++++-
>  kernel/trace/trace_probe.h           |  2 ++
>  kernel/trace/trace_uprobe.c          | 40 ++++++++++++++++++++++++++++++++++++
>  5 files changed, 63 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/trace/uprobetracer.txt b/Documentation/trace/uprobetracer.txt
> index 6e5cff263e2b..f1cf9a34ad9d 100644
> --- a/Documentation/trace/uprobetracer.txt
> +++ b/Documentation/trace/uprobetracer.txt
> @@ -32,6 +32,7 @@ Synopsis of uprobe_tracer
>    FETCHARGS     : Arguments. Each probe can have up to 128 args.
>     %REG         : Fetch register REG
>     @ADDR	: Fetch memory at ADDR (ADDR should be in userspace)
> +   @+OFFSET	: Fetch memory at OFFSET (OFFSET from same file as PATH)
>     $stackN	: Fetch Nth entry of stack (N >= 0)
>     $stack	: Fetch stack address.
>     $retval	: Fetch return value.(*)
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 8b32236ae890..1cf8f3375559 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -239,6 +239,14 @@ DEFINE_BASIC_FETCH_FUNCS(symbol)
>  DEFINE_FETCH_symbol(string)
>  DEFINE_FETCH_symbol(string_size)
>  
> +/* kprobes don't support file_offset fetch methods */
> +#define fetch_file_offset_u8		NULL
> +#define fetch_file_offset_u16		NULL
> +#define fetch_file_offset_u32		NULL
> +#define fetch_file_offset_u64		NULL
> +#define fetch_file_offset_string	NULL
> +#define fetch_file_offset_string_size	NULL
> +
>  /* Fetch type information table */
>  const struct fetch_type kprobes_fetch_type_table[] = {
>  	/* Special types */
> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> index 464ec506ec08..705c06ba0a8a 100644
> --- a/kernel/trace/trace_probe.c
> +++ b/kernel/trace/trace_probe.c
> @@ -373,7 +373,7 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
>  		}
>  		break;
>  
> -	case '@':	/* memory or symbol */
> +	case '@':	/* memory, file-offset or symbol */
>  		if (isdigit(arg[1])) {
>  			ret = kstrtoul(arg + 1, 0, &param);
>  			if (ret)
> @@ -381,6 +381,17 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
>  
>  			f->fn = t->fetch[FETCH_MTD_memory];
>  			f->data = (void *)param;
> +		} else if (arg[1] == '+') {
> +			/* kprobes don't support file offsets */
> +			if (is_kprobe)
> +				return -EINVAL;
> +
> +			ret = kstrtol(arg + 2, 0, &offset);
> +			if (ret)
> +				break;
> +
> +			f->fn = t->fetch[FETCH_MTD_file_offset];
> +			f->data = (void *)offset;
>  		} else {
>  			/* uprobes don't support symbols */
>  			if (!is_kprobe)
> diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
> index 385206bbbf8b..d9afeb580cbf 100644
> --- a/kernel/trace/trace_probe.h
> +++ b/kernel/trace/trace_probe.h
> @@ -106,6 +106,7 @@ enum {
>  	FETCH_MTD_symbol,
>  	FETCH_MTD_deref,
>  	FETCH_MTD_bitfield,
> +	FETCH_MTD_file_offset,
>  	FETCH_MTD_END,
>  };
>  
> @@ -217,6 +218,7 @@ ASSIGN_FETCH_FUNC(memory, ftype),			\
>  ASSIGN_FETCH_FUNC(symbol, ftype),			\
>  ASSIGN_FETCH_FUNC(deref, ftype),			\
>  ASSIGN_FETCH_FUNC(bitfield, ftype),			\
> +ASSIGN_FETCH_FUNC(file_offset, ftype),			\
>  	  }						\
>  	}
>  
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index f86a6a711de9..f5cbed7e7709 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -70,6 +70,11 @@ static int unregister_uprobe_event(struct trace_uprobe *tu);
>  static DEFINE_MUTEX(uprobe_lock);
>  static LIST_HEAD(uprobe_list);
>  
> +struct uprobe_dispatch_data {
> +	struct trace_uprobe	*tu;
> +	unsigned long		bp_addr;
> +};
> +
>  static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs);
>  static int uretprobe_dispatcher(struct uprobe_consumer *con,
>  				unsigned long func, struct pt_regs *regs);
> @@ -175,6 +180,29 @@ static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
>  #define fetch_symbol_string		NULL
>  #define fetch_symbol_string_size	NULL
>  
> +static unsigned long translate_user_vaddr(void *file_offset)
> +{
> +	unsigned long base_addr;
> +	struct uprobe_dispatch_data *udd;
> +
> +	udd = (void *) current->utask->vaddr;
> +
> +	base_addr = udd->bp_addr - udd->tu->offset;
> +	return base_addr + (unsigned long)file_offset;
> +}
> +
> +#define DEFINE_FETCH_file_offset(type)					\
> +static __kprobes void FETCH_FUNC_NAME(file_offset, type)(struct pt_regs *regs,\
> +					void *offset, void *dest) 	\
> +{									\
> +	void *vaddr = (void *)translate_user_vaddr(offset);		\
> +									\
> +	FETCH_FUNC_NAME(memory, type)(regs, vaddr, dest);		\
> +}
> +DEFINE_BASIC_FETCH_FUNCS(file_offset)
> +DEFINE_FETCH_file_offset(string)
> +DEFINE_FETCH_file_offset(string_size)
> +
>  /* Fetch type information table */
>  const struct fetch_type uprobes_fetch_type_table[] = {
>  	/* Special types */
> @@ -1104,11 +1132,17 @@ int trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type,
>  static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
>  {
>  	struct trace_uprobe *tu;
> +	struct uprobe_dispatch_data udd;
>  	int ret = 0;
>  
>  	tu = container_of(con, struct trace_uprobe, consumer);
>  	tu->nhit++;
>  
> +	udd.tu = tu;
> +	udd.bp_addr = instruction_pointer(regs);
> +
> +	current->utask->vaddr = (unsigned long) &udd;
> +
>  	if (tu->tp.flags & TP_FLAG_TRACE)
>  		ret |= uprobe_trace_func(tu, regs);
>  
> @@ -1123,9 +1157,15 @@ static int uretprobe_dispatcher(struct uprobe_consumer *con,
>  				unsigned long func, struct pt_regs *regs)
>  {
>  	struct trace_uprobe *tu;
> +	struct uprobe_dispatch_data udd;
>  
>  	tu = container_of(con, struct trace_uprobe, consumer);
>  
> +	udd.tu = tu;
> +	udd.bp_addr = func;
> +
> +	current->utask->vaddr = (unsigned long) &udd;
> +
>  	if (tu->tp.flags & TP_FLAG_TRACE)
>  		uretprobe_trace_func(tu, func, regs);
>  
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3H0MDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 08:03:36 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:52951 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab3H0MDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 08:03:35 -0400
Message-ID: <521C9594.30901@hitachi.com>
Date: Tue, 27 Aug 2013 21:03:32 +0900
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
Subject: Re: [PATCH 12/13] tracing/uprobes: Add more fetch functions
References: <1377593336-16828-1-git-send-email-namhyung@kernel.org> <1377593336-16828-13-git-send-email-namhyung@kernel.org>
In-Reply-To: <1377593336-16828-13-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/27 17:48), Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Implement uprobe-specific stack and memory fetch functions and add
> them to the uprobes_fetch_type_table.  Other fetch fucntions will be
> shared with kprobes.
> 
> Original-patch-by: Hyeoncheol Lee <cheol.lee@lge.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/trace_probe.c  |   9 ++-
>  kernel/trace/trace_probe.h  |   1 +
>  kernel/trace/trace_uprobe.c | 188 +++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 192 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> index eaee44d5d9d1..70cd3bfde5a6 100644
> --- a/kernel/trace/trace_probe.c
> +++ b/kernel/trace/trace_probe.c
> @@ -101,6 +101,10 @@ struct deref_fetch_param {
>  	fetch_func_t		fetch_size;
>  };
>  
> +/*
> + * For uprobes, it'll get a vaddr from first call_fetch() so pass NULL
> + * as a priv on the second dprm->fetch() not to translate it to vaddr again.
> + */
>  #define DEFINE_FETCH_deref(type)					\
>  __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,	\
>  				    void *data, void *dest, void *priv)	\
> @@ -110,13 +114,14 @@ __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,	\
>  	call_fetch(&dprm->orig, regs, &addr, priv);			\
>  	if (addr) {							\
>  		addr += dprm->offset;					\
> -		dprm->fetch(regs, (void *)addr, dest, priv);		\
> +		dprm->fetch(regs, (void *)addr, dest, NULL);		\
>  	} else								\
>  		*(type *)dest = 0;					\
>  }
>  DEFINE_BASIC_FETCH_FUNCS(deref)
>  DEFINE_FETCH_deref(string)
>  
> +/* Same as above */
>  __kprobes void FETCH_FUNC_NAME(deref, string_size)(struct pt_regs *regs,
>  					void *data, void *dest, void *priv)
>  {
> @@ -126,7 +131,7 @@ __kprobes void FETCH_FUNC_NAME(deref, string_size)(struct pt_regs *regs,
>  	call_fetch(&dprm->orig, regs, &addr, priv);
>  	if (addr && dprm->fetch_size) {
>  		addr += dprm->offset;
> -		dprm->fetch_size(regs, (void *)addr, dest, priv);
> +		dprm->fetch_size(regs, (void *)addr, dest, NULL);
>  	} else
>  		*(string_size *)dest = 0;
>  }
> diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
> index fc7edf3749ef..b1e7d722c354 100644
> --- a/kernel/trace/trace_probe.h
> +++ b/kernel/trace/trace_probe.h
> @@ -263,6 +263,7 @@ ASSIGN_FETCH_FUNC(bitfield, ftype),			\
>  #define NR_FETCH_TYPES		10
>  
>  extern const struct fetch_type kprobes_fetch_type_table[];
> +extern const struct fetch_type uprobes_fetch_type_table[];
>  
>  static inline __kprobes void call_fetch(struct fetch_param *fprm,
>  				 struct pt_regs *regs, void *dest, void *priv)
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index fc5f8aa62156..89d4b86abbe1 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -530,6 +530,186 @@ static const struct file_operations uprobe_profile_ops = {
>  	.release	= seq_release,
>  };
>  
> +#ifdef CONFIG_STACK_GROWSUP
> +static unsigned long adjust_stack_addr(unsigned long addr, unsigned n)
> +{
> +	return addr - (n * sizeof(long));
> +}
> +
> +static bool within_user_stack(struct vm_area_struct *vma, unsigned long addr,
> +			      unsigned int n)
> +{
> +	return vma->vm_start <= adjust_stack_addr(addr, n);
> +}
> +#else
> +static unsigned long adjust_stack_addr(unsigned long addr, unsigned n)
> +{
> +	return addr + (n * sizeof(long));
> +}
> +
> +static bool within_user_stack(struct vm_area_struct *vma, unsigned long addr,
> +			      unsigned int n)
> +{
> +	return vma->vm_end >= adjust_stack_addr(addr, n);
> +}
> +#endif
> +
> +static unsigned long get_user_stack_nth(struct pt_regs *regs, unsigned int n)
> +{
> +	struct vm_area_struct *vma;
> +	unsigned long addr = GET_USP(regs);

I recommend you to use user_stack_pointer() rather than GET_USP here.
Since some arch seem not to have correct GET_USP implementation (e.g. arm),
kernel build will be failed.

And at least trace_probe.c part is good for me.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965693Ab3HIJQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:16:45 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46547 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965456Ab3HIJQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:16:44 -0400
Message-ID: <5204B377.3050807@hitachi.com>
Date: Fri, 09 Aug 2013 18:16:39 +0900
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
Subject: Re: [PATCH 04/13] tracing/kprobes: Add fetch{,_size} member into
 deref fetch method
References: <1376037909-17797-1-git-send-email-namhyung@kernel.org> <1376037909-17797-5-git-send-email-namhyung@kernel.org>
In-Reply-To: <1376037909-17797-5-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/09 17:45), Namhyung Kim wrote:
> From: Hyeoncheol Lee <cheol.lee@lge.com>
> 
> The deref fetch methods access a memory region but it assumes that
> it's a kernel memory since uprobes does not support them.
> 
> Add ->fetch and ->fetch_size member in order to provide a proper
> access methods for supporting uprobes.
> 

Looks OK for me :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Hyeoncheol Lee <cheol.lee@lge.com>
> [namhyung@kernel.org: Split original patch into pieces as requested]
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/trace_probe.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> index 41f654d24cd9..b7b8bda02d6e 100644
> --- a/kernel/trace/trace_probe.c
> +++ b/kernel/trace/trace_probe.c
> @@ -97,6 +97,8 @@ DEFINE_BASIC_FETCH_FUNCS(retval)
>  struct deref_fetch_param {
>  	struct fetch_param	orig;
>  	long			offset;
> +	fetch_func_t		fetch;
> +	fetch_func_t		fetch_size;
>  };
>  
>  #define DEFINE_FETCH_deref(type)					\
> @@ -108,13 +110,26 @@ __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,	\
>  	call_fetch(&dprm->orig, regs, &addr);				\
>  	if (addr) {							\
>  		addr += dprm->offset;					\
> -		fetch_memory_##type(regs, (void *)addr, dest);		\
> +		dprm->fetch(regs, (void *)addr, dest);			\
>  	} else								\
>  		*(type *)dest = 0;					\
>  }
>  DEFINE_BASIC_FETCH_FUNCS(deref)
>  DEFINE_FETCH_deref(string)
> -DEFINE_FETCH_deref(string_size)
> +
> +__kprobes void FETCH_FUNC_NAME(deref, string_size)(struct pt_regs *regs,
> +						   void *data, void *dest)
> +{
> +	struct deref_fetch_param *dprm = data;
> +	unsigned long addr;
> +
> +	call_fetch(&dprm->orig, regs, &addr);
> +	if (addr && dprm->fetch_size) {
> +		addr += dprm->offset;
> +		dprm->fetch_size(regs, (void *)addr, dest);
> +	} else
> +		*(string_size *)dest = 0;
> +}
>  
>  static __kprobes void update_deref_fetch_param(struct deref_fetch_param *data)
>  {
> @@ -394,6 +409,9 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
>  				return -ENOMEM;
>  
>  			dprm->offset = offset;
> +			dprm->fetch = t->fetch[FETCH_MTD_memory];
> +			dprm->fetch_size = get_fetch_size_function(t,
> +							dprm->fetch, ttbl);
>  			ret = parse_probe_arg(arg, t2, &dprm->orig, is_return,
>  							is_kprobe);
>  			if (ret)
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



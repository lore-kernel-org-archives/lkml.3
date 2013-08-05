Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab3HEITy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:19:54 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:57136 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab3HEITw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:19:52 -0400
Message-ID: <51FF6026.7090409@hitachi.com>
Date: Mon, 05 Aug 2013 17:19:50 +0900
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
Subject: Re: [PATCH 02/13] tracing/kprobes: Add fetch{,_size} member into
 symbol and deref fetch method
References: <1375261410-11219-1-git-send-email-namhyung@kernel.org> <1375261410-11219-3-git-send-email-namhyung@kernel.org>
In-Reply-To: <1375261410-11219-3-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/31 18:03), Namhyung Kim wrote:
> From: Hyeoncheol Lee <cheol.lee@lge.com>
> 
> Those symbol and deref fetch methods access a memory region but they
> assume it's a kernel memory since uprobes does not support them.
> 
> Add ->fetch and ->fetch_size member in order to provide a proper
> access method for supporting uprobes.

It looks symbol cache is not used by uprobes. I think it it enough to
add fetch/fetch_size to only deref, isn't it?

Thank you,

> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Hyeoncheol Lee <cheol.lee@lge.com>
> [namhyung@kernel.org: Split original patch into pieces as requested]
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  kernel/trace/trace_probe.c | 48 ++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 42 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> index c58c25d81591..c123a890c5b1 100644
> --- a/kernel/trace/trace_probe.c
> +++ b/kernel/trace/trace_probe.c
> @@ -93,6 +93,8 @@ struct symbol_cache {
>  	char		*symbol;
>  	long		offset;
>  	unsigned long	addr;
> +	fetch_func_t	fetch;
> +	fetch_func_t	fetch_size;
>  };
>  
>  static unsigned long update_symbol_cache(struct symbol_cache *sc)
> @@ -139,18 +141,29 @@ __kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,	\
>  {									\
>  	struct symbol_cache *sc = data;					\
>  	if (sc->addr)							\
> -		fetch_memory_##type(regs, (void *)sc->addr, dest);	\
> +		sc->fetch(regs, (void *)sc->addr, dest);		\
>  	else								\
>  		*(type *)dest = 0;					\
>  }
>  DEFINE_BASIC_FETCH_FUNCS(symbol)
>  DEFINE_FETCH_symbol(string)
> -DEFINE_FETCH_symbol(string_size)
> +
> +__kprobes void FETCH_FUNC_NAME(symbol, string_size)(struct pt_regs *regs,
> +						    void *data, void *dest)
> +{
> +	struct symbol_cache *sc = data;
> +	if (sc->addr && sc->fetch_size)
> +		sc->fetch_size(regs, (void *)sc->addr, dest);
> +	else
> +		*(string_size *)dest = 0;
> +}
>  
>  /* Dereference memory access function */
>  struct deref_fetch_param {
>  	struct fetch_param	orig;
>  	long			offset;
> +	fetch_func_t		fetch;
> +	fetch_func_t		fetch_size;
>  };
>  
>  #define DEFINE_FETCH_deref(type)					\
> @@ -162,13 +175,26 @@ __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,	\
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
> @@ -410,13 +436,20 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
>  			f->fn = t->fetch[FETCH_MTD_memory];
>  			f->data = (void *)param;
>  		} else {
> +			struct symbol_cache *sc;
> +
>  			ret = traceprobe_split_symbol_offset(arg + 1, &offset);
>  			if (ret)
>  				break;
>  
> -			f->data = alloc_symbol_cache(arg + 1, offset);
> -			if (f->data)
> +			sc = alloc_symbol_cache(arg + 1, offset);
> +			if (sc) {
>  				f->fn = t->fetch[FETCH_MTD_symbol];
> +				sc->fetch = t->fetch[FETCH_MTD_memory];
> +				sc->fetch_size = get_fetch_size_function(t,
> +							sc->fetch, ttbl);
> +				f->data = sc;
> +			}
>  		}
>  		break;
>  
> @@ -448,6 +481,9 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
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



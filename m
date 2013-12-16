Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3LPIXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 03:23:34 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36612 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab3LPIXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 03:23:32 -0500
Message-ID: <52AEB87D.6020507@hitachi.com>
Date: Mon, 16 Dec 2013 17:23:25 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 10/17] tracing/probes: Move 'symbol' fetch method to kprobes
References: <1387168336-13213-1-git-send-email-namhyung@kernel.org> <1387168336-13213-11-git-send-email-namhyung@kernel.org>
In-Reply-To: <1387168336-13213-11-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/16 13:32), Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Move existing functions to trace_kprobe.c and add NULL entries to the
> uprobes fetch type table.  I don't make them static since some generic
> routines like update/free_XXX_fetch_param() require pointers to the
> functions.
> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

This looks good for me :)

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

And now all of this series has been reviewed/acked by me!

Thank you!

> ---
>  kernel/trace/trace_kprobe.c | 59 +++++++++++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_probe.c  | 59 ---------------------------------------------
>  kernel/trace/trace_probe.h  | 24 ++++++++++++++++++
>  kernel/trace/trace_uprobe.c |  8 ++++++
>  4 files changed, 91 insertions(+), 59 deletions(-)
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 11478020f76c..1c38f3f47d0d 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -88,6 +88,51 @@ static int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs);
>  static int kretprobe_dispatcher(struct kretprobe_instance *ri,
>  				struct pt_regs *regs);
>  
> +/* Memory fetching by symbol */
> +struct symbol_cache {
> +	char		*symbol;
> +	long		offset;
> +	unsigned long	addr;
> +};
> +
> +unsigned long update_symbol_cache(struct symbol_cache *sc)
> +{
> +	sc->addr = (unsigned long)kallsyms_lookup_name(sc->symbol);
> +
> +	if (sc->addr)
> +		sc->addr += sc->offset;
> +
> +	return sc->addr;
> +}
> +
> +void free_symbol_cache(struct symbol_cache *sc)
> +{
> +	kfree(sc->symbol);
> +	kfree(sc);
> +}
> +
> +struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
> +{
> +	struct symbol_cache *sc;
> +
> +	if (!sym || strlen(sym) == 0)
> +		return NULL;
> +
> +	sc = kzalloc(sizeof(struct symbol_cache), GFP_KERNEL);
> +	if (!sc)
> +		return NULL;
> +
> +	sc->symbol = kstrdup(sym, GFP_KERNEL);
> +	if (!sc->symbol) {
> +		kfree(sc);
> +		return NULL;
> +	}
> +	sc->offset = offset;
> +	update_symbol_cache(sc);
> +
> +	return sc;
> +}
> +
>  /*
>   * Kprobes-specific fetch functions
>   */
> @@ -103,6 +148,20 @@ DEFINE_BASIC_FETCH_FUNCS(stack)
>  #define fetch_stack_string	NULL
>  #define fetch_stack_string_size	NULL
>  
> +#define DEFINE_FETCH_symbol(type)					\
> +__kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,	\
> +					  void *data, void *dest)	\
> +{									\
> +	struct symbol_cache *sc = data;					\
> +	if (sc->addr)							\
> +		fetch_memory_##type(regs, (void *)sc->addr, dest);	\
> +	else								\
> +		*(type *)dest = 0;					\
> +}
> +DEFINE_BASIC_FETCH_FUNCS(symbol)
> +DEFINE_FETCH_symbol(string)
> +DEFINE_FETCH_symbol(string_size)
> +
>  /* Fetch type information table */
>  const struct fetch_type kprobes_fetch_type_table[] = {
>  	/* Special types */
> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> index 77aa7d18821e..a31ad478b7f6 100644
> --- a/kernel/trace/trace_probe.c
> +++ b/kernel/trace/trace_probe.c
> @@ -180,65 +180,6 @@ __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
>  		*(u32 *)dest = len;
>  }
>  
> -/* Memory fetching by symbol */
> -struct symbol_cache {
> -	char		*symbol;
> -	long		offset;
> -	unsigned long	addr;
> -};
> -
> -static unsigned long update_symbol_cache(struct symbol_cache *sc)
> -{
> -	sc->addr = (unsigned long)kallsyms_lookup_name(sc->symbol);
> -
> -	if (sc->addr)
> -		sc->addr += sc->offset;
> -
> -	return sc->addr;
> -}
> -
> -static void free_symbol_cache(struct symbol_cache *sc)
> -{
> -	kfree(sc->symbol);
> -	kfree(sc);
> -}
> -
> -static struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
> -{
> -	struct symbol_cache *sc;
> -
> -	if (!sym || strlen(sym) == 0)
> -		return NULL;
> -
> -	sc = kzalloc(sizeof(struct symbol_cache), GFP_KERNEL);
> -	if (!sc)
> -		return NULL;
> -
> -	sc->symbol = kstrdup(sym, GFP_KERNEL);
> -	if (!sc->symbol) {
> -		kfree(sc);
> -		return NULL;
> -	}
> -	sc->offset = offset;
> -	update_symbol_cache(sc);
> -
> -	return sc;
> -}
> -
> -#define DEFINE_FETCH_symbol(type)					\
> -__kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,	\
> -					  void *data, void *dest)	\
> -{									\
> -	struct symbol_cache *sc = data;					\
> -	if (sc->addr)							\
> -		fetch_memory_##type(regs, (void *)sc->addr, dest);	\
> -	else								\
> -		*(type *)dest = 0;					\
> -}
> -DEFINE_BASIC_FETCH_FUNCS(symbol)
> -DEFINE_FETCH_symbol(string)
> -DEFINE_FETCH_symbol(string_size)
> -
>  /* Dereference memory access function */
>  struct deref_fetch_param {
>  	struct fetch_param	orig;
> diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
> index 8211dd674ab6..8be84550ceb3 100644
> --- a/kernel/trace/trace_probe.h
> +++ b/kernel/trace/trace_probe.h
> @@ -239,6 +239,30 @@ ASSIGN_FETCH_FUNC(bitfield, ftype),			\
>  extern __weak const struct fetch_type kprobes_fetch_type_table[];
>  extern __weak const struct fetch_type uprobes_fetch_type_table[];
>  
> +#ifdef CONFIG_KPROBE_EVENT
> +struct symbol_cache;
> +unsigned long update_symbol_cache(struct symbol_cache *sc);
> +void free_symbol_cache(struct symbol_cache *sc);
> +struct symbol_cache *alloc_symbol_cache(const char *sym, long offset);
> +#else
> +struct symbol_cache {
> +};
> +static inline unsigned long __used update_symbol_cache(struct symbol_cache *sc)
> +{
> +	return 0;
> +}
> +
> +static inline void __used free_symbol_cache(struct symbol_cache *sc)
> +{
> +}
> +
> +static inline struct symbol_cache * __used
> +alloc_symbol_cache(const char *sym, long offset)
> +{
> +	return NULL;
> +}
> +#endif /* CONFIG_KPROBE_EVENT */
> +
>  struct probe_arg {
>  	struct fetch_param	fetch;
>  	struct fetch_param	fetch_size;
> diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> index 5395d37e5e72..adc9ac70fd3c 100644
> --- a/kernel/trace/trace_uprobe.c
> +++ b/kernel/trace/trace_uprobe.c
> @@ -115,6 +115,14 @@ DEFINE_BASIC_FETCH_FUNCS(stack)
>  #define fetch_stack_string_size	NULL
>  
>  
> +/* uprobes don't support symbol fetch methods */
> +#define fetch_symbol_u8			NULL
> +#define fetch_symbol_u16		NULL
> +#define fetch_symbol_u32		NULL
> +#define fetch_symbol_u64		NULL
> +#define fetch_symbol_string		NULL
> +#define fetch_symbol_string_size	NULL
> +
>  /* Fetch type information table */
>  const struct fetch_type uprobes_fetch_type_table[] = {
>  	/* Special types */
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab3K0LaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:30:17 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:49974 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab3K0LaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:30:14 -0500
Message-ID: <5295D7C1.3040806@hitachi.com>
Date: Wed, 27 Nov 2013 20:30:09 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC PATCH 2/2] tracing: Teach FETCH_MTD_symbol to handle per-cpu
 data
References: <20131123201543.GA22148@redhat.com> <20131125172106.GA14516@redhat.com> <20131125172206.GD14516@redhat.com> <52946B42.40603@hitachi.com> <20131126174355.GB14028@redhat.com> <20131126174446.GD14028@redhat.com>
In-Reply-To: <20131126174446.GD14028@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/27 2:44), Oleg Nesterov wrote:
> FETCH_FUNC_NAME(symbol) blindly dereferences sc->addr + sc->offset,
> this is not what we want if this symbol is per-cpu. Change this code
> to use this_cpu_ptr(sc->addr) in this case.

This looks good for me :)

Thanks!

> Note: this doesn't work for modules, but module's per-cpu data is
> not visible for kallsyms_lookup_name() anyway.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/trace/trace_probe.c |   22 ++++++++++++++++++----
>  1 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> index 097cc80..a0144b6 100644
> --- a/kernel/trace/trace_probe.c
> +++ b/kernel/trace/trace_probe.c
> @@ -252,14 +252,28 @@ static struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
>  	return sc;
>  }
>  
> +static void *sc_calc_addr(struct symbol_cache *sc)
> +{
> +	void *addr = (void*)sc->addr;
> +
> +	if (addr) {
> +		if (addr >= (void *)__per_cpu_start &&
> +		    addr <  (void *)__per_cpu_end)
> +			addr = this_cpu_ptr(addr);
> +
> +		addr += sc->offset;
> +	}
> +
> +	return addr;
> +}
> +
>  #define DEFINE_FETCH_symbol(type)					\
>  static __kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,\
>  					  void *data, void *dest)	\
>  {									\
> -	struct symbol_cache *sc = data;					\
> -	long off = sc->offset;						\
> -	if (sc->addr)							\
> -		fetch_memory_##type(regs, (void *)sc->addr + off, dest);\
> +	void *addr = sc_calc_addr(data);				\
> +	if (addr)							\
> +		fetch_memory_##type(regs, addr, dest);			\
>  	else								\
>  		*(type *)dest = 0;					\
>  }
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



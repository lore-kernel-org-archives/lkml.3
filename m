Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbbAODen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 22:34:43 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:35843 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbbAODel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 22:34:41 -0500
Message-ID: <54B73549.3090405@hitachi.com>
Date: Thu, 15 Jan 2015 12:34:33 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] ftrace: don't allow IPMODIFY without proper compiler
 support
References: <alpine.LNX.2.00.1412221412360.1680@pobox.suse.cz> <20141223094607.GA16445@infradead.org> <20141223151056.GA4789@treble.redhat.com> <20141226155613.36dd95b9@canb.auug.org.au> <20150107144317.61ab2080877a4d8227990551@linux-foundation.org> <alpine.LNX.2.00.1501072346400.15299@pobox.suse.cz> <20150107153006.60ed354e3458f402e6819b9e@linux-foundation.org> <alpine.LNX.2.00.1501080037030.15299@pobox.suse.cz> <20150107155701.4839545f63701412003edd88@linux-foundation.org> <alpine.LNX.2.00.1501080104190.15299@pobox.suse.cz> <54B3C1DD.6090400@hitachi.com> <alpine.LNX.2.00.1501132345080.4162@pobox.suse.cz> <20150113211223.18908f21@grimm.local.home> <alpine.LNX.2.00.1501140945520.4162@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1501140945520.4162@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/14 17:47), Jiri Kosina wrote:
> Using IPMODIFY needs to be allowed only with compilers which are 
> guaranteed to generate function prologues compatible with function 
> redirection through changing instruction pointer in saved regs.
> 
> For example changing regs->ip on x86_64 in cases when gcc is using mcount 
> (and not fentry) is not allowed, because at the time mcount call is 
> issued, the original function's prologue has already been executed, which 
> leads to all kinds of inconsistent havoc.
> 
> There is currently no way to express dependency on gcc features in 
> Kconfig, (CC_USING_FENTRY is defined only during build, so it's not 
> possible for Kconfig symbol to depend on it) so this needs to be checked 
> in runtime.
> 
> Mark x86_64 with fentry supported for now. Other archs can be added
> gradually.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
> 
> v1 -> v2: turn macro function into a plain macro
> 
>  arch/x86/include/asm/ftrace.h | 2 ++
>  include/linux/ftrace.h        | 5 +++++
>  kernel/trace/ftrace.c         | 5 +++++
>  3 files changed, 12 insertions(+)
> 
> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> index f45acad..f84eaaf 100644
> --- a/arch/x86/include/asm/ftrace.h
> +++ b/arch/x86/include/asm/ftrace.h
> @@ -4,8 +4,10 @@
>  #ifdef CONFIG_FUNCTION_TRACER
>  #ifdef CC_USING_FENTRY
>  # define MCOUNT_ADDR		((long)(__fentry__))
> +# define ftrace_ipmodify_supported 1
>  #else
>  # define MCOUNT_ADDR		((long)(mcount))
> +# define ftrace_ipmodify_supported 0
>  #endif
>  #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
>  
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 1da6029..837153a 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -244,6 +244,11 @@ static inline int ftrace_function_local_disabled(struct ftrace_ops *ops)
>  extern void ftrace_stub(unsigned long a0, unsigned long a1,
>  			struct ftrace_ops *op, struct pt_regs *regs);
>  
> +#ifndef ftrace_ipmodify_supported
> +/* let's not make any implicit assumptions about profiling call placement */
> +# define ftrace_ipmodify_supported 0
> +
> +#endif
>  #else /* !CONFIG_FUNCTION_TRACER */
>  /*
>   * (un)register_ftrace_function must be a macro since the ops parameter
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 929a733..05af4cd 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1809,6 +1809,11 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
>  	if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY))
>  		return 0;
>  
> +	if (!ftrace_ipmodify_supported) {
> +		WARN(1, "Your compiler doesn't support features necessary for IPMODIFY");
> +		return 0;
> +	}
> +

Hmm, if this binary doesn't support IPMODIFY, it should return -ENOTSUPP.
And also, IMHO, we'd better reject registering ftrace_ops with IPMODIFY
in this situation before updating hash table.

Thank you,

>  	/*
>  	 * Since the IPMODIFY is a very address sensitive action, we do not
>  	 * allow ftrace_ops to set all functions to new hash.
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



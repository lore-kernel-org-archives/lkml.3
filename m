Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbaKEKmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:42:13 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60434 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334AbaKEKmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:42:10 -0500
Date: Wed, 5 Nov 2014 11:42:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [for-next][PATCH 2/4] ftrace/x86: Show trampoline call function
 in enabled_functions
Message-ID: <20141105104207.GB5245@pd.tnic>
References: <20141027182702.778680710@goodmis.org>
 <20141027182948.432689737@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141027182948.432689737@goodmis.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 02:27:04PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> The file /sys/kernel/debug/tracing/eneabled_functions is used to debug
> ftrace function hooks. Add to the output what function is being called
> by the trampoline if the arch supports it.
> 
> Add support for this feature in x86_64.
> 
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/kernel/ftrace.c | 98 ++++++++++++++++++++++++++++++++++++++++++------
>  kernel/trace/ftrace.c    | 22 ++++++++++-
>  2 files changed, 106 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index e4d48f6cad86..ca17c20a1010 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -48,7 +48,7 @@ int ftrace_arch_code_modify_post_process(void)
>  union ftrace_code_union {
>  	char code[MCOUNT_INSN_SIZE];
>  	struct {
> -		char e8;
> +		unsigned char e8;

u8?

"u8 e8;" looks supa dupa though :-)

>  		int offset;
>  	} __attribute__((packed));
>  };
> @@ -797,12 +797,26 @@ static unsigned long create_trampoline(struct ftrace_ops *ops)
>  	return (unsigned long)trampoline;
>  }
>  
> +static unsigned long calc_trampoline_call_offset(bool save_regs)
> +{
> +	unsigned long start_offset;
> +	unsigned long call_offset;
> +
> +	if (save_regs) {
> +		start_offset = (unsigned long)ftrace_regs_caller;
> +		call_offset = (unsigned long)ftrace_regs_call;
> +	} else {
> +		start_offset = (unsigned long)ftrace_caller;
> +		call_offset = (unsigned long)ftrace_call;
> +	}
> +
> +	return call_offset - start_offset;
> +}
> +
>  void arch_ftrace_update_trampoline(struct ftrace_ops *ops)
>  {
>  	ftrace_func_t func;
>  	unsigned char *new;
> -	unsigned long start_offset;
> -	unsigned long call_offset;
>  	unsigned long offset;
>  	unsigned long ip;
>  	int ret;
> @@ -820,15 +834,7 @@ void arch_ftrace_update_trampoline(struct ftrace_ops *ops)
>  			return;
>  	}
>  
> -	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
> -		start_offset = (unsigned long)ftrace_regs_caller;
> -		call_offset = (unsigned long)ftrace_regs_call;
> -	} else {
> -		start_offset = (unsigned long)ftrace_caller;
> -		call_offset = (unsigned long)ftrace_call;
> -	}
> -
> -	offset = call_offset - start_offset;
> +	offset = calc_trampoline_call_offset(ops->flags & FTRACE_OPS_FL_SAVE_REGS);
>  	ip = ops->trampoline + offset;
>  
>  	func = ftrace_ops_get_func(ops);
> @@ -840,6 +846,74 @@ void arch_ftrace_update_trampoline(struct ftrace_ops *ops)
>  	/* The update should never fail */
>  	WARN_ON(ret);
>  }
> +
> +/* Return the address of the function the trampoline calls */
> +static void *addr_from_call(void *ptr)
> +{
> +	union ftrace_code_union calc;
> +	int ret;
> +
> +	ret = probe_kernel_read(&calc, ptr, MCOUNT_INSN_SIZE);
> +	if (WARN_ON_ONCE(ret < 0))
> +		return NULL;
> +
> +	/* Make sure this is a call */
> +	if (WARN_ON_ONCE(calc.e8 != 0xe8)) {
> +		pr_warn("Expected e8, got %x\n", calc.e8);

Simply WARN_ONCE gives you both.

> +		return NULL;
> +	}
> +
> +	return ptr + MCOUNT_INSN_SIZE + calc.offset;
> +}
> +
> +void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
> +			   unsigned long frame_pointer);
> +
> +/*
> + * If the ops->trampoline was not allocated, then it probably
> + * has a static trampoline func, or is the ftrace caller itself.
> + */
> +static void *static_tramp_func(struct ftrace_ops *ops, struct dyn_ftrace *rec)

I guess you can merge this one into its only caller below - it is not
that huge... yet! :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

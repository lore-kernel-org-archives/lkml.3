Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbaCMSdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 14:33:50 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:6111 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754468AbaCMSdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 14:33:49 -0400
Message-ID: <1394735618.26600.19.camel@pippen.local.home>
Subject: Re: [PATCH v6 5/7] arm64: ftrace: Add dynamic ftrace support
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Deacon <will.deacon@arm.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 13 Mar 2014 14:33:38 -0400
In-Reply-To: <20140313181033.GH25472@mudshark.cambridge.arm.com>
References: <1393564724-3966-1-git-send-email-takahiro.akashi@linaro.org>
	 <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
	 <1394705630-12384-6-git-send-email-takahiro.akashi@linaro.org>
	 <20140313181033.GH25472@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-13 at 18:10 +0000, Will Deacon wrote:
>  
> > +#else /* CONFIG_DYNAMIC_FTRACE */
> > +/*
> > + * _mcount() is used to build the kernel with -pg option, but all the branch
> > + * instructions to _mcount() are replaced to NOP initially at kernel start up,
> > + * and later on, NOP to branch to ftrace_caller() when enabled or branch to
> > + * NOP when disabled per-function base.
> > + */
> > +ENTRY(_mcount)
> > +	ret
> > +ENDPROC(_mcount)
> 
> Judging by your comment then, this should never be called. Is that right? If
> so, we could add a BUG-equivalent so we know if we missed an mcount during
> patching.

Actually, it can be called before the change to nops are done in early
boot. This is done very early, but everything before ftrace_init() in
init/main.c can still call _mcount.


> > +	/*
> > +	 * Note:
> > +	 * Due to modules and __init, code can disappear and change,
> > +	 * we need to protect against faulting as well as code changing.
> > +	 * We do this by aarch64_insn_*() which use the probe_kernel_*().
> > +	 *
> > +	 * No lock is held here because all the modifications are run
> > +	 * through stop_machine().
> > +	 */
> > +	if (validate) {
> > +		if (aarch64_insn_read((void *)pc, &replaced))
> > +			return -EFAULT;
> > +
> > +		if (replaced != old)
> > +			return -EINVAL;
> > +	}
> > +	if (aarch64_insn_patch_text_nosync((void *)pc, new))
> > +		return -EPERM;
> 
> I think you're better off propagating the errors here, rather than
> overriding them with EFAULT/EINVAL/EPERM.

The ftrace generic code expects to see these specific errors. Look at
ftrace_bug() in kernel/trace/ftrace.c.

> 
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Replace tracer function in ftrace_caller()
> > + */
> > +int ftrace_update_ftrace_func(ftrace_func_t func)
> > +{
> > +	unsigned long pc;
> > +	unsigned int new;
> > +
> > +	pc = (unsigned long)&ftrace_call;
> > +	new = aarch64_insn_gen_branch_imm(pc, (unsigned long)func, true);
> > +
> > +	return ftrace_modify_code(pc, 0, new, false);
> > +}
> > +
> > +/*
> > + * Turn on the call to ftrace_caller() in instrumented function
> > + */
> > +int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
> > +{
> > +	unsigned long pc = rec->ip;
> > +	unsigned int old, new;
> > +
> > +	old = aarch64_insn_gen_nop();
> > +	new = aarch64_insn_gen_branch_imm(pc, addr, true);
> > +
> > +	return ftrace_modify_code(pc, old, new, true);
> > +}
> > +
> > +/*
> > + * Turn off the call to ftrace_caller() in instrumented function
> > + */
> > +int ftrace_make_nop(struct module *mod,
> > +		    struct dyn_ftrace *rec, unsigned long addr)
> > +{
> > +	unsigned long pc = rec->ip;
> > +	unsigned int old, new;
> > +
> > +	old = aarch64_insn_gen_branch_imm(pc, addr, true);
> > +	new = aarch64_insn_gen_nop();
> > +
> > +	return ftrace_modify_code(pc, old, new, true);
> > +}
> > +
> > +int __init ftrace_dyn_arch_init(void *data)
> > +{
> > +	*(unsigned long *)data = 0;
> > +
> > +	return 0;
> > +}
> > +#endif /* CONFIG_DYNAMIC_FTRACE */
> > +
> >  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> >  /*
> >   * function_graph tracer expects ftrace_return_to_handler() to be called
> > @@ -61,4 +144,34 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
> >  		return;
> >  	}
> >  }
> > +
> > +#ifdef CONFIG_DYNAMIC_FTRACE
> > +/*
> > + * Turn on/off the call to ftrace_graph_caller() in ftrace_caller()
> > + * depending on @enable.
> > + */
> > +static int ftrace_modify_graph_caller(bool enable)
> > +{
> > +	unsigned long pc = (unsigned long)&ftrace_graph_call;
> > +	unsigned int branch, nop, old, new;
> > +
> > +	branch = aarch64_insn_gen_branch_imm(pc,
> > +			(unsigned long)ftrace_graph_caller, false);
> > +	nop = aarch64_insn_gen_nop();
> > +	old = enable ? nop : branch;
> > +	new = enable ? branch : nop;
> > +
> > +	return ftrace_modify_code(pc, old, new, true);
> 
> You could rewrite this as:
> 
> 	if (enable)
> 		return ftrace_modify_code(pc, nop, branch, true);
> 	else
> 		return ftrace_modify_code(pc, branch, nop, true);
> 
> which I find easier to read.

Heh, maybe that could be updated in other archs too. I'll have to think
about that one.

-- Steve



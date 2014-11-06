Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaKFOCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:02:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:3149 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750828AbaKFOCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:02:04 -0500
Date: Thu, 6 Nov 2014 09:01:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [for-next][PATCH 2/4] ftrace/x86: Show trampoline call function
 in enabled_functions
Message-ID: <20141106090157.5b2b562b@gandalf.local.home>
In-Reply-To: <20141105104207.GB5245@pd.tnic>
References: <20141027182702.778680710@goodmis.org>
	<20141027182948.432689737@goodmis.org>
	<20141105104207.GB5245@pd.tnic>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014 11:42:07 +0100
Borislav Petkov <bp@alien8.de> wrote:


> > diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> > index e4d48f6cad86..ca17c20a1010 100644
> > --- a/arch/x86/kernel/ftrace.c
> > +++ b/arch/x86/kernel/ftrace.c
> > @@ -48,7 +48,7 @@ int ftrace_arch_code_modify_post_process(void)
> >  union ftrace_code_union {
> >  	char code[MCOUNT_INSN_SIZE];
> >  	struct {
> > -		char e8;
> > +		unsigned char e8;
> 
> u8?
> 
> "u8 e8;" looks supa dupa though :-)

And compete with PowerPC's eieio command.

> 
> >  		int offset;
> >  	} __attribute__((packed));
> >  };
> > @@ -797,12 +797,26 @@ static unsigned long create_trampoline(struct ftrace_ops *ops)
> >  	return (unsigned long)trampoline;
> >  }
> >  
> > +static unsigned long calc_trampoline_call_offset(bool save_regs)
> > +{
> > +	unsigned long start_offset;
> > +	unsigned long call_offset;
> > +
> > +	if (save_regs) {
> > +		start_offset = (unsigned long)ftrace_regs_caller;
> > +		call_offset = (unsigned long)ftrace_regs_call;
> > +	} else {
> > +		start_offset = (unsigned long)ftrace_caller;
> > +		call_offset = (unsigned long)ftrace_call;
> > +	}
> > +
> > +	return call_offset - start_offset;
> > +}
> > +
> >  void arch_ftrace_update_trampoline(struct ftrace_ops *ops)
> >  {
> >  	ftrace_func_t func;
> >  	unsigned char *new;
> > -	unsigned long start_offset;
> > -	unsigned long call_offset;
> >  	unsigned long offset;
> >  	unsigned long ip;
> >  	int ret;
> > @@ -820,15 +834,7 @@ void arch_ftrace_update_trampoline(struct ftrace_ops *ops)
> >  			return;
> >  	}
> >  
> > -	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
> > -		start_offset = (unsigned long)ftrace_regs_caller;
> > -		call_offset = (unsigned long)ftrace_regs_call;
> > -	} else {
> > -		start_offset = (unsigned long)ftrace_caller;
> > -		call_offset = (unsigned long)ftrace_call;
> > -	}
> > -
> > -	offset = call_offset - start_offset;
> > +	offset = calc_trampoline_call_offset(ops->flags & FTRACE_OPS_FL_SAVE_REGS);
> >  	ip = ops->trampoline + offset;
> >  
> >  	func = ftrace_ops_get_func(ops);
> > @@ -840,6 +846,74 @@ void arch_ftrace_update_trampoline(struct ftrace_ops *ops)
> >  	/* The update should never fail */
> >  	WARN_ON(ret);
> >  }
> > +
> > +/* Return the address of the function the trampoline calls */
> > +static void *addr_from_call(void *ptr)
> > +{
> > +	union ftrace_code_union calc;
> > +	int ret;
> > +
> > +	ret = probe_kernel_read(&calc, ptr, MCOUNT_INSN_SIZE);
> > +	if (WARN_ON_ONCE(ret < 0))
> > +		return NULL;
> > +
> > +	/* Make sure this is a call */
> > +	if (WARN_ON_ONCE(calc.e8 != 0xe8)) {
> > +		pr_warn("Expected e8, got %x\n", calc.e8);
> 
> Simply WARN_ONCE gives you both.

Ah, could do that.

> 
> > +		return NULL;
> > +	}
> > +
> > +	return ptr + MCOUNT_INSN_SIZE + calc.offset;
> > +}
> > +
> > +void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
> > +			   unsigned long frame_pointer);
> > +
> > +/*
> > + * If the ops->trampoline was not allocated, then it probably
> > + * has a static trampoline func, or is the ftrace caller itself.
> > + */
> > +static void *static_tramp_func(struct ftrace_ops *ops, struct dyn_ftrace *rec)
> 
> I guess you can merge this one into its only caller below - it is not
> that huge... yet! :-)
> 

Hmm, it's big enough not to be in that function as a if statement that
will return anyway.

gcc will just make it inlined anyway. I think it's better separate for
readability.

-- Steve


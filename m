Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaKFN50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:57:26 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:65358 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750998AbaKFN5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:57:23 -0500
Date: Thu, 6 Nov 2014 08:57:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [for-next][PATCH 1/4] ftrace/x86: Add dynamic allocated
 trampoline for ftrace_ops
Message-ID: <20141106085715.2ba0771e@gandalf.local.home>
In-Reply-To: <20141105102801.GA5245@pd.tnic>
References: <20141027182702.778680710@goodmis.org>
	<20141027182948.284867581@goodmis.org>
	<20141105102801.GA5245@pd.tnic>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014 11:28:01 +0100
Borislav Petkov <bp@alien8.de> wrote:

> > --- a/arch/x86/kernel/ftrace.c
> > +++ b/arch/x86/kernel/ftrace.c
> > @@ -17,6 +17,7 @@
> >  #include <linux/ftrace.h>
> >  #include <linux/percpu.h>
> >  #include <linux/sched.h>
> > +#include <linux/slab.h>
> >  #include <linux/init.h>
> >  #include <linux/list.h>
> >  #include <linux/module.h>
> > @@ -644,13 +645,8 @@ int __init ftrace_dyn_arch_init(void)
> >  {
> >  	return 0;
> >  }
> > -#endif
> > -
> > -#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> > -
> > -#ifdef CONFIG_DYNAMIC_FTRACE
> > -extern void ftrace_graph_call(void);
> >  
> > +#if defined(CONFIG_X86_64) || defined(CONFIG_FUNCTION_GRAPH_TRACER)
> >  static unsigned char *ftrace_jmp_replace(unsigned long ip, unsigned long addr)
> >  {
> >  	static union ftrace_code_union calc;
> > @@ -664,6 +660,193 @@ static unsigned char *ftrace_jmp_replace(unsigned long ip, unsigned long addr)
> >  	 */
> >  	return calc.code;
> >  }
> > +#endif
> > +
> > +/* Currently only x86_64 supports dynamic trampolines */
> > +#ifdef CONFIG_X86_64
> > +
> > +#ifdef CONFIG_MODULES
> > +#include <linux/moduleloader.h>
> > +/* Module allocation simplifies allocating memory for code */
> 
> ... because it makes it EXEC too?

Yeah, I should have specified that.

> 
> > +static inline void *alloc_tramp(unsigned long size)
> 
> Yeah, naming is, hmm, rated R. But we talked about it :-)

It's used in Disney movies, I doubt it's rated R.

> 
> > +{
> > +	return module_alloc(size);
> > +}
> > +static inline void tramp_free(void *tramp)
> > +{
> > +	module_free(NULL, tramp);
> > +}
> > +#else
> > +/* Trampolines can only be created if modules are supported */
> 
> Just for my own understanding: why? You're not loading additional .ko's
> right?

It goes back to the EXEC issue. The module allocation goes through
leaps and bounds to get memory allocated for EXEC correct. I wasn't
about to duplicate that.

Ideally, there should be a generic way to allocate memory that will be
used for executing code, but right now we depend on module code.

> 
> > +static inline void *alloc_tramp(unsigned long size)
> > +{
> > +	return NULL;
> > +}
> > +static inline void tramp_free(void *tramp) { }
> > +#endif
> > +
> > +/* Defined as markers to the end of the ftrace default trampolines */
> > +extern void ftrace_caller_end(void);
> > +extern void ftrace_regs_caller_end(void);
> > +extern void ftrace_return(void);
> > +extern void ftrace_caller_op_ptr(void);
> > +extern void ftrace_regs_caller_op_ptr(void);
> > +
> > +/* movq function_trace_op(%rip), %rdx */
> > +/* 0x48 0x8b 0x15 <offset-to-ftrace_trace_op (4 bytes)> */
> > +#define OP_REF_SIZE	7
> > +
> > +/*
> > + * The ftrace_ops is passed to the function callback. Since the
> > + * trampoline only services a single ftrace_ops, we can pass in
> > + * that ops directly.
> > + *
> > + * The ftrace_op_code_union is used to create a pointer to the
> > + * ftrace_ops that will be passed to the callback function.
> > + */
> > +union ftrace_op_code_union {
> > +	char code[OP_REF_SIZE];
> > +	struct {
> > +		char op[3];
> > +		int offset;
> > +	} __attribute__((packed));
> > +};
> > +
> > +static unsigned long create_trampoline(struct ftrace_ops *ops)
> > +{
> > +	unsigned const char *jmp;
> > +	unsigned long start_offset;
> > +	unsigned long end_offset;
> > +	unsigned long op_offset;
> > +	unsigned long offset;
> > +	unsigned long size;
> > +	unsigned long ip;
> > +	unsigned long *ptr;
> > +	void *trampoline;
> > +	/* 48 8b 15 <offset> is movq <offset>(%rip), %rdx */
> > +	unsigned const char op_ref[] = { 0x48, 0x8b, 0x15 };
> 
> Ok, this 0x15 is the ModRM which says that the destination register is
> hammered to be %rdx. I guess this has something to do with the magic
> third parameter thing where ftrace_ops go into...

Yes, the ftrace_ops is passed in as the third parameter.

> 
> > +	union ftrace_op_code_union op_ptr;
> > +	int ret;
> > +
> > +	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
> > +		start_offset = (unsigned long)ftrace_regs_caller;
> > +		end_offset = (unsigned long)ftrace_regs_caller_end;
> > +		op_offset = (unsigned long)ftrace_regs_caller_op_ptr;
> > +	} else {
> > +		start_offset = (unsigned long)ftrace_caller;
> > +		end_offset = (unsigned long)ftrace_caller_end;
> > +		op_offset = (unsigned long)ftrace_caller_op_ptr;
> > +	}
> > +
> > +	size = end_offset - start_offset;
> > +
> > +	/*
> > +	 * Allocate enough size to store the ftrace_caller code,
> > +	 * the jmp to ftrace_return, as well as the address of
> > +	 * the ftrace_ops this trampoline is used for.
> > +	 */
> > +	trampoline = alloc_tramp(size + MCOUNT_INSN_SIZE + sizeof(void *));
> > +	if (!trampoline)
> > +		return 0;
> > +
> > +	/* Copy ftrace_caller onto the trampoline memory */
> > +	ret = probe_kernel_read(trampoline, (void *)start_offset, size);
> > +	if (WARN_ON(ret < 0)) {
> > +		tramp_free(trampoline);
> 
> A tramp-free trampoline? :-P
> 
> Btw, "trmp" could be a good, short and politically correct prefix to
> this stuff:
> 
> trmp_alloc()
> trmp_free()

I just see "Trump" which to me is less politically correct than
Tramp ;-)

> ...
> 
> :-)
> 
> > +		return 0;
> > +	}
> > +
> > +	ip = (unsigned long)trampoline + size;
> > +
> > +	/* The trampoline ends with a jmp to ftrace_return */
> > +	jmp = ftrace_jmp_replace(ip, (unsigned long)ftrace_return);
> > +	memcpy(trampoline + size, jmp, MCOUNT_INSN_SIZE);
> > +
> > +	/*
> > +	 * The address of the ftrace_ops that is used for this trampoline
> > +	 * is stored at the end of the trampoline. This will be used to
> > +	 * load the third parameter for the callback. Basically, that
> > +	 * location at the end of the trampoline takes the place of
> > +	 * the global function_trace_op variable.
> > +	 */
> > +
> 
> Spurious newline.
> 
> > +	ptr = (unsigned long *)(trampoline + size + MCOUNT_INSN_SIZE);
> 
> Maybe we should call this variable ftrace_ops_ptr to be more clear?
> 
> > +	*ptr = (unsigned long)ops;
> > +
> > +	op_offset -= start_offset;
> > +	memcpy(&op_ptr, trampoline + op_offset, OP_REF_SIZE);
> 
> I guess we can copy only 3 bytes here and not OP_REF_SIZE as we
> overwrite op_ptr.offset later anyway.

Yeah I guess we could.

> 
> > +
> > +	/* Are we pointing to the reference? */
> 
> "Are we pointing to the movq" is what we ask here, no?

Yep. I guess I should have said, "Are we pointing to the correct
label?".

> 
> > +	if (WARN_ON(memcmp(op_ptr.op, op_ref, 3) != 0)) {
> > +		tramp_free(trampoline);
> > +		return 0;
> > +	}
> > +
> > +	/* Load the contents of ptr into the callback parameter */
> > +	offset = (unsigned long)ptr;
> > +	offset -= (unsigned long)trampoline + op_offset + OP_REF_SIZE;
> > +
> > +	op_ptr.offset = offset;
> > +
> > +	/* put in the new offset to the ftrace_ops */
> > +	memcpy(trampoline + op_offset, &op_ptr, OP_REF_SIZE);
> > +
> > +	/* ALLOC_TRAMP flags lets us know we created it */
> > +	ops->flags |= FTRACE_OPS_FL_ALLOC_TRAMP;
> > +
> > +	return (unsigned long)trampoline;
> > +}
> > +
> 
> Yeah, it looks ok as far as I can tell by looking around and trying to
> piece it together from staring at ftrace-design.txt and the rest of the
> fun.
> 
> But don't take my word for it :-)
> 

Thanks,

I may update some of the comments and such. It will have to be a
separate patch. I already tested the hell out of these and have a bunch
of commits on top that have also been fully tested. Any rebase would
throw all that away.

-- Steve

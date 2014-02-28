Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaB1QAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:00:13 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:2657 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752509AbaB1QAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:00:11 -0500
Date: Fri, 28 Feb 2014 11:00:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH] x86 trace: Fix page fault tracing bug
Message-ID: <20140228160006.GA19658@home.goodmis.org>
References: <1393601620-13117-1-git-send-email-jolsa@redhat.com>
 <20140228154715.GC1133@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228154715.GC1133@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince, can you test this patch instead. Seems that the bug you found was
found by others. You can remove all patches again, and modify this patch such
that the read of cr2 is before the exception_enter() call (in both locations)

On Fri, Feb 28, 2014 at 04:47:15PM +0100, Jiri Olsa wrote:
> On Fri, Feb 28, 2014 at 04:33:40PM +0100, Jiri Olsa wrote:
> > The trace_do_page_fault function trigger tracepoint
> > and then handles the actual page fault.
> > 
> > This could lead to error if the tracepoint caused page
> > fault. The original cr2 value gets lost and the original
> > page fault handler kills current process with SIGSEGV.
> > 
> > This happens if you record page faults with callchain
> > data, the user part of it will cause tracepoint handler
> > to page fault:
> > 
> >   # perf record -g -e exceptions:page_fault_user ls
> > 
> > Fixing this by saving the original cr2 value
> > and using it after tracepoint handler is done.
> > 
> 
> sry, forgot..
> 
> Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Please also add:

Reported-by: Vince Weaver <vincent.weaver@maine.edu>

And after verificiation, add a Tested-by for him too. He's been doing a
lot to help us solve this bug (from a different angle).

You may also add:

Link: http://lkml.kernel.org/r/20140224172536.GD9987@twins.programming.kicks-ass.net

-- Steve


> 
> jirka
> 
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Seiji Aguchi <seiji.aguchi@hds.com>
> > ---
> >  arch/x86/mm/fault.c | 25 ++++++++++++++++++-------
> >  1 file changed, 18 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> > index 9d591c8..52fad6c 100644
> > --- a/arch/x86/mm/fault.c
> > +++ b/arch/x86/mm/fault.c
> > @@ -1016,11 +1016,11 @@ static inline bool smap_violation(int error_code, struct pt_regs *regs)
> >   * routines.
> >   */
> >  static void __kprobes
> > -__do_page_fault(struct pt_regs *regs, unsigned long error_code)
> > +__do_page_fault(struct pt_regs *regs, unsigned long error_code,
> > +		unsigned long address)
> >  {
> >  	struct vm_area_struct *vma;
> >  	struct task_struct *tsk;
> > -	unsigned long address;
> >  	struct mm_struct *mm;
> >  	int fault;
> >  	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
> > @@ -1028,9 +1028,6 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code)
> >  	tsk = current;
> >  	mm = tsk->mm;
> >  
> > -	/* Get the faulting address: */
> > -	address = read_cr2();
> > -
> >  	/*
> >  	 * Detect and handle instructions that would cause a page fault for
> >  	 * both a tracked kernel page and a userspace page.
> > @@ -1248,9 +1245,14 @@ dotraplinkage void __kprobes
> >  do_page_fault(struct pt_regs *regs, unsigned long error_code)
> >  {
> >  	enum ctx_state prev_state;
> > +	unsigned long address;
> >  
> >  	prev_state = exception_enter();
> > -	__do_page_fault(regs, error_code);
> > +
> > +	/* Get the faulting address: */
> > +	address = read_cr2();
> > +
> > +	__do_page_fault(regs, error_code, address);
> >  	exception_exit(prev_state);
> >  }
> >  
> > @@ -1267,9 +1269,18 @@ dotraplinkage void __kprobes
> >  trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
> >  {
> >  	enum ctx_state prev_state;
> > +	unsigned long address;
> >  
> >  	prev_state = exception_enter();
> > +
> > +	/*
> > +	 * The tracepoint processing could trigger another page
> > +	 * fault (user space callchain reading) and destroy the
> > +	 * original cr2 value, so read the faulting address now.
> > +	 */
> > +	address = read_cr2();
> > +
> >  	trace_page_fault_entries(regs, error_code);
> > -	__do_page_fault(regs, error_code);
> > +	__do_page_fault(regs, error_code, address);
> >  	exception_exit(prev_state);
> >  }
> > -- 
> > 1.7.11.7
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

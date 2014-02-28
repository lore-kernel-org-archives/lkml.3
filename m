Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaB1QPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:15:40 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:10491 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751580AbaB1QPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:15:39 -0500
Date: Fri, 28 Feb 2014 11:15:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCHv2] x86 trace: Fix page fault tracing bug
Message-ID: <20140228111537.16e1635e@gandalf.local.home>
In-Reply-To: <20140228160526.GD1133@krava.brq.redhat.com>
References: <1393601620-13117-1-git-send-email-jolsa@redhat.com>
	<20140228154708.GI9987@twins.programming.kicks-ass.net>
	<20140228160526.GD1133@krava.brq.redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince, you probably missed my other emails, as I sent from mutt, and
not my normal email client. I see that mutt uses my own box to send,
and I got these error messages (need to put back sending via my ISP
instead of my local mail server):

>>> vincent.weaver@maine.edu (after MAIL FROM): 550 5.5.4 <rostedt@home.goodmis.org>... Domain of sender address rostedt@home.goodmis.org refused. MX points to hosts without valid addresses. This violates RFC 1035/2181.  

-- Steve


On Fri, 28 Feb 2014 17:05:26 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> On Fri, Feb 28, 2014 at 04:47:08PM +0100, Peter Zijlstra wrote:
> > On Fri, Feb 28, 2014 at 04:33:40PM +0100, Jiri Olsa wrote:
> > 
> > While I like the idea of just pushing up the CR2 read; the below does
> > the read too late still, exception_enter() also has a tracepoint in.
> 
> please check v2, thanks
> 
> jirka
> 
> 
> ---
> The trace_do_page_fault function trigger tracepoint
> and then handles the actual page fault.
> 
> This could lead to error if the tracepoint caused page
> fault. The original cr2 value gets lost and the original
> page fault handler kills current process with SIGSEGV.
> 
> This happens if you record page faults with callchain
> data, the user part of it will cause tracepoint handler
> to page fault:
> 
>   # perf record -g -e exceptions:page_fault_user ls
> 
> Fixing this by saving the original cr2 value
> and using it after tracepoint handler is done.
> 
> v2: Moving the cr2 read before exception_enter, because
>     it could trigger tracepoint as well.
> 
> Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Seiji Aguchi <seiji.aguchi@hds.com>
> Cc: Vince Weaver <vincent.weaver@maine.edu>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/mm/fault.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 9d591c8..dd59031 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1016,11 +1016,11 @@ static inline bool smap_violation(int error_code, struct pt_regs *regs)
>   * routines.
>   */
>  static void __kprobes
> -__do_page_fault(struct pt_regs *regs, unsigned long error_code)
> +__do_page_fault(struct pt_regs *regs, unsigned long error_code,
> +		unsigned long address)
>  {
>  	struct vm_area_struct *vma;
>  	struct task_struct *tsk;
> -	unsigned long address;
>  	struct mm_struct *mm;
>  	int fault;
>  	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
> @@ -1028,9 +1028,6 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  	tsk = current;
>  	mm = tsk->mm;
>  
> -	/* Get the faulting address: */
> -	address = read_cr2();
> -
>  	/*
>  	 * Detect and handle instructions that would cause a page fault for
>  	 * both a tracked kernel page and a userspace page.
> @@ -1248,9 +1245,11 @@ dotraplinkage void __kprobes
>  do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  {
>  	enum ctx_state prev_state;
> +	/* Get the faulting address: */
> +	unsigned long address = read_cr2();
>  
>  	prev_state = exception_enter();
> -	__do_page_fault(regs, error_code);
> +	__do_page_fault(regs, error_code, address);
>  	exception_exit(prev_state);
>  }
>  
> @@ -1267,9 +1266,16 @@ dotraplinkage void __kprobes
>  trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  {
>  	enum ctx_state prev_state;
> +	/*
> +	 * The exception_enter and tracepoint processing could
> +	 * trigger another page faults (user space callchain
> +	 * reading) and destroy the original cr2 value, so read
> +	 * the faulting address now.
> +	 */
> +	unsigned long address = read_cr2();
>  
>  	prev_state = exception_enter();
>  	trace_page_fault_entries(regs, error_code);
> -	__do_page_fault(regs, error_code);
> +	__do_page_fault(regs, error_code, address);
>  	exception_exit(prev_state);
>  }


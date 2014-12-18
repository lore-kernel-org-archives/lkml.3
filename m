Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaLRO27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 09:28:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbaLRO26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 09:28:58 -0500
Date: Thu, 18 Dec 2014 15:28:27 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] perf ftrace: Factor regs retrieval for function tracer
Message-ID: <20141218142827.GB18898@krava.brq.redhat.com>
References: <20141216115041.GW3337@twins.programming.kicks-ass.net>
 <20141217143105.GG18257@krava.brq.redhat.com>
 <20141217153508.GC30905@twins.programming.kicks-ass.net>
 <20141217154507.GA20471@krava.brq.redhat.com>
 <20141218140847.GA18898@krava.brq.redhat.com>
 <20141218142027.GE30905@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141218142027.GE30905@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 03:20:27PM +0100, Peter Zijlstra wrote:
> On Thu, Dec 18, 2014 at 03:08:47PM +0100, Jiri Olsa wrote:
> > diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
> > index 6fa484de2ba1..54bffedd28b6 100644
> > --- a/kernel/trace/trace_event_perf.c
> > +++ b/kernel/trace/trace_event_perf.c
> > @@ -304,7 +304,7 @@ perf_ftrace_function_call(unsigned long ip, unsigned long parent_ip,
> >  {
> >  	struct ftrace_entry *entry;
> >  	struct hlist_head *head;
> > -	struct pt_regs regs;
> > +	struct pt_regs **regsp, *regs = pt_regs;
> >  	int rctx;
> >  
> >  	head = this_cpu_ptr(event_function.perf_events);
> > @@ -316,16 +316,24 @@ perf_ftrace_function_call(unsigned long ip, unsigned long parent_ip,
> >  
> >  	BUILD_BUG_ON(ENTRY_SIZE > PERF_MAX_TRACE_SIZE);
> >  
> > -	perf_fetch_caller_regs(&regs);
> > +	/*
> > +	 * The ftrace_ops is registered with SAVE_REGS_IF_SUPPORTED,
> > +	 * so if we got pt_regs defined, we don't need to retrieve
> > +	 * regs buffer through perf_trace_buf_prepare.
> > +	 */
> > +	regsp = pt_regs ? NULL : &regs;
> >  
> > -	entry = perf_trace_buf_prepare(ENTRY_SIZE, TRACE_FN, NULL, &rctx);
> > +	entry = perf_trace_buf_prepare(ENTRY_SIZE, TRACE_FN, regsp, &rctx);
> >  	if (!entry)
> >  		return;
> >  
> > +	if (regsp)
> > +		perf_fetch_caller_regs(regs);
> > +
> 
> 
> Would not something like:
> 
> 	struct pt_regs *regs;
> 
> 	entry = perf_trace_buf_prepare(ENTRY_SIZE, TRACE_FN, &regs, &rctx);
> 	if (!pt_regs) {
> 		perf_fetch_caller_regs(regs);
> 		pt_regs = regs;
> 	}
> 
> Be simpler?

well, I wanted to omit touching the '__perf_regs' var
in perf_trace_buf_prepare:

        if (regs)
                *regs = this_cpu_ptr(&__perf_regs[*rctxp]);

jirka

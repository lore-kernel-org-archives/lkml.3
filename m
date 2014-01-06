Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbaAFToE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 14:44:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:23555 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101AbaAFToB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 14:44:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,614,1384329600"; 
   d="scan'208";a="434659670"
Message-ID: <1389037440.3040.56.camel@empanada>
Subject: Re: [PATCH] tracing/kprobes: Add trace event trigger invocations
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 06 Jan 2014 13:44:00 -0600
In-Reply-To: <20140106111055.2cf828f7@gandalf.local.home>
References: <1388283848.3048.1.camel@empanada>
	 <20140106111055.2cf828f7@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-06 at 11:10 -0500, Steven Rostedt wrote:
> On Sat, 28 Dec 2013 20:24:08 -0600
> Tom Zanussi <tom.zanussi@linux.intel.com> wrote:
> 
> > Add code to the kprobe/kretprobe event functions that will invoke any
> > event triggers associated with a probe's ftrace_event_file.
> > 
> > The code to do this is very similar to the invocation code already
> > used to invoke the triggers associated with static events and
> > essentially replaces the existing soft-disable checks with a superset
> > that preserves the original behavior but adds the bits needed to
> > support event triggers.
> > 
> > Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
> > ---
> >  kernel/trace/trace_kprobe.c | 42 ++++++++++++++++++++++++++++++++++++------
> >  1 file changed, 36 insertions(+), 6 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> > index dae9541..1ee13eb 100644
> > --- a/kernel/trace/trace_kprobe.c
> > +++ b/kernel/trace/trace_kprobe.c
> > @@ -812,12 +812,20 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
> >  	struct ring_buffer *buffer;
> >  	int size, dsize, pc;
> >  	unsigned long irq_flags;
> > +	unsigned long eflags;
> > +	enum event_trigger_type __tt = ETT_NONE;
> 
> What's the significance of the "__" in the variable?
> 
> Looks as if you copied it from the ftrace_raw_event_* macro. The "__"
> there is usually recommended because it is a macro and we try to avoid
> namespace collisions by adding the "__".
> 
> This is a proper function, please remove the "__" from it.
> 

Right, it was just for consistency with the other invocations.  Updates
to this and the syscall invocations which also do the same thing, coming
up...

Tom

> Thanks,
> 
> -- Steve
> 
> 
> >  	struct ftrace_event_call *call = &tp->call;
> >  
> >  	WARN_ON(call != ftrace_file->event_call);
> >  
> > -	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
> > -		return;
> > +	eflags = ftrace_file->flags;
> > +
> > +	if (!(eflags & FTRACE_EVENT_FL_TRIGGER_COND)) {
> > +		if (eflags & FTRACE_EVENT_FL_TRIGGER_MODE)
> > +			event_triggers_call(ftrace_file, NULL);
> > +		if (eflags & FTRACE_EVENT_FL_SOFT_DISABLED)
> > +			return;
> > +	}
> >  
> >  	local_save_flags(irq_flags);
> >  	pc = preempt_count();



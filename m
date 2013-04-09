Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934913Ab3DIPCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 11:02:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761304Ab3DIPCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 11:02:30 -0400
Date: Tue, 9 Apr 2013 16:58:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] uprobes/tracing: Kill the pointless
	local_save_flags/preempt_count calls
Message-ID: <20130409145851.GB22913@redhat.com>
References: <20130329181545.GA20697@redhat.com> <1365436722.25498.14.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365436722.25498.14.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08, Steven Rostedt wrote:
>
> On Fri, 2013-03-29 at 19:15 +0100, Oleg Nesterov wrote:
> > --- a/kernel/trace/trace_uprobe.c
> > +++ b/kernel/trace/trace_uprobe.c
> > @@ -492,17 +492,13 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
> >  	struct ring_buffer_event *event;
> >  	struct ring_buffer *buffer;
> >  	u8 *data;
> > -	int size, i, pc;
> > -	unsigned long irq_flags;
> > +	int size, i;
> >  	struct ftrace_event_call *call = &tu->call;
> >
> > -	local_save_flags(irq_flags);
> > -	pc = preempt_count();
>
> How about instead, just change the above two and have:
>
> 	/* uprobes are never called with preemption disabled */
> 	pc = 0;
> 	irq_flags = 0;
>
> and leave the rest the same. This will help in future reviewers of the
> code to not have to look up what that "0, 0" is for, and then wonder if
> it should be that way. gcc should optimize it to be exactly the same as
> this patch.

Hmm, just to remind which arguments trace_current_buffer_*() has?

Personally I disagree. And, for example, ftrace_syscall_enter/exit just
use 0,0 for the same reason.

So please tell me if you really want the dummy variables/arguments, in
this case I'll change this code even if I do not like it.

Oleg.


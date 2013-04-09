Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935832Ab3DINlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:41:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358Ab3DINlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:41:31 -0400
Date: Tue, 9 Apr 2013 15:33:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] uprobes/tracing: Make uprobe_{trace,perf}_print()
	uretprobe-friendly
Message-ID: <20130409133333.GA19185@redhat.com>
References: <20130401160827.GA19206@redhat.com> <20130401160851.GA19576@redhat.com> <20130407103159.GA6810@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130407103159.GA6810@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2013-04-01 18:08:51]:
>
> > diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> > index e91a354..db2718a 100644
> > --- a/kernel/trace/trace_uprobe.c
> > +++ b/kernel/trace/trace_uprobe.c
> > @@ -515,15 +515,26 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
> >  	int size, i;
> >  	struct ftrace_event_call *call = &tu->call;
> >
> > -	size = SIZEOF_TRACE_ENTRY(1) + tu->size;
> > +	if (is_ret_probe(tu))
>
> One nit:
> Here and couple of places below .. we could check for func instead of
> is_ret_probe() right?

Yes we could. And note that we do not really need both uprobe_trace_func()
and uretprobe_perf_func(), we could use a single function and check "func".

But:

> Or is there an advantage of checking is_ret_probe() over func?

I believe yes. Firstly, we can't use 0ul as "invalid func address" to detect
the !is_ret_probe() case, we need, say, -1ul which probably needs a symbolic
name. In fact, I'd prefer to add another "is_return" argument if we want to
avoid is_ret_probe() and unify 2 functions.

But more importantly, I think that is_ret_probe() is much more grep-friendly
and thus more understandable and consistent with other checks which can not
rely on "func".

> >  static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
> >  {
> > -	uprobe_trace_print(tu, 0, regs);
> > +	if (!is_ret_probe(tu))
> > +		uprobe_trace_print(tu, 0, regs);
>
> Should this hunk be in the previous patch?

Well, I dunno. Even if this hunk goes into the previous patch it won't
make the "print" logic correct until we change uprobe_trace_print(), iow
to me this logically connects to uprobe_trace_print() changed by this patch.

And correctness-wise this doesn't matter, until 6/6 make is_ret_probe() == T
possible we should not worry about the "missed" is_ret_probe() checks.

> Also something for the future:
> Most times a user uses a return probe, the user probably wants to probe
> the function entry too. So should we extend the abi from p+r to
> p+r+..<something else> to mean it traces both function entry and return.
> Esp given that uretprobe has been elegantly been designed to make this a
> possibility.

Oh, perhaps, but this is really for the future. In particular, it is not
clear how we can specify normal-fetchargs + ret-fetchargs.

Oleg.


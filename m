Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab3JKMbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:31:48 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:25559 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752338Ab3JKMbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:31:46 -0400
Date: Fri, 11 Oct 2013 08:31:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RFC/PATCH] ftrace: add set_graph_notrace filter
Message-ID: <20131011083145.0d000fbc@gandalf.local.home>
In-Reply-To: <87a9igcj8d.fsf@sejong.aot.lge.com>
References: <1378184708-31385-1-git-send-email-namhyung@kernel.org>
	<20131011001717.26b92150@gandalf.local.home>
	<87a9igcj8d.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Oct 2013 17:19:46 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Steve,
> 
> On Fri, 11 Oct 2013 00:17:17 -0400, Steven Rostedt wrote:
> > Sorry for the very late reply, finally got some time to look at other
> > peoples code.
> 
> Thank you for taking your time to review this carefully. :)

Sorry for it taking so long.



> > I would be a bit more specific in your comment. Explain that
> > curr_ret_stack is negative when we hit a function in the
> > set_graph_notrace file.
> 
> How about this:
> 
> 	/*
> 	 * curr_ret_stack is initialized to -1 and gets increased in
> 	 * this function.  So it can be less than -1 only if it was
> 	 * filtered out via ftrace_graph_notrace_addr() which can be
> 	 * set from set_graph_notrace file in debugfs by user.
> 	 */

Looks good.

> 
> >
> >> +
> >>  	calltime = trace_clock_local();
> >>  
> >>  	index = ++current->curr_ret_stack;
> >> +	if (ftrace_graph_notrace_addr(func))
> >> +		current->curr_ret_stack -= FTRACE_NOTRACE_DEPTH;
> >
> > I really hate this double call to ftrace_graph_notrace_addr(). The
> > first one in trace_graph_entry(), and then here too.
> >
> > Isn't there a way we could pass the state? Hmm, I think we could use
> > depth to do that. As depth is a pointer to trace.depth and not used
> > before then. We could make it negative and then check that.
> >
> > /me looks at other archs.
> >
> > Darn it, s390 calls ftrace_push_return_trace() before
> > ftrace_graph_entry(). They got fancy, as they must have noticed that
> > trace.depth is set by ftrace_push_return_trace() and they just figured
> > to let the ftrace_push_return_trace() do the work.
> 
> Yes, I thought about it before but as you can see other archs go to the
> other way around so I just ended up to call it twice.
> 
> >
> > Hmm, we could add a config to do the check on one side or the other
> > depending on how the arch handles it.
> >
> > It needs to be well commented though.
> 
> Hmm.. maybe.  But it'd better if this function call order is fixed
> IMHO.  Anyway, I'll add comments.

Well, as you probably already saw, s390 changed to help us out :-) Is
there other archs you know about. I haven't looked at all the others
yet. s390 was the first one I saw that didn't follow suit.

Anyway, lets keep your double check for now. I'll look at making the
two function calls from arch into one, where we can optimize this a bit
more.

> 
> >
> >
> >
> >>  	barrier();
> >>  	current->ret_stack[index].ret = ret;
> >>  	current->ret_stack[index].func = func;
> >>  	current->ret_stack[index].calltime = calltime;
> >>  	current->ret_stack[index].subtime = 0;
> >>  	current->ret_stack[index].fp = frame_pointer;
> >> -	*depth = index;
> >> +	*depth = current->curr_ret_stack;
> >>  
> >>  	return 0;
> >>  }
> >> @@ -137,6 +143,9 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret,
> >>  
> >>  	index = current->curr_ret_stack;
> >>  
> >> +	if (index < 0)
> >> +		index += FTRACE_NOTRACE_DEPTH;
> >
> > Speaking of comments. This needs to be commented, and not only that,
> > perhaps this is where another ftrace_graph_notrace_addr() belongs.
> >
> > 	bool check = false;
> >
> > 	if (index < 0) {
> > 		index += FTRACE_NOTRACE_DEPTH;
> > 		check = true;
> > 	}
> >
> > 	[...]
> >
> > 	if (check && !ftrace_graph_notrace_addr(trace->func))
> > 		[ do the same bug as index < 0 ]
> >
> > 		
> >
> > Otherwise if the stack does get corrupted, this will just think we are
> > in a notrace and fail someplace else, making it much harder to debug
> > what went wrong.
> >
> > Hmm, this may be racy, as the user could change the notrace file and
> > this could happen after that, causing a false positive.
> >
> > Well, we could do other tricks, like adding a flag in
> > current->ret_stack[index].func (LSB set).
> >
> > But for now, just comment this better. We can come up with a proper
> > check later. (/me is rambling as I've been on and off reviewing this
> > patch all day, and it's now past my bedtime).
> 
> Sorry for interrupting your bedtime. :)

hehe, I hit an unrelated bug with acpi on 3.12-rc4 when testing your
patches, and went to figure out why (and reported it). Otherwise, I
would have been wide awake when reviewing all of this.


> 
> Hmm.. never thought about the corruption.  And yes, simply checking it
> again here might cause a trouble, I guess.  I'll add a comment for this.
> 
> 	/*
> 	 * A negative index here means that it's just returned from a
> 	 * notrace'd function.  Recover index to get an original return
> 	 * address.  See ftrace_push_return_trace().
> 	 *
> 	 * TODO: Need to check whether the stack gets corrupted.
> 	 */
> 
> >
> >
> >> +
> >>  	if (unlikely(index < 0)) {
> >>  		ftrace_graph_stop();
> >>  		WARN_ON(1);
> >> @@ -193,6 +202,10 @@ unsigned long ftrace_return_to_handler(unsigned long frame_pointer)
> >>  	trace.rettime = trace_clock_local();
> >>  	barrier();
> >>  	current->curr_ret_stack--;
> >> +	if (current->curr_ret_stack < -1) {
> >> +		current->curr_ret_stack += FTRACE_NOTRACE_DEPTH;
> >> +		return ret;
> >> +	}
> >>  
> >>  	/*
> >>  	 * The trace should run after decrementing the ret counter
> >> @@ -259,10 +272,14 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
> >>  
> >>  	/* trace it when it is-nested-in or is a function enabled. */
> >>  	if ((!(trace->depth || ftrace_graph_addr(trace->func)) ||
> >> -	     ftrace_graph_ignore_irqs()) ||
> >> +	     ftrace_graph_ignore_irqs()) || (trace->depth < 0) ||
> >>  	    (max_depth && trace->depth >= max_depth))
> >>  		return 0;
> >>  
> >> +	/* need to reserve a ret_stack entry to recover the depth */
> >> +	if (ftrace_graph_notrace_addr(trace->func))
> >> +		return 1;
> >> +
> >
> > Also, I understand what you are doing here, with making curr_ret_stack
> > negative to denote we are in a state to not do tracing. But it's more
> > of a hack (not a bad one), and really needs to be documented somewhere.
> > That is, the design should be in the comments where it's used, and 5
> > years from now, nobody will understand how the notrace works without
> > spending days trying to figure it out. Let's be nice to that poor soul,
> > and write up what is going on so they don't need to pray to the holy
> > tuna hoping to get a fish of enlightenment on how turning
> > curr_ret_stack negative magically makes the function graph tracing not
> > trace down functions, and magically starts tracing again when it comes
> > back up.
> 
> Fully agreed.  How about this:
> 
> /*
>  * The curr_ret_stack is an index to ftrace return stack of current
>  * task.  Its value should be in [0, FTRACE_RETFUNC_DEPTH) when the
>  * function graph tracer is used.  To support filtering out specific
>  * functions, it makes the index negative by subtracting huge value

                                                s/huge/the max/

>  * (FTRACE_NOTRACE_DEPTH) so when it sees a negative index the ftrace
>  * will ignore the record.  And the index gets recovered when returning
>  * from the filtered function by adding the FTRACE_NOTRACE_DEPTH and
>  * then it will continue to record functions normally.
>  */

Sounds good.

Thanks!

-- Steve

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab3JNA7O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 20:59:14 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:54222 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab3JNA7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 20:59:13 -0400
X-AuditID: 9c93017d-b7b79ae000001729-15-525b41dd347f
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RFC/PATCH] ftrace: add set_graph_notrace filter
References: <1378184708-31385-1-git-send-email-namhyung@kernel.org>
	<20131011001717.26b92150@gandalf.local.home>
	<87a9igcj8d.fsf@sejong.aot.lge.com>
	<20131011083145.0d000fbc@gandalf.local.home>
Date: Mon, 14 Oct 2013 09:59:09 +0900
In-Reply-To: <20131011083145.0d000fbc@gandalf.local.home> (Steven Rostedt's
	message of "Fri, 11 Oct 2013 08:31:45 -0400")
Message-ID: <87wqlgbrc2.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 11 Oct 2013 08:31:45 -0400, Steven Rostedt wrote:
> On Fri, 11 Oct 2013 17:19:46 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>
>> Hi Steve,
>> 
>> On Fri, 11 Oct 2013 00:17:17 -0400, Steven Rostedt wrote:
>> > Sorry for the very late reply, finally got some time to look at other
>> > peoples code.
>> 
>> Thank you for taking your time to review this carefully. :)
>
> Sorry for it taking so long.

Nevermind. :)

>
>> > I would be a bit more specific in your comment. Explain that
>> > curr_ret_stack is negative when we hit a function in the
>> > set_graph_notrace file.
>> 
>> How about this:
>> 
>> 	/*
>> 	 * curr_ret_stack is initialized to -1 and gets increased in
>> 	 * this function.  So it can be less than -1 only if it was
>> 	 * filtered out via ftrace_graph_notrace_addr() which can be
>> 	 * set from set_graph_notrace file in debugfs by user.
>> 	 */
>
> Looks good.
>
>> 
>> >
>> >> +
>> >>  	calltime = trace_clock_local();
>> >>  
>> >>  	index = ++current->curr_ret_stack;
>> >> +	if (ftrace_graph_notrace_addr(func))
>> >> +		current->curr_ret_stack -= FTRACE_NOTRACE_DEPTH;
>> >
>> > I really hate this double call to ftrace_graph_notrace_addr(). The
>> > first one in trace_graph_entry(), and then here too.
>> >
>> > Isn't there a way we could pass the state? Hmm, I think we could use
>> > depth to do that. As depth is a pointer to trace.depth and not used
>> > before then. We could make it negative and then check that.
>> >
>> > /me looks at other archs.
>> >
>> > Darn it, s390 calls ftrace_push_return_trace() before
>> > ftrace_graph_entry(). They got fancy, as they must have noticed that
>> > trace.depth is set by ftrace_push_return_trace() and they just figured
>> > to let the ftrace_push_return_trace() do the work.
>> 
>> Yes, I thought about it before but as you can see other archs go to the
>> other way around so I just ended up to call it twice.
>> 
>> >
>> > Hmm, we could add a config to do the check on one side or the other
>> > depending on how the arch handles it.
>> >
>> > It needs to be well commented though.
>> 
>> Hmm.. maybe.  But it'd better if this function call order is fixed
>> IMHO.  Anyway, I'll add comments.
>
> Well, as you probably already saw, s390 changed to help us out :-) Is
> there other archs you know about. I haven't looked at all the others
> yet. s390 was the first one I saw that didn't follow suit.

As you can see that most other archs don't follow the ordering.

>
> Anyway, lets keep your double check for now. I'll look at making the
> two function calls from arch into one, where we can optimize this a bit
> more.

Okay.

>
[SNIP]

>> >> @@ -259,10 +272,14 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
>> >>  
>> >>  	/* trace it when it is-nested-in or is a function enabled. */
>> >>  	if ((!(trace->depth || ftrace_graph_addr(trace->func)) ||
>> >> -	     ftrace_graph_ignore_irqs()) ||
>> >> +	     ftrace_graph_ignore_irqs()) || (trace->depth < 0) ||
>> >>  	    (max_depth && trace->depth >= max_depth))
>> >>  		return 0;
>> >>  
>> >> +	/* need to reserve a ret_stack entry to recover the depth */
>> >> +	if (ftrace_graph_notrace_addr(trace->func))
>> >> +		return 1;
>> >> +
>> >
>> > Also, I understand what you are doing here, with making curr_ret_stack
>> > negative to denote we are in a state to not do tracing. But it's more
>> > of a hack (not a bad one), and really needs to be documented somewhere.
>> > That is, the design should be in the comments where it's used, and 5
>> > years from now, nobody will understand how the notrace works without
>> > spending days trying to figure it out. Let's be nice to that poor soul,
>> > and write up what is going on so they don't need to pray to the holy
>> > tuna hoping to get a fish of enlightenment on how turning
>> > curr_ret_stack negative magically makes the function graph tracing not
>> > trace down functions, and magically starts tracing again when it comes
>> > back up.
>> 
>> Fully agreed.  How about this:
>> 
>> /*
>>  * The curr_ret_stack is an index to ftrace return stack of current
>>  * task.  Its value should be in [0, FTRACE_RETFUNC_DEPTH) when the
>>  * function graph tracer is used.  To support filtering out specific
>>  * functions, it makes the index negative by subtracting huge value
>
>                                                 s/huge/the max/

Hmm.. I introduced FTRACE_NOTRACE_DEPTH (not FTRACE_RETFUNC_DEPTH) in
order to prevent possible off-by-one bug in any case.  Do you think just
using FTRACE_RETFUNC_DEPTH is enough?

>
>>  * (FTRACE_NOTRACE_DEPTH) so when it sees a negative index the ftrace
>>  * will ignore the record.  And the index gets recovered when returning
>>  * from the filtered function by adding the FTRACE_NOTRACE_DEPTH and
>>  * then it will continue to record functions normally.
>>  */
>
> Sounds good.

Thank you for the review!
Namhyung

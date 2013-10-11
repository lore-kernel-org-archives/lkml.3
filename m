Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab3JKITy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:19:54 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:48982 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3JKITt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:19:49 -0400
X-AuditID: 9c93017d-b7b96ae000006e96-9d-5257b4a35b3f
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
Date: Fri, 11 Oct 2013 17:19:46 +0900
In-Reply-To: <20131011001717.26b92150@gandalf.local.home> (Steven Rostedt's
	message of "Fri, 11 Oct 2013 00:17:17 -0400")
Message-ID: <87a9igcj8d.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Fri, 11 Oct 2013 00:17:17 -0400, Steven Rostedt wrote:
> Sorry for the very late reply, finally got some time to look at other
> peoples code.

Thank you for taking your time to review this carefully. :)

>
> On Tue,  3 Sep 2013 14:05:08 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
>
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> The set_graph_notrace filter is analogous to set_ftrace_notrace and
>> can be used for eliminating uninteresting part of function graph trace
>> output.  It also works with set_graph_function nicely.
>> 
>>   # cd /sys/kernel/debug/tracing/
>>   # echo do_page_fault > set_graph_function
>>   # perf ftrace live true
>>    2)               |  do_page_fault() {
>>    2)               |    __do_page_fault() {
>>    2)   0.381 us    |      down_read_trylock();
>>    2)   0.055 us    |      __might_sleep();
>>    2)   0.696 us    |      find_vma();
>>    2)               |      handle_mm_fault() {
>>    2)               |        handle_pte_fault() {
>>    2)               |          __do_fault() {
>>    2)               |            filemap_fault() {
>>    2)               |              find_get_page() {
>>    2)   0.033 us    |                __rcu_read_lock();
>>    2)   0.035 us    |                __rcu_read_unlock();
>>    2)   1.696 us    |              }
>>    2)   0.031 us    |              __might_sleep();
>>    2)   2.831 us    |            }
>>    2)               |            _raw_spin_lock() {
>>    2)   0.046 us    |              add_preempt_count();
>>    2)   0.841 us    |            }
>>    2)   0.033 us    |            page_add_file_rmap();
>>    2)               |            _raw_spin_unlock() {
>>    2)   0.057 us    |              sub_preempt_count();
>>    2)   0.568 us    |            }
>>    2)               |            unlock_page() {
>>    2)   0.084 us    |              page_waitqueue();
>>    2)   0.126 us    |              __wake_up_bit();
>>    2)   1.117 us    |            }
>>    2)   7.729 us    |          }
>>    2)   8.397 us    |        }
>>    2)   8.956 us    |      }
>>    2)   0.085 us    |      up_read();
>>    2) + 12.745 us   |    }
>>    2) + 13.401 us   |  }
>>   ...
>> 
>>   # echo handle_mm_fault > set_graph_notrace
>>   # perf ftrace live true
>>    1)               |  do_page_fault() {
>>    1)               |    __do_page_fault() {
>>    1)   0.205 us    |      down_read_trylock();
>>    1)   0.041 us    |      __might_sleep();
>>    1)   0.344 us    |      find_vma();
>>    1)   0.069 us    |      up_read();
>>    1)   4.692 us    |    }
>>    1)   5.311 us    |  }
>>   ...
>
> Concept looks good.

hehe, thanks.

[SNIP]
>
>> @@ -3910,8 +3971,6 @@ out:
>>  	if (fail)
>>  		return -EINVAL;
>>  
>> -	ftrace_graph_filter_enabled = !!(*idx);
>> -
>>  	return 0;
>>  }
>>  
>> @@ -3946,6 +4005,50 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
>>  
>>  	ret = read;
>>  
>> +	ftrace_graph_filter_enabled = ftrace_graph_count > 0;
>
> You modified the ftrace_graph_filter code without mentioning this in
> the change log. Actually, this should be a separate patch (clean up)
> and not just included with the ftrace_graph_notrace code, as it is a
> separate change.

Okay, I'll make it a separate patch.  And I think we can get rid of
ftrace_graph_{filter,notrace}_enabled altogether and just use _count
variable instead.

>
>> +
>> +out_free:
>> +	trace_parser_put(&parser);
>> +out_unlock:
>> +	mutex_unlock(&graph_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static ssize_t
>> +ftrace_graph_notrace_write(struct file *file, const char __user *ubuf,
>> +			   size_t cnt, loff_t *ppos)
>> +{
>> +	struct trace_parser parser;
>> +	ssize_t read, ret;
>> +
>> +	if (!cnt)
>> +		return 0;
>> +
>> +	mutex_lock(&graph_lock);
>> +
>> +	if (trace_parser_get_init(&parser, FTRACE_BUFF_MAX)) {
>> +		ret = -ENOMEM;
>> +		goto out_unlock;
>> +	}
>> +
>> +	read = trace_get_user(&parser, ubuf, cnt, ppos);
>> +
>> +	if (read >= 0 && trace_parser_loaded((&parser))) {
>> +		parser.buffer[parser.idx] = 0;
>> +
>> +		/* we allow only one expression at a time */
>> +		ret = ftrace_set_func(ftrace_graph_notrace_funcs,
>> +				      &ftrace_graph_notrace_count,
>> +				      parser.buffer);
>> +		if (ret)
>> +			goto out_free;
>> +	}
>> +
>> +	ret = read;
>> +
>> +	ftrace_graph_notrace_enabled = ftrace_graph_notrace_count > 0;
>> +
>
> ftrace_graph_notrace_write() and ftrace_graph_write() are basically
> identical. Please make a helper function that does the work and passes
> in the different variables. That is:
>
> static ssize_t
> ftrace_graph_notrace_write(struct file *file, const char __user *ubuf,
> 		size_t cnt, loff_t *ppos)
> {
> 	return __ftrace_graph_write(file, ubuf, cnt, ppos,
> 				ftrace_graph_notrace_funcs,
> 				&ftrace_graph_notrace_count)
> }
>
> and do the same with ftrace_graph_write(). This way if we find a bug,
> or update the code, it gets done to both and not just one.

Agreed, will do that.

[SNIP]
>
>> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
>> index b5c09242683d..3ba240daa5e0 100644
>> --- a/kernel/trace/trace_functions_graph.c
>> +++ b/kernel/trace/trace_functions_graph.c
>> @@ -114,16 +114,22 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth,
>>  		return -EBUSY;
>>  	}
>>  
>> +	/* The function was filtered out */
>> +	if (current->curr_ret_stack < -1)
>> +		return -EBUSY;
>
> I would be a bit more specific in your comment. Explain that
> curr_ret_stack is negative when we hit a function in the
> set_graph_notrace file.

How about this:

	/*
	 * curr_ret_stack is initialized to -1 and gets increased in
	 * this function.  So it can be less than -1 only if it was
	 * filtered out via ftrace_graph_notrace_addr() which can be
	 * set from set_graph_notrace file in debugfs by user.
	 */

>
>> +
>>  	calltime = trace_clock_local();
>>  
>>  	index = ++current->curr_ret_stack;
>> +	if (ftrace_graph_notrace_addr(func))
>> +		current->curr_ret_stack -= FTRACE_NOTRACE_DEPTH;
>
> I really hate this double call to ftrace_graph_notrace_addr(). The
> first one in trace_graph_entry(), and then here too.
>
> Isn't there a way we could pass the state? Hmm, I think we could use
> depth to do that. As depth is a pointer to trace.depth and not used
> before then. We could make it negative and then check that.
>
> /me looks at other archs.
>
> Darn it, s390 calls ftrace_push_return_trace() before
> ftrace_graph_entry(). They got fancy, as they must have noticed that
> trace.depth is set by ftrace_push_return_trace() and they just figured
> to let the ftrace_push_return_trace() do the work.

Yes, I thought about it before but as you can see other archs go to the
other way around so I just ended up to call it twice.

>
> Hmm, we could add a config to do the check on one side or the other
> depending on how the arch handles it.
>
> It needs to be well commented though.

Hmm.. maybe.  But it'd better if this function call order is fixed
IMHO.  Anyway, I'll add comments.

>
>
>
>>  	barrier();
>>  	current->ret_stack[index].ret = ret;
>>  	current->ret_stack[index].func = func;
>>  	current->ret_stack[index].calltime = calltime;
>>  	current->ret_stack[index].subtime = 0;
>>  	current->ret_stack[index].fp = frame_pointer;
>> -	*depth = index;
>> +	*depth = current->curr_ret_stack;
>>  
>>  	return 0;
>>  }
>> @@ -137,6 +143,9 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret,
>>  
>>  	index = current->curr_ret_stack;
>>  
>> +	if (index < 0)
>> +		index += FTRACE_NOTRACE_DEPTH;
>
> Speaking of comments. This needs to be commented, and not only that,
> perhaps this is where another ftrace_graph_notrace_addr() belongs.
>
> 	bool check = false;
>
> 	if (index < 0) {
> 		index += FTRACE_NOTRACE_DEPTH;
> 		check = true;
> 	}
>
> 	[...]
>
> 	if (check && !ftrace_graph_notrace_addr(trace->func))
> 		[ do the same bug as index < 0 ]
>
> 		
>
> Otherwise if the stack does get corrupted, this will just think we are
> in a notrace and fail someplace else, making it much harder to debug
> what went wrong.
>
> Hmm, this may be racy, as the user could change the notrace file and
> this could happen after that, causing a false positive.
>
> Well, we could do other tricks, like adding a flag in
> current->ret_stack[index].func (LSB set).
>
> But for now, just comment this better. We can come up with a proper
> check later. (/me is rambling as I've been on and off reviewing this
> patch all day, and it's now past my bedtime).

Sorry for interrupting your bedtime. :)

Hmm.. never thought about the corruption.  And yes, simply checking it
again here might cause a trouble, I guess.  I'll add a comment for this.

	/*
	 * A negative index here means that it's just returned from a
	 * notrace'd function.  Recover index to get an original return
	 * address.  See ftrace_push_return_trace().
	 *
	 * TODO: Need to check whether the stack gets corrupted.
	 */

>
>
>> +
>>  	if (unlikely(index < 0)) {
>>  		ftrace_graph_stop();
>>  		WARN_ON(1);
>> @@ -193,6 +202,10 @@ unsigned long ftrace_return_to_handler(unsigned long frame_pointer)
>>  	trace.rettime = trace_clock_local();
>>  	barrier();
>>  	current->curr_ret_stack--;
>> +	if (current->curr_ret_stack < -1) {
>> +		current->curr_ret_stack += FTRACE_NOTRACE_DEPTH;
>> +		return ret;
>> +	}
>>  
>>  	/*
>>  	 * The trace should run after decrementing the ret counter
>> @@ -259,10 +272,14 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
>>  
>>  	/* trace it when it is-nested-in or is a function enabled. */
>>  	if ((!(trace->depth || ftrace_graph_addr(trace->func)) ||
>> -	     ftrace_graph_ignore_irqs()) ||
>> +	     ftrace_graph_ignore_irqs()) || (trace->depth < 0) ||
>>  	    (max_depth && trace->depth >= max_depth))
>>  		return 0;
>>  
>> +	/* need to reserve a ret_stack entry to recover the depth */
>> +	if (ftrace_graph_notrace_addr(trace->func))
>> +		return 1;
>> +
>
> Also, I understand what you are doing here, with making curr_ret_stack
> negative to denote we are in a state to not do tracing. But it's more
> of a hack (not a bad one), and really needs to be documented somewhere.
> That is, the design should be in the comments where it's used, and 5
> years from now, nobody will understand how the notrace works without
> spending days trying to figure it out. Let's be nice to that poor soul,
> and write up what is going on so they don't need to pray to the holy
> tuna hoping to get a fish of enlightenment on how turning
> curr_ret_stack negative magically makes the function graph tracing not
> trace down functions, and magically starts tracing again when it comes
> back up.

Fully agreed.  How about this:

/*
 * The curr_ret_stack is an index to ftrace return stack of current
 * task.  Its value should be in [0, FTRACE_RETFUNC_DEPTH) when the
 * function graph tracer is used.  To support filtering out specific
 * functions, it makes the index negative by subtracting huge value
 * (FTRACE_NOTRACE_DEPTH) so when it sees a negative index the ftrace
 * will ignore the record.  And the index gets recovered when returning
 * from the filtered function by adding the FTRACE_NOTRACE_DEPTH and
 * then it will continue to record functions normally.
 */

Thanks,
Namhyung

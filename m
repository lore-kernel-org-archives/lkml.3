Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab3GCEAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 00:00:54 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:16454 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab3GCEAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 00:00:53 -0400
Message-ID: <51D3A1B7.3010200@huawei.com>
Date: Wed, 3 Jul 2013 11:59:51 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: <fweisbec@gmail.com>, <mingo@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 03/12] tracing: expose event tracing infrastructure
References: <1365564393-10972-1-git-send-email-jovi.zhangwei@huawei.com>  <1365564393-10972-4-git-send-email-jovi.zhangwei@huawei.com> <1372808114.22688.81.camel@gandalf.local.home>
In-Reply-To: <1372808114.22688.81.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/3 7:35, Steven Rostedt wrote:
> On Wed, 2013-04-10 at 11:26 +0800, zhangwei(Jovi) wrote:
>> From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
>>
>> Currently event tracing only can be use for ftrace and perf,
>> there don't have any mechanism to let modules(like external tracing tool)
>> register callback tracing function.
>>
>> Event tracing implement based on tracepoint, compare with raw tracepoint,
>> event tracing infrastructure provide built-in structured event annotate format,
>> this feature should expose to external user.
>>
>> For example, simple pseudo ktap script demonstrate how to use this event
>> tracing expose change.
> 
> Ah, it's for ktap.
> 
> Lets work on getting ktap into mainline first ;-)
> 
Sure.

I have to say this patch need to revise a little.

Original ktap is based on this patch, so ktap user handler will invoked when event is hit,
but from strict technical point of view, this is completely not needed, because it's perf
callback mechanism in there, which I didn't use it(should be blame). Currently ktap already
tuned to use unified perf interface, so it's pretty easy to support tracepoint/kprobe/uprobe/PMU/hw_breakpoint
in a unified manner without any kernel patch(Also I suggest Tom's event trigger patchset
can follow this way if possible).

But perhaps this patch still have value for tracing subsystem, with benefit on:
reduce kernel size by unify ftrace_raw_event_##call and perf_trace_##call

Remember the size reduced in my v2 patch?
Link:https://lkml.org/lkml/2013/3/13/143
kernel size will shrink ~52K with that change

Worth to continue to focus on kernel size shrinking?
please forget the part of "expose event tracing infrastructure".

>>
>> function event_trace(e)
>> {
>>         printf("%s", e.annotate);
>> }
>>
>> os.trace("sched:sched_switch", event_trace);
>> os.trace("irq:softirq_raise", event_trace);
>>
>> The running result:
>> sched_switch: prev_comm=rcu_sched prev_pid=10 prev_prio=120 prev_state=S ==> next_comm=swapper/1 next_pid=0 next_prio=120
>> softirq_raise: vec=1 [action=TIMER]
>> ...
>>
>> This expose change can be use by other tracing tool, like systemtap/lttng,
>> if they would implement this.
>>
>> This patch introduce struct event_trace_ops in trace_array, it have
>> two callback functions, pre_trace and do_trace.
>> when ftrace_raw_event_<call> function hit, it will call all
>> registered event_trace_ops.
>>
>> the benefit of this change is kernel size shrink ~18K
> 
> Now this is something that I would be more interested in having.
> 
>>
>> (the kernel size will reduce more when perf tracing code
>> converting to use this mechanism in future)
>>
>> text    data     bss     dec     hex filename
>> 7402131  804364 3149824 11356319         ad489f vmlinux.old
>> 7383115  804684 3149824 11337623         acff97 vmlinux.new
>>
>> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
>> ---
>>  include/linux/ftrace_event.h |   21 +++++++++++++
>>  include/linux/trace_array.h  |    1 +
>>  include/trace/ftrace.h       |   69 +++++++++++++-----------------------------
>>  kernel/trace/trace.c         |    4 ++-
>>  kernel/trace/trace.h         |    2 ++
>>  kernel/trace/trace_events.c  |   51 +++++++++++++++++++++++++++++++
>>  6 files changed, 99 insertions(+), 49 deletions(-)
>>
>> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
>> index 4e28b01..4b55272 100644
>> --- a/include/linux/ftrace_event.h
>> +++ b/include/linux/ftrace_event.h
>> @@ -6,6 +6,7 @@
>>  #include <linux/percpu.h>
>>  #include <linux/hardirq.h>
>>  #include <linux/perf_event.h>
>> +#include <linux/trace_array.h>
>>  
>>  struct trace_array;
>>  struct trace_buffer;
>> @@ -245,6 +246,26 @@ struct ftrace_event_call {
>>  #endif
>>  };
>>  
>> +
>> +/*
>> + * trace_descriptor_t is purpose for passing arguments between
>> + * pre_trace and do_trace function.
>> + */
>> +struct trace_descriptor_t {
>> +	struct ring_buffer_event *event;
>> +	struct ring_buffer *buffer;
>> +	unsigned long irq_flags;
>> +	int pc;
>> +};
>> +
>> +/* callback function for tracing */
>> +struct event_trace_ops {
>> +	void *(*pre_trace)(struct ftrace_event_file *file,
>> +			   int entry_size, void *data);
>> +	void (*do_trace)(struct ftrace_event_file *file, void *entry,
>> +			 int entry_size, void *data);
>> +};
>> +
>>  struct trace_array;
>>  struct ftrace_subsystem_dir;
>>  
>> diff --git a/include/linux/trace_array.h b/include/linux/trace_array.h
>> index c5b7a13..b362c5f 100644
>> --- a/include/linux/trace_array.h
>> +++ b/include/linux/trace_array.h
>> @@ -56,6 +56,7 @@ struct trace_array {
>>  	struct list_head	list;
>>  	char			*name;
>>  	struct trace_buffer	trace_buffer;
>> +	struct event_trace_ops	*ops;
>>  #ifdef CONFIG_TRACER_MAX_TRACE
>>  	/*
>>  	 * The max_buffer is used to snapshot the trace when a maximum
>> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
>> index 4bda044..743e754 100644
>> --- a/include/trace/ftrace.h
>> +++ b/include/trace/ftrace.h
>> @@ -401,41 +401,28 @@ static inline notrace int ftrace_get_offsets_##call(			\
>>   *
>>   * static struct ftrace_event_call event_<call>;
>>   *
>> - * static void ftrace_raw_event_<call>(void *__data, proto)
>> + * static notrace void ftrace_raw_event_##call(void *__data, proto)
>>   * {
>>   *	struct ftrace_event_file *ftrace_file = __data;
>> - *	struct ftrace_event_call *event_call = ftrace_file->event_call;
>> - *	struct ftrace_data_offsets_<call> __maybe_unused __data_offsets;
>> - *	struct ring_buffer_event *event;
>> - *	struct ftrace_raw_<call> *entry; <-- defined in stage 1
>> - *	struct ring_buffer *buffer;
>> - *	unsigned long irq_flags;
>> - *	int __data_size;
>> - *	int pc;
>> + *	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;
>> + *	struct trace_descriptor_t __desc;
>> + *	struct event_trace_ops *ops = ftrace_file->tr->ops;
>> + *	struct ftrace_raw_##call *entry; <-- defined in stage 1
>> + *	int __data_size, __entry_size;
>>   *
>> - *	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,
>> - *		     &ftrace_file->flags))
>> - *		return;
>> - *
>> - *	local_save_flags(irq_flags);
>> - *	pc = preempt_count();
>> - *
>> - *	__data_size = ftrace_get_offsets_<call>(&__data_offsets, args);
>> + *	__data_size = ftrace_get_offsets_##call(&__data_offsets, args);
>> + *	__entry_size = sizeof(*entry) + __data_size;
>>   *
>> - *	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
>> - *				  event_<call>->event.type,
>> - *				  sizeof(*entry) + __data_size,
>> - *				  irq_flags, pc);
>> - *	if (!event)
>> + *	entry = ops->pre_trace(ftrace_file, __entry_size, &__desc);
>> + *	if (!entry)
>>   *		return;
>> - *	entry	= ring_buffer_event_data(event);
>> + *
>> + *	tstruct
>>   *
>>   *	{ <assign>; }  <-- Here we assign the entries by the __field and
>>   *			   __array macros.
>>   *
>> - *	if (!filter_current_check_discard(buffer, event_call, entry, event))
>> - *		trace_nowake_buffer_unlock_commit(buffer,
>> - *						   event, irq_flags, pc);
>> + *	ops->do_trace(ftrace_file, entry, __entry_size, &__desc);
>>   * }
>>   *
>>   * static struct trace_event ftrace_event_type_<call> = {
>> @@ -513,38 +500,24 @@ static notrace void							\
>>  ftrace_raw_event_##call(void *__data, proto)				\
>>  {									\
>>  	struct ftrace_event_file *ftrace_file = __data;			\
>> -	struct ftrace_event_call *event_call = ftrace_file->event_call;	\
>>  	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
>> -	struct ring_buffer_event *event;				\
>> +	struct trace_descriptor_t __desc;				\
>> +	struct event_trace_ops *ops = ftrace_file->tr->ops;		\
>>  	struct ftrace_raw_##call *entry;				\
>> -	struct ring_buffer *buffer;					\
>> -	unsigned long irq_flags;					\
>> -	int __data_size;						\
>> -	int pc;								\
>> +	int __data_size, __entry_size;					\
>>  									\
>> -	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT,			\
>> -		     &ftrace_file->flags))				\
>> -		return;							\
>> -									\
>> -	local_save_flags(irq_flags);					\
>> -	pc = preempt_count();						\
>> +	__data_size = ftrace_get_offsets_##call(&__data_offsets, args);	\
>> +	__entry_size = sizeof(*entry) + __data_size;			\
>>  									\
>> -	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
>> -									\
>> -	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,	\
>> -				 event_call->event.type,		\
>> -				 sizeof(*entry) + __data_size,		\
>> -				 irq_flags, pc);			\
>> -	if (!event)							\
>> +	entry = ops->pre_trace(ftrace_file, __entry_size, &__desc);	\
>> +	if (!entry)							\
>>  		return;							\
>> -	entry	= ring_buffer_event_data(event);			\
>>  									\
>>  	tstruct								\
>>  									\
>>  	{ assign; }							\
>>  									\
>> -	if (!filter_current_check_discard(buffer, event_call, entry, event)) \
>> -		trace_buffer_unlock_commit(buffer, event, irq_flags, pc); \
>> +	ops->do_trace(ftrace_file, entry, __entry_size, &__desc);	\
>>  }
> 
> Hmm, this is a major change. Something that will definitely have to wait
> for 3.12.
> 
> -- Steve
> 
>>  /*
>>   * The ftrace_test_probe is compiled out, it is only here as a build time check
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index 829b2be..224b152 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -189,7 +189,7 @@ unsigned long long ns2usecs(cycle_t nsec)
>>   * pages for the buffer for that CPU. Each CPU has the same number
>>   * of pages allocated for its buffer.
>>   */
>> -static struct trace_array	global_trace;
>> +static struct trace_array	global_trace = {.ops = &ftrace_events_ops};
>>  
>>  LIST_HEAD(ftrace_trace_arrays);
>>  
>> @@ -5773,6 +5773,8 @@ static int new_instance_create(const char *name)
>>  
>>  	list_add(&tr->list, &ftrace_trace_arrays);
>>  
>> +	tr->ops = &ftrace_events_ops;
>> +
>>  	mutex_unlock(&trace_types_lock);
>>  
>>  	return 0;
>> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
>> index a8acfcd..0a1f4be 100644
>> --- a/kernel/trace/trace.h
>> +++ b/kernel/trace/trace.h
>> @@ -493,6 +493,8 @@ extern unsigned long nsecs_to_usecs(unsigned long nsecs);
>>  
>>  extern unsigned long tracing_thresh;
>>  
>> +extern struct event_trace_ops ftrace_events_ops;
>> +
>>  #ifdef CONFIG_TRACER_MAX_TRACE
>>  extern unsigned long tracing_max_latency;
>>  
>> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
>> index 53582e9..09ca479 100644
>> --- a/kernel/trace/trace_events.c
>> +++ b/kernel/trace/trace_events.c
>> @@ -241,6 +241,57 @@ void trace_event_enable_cmd_record(bool enable)
>>  	mutex_unlock(&event_mutex);
>>  }
>>  
>> +static void *ftrace_events_pre_trace(struct ftrace_event_file *file,
>> +				     int entry_size, void *data)
>> +{
>> +	struct ftrace_event_call *event_call = file->event_call;
>> +	struct trace_descriptor_t *desc = data;
>> +	struct ring_buffer_event *event;
>> +	struct ring_buffer *buffer;
>> +	unsigned long irq_flags;
>> +	int pc;
>> +
>> +	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags))
>> +		return NULL;
>> +
>> +	local_save_flags(irq_flags);
>> +	pc = preempt_count();
>> +
>> +	event = trace_event_buffer_lock_reserve(&buffer, file,
>> +						event_call->event.type,
>> +						entry_size, irq_flags, pc);
>> +
>> +	if (!event)
>> +		return NULL;
>> +
>> +	desc->event = event;
>> +	desc->buffer = buffer;
>> +	desc->irq_flags = irq_flags;
>> +	desc->pc = pc;
>> +
>> +	return ring_buffer_event_data(event);
>> +}
>> +
>> +static void ftrace_events_do_trace(struct ftrace_event_file *file, void *entry,
>> +				   int entry_size, void *data)
>> +{
>> +	struct ftrace_event_call *event_call = file->event_call;
>> +	struct trace_descriptor_t *desc = data;
>> +	struct ring_buffer_event *event = desc->event;
>> +	struct ring_buffer *buffer = desc->buffer;
>> +	unsigned long irq_flags = desc->irq_flags;
>> +	int pc = desc->pc;
>> +
>> +	if (!filter_current_check_discard(buffer, event_call, entry, event))
>> +		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
>> +}
>> +
>> +struct event_trace_ops ftrace_events_ops = {
>> +	.pre_trace = ftrace_events_pre_trace,
>> +	.do_trace  = ftrace_events_do_trace,
>> +};
>> +
>> +
>>  static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
>>  					 int enable, int soft_disable)
>>  {
> 
> 
> 
> .
> 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab3GJLiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:38:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:53116 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237Ab3GJLiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:38:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1035,1363158000"; 
   d="scan'208";a="266360162"
Message-ID: <51DD4787.7080504@intel.com>
Date: Wed, 10 Jul 2013 19:37:43 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [PATCH] perf: Update event buffer tail when overwriting old events
References: <1370498286-12801-1-git-send-email-zheng.z.yan@intel.com> <20130708121557.GA17211@twins.programming.kicks-ass.net>
In-Reply-To: <20130708121557.GA17211@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 08:15 PM, Peter Zijlstra wrote:
> On Thu, Jun 06, 2013 at 01:58:06PM +0800, Yan, Zheng wrote:
>> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>>
>> If perf event buffer is in overwrite mode, the kernel only updates
>> the data head when it overwrites old samples. The program that owns
>> the buffer need periodically check the buffer and update a variable
>> that tracks the date tail. If the program fails to do this in time,
>> the data tail can be overwritted by new samples. The program has to
>> rewind the buffer because it does not know where is the first vaild
>> sample.
>>
>> This patch makes the kernel update the date tail when it overwrites
>> old events. So the program that owns the event buffer can always
>> read the latest samples. This is convenient for programs that use
>> perf to do branch tracing. One use case is GDB branch tracing:
>> (http://sourceware.org/ml/gdb-patches/2012-06/msg00172.html)
>> It uses perf interface to read BTS, but only cares the branches
>> before the ptrace event.
>>
>> I added code to perf_output_{begin/end} to count how many cycles
>> are spent by sample output, then ran "perf record" to profile kernel
>> compilation 10 times on IvyBridge-EP. (perf record -a make -j 60)
>> The first number is scaled to 1000, the rest numbers are scaled by
>> the same factor.
>>
>>         before   overwrite mode      after   overwrite mode
>> AVG      1000        999             1046        1044
>> STDEV    19.4        19.5            17.1        17.9
> 
> OK, so I was sure I replied to this email; but apparently I didn't :/
> 
> So its still adding about 5% overhead to the regular case; this is sad.
> 
> What does something like the below do?
> 

I re-test the patch on a different 32 core sandybridge-ep machine. the result is quite good.

       origin   origin overwrite       modified    modified overwrite
AVG    1000      1044                   960        1006
STDEV  39.0      26.0                   28.1       14.4


Regards
Yan, Zheng

 

> ---
>  include/linux/perf_event.h  |  2 +
>  kernel/events/core.c        | 60 ++++++++++++++++++++++++------
>  kernel/events/internal.h    |  2 +
>  kernel/events/ring_buffer.c | 90 +++++++++++++++++++++++++++------------------
>  4 files changed, 106 insertions(+), 48 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 8873f82..bcce98a 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -753,6 +753,8 @@ static inline bool has_branch_stack(struct perf_event *event)
>  
>  extern int perf_output_begin(struct perf_output_handle *handle,
>  			     struct perf_event *event, unsigned int size);
> +extern int perf_output_begin_overwrite(struct perf_output_handle *handle,
> +			     struct perf_event *event, unsigned int size);
>  extern void perf_output_end(struct perf_output_handle *handle);
>  extern unsigned int perf_output_copy(struct perf_output_handle *handle,
>  			     const void *buf, unsigned int len);
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 1833bc5..4d674e9 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3878,6 +3878,8 @@ static const struct vm_operations_struct perf_mmap_vmops = {
>  	.page_mkwrite	= perf_mmap_fault,
>  };
>  
> +static void perf_event_set_overflow(struct perf_event *event, struct ring_buffer *rb);
> +
>  static int perf_mmap(struct file *file, struct vm_area_struct *vma)
>  {
>  	struct perf_event *event = file->private_data;
> @@ -3985,6 +3987,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
>  	vma->vm_mm->pinned_vm += extra;
>  
>  	ring_buffer_attach(event, rb);
> +	perf_event_set_overflow(event, rb);
>  	rcu_assign_pointer(event->rb, rb);
>  
>  	perf_event_update_userpage(event);
> @@ -4595,9 +4598,12 @@ void perf_prepare_sample(struct perf_event_header *header,
>  	}
>  }
>  
> -static void perf_event_output(struct perf_event *event,
> -				struct perf_sample_data *data,
> -				struct pt_regs *regs)
> +static __always_inline void 
> +__perf_event_output(struct perf_event *event,
> +		    struct perf_sample_data *data,
> +		    struct pt_regs *regs,
> +		    int (*output_begin)(struct perf_output_handle *, 
> +			                struct perf_event *, unsigned int))
>  {
>  	struct perf_output_handle handle;
>  	struct perf_event_header header;
> @@ -4607,7 +4613,7 @@ static void perf_event_output(struct perf_event *event,
>  
>  	perf_prepare_sample(&header, data, event, regs);
>  
> -	if (perf_output_begin(&handle, event, header.size))
> +	if (output_begin(&handle, event, header.size))
>  		goto exit;
>  
>  	perf_output_sample(&handle, &header, data, event);
> @@ -4618,6 +4624,33 @@ static void perf_event_output(struct perf_event *event,
>  	rcu_read_unlock();
>  }
>  
> +static void perf_event_output(struct perf_event *event,
> +				struct perf_sample_data *data,
> +				struct pt_regs *regs)
> +{
> +	__perf_event_output(event, data, regs, perf_output_begin);
> +}
> +
> +static void perf_event_output_overwrite(struct perf_event *event,
> +				struct perf_sample_data *data,
> +				struct pt_regs *regs)
> +{
> +	__perf_event_output(event, data, regs, perf_output_begin_overwrite);
> +}
> +
> +static void 
> +perf_event_set_overflow(struct perf_event *event, struct ring_buffer *rb)
> +{
> +	if (event->overflow_handler != perf_event_output ||
> +	    event->overflow_handler != perf_event_output_overwrite)
> +		return;
> +
> +	if (rb->overwrite)
> +		event->overflow_handler = perf_event_output_overwrite;
> +	else
> +		event->overflow_handler = perf_event_output;
> +}
> +
>  /*
>   * read event_id
>   */
> @@ -5183,10 +5216,7 @@ static int __perf_event_overflow(struct perf_event *event,
>  		irq_work_queue(&event->pending);
>  	}
>  
> -	if (event->overflow_handler)
> -		event->overflow_handler(event, data, regs);
> -	else
> -		perf_event_output(event, data, regs);
> +	event->overflow_handler(event, data, regs);
>  
>  	if (event->fasync && event->pending_kill) {
>  		event->pending_wakeup = 1;
> @@ -6501,8 +6531,13 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
>  		context = parent_event->overflow_handler_context;
>  	}
>  
> -	event->overflow_handler	= overflow_handler;
> -	event->overflow_handler_context = context;
> +	if (overflow_handler) {
> +		event->overflow_handler	= overflow_handler;
> +		event->overflow_handler_context = context;
> +	} else {
> +		event->overflow_handler = perf_event_output;
> +		event->overflow_handler_context = NULL;
> +	}
>  
>  	perf_event__state_init(event);
>  
> @@ -6736,9 +6771,10 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
>  	if (old_rb)
>  		ring_buffer_detach(event, old_rb);
>  
> -	if (rb)
> +	if (rb) {
>  		ring_buffer_attach(event, rb);
> -
> +		perf_event_set_overflow(event, rb);
> +	}
>  	rcu_assign_pointer(event->rb, rb);
>  
>  	if (old_rb) {
> diff --git a/kernel/events/internal.h b/kernel/events/internal.h
> index ca65997..c4e4610 100644
> --- a/kernel/events/internal.h
> +++ b/kernel/events/internal.h
> @@ -20,6 +20,8 @@ struct ring_buffer {
>  
>  	atomic_t			poll;		/* POLL_ for wakeups */
>  
> +	local_t				tail;		/* read position     */
> +	local_t				next_tail;	/* next read position */
>  	local_t				head;		/* write position    */
>  	local_t				nest;		/* nested writers    */
>  	local_t				events;		/* event limit       */
> diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
> index cd55144..5887044 100644
> --- a/kernel/events/ring_buffer.c
> +++ b/kernel/events/ring_buffer.c
> @@ -15,28 +15,9 @@
>  
>  #include "internal.h"
>  
> -static bool perf_output_space(struct ring_buffer *rb, unsigned long tail,
> -			      unsigned long offset, unsigned long head)
> +static bool perf_output_space(unsigned long tail, unsigned long offset,
> +			      unsigned long head, unsigned long mask)
>  {
> -	unsigned long sz = perf_data_size(rb);
> -	unsigned long mask = sz - 1;
> -
> -	/*
> -	 * check if user-writable
> -	 * overwrite : over-write its own tail
> -	 * !overwrite: buffer possibly drops events.
> -	 */
> -	if (rb->overwrite)
> -		return true;
> -
> -	/*
> -	 * verify that payload is not bigger than buffer
> -	 * otherwise masking logic may fail to detect
> -	 * the "not enough space" condition
> -	 */
> -	if ((head - offset) > sz)
> -		return false;
> -
>  	offset = (offset - tail) & mask;
>  	head   = (head   - tail) & mask;
>  
> @@ -109,11 +90,11 @@ static void perf_output_put_handle(struct perf_output_handle *handle)
>  	preempt_enable();
>  }
>  
> -int perf_output_begin(struct perf_output_handle *handle,
> -		      struct perf_event *event, unsigned int size)
> +static __always_inline int __perf_output_begin(struct perf_output_handle *handle,
> +		      struct perf_event *event, unsigned int size, bool overwrite)
>  {
>  	struct ring_buffer *rb;
> -	unsigned long tail, offset, head;
> +	unsigned long tail, offset, head, max_size;
>  	int have_lost;
>  	struct perf_sample_data sample_data;
>  	struct {
> @@ -136,7 +117,8 @@ int perf_output_begin(struct perf_output_handle *handle,
>  	handle->rb	= rb;
>  	handle->event	= event;
>  
> -	if (!rb->nr_pages)
> +	max_size = perf_data_size(rb);
> +	if (size > max_size)
>  		goto out;
>  
>  	have_lost = local_read(&rb->lost);
> @@ -149,19 +131,43 @@ int perf_output_begin(struct perf_output_handle *handle,
>  
>  	perf_output_get_handle(handle);
>  
> -	do {
> +	if (overwrite) {
> +		do {
> +			tail = local_read(&rb->tail);
> +			offset = local_read(&rb->head);
> +			head = offset + size;
> +			if (unlikely(!perf_output_space(tail, offset, head,
> +						        max_size - 1))) {
> +				tail = local_read(&rb->next_tail);
> +				local_set(&rb->tail, tail);
> +				rb->user_page->data_tail = tail;
> +			}
> +		} while (local_cmpxchg(&rb->head, offset, head) != offset);
> +
>  		/*
> -		 * Userspace could choose to issue a mb() before updating the
> -		 * tail pointer. So that all reads will be completed before the
> -		 * write is issued.
> +		 * Save the start of next event when half of the buffer
> +		 * has been filled. Later when the event buffer overflows,
> +		 * update the tail pointer to point to it.
>  		 */
> -		tail = ACCESS_ONCE(rb->user_page->data_tail);
> -		smp_rmb();
> -		offset = head = local_read(&rb->head);
> -		head += size;
> -		if (unlikely(!perf_output_space(rb, tail, offset, head)))
> -			goto fail;
> -	} while (local_cmpxchg(&rb->head, offset, head) != offset);
> +		if (tail == local_read(&rb->next_tail) &&
> +		    head - tail >= (max_size >> 1))
> +			local_cmpxchg(&rb->next_tail, tail, head);
> +	} else {
> +		do {
> +			/*
> +			 * Userspace could choose to issue a mb() before
> +			 * updating the tail pointer. So that all reads will
> +			 * be completed before the write is issued.
> +			 */
> +			tail = ACCESS_ONCE(rb->user_page->data_tail);
> +			smp_rmb();
> +			offset = local_read(&rb->head);
> +			head = offset + size;
> +			if (unlikely(!perf_output_space(tail, offset, head,
> +							max_size - 1)))
> +				goto fail;
> +		} while (local_cmpxchg(&rb->head, offset, head) != offset);
> +	}
>  
>  	if (head - local_read(&rb->wakeup) > rb->watermark)
>  		local_add(rb->watermark, &rb->wakeup);
> @@ -194,6 +200,18 @@ int perf_output_begin(struct perf_output_handle *handle,
>  	return -ENOSPC;
>  }
>  
> +int perf_output_begin(struct perf_output_handle *handle,
> +		      struct perf_event *event, unsigned int size)
> +{
> +	return __perf_output_begin(handle, event, size, false);
> +}
> +
> +int perf_output_begin_overwrite(struct perf_output_handle *handle,
> +		      struct perf_event *event, unsigned int size)
> +{
> +	return __perf_output_begin(handle, event, size, true);
> +}
> +
>  unsigned int perf_output_copy(struct perf_output_handle *handle,
>  		      const void *buf, unsigned int len)
>  {
> 


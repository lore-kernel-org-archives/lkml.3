Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab3GYGPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 02:15:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:25594 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019Ab3GYGP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 02:15:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,741,1367996400"; 
   d="scan'208";a="351259143"
Message-ID: <51F0C41C.8080005@intel.com>
Date: Thu, 25 Jul 2013 09:22:20 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Vince Weaver <vince@deater.net>
CC: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Update perf_event_type documentation
References: <20130716150907.GL23818@dyad.programming.kicks-ass.net> <tip-a5cdd40c9877e9aba704c020fd65d26b5cfecf18@git.kernel.org> <alpine.DEB.2.02.1307241348250.7828@pianoman.cluster.toy>
In-Reply-To: <alpine.DEB.2.02.1307241348250.7828@pianoman.cluster.toy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/07/13 20:54, Vince Weaver wrote:
> On Tue, 23 Jul 2013, tip-bot for Peter Zijlstra wrote:
> 
>> Commit-ID:  a5cdd40c9877e9aba704c020fd65d26b5cfecf18
>> Gitweb:     http://git.kernel.org/tip/a5cdd40c9877e9aba704c020fd65d26b5cfecf18
>> Author:     Peter Zijlstra <peterz@infradead.org>
>> AuthorDate: Tue, 16 Jul 2013 17:09:07 +0200
>> Committer:  Ingo Molnar <mingo@kernel.org>
>> CommitDate: Tue, 23 Jul 2013 12:17:08 +0200
>>
>> perf: Update perf_event_type documentation
>>
>> Due to a discussion with Adrian I had a good look at the perf_event_type record
>> layout and found the documentation to be somewhat unclear.
> 
> This code makes a lot of code changes considering it is "updating 
> documentation".
> 
> Also, will code following this "documentation" be backward compatible?
> 
> Meaning, if you have code that depends on the new fields you've added
> and run on older kernels, will you get sane results?  Or will the code
> get garbage and/or segfault in the sample_id fields because you read
> past the end of valid data?

This is not the patch that adds new sample format bits.

New sample format bits are always backward compatible in the sense that the
kernel perf_event_open system call will return an error if you try to use
sample format bits that it does not know about.

Applications will not spontaneously start using sample format bits they have
not been programmed for.  If an application is enhanced to use a new sample
format bit then it must be ready to cope with errors on older kernels.  With
respect to the sample format bit I tried to propose
(PERF_SAMPLE_IDENTIFIER), I modified perf tools to check if the kernel
supported it.  Other applications that want to use PERF_SAMPLE_IDENTIFIER
should take the same approach.

New sample format bits are added from time to time such as
PERF_SAMPLE_WEIGHT and PERF_SAMPLE_DATA_SRC which were added in 3.10.


> 
>  
>> Cc: Adrian Hunter <adrian.hunter@intel.com>
>> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>> Link: http://lkml.kernel.org/r/20130716150907.GL23818@dyad.programming.kicks-ass.net
>> Signed-off-by: Ingo Molnar <mingo@kernel.org>
>> ---
>>  include/uapi/linux/perf_event.h | 18 +++++++++++++++++-
>>  kernel/events/core.c            | 31 ++++++++++++++++---------------
>>  2 files changed, 33 insertions(+), 16 deletions(-)
>>
>> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
>> index 0b1df41..00d8274 100644
>> --- a/include/uapi/linux/perf_event.h
>> +++ b/include/uapi/linux/perf_event.h
>> @@ -478,6 +478,16 @@ enum perf_event_type {
>>  	 * file will be supported by older perf tools, with these new optional
>>  	 * fields being ignored.
>>  	 *
>> +	 * struct sample_id {
>> +	 * 	{ u32			pid, tid; } && PERF_SAMPLE_TID
>> +	 * 	{ u64			time;     } && PERF_SAMPLE_TIME
>> +	 * 	{ u64			id;       } && PERF_SAMPLE_ID
>> +	 * 	{ u64			stream_id;} && PERF_SAMPLE_STREAM_ID
>> +	 * 	{ u32			cpu, res; } && PERF_SAMPLE_CPU
>> +	 * } && perf_event_attr::sample_id_all
>> +	 */
>> +
>> +	/*
>>  	 * The MMAP events record the PROT_EXEC mappings so that we can
>>  	 * correlate userspace IPs to code. They have the following structure:
>>  	 *
>> @@ -498,6 +508,7 @@ enum perf_event_type {
>>  	 *	struct perf_event_header	header;
>>  	 *	u64				id;
>>  	 *	u64				lost;
>> +	 * 	struct sample_id		sample_id;
>>  	 * };
>>  	 */
>>  	PERF_RECORD_LOST			= 2,
>> @@ -508,6 +519,7 @@ enum perf_event_type {
>>  	 *
>>  	 *	u32				pid, tid;
>>  	 *	char				comm[];
>> +	 * 	struct sample_id		sample_id;
>>  	 * };
>>  	 */
>>  	PERF_RECORD_COMM			= 3,
>> @@ -518,6 +530,7 @@ enum perf_event_type {
>>  	 *	u32				pid, ppid;
>>  	 *	u32				tid, ptid;
>>  	 *	u64				time;
>> +	 * 	struct sample_id		sample_id;
>>  	 * };
>>  	 */
>>  	PERF_RECORD_EXIT			= 4,
>> @@ -528,6 +541,7 @@ enum perf_event_type {
>>  	 *	u64				time;
>>  	 *	u64				id;
>>  	 *	u64				stream_id;
>> +	 * 	struct sample_id		sample_id;
>>  	 * };
>>  	 */
>>  	PERF_RECORD_THROTTLE			= 5,
>> @@ -539,6 +553,7 @@ enum perf_event_type {
>>  	 *	u32				pid, ppid;
>>  	 *	u32				tid, ptid;
>>  	 *	u64				time;
>> +	 * 	struct sample_id		sample_id;
>>  	 * };
>>  	 */
>>  	PERF_RECORD_FORK			= 7,
>> @@ -549,6 +564,7 @@ enum perf_event_type {
>>  	 *	u32				pid, tid;
>>  	 *
>>  	 *	struct read_format		values;
>> +	 * 	struct sample_id		sample_id;
>>  	 * };
>>  	 */
>>  	PERF_RECORD_READ			= 8,
>> @@ -596,7 +612,7 @@ enum perf_event_type {
>>  	 * 	  u64			dyn_size; } && PERF_SAMPLE_STACK_USER
>>  	 *
>>  	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
>> -	 *	{ u64			data_src;     } && PERF_SAMPLE_DATA_SRC
>> +	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
>>  	 * };
>>  	 */
>>  	PERF_RECORD_SAMPLE			= 9,
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 5e2bce9..1274114 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -4462,20 +4462,6 @@ void perf_output_sample(struct perf_output_handle *handle,
>>  		}
>>  	}
>>  
>> -	if (!event->attr.watermark) {
>> -		int wakeup_events = event->attr.wakeup_events;
>> -
>> -		if (wakeup_events) {
>> -			struct ring_buffer *rb = handle->rb;
>> -			int events = local_inc_return(&rb->events);
>> -
>> -			if (events >= wakeup_events) {
>> -				local_sub(wakeup_events, &rb->events);
>> -				local_inc(&rb->wakeup);
>> -			}
>> -		}
>> -	}
>> -
>>  	if (sample_type & PERF_SAMPLE_BRANCH_STACK) {
>>  		if (data->br_stack) {
>>  			size_t size;
>> @@ -4511,16 +4497,31 @@ void perf_output_sample(struct perf_output_handle *handle,
>>  		}
>>  	}
>>  
>> -	if (sample_type & PERF_SAMPLE_STACK_USER)
>> +	if (sample_type & PERF_SAMPLE_STACK_USER) {
>>  		perf_output_sample_ustack(handle,
>>  					  data->stack_user_size,
>>  					  data->regs_user.regs);
>> +	}
>>  
>>  	if (sample_type & PERF_SAMPLE_WEIGHT)
>>  		perf_output_put(handle, data->weight);
>>  
>>  	if (sample_type & PERF_SAMPLE_DATA_SRC)
>>  		perf_output_put(handle, data->data_src.val);
>> +
>> +	if (!event->attr.watermark) {
>> +		int wakeup_events = event->attr.wakeup_events;
>> +
>> +		if (wakeup_events) {
>> +			struct ring_buffer *rb = handle->rb;
>> +			int events = local_inc_return(&rb->events);
>> +
>> +			if (events >= wakeup_events) {
>> +				local_sub(wakeup_events, &rb->events);
>> +				local_inc(&rb->wakeup);
>> +			}
>> +		}
>> +	}
>>  }
>>  
>>  void perf_prepare_sample(struct perf_event_header *header,
> 
> 


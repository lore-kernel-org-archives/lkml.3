Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbaE1IE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:04:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:28506 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbaE1IEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:04:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,926,1392192000"; 
   d="scan'208";a="518898916"
Message-ID: <53859833.6050905@intel.com>
Date: Wed, 28 May 2014 11:02:59 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ye olde task_ctx_sched_out trace.
References: <20140521150613.GA28702@redhat.com> <20140521151655.GG2485@laptop.programming.kicks-ass.net> <20140521153013.GG5226@laptop.programming.kicks-ass.net> <20140521153219.GH5226@laptop.programming.kicks-ass.net> <537D9EBE.7030806@intel.com> <20140522072222.GR30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140522072222.GR30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 10:22 AM, Peter Zijlstra wrote:
> On Thu, May 22, 2014 at 09:52:46AM +0300, Adrian Hunter wrote:
>> +/*
>> + * PERF_RECORD_MISC_MMAP_DATA and PERF_RECORD_MISC_COMM_EXEC are used on
>> + * different events so can reuse the same bit position.
>> + */
>>  #define PERF_RECORD_MISC_MMAP_DATA		(1 << 13)
>> +#define PERF_RECORD_MISC_COMM_EXEC		(1 << 13)
>>  /*
>>   * Indicates that the content of PERF_SAMPLE_IP points to
>>   * the actual instruction that triggered the event. See also
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index ed50b09..760abd0 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -5067,7 +5067,7 @@ static void perf_event_comm_event(struct perf_comm_event *comm_event)
>>  		       NULL);
>>  }
>>  
>> -void perf_event_comm(struct task_struct *task)
>> +void perf_event_comm(struct task_struct *task, bool exec)
>>  {
>>  	struct perf_comm_event comm_event;
>>  	struct perf_event_context *ctx;
>> @@ -5093,7 +5093,7 @@ void perf_event_comm(struct task_struct *task)
>>  		.event_id  = {
>>  			.header = {
>>  				.type = PERF_RECORD_COMM,
>> -				.misc = 0,
>> +				.misc = exec ? PERF_RECORD_MISC_COMM_EXEC : 0,
>>  				/* .size */
>>  			},
>>  			/* .pid */
> 
> OK, now that you pointed out the obvious, yeah, I suppose we can do that :-)
> 

One problem is how user space can figure out if the kernel supports it.
For my purposes, I don't need to know in advance, but I can imagine some
users might want to.  So I suggest adding:

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index e3fc8f0..67cec3e 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -301,8 +301,9 @@ struct perf_event_attr {
                                exclude_callchain_kernel : 1, /* exclude kernel callchains */
                                exclude_callchain_user   : 1, /* exclude user callchains */
                                mmap2          :  1, /* include mmap with inode data     */
+                               exec           :  1, /* flag comm events that are due to an exec */
 
-                               __reserved_1   : 40;
+                               __reserved_1   : 39;
 
        union {
                __u32           wakeup_events;    /* wakeup every n events */


Commit message:

perf tools like 'perf report' can aggregate samples by comm
strings, which generally works.  However, there are other
potential use-cases.  For example, to pair up 'calls'
with 'returns' accurately (from branch events like Intel BTS)
it is necessary to identify whether the process has exec'd.
Although a comm event is generated when an 'exec' happens
it is also generated whenever the comm string is changed
on a whim (e.g. by prctl PR_SET_NAME).  This patch adds a
flag to the comm event to differentiate one case from the
other.

In order to determine whether the kernel supports the new
flag, a selection bit named 'exec' is added to struct
perf_event_attr.  The bit does nothing but will cause
perf_event_open() to fail if the bit is set on kernels
that do not have it defined.






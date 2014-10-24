Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbaJXItP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:49:15 -0400
Received: from mga03.intel.com ([134.134.136.65]:64027 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbaJXItI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:49:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,779,1406617200"; 
   d="scan'208";a="624526334"
Message-ID: <544A1229.2000704@intel.com>
Date: Fri, 24 Oct 2014 11:47:37 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 04/16] perf tools: Add a thread stack for synthesizing
 call chains
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com> <1414061124-26830-5-git-send-email-adrian.hunter@intel.com> <20141023205127.GM14687@kernel.org>
In-Reply-To: <20141023205127.GM14687@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/10/14 23:51, Arnaldo Carvalho de Melo wrote:
> Em Thu, Oct 23, 2014 at 01:45:12PM +0300, Adrian Hunter escreveu:
>> Add a thread stack for synthesizing call chains from call
>> and return events.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/Makefile.perf       |   2 +
>>  tools/perf/util/event.h        |  26 +++++++
>>  tools/perf/util/thread-stack.c | 151 +++++++++++++++++++++++++++++++++++++++++
>>  tools/perf/util/thread-stack.h |  32 +++++++++
>>  tools/perf/util/thread.c       |   3 +
>>  tools/perf/util/thread.h       |   3 +
>>  6 files changed, 217 insertions(+)
>>  create mode 100644 tools/perf/util/thread-stack.c
>>  create mode 100644 tools/perf/util/thread-stack.h
>>
>> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
>> index 262916f..5bbe1ff 100644
>> --- a/tools/perf/Makefile.perf
>> +++ b/tools/perf/Makefile.perf
>> @@ -304,6 +304,7 @@ LIB_H += ui/util.h
>>  LIB_H += ui/ui.h
>>  LIB_H += util/data.h
>>  LIB_H += util/kvm-stat.h
>> +LIB_H += util/thread-stack.h
>>  
>>  LIB_OBJS += $(OUTPUT)util/abspath.o
>>  LIB_OBJS += $(OUTPUT)util/alias.o
>> @@ -380,6 +381,7 @@ LIB_OBJS += $(OUTPUT)util/srcline.o
>>  LIB_OBJS += $(OUTPUT)util/data.o
>>  LIB_OBJS += $(OUTPUT)util/tsc.o
>>  LIB_OBJS += $(OUTPUT)util/cloexec.o
>> +LIB_OBJS += $(OUTPUT)util/thread-stack.o
>>  
>>  LIB_OBJS += $(OUTPUT)ui/setup.o
>>  LIB_OBJS += $(OUTPUT)ui/helpline.o
>> diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
>> index c89518e..e84f929 100644
>> --- a/tools/perf/util/event.h
>> +++ b/tools/perf/util/event.h
>> @@ -143,6 +143,32 @@ struct branch_stack {
>>  	struct branch_entry	entries[0];
>>  };
>>  
>> +enum {
>> +	PERF_FLAG_BRANCH		= 1ULL << 0,
>> +	PERF_FLAG_CALL			= 1ULL << 1,
>> +	PERF_FLAG_RETURN		= 1ULL << 2,
>> +	PERF_FLAG_CONDITIONAL		= 1ULL << 3,
>> +	PERF_FLAG_SYSCALLRET		= 1ULL << 4,
>> +	PERF_FLAG_ASYNC			= 1ULL << 5,
>> +	PERF_FLAG_INTERRUPT		= 1ULL << 6,
>> +	PERF_FLAG_TX_ABORT		= 1ULL << 7,
>> +	PERF_FLAG_TRACE_BEGIN		= 1ULL << 8,
>> +	PERF_FLAG_TRACE_END		= 1ULL << 9,
>> +	PERF_FLAG_IN_TX			= 1ULL << 10,
>> +};
>> +
>> +#define PERF_BRANCH_MASK	(\
>> +	PERF_FLAG_BRANCH	|\
>> +	PERF_FLAG_CALL		|\
>> +	PERF_FLAG_RETURN	|\
>> +	PERF_FLAG_CONDITIONAL	|\
>> +	PERF_FLAG_SYSCALLRET	|\
>> +	PERF_FLAG_ASYNC		|\
>> +	PERF_FLAG_INTERRUPT	|\
>> +	PERF_FLAG_TX_ABORT	|\
>> +	PERF_FLAG_TRACE_BEGIN	|\
>> +	PERF_FLAG_TRACE_END)
>> +
>>  struct perf_sample {
>>  	u64 ip;
>>  	u32 pid, tid;
>> diff --git a/tools/perf/util/thread-stack.c b/tools/perf/util/thread-stack.c
>> new file mode 100644
>> index 0000000..c1ca2a9
>> --- /dev/null
>> +++ b/tools/perf/util/thread-stack.c
>> @@ -0,0 +1,151 @@
>> +/*
>> + * thread-stack.c: Synthesize a thread's stack using call / return events
>> + * Copyright (c) 2014, Intel Corporation.
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms and conditions of the GNU General Public License,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + *
>> + */
>> +
>> +#include "thread.h"
>> +#include "event.h"
>> +#include "util.h"
>> +#include "thread-stack.h"
>> +
>> +#define STACK_GROWTH 4096
>> +
>> +struct thread_stack_entry {
>> +	u64 ret_addr;
>> +};
>> +
>> +struct thread_stack {
>> +	struct thread_stack_entry *stack;
>> +	size_t cnt;
>> +	size_t sz;
>> +	u64 trace_nr;
>> +};
>> +
>> +static void thread_stack__grow(struct thread_stack *ts)
>> +{
>> +	struct thread_stack_entry *new_stack;
>> +	size_t sz, new_sz;
>> +
>> +	new_sz = ts->sz + STACK_GROWTH;
>> +	sz = new_sz * sizeof(struct thread_stack_entry);
>> +	new_stack = realloc(ts->stack, sz);
>> +	if (new_stack) {
>> +		ts->stack = new_stack;
>> +		ts->sz = new_sz;
>> +	}
>> +}
>> +
>> +static struct thread_stack *thread_stack__new(void)
>> +{
>> +	struct thread_stack *ts;
>> +
>> +	ts = zalloc(sizeof(struct thread_stack));
>> +	if (!ts)
>> +		return NULL;
>> +
>> +	thread_stack__grow(ts);
>> +	if (!ts->stack) {
>> +		free(ts);
>> +		return NULL;
>> +	}
>> +
>> +	return ts;
>> +}
>> +
>> +static void thread_stack__push(struct thread_stack *ts, u64 ret_addr)
>> +{
>> +	if (ts->cnt == ts->sz) {
>> +		thread_stack__grow(ts);
>> +		if (ts->cnt == ts->sz)
>> +			ts->cnt = 0;
>> +	}
>> +
>> +	ts->stack[ts->cnt++].ret_addr = ret_addr;
>> +}
> 
> So can you elaborate on the use case, i.e. this silently trows the
> existing stack contents away if it doesn't grow, looks strange :-\
> 
> Merits some explanation about why this is OK, to say the least.

I considered the call stack to be augmenting the information so not worth
failing the whole session over.  Equally memory allocation failure is likely
to be fatal anyway due to oom-killers or other allocations failing.

But it could certainly print a warning, so I will add that.

> 
>> +
>> +static void thread_stack__pop(struct thread_stack *ts, u64 ret_addr)
>> +{
>> +	if (!ts->cnt)
>> +		return;
>> +
>> +	if (ts->stack[ts->cnt - 1].ret_addr == ret_addr) {
>> +		ts->cnt -= 1;
>> +	} else {
>> +		size_t i = ts->cnt - 1;
>> +
>> +		while (i--) {
>> +			if (ts->stack[i].ret_addr == ret_addr) {
>> +				ts->cnt = i;
>> +				return;
>> +			}
>> +		}
>> +	}
>> +}
>> +
>> +void thread_stack__event(struct thread *thread, u32 flags, u64 from_ip,
>> +			 u64 to_ip, u16 insn_len, u64 trace_nr)
>> +{
>> +	if (!thread)
>> +		return;
>> +
>> +	if (!thread->ts) {
>> +		thread->ts = thread_stack__new();
>> +		if (!thread->ts)
>> +			return;
>> +		thread->ts->trace_nr = trace_nr;
>> +	}
>> +
>> +	if (trace_nr != thread->ts->trace_nr) {
>> +		thread->ts->trace_nr = trace_nr;
>> +		thread->ts->cnt = 0;
>> +	}
>> +
>> +	if (flags & PERF_FLAG_CALL) {
>> +		u64 ret_addr;
>> +
>> +		if (!to_ip)
>> +			return;
>> +		ret_addr = from_ip + insn_len;
>> +		if (ret_addr == to_ip)
>> +			return; /* Zero-length calls are excluded */
>> +		thread_stack__push(thread->ts, ret_addr);
>> +	} else if (flags & PERF_FLAG_RETURN) {
>> +		if (!from_ip)
>> +			return;
>> +		thread_stack__pop(thread->ts, to_ip);
>> +	}
>> +}
>> +
>> +void thread_stack__free(struct thread *thread)
>> +{
>> +	if (thread->ts) {
>> +		zfree(&thread->ts->stack);
>> +		zfree(&thread->ts);
>> +	}
>> +}
>> +
>> +void thread_stack__sample(struct thread *thread, struct ip_callchain *chain,
>> +			  size_t sz, u64 ip)
>> +{
>> +	size_t i;
>> +
>> +	if (!thread || !thread->ts)
>> +		chain->nr = 1;
>> +	else
>> +		chain->nr = min(sz, thread->ts->cnt + 1);
>> +
>> +	chain->ips[0] = ip;
>> +
>> +	for (i = 1; i < chain->nr; i++)
>> +		chain->ips[i] = thread->ts->stack[thread->ts->cnt - i].ret_addr;
>> +}
>> diff --git a/tools/perf/util/thread-stack.h b/tools/perf/util/thread-stack.h
>> new file mode 100644
>> index 0000000..c0ba4cf
>> --- /dev/null
>> +++ b/tools/perf/util/thread-stack.h
>> @@ -0,0 +1,32 @@
>> +/*
>> + * thread-stack.h: Synthesize a thread's stack using call / return events
>> + * Copyright (c) 2014, Intel Corporation.
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms and conditions of the GNU General Public License,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + *
>> + */
>> +
>> +#ifndef __PERF_THREAD_STACK_H
>> +#define __PERF_THREAD_STACK_H
>> +
>> +#include <sys/types.h>
>> +
>> +#include <linux/types.h>
>> +
>> +struct thread;
>> +struct ip_callchain;
>> +
>> +void thread_stack__event(struct thread *thread, u32 flags, u64 from_ip,
>> +			 u64 to_ip, u16 insn_len, u64 trace_nr);
>> +void thread_stack__sample(struct thread *thread, struct ip_callchain *chain,
>> +			  size_t sz, u64 ip);
>> +void thread_stack__free(struct thread *thread);
>> +
>> +#endif
>> diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
>> index 2b7b2d9..4e3418d 100644
>> --- a/tools/perf/util/thread.c
>> +++ b/tools/perf/util/thread.c
>> @@ -4,6 +4,7 @@
>>  #include <string.h>
>>  #include "session.h"
>>  #include "thread.h"
>> +#include "thread-stack.h"
>>  #include "util.h"
>>  #include "debug.h"
>>  #include "comm.h"
>> @@ -66,6 +67,8 @@ void thread__delete(struct thread *thread)
>>  {
>>  	struct comm *comm, *tmp;
>>  
>> +	thread_stack__free(thread);
>> +
>>  	if (thread->mg) {
>>  		map_groups__put(thread->mg);
>>  		thread->mg = NULL;
>> diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
>> index 8c75fa7..a057820 100644
>> --- a/tools/perf/util/thread.h
>> +++ b/tools/perf/util/thread.h
>> @@ -8,6 +8,8 @@
>>  #include "symbol.h"
>>  #include <strlist.h>
>>  
>> +struct thread_stack;
>> +
>>  struct thread {
>>  	union {
>>  		struct rb_node	 rb_node;
>> @@ -25,6 +27,7 @@ struct thread {
>>  	int			comm_len;
>>  
>>  	void			*priv;
>> +	struct thread_stack	*ts;
>>  };
>>  
>>  struct machine;
>> -- 
>> 1.9.1
> 
> 


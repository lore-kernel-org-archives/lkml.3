Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab3HGI2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 04:28:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:63167 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755776Ab3HGI2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:28:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,831,1367996400"; 
   d="scan'208";a="383127766"
Message-ID: <5202068F.4000501@intel.com>
Date: Wed, 07 Aug 2013 11:34:23 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V9 04/14] perf tools: change machine__findnew_thread()
 to set thread pid
References: <1375719994-26482-1-git-send-email-adrian.hunter@intel.com> <1375719994-26482-5-git-send-email-adrian.hunter@intel.com> <87y58ex7k5.fsf@sejong.aot.lge.com>
In-Reply-To: <87y58ex7k5.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/13 10:51, Namhyung Kim wrote:
> On Mon,  5 Aug 2013 19:26:24 +0300, Adrian Hunter wrote:
>> Add a new parameter for 'pid' to machine__findnew_thread().
>> Change callers to pass 'pid' when it is known.
>>
> [SNIP]
> 
>> @@ -198,7 +198,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
>>  
>>  	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
>>  
>> -	thread = machine__findnew_thread(machine, event->ip.pid);
>> +	thread = machine__findnew_thread(machine, event->ip.pid, event->ip.pid);
> 
> Maybe I'm missing something.  Why not use event->ip.tid here?

That is covered here:

	http://marc.info/?l=linux-kernel&m=137513636309689&w=2

> 
> 
>>  	if (thread == NULL) {
>>  		pr_err("problem processing %d event, skipping it.\n",
>>  		       event->header.type);
>> diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
>> index b49f5c5..c324778 100644
>> --- a/tools/perf/builtin-kmem.c
>> +++ b/tools/perf/builtin-kmem.c
>> @@ -305,7 +305,8 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
>>  				struct perf_evsel *evsel,
>>  				struct machine *machine)
>>  {
>> -	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
>> +	struct thread *thread = machine__findnew_thread(machine, event->ip.pid,
>> +							event->ip.pid);
> 
> And here.
> 
> [SNIP]
> 
>> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
>> index 1cad370..a021e70 100644
>> --- a/tools/perf/builtin-script.c
>> +++ b/tools/perf/builtin-script.c
>> @@ -480,7 +480,8 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
>>  				struct machine *machine)
>>  {
>>  	struct addr_location al;
>> -	struct thread *thread = machine__findnew_thread(machine, event->ip.tid);
>> +	struct thread *thread = machine__findnew_thread(machine, event->ip.pid,
>> +							event->ip.tid);
> 
> But .tid used here.
> 
>>  
>>  	if (thread == NULL) {
>>  		pr_debug("problem processing %d event, skipping it.\n",
> [SNIP]
>> diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
>> index 5295625..0f9d27a 100644
>> --- a/tools/perf/util/build-id.c
>> +++ b/tools/perf/util/build-id.c
>> @@ -24,7 +24,8 @@ int build_id__mark_dso_hit(struct perf_tool *tool __maybe_unused,
>>  {
>>  	struct addr_location al;
>>  	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
>> -	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
>> +	struct thread *thread = machine__findnew_thread(machine, event->ip.pid,
>> +							event->ip.pid);
> 
> Again, pid used.
> 
>>  
>>  	if (thread == NULL) {
>>  		pr_err("problem processing %d event, skipping it.\n",
>> @@ -47,7 +48,9 @@ static int perf_event__exit_del_thread(struct perf_tool *tool __maybe_unused,
>>  				       __maybe_unused,
>>  				       struct machine *machine)
>>  {
>> -	struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
>> +	struct thread *thread = machine__findnew_thread(machine,
>> +							event->fork.pid,
>> +							event->fork.tid);
>>  
>>  	dump_printf("(%d:%d):(%d:%d)\n", event->fork.pid, event->fork.tid,
>>  		    event->fork.ppid, event->fork.ptid);
>> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
>> index 9541270..ec494a3 100644
>> --- a/tools/perf/util/event.c
>> +++ b/tools/perf/util/event.c
>> @@ -677,7 +677,8 @@ int perf_event__preprocess_sample(const union perf_event *event,
>>  				  symbol_filter_t filter)
>>  {
>>  	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
>> -	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
>> +	struct thread *thread = machine__findnew_thread(machine, event->ip.pid,
>> +							event->ip.pid);
> 
> And here.
> 
>>  
>>  	if (thread == NULL)
>>  		return -1;
>> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
>> index 67ba572..16b84ac 100644
>> --- a/tools/perf/util/machine.c
>> +++ b/tools/perf/util/machine.c
>> @@ -30,7 +30,8 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
>>  		return -ENOMEM;
>>  
>>  	if (pid != HOST_KERNEL_ID) {
>> -		struct thread *thread = machine__findnew_thread(machine, pid);
>> +		struct thread *thread = machine__findnew_thread(machine, 0,
>> +								pid);
>>  		char comm[64];
>>  
>>  		if (thread == NULL)
>> @@ -282,9 +283,10 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
>>  	return th;
>>  }
>>  
>> -struct thread *machine__findnew_thread(struct machine *machine, pid_t tid)
>> +struct thread *machine__findnew_thread(struct machine *machine, pid_t pid,
>> +				       pid_t tid)
>>  {
>> -	return __machine__findnew_thread(machine, 0, tid, true);
>> +	return __machine__findnew_thread(machine, pid, tid, true);
>>  }
>>  
>>  struct thread *machine__find_thread(struct machine *machine, pid_t tid)
>> @@ -294,7 +296,9 @@ struct thread *machine__find_thread(struct machine *machine, pid_t tid)
>>  
>>  int machine__process_comm_event(struct machine *machine, union perf_event *event)
>>  {
>> -	struct thread *thread = machine__findnew_thread(machine, event->comm.tid);
>> +	struct thread *thread = machine__findnew_thread(machine,
>> +							event->comm.pid,
>> +							event->comm.tid);
>>  
>>  	if (dump_trace)
>>  		perf_event__fprintf_comm(event, stdout);
>> @@ -975,7 +979,8 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
>>  		return 0;
>>  	}
>>  
>> -	thread = machine__findnew_thread(machine, event->mmap.pid);
>> +	thread = machine__findnew_thread(machine, event->mmap.pid,
>> +					 event->mmap.pid);
> 
> Ditto.
> 
> Hmm.. now I'm thinking that it's related to sharing map_groups between
> threads within a process.  To do that, IMHO we need more sophisticated
> handling rather than passing either pid or tid depending on contexts?

Yes there is always more that could be done.


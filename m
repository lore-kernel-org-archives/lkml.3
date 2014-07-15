Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811AbaGOLoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:44:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:37182 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758376AbaGOLoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:44:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,665,1400050800"; 
   d="scan'208";a="562011636"
Message-ID: <53C513CC.1010202@intel.com>
Date: Tue, 15 Jul 2014 14:43:08 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 05/41] perf tools: Identify which comms are from exec
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com> <1405332185-4050-6-git-send-email-adrian.hunter@intel.com> <20140714203237.GA18133@kernel.org>
In-Reply-To: <20140714203237.GA18133@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 11:32 PM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jul 14, 2014 at 01:02:29PM +0300, Adrian Hunter escreveu:
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/util/comm.c    |  7 +++++--
>>  tools/perf/util/comm.h    |  6 ++++--
>>  tools/perf/util/machine.c |  4 +++-
>>  tools/perf/util/thread.c  | 24 +++++++++++++++++++-----
>>  tools/perf/util/thread.h  | 10 +++++++++-
>>  5 files changed, 40 insertions(+), 11 deletions(-)
>>
>> diff --git a/tools/perf/util/comm.c b/tools/perf/util/comm.c
>> index f9e7776..5e1e80e 100644
>> --- a/tools/perf/util/comm.c
>> +++ b/tools/perf/util/comm.c
>> @@ -74,7 +74,7 @@ static struct comm_str *comm_str__findnew(const char *str, struct rb_root *root)
>>  	return new;
>>  }
>>  
>> -struct comm *comm__new(const char *str, u64 timestamp)
>> +struct comm *comm__new(const char *str, u64 timestamp, bool exec)
>>  {
>>  	struct comm *comm = zalloc(sizeof(*comm));
>>  
>> @@ -82,6 +82,7 @@ struct comm *comm__new(const char *str, u64 timestamp)
>>  		return NULL;
>>  
>>  	comm->start = timestamp;
>> +	comm->exec = exec;
>>  
>>  	comm->comm_str = comm_str__findnew(str, &comm_str_root);
>>  	if (!comm->comm_str) {
>> @@ -94,7 +95,7 @@ struct comm *comm__new(const char *str, u64 timestamp)
>>  	return comm;
>>  }
>>  
>> -int comm__override(struct comm *comm, const char *str, u64 timestamp)
>> +int comm__override(struct comm *comm, const char *str, u64 timestamp, bool exec)
>>  {
>>  	struct comm_str *new, *old = comm->comm_str;
>>  
>> @@ -106,6 +107,8 @@ int comm__override(struct comm *comm, const char *str, u64 timestamp)
>>  	comm_str__put(old);
>>  	comm->comm_str = new;
>>  	comm->start = timestamp;
>> +	if (exec && !comm->exec)
>> +		comm->exec = true;
> 
> Why do you need the !comm->exec test?

Dunno

> 
>>  	return 0;
>>  }
>> diff --git a/tools/perf/util/comm.h b/tools/perf/util/comm.h
>> index fac5bd5..51c10ab 100644
>> --- a/tools/perf/util/comm.h
>> +++ b/tools/perf/util/comm.h
>> @@ -11,11 +11,13 @@ struct comm {
>>  	struct comm_str *comm_str;
>>  	u64 start;
>>  	struct list_head list;
>> +	bool exec;
>>  };
>>  
>>  void comm__free(struct comm *comm);
>> -struct comm *comm__new(const char *str, u64 timestamp);
>> +struct comm *comm__new(const char *str, u64 timestamp, bool exec);
>>  const char *comm__str(const struct comm *comm);
>> -int comm__override(struct comm *comm, const char *str, u64 timestamp);
>> +int comm__override(struct comm *comm, const char *str, u64 timestamp,
>> +		   bool exec);
>>  
>>  #endif  /* __PERF_COMM_H */
>> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
>> index 0fa93c1..2513204 100644
>> --- a/tools/perf/util/machine.c
>> +++ b/tools/perf/util/machine.c
>> @@ -360,11 +360,13 @@ int machine__process_comm_event(struct machine *machine, union perf_event *event
>>  	struct thread *thread = machine__findnew_thread(machine,
>>  							event->comm.pid,
>>  							event->comm.tid);
>> +	bool exec = event->header.misc & PERF_RECORD_MISC_COMM_EXEC;
>>  
>>  	if (dump_trace)
>>  		perf_event__fprintf_comm(event, stdout);
>>  
>> -	if (thread == NULL || thread__set_comm(thread, event->comm.comm, sample->time)) {
>> +	if (thread == NULL ||
>> +	    __thread__set_comm(thread, event->comm.comm, sample->time, exec)) {
>>  		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
>>  		return -1;
>>  	}
>> diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
>> index ca94295..149e417 100644
>> --- a/tools/perf/util/thread.c
>> +++ b/tools/perf/util/thread.c
>> @@ -76,7 +76,7 @@ struct thread *thread__new(pid_t pid, pid_t tid)
>>  			goto err_thread;
>>  
>>  		snprintf(comm_str, 32, ":%d", tid);
>> -		comm = comm__new(comm_str, 0);
>> +		comm = comm__new(comm_str, 0, false);
>>  		free(comm_str);
>>  		if (!comm)
>>  			goto err_thread;
>> @@ -113,19 +113,33 @@ struct comm *thread__comm(const struct thread *thread)
>>  	return list_first_entry(&thread->comm_list, struct comm, list);
>>  }
>>  
>> +struct comm *thread__exec_comm(const struct thread *thread)
>> +{
>> +	struct comm *comm, *last = NULL;
>> +
>> +	list_for_each_entry(comm, &thread->comm_list, list) {
>> +		if (comm->exec)
>> +			return comm;
>> +		last = comm;
>> +	}
>> +
>> +	return last;
>> +}
>> +
>>  /* CHECKME: time should always be 0 if event aren't ordered */
>> -int thread__set_comm(struct thread *thread, const char *str, u64 timestamp)
>> +int __thread__set_comm(struct thread *thread, const char *str, u64 timestamp,
>> +		       bool exec)
>>  {
>>  	struct comm *new, *curr = thread__comm(thread);
>>  	int err;
>>  
>>  	/* Override latest entry if it had no specific time coverage */
>> -	if (!curr->start) {
>> -		err = comm__override(curr, str, timestamp);
>> +	if (!curr->start && !curr->exec) {
>> +		err = comm__override(curr, str, timestamp, exec);
>>  		if (err)
>>  			return err;
>>  	} else {
>> -		new = comm__new(str, timestamp);
>> +		new = comm__new(str, timestamp, exec);
>>  		if (!new)
>>  			return -ENOMEM;
>>  		list_add(&new->list, &thread->comm_list);
>> diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
>> index 9de0629..b4269af 100644
>> --- a/tools/perf/util/thread.h
>> +++ b/tools/perf/util/thread.h
>> @@ -38,9 +38,17 @@ static inline void thread__exited(struct thread *thread)
>>  	thread->dead = true;
>>  }
>>  
>> -int thread__set_comm(struct thread *thread, const char *comm, u64 timestamp);
>> +int __thread__set_comm(struct thread *thread, const char *comm, u64 timestamp,
>> +		       bool exec);
>> +static inline int thread__set_comm(struct thread *thread, const char *comm,
>> +				   u64 timestamp)
>> +{
>> +	return __thread__set_comm(thread, comm, timestamp, false);
>> +}
>> +
> 
> So this is nice, you leave the existing function, setting exec to false,
> so that you don't have to change the existing codepaths where it is not
> from 'exec', and provide a __ prefixed variant where 'exec' can be set.
> 
> Why not to do the same thing for comm__new() ? No uses, i.e. in all
> cases you will need to pass 'exec' as a variable?

There are only 2 comm__new() callers, and they are in files I am changing
anyway.

> 
> I thought about doing the same thing for that machine__findnew_thread,
> i.e. provide a variant where tid and pid is passed and one where just
> the tid is passed, because the pid is unknown.

But you don't want people using the "unknown" variant if they do know
the pid, so forcing them to pass something maybe better.

> 
> BTW, I'll update my perf/core branch with the set of patches that I
> merged, so that you can have where to look for a consolidated tree with
> the things already processed.

Thanks!


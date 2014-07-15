Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbaGOLeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:34:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:33395 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758438AbaGOLeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:34:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,665,1400050800"; 
   d="scan'208";a="562008185"
Message-ID: <53C5116D.1030905@intel.com>
Date: Tue, 15 Jul 2014 14:33:01 +0300
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
Subject: Re: [PATCH 02/41] perf tools: Fix map groups of threads with unknown
 pids
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com> <1405332185-4050-3-git-send-email-adrian.hunter@intel.com> <20140714201829.GA9449@kernel.org>
In-Reply-To: <20140714201829.GA9449@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 11:18 PM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jul 14, 2014 at 01:02:26PM +0300, Adrian Hunter escreveu:
>> Events like sched_switch do not provide a pid (tgid)
>> which can result in threads with an unknown pid.  If
>> the pid is later discovered, join the map groups.
>> Note the thread's map groups should be empty because
>> they are populated by MMAP events which do provide the
>> pid and tid.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/util/machine.c | 22 ++++++++++++++++------
>>  tools/perf/util/map.c     | 14 ++++++++++++++
>>  tools/perf/util/map.h     |  1 +
>>  tools/perf/util/thread.c  | 35 +++++++++++++++++++++++++++++++++++
>>  tools/perf/util/thread.h  |  1 +
>>  5 files changed, 67 insertions(+), 6 deletions(-)
>>
>> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
>> index 5b80877..0fa93c1 100644
>> --- a/tools/perf/util/machine.c
>> +++ b/tools/perf/util/machine.c
>> @@ -272,6 +272,17 @@ void machines__set_id_hdr_size(struct machines *machines, u16 id_hdr_size)
>>  	return;
>>  }
>>  
>> +static void machine__update_thread_pid(struct machine *machine,
>> +				       struct thread *th, pid_t pid)
>> +{
>> +	if (pid != th->pid_ && pid != -1 && th->pid_ == -1) {
>> +		th->pid_ = pid;
>> +		if (thread__join_map_groups(th, machine))
>> +			pr_err("Failed to join map groups for %d:%d\n",
>> +			       th->pid_, th->tid);
>> +	}
>> +}
>> +
> 
> I think you should combine the above function with
> thread__join_map_groups, and I think that the method belongs to the
> 'machine' class, see below for further comments on this...
> 
>> diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
>> index 7a32f44..ca94295 100644
>> --- a/tools/perf/util/thread.c
>> +++ b/tools/perf/util/thread.c
>> @@ -24,6 +24,41 @@ int thread__init_map_groups(struct thread *thread, struct machine *machine)
>>  	return thread->mg ? 0 : -1;
>>  }
>>  
>> +int thread__join_map_groups(struct thread *thread, struct machine *machine)
>> +{
>> +	struct thread *leader;
>> +	pid_t pid = thread->pid_;
>> +
>> +	if (pid == thread->tid)
>> +		return 0;
>> +
>> +	leader = machine__findnew_thread(machine, pid, pid);
>> +	if (!leader)
>> +		return -ENOMEM;
>> +
>> +	if (!leader->mg)
>> +		leader->mg = map_groups__new();
>> +
>> +	if (!leader->mg)
>> +		return -ENOMEM;
>> +
>> +	if (thread->mg) {
>> +		/*
>> +		 * Maps are created from MMAP events which provide the pid and
>> +		 * tid.  Consequently there never should be any maps on a thread
>> +		 * with an unknown pid.  Just print an error if there are.
>> +		 */
>> +		if (!map_groups__empty(thread->mg))
>> +			pr_err("Discarding thread maps for %d:%d\n",
>> +			       thread->pid_, thread->tid);
> 
> Because there is nothing in this function (thread__join_map_groups),
> checking if it is operating on a thread that has an unknown pid.
> 
> So, please consider merging this and its sole caller,
> machine__update_thread_pid, so that the test is in the same function as
> the assumption that it is operating on a thread with an unknown pid.

You have it in your tree now.  Do you want another patch
to do that?


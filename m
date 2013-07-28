Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab3G1Knk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 06:43:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:18667 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab3G1Kni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 06:43:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,763,1367996400"; 
   d="scan'208";a="338043166"
Message-ID: <51F4F5D4.8080405@intel.com>
Date: Sun, 28 Jul 2013 13:43:32 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V8 04/15] perf tools: change machine__findnew_thread()
 to set thread pid
References: <1374144177-24762-1-git-send-email-adrian.hunter@intel.com> <1374144177-24762-5-git-send-email-adrian.hunter@intel.com> <51F29DAC.7000803@gmail.com>
In-Reply-To: <51F29DAC.7000803@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/07/2013 7:02 p.m., David Ahern wrote:
> On 7/18/13 4:42 AM, Adrian Hunter wrote:
>> Add a new parameter for 'pid' to machine__findnew_thread().
>> Change callers to pass 'pid' when it is known.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>> tools/perf/builtin-inject.c | 2 +-
>> tools/perf/builtin-kmem.c | 3 ++-
>> tools/perf/builtin-kvm.c | 3 ++-
>> tools/perf/builtin-lock.c | 3 ++-
>> tools/perf/builtin-sched.c | 17 +++++++++--------
>> tools/perf/builtin-script.c | 3 ++-
>> tools/perf/builtin-trace.c | 12 +++++++++---
>> tools/perf/tests/hists_link.c | 3 ++-
>> tools/perf/util/build-id.c | 7 +++++--
>> tools/perf/util/event.c | 3 ++-
>> tools/perf/util/machine.c | 23 ++++++++++++++++-------
>> tools/perf/util/machine.h | 3 ++-
>> tools/perf/util/session.c | 2 +-
>> 13 files changed, 55 insertions(+), 29 deletions(-)
>>
>> diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
>> index 1d8de2e..0d4ae1d 100644
>> --- a/tools/perf/builtin-inject.c
>> +++ b/tools/perf/builtin-inject.c
>> @@ -198,7 +198,7 @@ static int perf_event__inject_buildid(struct
>> perf_tool *tool,
>>
>> cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
>>
>> - thread = machine__findnew_thread(machine, event->ip.pid);
>> + thread = machine__findnew_thread(machine, event->ip.pid,
>> event->ip.pid);
>
> event->ip.tid? at a minimum current functionality is retained with
> machine__findnew_thread(machine, 0, event->ip.pid)

perf tools records mmap information against the process's main thread
for which pid == tid.  So the correct values are being passed here.

>
>
>> if (thread == NULL) {
>> pr_err("problem processing %d event, skipping it.\n",
>> event->header.type);
>> diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
>> index b49f5c5..c324778 100644
>> --- a/tools/perf/builtin-kmem.c
>> +++ b/tools/perf/builtin-kmem.c
>> @@ -305,7 +305,8 @@ static int process_sample_event(struct perf_tool
>> *tool __maybe_unused,
>> struct perf_evsel *evsel,
>> struct machine *machine)
>> {
>> - struct thread *thread = machine__findnew_thread(machine,
>> event->ip.pid);
>> + struct thread *thread = machine__findnew_thread(machine, event->ip.pid,
>> + event->ip.pid);
>
> ditto.
>
>
>> diff --git a/tools/perf/tests/hists_link.c
>> b/tools/perf/tests/hists_link.c
>> index 89085a9..5a178d5 100644
>> --- a/tools/perf/tests/hists_link.c
>> +++ b/tools/perf/tests/hists_link.c
>> @@ -88,7 +88,8 @@ static struct machine *setup_fake_machine(struct
>> machines *machines)
>> for (i = 0; i < ARRAY_SIZE(fake_threads); i++) {
>> struct thread *thread;
>>
>> - thread = machine__findnew_thread(machine, fake_threads[i].pid);
>> + thread = machine__findnew_thread(machine, fake_threads[i].pid,
>> + fake_threads[i].pid);
>
> And here
>
>> if (thread == NULL)
>> goto out;
>>
>> diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
>> index 5295625..0f9d27a 100644
>> --- a/tools/perf/util/build-id.c
>> +++ b/tools/perf/util/build-id.c
>> @@ -24,7 +24,8 @@ int build_id__mark_dso_hit(struct perf_tool *tool
>> __maybe_unused,
>> {
>> struct addr_location al;
>> u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
>> - struct thread *thread = machine__findnew_thread(machine,
>> event->ip.pid);
>> + struct thread *thread = machine__findnew_thread(machine, event->ip.pid,
>> + event->ip.pid);
>
> and here.
>
>> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
>> index 9541270..ec494a3 100644
>> --- a/tools/perf/util/event.c
>> +++ b/tools/perf/util/event.c
>> @@ -677,7 +677,8 @@ int perf_event__preprocess_sample(const union
>> perf_event *event,
>> symbol_filter_t filter)
>> {
>> u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
>> - struct thread *thread = machine__findnew_thread(machine,
>> event->ip.pid);
>> + struct thread *thread = machine__findnew_thread(machine, event->ip.pid,
>> + event->ip.pid);
>
> and here
>
>>
>> if (thread == NULL)
>> return -1;
>> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
>> index 67ba572..16b84ac 100644
>> --- a/tools/perf/util/machine.c
>> +++ b/tools/perf/util/machine.c
>> @@ -30,7 +30,8 @@ int machine__init(struct machine *machine, const
>> char *root_dir, pid_t pid)
>> return -ENOMEM;
>>
>> if (pid != HOST_KERNEL_ID) {
>> - struct thread *thread = machine__findnew_thread(machine, pid);
>> + struct thread *thread = machine__findnew_thread(machine, 0,
>> + pid);
>> char comm[64];
>>
>> if (thread == NULL)
>> @@ -282,9 +283,10 @@ static struct thread
>> *__machine__findnew_thread(struct machine *machine,
>> return th;
>> }
>>
>> -struct thread *machine__findnew_thread(struct machine *machine, pid_t
>> tid)
>> +struct thread *machine__findnew_thread(struct machine *machine, pid_t
>> pid,
>> + pid_t tid)
>> {
>> - return __machine__findnew_thread(machine, 0, tid, true);
>> + return __machine__findnew_thread(machine, pid, tid, true);
>> }
>>
>> struct thread *machine__find_thread(struct machine *machine, pid_t tid)
>> @@ -294,7 +296,9 @@ struct thread *machine__find_thread(struct machine
>> *machine, pid_t tid)
>>
>> int machine__process_comm_event(struct machine *machine, union
>> perf_event *event)
>> {
>> - struct thread *thread = machine__findnew_thread(machine,
>> event->comm.tid);
>> + struct thread *thread = machine__findnew_thread(machine,
>> + event->comm.pid,
>> + event->comm.tid);
>>
>> if (dump_trace)
>> perf_event__fprintf_comm(event, stdout);
>> @@ -975,7 +979,8 @@ int machine__process_mmap_event(struct machine
>> *machine, union perf_event *event
>> return 0;
>> }
>>
>> - thread = machine__findnew_thread(machine, event->mmap.pid);
>> + thread = machine__findnew_thread(machine, event->mmap.pid,
>> + event->mmap.pid);
>
> and here.
>
> David


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab3KENJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 08:09:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:2484 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab3KENJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:09:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="403882826"
Message-ID: <5278EE0A.1080108@intel.com>
Date: Tue, 05 Nov 2013 15:09:30 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V3 06/11] perf record: Add an option to force per-cpu
 mmaps
References: <1383313899-15987-1-git-send-email-adrian.hunter@intel.com> <1383313899-15987-7-git-send-email-adrian.hunter@intel.com> <20131104152942.GA4004@krava.brq.redhat.com> <5278AC36.1020702@intel.com> <20131105094220.GA1071@krava.brq.redhat.com>
In-Reply-To: <20131105094220.GA1071@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/13 11:42, Jiri Olsa wrote:
> On Tue, Nov 05, 2013 at 10:28:38AM +0200, Adrian Hunter wrote:
>> On 04/11/13 17:29, Jiri Olsa wrote:
>>> On Fri, Nov 01, 2013 at 03:51:34PM +0200, Adrian Hunter wrote:
>>>> By default, when tasks are specified (i.e. -p, -t
>>>> or -u options) per-thread mmaps are created.  Add
>>>> an option to override that and force per-cpu mmaps.
>>>>
>>>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>>>> ---
>>>>  tools/perf/Documentation/perf-record.txt | 6 ++++++
>>>>  tools/perf/builtin-record.c              | 2 ++
>>>>  tools/perf/util/evlist.c                 | 4 +++-
>>>>  tools/perf/util/evsel.c                  | 4 ++--
>>>>  tools/perf/util/target.h                 | 1 +
>>>>  5 files changed, 14 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
>>>> index f10ab63..2ea6685 100644
>>>> --- a/tools/perf/Documentation/perf-record.txt
>>>> +++ b/tools/perf/Documentation/perf-record.txt
>>>> @@ -189,6 +189,12 @@ abort events and some memory events in precise mode on modern Intel CPUs.
>>>>  --transaction::
>>>>  Record transaction flags for transaction related events.
>>>>  
>>>> +--force-per-cpu::
>>>> +Force the use of per-cpu mmaps.  By default, when tasks are specified (i.e. -p,
>>>> +-t or -u options) per-thread mmaps are created.  This option overrides that and
>>>> +forces per-cpu mmaps.  A side-effect of that is that inheritance is
>>>> +automatically enabled.  Add the -i option also to disable inheritance.
>>>
>>> I recently sent out patch that actually force perf cpu mmaps for -p,-t,-u
>>> http://marc.info/?l=linux-kernel&m=138332119912433&w=2
>>>
>>> Is there a reason why would you want to keep single
>>> mmap (in record command) and cut yourself from inherited
>>> events?
>>
>> Not sure I understand the question.
>>
>> perf supports having a single context for a thread.  That is a
>> feature.  You seem to be removing perf tools support for it.
>>
>> I image a case where the user has hundreds of CPUs but just
>> wants to record one thread.  Currently -t does that. i.e.
>> one file descriptor and one mmap saving megabytes of memory.
>>
>> Another advantage of per-thread mmaps is that you do not
>> need to sample time (nor cpu), because the events are recorded
>> in order.
>>
>> I was adding a feature.  Users can choose per-cpu mmaps if
>> they want.
> 
> right, I haven't considered the hundreds CPU machine.. I just
> saw that it disables inherited events in my test ;-) maybe we
> could mentioned that somewhere, because it's not clear

How about this:

From: Adrian Hunter <adrian.hunter@intel.com>

By default, when tasks are specified (i.e. -p, -t
or -u options) per-thread mmaps are created.  Add
an option to override that and force per-cpu mmaps.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-record.txt | 15 +++++++++++++++
 tools/perf/builtin-record.c              |  2 ++
 tools/perf/util/evlist.c                 |  4 +++-
 tools/perf/util/evsel.c                  |  4 ++--
 tools/perf/util/target.h                 |  1 +
 5 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 052f7c4..5d5cbed 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -53,14 +53,20 @@ OPTIONS
 -p::
 --pid=::
 	Record events on existing process ID (comma separated list).
+	Note this causes the use of per-thread mmaps which prevents
+	inheritance. This can be overridden by --force-per-cpu.
 
 -t::
 --tid=::
         Record events on existing thread ID (comma separated list).
+	Note this causes the use of per-thread mmaps which prevents
+	inheritance. This can be overridden by --force-per-cpu.
 
 -u::
 --uid=::
         Record events in threads owned by uid. Name or number.
+	Note this causes the use of per-thread mmaps which prevents
+	inheritance. This can be overridden by --force-per-cpu.
 
 -r::
 --realtime=::
@@ -81,6 +87,9 @@ OPTIONS
 -i::
 --no-inherit::
 	Child tasks do not inherit counters.
+	Note that inheritance is not possible when events are recorded
+	with per-thread mmaps e.g. -p, -t or -u options.
+
 -F::
 --freq=::
 	Profile at this frequency.
@@ -201,6 +210,12 @@ abort events and some memory events in precise mode on modern Intel CPUs.
 --transaction::
 Record transaction flags for transaction related events.
 
+--force-per-cpu::
+Force the use of per-cpu mmaps.  By default, when tasks are specified (i.e. -p,
+-t or -u options) per-thread mmaps are created.  This option overrides that and
+forces per-cpu mmaps.  A side-effect of that is that inheritance is
+automatically enabled.  Add the -i option also to disable inheritance.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8b45fce..6b6f5d9 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -889,6 +889,8 @@ const struct option record_options[] = {
 		    "sample by weight (on special events only)"),
 	OPT_BOOLEAN(0, "transaction", &record.opts.sample_transaction,
 		    "sample transaction flags (special events only)"),
+	OPT_BOOLEAN(0, "force-per-cpu", &record.opts.target.force_per_cpu,
+		    "force the use of per-cpu mmaps"),
 	OPT_END()
 };
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 1c173cc..b3183d5 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -805,7 +805,9 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (perf_target__has_task(target))
+	if (target->force_per_cpu)
+		evlist->cpus = cpu_map__new(target->cpu_list);
+	else if (perf_target__has_task(target))
 		evlist->cpus = cpu_map__dummy_new();
 	else if (!perf_target__has_cpu(target) && !target->uses_mmap)
 		evlist->cpus = cpu_map__dummy_new();
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 5280820..080cc55 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -645,7 +645,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		}
 	}
 
-	if (perf_target__has_cpu(&opts->target))
+	if (perf_target__has_cpu(&opts->target) || opts->target.force_per_cpu)
 		perf_evsel__set_sample_bit(evsel, CPU);
 
 	if (opts->period)
@@ -653,7 +653,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 
 	if (!perf_missing_features.sample_id_all &&
 	    (opts->sample_time || !opts->no_inherit ||
-	     perf_target__has_cpu(&opts->target)))
+	     perf_target__has_cpu(&opts->target) || opts->target.force_per_cpu))
 		perf_evsel__set_sample_bit(evsel, TIME);
 
 	if (opts->raw_samples) {
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
index a4be857..6d7efbd 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -12,6 +12,7 @@ struct perf_target {
 	uid_t	     uid;
 	bool	     system_wide;
 	bool	     uses_mmap;
+	bool	     force_per_cpu;
 };
 
 enum perf_target_errno {
-- 
1.7.11.7


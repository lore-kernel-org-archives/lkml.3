Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbaJXH0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:26:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:59117 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbaJXH0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:26:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,778,1406617200"; 
   d="scan'208";a="624497687"
Message-ID: <5449FECE.5020807@intel.com>
Date: Fri, 24 Oct 2014 10:25:02 +0300
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
Subject: Re: [PATCH 01/16] perf tools: Add id index
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com> <1414061124-26830-2-git-send-email-adrian.hunter@intel.com> <20141023210817.GN14687@kernel.org>
In-Reply-To: <20141023210817.GN14687@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/10/14 00:08, Arnaldo Carvalho de Melo wrote:
> Em Thu, Oct 23, 2014 at 01:45:09PM +0300, Adrian Hunter escreveu:
>> Add an index of the event identifiers.
>>
>> This is needed to queue Instruction
>> Trace samples according to the mmap
>> buffer from which they were recorded.
> 
> This gets difficult to review, I end up having to look at all the
> patches together to figure out the use cases, to see if this here makes
> sense...
> 
> Can you try to explain like to a seven year old?
> 
> Sigh.
> 
> 'id' is somethig super vague, what does this identifies? I want to make
> progress processing these patches, but with so short explanations like
> the above one, it gets difficult.

This is the event id (also called the sample id) which is a unique number
allocated by the kernel to the event created by perf_event_open().  Events
can include the event id by having a sample type including PERF_SAMPLE_ID or
PERF_SAMPLE_IDENTIFIER.

Currently the main use of the event id is to match an event back to the
evsel to which it belongs i.e. perf_evlist__id2evsel()

The purpose of this patch is to make it possible to match an event back to
the mmap from which it was read.  The reason that is useful is because the
mmap represents a time-ordered context (either for a cpu or for a thread).
Intel PT decodes trace information on that basis.  In full-trace mode, that
information can be recorded when the Intel PT trace is read, but in
sample-mode the Intel PT trace data is embedded in a sample and it is in
that case that the "id index" is needed.

So the mmaps are numbered (idx) and the cpu and tid recorded against the id
by perf_evlist__set_sid_idx() which is called by perf_evlist__mmap_per_evsel().

That information is recorded on the perf.data file in the new "id index".
idx, cpu and tid are added to struct perf_sample_id (which is the node of
evlist's hash table to match ids to evsels).  The information can be
retrieved using perf_evlist__id2sid().  Note however this all depends on
having a sample type including PERF_SAMPLE_ID or PERF_SAMPLE_IDENTIFIER,
otherwise ids are not recorded.

The "id index" is a synthesized event record which will be created when
Intel PT sampling is used by calling perf_event__synthesize_id_index().

> 
> - Arnaldo
>  
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/builtin-inject.c |   1 +
>>  tools/perf/util/event.c     |   1 +
>>  tools/perf/util/event.h     |  15 ++++++
>>  tools/perf/util/evlist.c    |  26 ++++++++--
>>  tools/perf/util/evsel.h     |   3 ++
>>  tools/perf/util/session.c   | 122 ++++++++++++++++++++++++++++++++++++++++++++
>>  tools/perf/util/session.h   |  10 ++++
>>  tools/perf/util/tool.h      |   3 +-
>>  8 files changed, 177 insertions(+), 4 deletions(-)
>>
>> diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
>> index de99ca1..046c719 100644
>> --- a/tools/perf/builtin-inject.c
>> +++ b/tools/perf/builtin-inject.c
>> @@ -410,6 +410,7 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
>>  			.tracing_data	= perf_event__repipe_op2_synth,
>>  			.finished_round	= perf_event__repipe_op2_synth,
>>  			.build_id	= perf_event__repipe_op2_synth,
>> +			.id_index	= perf_event__repipe_op2_synth,
>>  		},
>>  		.input_name  = "-",
>>  		.samples = LIST_HEAD_INIT(inject.samples),
>> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
>> index 4af6b27..bbf6705 100644
>> --- a/tools/perf/util/event.c
>> +++ b/tools/perf/util/event.c
>> @@ -28,6 +28,7 @@ static const char *perf_event__names[] = {
>>  	[PERF_RECORD_HEADER_TRACING_DATA]	= "TRACING_DATA",
>>  	[PERF_RECORD_HEADER_BUILD_ID]		= "BUILD_ID",
>>  	[PERF_RECORD_FINISHED_ROUND]		= "FINISHED_ROUND",
>> +	[PERF_RECORD_ID_INDEX]			= "ID_INDEX",
>>  };
>>  
>>  const char *perf_event__name(unsigned int id)
>> diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
>> index 5699e7e..c89518e 100644
>> --- a/tools/perf/util/event.h
>> +++ b/tools/perf/util/event.h
>> @@ -187,6 +187,7 @@ enum perf_user_event_type { /* above any possible kernel type */
>>  	PERF_RECORD_HEADER_TRACING_DATA		= 66,
>>  	PERF_RECORD_HEADER_BUILD_ID		= 67,
>>  	PERF_RECORD_FINISHED_ROUND		= 68,
>> +	PERF_RECORD_ID_INDEX			= 69,
>>  	PERF_RECORD_HEADER_MAX
>>  };
>>  
>> @@ -239,6 +240,19 @@ struct tracing_data_event {
>>  	u32 size;
>>  };
>>  
>> +struct id_index_entry {
>> +	u64 id;
>> +	u64 idx;
>> +	u64 cpu;
>> +	u64 tid;
>> +};
>> +
>> +struct id_index_event {
>> +	struct perf_event_header header;
>> +	u64 nr;
>> +	struct id_index_entry entries[0];
>> +};
>> +
>>  union perf_event {
>>  	struct perf_event_header	header;
>>  	struct mmap_event		mmap;
>> @@ -253,6 +267,7 @@ union perf_event {
>>  	struct event_type_event		event_type;
>>  	struct tracing_data_event	tracing_data;
>>  	struct build_id_event		build_id;
>> +	struct id_index_event		id_index;
>>  };
>>  
>>  void perf_event__print_totals(void);
>> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
>> index 3c9e77d..0babd39 100644
>> --- a/tools/perf/util/evlist.c
>> +++ b/tools/perf/util/evlist.c
>> @@ -527,6 +527,22 @@ static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
>>  	return 0;
>>  }
>>  
>> +static void perf_evlist__set_sid_idx(struct perf_evlist *evlist,
>> +				     struct perf_evsel *evsel, int idx, int cpu,
>> +				     int thread)
>> +{
>> +	struct perf_sample_id *sid = SID(evsel, cpu, thread);
>> +	sid->idx = idx;
>> +	if (evlist->cpus && cpu >= 0)
>> +		sid->cpu = evlist->cpus->map[cpu];
>> +	else
>> +		sid->cpu = -1;
>> +	if (!evsel->system_wide && evlist->threads && thread >= 0)
>> +		sid->tid = evlist->threads->map[thread];
>> +	else
>> +		sid->tid = -1;
>> +}
>> +
>>  struct perf_sample_id *perf_evlist__id2sid(struct perf_evlist *evlist, u64 id)
>>  {
>>  	struct hlist_head *head;
>> @@ -805,9 +821,13 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
>>  			return -1;
>>  		}
>>  
>> -		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
>> -		    perf_evlist__id_add_fd(evlist, evsel, cpu, thread, fd) < 0)
>> -			return -1;
>> +		if (evsel->attr.read_format & PERF_FORMAT_ID) {
>> +			if (perf_evlist__id_add_fd(evlist, evsel, cpu, thread,
>> +						   fd) < 0)
>> +				return -1;
>> +			perf_evlist__set_sid_idx(evlist, evsel, idx, cpu,
>> +						 thread);
>> +		}
>>  	}
>>  
>>  	return 0;
>> diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
>> index 163c560..4861e8c 100644
>> --- a/tools/perf/util/evsel.h
>> +++ b/tools/perf/util/evsel.h
>> @@ -36,6 +36,9 @@ struct perf_sample_id {
>>  	struct hlist_node 	node;
>>  	u64		 	id;
>>  	struct perf_evsel	*evsel;
>> +	int			idx;
>> +	int			cpu;
>> +	pid_t			tid;
>>  
>>  	/* Holds total ID period value for PERF_SAMPLE_READ processing. */
>>  	u64			period;
>> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
>> index 6702ac2..d70e37d 100644
>> --- a/tools/perf/util/session.c
>> +++ b/tools/perf/util/session.c
>> @@ -228,6 +228,15 @@ static int process_finished_round(struct perf_tool *tool,
>>  				  union perf_event *event,
>>  				  struct perf_session *session);
>>  
>> +static int process_id_index_stub(struct perf_tool *tool __maybe_unused,
>> +				 union perf_event *event __maybe_unused,
>> +				 struct perf_session *perf_session
>> +				 __maybe_unused)
>> +{
>> +	dump_printf(": unhandled!\n");
>> +	return 0;
>> +}
>> +
>>  void perf_tool__fill_defaults(struct perf_tool *tool)
>>  {
>>  	if (tool->sample == NULL)
>> @@ -262,6 +271,8 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
>>  		else
>>  			tool->finished_round = process_finished_round_stub;
>>  	}
>> +	if (tool->id_index == NULL)
>> +		tool->id_index = process_id_index_stub;
>>  }
>>   
>>  static void swap_sample_id_all(union perf_event *event, void *data)
>> @@ -460,6 +471,7 @@ static perf_event__swap_op perf_event__swap_ops[] = {
>>  	[PERF_RECORD_HEADER_EVENT_TYPE]	  = perf_event__event_type_swap,
>>  	[PERF_RECORD_HEADER_TRACING_DATA] = perf_event__tracing_data_swap,
>>  	[PERF_RECORD_HEADER_BUILD_ID]	  = NULL,
>> +	[PERF_RECORD_ID_INDEX]		  = perf_event__all64_swap,
>>  	[PERF_RECORD_HEADER_MAX]	  = NULL,
>>  };
>>  
>> @@ -888,6 +900,8 @@ static s64 perf_session__process_user_event(struct perf_session *session,
>>  		return tool->build_id(tool, event, session);
>>  	case PERF_RECORD_FINISHED_ROUND:
>>  		return tool->finished_round(tool, event, session);
>> +	case PERF_RECORD_ID_INDEX:
>> +		return tool->id_index(tool, event, session);
>>  	default:
>>  		return -EINVAL;
>>  	}
>> @@ -1594,3 +1608,111 @@ int __perf_session__set_tracepoints_handlers(struct perf_session *session,
>>  out:
>>  	return err;
>>  }
>> +
>> +int perf_event__process_id_index(struct perf_tool *tool __maybe_unused,
>> +				 union perf_event *event,
>> +				 struct perf_session *session)
>> +{
>> +	struct perf_evlist *evlist = session->evlist;
>> +	struct id_index_event *ie = &event->id_index;
>> +	size_t i, nr, max_nr;
>> +
>> +	max_nr = (ie->header.size - sizeof(struct id_index_event)) /
>> +		 sizeof(struct id_index_entry);
>> +	nr = ie->nr;
>> +	if (nr > max_nr)
>> +		return -EINVAL;
>> +
>> +	if (dump_trace)
>> +		fprintf(stdout, " nr: %zu\n", nr);
>> +
>> +	for (i = 0; i < nr; i++) {
>> +		struct id_index_entry *e = &ie->entries[i];
>> +		struct perf_sample_id *sid;
>> +
>> +		if (dump_trace) {
>> +			fprintf(stdout,	" ... id: %"PRIu64, e->id);
>> +			fprintf(stdout,	"  idx: %"PRIu64, e->idx);
>> +			fprintf(stdout,	"  cpu: %"PRId64, e->cpu);
>> +			fprintf(stdout,	"  tid: %"PRId64"\n", e->tid);
>> +		}
>> +
>> +		sid = perf_evlist__id2sid(evlist, e->id);
>> +		if (!sid)
>> +			return -ENOENT;
>> +		sid->idx = e->idx;
>> +		sid->cpu = e->cpu;
>> +		sid->tid = e->tid;
>> +	}
>> +	return 0;
>> +}
>> +
>> +int perf_event__synthesize_id_index(struct perf_tool *tool,
>> +				    perf_event__handler_t process,
>> +				    struct perf_evlist *evlist,
>> +				    struct machine *machine)
>> +{
>> +	union perf_event *ev;
>> +	struct perf_evsel *evsel;
>> +	size_t nr = 0, i = 0, sz, max_nr, n;
>> +	int err;
>> +
>> +	pr_debug2("Synthesizing id index\n");
>> +
>> +	max_nr = (UINT16_MAX - sizeof(struct id_index_event)) /
>> +		 sizeof(struct id_index_entry);
>> +
>> +	list_for_each_entry(evsel, &evlist->entries, node)
>> +		nr += evsel->ids;
>> +
>> +	n = nr > max_nr ? max_nr : nr;
>> +	sz = sizeof(struct id_index_event) + n * sizeof(struct id_index_entry);
>> +	ev = zalloc(sz);
>> +	if (!ev)
>> +		return -ENOMEM;
>> +
>> +	ev->id_index.header.type = PERF_RECORD_ID_INDEX;
>> +	ev->id_index.header.size = sz;
>> +	ev->id_index.nr = n;
>> +
>> +	list_for_each_entry(evsel, &evlist->entries, node) {
>> +		u32 j;
>> +
>> +		for (j = 0; j < evsel->ids; j++) {
>> +			struct id_index_entry *e;
>> +			struct perf_sample_id *sid;
>> +
>> +			if (i >= n) {
>> +				err = process(tool, ev, NULL, machine);
>> +				if (err)
>> +					goto out_err;
>> +				nr -= n;
>> +				i = 0;
>> +			}
>> +
>> +			e = &ev->id_index.entries[i++];
>> +
>> +			e->id = evsel->id[j];
>> +
>> +			sid = perf_evlist__id2sid(evlist, e->id);
>> +			if (!sid) {
>> +				free(ev);
>> +				return -ENOENT;
>> +			}
>> +
>> +			e->idx = sid->idx;
>> +			e->cpu = sid->cpu;
>> +			e->tid = sid->tid;
>> +		}
>> +	}
>> +
>> +	sz = sizeof(struct id_index_event) + nr * sizeof(struct id_index_entry);
>> +	ev->id_index.header.size = sz;
>> +	ev->id_index.nr = nr;
>> +
>> +	err = process(tool, ev, NULL, machine);
>> +out_err:
>> +	free(ev);
>> +
>> +	return err;
>> +}
>> diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
>> index a4be851..d8521ac 100644
>> --- a/tools/perf/util/session.h
>> +++ b/tools/perf/util/session.h
>> @@ -126,4 +126,14 @@ int __perf_session__set_tracepoints_handlers(struct perf_session *session,
>>  extern volatile int session_done;
>>  
>>  #define session_done()	ACCESS_ONCE(session_done)
>> +
>> +int perf_event__process_id_index(struct perf_tool *tool,
>> +				 union perf_event *event,
>> +				 struct perf_session *session);
>> +
>> +int perf_event__synthesize_id_index(struct perf_tool *tool,
>> +				    perf_event__handler_t process,
>> +				    struct perf_evlist *evlist,
>> +				    struct machine *machine);
>> +
>>  #endif /* __PERF_SESSION_H */
>> diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
>> index f116369..bb2708b 100644
>> --- a/tools/perf/util/tool.h
>> +++ b/tools/perf/util/tool.h
>> @@ -39,7 +39,8 @@ struct perf_tool {
>>  	event_attr_op	attr;
>>  	event_op2	tracing_data;
>>  	event_op2	finished_round,
>> -			build_id;
>> +			build_id,
>> +			id_index;
>>  	bool		ordered_events;
>>  	bool		ordering_requires_timestamps;
>>  };
>> -- 
>> 1.9.1
> 
> 


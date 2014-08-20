Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaHTTsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:48:22 -0400
Received: from mail.kernel.org ([198.145.19.201]:60917 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbaHTTsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:48:20 -0400
Date: Wed, 20 Aug 2014 16:48:13 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/24] perf tools: Add a test for tracking with
 sched_switch
Message-ID: <20140820194813.GI2892@kernel.org>
References: <1408129739-17368-1-git-send-email-adrian.hunter@intel.com>
 <1408129739-17368-2-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408129739-17368-2-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Aug 15, 2014 at 10:08:36PM +0300, Adrian Hunter escreveu:
> Add a test that checks that sched_switch events and
> tracking events can be recorded for a workload using the
> evsel->system_wide and evsel->tracking flags (respectively)
> with other events sometimes enabled or disabled.

Really nice exercise! Gives lots of evlist/evsel routines a good test,
checking for expected behaviour, really good, thanks.

One thing I noticed was that it uses parse_events() for creating events,
a perhaps simpler equivalent would be:

	switch_evsel = perf_evsel__newtp("sched", "sched_switch");

And then go on, like you did, configuring whatever attribute one wants
to have set, like what you get from ":u", and the other things you
touched, like:

	switch_evsel->system_wide = true;
	switch_evsel->no_aux_samples = true;
	switch_evsel->immediate = true;

And when the evsel is all set up, if dealing with evlists, like in this
case, just do a:

	perf_evlist__add(evlist, switch_evsel);

Looks more natural than using parse_events(evlist, "sched:sched_switch");

To then infer that it must be the last entry at this point to retrieve
it using:

	switch_evsel = perf_evlist__last(evlist);

But, for the current architecture, that should be just a clarification,
not a requirement for this specific test.

Applying!

- Arnaldo

 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/Makefile.perf           |   1 +
>  tools/perf/tests/builtin-test.c    |   4 +
>  tools/perf/tests/switch-tracking.c | 572 +++++++++++++++++++++++++++++++++++++
>  tools/perf/tests/tests.h           |   1 +
>  4 files changed, 578 insertions(+)
>  create mode 100644 tools/perf/tests/switch-tracking.c
> 
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index 1ea31e2..95e832b 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -425,6 +425,7 @@ endif
>  endif
>  LIB_OBJS += $(OUTPUT)tests/mmap-thread-lookup.o
>  LIB_OBJS += $(OUTPUT)tests/thread-mg-share.o
> +LIB_OBJS += $(OUTPUT)tests/switch-tracking.o
>  
>  BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
>  BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
> diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
> index 9948136..6a4145e 100644
> --- a/tools/perf/tests/builtin-test.c
> +++ b/tools/perf/tests/builtin-test.c
> @@ -154,6 +154,10 @@ static struct test {
>  		.func = test__hists_cumulate,
>  	},
>  	{
> +		.desc = "Test tracking with sched_switch",
> +		.func = test__switch_tracking,
> +	},
> +	{
>  		.func = NULL,
>  	},
>  };
> diff --git a/tools/perf/tests/switch-tracking.c b/tools/perf/tests/switch-tracking.c
> new file mode 100644
> index 0000000..50c82d5
> --- /dev/null
> +++ b/tools/perf/tests/switch-tracking.c
> @@ -0,0 +1,572 @@
> +#include <sys/time.h>
> +#include <sys/prctl.h>
> +#include <time.h>
> +#include <stdlib.h>
> +
> +#include "parse-events.h"
> +#include "evlist.h"
> +#include "evsel.h"
> +#include "thread_map.h"
> +#include "cpumap.h"
> +#include "tests.h"
> +
> +static int spin_sleep(void)
> +{
> +	struct timeval start, now, diff, maxtime;
> +	struct timespec ts;
> +	int err, i;
> +
> +	maxtime.tv_sec = 0;
> +	maxtime.tv_usec = 50000;
> +
> +	err = gettimeofday(&start, NULL);
> +	if (err)
> +		return err;
> +
> +	/* Spin for 50ms */
> +	while (1) {
> +		for (i = 0; i < 1000; i++)
> +			barrier();
> +
> +		err = gettimeofday(&now, NULL);
> +		if (err)
> +			return err;
> +
> +		timersub(&now, &start, &diff);
> +		if (timercmp(&diff, &maxtime, > /* For checkpatch */))
> +			break;
> +	}
> +
> +	ts.tv_nsec = 50 * 1000 * 1000;
> +	ts.tv_sec = 0;
> +
> +	/* Sleep for 50ms */
> +	err = nanosleep(&ts, NULL);
> +	if (err == EINTR)
> +		err = 0;
> +
> +	return err;
> +}
> +
> +struct switch_tracking {
> +	struct perf_evsel *switch_evsel;
> +	struct perf_evsel *cycles_evsel;
> +	pid_t *tids;
> +	int nr_tids;
> +	int comm_seen[4];
> +	int cycles_before_comm_1;
> +	int cycles_between_comm_2_and_comm_3;
> +	int cycles_after_comm_4;
> +};
> +
> +static int check_comm(struct switch_tracking *switch_tracking,
> +		      union perf_event *event, const char *comm, int nr)
> +{
> +	if (event->header.type == PERF_RECORD_COMM &&
> +	    (pid_t)event->comm.pid == getpid() &&
> +	    (pid_t)event->comm.tid == getpid() &&
> +	    strcmp(event->comm.comm, comm) == 0) {
> +		if (switch_tracking->comm_seen[nr]) {
> +			pr_debug("Duplicate comm event\n");
> +			return -1;
> +		}
> +		switch_tracking->comm_seen[nr] = 1;
> +		pr_debug3("comm event: %s nr: %d\n", event->comm.comm, nr);
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +static int check_cpu(struct switch_tracking *switch_tracking, int cpu)
> +{
> +	int i, nr = cpu + 1;
> +
> +	if (cpu < 0)
> +		return -1;
> +
> +	if (!switch_tracking->tids) {
> +		switch_tracking->tids = calloc(nr, sizeof(pid_t));
> +		if (!switch_tracking->tids)
> +			return -1;
> +		for (i = 0; i < nr; i++)
> +			switch_tracking->tids[i] = -1;
> +		switch_tracking->nr_tids = nr;
> +		return 0;
> +	}
> +
> +	if (cpu >= switch_tracking->nr_tids) {
> +		void *addr;
> +
> +		addr = realloc(switch_tracking->tids, nr * sizeof(pid_t));
> +		if (!addr)
> +			return -1;
> +		switch_tracking->tids = addr;
> +		for (i = switch_tracking->nr_tids; i < nr; i++)
> +			switch_tracking->tids[i] = -1;
> +		switch_tracking->nr_tids = nr;
> +		return 0;
> +	}
> +
> +	return 0;
> +}
> +
> +static int process_sample_event(struct perf_evlist *evlist,
> +				union perf_event *event,
> +				struct switch_tracking *switch_tracking)
> +{
> +	struct perf_sample sample;
> +	struct perf_evsel *evsel;
> +	pid_t next_tid, prev_tid;
> +	int cpu, err;
> +
> +	if (perf_evlist__parse_sample(evlist, event, &sample)) {
> +		pr_debug("perf_evlist__parse_sample failed\n");
> +		return -1;
> +	}
> +
> +	evsel = perf_evlist__id2evsel(evlist, sample.id);
> +	if (evsel == switch_tracking->switch_evsel) {
> +		next_tid = perf_evsel__intval(evsel, &sample, "next_pid");
> +		prev_tid = perf_evsel__intval(evsel, &sample, "prev_pid");
> +		cpu = sample.cpu;
> +		pr_debug3("sched_switch: cpu: %d prev_tid %d next_tid %d\n",
> +			  cpu, prev_tid, next_tid);
> +		err = check_cpu(switch_tracking, cpu);
> +		if (err)
> +			return err;
> +		/*
> +		 * Check for no missing sched_switch events i.e. that the
> +		 * evsel->system_wide flag has worked.
> +		 */
> +		if (switch_tracking->tids[cpu] != -1 &&
> +		    switch_tracking->tids[cpu] != prev_tid) {
> +			pr_debug("Missing sched_switch events\n");
> +			return -1;
> +		}
> +		switch_tracking->tids[cpu] = next_tid;
> +	}
> +
> +	if (evsel == switch_tracking->cycles_evsel) {
> +		pr_debug3("cycles event\n");
> +		if (!switch_tracking->comm_seen[0])
> +			switch_tracking->cycles_before_comm_1 = 1;
> +		if (switch_tracking->comm_seen[1] &&
> +		    !switch_tracking->comm_seen[2])
> +			switch_tracking->cycles_between_comm_2_and_comm_3 = 1;
> +		if (switch_tracking->comm_seen[3])
> +			switch_tracking->cycles_after_comm_4 = 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int process_event(struct perf_evlist *evlist, union perf_event *event,
> +			 struct switch_tracking *switch_tracking)
> +{
> +	if (event->header.type == PERF_RECORD_SAMPLE)
> +		return process_sample_event(evlist, event, switch_tracking);
> +
> +	if (event->header.type == PERF_RECORD_COMM) {
> +		int err, done = 0;
> +
> +		err = check_comm(switch_tracking, event, "Test COMM 1", 0);
> +		if (err < 0)
> +			return -1;
> +		done += err;
> +		err = check_comm(switch_tracking, event, "Test COMM 2", 1);
> +		if (err < 0)
> +			return -1;
> +		done += err;
> +		err = check_comm(switch_tracking, event, "Test COMM 3", 2);
> +		if (err < 0)
> +			return -1;
> +		done += err;
> +		err = check_comm(switch_tracking, event, "Test COMM 4", 3);
> +		if (err < 0)
> +			return -1;
> +		done += err;
> +		if (done != 1) {
> +			pr_debug("Unexpected comm event\n");
> +			return -1;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +struct event_node {
> +	struct list_head list;
> +	union perf_event *event;
> +	u64 event_time;
> +};
> +
> +static int add_event(struct perf_evlist *evlist, struct list_head *events,
> +		     union perf_event *event)
> +{
> +	struct perf_sample sample;
> +	struct event_node *node;
> +
> +	node = malloc(sizeof(struct event_node));
> +	if (!node) {
> +		pr_debug("malloc failed\n");
> +		return -1;
> +	}
> +	node->event = event;
> +	list_add(&node->list, events);
> +
> +	if (perf_evlist__parse_sample(evlist, event, &sample)) {
> +		pr_debug("perf_evlist__parse_sample failed\n");
> +		return -1;
> +	}
> +
> +	if (!sample.time) {
> +		pr_debug("event with no time\n");
> +		return -1;
> +	}
> +
> +	node->event_time = sample.time;
> +
> +	return 0;
> +}
> +
> +static void free_event_nodes(struct list_head *events)
> +{
> +	struct event_node *node;
> +
> +	while (!list_empty(events)) {
> +		node = list_entry(events->next, struct event_node, list);
> +		list_del(&node->list);
> +		free(node);
> +	}
> +}
> +
> +static int compar(const void *a, const void *b)
> +{
> +	const struct event_node *nodea = a;
> +	const struct event_node *nodeb = b;
> +	s64 cmp = nodea->event_time - nodeb->event_time;
> +
> +	return cmp;
> +}
> +
> +static int process_events(struct perf_evlist *evlist,
> +			  struct switch_tracking *switch_tracking)
> +{
> +	union perf_event *event;
> +	unsigned pos, cnt = 0;
> +	LIST_HEAD(events);
> +	struct event_node *events_array, *node;
> +	int i, ret;
> +
> +	for (i = 0; i < evlist->nr_mmaps; i++) {
> +		while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
> +			cnt += 1;
> +			ret = add_event(evlist, &events, event);
> +			perf_evlist__mmap_consume(evlist, i);
> +			if (ret < 0)
> +				goto out_free_nodes;
> +		}
> +	}
> +
> +	events_array = calloc(cnt, sizeof(struct event_node));
> +	if (!events_array) {
> +		pr_debug("calloc failed\n");
> +		ret = -1;
> +		goto out_free_nodes;
> +	}
> +
> +	pos = 0;
> +	list_for_each_entry(node, &events, list)
> +		events_array[pos++] = *node;
> +
> +	qsort(events_array, cnt, sizeof(struct event_node), compar);
> +
> +	for (pos = 0; pos < cnt; pos++) {
> +		ret = process_event(evlist, events_array[pos].event,
> +				    switch_tracking);
> +		if (ret < 0)
> +			goto out_free;
> +	}
> +
> +	ret = 0;
> +out_free:
> +	pr_debug("%u events recorded\n", cnt);
> +	free(events_array);
> +out_free_nodes:
> +	free_event_nodes(&events);
> +	return ret;
> +}
> +
> +/**
> + * test__switch_tracking - test using sched_switch and tracking events.
> + *
> + * This function implements a test that checks that sched_switch events and
> + * tracking events can be recorded for a workload (current process) using the
> + * evsel->system_wide and evsel->tracking flags (respectively) with other events
> + * sometimes enabled or disabled.
> + */
> +int test__switch_tracking(void)
> +{
> +	const char *sched_switch = "sched:sched_switch";
> +	struct switch_tracking switch_tracking = {0};
> +	struct record_opts opts = {
> +		.mmap_pages	     = UINT_MAX,
> +		.user_freq	     = UINT_MAX,
> +		.user_interval	     = ULLONG_MAX,
> +		.freq		     = 4000,
> +		.target		     = {
> +			.uses_mmap   = true,
> +		},
> +	};
> +	struct thread_map *threads = NULL;
> +	struct cpu_map *cpus = NULL;
> +	struct perf_evlist *evlist = NULL;
> +	struct perf_evsel *evsel, *cpu_clocks_evsel, *cycles_evsel;
> +	struct perf_evsel *switch_evsel, *tracking_evsel;
> +	const char *comm;
> +	int err = -1;
> +
> +	threads = thread_map__new(-1, getpid(), UINT_MAX);
> +	if (!threads) {
> +		pr_debug("thread_map__new failed!\n");
> +		goto out_err;
> +	}
> +
> +	cpus = cpu_map__new(NULL);
> +	if (!cpus) {
> +		pr_debug("cpu_map__new failed!\n");
> +		goto out_err;
> +	}
> +
> +	evlist = perf_evlist__new();
> +	if (!evlist) {
> +		pr_debug("perf_evlist__new failed!\n");
> +		goto out_err;
> +	}
> +
> +	perf_evlist__set_maps(evlist, cpus, threads);
> +
> +	/* First event */
> +	err = parse_events(evlist, "cpu-clock:u");
> +	if (err) {
> +		pr_debug("Failed to parse event dummy:u\n");
> +		goto out_err;
> +	}
> +
> +	cpu_clocks_evsel = perf_evlist__last(evlist);
> +
> +	/* Second event */
> +	err = parse_events(evlist, "cycles:u");
> +	if (err) {
> +		pr_debug("Failed to parse event cycles:u\n");
> +		goto out_err;
> +	}
> +
> +	cycles_evsel = perf_evlist__last(evlist);
> +
> +	/* Third event */
> +	if (!perf_evlist__can_select_event(evlist, sched_switch)) {
> +		fprintf(stderr, " (no sched_switch)");
> +		err = 0;
> +		goto out;
> +	}
> +
> +	err = parse_events(evlist, sched_switch);
> +	if (err) {
> +		pr_debug("Failed to parse event %s\n", sched_switch);
> +		goto out_err;
> +	}
> +
> +	switch_evsel = perf_evlist__last(evlist);
> +
> +	perf_evsel__set_sample_bit(switch_evsel, CPU);
> +	perf_evsel__set_sample_bit(switch_evsel, TIME);
> +
> +	switch_evsel->system_wide = true;
> +	switch_evsel->no_aux_samples = true;
> +	switch_evsel->immediate = true;
> +
> +	/* Test moving an event to the front */
> +	if (cycles_evsel == perf_evlist__first(evlist)) {
> +		pr_debug("cycles event already at front");
> +		goto out_err;
> +	}
> +	perf_evlist__to_front(evlist, cycles_evsel);
> +	if (cycles_evsel != perf_evlist__first(evlist)) {
> +		pr_debug("Failed to move cycles event to front");
> +		goto out_err;
> +	}
> +
> +	perf_evsel__set_sample_bit(cycles_evsel, CPU);
> +	perf_evsel__set_sample_bit(cycles_evsel, TIME);
> +
> +	/* Fourth event */
> +	err = parse_events(evlist, "dummy:u");
> +	if (err) {
> +		pr_debug("Failed to parse event dummy:u\n");
> +		goto out_err;
> +	}
> +
> +	tracking_evsel = perf_evlist__last(evlist);
> +
> +	perf_evlist__set_tracking_event(evlist, tracking_evsel);
> +
> +	tracking_evsel->attr.freq = 0;
> +	tracking_evsel->attr.sample_period = 1;
> +
> +	perf_evsel__set_sample_bit(tracking_evsel, TIME);
> +
> +	/* Config events */
> +	perf_evlist__config(evlist, &opts);
> +
> +	/* Check moved event is still at the front */
> +	if (cycles_evsel != perf_evlist__first(evlist)) {
> +		pr_debug("Front event no longer at front");
> +		goto out_err;
> +	}
> +
> +	/* Check tracking event is tracking */
> +	if (!tracking_evsel->attr.mmap || !tracking_evsel->attr.comm) {
> +		pr_debug("Tracking event not tracking\n");
> +		goto out_err;
> +	}
> +
> +	/* Check non-tracking events are not tracking */
> +	evlist__for_each(evlist, evsel) {
> +		if (evsel != tracking_evsel) {
> +			if (evsel->attr.mmap || evsel->attr.comm) {
> +				pr_debug("Non-tracking event is tracking\n");
> +				goto out_err;
> +			}
> +		}
> +	}
> +
> +	if (perf_evlist__open(evlist) < 0) {
> +		fprintf(stderr, " (not supported)");
> +		err = 0;
> +		goto out;
> +	}
> +
> +	err = perf_evlist__mmap(evlist, UINT_MAX, false);
> +	if (err) {
> +		pr_debug("perf_evlist__mmap failed!\n");
> +		goto out_err;
> +	}
> +
> +	perf_evlist__enable(evlist);
> +
> +	err = perf_evlist__disable_event(evlist, cpu_clocks_evsel);
> +	if (err) {
> +		pr_debug("perf_evlist__disable_event failed!\n");
> +		goto out_err;
> +	}
> +
> +	err = spin_sleep();
> +	if (err) {
> +		pr_debug("spin_sleep failed!\n");
> +		goto out_err;
> +	}
> +
> +	comm = "Test COMM 1";
> +	err = prctl(PR_SET_NAME, (unsigned long)comm, 0, 0, 0);
> +	if (err) {
> +		pr_debug("PR_SET_NAME failed!\n");
> +		goto out_err;
> +	}
> +
> +	err = perf_evlist__disable_event(evlist, cycles_evsel);
> +	if (err) {
> +		pr_debug("perf_evlist__disable_event failed!\n");
> +		goto out_err;
> +	}
> +
> +	comm = "Test COMM 2";
> +	err = prctl(PR_SET_NAME, (unsigned long)comm, 0, 0, 0);
> +	if (err) {
> +		pr_debug("PR_SET_NAME failed!\n");
> +		goto out_err;
> +	}
> +
> +	err = spin_sleep();
> +	if (err) {
> +		pr_debug("spin_sleep failed!\n");
> +		goto out_err;
> +	}
> +
> +	comm = "Test COMM 3";
> +	err = prctl(PR_SET_NAME, (unsigned long)comm, 0, 0, 0);
> +	if (err) {
> +		pr_debug("PR_SET_NAME failed!\n");
> +		goto out_err;
> +	}
> +
> +	err = perf_evlist__enable_event(evlist, cycles_evsel);
> +	if (err) {
> +		pr_debug("perf_evlist__disable_event failed!\n");
> +		goto out_err;
> +	}
> +
> +	comm = "Test COMM 4";
> +	err = prctl(PR_SET_NAME, (unsigned long)comm, 0, 0, 0);
> +	if (err) {
> +		pr_debug("PR_SET_NAME failed!\n");
> +		goto out_err;
> +	}
> +
> +	err = spin_sleep();
> +	if (err) {
> +		pr_debug("spin_sleep failed!\n");
> +		goto out_err;
> +	}
> +
> +	perf_evlist__disable(evlist);
> +
> +	switch_tracking.switch_evsel = switch_evsel;
> +	switch_tracking.cycles_evsel = cycles_evsel;
> +
> +	err = process_events(evlist, &switch_tracking);
> +
> +	zfree(&switch_tracking.tids);
> +
> +	if (err)
> +		goto out_err;
> +
> +	/* Check all 4 comm events were seen i.e. that evsel->tracking works */
> +	if (!switch_tracking.comm_seen[0] || !switch_tracking.comm_seen[1] ||
> +	    !switch_tracking.comm_seen[2] || !switch_tracking.comm_seen[3]) {
> +		pr_debug("Missing comm events\n");
> +		goto out_err;
> +	}
> +
> +	/* Check cycles event got enabled */
> +	if (!switch_tracking.cycles_before_comm_1) {
> +		pr_debug("Missing cycles events\n");
> +		goto out_err;
> +	}
> +
> +	/* Check cycles event got disabled */
> +	if (switch_tracking.cycles_between_comm_2_and_comm_3) {
> +		pr_debug("cycles events even though event was disabled\n");
> +		goto out_err;
> +	}
> +
> +	/* Check cycles event got enabled again */
> +	if (!switch_tracking.cycles_after_comm_4) {
> +		pr_debug("Missing cycles events\n");
> +		goto out_err;
> +	}
> +out:
> +	if (evlist) {
> +		perf_evlist__disable(evlist);
> +		perf_evlist__delete(evlist);
> +	} else {
> +		cpu_map__delete(cpus);
> +		thread_map__delete(threads);
> +	}
> +
> +	return err;
> +
> +out_err:
> +	err = -1;
> +	goto out;
> +}
> diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
> index ed64790..be8be10 100644
> --- a/tools/perf/tests/tests.h
> +++ b/tools/perf/tests/tests.h
> @@ -48,6 +48,7 @@ int test__mmap_thread_lookup(void);
>  int test__thread_mg_share(void);
>  int test__hists_output(void);
>  int test__hists_cumulate(void);
> +int test__switch_tracking(void);
>  
>  #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
>  #ifdef HAVE_DWARF_UNWIND_SUPPORT
> -- 
> 1.8.3.2

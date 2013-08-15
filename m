Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab3HON0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:26:46 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:59280 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab3HON0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:26:44 -0400
Date: Thu, 15 Aug 2013 10:26:37 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/4] perf, tools: Add perf stat --transaction v3
Message-ID: <20130815132637.GE1861@ghostprotocols.net>
References: <1376505267-8902-1-git-send-email-andi@firstfloor.org>
 <1376505267-8902-5-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376505267-8902-5-git-send-email-andi@firstfloor.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 14, 2013 at 11:34:27AM -0700, Andi Kleen escreveu:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add support to perf stat to print the basic transactional execution statistics:
> Total cycles, Cycles in Transaction, Cycles in aborted transsactions
> using the in_tx and in_tx_checkpoint qualifiers.
> Transaction Starts and Elision Starts, to compute the average transaction length.
> 
> This is a reasonable overview over the success of the transactions.
> 
> Enable with a new --transaction / -T option.
> 
> This requires measuring these events in a group, since they depend on each
> other.
> 
> This is implemented by using TM sysfs events exported by the kernel
> 
> v2: Only print the extended statistics when the option is enabled.
> This avoids negative output when the user specifies the -T events
> in separate groups.
> v3: Port to latest tree
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/Documentation/perf-stat.txt |   5 ++
>  tools/perf/builtin-stat.c              | 132 ++++++++++++++++++++++++++++++++-
>  tools/perf/util/evsel.h                |   6 ++
>  tools/perf/util/pmu.c                  |  16 ++++
>  tools/perf/util/pmu.h                  |   1 +
>  5 files changed, 157 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
> index 2fe87fb..40bc65a 100644
> --- a/tools/perf/Documentation/perf-stat.txt
> +++ b/tools/perf/Documentation/perf-stat.txt
> @@ -132,6 +132,11 @@ is a useful mode to detect imbalance between physical cores.  To enable this mod
>  use --per-core in addition to -a. (system-wide).  The output includes the
>  core number and the number of online logical processors on that physical processor.
>  
> +-T::
> +--transaction::
> +
> +Print statistics of transactional execution if supported.
> +
>  EXAMPLES
>  --------
>  
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 352fbd7..d68bf93 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -46,6 +46,7 @@
>  #include "util/util.h"
>  #include "util/parse-options.h"
>  #include "util/parse-events.h"
> +#include "util/pmu.h"
>  #include "util/event.h"
>  #include "util/evlist.h"
>  #include "util/evsel.h"
> @@ -70,6 +71,41 @@ static void print_counter_aggr(struct perf_evsel *counter, char *prefix);
>  static void print_counter(struct perf_evsel *counter, char *prefix);
>  static void print_aggr(char *prefix);
>  
> +/* Default events used for perf stat -T */
> +static const char * const transaction_attrs[] = {
> +	"task-clock",
> +	"{"
> +	"instructions,"
> +	"cycles,"
> +	"cpu/cycles-t/,"
> +	"cpu/tx-start/,"
> +	"cpu/el-start/,"
> +	"cpu/cycles-ct/"
> +	"}"
> +};
> +
> +/* More limited version when the CPU does not have all events. */
> +static const char * const transaction_limited_attrs[] = {
> +	"task-clock",
> +	"{"
> +	"instructions,"
> +	"cycles,"
> +	"cpu/cycles-t/,"
> +	"cpu/tx-start/"
> +	"}"
> +};
> +
> +/* must match the transaction_attrs above */

Match in what way? It kinda matches the first one (transaction_attrs):

enum {
	T_TASK_CLOCK,        ==	"task-clock",
	T_INSTRUCTIONS,      == "instructions,"
	T_CYCLES,	     == "cycles,"
	T_CYCLES_IN_TX,      ~= "cpu/cycles-t/,"
	T_TRANSACTION_START, != "cpu/tx-start/,"
	T_ELISION_START,     ~= "cpu/el-start/,"
	T_CYCLES_IN_TX_CP,   != "cpu/cycles-ct/"
};

Also the enum numbers won't match the array positions due to the '{'
grouping (?) entries, so, without looking further, how can this match?
Reading on...

Also:

~=  Kinda matches
==  Matches
!=  Doesn't look like matching, does it?

:-)

>  static struct perf_evlist	*evsel_list;
>  
>  static struct perf_target	target = {
> @@ -90,6 +126,7 @@ static enum aggr_mode		aggr_mode			= AGGR_GLOBAL;
>  static volatile pid_t		child_pid			= -1;
>  static bool			null_run			=  false;
>  static int			detailed_run			=  0;
> +static bool			transaction_run;
>  static bool			big_num				=  true;
>  static int			big_num_opt			=  -1;
>  static const char		*csv_sep			= NULL;
> @@ -213,7 +250,10 @@ static struct stats runtime_l1_icache_stats[MAX_NR_CPUS];
>  static struct stats runtime_ll_cache_stats[MAX_NR_CPUS];
>  static struct stats runtime_itlb_cache_stats[MAX_NR_CPUS];
>  static struct stats runtime_dtlb_cache_stats[MAX_NR_CPUS];
> +static struct stats runtime_cycles_in_tx_stats[MAX_NR_CPUS];
>  static struct stats walltime_nsecs_stats;
> +static struct stats runtime_transaction_stats[MAX_NR_CPUS];
> +static struct stats runtime_elision_stats[MAX_NR_CPUS];
>  
>  static void perf_stat__reset_stats(struct perf_evlist *evlist)
>  {
> @@ -235,6 +275,11 @@ static void perf_stat__reset_stats(struct perf_evlist *evlist)
>  	memset(runtime_ll_cache_stats, 0, sizeof(runtime_ll_cache_stats));
>  	memset(runtime_itlb_cache_stats, 0, sizeof(runtime_itlb_cache_stats));
>  	memset(runtime_dtlb_cache_stats, 0, sizeof(runtime_dtlb_cache_stats));
> +	memset(runtime_cycles_in_tx_stats, 0,
> +			sizeof(runtime_cycles_in_tx_stats));
> +	memset(runtime_transaction_stats, 0,
> +		sizeof(runtime_transaction_stats));
> +	memset(runtime_elision_stats, 0, sizeof(runtime_elision_stats));
>  	memset(&walltime_nsecs_stats, 0, sizeof(walltime_nsecs_stats));
>  }
>  
> @@ -272,6 +317,18 @@ static inline int nsec_counter(struct perf_evsel *evsel)
>  	return 0;
>  }
>  
> +static struct perf_evsel *nth_evsel(int n)
> +{
> +	struct perf_evsel *ev;
> +	int j;
> +
> +	j = 0;
> +	list_for_each_entry(ev, &evsel_list->entries, node)
> +		if (j++ == n)
> +			return ev;
> +	return NULL;
> +}

At some point I'll add a:

struct perf_evsel *perf_evlist__entry(evlist, int idx)
{
	struct perf_evsel *evsel;

	list_for_each_entry(evsel, &evsel_list->entries, node)
		if (idx == evsel->idx)
			return evsel;
	return NULL;
}

Helper, but apart from that, your code is ok.

>  /*
>   * Update various tracking values we maintain to print
>   * more semantic information such as miss/hit ratios,
> @@ -283,8 +340,12 @@ static void update_shadow_stats(struct perf_evsel *counter, u64 *count)
>  		update_stats(&runtime_nsecs_stats[0], count[0]);
>  	else if (perf_evsel__match(counter, HARDWARE, HW_CPU_CYCLES))
>  		update_stats(&runtime_cycles_stats[0], count[0]);
> -	else if (perf_evsel__match(counter, HARDWARE, HW_STALLED_CYCLES_FRONTEND))
> -		update_stats(&runtime_stalled_cycles_front_stats[0], count[0]);

Why remove the test for HW_STALLED_CYCLES_FRONTEND?

> +	else if (perf_evsel__cmp(counter, nth_evsel(T_CYCLES_IN_TX)))
> +		update_stats(&runtime_cycles_in_tx_stats[0], count[0]);
> +	else if (perf_evsel__cmp(counter, nth_evsel(T_TRANSACTION_START)))
> +		update_stats(&runtime_transaction_stats[0], count[0]);
> +	else if (perf_evsel__cmp(counter, nth_evsel(T_ELISION_START)))
> +		update_stats(&runtime_elision_stats[0], count[0]);
>  	else if (perf_evsel__match(counter, HARDWARE, HW_STALLED_CYCLES_BACKEND))
>  		update_stats(&runtime_stalled_cycles_back_stats[0], count[0]);
>  	else if (perf_evsel__match(counter, HARDWARE, HW_BRANCH_INSTRUCTIONS))
> @@ -807,7 +868,7 @@ static void print_ll_cache_misses(int cpu,
>  
>  static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
>  {
> -	double total, ratio = 0.0;
> +	double total, ratio = 0.0, total2;
>  	const char *fmt;
>  
>  	if (csv_output)
> @@ -903,6 +964,43 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
>  			ratio = 1.0 * avg / total;
>  
>  		fprintf(output, " # %8.3f GHz                    ", ratio);
> +	} else if (perf_evsel__cmp(evsel, nth_evsel(T_CYCLES_IN_TX)) &&

Got it why it doesn't need to account for the '{' in the array ;-)

While this works and isn't in any fast path, I find it ugly with all
this looping in nth_evsel.

Why not:

	} else if (evsel->idx == T_CYCLES_IN_TX)) &&

? I guess this works as you expect, no?

> +		   transaction_run) {
> +		total = avg_stats(&runtime_cycles_stats[cpu]);
> +		if (total)
> +			fprintf(output,
> +				" #   %5.2f%% transactional cycles   ",
> +				100.0 * (avg / total));
> +	} else if (perf_evsel__cmp(evsel, nth_evsel(T_CYCLES_IN_TX_CP)) &&

Ditto

> +		   transaction_run) {
> +		total = avg_stats(&runtime_cycles_stats[cpu]);
> +		total2 = avg_stats(&runtime_cycles_in_tx_stats[cpu]);
> +		if (total2 < avg)
> +			total2 = avg;
> +		if (total)
> +			fprintf(output,
> +				" #   %5.2f%% aborted cycles         ",
> +				100.0 * ((total2-avg) / total));
> +	} else if (perf_evsel__cmp(evsel, nth_evsel(T_TRANSACTION_START)) &&

Ditto

> +		   avg > 0 &&
> +		   runtime_cycles_in_tx_stats[cpu].n != 0 &&
> +		   transaction_run) {
> +		total = avg_stats(&runtime_cycles_in_tx_stats[cpu]);
> +
> +		if (total)
> +			ratio = total / avg;
> +
> +		fprintf(output, " # %8.0f cycles / transaction   ", ratio);
> +	} else if (perf_evsel__cmp(evsel, nth_evsel(T_ELISION_START)) &&

Ditto

> +		   avg > 0 &&
> +		   runtime_cycles_in_tx_stats[cpu].n != 0 &&
> +		   transaction_run) {
> +		total = avg_stats(&runtime_cycles_in_tx_stats[cpu]);
> +
> +		if (total)
> +			ratio = total / avg;
> +
> +		fprintf(output, " # %8.0f cycles / elision       ", ratio);
>  	} else if (runtime_nsecs_stats[cpu].n != 0) {
>  		char unit = 'M';
>  
> @@ -1216,6 +1314,16 @@ static int perf_stat_init_aggr_mode(void)
>  	return 0;
>  }
>  
> +static int setup_events(const char * const *attrs, unsigned len)
> +{
> +	unsigned i;
> +
> +	for (i = 0; i < len; i++) {
> +		if (parse_events(evsel_list, attrs[i]))
> +			return -1;
> +	}
> +	return 0;
> +}
>  
>  /*
>   * Add default attributes, if there were no attributes specified or
> @@ -1334,6 +1442,22 @@ static int add_default_attributes(void)
>  	if (null_run)
>  		return 0;
>  
> +	if (transaction_run) {
> +		int err;
> +		if (pmu_have_event("cpu", "cycles-ct") &&
> +		    pmu_have_event("cpu", "el-start"))
> +			err = setup_events(transaction_attrs,
> +					ARRAY_SIZE(transaction_attrs));
> +		else
> +				err = setup_events(transaction_limited_attrs,
> +				 ARRAY_SIZE(transaction_limited_attrs));
> +		if (err < 0) {
> +			fprintf(stderr, "Cannot set up transaction events\n");
> +			return -1;
> +		}
> +		return 0;
> +	}
> +
>  	if (!evsel_list->nr_entries) {
>  		if (perf_evlist__add_default_attrs(evsel_list, default_attrs) < 0)
>  			return -1;
> @@ -1419,6 +1543,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
>  		     "aggregate counts per processor socket", AGGR_SOCKET),
>  	OPT_SET_UINT(0, "per-core", &aggr_mode,
>  		     "aggregate counts per physical processor core", AGGR_CORE),
> +	OPT_BOOLEAN('T', "transaction", &transaction_run,
> +		    "hardware transaction statistics"),
>  	OPT_END()
>  	};
>  	const char * const stat_usage[] = {
> diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
> index 3f156cc..2f3dc86 100644
> --- a/tools/perf/util/evsel.h
> +++ b/tools/perf/util/evsel.h
> @@ -180,6 +180,12 @@ static inline bool perf_evsel__match2(struct perf_evsel *e1,
>  	       (e1->attr.config == e2->attr.config);
>  }
>  
> +#define perf_evsel__cmp(a, b)			\
> +	((a) &&					\
> +	 (b) &&					\
> +	 (a)->attr.type == (b)->attr.type &&	\
> +	 (a)->attr.config == (b)->attr.config)
> +
>  int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
>  			      int cpu, int thread, bool scale);
>  
> diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> index bc9d806..64362fe 100644
> --- a/tools/perf/util/pmu.c
> +++ b/tools/perf/util/pmu.c
> @@ -637,3 +637,19 @@ void print_pmu_events(const char *event_glob, bool name_only)
>  		printf("\n");
>  	free(aliases);
>  }
> +
> +bool pmu_have_event(const char *pname, const char *name)
> +{
> +	struct perf_pmu *pmu;
> +	struct perf_pmu_alias *alias;
> +
> +	pmu = NULL;
> +	while ((pmu = perf_pmu__scan(pmu)) != NULL) {
> +		if (strcmp(pname, pmu->name))
> +			continue;
> +		list_for_each_entry(alias, &pmu->aliases, list)
> +			if (!strcmp(alias->name, name))
> +				return true;
> +	}
> +	return false;
> +}
> diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
> index 6b2cbe2..1179b26 100644
> --- a/tools/perf/util/pmu.h
> +++ b/tools/perf/util/pmu.h
> @@ -42,6 +42,7 @@ int perf_pmu__format_parse(char *dir, struct list_head *head);
>  struct perf_pmu *perf_pmu__scan(struct perf_pmu *pmu);
>  
>  void print_pmu_events(const char *event_glob, bool name_only);
> +bool pmu_have_event(const char *pname, const char *name);
>  
>  int perf_pmu__test(void);
>  #endif /* __PMU_H */
> -- 
> 1.8.3.1

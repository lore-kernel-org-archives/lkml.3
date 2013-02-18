Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab3BRPEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 10:04:54 -0500
Received: from mail-gh0-f173.google.com ([209.85.160.173]:48990 "EHLO
	mail-gh0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab3BRPEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 10:04:52 -0500
Date: Mon, 18 Feb 2013 12:04:44 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] perf stat: --repeat forever
Message-ID: <20130218150444.GB1915@ghostprotocols.net>
References: <20130215222849.GA5199@ks398093.ip-192-95-24.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130215222849.GA5199@ks398093.ip-192-95-24.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 15, 2013 at 05:28:49PM -0500, Frederik Deweerdt escreveu:
> Hi,
> 
> The following patch causes 'perf stat --repeat 0' to be interpreted as
> 'forever', displaying the stats for every run.
> 
> We act as if a single run was asked, and reset the stats in each
> iteration. In this mode SIGINT is passed to perf to be able to stop the
> loop with Ctrl+C.

It is not applying to my perf/core branch, please take a look at:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux

branch perf/core

Also please consider removing the need to specify 0, i.e. I think this
is possible and shorter:

# perf stat -a --repeat sleep 1

- Arnaldo
 
> Regards,
> Frederik
> 
> 
> Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
> 
> diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
> index cf0c310..784976a 100644
> --- a/tools/perf/Documentation/perf-stat.txt
> +++ b/tools/perf/Documentation/perf-stat.txt
> @@ -52,7 +52,7 @@ OPTIONS
>  
>  -r::
>  --repeat=<n>::
> -	repeat command and print average + stddev (max: 100)
> +	repeat command and print average + stddev (max: 100). 0 means forever.
>  
>  -B::
>  --big-num::
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index c247fac..b02b3a9 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -87,6 +87,7 @@ static FILE			*output				= NULL;
>  static const char		*pre_cmd			= NULL;
>  static const char		*post_cmd			= NULL;
>  static bool			sync_run			= false;
> +static bool			forever				= false;
>  
>  static volatile int done = 0;
>  
> @@ -94,6 +95,11 @@ struct perf_stat {
>  	struct stats	  res_stats[3];
>  };
>  
> +static void perf_evsel__reset_stat_priv(struct perf_evsel *evsel)
> +{
> +	memset(evsel->priv, 0, sizeof(struct perf_stat));
> +}
> +
>  static int perf_evsel__alloc_stat_priv(struct perf_evsel *evsel)
>  {
>  	evsel->priv = zalloc(sizeof(struct perf_stat));
> @@ -129,6 +135,22 @@ static struct stats runtime_itlb_cache_stats[MAX_NR_CPUS];
>  static struct stats runtime_dtlb_cache_stats[MAX_NR_CPUS];
>  static struct stats walltime_nsecs_stats;
>  
> +static void reset_stats(void)
> +{
> +	memset(runtime_nsecs_stats, 0, sizeof(runtime_nsecs_stats));
> +	memset(runtime_cycles_stats, 0, sizeof(runtime_cycles_stats));
> +	memset(runtime_stalled_cycles_front_stats, 0, sizeof(runtime_stalled_cycles_front_stats));
> +	memset(runtime_stalled_cycles_back_stats, 0, sizeof(runtime_stalled_cycles_back_stats));
> +	memset(runtime_branches_stats, 0, sizeof(runtime_branches_stats));
> +	memset(runtime_cacherefs_stats, 0, sizeof(runtime_cacherefs_stats));
> +	memset(runtime_l1_dcache_stats, 0, sizeof(runtime_l1_dcache_stats));
> +	memset(runtime_l1_icache_stats, 0, sizeof(runtime_l1_icache_stats));
> +	memset(runtime_ll_cache_stats, 0, sizeof(runtime_ll_cache_stats));
> +	memset(runtime_itlb_cache_stats, 0, sizeof(runtime_itlb_cache_stats));
> +	memset(runtime_dtlb_cache_stats, 0, sizeof(runtime_dtlb_cache_stats));
> +	memset(&walltime_nsecs_stats, 0, sizeof(walltime_nsecs_stats));
> +}
> +
>  static int create_perf_stat_counter(struct perf_evsel *evsel)
>  {
>  	struct perf_event_attr *attr = &evsel->attr;
> @@ -1120,7 +1142,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
>  	OPT_INCR('v', "verbose", &verbose,
>  		    "be more verbose (show counter open errors, etc)"),
>  	OPT_INTEGER('r', "repeat", &run_count,
> -		    "repeat command and print average + stddev (max: 100)"),
> +		    "repeat command and print average + stddev (max: 100, forever: 0)"),
>  	OPT_BOOLEAN('n', "null", &null_run,
>  		    "null run - dont start any counters"),
>  	OPT_INCR('d', "detailed", &detailed_run,
> @@ -1220,8 +1242,12 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
>  
>  	if (!argc && !perf_target__has_task(&target))
>  		usage_with_options(stat_usage, options);
> -	if (run_count <= 0)
> +	if (run_count < 0) {
>  		usage_with_options(stat_usage, options);
> +	} else if (run_count == 0) {
> +		forever = true;
> +		run_count = 1;
> +	}
>  
>  	/* no_aggr, cgroup are for system-wide only */
>  	if ((no_aggr || nr_cgroups) && !perf_target__has_cpu(&target)) {
> @@ -1259,21 +1285,31 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
>  	 * task, but being ignored by perf stat itself:
>  	 */
>  	atexit(sig_atexit);
> -	signal(SIGINT,  skip_signal);
> +	if (!forever)
> +		signal(SIGINT,  skip_signal);
>  	signal(SIGALRM, skip_signal);
>  	signal(SIGABRT, skip_signal);
>  
>  	status = 0;
> -	for (run_idx = 0; run_idx < run_count; run_idx++) {
> +	for (run_idx = 0; forever || run_idx < run_count; run_idx++) {
>  		if (run_count != 1 && verbose)
>  			fprintf(output, "[ perf stat: executing run #%d ... ]\n",
> -				run_idx + 1);
> +					run_idx + 1);
>  
>  		status = run_perf_stat(argc, argv);
> +		if (forever && status != -1) {
> +			print_stat(argc, argv);
> +			list_for_each_entry(pos, &evsel_list->entries, node) {
> +				perf_evsel__reset_stat_priv(pos);
> +				perf_evsel__reset_counts(pos, perf_evsel__nr_cpus(pos));
> +			}
> +			reset_stats();
> +		}
>  	}
>  
> -	if (status != -1)
> +	if (!forever && status != -1)
>  		print_stat(argc, argv);
> +
>  out_free_fd:
>  	list_for_each_entry(pos, &evsel_list->entries, node)
>  		perf_evsel__free_stat_priv(pos);
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 1b16dd1..0c49e79 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -580,6 +580,12 @@ int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads)
>  	return 0;
>  }
>  
> +void perf_evsel__reset_counts(struct perf_evsel *evsel, int ncpus)
> +{
> +	memset(evsel->counts, 0, (sizeof(*evsel->counts) +
> +				 (ncpus * sizeof(struct perf_counts_values))));
> +}
> +
>  int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus)
>  {
>  	evsel->counts = zalloc((sizeof(*evsel->counts) +
> diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
> index 3d2b801..364d820 100644
> --- a/tools/perf/util/evsel.h
> +++ b/tools/perf/util/evsel.h
> @@ -114,6 +114,7 @@ const char *perf_evsel__name(struct perf_evsel *evsel);
>  int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
>  int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads);
>  int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus);
> +void perf_evsel__reset_counts(struct perf_evsel *evsel, int ncpus);
>  void perf_evsel__free_fd(struct perf_evsel *evsel);
>  void perf_evsel__free_id(struct perf_evsel *evsel);
>  void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);

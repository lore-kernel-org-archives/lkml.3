Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab3AUCxd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 21:53:33 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48592 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3AUCxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 21:53:32 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-af-50fcadaa41dc
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, jolsa@redhat.com,
        namhyung.kim@lge.com
Subject: Re: [PATCH v4 2/2] perf stat: add interval printing
References: <1358550839-7509-1-git-send-email-eranian@google.com>
	<1358550839-7509-3-git-send-email-eranian@google.com>
Date: Mon, 21 Jan 2013 11:53:29 +0900
In-Reply-To: <1358550839-7509-3-git-send-email-eranian@google.com> (Stephane
	Eranian's message of "Sat, 19 Jan 2013 00:13:59 +0100")
Message-ID: <87bocjl00m.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

On Sat, 19 Jan 2013 00:13:59 +0100, Stephane Eranian wrote:
> This patch adds a new printing mode for perf stat.
> It allows internval printing. That means perf stat
> can now print event deltas at regular time interval.
> This is useful to detect phases in programs.
>
> The -I option enables interval printing. It expects
> an interval duration in milliseconds. Minimum is
> 100ms. Once, activated perf stat prints events deltas
> since last printout. All modes are supported.
>
> $ perf stat -I 1000 -e cycles noploop 10
> noploop for 10 seconds

Is this line an output from perf stat?

In addition, how about adding a head line like:

# time                count      event
#
> 1.000086918         2385155642 cycles                    #    0.000 GHz
> 2.000267937         2392279774 cycles                    #    0.000 GHz
> 3.000385400         2390971450 cycles                    #    0.000 GHz
> 4.000504408         2390996752 cycles                    #    0.000 GHz
> 5.000626878         2390853097 cycles                    #    0.000 GHz
>
> The output format makes it easy to feed into a plotting program
> such as gnuplot when the -I option is used in combination with the -x
> option:
>
> $ perf stat -x, -I 1000 -e cycles noploop 10
> noploop for 10 seconds
> 1.000084113,2378775498,cycles
> 2.000245798,2391056897,cycles
> 3.000354445,2392089414,cycles
> 4.000459115,2390936603,cycles
> 5.000565341,2392108173,cycles
>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
[snip]
> @@ -877,6 +977,8 @@ static void print_counter(struct perf_evsel *counter)
>  static void print_stat(int argc, const char **argv)
>  {
>  	struct perf_evsel *counter;
> +	struct timespec ts, rs;
> +	char prefix[64] = { 0, };
>  	int i;
>  
>  	fflush(stdout);
> @@ -899,12 +1001,18 @@ static void print_stat(int argc, const char **argv)
>  		fprintf(output, ":\n\n");
>  	}
>  
> +	if (interval) {
> +		clock_gettime(CLOCK_MONOTONIC, &ts);
> +		diff_timespec(&rs, &ts, &ref_time);
> +		sprintf(prefix, "%lu.%09lu%s", rs.tv_sec, rs.tv_nsec, csv_sep);
> +	}

AFAICS the only caller of print_stat() is cmd_stat() and it'll call this
only if interval is 0.  So why not just setting prefix to NULL then?


> +
>  	if (no_aggr) {
>  		list_for_each_entry(counter, &evsel_list->entries, node)
> -			print_counter(counter);
> +			print_counter(counter, prefix);
>  	} else {
>  		list_for_each_entry(counter, &evsel_list->entries, node)
> -			print_counter_aggr(counter);
> +			print_counter_aggr(counter, prefix);
>  	}
>  
>  	if (!csv_output) {
> @@ -925,7 +1033,7 @@ static volatile int signr = -1;
>  
>  static void skip_signal(int signo)
>  {
> -	if(child_pid == -1)
> +	if((child_pid == -1) || interval)

Looks like it needs a whitespace :)


>  		done = 1;
>  
>  	signr = signo;
> @@ -1145,6 +1253,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
>  			"command to run prior to the measured command"),
>  	OPT_STRING(0, "post", &post_cmd, "command",
>  			"command to run after to the measured command"),
> +	OPT_INTEGER('I', "interval-print", &interval,
> +		    "print counts at regular interval in ms (>= 100)"),
>  	OPT_END()
>  	};
>  	const char * const stat_usage[] = {
> @@ -1245,12 +1355,23 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
>  		usage_with_options(stat_usage, options);
>  		return -1;
>  	}
> +	if (interval < 0 || (interval > 0 && interval < 100)) {
> +		pr_err("print interval must be >= 100ms\n");
> +		usage_with_options(stat_usage, options);
> +		return -1;
> +	}

How about making 'interval' unsigned and simplify the condition a bit:

	if (interval && interval < 100) {
		...
	}

Thanks,
Namhyung

>  
>  	list_for_each_entry(pos, &evsel_list->entries, node) {
>  		if (perf_evsel__alloc_stat_priv(pos) < 0 ||
>  		    perf_evsel__alloc_counts(pos, perf_evsel__nr_cpus(pos)) < 0)
>  			goto out_free_fd;
>  	}
> +	if (interval) {
> +		list_for_each_entry(pos, &evsel_list->entries, node) {
> +			if (perf_evsel__alloc_prev_raw_counts(pos) < 0)
> +				goto out_free_fd;
> +		}
> +	}

It's not about your patch, but I can't find where it frees evsel->counts
- a counter part of perf_evsel__alloc_counts().  Seems we leak that?


>  
>  	/*
>  	 * We dont want to block the signals - that would cause
> @@ -1260,6 +1381,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
>  	 */
>  	atexit(sig_atexit);
>  	signal(SIGINT,  skip_signal);
> +	signal(SIGCHLD, skip_signal);
>  	signal(SIGALRM, skip_signal);
>  	signal(SIGABRT, skip_signal);
>  
> @@ -1272,11 +1394,13 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
>  		status = run_perf_stat(argc, argv);
>  	}
>  
> -	if (status != -1)
> +	if (status != -1 && !interval)
>  		print_stat(argc, argv);
>  out_free_fd:
> -	list_for_each_entry(pos, &evsel_list->entries, node)
> +	list_for_each_entry(pos, &evsel_list->entries, node) {
>  		perf_evsel__free_stat_priv(pos);
> +		perf_evsel__free_prev_raw_counts(pos);
> +	}
>  	perf_evlist__delete_maps(evsel_list);
>  out:
>  	perf_evlist__delete(evsel_list);

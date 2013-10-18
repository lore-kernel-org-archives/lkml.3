Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab3JRRRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:17:37 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:45621 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab3JRRRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:17:36 -0400
Date: Fri, 18 Oct 2013 14:17:26 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v2 3/4] perf-report: add --max-stack option to limit
 callchain stack scan
Message-ID: <20131018171726.GD12054@ghostprotocols.net>
References: <1382107129-2010-1-git-send-email-Waiman.Long@hp.com>
 <1382107129-2010-4-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382107129-2010-4-git-send-email-Waiman.Long@hp.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 18, 2013 at 10:38:48AM -0400, Waiman Long escreveu:
> When callgraph data was included in the perf data file, it may take a
> long time to scan all those data and merge them together especially
> if the stored callchains are long and the perf data file itself is
> large, like a Gbyte or so.
> 
> The callchain stack is currently limited to PERF_MAX_STACK_DEPTH (127).
> This is a large value. Usually the callgraph data that developers are
> most interested in are the first few levels, the rests are usually
> not looked at.
> 
> This patch adds a new --max-stack option to perf-report to limit the
> depth of callchain stack data to look at to reduce the time it takes
> for perf-report to finish its processing. It trades the presence of
> trailing stack information with faster speed.
> 
> The following table shows the elapsed time of doing perf-report on a
> perf.data file of size 985,531,828 bytes.
> 
> --max_stack	Elapsed Time	Output data size
> -----------	------------	----------------

Please prefix lines like this (------) with a space, otherwise 'git am'
will chop off everything from that line onwards. Fixing it up now.

- Arnaldo

> not set		   88.0s	124,422,651
> 64		   87.5s	116,303,213
> 32		   87.2s	112,023,804
> 16		   86.6s	 94,326,380
> 8		   59.9s	 33,697,248
> 4		   40.7s	 10,116,637
> -g none		   27.1s	  2,555,810
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> ---
>  tools/perf/Documentation/perf-report.txt |    8 ++++++++
>  tools/perf/builtin-report.c              |   22 +++++++++++++++++-----
>  tools/perf/builtin-top.c                 |    3 ++-
>  tools/perf/util/machine.c                |   14 +++++++++-----
>  tools/perf/util/machine.h                |    3 ++-
>  tools/perf/util/session.c                |    3 ++-
>  6 files changed, 40 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
> index 2b8097e..be3f196 100644
> --- a/tools/perf/Documentation/perf-report.txt
> +++ b/tools/perf/Documentation/perf-report.txt
> @@ -135,6 +135,14 @@ OPTIONS
>  
>  	Default: fractal,0.5,callee,function.
>  
> +--max-stack::
> +	Set the stack depth limit when parsing the callchain, anything
> +	beyond the specified depth will be ignored. This is a trade-off
> +	between information loss and faster processing especially for
> +	workloads that can have a very long callchain stack.
> +
> +	Default: 127
> +
>  -G::
>  --inverted::
>          alias for inverted caller based call graph.
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 72eae74..d0c9504 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -47,6 +47,7 @@ struct perf_report {
>  	bool			show_threads;
>  	bool			inverted_callchain;
>  	bool			mem_mode;
> +	int			max_stack;
>  	struct perf_read_values	show_threads_values;
>  	const char		*pretty_printing_style;
>  	const char		*cpu_list;
> @@ -88,7 +89,8 @@ static int perf_report__add_mem_hist_entry(struct perf_tool *tool,
>  	if ((sort__has_parent || symbol_conf.use_callchain) &&
>  	    sample->callchain) {
>  		err = machine__resolve_callchain(machine, evsel, al->thread,
> -						 sample, &parent, al);
> +						 sample, &parent, al,
> +						 rep->max_stack);
>  		if (err)
>  			return err;
>  	}
> @@ -179,7 +181,8 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
>  	if ((sort__has_parent || symbol_conf.use_callchain)
>  	    && sample->callchain) {
>  		err = machine__resolve_callchain(machine, evsel, al->thread,
> -						 sample, &parent, al);
> +						 sample, &parent, al,
> +						 rep->max_stack);
>  		if (err)
>  			return err;
>  	}
> @@ -242,18 +245,21 @@ out:
>  	return err;
>  }
>  
> -static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
> +static int perf_evsel__add_hist_entry(struct perf_tool *tool,
> +				      struct perf_evsel *evsel,
>  				      struct addr_location *al,
>  				      struct perf_sample *sample,
>  				      struct machine *machine)
>  {
> +	struct perf_report *rep = container_of(tool, struct perf_report, tool);
>  	struct symbol *parent = NULL;
>  	int err = 0;
>  	struct hist_entry *he;
>  
>  	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
>  		err = machine__resolve_callchain(machine, evsel, al->thread,
> -						 sample, &parent, al);
> +						 sample, &parent, al,
> +						 rep->max_stack);
>  		if (err)
>  			return err;
>  	}
> @@ -330,7 +336,8 @@ static int process_sample_event(struct perf_tool *tool,
>  		if (al.map != NULL)
>  			al.map->dso->hit = 1;
>  
> -		ret = perf_evsel__add_hist_entry(evsel, &al, sample, machine);
> +		ret = perf_evsel__add_hist_entry(tool, evsel, &al, sample,
> +						 machine);
>  		if (ret < 0)
>  			pr_debug("problem incrementing symbol period, skipping event\n");
>  	}
> @@ -757,6 +764,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
>  			.ordered_samples = true,
>  			.ordering_requires_timestamps = true,
>  		},
> +		.max_stack		 = PERF_MAX_STACK_DEPTH,
>  		.pretty_printing_style	 = "normal",
>  	};
>  	const struct option options[] = {
> @@ -797,6 +805,10 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
>  	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order",
>  		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address). "
>  		     "Default: fractal,0.5,callee,function", &parse_callchain_opt, callchain_default_opt),
> +	OPT_INTEGER(0, "max-stack", &report.max_stack,
> +		    "Set the maximum stack depth when parsing the callchain, "
> +		    "anything beyond the specified depth will be ignored. "
> +		    "Default: " __stringify(PERF_MAX_STACK_DEPTH)),
>  	OPT_BOOLEAN('G', "inverted", &report.inverted_callchain,
>  		    "alias for inverted call graph"),
>  	OPT_CALLBACK(0, "ignore-callees", NULL, "regex",
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 2122141..2725aca 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -771,7 +771,8 @@ static void perf_event__process_sample(struct perf_tool *tool,
>  		    sample->callchain) {
>  			err = machine__resolve_callchain(machine, evsel,
>  							 al.thread, sample,
> -							 &parent, &al);
> +							 &parent, &al,
> +							 PERF_MAX_STACK_DEPTH);
>  			if (err)
>  				return;
>  		}
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index 6188d28..9617c4a 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -1267,10 +1267,12 @@ static int machine__resolve_callchain_sample(struct machine *machine,
>  					     struct thread *thread,
>  					     struct ip_callchain *chain,
>  					     struct symbol **parent,
> -					     struct addr_location *root_al)
> +					     struct addr_location *root_al,
> +					     int max_stack)
>  {
>  	u8 cpumode = PERF_RECORD_MISC_USER;
> -	unsigned int i;
> +	int chain_nr = min(max_stack, (int)chain->nr);
> +	int i;
>  	int err;
>  
>  	callchain_cursor_reset(&callchain_cursor);
> @@ -1280,7 +1282,7 @@ static int machine__resolve_callchain_sample(struct machine *machine,
>  		return 0;
>  	}
>  
> -	for (i = 0; i < chain->nr; i++) {
> +	for (i = 0; i < chain_nr; i++) {
>  		u64 ip;
>  		struct addr_location al;
>  
> @@ -1352,12 +1354,14 @@ int machine__resolve_callchain(struct machine *machine,
>  			       struct thread *thread,
>  			       struct perf_sample *sample,
>  			       struct symbol **parent,
> -			       struct addr_location *root_al)
> +			       struct addr_location *root_al,
> +			       int max_stack)
>  {
>  	int ret;
>  
>  	ret = machine__resolve_callchain_sample(machine, thread,
> -						sample->callchain, parent, root_al);
> +						sample->callchain, parent,
> +						root_al, max_stack);
>  	if (ret)
>  		return ret;
>  
> diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
> index 58a6be1..d09cce0 100644
> --- a/tools/perf/util/machine.h
> +++ b/tools/perf/util/machine.h
> @@ -91,7 +91,8 @@ int machine__resolve_callchain(struct machine *machine,
>  			       struct thread *thread,
>  			       struct perf_sample *sample,
>  			       struct symbol **parent,
> -			       struct addr_location *root_al);
> +			       struct addr_location *root_al,
> +			       int max_stack);
>  
>  /*
>   * Default guest kernel is defined by parameter --guestkallsyms
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 568b750..96e5449 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -1525,7 +1525,8 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
>  	if (symbol_conf.use_callchain && sample->callchain) {
>  
>  		if (machine__resolve_callchain(machine, evsel, al.thread,
> -					       sample, NULL, NULL) != 0) {
> +					       sample, NULL, NULL,
> +					       PERF_MAX_STACK_DEPTH) != 0) {
>  			if (verbose)
>  				error("Failed to resolve callchain. Skipping\n");
>  			return;
> -- 
> 1.7.1

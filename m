Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab3JTWfW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 18:35:22 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:28498 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab3JTWfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 18:35:20 -0400
Message-ID: <1382308516.2827.0.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2 4/4] perf-top: add --max-stack option to limit
 callchain stack scan
From: Davidlohr Bueso <davidlohr@hp.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Date: Sun, 20 Oct 2013 15:35:16 -0700
In-Reply-To: <1382107129-2010-5-git-send-email-Waiman.Long@hp.com>
References: <1382107129-2010-1-git-send-email-Waiman.Long@hp.com>
	 <1382107129-2010-5-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-18 at 10:38 -0400, Waiman Long wrote:
> When the callgraph function is enabled (-G), it may take a long time to
> scan all the stack data and merge them accordingly.
> 
> This patch adds a new --max-stack option to perf-top to limit the depth
> of callchain stack data to look at to reduce the time it takes for
> perf-top to finish its processing. It reduces the amount of information
> provided to the user in exchange for faster speed.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Tested-by: Davidlohr Bueso <davidlohr@hp.com>

> ---
>  tools/perf/Documentation/perf-top.txt |    8 ++++++++
>  tools/perf/builtin-top.c              |    8 ++++++--
>  tools/perf/util/top.h                 |    1 +
>  3 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
> index 58d6598..3fd911c 100644
> --- a/tools/perf/Documentation/perf-top.txt
> +++ b/tools/perf/Documentation/perf-top.txt
> @@ -155,6 +155,14 @@ Default is to monitor all CPUS.
>  
>  	Default: fractal,0.5,callee.
>  
> +--max-stack::
> +	Set the stack depth limit when parsing the callchain, anything
> +	beyond the specified depth will be ignored. This is a trade-off
> +	between information loss and faster processing especially for
> +	workloads that can have a very long callchain stack.
> +
> +	Default: 127
> +
>  --ignore-callees=<regex>::
>          Ignore callees of the function(s) matching the given regex.
>          This has the effect of collecting the callers of each such
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 2725aca..14902b0 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -772,7 +772,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
>  			err = machine__resolve_callchain(machine, evsel,
>  							 al.thread, sample,
>  							 &parent, &al,
> -							 PERF_MAX_STACK_DEPTH);
> +							 top->max_stack);
>  			if (err)
>  				return;
>  		}
> @@ -1052,10 +1052,11 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
>  			.user_freq	= UINT_MAX,
>  			.user_interval	= ULLONG_MAX,
>  			.freq		= 4000, /* 4 KHz */
> -			.target		     = {
> +			.target		= {
>  				.uses_mmap   = true,
>  			},
>  		},
> +		.max_stack	     = PERF_MAX_STACK_DEPTH,
>  		.sym_pcnt_filter     = 5,
>  	};
>  	struct perf_record_opts *opts = &top.record_opts;
> @@ -1110,6 +1111,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
>  	OPT_CALLBACK_DEFAULT('G', "call-graph", &top.record_opts,
>  			     "mode[,dump_size]", record_callchain_help,
>  			     &parse_callchain_opt, "fp"),
> +	OPT_INTEGER(0, "max-stack", &top.max_stack,
> +		    "Set the maximum stack depth when parsing the callchain. "
> +		    "Default: " __stringify(PERF_MAX_STACK_DEPTH)),
>  	OPT_CALLBACK(0, "ignore-callees", NULL, "regex",
>  		   "ignore callees of these functions in call graphs",
>  		   report_parse_ignore_callees_opt),
> diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
> index b554ffc..88cfeaf 100644
> --- a/tools/perf/util/top.h
> +++ b/tools/perf/util/top.h
> @@ -24,6 +24,7 @@ struct perf_top {
>  	u64		   exact_samples;
>  	u64		   guest_us_samples, guest_kernel_samples;
>  	int		   print_entries, count_filter, delay_secs;
> +	int		   max_stack;
>  	bool		   hide_kernel_symbols, hide_user_symbols, zero;
>  	bool		   use_tui, use_stdio;
>  	bool		   kptr_restrict_warned;



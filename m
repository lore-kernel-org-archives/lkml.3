Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaJ0MjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:39:22 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42213 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaJ0MjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:39:21 -0400
Message-ID: <544E3CF2.80901@hitachi.com>
Date: Mon, 27 Oct 2014 21:39:14 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: srikar@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        namhyung@kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: (ltc-kernel 10243) [PATCH perf/core 2/2] perf-probe: Add --quiet
 option to suppress output result message
References: <20141027203124.21219.68278.stgit@localhost.localdomain> <20141027203131.21219.35170.stgit@localhost.localdomain>
In-Reply-To: <20141027203131.21219.35170.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hermant,

This patch is actually what you need for suppressing the result
messages when adding/removing probe events from sdt event tracing.
You just need to set "verbose=-1" around adding/removing probes.

Thank you,

(2014/10/28 5:31), Masami Hiramatsu wrote:
> Add --quiet(-q) option to suppress output result message
> for --add, and --del options (Note that --lines/funcs/vars are
> not affected). This option is useful if you run the perf
> probe inside your scripts.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>  tools/perf/builtin-probe.c    |   11 +++++++++++
>  tools/perf/util/probe-event.c |   18 +++++++++---------
>  2 files changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> index 2d3577d..921bb69 100644
> --- a/tools/perf/builtin-probe.c
> +++ b/tools/perf/builtin-probe.c
> @@ -55,6 +55,7 @@ static struct {
>  	bool show_funcs;
>  	bool mod_events;
>  	bool uprobes;
> +	bool quiet;
>  	int nevents;
>  	struct perf_probe_event events[MAX_PROBES];
>  	struct strlist *dellist;
> @@ -315,6 +316,8 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>  	struct option options[] = {
>  	OPT_INCR('v', "verbose", &verbose,
>  		    "be more verbose (show parsed arguments, etc)"),
> +	OPT_BOOLEAN('q', "quiet", &params.quiet,
> +		    "be quiet (do not show any mesages)"),
>  	OPT_BOOLEAN('l', "list", &params.list_events,
>  		    "list up current probe events"),
>  	OPT_CALLBACK('d', "del", NULL, "[GROUP:]EVENT", "delete a probe event.",
> @@ -404,6 +407,14 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
>  		}
>  	}
>  
> +	if (params.quiet) {
> +		if (verbose != 0) {
> +			pr_err("  Error: -v and -q are exclusive.\n");
> +			return -EINVAL;
> +		}
> +		verbose = -1;
> +	}
> +
>  	if (params.max_probe_points == 0)
>  		params.max_probe_points = MAX_PROBES;
>  
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index c150ca4..28eb141 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -1910,21 +1910,21 @@ static int show_perf_probe_event(struct perf_probe_event *pev,
>  	if (ret < 0)
>  		return ret;
>  
> -	printf("  %-20s (on %s", buf, place);
> +	pr_info("  %-20s (on %s", buf, place);
>  	if (module)
> -		printf(" in %s", module);
> +		pr_info(" in %s", module);
>  
>  	if (pev->nargs > 0) {
> -		printf(" with");
> +		pr_info(" with");
>  		for (i = 0; i < pev->nargs; i++) {
>  			ret = synthesize_perf_probe_arg(&pev->args[i],
>  							buf, 128);
>  			if (ret < 0)
>  				break;
> -			printf(" %s", buf);
> +			pr_info(" %s", buf);
>  		}
>  	}
> -	printf(")\n");
> +	pr_info(")\n");
>  	free(place);
>  	return ret;
>  }
> @@ -2124,7 +2124,7 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
>  	}
>  
>  	ret = 0;
> -	printf("Added new event%s\n", (ntevs > 1) ? "s:" : ":");
> +	pr_info("Added new event%s\n", (ntevs > 1) ? "s:" : ":");
>  	for (i = 0; i < ntevs; i++) {
>  		tev = &tevs[i];
>  		if (pev->event)
> @@ -2179,8 +2179,8 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
>  
>  	if (ret >= 0) {
>  		/* Show how to use the event. */
> -		printf("\nYou can now use it in all perf tools, such as:\n\n");
> -		printf("\tperf record -e %s:%s -aR sleep 1\n\n", tev->group,
> +		pr_info("\nYou can now use it in all perf tools, such as:\n\n");
> +		pr_info("\tperf record -e %s:%s -aR sleep 1\n\n", tev->group,
>  			 tev->event);
>  	}
>  
> @@ -2444,7 +2444,7 @@ static int __del_trace_probe_event(int fd, struct str_node *ent)
>  		goto error;
>  	}
>  
> -	printf("Removed event: %s\n", ent->s);
> +	pr_info("Removed event: %s\n", ent->s);
>  	return 0;
>  error:
>  	pr_warning("Failed to delete event: %s\n",
> 
> 
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab3LSNa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:30:57 -0500
Received: from mail-qe0-f42.google.com ([209.85.128.42]:47922 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab3LSNaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:30:55 -0500
Date: Thu, 19 Dec 2013 10:30:47 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/6] perf report: Use pr_*() functions if possible
Message-ID: <20131219133047.GK4819@ghostprotocols.net>
References: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
 <1387436411-20160-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387436411-20160-2-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 19, 2013 at 04:00:06PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> There're some places printing a message to stdout/err directly.  It
> should be converted to use proper error printing functions instead.
> 
> If it's not possible, just do it when --stdio was enabled only.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-report.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 3a14dbed387c..a1f72b471a96 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -321,8 +321,8 @@ static int process_sample_event(struct perf_tool *tool,
>  	int ret;
>  
>  	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
> -		fprintf(stderr, "problem processing %d event, skipping it.\n",
> -			event->header.type);
> +		pr_debug("problem processing %d event, skipping it.\n",
> +			 event->header.type);
>  		return -1;
>  	}
>  
> @@ -552,15 +552,17 @@ static int __cmd_report(struct perf_report *rep)
>  		desc);
>  	}
>  
> -	if (verbose > 3)
> -		perf_session__fprintf(session, stdout);
> +	if (use_browser == 0) {
> +		if (verbose > 3)
> +			perf_session__fprintf(session, stdout);
>  
> -	if (verbose > 2)
> -		perf_session__fprintf_dsos(session, stdout);
> +		if (verbose > 2)
> +			perf_session__fprintf_dsos(session, stdout);
>  
> -	if (dump_trace) {
> -		perf_session__fprintf_nr_events(session, stdout);
> -		return 0;
> +		if (dump_trace) {
> +			perf_session__fprintf_nr_events(session, stdout);
> +			return 0;
> +		}
>  	}

This should be in a different patch, one that is related just to
dump_trace, i.e. if -D, aka dump_trace (right?) is enabled, then
probably we won't be initializing the TUI/GUI, no?

So having a patch that deals just with conversions of fprintf ->
pr_{err,etc} and another that deals with dump_trace related seems to be
the best course of action.

- Arnaldo
  
>  	nr_samples = 0;
> @@ -720,7 +722,7 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
>  		return -1;
>  setup:
>  	if (callchain_register_param(&callchain_param) < 0) {
> -		fprintf(stderr, "Can't register callchain params\n");
> +		pr_err("Can't register callchain params\n");
>  		return -1;
>  	}
>  	return 0;
> @@ -942,7 +944,7 @@ repeat:
>  	}
>  	if (report.mem_mode) {
>  		if (sort__mode == SORT_MODE__BRANCH) {
> -			fprintf(stderr, "branch and mem mode incompatible\n");
> +			pr_err("branch and mem mode incompatible\n");
>  			goto error;
>  		}
>  		sort__mode = SORT_MODE__MEMORY;
> -- 
> 1.7.11.7

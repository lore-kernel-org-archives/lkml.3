Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaAKP1w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 10:27:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbaAKP1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 10:27:50 -0500
Date: Sat, 11 Jan 2014 16:27:08 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 2/2] perf, tools: Add --delay support to perf record v2
Message-ID: <20140111152708.GB1131@krava.brq.redhat.com>
References: <1389295793-24137-1-git-send-email-andi@firstfloor.org>
 <1389295793-24137-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389295793-24137-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 11:29:53AM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> perf stat has a --delay option to delay measuring the workload.
> This is useful to skip measuring the startup phase of the program, which
> is often very different from the main workload.
> 
> The same is useful for perf record when sampling. Add --delay to perf record too.
> -D was already taken for record, so there is only a long option.
> 
> v2: Don't disable group members (Namhyung Kim)
> Cc: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/Documentation/perf-record.txt | 4 ++++
>  tools/perf/builtin-record.c              | 9 ++++++++-
>  tools/perf/perf.h                        | 1 +
>  tools/perf/util/evsel.c                  | 3 ++-
>  4 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
> index 43b42c4..e349151 100644
> --- a/tools/perf/Documentation/perf-record.txt
> +++ b/tools/perf/Documentation/perf-record.txt
> @@ -207,6 +207,10 @@ Force the use of per-cpu mmaps.  By default, when tasks are specified (i.e. -p,
>  forces per-cpu mmaps.  A side-effect of that is that inheritance is
>  automatically enabled.  Add the -i option also to disable inheritance.
>  
> +--delay msecs::
> +After starting the program, wait msecs before measuring. This is useful to
> +filter out the startup phase of the program, which is often very different.
> +
>  SEE ALSO
>  --------
>  linkperf:perf-stat[1], linkperf:perf-list[1]
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 7c8020a..110158e 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -506,7 +506,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
>  	 * (apart from group members) have enable_on_exec=1 set,
>  	 * so don't spoil it by prematurely enabling them.
>  	 */
> -	if (!target__none(&opts->target))
> +	if (!target__none(&opts->target) && !opts->initial_delay)
>  		perf_evlist__enable(evsel_list);
>  
>  	/*
> @@ -515,6 +515,11 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
>  	if (forks)
>  		perf_evlist__start_workload(evsel_list);
>  
> +	if (opts->initial_delay) {
> +		usleep(opts->initial_delay * 1000);
> +		perf_evlist__enable(evsel_list);
> +	}
> +

evsel_list no longer works due to:
  6346015 perf record: Remove old evsel_list usage

jirka

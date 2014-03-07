Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaCGOhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 09:37:16 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:47230 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaCGOhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:37:14 -0500
Date: Fri, 7 Mar 2014 11:37:07 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 07/13] perf hists: Add support for showing relative
 percentage
Message-ID: <20140307143707.GC3153@ghostprotocols.net>
References: <1393809254-4480-1-git-send-email-namhyung@kernel.org>
 <1393809254-4480-8-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393809254-4480-8-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 03, 2014 at 10:14:08AM +0900, Namhyung Kim escreveu:
> When filtering by thread, dso or symbol on TUI it also update total
> period so that the output shows different result than no filter - the
> percentage changed to relative to filtered entries only.  Sometimes
> this is not desired since users might expect same results with filter.
> 
> So new filtered_* fields to hists->stats to count them separately.
> They'll be controlled/used by user later.
> 
> Acked-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-report.c |  6 ++++++
>  tools/perf/util/hist.c      | 19 +++++++++++++++----
>  tools/perf/util/hist.h      |  2 ++
>  3 files changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 5f7f1a332186..3f8478603d51 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -121,6 +121,8 @@ static int report__add_mem_hist_entry(struct report *rep, struct addr_location *
>  
>  	evsel->hists.stats.total_period += cost;
>  	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
> +	if (!he->filtered)
> +		evsel->hists.stats.nr_filtered_samples++;


Huh? I read the above as "if not filtered, increment the number of
filtered samples", isn't this reversed?

I.e. I understand "filtered" as entries that the filter applied to, so
will not be considered, and you use this meaning for he->filtered, but
not for stats_nr_filtered_samples, right?

- Arnaldo

>  	err = hist_entry__append_callchain(he, sample);
>  out:
>  	return err;
> @@ -170,6 +172,8 @@ static int report__add_branch_hist_entry(struct report *rep, struct addr_locatio
>  
>  			evsel->hists.stats.total_period += 1;
>  			hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
> +			if (!he->filtered)
> +				evsel->hists.stats.nr_filtered_samples++;
>  		} else
>  			goto out;
>  	}
> @@ -201,6 +205,8 @@ static int report__add_hist_entry(struct report *rep, struct perf_evsel *evsel,
>  
>  	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
>  	evsel->hists.stats.total_period += sample->period;
> +	if (!he->filtered)
> +		evsel->hists.stats.nr_filtered_samples++;
>  	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
>  out:
>  	return err;
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index d0c40897c955..743947d891bd 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -675,8 +675,8 @@ void hists__output_resort(struct hists *hists)
>  	next = rb_first(root);
>  	hists->entries = RB_ROOT;
>  
> -	hists->nr_entries = 0;
> -	hists->stats.total_period = 0;
> +	hists->nr_entries = hists->nr_filtered_entries = 0;
> +	hists->stats.total_period = hists->stats.total_filtered_period = 0;
>  	hists__reset_col_len(hists);
>  
>  	while (next) {
> @@ -695,12 +695,17 @@ static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h
>  	if (h->filtered)
>  		return;
>  
> -	++hists->nr_entries;
> -	if (h->ms.unfolded)
> +	hists->nr_entries++;
> +	hists->nr_filtered_entries++;
> +	if (h->ms.unfolded) {
>  		hists->nr_entries += h->nr_rows;
> +		hists->nr_filtered_entries += h->nr_rows;
> +	}
>  	h->row_offset = 0;
>  	hists->stats.total_period += h->stat.period;
> +	hists->stats.total_filtered_period += h->stat.period;
>  	hists->stats.nr_events[PERF_RECORD_SAMPLE] += h->stat.nr_events;
> +	hists->stats.nr_filtered_samples += h->stat.nr_events;
>  
>  	hists__calc_col_len(hists, h);
>  }
> @@ -723,7 +728,9 @@ void hists__filter_by_dso(struct hists *hists)
>  	struct rb_node *nd;
>  
>  	hists->nr_entries = hists->stats.total_period = 0;
> +	hists->nr_filtered_entries = hists->stats.total_filtered_period = 0;
>  	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
> +	hists->stats.nr_filtered_samples = 0;
>  	hists__reset_col_len(hists);
>  
>  	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
> @@ -756,7 +763,9 @@ void hists__filter_by_thread(struct hists *hists)
>  	struct rb_node *nd;
>  
>  	hists->nr_entries = hists->stats.total_period = 0;
> +	hists->nr_filtered_entries = hists->stats.total_filtered_period = 0;
>  	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
> +	hists->stats.nr_filtered_samples = 0;
>  	hists__reset_col_len(hists);
>  
>  	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
> @@ -787,7 +796,9 @@ void hists__filter_by_symbol(struct hists *hists)
>  	struct rb_node *nd;
>  
>  	hists->nr_entries = hists->stats.total_period = 0;
> +	hists->nr_filtered_entries = hists->stats.total_filtered_period = 0;
>  	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
> +	hists->stats.nr_filtered_samples = 0;
>  	hists__reset_col_len(hists);
>  
>  	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> index 5ccc70057934..115d2e7f0a15 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/perf/util/hist.h
> @@ -41,6 +41,7 @@ struct events_stats {
>  	u64 total_lost;
>  	u64 total_invalid_chains;
>  	u32 nr_events[PERF_RECORD_HEADER_MAX];
> +	u32 nr_filtered_samples;
>  	u32 nr_lost_warned;
>  	u32 nr_unknown_events;
>  	u32 nr_invalid_chains;
> @@ -84,6 +85,7 @@ struct hists {
>  	struct rb_root		entries;
>  	struct rb_root		entries_collapsed;
>  	u64			nr_entries;
> +	u64			nr_filtered_entries;
>  	const struct thread	*thread_filter;
>  	const struct dso	*dso_filter;
>  	const char		*uid_filter_str;
> -- 
> 1.7.11.7

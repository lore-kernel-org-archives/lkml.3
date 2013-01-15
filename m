Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab3AOS3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:29:25 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:36576 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab3AOS3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:29:24 -0500
Date: Tue, 15 Jan 2013 15:29:15 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 05/13] perf hists: Resort hist entries using group
 members for output
Message-ID: <20130115182915.GA5826@ghostprotocols.net>
References: <1358235117-12803-1-git-send-email-namhyung@kernel.org>
 <1358235117-12803-6-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358235117-12803-6-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 15, 2013 at 04:31:49PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> When event group is enabled, sorting hist entries on periods for output
> should consider groups members' period also.  To do that, build period
> table using link/pair information and compare the table.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> Acked-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Stephane Eranian <eranian@google.com>
> Link: http://lkml.kernel.org/r/1355726345-29553-7-git-send-email-namhyung@kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/util/evsel.h |  2 ++
>  tools/perf/util/hist.c  | 59 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 60 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
> index f5d22f12ccd8..24225d728ba4 100644
> --- a/tools/perf/util/evsel.h
> +++ b/tools/perf/util/evsel.h
> @@ -78,6 +78,8 @@ struct perf_evsel {
>  	char			*group_name;
>  };
>  
> +#define hists_to_evsel(h) container_of(h, struct perf_evsel, hists)
> +
>  struct cpu_map;
>  struct thread_map;
>  struct perf_evlist;
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 8170a3d11ffa..f855941bebea 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -4,6 +4,7 @@
>  #include "hist.h"
>  #include "session.h"
>  #include "sort.h"
> +#include "evsel.h"
>  #include <math.h>
>  
>  static bool hists__filter_entry_by_dso(struct hists *hists,
> @@ -540,6 +541,62 @@ void hists__collapse_resort_threaded(struct hists *hists)
>   * reverse the map, sort on period.
>   */
>  
> +static int period_cmp(u64 period_a, u64 period_b)
> +{
> +	if (period_a > period_b)
> +		return 1;
> +	if (period_a < period_b)
> +		return -1;
> +	return 0;
> +}
> +
> +static int hist_entry__sort_on_period(struct hist_entry *a,
> +				      struct hist_entry *b)
> +{
> +	int ret;
> +	int i, nr_members;
> +	struct perf_evsel *evsel;
> +	struct hist_entry *pair;
> +	u64 *periods_a, *periods_b;
> +
> +	ret = period_cmp(a->stat.period, b->stat.period);
> +	if (ret || !symbol_conf.event_group)

Why do we need to call period_cmp() when symbol_conf.event_group is
false?

I see, confusing neverthless :-\

> +		return ret;

I would expect two functions, one for sorting on period and another for
not sorting on period, i.e. don't call a function called
'sort_on_period' when _not_ sorting on period.

- Arnaldo

> +
> +	evsel = hists_to_evsel(a->hists);
> +	nr_members = evsel->nr_members;
> +	if (nr_members <= 1)
> +		return ret;
> +
> +	periods_a = zalloc(sizeof(periods_a) * nr_members);
> +	periods_b = zalloc(sizeof(periods_b) * nr_members);
> +
> +	if (!periods_a || !periods_b)
> +		goto out;
> +
> +	list_for_each_entry(pair, &a->pairs.head, pairs.node) {
> +		evsel = hists_to_evsel(pair->hists);
> +		periods_a[perf_evsel__group_idx(evsel)] = pair->stat.period;
> +	}
> +
> +	list_for_each_entry(pair, &b->pairs.head, pairs.node) {
> +		evsel = hists_to_evsel(pair->hists);
> +		periods_b[perf_evsel__group_idx(evsel)] = pair->stat.period;
> +	}
> +
> +	for (i = 1; i < nr_members; i++) {
> +		ret = period_cmp(periods_a[i], periods_b[i]);
> +		if (ret)
> +			break;
> +	}
> +
> +out:
> +	free(periods_a);
> +	free(periods_b);
> +
> +	return ret;
> +}
> +
>  static void __hists__insert_output_entry(struct rb_root *entries,
>  					 struct hist_entry *he,
>  					 u64 min_callchain_hits)
> @@ -556,7 +613,7 @@ static void __hists__insert_output_entry(struct rb_root *entries,
>  		parent = *p;
>  		iter = rb_entry(parent, struct hist_entry, rb_node);
>  
> -		if (he->stat.period > iter->stat.period)
> +		if (hist_entry__sort_on_period(he, iter) > 0)
>  			p = &(*p)->rb_left;
>  		else
>  			p = &(*p)->rb_right;
> -- 
> 1.7.11.7

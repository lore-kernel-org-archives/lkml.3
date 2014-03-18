Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620AbaCRUIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:08:46 -0400
Received: from mail-yk0-f169.google.com ([209.85.160.169]:63061 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348AbaCRUIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:08:44 -0400
Date: Tue, 18 Mar 2014 17:08:37 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 3/9] perf hists: Add support for showing relative
 percentage
Message-ID: <20140318200837.GG6482@ghostprotocols.net>
References: <1394437440-11609-1-git-send-email-namhyung@kernel.org>
 <1394437440-11609-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394437440-11609-4-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 10, 2014 at 04:43:54PM +0900, Namhyung Kim escreveu:
> @@ -695,12 +695,17 @@ static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h
>  	if (h->filtered)
>  		return;
>  
> -	++hists->nr_entries;
> -	if (h->ms.unfolded)
> +	hists->nr_entries++;
> +	hists->nr_non_filtered_entries++;

Why not keep existing practice? prefix or suffix generates the same
code, changing it from prefix to suffix increment just adds noise to the
patch :-\

Also, this is why I was asking about nr_entries and total_period being
invariant, looking at this function we can see it is _not_ invariant, as
when we apply/remove filters we touch them.

This is why I made the comment (in a private conversation) about having
a invariant_total_period invariant_nr_entries pair (I think I used some
other naming) while knowing that the existing variables nr_entries and
total_period are actually subjected to the filters being used.

I.e. to avoid confusion we need to make total_entries and nr_entries
never change when a filter is applied, touching only two new variables
for non_filtered total_period and nr_entries.

I'll try doing it if you don't do it first, but will first process some
more patches and submit what I already processed.

- Arnaldo

> +	if (h->ms.unfolded) {
>  		hists->nr_entries += h->nr_rows;
> +		hists->nr_non_filtered_entries += h->nr_rows;
> +	}
>  	h->row_offset = 0;
>  	hists->stats.total_period += h->stat.period;
> +	hists->stats.total_non_filtered_period += h->stat.period;
>  	hists->stats.nr_events[PERF_RECORD_SAMPLE] += h->stat.nr_events;
> +	hists->stats.nr_non_filtered_samples += h->stat.nr_events;
>  
>  	hists__calc_col_len(hists, h);
>  }
> @@ -723,7 +728,9 @@ void hists__filter_by_dso(struct hists *hists)
>  	struct rb_node *nd;
>  
>  	hists->nr_entries = hists->stats.total_period = 0;
> +	hists->nr_non_filtered_entries = hists->stats.total_non_filtered_period = 0;
>  	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
> +	hists->stats.nr_non_filtered_samples = 0;
>  	hists__reset_col_len(hists);
>  
>  	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
> @@ -756,7 +763,9 @@ void hists__filter_by_thread(struct hists *hists)
>  	struct rb_node *nd;
>  
>  	hists->nr_entries = hists->stats.total_period = 0;
> +	hists->nr_non_filtered_entries = hists->stats.total_non_filtered_period = 0;
>  	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
> +	hists->stats.nr_non_filtered_samples = 0;
>  	hists__reset_col_len(hists);
>  
>  	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
> @@ -787,7 +796,9 @@ void hists__filter_by_symbol(struct hists *hists)
>  	struct rb_node *nd;
>  
>  	hists->nr_entries = hists->stats.total_period = 0;
> +	hists->nr_non_filtered_entries = hists->stats.total_non_filtered_period = 0;
>  	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
> +	hists->stats.nr_non_filtered_samples = 0;
>  	hists__reset_col_len(hists);
>  
>  	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> index a149f1adaae4..213551469f36 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/perf/util/hist.h
> @@ -41,6 +41,7 @@ struct events_stats {
>  	u64 total_lost;
>  	u64 total_invalid_chains;
>  	u32 nr_events[PERF_RECORD_HEADER_MAX];
> +	u32 nr_non_filtered_samples;
>  	u32 nr_lost_warned;
>  	u32 nr_unknown_events;
>  	u32 nr_invalid_chains;
> @@ -84,6 +85,7 @@ struct hists {
>  	struct rb_root		entries;
>  	struct rb_root		entries_collapsed;
>  	u64			nr_entries;
> +	u64			nr_non_filtered_entries;
>  	const struct thread	*thread_filter;
>  	const struct dso	*dso_filter;
>  	const char		*uid_filter_str;
> -- 
> 1.7.11.7

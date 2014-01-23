Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaAWNjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 08:39:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbaAWNjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 08:39:21 -0500
Date: Thu, 23 Jan 2014 14:38:48 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/5] perf tools: Count filtered entries to total period
 also
Message-ID: <20140123133847.GB1180@krava.brq.redhat.com>
References: <1390433333-15350-1-git-send-email-namhyung@kernel.org>
 <1390433333-15350-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390433333-15350-2-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 08:28:49AM +0900, Namhyung Kim wrote:
> Currently if a sample was filtered by command line option, it just
> dropped.  But this affects final output in that the percentage can be
> different since the filtered entries were not included to the total.
> 
> But user might want to see the original percentages when filter
> applied so change the behavior depends on a new symbol_conf.filter_
> relative value in order to be controlled by user later.

SNIP

> +		al->filtered |= (1 << HIST_FILTER__SYMBOL);
>  
> -out_filtered:
> -	al->filtered = true;
>  	return 0;
>  }
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index e4e6249b87d4..73b999448932 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -13,13 +13,6 @@ static bool hists__filter_entry_by_thread(struct hists *hists,
>  static bool hists__filter_entry_by_symbol(struct hists *hists,
>  					  struct hist_entry *he);
>  
> -enum hist_filter {
> -	HIST_FILTER__DSO,
> -	HIST_FILTER__THREAD,
> -	HIST_FILTER__PARENT,
> -	HIST_FILTER__SYMBOL,
> -};

it striked me that al.filtered is duplicating he.filtered, so I thought
we could leave just the one in hist_entry.. now I see annotate, diff
and others use al.filtered to skip hist_entry adding/processing

I think there's use for relative/total switch in other places,
and we could actually get rid of the al.filtered and make
the relative switch global (also in config?) .. in the future ;-)

> -
>  struct callchain_param	callchain_param = {
>  	.mode	= CHAIN_GRAPH_REL,
>  	.min_percent = 0.5,
> @@ -329,8 +322,9 @@ void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
>  	if (!h->filtered) {
>  		hists__calc_col_len(hists, h);
>  		++hists->nr_entries;
> -		hists->stats.total_period += h->stat.period;
>  	}
> +	if (!h->filtered || !symbol_conf.filter_relative)
> +		hists->stats.total_period += h->stat.period;

also we could keep both counts and easily switch on in tui/gui
.. in the future ;-)

jirka

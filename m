Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaCQUIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 16:08:40 -0400
Received: from mail-yk0-f178.google.com ([209.85.160.178]:58429 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaCQUIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 16:08:38 -0400
Date: Mon, 17 Mar 2014 17:08:32 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/9] perf tools: Count periods of filtered entries
 separately
Message-ID: <20140317200832.GE31482@ghostprotocols.net>
References: <1394437440-11609-1-git-send-email-namhyung@kernel.org>
 <1394437440-11609-3-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394437440-11609-3-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 10, 2014 at 04:43:53PM +0900, Namhyung Kim escreveu:
> @@ -749,9 +750,6 @@ int perf_event__preprocess_sample(const union perf_event *event,
>  	if (thread == NULL)
>  		return -1;
>  
> -	if (thread__is_filtered(thread))
> -		goto out_filtered;
> -

What was the intent of moving this test from here...

>  	dump_printf(" ... thread: %s:%d\n", thread__comm_str(thread), thread->tid);
>  	/*
>  	 * Have we already created the kernel maps for this machine?
> @@ -766,6 +764,10 @@ int perf_event__preprocess_sample(const union perf_event *event,
>  
>  	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
>  			      sample->ip, al);
> +
> +	if (thread__is_filtered(thread))
> +		al->filtered |= (1 << HIST_FILTER__THREAD);
> +

... to here? At first I thought it was because thread__is_filtered()
would check something that thread__find_addr_map() was doing, but no,
its invariant, we can do it here or at the original site, so I'm keeping
it there, ok?

- Arnaldo

>  	dump_printf(" ...... dso: %s\n",
>  		    al->map ? al->map->dso->long_name :
>  			al->level == 'H' ? "[hypervisor]" : "<not found>");
> @@ -781,7 +783,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
>  			       (dso->short_name != dso->long_name &&
>  				strlist__has_entry(symbol_conf.dso_list,
>  						   dso->long_name)))))
> -			goto out_filtered;
> +			al->filtered |= (1 << HIST_FILTER__DSO);
>  
>  		al->sym = map__find_symbol(al->map, al->addr,
>  					   machine->symbol_filter);
> @@ -790,11 +792,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
>  	if (symbol_conf.sym_list &&
>  		(!al->sym || !strlist__has_entry(symbol_conf.sym_list,
>  						al->sym->name)))
> -		goto out_filtered;
> -
> -	return 0;
> +		al->filtered |= (1 << HIST_FILTER__SYMBOL);
>  
> -out_filtered:
> -	al->filtered = true;
>  	return 0;
>  }
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 0466efa71140..aa13aa9826d9 100644
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
> -
>  struct callchain_param	callchain_param = {
>  	.mode	= CHAIN_GRAPH_REL,
>  	.min_percent = 0.5,
> @@ -330,6 +323,7 @@ void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
>  		hists__calc_col_len(hists, h);
>  		++hists->nr_entries;
>  		hists->stats.total_period += h->stat.period;
> +		hists->stats.total_non_filtered_period += h->stat.period;
>  	}
>  }
>  
> @@ -429,7 +423,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
>  			.weight = weight,
>  		},
>  		.parent = sym_parent,
> -		.filtered = symbol__parent_filter(sym_parent),
> +		.filtered = symbol__parent_filter(sym_parent) | al->filtered,
>  		.hists	= hists,
>  		.branch_info = bi,
>  		.mem_info = mi,
> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> index 0c76bf972736..a149f1adaae4 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/perf/util/hist.h
> @@ -14,6 +14,15 @@ struct hist_entry;
>  struct addr_location;
>  struct symbol;
>  
> +enum hist_filter {
> +	HIST_FILTER__DSO,
> +	HIST_FILTER__THREAD,
> +	HIST_FILTER__PARENT,
> +	HIST_FILTER__SYMBOL,
> +	HIST_FILTER__GUEST,
> +	HIST_FILTER__HOST,
> +};
> +
>  /*
>   * The kernel collects the number of events it couldn't send in a stretch and
>   * when possible sends this number in a PERF_RECORD_LOST event. The number of
> @@ -28,6 +37,7 @@ struct symbol;
>   */
>  struct events_stats {
>  	u64 total_period;
> +	u64 total_non_filtered_period;
>  	u64 total_lost;
>  	u64 total_invalid_chains;
>  	u32 nr_events[PERF_RECORD_HEADER_MAX];
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index 2553ae04b788..501e4e722e8e 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -186,7 +186,7 @@ struct addr_location {
>  	struct symbol *sym;
>  	u64	      addr;
>  	char	      level;
> -	bool	      filtered;
> +	u8	      filtered;
>  	u8	      cpumode;
>  	s32	      cpu;
>  };
> -- 
> 1.7.11.7

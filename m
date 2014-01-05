Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaAESCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 13:02:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbaAESCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 13:02:17 -0500
Date: Sun, 5 Jan 2014 19:01:54 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 18/21] perf top: Support callchain accumulation
Message-ID: <20140105180154.GM10018@krava.brq.redhat.com>
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
 <1387873347-28838-19-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387873347-28838-19-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 05:22:24PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Enable cumulation of callchain of children in perf top.
> 
> Cc: Arun Sharma <asharma@fb.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-top.c | 106 +++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 103 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 48c527a0f4c8..6a7a76496c94 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -657,6 +657,99 @@ static int symbol_filter(struct map *map __maybe_unused, struct symbol *sym)
>  	return 0;
>  }
>  
> +static int process_cumulative_entry(struct perf_top *top,
> +				    struct hist_entry *he,
> +				    struct perf_evsel *evsel,
> +				    struct addr_location *al,
> +				    struct perf_sample *sample,
> +				    struct symbol *parent)
> +{

hum, I wonder how hard would it be to export the iterator
stuff out of the report command and export it to be usable
from here as well.. to much code dusplicated below :-\

jirka

> +	struct hist_entry **he_cache;
> +	struct callchain_cursor_node *node;
> +	int idx = 0, err;
> +
> +	he_cache = malloc(sizeof(*he_cache) * (PERF_MAX_STACK_DEPTH + 1));
> +	if (he_cache == NULL)
> +		return -ENOMEM;
> +
> +	pthread_mutex_lock(&evsel->hists.lock);
> +
> +	he_cache[idx++] = he;
> +
> +	/*
> +	 * This is for putting parents upward during output resort iff
> +	 * only a child gets sampled.  See hist_entry__sort_on_period().
> +	 */
> +	he->callchain->max_depth = PERF_MAX_STACK_DEPTH + 1;
> +
> +	callchain_cursor_commit(&callchain_cursor);
> +
> +	node = callchain_cursor_current(&callchain_cursor);
> +	while (node) {
> +		int i;
> +		struct hist_entry he_tmp = {
> +			.cpu = al->cpu,
> +			.thread = al->thread,
> +			.comm = thread__comm(al->thread),
> +			.parent = parent,
> +		};
> +
> +		fill_callchain_info(al, node, false);
> +
> +		he_tmp.ip = al->addr;
> +		he_tmp.ms.map = al->map;
> +		he_tmp.ms.sym = al->sym;
> +
> +		if (al->sym && al->sym->ignore)
> +			goto next;
> +
> +		/*
> +		 * Check if there's duplicate entries in the callchain.
> +		 * It's possible that it has cycles or recursive calls.
> +		 */
> +		for (i = 0; i < idx; i++) {
> +			if (hist_entry__cmp(he_cache[i], &he_tmp) == 0)
> +				goto next;
> +		}
> +
> +		he = __hists__add_entry(&evsel->hists, al, parent, NULL, NULL,
> +					sample->period, sample->weight,
> +					sample->transaction, false);
> +		if (he == NULL) {
> +			err = -ENOMEM;
> +			break;;
> +		}
> +
> +		he_cache[idx++] = he;
> +
> +		/*
> +		 * This is for putting parents upward during output resort iff
> +		 * only a child gets sampled.  See hist_entry__sort_on_period().
> +		 */
> +		he->callchain->max_depth = callchain_cursor.nr - callchain_cursor.pos;
> +
> +		if (sort__has_sym) {
> +			u64 ip;
> +
> +			if (al->map)
> +				ip = al->map->unmap_ip(al->map, al->addr);
> +			else
> +				ip = al->addr;
> +
> +			perf_top__record_precise_ip(top, he, evsel->idx, ip);
> +		}
> +
> +next:
> +		callchain_cursor_advance(&callchain_cursor);
> +		node = callchain_cursor_current(&callchain_cursor);
> +	}
> +
> +	pthread_mutex_unlock(&evsel->hists.lock);
> +
> +	free(he_cache);
> +	return err;
> +}
> +
>  static void perf_event__process_sample(struct perf_tool *tool,
>  				       const union perf_event *event,
>  				       struct perf_evsel *evsel,
> @@ -754,9 +847,16 @@ static void perf_event__process_sample(struct perf_tool *tool,
>  			return;
>  		}
>  
> -		err = hist_entry__append_callchain(he, sample);
> -		if (err)
> -			return;
> +		if (symbol_conf.cumulate_callchain) {
> +			err = process_cumulative_entry(top, he, evsel, &al,
> +						       sample, parent);
> +			if (err)
> +				return;
> +		} else {
> +			err = hist_entry__append_callchain(he, sample);
> +			if (err)
> +				return;
> +		}
>  
>  		if (sort__has_sym)
>  			perf_top__record_precise_ip(top, he, evsel->idx, ip);
> -- 
> 1.7.11.7
> 

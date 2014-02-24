Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaBXMrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 07:47:01 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:41092 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaBXMrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 07:47:00 -0500
Date: Mon, 24 Feb 2014 09:46:53 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH 1/4] perf tools: Check availability of annotate when
 processing samples
Message-ID: <20140224124653.GB5982@ghostprotocols.net>
References: <1392859976-32760-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392859976-32760-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 20, 2014 at 10:32:53AM +0900, Namhyung Kim escreveu:
> The TUI of perf report and top support annotation, but stdio and GTK
> don't.  So it should be checked before calling hist_entry__inc_addr_
> samples() since perf annotate need it regardless of UI and sort keys.
> 
> It caused perf annotate on ppc64 to produce zero output.

I renamed {top,report}_needs_annotate to ui__has_annotation() and will
make this patch apply on perf/urgent, as it is a bug fix.

While looking at it I noticed several things that can be improved in
this area, like we don't need to map the ip in top if we're not going to
use it, etc. But will leave those to a follow on patch.

Thanks,

- Arnaldo
 
> Reported-by: Anton Blanchard <anton@samba.org>
> Cc: Anton Blanchard <anton@samba.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-report.c | 45 +++++++++++++++++++++++++++++----------------
>  tools/perf/builtin-top.c    | 11 +++++++++--
>  tools/perf/util/annotate.c  |  2 +-
>  3 files changed, 39 insertions(+), 19 deletions(-)
> 
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index d882b6f96411..bab762bdeb0d 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -75,6 +75,11 @@ static int report__config(const char *var, const char *value, void *cb)
>  	return perf_default_config(var, value, cb);
>  }
>  
> +static bool report_needs_annotate(void)
> +{
> +	return use_browser == 1 && sort__has_sym;
> +}
> +
>  static int report__add_mem_hist_entry(struct report *rep, struct addr_location *al,
>  				      struct perf_sample *sample, struct perf_evsel *evsel)
>  {
> @@ -110,14 +115,16 @@ static int report__add_mem_hist_entry(struct report *rep, struct addr_location *
>  	if (!he)
>  		return -ENOMEM;
>  
> -	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
> -	if (err)
> -		goto out;
> +	if (report_needs_annotate()) {
> +		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
> +		if (err)
> +			goto out;
>  
> -	mx = he->mem_info;
> -	err = addr_map_symbol__inc_samples(&mx->daddr, evsel->idx);
> -	if (err)
> -		goto out;
> +		mx = he->mem_info;
> +		err = addr_map_symbol__inc_samples(&mx->daddr, evsel->idx);
> +		if (err)
> +			goto out;
> +	}
>  
>  	evsel->hists.stats.total_period += cost;
>  	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
> @@ -159,14 +166,18 @@ static int report__add_branch_hist_entry(struct report *rep, struct addr_locatio
>  		he = __hists__add_entry(&evsel->hists, al, parent, &bi[i], NULL,
>  					1, 1, 0);
>  		if (he) {
> -			bx = he->branch_info;
> -			err = addr_map_symbol__inc_samples(&bx->from, evsel->idx);
> -			if (err)
> -				goto out;
> -
> -			err = addr_map_symbol__inc_samples(&bx->to, evsel->idx);
> -			if (err)
> -				goto out;
> +			if (report_needs_annotate()) {
> +				bx = he->branch_info;
> +				err = addr_map_symbol__inc_samples(&bx->from,
> +								   evsel->idx);
> +				if (err)
> +					goto out;
> +
> +				err = addr_map_symbol__inc_samples(&bx->to,
> +								   evsel->idx);
> +				if (err)
> +					goto out;
> +			}
>  
>  			evsel->hists.stats.total_period += 1;
>  			hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
> @@ -199,7 +210,9 @@ static int report__add_hist_entry(struct report *rep, struct perf_evsel *evsel,
>  	if (err)
>  		goto out;
>  
> -	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
> +	if (report_needs_annotate())
> +		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
> +
>  	evsel->hists.stats.total_period += sample->period;
>  	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
>  out:
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index ed99ec4a309f..a19c3afcfa0e 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -87,6 +87,11 @@ static void perf_top__sig_winch(int sig __maybe_unused,
>  	perf_top__update_print_entries(top);
>  }
>  
> +static bool top_needs_annotate(void)
> +{
> +	return use_browser == 1 && sort__has_sym;
> +}
> +
>  static int perf_top__parse_source(struct perf_top *top, struct hist_entry *he)
>  {
>  	struct symbol *sym;
> @@ -176,7 +181,7 @@ static void perf_top__record_precise_ip(struct perf_top *top,
>  {
>  	struct annotation *notes;
>  	struct symbol *sym;
> -	int err;
> +	int err = 0;
>  
>  	if (he == NULL || he->ms.sym == NULL ||
>  	    ((top->sym_filter_entry == NULL ||
> @@ -190,7 +195,9 @@ static void perf_top__record_precise_ip(struct perf_top *top,
>  		return;
>  
>  	ip = he->ms.map->map_ip(he->ms.map, ip);
> -	err = hist_entry__inc_addr_samples(he, counter, ip);
> +
> +	if (top_needs_annotate())
> +		err = hist_entry__inc_addr_samples(he, counter, ip);
>  
>  	pthread_mutex_unlock(&notes->lock);
>  
> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
> index 469eb679fb9d..6fcada625c86 100644
> --- a/tools/perf/util/annotate.c
> +++ b/tools/perf/util/annotate.c
> @@ -489,7 +489,7 @@ static int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
>  {
>  	struct annotation *notes;
>  
> -	if (sym == NULL || use_browser != 1 || !sort__has_sym)
> +	if (sym == NULL)
>  		return 0;
>  
>  	notes = symbol__annotation(sym);
> -- 
> 1.7.11.7

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaHMU2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 16:28:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:51027 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbaHMU2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 16:28:01 -0400
Date: Wed, 13 Aug 2014 17:27:56 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [RFC/PATCH 1/2] perf top: Fix -z option behavior
Message-ID: <20140813202756.GK2718@kernel.org>
References: <1407831366-28892-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407831366-28892-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 12, 2014 at 05:16:05PM +0900, Namhyung Kim escreveu:
> The current -z option does almost nothing.  It doesn't zero the
> existing samples so that we can see profiles of exited process after
> last refresh.  It seems it only affects annotation.
> 
> This patch clears existing entries before processing if -z option is
> given.  For this original decaying logic also moved before processing.

So, this is two things bolted into one, i.e. it is not stated here why
decaying needs to be done before resorting. I bet its because since
we're zeroing everything, no need to decay anything, right?

Stating more clearly what is the intent and the reason for changes helps
reviewing.

Anyway, will add a note about that and apply the change.

Also, the delete entries thing could zero total stats in struct hists,
which is not a problem currently, because, IIRC, the collapse/resort
logic will do that when it rotates the hists, but if we ever want to
just delete events and then add a bunch of events without resorting, we
will end up with bogus stats that will have the sum of the old events
stats with the new ones.

Thanks!

- Arnaldo
 
> Reported-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-top.c | 23 +++++++++++++++++------
>  tools/perf/util/hist.c   | 22 ++++++++++++++++++++++
>  tools/perf/util/hist.h   |  1 +
>  3 files changed, 40 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 4fb6f726271c..e486501b2067 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -276,11 +276,17 @@ static void perf_top__print_sym_table(struct perf_top *top)
>  		return;
>  	}
>  
> +	if (top->zero) {
> +		hists__delete_entries(&top->sym_evsel->hists);
> +	} else {
> +		hists__decay_entries(&top->sym_evsel->hists,
> +				     top->hide_user_symbols,
> +				     top->hide_kernel_symbols);
> +	}
> +
>  	hists__collapse_resort(&top->sym_evsel->hists, NULL);
>  	hists__output_resort(&top->sym_evsel->hists);
> -	hists__decay_entries(&top->sym_evsel->hists,
> -			     top->hide_user_symbols,
> -			     top->hide_kernel_symbols);
> +
>  	hists__output_recalc_col_len(&top->sym_evsel->hists,
>  				     top->print_entries - printed);
>  	putchar('\n');
> @@ -542,11 +548,16 @@ static void perf_top__sort_new_samples(void *arg)
>  	if (t->evlist->selected != NULL)
>  		t->sym_evsel = t->evlist->selected;
>  
> +	if (t->zero) {
> +		hists__delete_entries(&t->sym_evsel->hists);
> +	} else {
> +		hists__decay_entries(&t->sym_evsel->hists,
> +				     t->hide_user_symbols,
> +				     t->hide_kernel_symbols);
> +	}
> +
>  	hists__collapse_resort(&t->sym_evsel->hists, NULL);
>  	hists__output_resort(&t->sym_evsel->hists);
> -	hists__decay_entries(&t->sym_evsel->hists,
> -			     t->hide_user_symbols,
> -			     t->hide_kernel_symbols);
>  }
>  
>  static void *display_thread_tui(void *arg)
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 30df6187ee02..86569fa3651d 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -277,6 +277,28 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
>  	}
>  }
>  
> +void hists__delete_entries(struct hists *hists)
> +{
> +	struct rb_node *next = rb_first(&hists->entries);
> +	struct hist_entry *n;
> +
> +	while (next) {
> +		n = rb_entry(next, struct hist_entry, rb_node);
> +		next = rb_next(&n->rb_node);
> +
> +		rb_erase(&n->rb_node, &hists->entries);
> +
> +		if (sort__need_collapse)
> +			rb_erase(&n->rb_node_in, &hists->entries_collapsed);
> +
> +		--hists->nr_entries;
> +		if (!n->filtered)
> +			--hists->nr_non_filtered_entries;
> +
> +		hist_entry__free(n);
> +	}
> +}
> +
>  /*
>   * histogram, sorted on item, collects periods
>   */
> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> index 95405a8fbd95..8c9c70e18cbb 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/perf/util/hist.h
> @@ -152,6 +152,7 @@ void hists__output_resort(struct hists *hists);
>  void hists__collapse_resort(struct hists *hists, struct ui_progress *prog);
>  
>  void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
> +void hists__delete_entries(struct hists *hists);
>  void hists__output_recalc_col_len(struct hists *hists, int max_rows);
>  
>  u64 hists__total_period(struct hists *hists);
> -- 
> 2.0.0

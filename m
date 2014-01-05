Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbaAERkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 12:40:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbaAERkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 12:40:51 -0500
Date: Sun, 5 Jan 2014 18:40:33 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 12/21] perf tools: Apply percent-limit to cumulative
 percentage
Message-ID: <20140105174033.GK10018@krava.brq.redhat.com>
References: <1387873347-28838-1-git-send-email-namhyung@kernel.org>
 <1387873347-28838-13-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387873347-28838-13-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 05:22:18PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> If -g cumulative option is given, it needs to show entries which don't
> have self overhead.  So apply percent-limit to accumulated overhead
> percentage in this case.
> 
> Cc: Arun Sharma <asharma@fb.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/ui/browsers/hists.c | 34 ++++++++++++++++++++++++++--------
>  tools/perf/ui/gtk/hists.c      | 11 +++++++++--
>  tools/perf/ui/stdio/hist.c     | 11 +++++++++--
>  3 files changed, 44 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
> index efa78894f70d..b02e71ecc5fe 100644
> --- a/tools/perf/ui/browsers/hists.c
> +++ b/tools/perf/ui/browsers/hists.c
> @@ -828,12 +828,19 @@ static unsigned int hist_browser__refresh(struct ui_browser *browser)
>  
>  	for (nd = browser->top; nd; nd = rb_next(nd)) {
>  		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
> -		float percent = h->stat.period * 100.0 /
> -					hb->hists->stats.total_period;
> +		float percent;
>  
>  		if (h->filtered)
>  			continue;
>  
> +		if (symbol_conf.cumulate_callchain) {
> +			percent = h->stat_acc->period * 100.0 /
> +					hb->hists->stats.total_period;
> +		} else {
> +			percent = h->stat.period * 100.0 /
> +					hb->hists->stats.total_period;
> +		}

seems like above code (7 lines) should go to function

jirka

> +
>  		if (percent < hb->min_pcnt)
>  			continue;
>  
> @@ -851,13 +858,17 @@ static struct rb_node *hists__filter_entries(struct rb_node *nd,
>  {
>  	while (nd != NULL) {
>  		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
> -		float percent = h->stat.period * 100.0 /
> -					hists->stats.total_period;
> +		float percent;
>  
> -		if (percent < min_pcnt)
> -			return NULL;
> +		if (symbol_conf.cumulate_callchain) {
> +			percent = h->stat_acc->period * 100.0 /
> +					hists->stats.total_period;
> +		} else {
> +			percent = h->stat.period * 100.0 /
> +					hists->stats.total_period;
> +		}
>  
> -		if (!h->filtered)
> +		if (!h->filtered && percent >= min_pcnt)
>  			return nd;
>  
>  		nd = rb_next(nd);
> @@ -872,8 +883,15 @@ static struct rb_node *hists__filter_prev_entries(struct rb_node *nd,
>  {
>  	while (nd != NULL) {
>  		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
> -		float percent = h->stat.period * 100.0 /
> +		float percent;
> +
> +		if (symbol_conf.cumulate_callchain) {
> +			percent = h->stat_acc->period * 100.0 /
> +					hists->stats.total_period;
> +		} else {
> +			percent = h->stat.period * 100.0 /
>  					hists->stats.total_period;
> +		}
>  
>  		if (!h->filtered && percent >= min_pcnt)
>  			return nd;
> diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
> index 70ed0d5e1b94..06ae3342e14f 100644
> --- a/tools/perf/ui/gtk/hists.c
> +++ b/tools/perf/ui/gtk/hists.c
> @@ -296,12 +296,19 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
>  	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
>  		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
>  		GtkTreeIter iter;
> -		float percent = h->stat.period * 100.0 /
> -					hists->stats.total_period;
> +		float percent;
>  
>  		if (h->filtered)
>  			continue;
>  
> +		if (symbol_conf.cumulate_callchain) {
> +			percent = h->stat_acc->period * 100.0 /
> +					hists->stats.total_period;
> +		} else {
> +			percent = h->stat.period * 100.0 /
> +					hists->stats.total_period;
> +		}
> +
>  		if (percent < min_pcnt)
>  			continue;
>  
> diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
> index 4c4986e809d8..7ea8502192b0 100644
> --- a/tools/perf/ui/stdio/hist.c
> +++ b/tools/perf/ui/stdio/hist.c
> @@ -487,12 +487,19 @@ print_entries:
>  
>  	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
>  		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
> -		float percent = h->stat.period * 100.0 /
> -					hists->stats.total_period;
> +		float percent;
>  
>  		if (h->filtered)
>  			continue;
>  
> +		if (symbol_conf.cumulate_callchain) {
> +			percent = h->stat_acc->period * 100.0 /
> +					hists->stats.total_period;
> +		} else {
> +			percent = h->stat.period * 100.0 /
> +					hists->stats.total_period;
> +		}
> +
>  		if (percent < min_pcnt)
>  			continue;
>  
> -- 
> 1.7.11.7
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574AbaDVRjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:39:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927AbaDVRji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:39:38 -0400
Date: Tue, 22 Apr 2014 19:39:12 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 9/9] perf hists/tui: Count callchain rows separately
Message-ID: <20140422173912.GA16924@krava.brq.redhat.com>
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
 <1398156591-11001-10-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398156591-11001-10-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 05:49:51PM +0900, Namhyung Kim wrote:
> When TUI hist browser expands/collapses callchains it accounted number
> of callchain nodes into total entries to show.  However this code
> ignores filtering so that it can make the cursor go to out of screen.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/ui/browsers/hists.c | 38 ++++++++++++++++++++++++++++----------
>  1 file changed, 28 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
> index 886eee0062e0..215f10429dda 100644
> --- a/tools/perf/ui/browsers/hists.c
> +++ b/tools/perf/ui/browsers/hists.c
> @@ -27,6 +27,7 @@ struct hist_browser {
>  	bool		     show_dso;
>  	float		     min_pcnt;
>  	u64		     nr_non_filtered_entries;
> +	u64		     nr_callchain_rows;
>  };
>  
>  extern void hist_browser__init_hpp(void);
> @@ -35,6 +36,10 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
>  				const char *ev_name);
>  static void hist_browser__update_nr_entries(struct hist_browser *hb);
>  
> +static struct rb_node *hists__filter_entries(struct rb_node *nd,
> +					     struct hists *hists,
> +					     float min_pcnt);
> +
>  static bool hist_browser__has_filter(struct hist_browser *hb)
>  {
>  	return hists__has_filter(hb->hists) || hb->min_pcnt;
> @@ -51,6 +56,7 @@ static void hist_browser__reset(struct hist_browser *browser)
>  {
>  	hist_browser__update_nr_entries(browser);
>  	browser->b.nr_entries = browser->nr_non_filtered_entries;
> +	browser->b.nr_entries += browser->nr_callchain_rows;
>  	hist_browser__refresh_dimensions(browser);
>  	ui_browser__reset_index(&browser->b);
>  }
> @@ -205,14 +211,16 @@ static bool hist_browser__toggle_fold(struct hist_browser *browser)
>  		struct hist_entry *he = browser->he_selection;
>  
>  		hist_entry__init_have_children(he);
> -		browser->hists->nr_entries -= he->nr_rows;
> +		browser->b.nr_entries -= he->nr_rows;

does browser->b.nr_entries need to be updated in here?

it gets set in hist_browser__reset and hist_browser__run

> +		browser->nr_callchain_rows -= he->nr_rows;
>  
>  		if (he->ms.unfolded)
>  			he->nr_rows = callchain__count_rows(&he->sorted_chain);
>  		else
>  			he->nr_rows = 0;
> -		browser->hists->nr_entries += he->nr_rows;
> -		browser->b.nr_entries = browser->hists->nr_entries;
> +
> +		browser->b.nr_entries += he->nr_rows;

ditto

> +		browser->nr_callchain_rows += he->nr_rows;
>  
>  		return true;
>  	}
> @@ -287,23 +295,31 @@ static void hist_entry__set_folding(struct hist_entry *he, bool unfold)
>  		he->nr_rows = 0;
>  }
>  
> -static void hists__set_folding(struct hists *hists, bool unfold)
> +static void
> +__hist_browser__set_folding(struct hist_browser *browser, bool unfold)
>  {
>  	struct rb_node *nd;
> +	struct hists *hists = browser->hists;
>  
> -	hists->nr_entries = 0;
> -
> -	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
> +	for (nd = rb_first(&hists->entries);
> +	     (nd = hists__filter_entries(nd, hists, browser->min_pcnt)) != NULL;
> +	     nd = rb_next(nd)) {
>  		struct hist_entry *he = rb_entry(nd, struct hist_entry, rb_node);
>  		hist_entry__set_folding(he, unfold);
> -		hists->nr_entries += 1 + he->nr_rows;
> +		browser->nr_callchain_rows += he->nr_rows;
>  	}
>  }
>  
>  static void hist_browser__set_folding(struct hist_browser *browser, bool unfold)
>  {
> -	hists__set_folding(browser->hists, unfold);
> -	browser->b.nr_entries = browser->hists->nr_entries;
> +	browser->nr_callchain_rows = 0;
> +	__hist_browser__set_folding(browser, unfold);
> +
> +	if (hist_browser__has_filter(browser))
> +		browser->b.nr_entries = browser->nr_non_filtered_entries;
> +	else
> +		browser->b.nr_entries = browser->hists->nr_entries;
> +	browser->b.nr_entries += browser->nr_callchain_rows;

ditto,

I think whole condition above could go away, it's the same as in the
hist_browser__run, which is going to be executed after this anyway..

just setup browser->nr_callchain_rows


thanks,
jirka

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab3AOSce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:32:34 -0500
Received: from mail-ye0-f177.google.com ([209.85.213.177]:33333 "EHLO
	mail-ye0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118Ab3AOScd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:32:33 -0500
Date: Tue, 15 Jan 2013 15:32:26 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 07/13] perf hist browser: Add support for event group view
Message-ID: <20130115183226.GC5826@ghostprotocols.net>
References: <1358235117-12803-1-git-send-email-namhyung@kernel.org>
 <1358235117-12803-8-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358235117-12803-8-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 15, 2013 at 04:31:51PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Show group members' overhead also when showing the leader's if event
> group is enabled.  Use macro for defining hpp functions which looks
> almost identical.
> 
> Also move coloring logic into the hpp function so that each value can
> be colored independently.

Just from reading the description: when we have this "Also do this extra
thing" it smells like we need to break the patch in two... Can this be
done?

- Arnaldo
 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/ui/browsers/hists.c | 153 ++++++++++++++++++++++++++++++++---------
>  tools/perf/ui/hist.c           |   5 +-
>  2 files changed, 126 insertions(+), 32 deletions(-)
> 
> diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
> index 57b82c26cd05..65e6c005f8e9 100644
> --- a/tools/perf/ui/browsers/hists.c
> +++ b/tools/perf/ui/browsers/hists.c
> @@ -567,23 +567,126 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
>  	return row - first_row;
>  }
>  
> -#define HPP__COLOR_FN(_name, _field)					\
> -static int hist_browser__hpp_color_ ## _name(struct perf_hpp *hpp,	\
> -					     struct hist_entry *he)	\
> +struct hpp_arg {
> +	struct ui_browser *b;
> +	char folded_sign;
> +	bool current_entry;
> +};
> +
> +static int hist_browser__hpp_color_callchain(struct hpp_arg *arg)
> +{
> +	if (!symbol_conf.use_callchain)
> +		return 0;
> +
> +	slsmg_printf("%c ", arg->folded_sign);
> +	return 2;
> +}
> +
> +static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
> +			    u64 (*get_field)(struct hist_entry *),
> +			    int (*callchain_cb)(struct hpp_arg *))
> +{
> +	int ret = 0;
> +	double percent = 0.0;
> +	struct hists *hists = he->hists;
> +	struct hpp_arg *arg = hpp->ptr;
> +
> +	if (hists->stats.total_period)
> +		percent = 100.0 * get_field(he) / hists->stats.total_period;
> +
> +	ui_browser__set_percent_color(arg->b, percent, arg->current_entry);
> +
> +	if (callchain_cb)
> +		ret += callchain_cb(arg);
> +
> +	ret += scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);
> +	slsmg_printf("%s", hpp->buf);
> +
> +	if (symbol_conf.event_group) {
> +		int prev_idx, idx_delta, i;
> +		struct perf_evsel *evsel = hists_to_evsel(hists);
> +		struct hist_entry *pair;
> +		int nr_members = evsel->nr_members;
> +
> +		if (nr_members <= 1)
> +			goto out;
> +
> +		prev_idx = perf_evsel__group_idx(evsel);
> +
> +		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
> +			u64 period = get_field(pair);
> +			u64 total = pair->hists->stats.total_period;
> +
> +			if (!total)
> +				continue;
> +
> +			evsel = hists_to_evsel(pair->hists);
> +			idx_delta = perf_evsel__group_idx(evsel) - prev_idx - 1;
> +
> +			for (i = 0; i < idx_delta; i++) {
> +				ui_browser__set_percent_color(arg->b, 0.0,
> +							arg->current_entry);
> +				ret += scnprintf(hpp->buf, hpp->size,
> +						 " %6.2f%%", 0.0);
> +				slsmg_printf("%s", hpp->buf);
> +			}
> +
> +			percent = 100.0 * period / total;
> +			ui_browser__set_percent_color(arg->b, percent,
> +						      arg->current_entry);
> +			ret += scnprintf(hpp->buf, hpp->size,
> +					 " %6.2f%%", percent);
> +			slsmg_printf("%s", hpp->buf);
> +
> +			prev_idx += 1 + idx_delta;
> +		}
> +
> +		idx_delta = nr_members - prev_idx - 1;
> +
> +		for (i = 0; i < idx_delta; i++) {
> +			ui_browser__set_percent_color(arg->b, 0.0,
> +						      arg->current_entry);
> +			ret += scnprintf(hpp->buf, hpp->size, " %6.2f%%", 0.0);
> +			slsmg_printf("%s", hpp->buf);
> +		}
> +	}
> +out:
> +	if (!arg->current_entry || !arg->b->navkeypressed)
> +		ui_browser__set_color(arg->b, HE_COLORSET_NORMAL);
> +
> +	return ret;
> +}
> +
> +static u64 __hpp_get_period(struct hist_entry *he)
> +{
> +	return he->stat.period;
> +}
> +
> +static int hist_browser__hpp_color_overhead(struct perf_hpp *hpp,
> +					    struct hist_entry *he)
> +{
> +	return __hpp__color_fmt(hpp, he, __hpp_get_period,
> +				hist_browser__hpp_color_callchain);
> +}
> +
> +#define __HPP_COLOR_PERCENT_FN(_type, _field)				\
> +static u64 __hpp_get_##_field(struct hist_entry *he)			\
> +{									\
> +	return he->stat._field;						\
> +}									\
> +									\
> +static int hist_browser__hpp_color_##_type(struct perf_hpp *hpp,	\
> +					   struct hist_entry *he)	\
>  {									\
> -	struct hists *hists = he->hists;				\
> -	double percent = 100.0 * he->stat._field / hists->stats.total_period; \
> -	*(double *)hpp->ptr = percent;					\
> -	return scnprintf(hpp->buf, hpp->size, "%6.2f%%", percent);	\
> +	return __hpp__color_fmt(hpp, he, __hpp_get_##_field, NULL);	\
>  }
>  
> -HPP__COLOR_FN(overhead, period)
> -HPP__COLOR_FN(overhead_sys, period_sys)
> -HPP__COLOR_FN(overhead_us, period_us)
> -HPP__COLOR_FN(overhead_guest_sys, period_guest_sys)
> -HPP__COLOR_FN(overhead_guest_us, period_guest_us)
> +__HPP_COLOR_PERCENT_FN(overhead_sys, period_sys)
> +__HPP_COLOR_PERCENT_FN(overhead_us, period_us)
> +__HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys)
> +__HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us)
>  
> -#undef HPP__COLOR_FN
> +#undef __HPP_COLOR_PERCENT_FN
>  
>  void hist_browser__init_hpp(void)
>  {
> @@ -608,7 +711,6 @@ static int hist_browser__show_entry(struct hist_browser *browser,
>  				    unsigned short row)
>  {
>  	char s[256];
> -	double percent;
>  	int printed = 0;
>  	int width = browser->b.width;
>  	char folded_sign = ' ';
> @@ -628,11 +730,16 @@ static int hist_browser__show_entry(struct hist_browser *browser,
>  	}
>  
>  	if (row_offset == 0) {
> +		struct hpp_arg arg = {
> +			.b		= &browser->b,
> +			.folded_sign	= folded_sign,
> +			.current_entry	= current_entry,
> +		};
>  		struct perf_hpp hpp = {
>  			.buf		= s,
>  			.size		= sizeof(s),
> +			.ptr		= &arg,
>  		};
> -		int i = 0;
>  
>  		ui_browser__gotorc(&browser->b, row, 0);
>  
> @@ -645,27 +752,11 @@ static int hist_browser__show_entry(struct hist_browser *browser,
>  			first = false;
>  
>  			if (fmt->color) {
> -				hpp.ptr = &percent;
> -				/* It will set percent for us. See HPP__COLOR_FN above. */
>  				width -= fmt->color(&hpp, entry);
> -
> -				ui_browser__set_percent_color(&browser->b, percent, current_entry);
> -
> -				if (!i && symbol_conf.use_callchain) {
> -					slsmg_printf("%c ", folded_sign);
> -					width -= 2;
> -				}
> -
> -				slsmg_printf("%s", s);
> -
> -				if (!current_entry || !browser->b.navkeypressed)
> -					ui_browser__set_color(&browser->b, HE_COLORSET_NORMAL);
>  			} else {
>  				width -= fmt->entry(&hpp, entry);
>  				slsmg_printf("%s", s);
>  			}
> -
> -			i++;
>  		}
>  
>  		/* The scroll bar isn't being used */
> diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
> index ec14335a9713..be9152cd4c76 100644
> --- a/tools/perf/ui/hist.c
> +++ b/tools/perf/ui/hist.c
> @@ -521,12 +521,15 @@ unsigned int hists__sort_list_width(struct hists *hists)
>  	struct perf_hpp_fmt *fmt;
>  	struct sort_entry *se;
>  	int i = 0, ret = 0;
> +	struct perf_hpp dummy_hpp = {
> +		.ptr	= hists_to_evsel(hists),
> +	};
>  
>  	perf_hpp__for_each_format(fmt) {
>  		if (i)
>  			ret += 2;
>  
> -		ret += fmt->width(NULL);
> +		ret += fmt->width(&dummy_hpp);
>  	}
>  
>  	list_for_each_entry(se, &hist_entry__sort_list, list)
> -- 
> 1.7.11.7

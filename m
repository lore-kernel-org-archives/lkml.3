Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab3AOSeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:34:15 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:58017 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab3AOSeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:34:13 -0500
Date: Tue, 15 Jan 2013 15:34:05 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 08/13] perf gtk/browser: Add support for event group view
Message-ID: <20130115183405.GD5826@ghostprotocols.net>
References: <1358235117-12803-1-git-send-email-namhyung@kernel.org>
 <1358235117-12803-9-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358235117-12803-9-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 15, 2013 at 04:31:52PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Show group members' overhead also when showing the leader's if event
> group is enabled.  Use macro for defining hpp functions which looks
> almost identical.
> 
> Unlike other hpp backend, GTK+ needs to print dummy 0.00% output since
> it's displayed with variable width fonts.  So that simply skipping
> with %*s trick won't work well here.

I'm illiterate on GTK+ internals, but I kinda expected that it could
provide a way to avoid such things, i.e. a way to position the cursor
in such circumstance without having to actually print the '0.00%' :-\

- Arnaldo
 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/ui/gtk/hists.c | 114 +++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 92 insertions(+), 22 deletions(-)
> 
> diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
> index c03da79d524f..a4d951ea919a 100644
> --- a/tools/perf/ui/gtk/hists.c
> +++ b/tools/perf/ui/gtk/hists.c
> @@ -8,32 +8,102 @@
>  
>  #define MAX_COLUMNS			32
>  
> -#define HPP__COLOR_FN(_name, _field)						\
> -static int perf_gtk__hpp_color_ ## _name(struct perf_hpp *hpp,			\
> -					 struct hist_entry *he)			\
> +static int perf_gtk__percent_color_snprintf(char *buf, size_t size,
> +					    double percent)
> +{
> +	int ret = 0;
> +	const char *markup;
> +
> +	markup = perf_gtk__get_percent_color(percent);
> +	if (markup)
> +		ret += scnprintf(buf, size, markup);
> +
> +	ret += scnprintf(buf + ret, size - ret, "%6.2f%%", percent);
> +
> +	if (markup)
> +		ret += scnprintf(buf + ret, size - ret, "</span>");
> +
> +	return ret;
> +}
> +
> +
> +static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
> +			    u64 (*get_field)(struct hist_entry *))
> +{
> +	int ret;
> +	double percent = 0.0;
> +	struct hists *hists = he->hists;
> +
> +	if (hists->stats.total_period)
> +		percent = 100.0 * get_field(he) / hists->stats.total_period;
> +
> +	ret = perf_gtk__percent_color_snprintf(hpp->buf, hpp->size, percent);
> +
> +	if (symbol_conf.event_group) {
> +		int prev_idx, idx_delta;
> +		struct perf_evsel *evsel = hists_to_evsel(hists);
> +		struct hist_entry *pair;
> +		int nr_members = evsel->nr_members;
> +
> +		if (nr_members <= 1)
> +			return ret;
> +
> +		prev_idx = perf_evsel__group_idx(evsel);
> +
> +		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
> +			u64 period = get_field(pair);
> +			u64 total = pair->hists->stats.total_period;
> +
> +			evsel = hists_to_evsel(pair->hists);
> +			idx_delta = perf_evsel__group_idx(evsel) - prev_idx - 1;
> +
> +			while (idx_delta--) {
> +				ret += scnprintf(hpp->buf + ret, hpp->size -ret, " ");
> +				ret += perf_gtk__percent_color_snprintf(hpp->buf + ret,
> +									hpp->size - ret,
> +									0.0);
> +			}
> +
> +			percent = 100.0 * period / total;
> +			ret += scnprintf(hpp->buf + ret, hpp->size -ret, " ");
> +			ret += perf_gtk__percent_color_snprintf(hpp->buf + ret,
> +								hpp->size - ret,
> +								percent);
> +
> +			prev_idx = perf_evsel__group_idx(evsel);
> +		}
> +
> +		idx_delta = nr_members - prev_idx - 1;
> +
> +		while (idx_delta--) {
> +			ret += scnprintf(hpp->buf + ret, hpp->size -ret, " ");
> +			ret += perf_gtk__percent_color_snprintf(hpp->buf + ret,
> +								hpp->size - ret,
> +								0.0);
> +		}
> +	}
> +	return ret;
> +}
> +
> +#define __HPP_COLOR_PERCENT_FN(_type, _field)					\
> +static u64 he_get_##_field(struct hist_entry *he)				\
>  {										\
> -	struct hists *hists = he->hists;					\
> -	double percent = 100.0 * he->stat._field / hists->stats.total_period;	\
> -	const char *markup;							\
> -	int ret = 0;								\
> +	return he->stat._field;							\
> +}										\
>  										\
> -	markup = perf_gtk__get_percent_color(percent);				\
> -	if (markup)								\
> -		ret += scnprintf(hpp->buf, hpp->size, "%s", markup);		\
> -	ret += scnprintf(hpp->buf + ret, hpp->size - ret, "%6.2f%%", percent); 	\
> -	if (markup)								\
> -		ret += scnprintf(hpp->buf + ret, hpp->size - ret, "</span>"); 	\
> -										\
> -	return ret;								\
> +static int perf_gtk__hpp_color_##_type(struct perf_hpp *hpp,			\
> +				       struct hist_entry *he)			\
> +{										\
> +	return __hpp__color_fmt(hpp, he, he_get_##_field);			\
>  }
>  
> -HPP__COLOR_FN(overhead, period)
> -HPP__COLOR_FN(overhead_sys, period_sys)
> -HPP__COLOR_FN(overhead_us, period_us)
> -HPP__COLOR_FN(overhead_guest_sys, period_guest_sys)
> -HPP__COLOR_FN(overhead_guest_us, period_guest_us)
> +__HPP_COLOR_PERCENT_FN(overhead, period)
> +__HPP_COLOR_PERCENT_FN(overhead_sys, period_sys)
> +__HPP_COLOR_PERCENT_FN(overhead_us, period_us)
> +__HPP_COLOR_PERCENT_FN(overhead_guest_sys, period_guest_sys)
> +__HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us)
>  
> -#undef HPP__COLOR_FN
> +#undef __HPP_COLOR_PERCENT_FN
>  
>  
>  void perf_gtk__init_hpp(void)
> @@ -70,6 +140,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
>  	struct perf_hpp hpp = {
>  		.buf		= s,
>  		.size		= sizeof(s),
> +		.ptr		= hists_to_evsel(hists),
>  	};
>  
>  	nr_cols = 0;
> @@ -94,7 +165,6 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
>  
>  	perf_hpp__for_each_format(fmt) {
>  		fmt->header(&hpp);
> -
>  		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
>  							    -1, s,
>  							    renderer, "markup",
> -- 
> 1.7.11.7

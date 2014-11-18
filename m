Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaKRENK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 23:13:10 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:42346 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbaKRENJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 23:13:09 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: kan.liang@intel.com
Cc: acme@kernel.org, jolsa@redhat.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com
Subject: Re: [PATCH V3 3/3] perf tool: Add sort key symoff for perf diff
References: <1416235939-29565-1-git-send-email-kan.liang@intel.com>
	<1416235939-29565-4-git-send-email-kan.liang@intel.com>
Date: Tue, 18 Nov 2014 13:13:01 +0900
In-Reply-To: <1416235939-29565-4-git-send-email-kan.liang@intel.com> (kan
	liang's message of "Mon, 17 Nov 2014 09:52:19 -0500")
Message-ID: <877fytrvsi.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi kan,

On Mon, 17 Nov 2014 09:52:19 -0500, kan liang wrote:
> From: Kan Liang <kan.liang@intel.com>
>
> Sometime, especially debugging scaling issue, the function level diff
> may be high granularity. The user may want to do deeper diff analysis
> for some cache or lock issue. The "symoff" key can let the user sort
> differential profile by ips. This feature should only work when the
> perf.data comes from same binary.

It'd be better to include output of symoff here IMHO.

>
> Signed-off-by: Kan Liang <kan.liang@intel.com>
> ---
>  tools/perf/Documentation/perf-diff.txt |  8 ++++++--
>  tools/perf/builtin-diff.c              |  2 +-
>  tools/perf/util/hist.c                 |  5 +++--
>  tools/perf/util/hist.h                 |  1 +
>  tools/perf/util/sort.c                 | 29 +++++++++++++++++++++++++++++
>  tools/perf/util/sort.h                 |  2 ++
>  6 files changed, 42 insertions(+), 5 deletions(-)
>
> diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
> index e463caa..9e13911 100644
> --- a/tools/perf/Documentation/perf-diff.txt
> +++ b/tools/perf/Documentation/perf-diff.txt
> @@ -50,8 +50,12 @@ OPTIONS
>  
>  -s::
>  --sort=::
> -	Sort by key(s): pid, comm, dso, symbol, cpu, parent, srcline.
> -	Please see description of --sort in the perf-report man page.
> +	Sort by key(s): pid, comm, dso, symbol, cpu, parent, srcline, symoff.
> +
> +	- symoff: exact symbol +  offset address executed at the time of sample.
> +	(for same binary compare)
> +
> +	For other keys, please see description of --sort in the perf-report man page.
>  
>  -t::
>  --field-separator=::
> diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
> index 1ce425d..03a4001 100644
> --- a/tools/perf/builtin-diff.c
> +++ b/tools/perf/builtin-diff.c
> @@ -744,7 +744,7 @@ static const struct option options[] = {
>  	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
>  		   "only consider these symbols"),
>  	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
> -		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline, ..."
> +		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline, symoff, ..."
>  		   " Please refer the man page for the complete list."),
>  	OPT_STRING('t', "field-separator", &symbol_conf.field_sep, "separator",
>  		   "separator for columns, no spaces will be added between "
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 6e88b9e..3d8a71b 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -67,13 +67,14 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
>  		symlen = h->ms.sym->namelen + 4;
>  		if (verbose)
>  			symlen += BITS_PER_LONG / 4 + 2 + 3;
> -		hists__new_col_len(hists, HISTC_SYMBOL, symlen);
>  	} else {
>  		symlen = unresolved_col_width + 4 + 2;
> -		hists__new_col_len(hists, HISTC_SYMBOL, symlen);
>  		hists__set_unres_dso_col_len(hists, HISTC_DSO);
>  	}
>  
> +	hists__new_col_len(hists, HISTC_SYMBOL, symlen);
> +	hists__new_col_len(hists, HISTC_SYMOFF, symlen);
> +
>  	len = thread__comm_len(h->thread);
>  	if (hists__new_col_len(hists, HISTC_COMM, len))
>  		hists__set_col_len(hists, HISTC_THREAD, len + 6);
> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> index d0ef9a1..874b203 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/perf/util/hist.h
> @@ -24,6 +24,7 @@ enum hist_filter {
>  
>  enum hist_column {
>  	HISTC_SYMBOL,
> +	HISTC_SYMOFF,
>  	HISTC_DSO,
>  	HISTC_THREAD,
>  	HISTC_COMM,
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index 5b6c57d..370a799 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -280,6 +280,34 @@ struct sort_entry sort_sym = {
>  	.se_width_idx	= HISTC_SYMBOL,
>  };
>  
> +static int64_t
> +sort__addr_cmp(struct hist_entry *left, struct hist_entry *right)
> +{
> +	return _sort__addr_cmp(left->ip, right->ip);
> +}
> +
> +static int hist_entry__addr_snprintf(struct hist_entry *he, char *bf,
> +				    size_t size, unsigned int width)
> +{
> +	struct map *map = he->ms.map;
> +	u64 ip;
> +
> +	if (map)
> +		ip = map->unmap_ip(map, he->ip);
> +	else
> +		ip = he->ip;
> +
> +	return _hist_entry__sym_snprintf(NULL, NULL, ip,
> +					 he->level, bf, size, width);
> +}
> +
> +struct sort_entry sort_symoff = {
> +	.se_header	= "Symbol+Offset",
> +	.se_cmp		= sort__addr_cmp,
> +	.se_snprintf	= hist_entry__addr_snprintf,
> +	.se_width_idx	= HISTC_SYMOFF,
> +};

I meant something like below (not tested):


sort__symoff_cmp(left, right)
{
	return _sort__addr_cmp(left->ip, right->ip);
}

sort__symoff_collapse(left, right)
{
	int64_t ret;
	u64 symoff_l, symoff_r;

	if (!left->ms.sym || right->ms.sym)
		return cmp_null(...);

	ret = strcmp(left->ms.sym, right->ms.sym);
	if (ret)
		return ret;

	symoff_l = left->ip - left->ms.sym->start;
	symoff_r = right->ip - right->ms.sym->start;

        return (int64_t)(symoff_r - symoff_l);
}

hist_entry__symoff_snprintf(he, bf, size, width)
{
	size_t ret;

	if (he->ms.sym)
		ret = repsep_snprintf(bf, size, "%s+0x%llx", he->ms.sym->name,
				he->ip - he->ms.sym->start);
	else
		ret = repsep_snprintf(bf, size, "%-#*llx",
				BITS_PER_LONG / 4 + 2, he->ip); // unmap?

	ret += repsep_snprintf(bf + ret, size - ret, "%-*s",
			       width - ret, "");

	if (ret > width)
		bf[width] = '\0';

	return width;
}

struct sort_entry sort_symoff = {
	.se_header	= "Symbol+Offset",
	.se_cmp		= sort__symoff_cmp,
	.se_snprintf	= hist_entry__symoff_snprintf,
	.se_width_idx	= HISTC_SYMOFF,


...

int sort_dimension__add()
{
	...
	else if (sd->entry == &sort_symoff) {
		if (sort__mode == SORT_MODE__DIFF)
			se->entry->se_collapse = sort__symoff_collapse;
	}
	...
}


Thanks,
Namhyung


> +
>  /* --sort srcline */
>  
>  static int64_t
> @@ -1170,6 +1198,7 @@ static struct sort_dimension common_sort_dimensions[] = {
>  	DIM(SORT_COMM, "comm", sort_comm),
>  	DIM(SORT_DSO, "dso", sort_dso),
>  	DIM(SORT_SYM, "symbol", sort_sym),
> +	DIM(SORT_SYMOFF, "symoff", sort_symoff),
>  	DIM(SORT_PARENT, "parent", sort_parent),
>  	DIM(SORT_CPU, "cpu", sort_cpu),
>  	DIM(SORT_SRCLINE, "srcline", sort_srcline),
> diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
> index c03e4ff..ea0122f 100644
> --- a/tools/perf/util/sort.h
> +++ b/tools/perf/util/sort.h
> @@ -38,6 +38,7 @@ extern enum sort_mode sort__mode;
>  extern struct sort_entry sort_comm;
>  extern struct sort_entry sort_dso;
>  extern struct sort_entry sort_sym;
> +extern struct sort_entry sort_symoff;
>  extern struct sort_entry sort_parent;
>  extern struct sort_entry sort_dso_from;
>  extern struct sort_entry sort_dso_to;
> @@ -161,6 +162,7 @@ enum sort_type {
>  	SORT_COMM,
>  	SORT_DSO,
>  	SORT_SYM,
> +	SORT_SYMOFF,
>  	SORT_PARENT,
>  	SORT_CPU,
>  	SORT_SRCLINE,

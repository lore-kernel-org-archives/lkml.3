Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbaKSO7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:59:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:46313 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950AbaKSO7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:59:13 -0500
Date: Tue, 18 Nov 2014 18:13:19 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: kan.liang@intel.com
Cc: jolsa@redhat.com, namhyung@kernel.org, linux-kernel@vger.kernel.org,
        ak@linux.intel.com
Subject: Re: [PATCH V4 3/3] perf tool: Add sort key symoff for perf diff
Message-ID: <20141118211319.GD3790@kernel.org>
References: <1416328700-1836-1-git-send-email-kan.liang@intel.com>
 <1416328700-1836-4-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416328700-1836-4-git-send-email-kan.liang@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 18, 2014 at 11:38:20AM -0500, kan.liang@intel.com escreveu:
> From: Kan Liang <kan.liang@intel.com>
> 
> Sometime, especially debugging scaling issue, the function level diff
> may be high granularity. The user may want to do deeper diff analysis
> for some cache or lock issue. The "symoff" key can let the user sort
> differential profile by ips. This feature should only work when the
> perf.data comes from same binary.

So, to avoid having people scratching heads, and since we have the
build-id for both perf.data files, hence for both binaries being
compared, can we check the build ids and either refuse to do the diff or
print a big warning about different binaries being compared?

- Arnaldo
 
> Here is an example.
> perf diff -s symoff  v1_1_8_1perf.data v1_1_8_2perf.data
> 
>  Event 'cycles'
> 
>  Baseline    Delta  Symbol + Offset
>  ........  .......  ...............................
> 
>      0.00%           __update_cpu_load+0xcc
>                      _raw_spin_lock_irqsave+0x24
>                      _raw_spin_unlock_irqrestore+0xa
>      0.00%           apic_timer_interrupt+0x0
>                      apic_timer_interrupt+0x68
>                      check_preempt_curr+0x1c
>      0.00%           f1+0x20
>      0.03%   +0.03%  f2+0x11
>      0.03%   +0.01%  f2+0x16
>      0.05%           f2+0x1b
>      0.04%   -0.02%  f2+0x20
>      0.03%           f2+0x25
>      0.17%   +0.11%  f2+0x29
>      0.15%           f2+0x2d
>                      f2+0x30
>      0.37%   +0.02%  f3+0x0
>      0.18%   +0.03%  f3+0x1
>      0.01%           f3+0x4
>      0.18%   +0.04%  f3+0xb
>     12.31%   +0.11%  f3+0xd
>      0.03%           f3+0x10
>      0.80%   -0.12%  f3+0x13
>      6.66%   +0.09%  f3+0x17
>      1.81%   -0.36%  f3+0x1b
>      6.35%   +0.24%  f3+0x1d
>      1.42%   -0.22%  f3+0x21
>     66.83%   +0.22%  f3+0x25
>      1.29%   -0.12%  f3+0x27
>      1.22%   -0.04%  f3+0x28
>      0.00%           load_balance+0x96
>      0.00%           native_apic_mem_write+0x0
>      0.00%           native_write_msr_safe+0xa
>      0.00%           native_write_msr_safe+0xd
>      0.00%           rb_erase+0x381
>                      resched_curr+0x5
>                      restore_args+0x4
>      0.00%           run_timer_softirq+0x29f
>                      select_task_rq_fair+0x9
>      0.00%           select_task_rq_fair+0x1d9
>                      task_tick_fair+0x46
>      0.00%           task_tick_fair+0x1ce
>                      task_waking_fair+0x27
>      0.00%           try_to_wake_up+0x158
>                      update_cfs_rq_blocked_load+0x99
>      0.00%           update_cpu_load_active+0x3b
>                      update_group_capacity+0x150
>                      update_wall_time+0x3c6
> 
> Signed-off-by: Kan Liang <kan.liang@intel.com>
> ---
>  tools/perf/Documentation/perf-diff.txt |  8 +++-
>  tools/perf/builtin-diff.c              |  2 +-
>  tools/perf/util/hist.c                 |  5 ++-
>  tools/perf/util/hist.h                 |  1 +
>  tools/perf/util/sort.c                 | 67 ++++++++++++++++++++++++++++++++++
>  tools/perf/util/sort.h                 |  2 +
>  6 files changed, 80 insertions(+), 5 deletions(-)
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
> index bea2e07..49ad000 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -280,6 +280,65 @@ struct sort_entry sort_sym = {
>  	.se_width_idx	= HISTC_SYMBOL,
>  };
>  
> +static int64_t
> +sort__symoff_cmp(struct hist_entry *left, struct hist_entry *right)
> +{
> +	return _sort__addr_cmp(left->ip, right->ip);
> +}
> +
> +static int64_t
> +sort__symoff_collapse(struct hist_entry *left, struct hist_entry *right)
> +{
> +	struct symbol *sym_l = left->ms.sym;
> +	struct symbol *sym_r = right->ms.sym;
> +	u64 symoff_l, symoff_r;
> +	int64_t ret;
> +
> +	if (!sym_l || !sym_r)
> +		return cmp_null(sym_l, sym_r);
> +
> +	ret = strcmp(sym_r->name, sym_l->name);
> +	if (ret)
> +		return ret;
> +
> +
> +	symoff_l = left->ip - sym_l->start;
> +	symoff_r = right->ip - sym_r->start;
> +
> +	return (int64_t)(symoff_r - symoff_l);
> +}
> +
> +static int hist_entry__symoff_snprintf(struct hist_entry *he, char *bf,
> +				    size_t size, unsigned int width)
> +{
> +	struct map *map = he->ms.map;
> +	struct symbol *sym = he->ms.sym;
> +	size_t ret = 0;
> +
> +	if (sym) {
> +		ret += repsep_snprintf(bf + ret, size - ret, "%s", sym->name);
> +		ret += repsep_snprintf(bf + ret, size - ret, "+0x%llx",
> +				       he->ip - sym->start);
> +
> +	} else {
> +		size_t len = BITS_PER_LONG / 4;
> +
> +		ret += repsep_snprintf(bf + ret, size - ret, "%-#.*llx", len,
> +				       map ? map->unmap_ip(map, he->ip) : he->ip);
> +	}
> +
> +	ret += repsep_snprintf(bf + ret, size - ret, "%-*s",
> +			       width - ret, "");
> +	return ret;
> +}
> +
> +struct sort_entry sort_symoff = {
> +	.se_header	= "Symbol + Offset",
> +	.se_cmp		= sort__symoff_cmp,
> +	.se_snprintf	= hist_entry__symoff_snprintf,
> +	.se_width_idx	= HISTC_SYMOFF,
> +};
> +
>  /* --sort srcline */
>  
>  static int64_t
> @@ -1172,6 +1231,7 @@ static struct sort_dimension common_sort_dimensions[] = {
>  	DIM(SORT_COMM, "comm", sort_comm),
>  	DIM(SORT_DSO, "dso", sort_dso),
>  	DIM(SORT_SYM, "symbol", sort_sym),
> +	DIM(SORT_SYMOFF, "symoff", sort_symoff),
>  	DIM(SORT_PARENT, "parent", sort_parent),
>  	DIM(SORT_CPU, "cpu", sort_cpu),
>  	DIM(SORT_SRCLINE, "srcline", sort_srcline),
> @@ -1443,6 +1503,13 @@ int sort_dimension__add(const char *tok)
>  
>  		} else if (sd->entry == &sort_dso) {
>  			sort__has_dso = 1;
> +		} else if (sd->entry == &sort_symoff) {
> +			/*
> +			 * For symoff sort key, not only the offset but also the
> +			 * symbol name should be compared.
> +			 */
> +			if (sort__mode == SORT_MODE__DIFF)
> +				sd->entry->se_collapse = sort__symoff_collapse;
>  		}
>  
>  		return __sort_dimension__add(sd);
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
> -- 
> 1.8.3.2

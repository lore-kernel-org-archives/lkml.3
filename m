Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbaKSGqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 01:46:40 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:59493 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbaKSGqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 01:46:38 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: kan.liang@intel.com
Cc: acme@kernel.org, jolsa@redhat.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com
Subject: Re: [PATCH V4 3/3] perf tool: Add sort key symoff for perf diff
References: <1416328700-1836-1-git-send-email-kan.liang@intel.com>
	<1416328700-1836-4-git-send-email-kan.liang@intel.com>
Date: Wed, 19 Nov 2014 15:46:36 +0900
In-Reply-To: <1416328700-1836-4-git-send-email-kan.liang@intel.com> (kan
	liang's message of "Tue, 18 Nov 2014 11:38:20 -0500")
Message-ID: <87vbmbpu0j.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014 11:38:20 -0500, kan liang wrote:
> From: Kan Liang <kan.liang@intel.com>
>
> Sometime, especially debugging scaling issue, the function level diff
> may be high granularity. The user may want to do deeper diff analysis
> for some cache or lock issue. The "symoff" key can let the user sort
> differential profile by ips. This feature should only work when the
> perf.data comes from same binary.

I think the symoff sort key now works well for different (i.e. modified)
binaries too.


>
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

Ditto.  And symoff is not only for perf diff, but it should work for
normal perf report also.  So you'd better move the description to perf
report man page IMHO.


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

SYMOFF will need larger length at least 6 (for "+0xYYY").  Idealy 3 +
symbol size in hexdigit?

Thanks,
Namhyung

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbbAFOyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:54:05 -0500
Received: from mail.kernel.org ([198.145.29.136]:54525 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347AbbAFOyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:54:03 -0500
Date: Tue, 6 Jan 2015 11:53:56 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: kan.liang@intel.com
Cc: jolsa@redhat.com, namhyung@kernel.org, linux-kernel@vger.kernel.org,
        ak@linux.intel.com
Subject: Re: [PATCH V6 1/1] perf tool: perf diff support for different
 binaries
Message-ID: <20150106145356.GA10675@kernel.org>
References: <1417534758-26416-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417534758-26416-1-git-send-email-kan.liang@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 02, 2014 at 10:39:18AM -0500, kan.liang@intel.com escreveu:
> From: Kan Liang <kan.liang@intel.com>
> 
> Currently, the perf diff only works with same binaries. That's because
> it compares the symbol start address. It doesn't work if the perf.data
> comes from different binaries. This patch matches the function names.

Sorry Kan, I saw these patches, its just that it the above statement
looked completely strange to me, i.e. of course it should look at the
dso name, then at the symbol name, comparing via addresses makes no
sense to me, so I kept leaving this patch to look after processing other
patches and doing other things, then the year end holidays, etc.

So now I'm looking at old code, from 2009:

  commit 604c5c92972dcb4b98be34775452d09a5d4ec248
  Author: Arnaldo Carvalho de Melo <acme@redhat.com>
  Date:   Wed Dec 16 14:09:53 2009 -0200

    perf diff: Change the default sort order to "dso,symbol"
    
    This is a more intuitive / more meaningful default:
    
    $ perf diff | head -8
         9.02%     +1.00%  libc-2.10.1.so               [.] _IO_vfprintf_internal
         2.91%     -1.00%  [kernel]                     [k] __kmalloc
         2.85%     -1.00%  [kernel]                     [k] ext4_htree_store_dirent
         1.99%     -1.00%  [kernel]                     [k] _atomic_dec_and_lock
         2.44%             [kernel]
    $
    
    Suggested-by: Ingo Molnar <mingo@elte.hu>

and I see:

static void perf_session__match_hists(struct perf_session *old_session,
                                      struct perf_session *new_session)
{
        struct rb_node *nd;

        perf_session__resort_by_name(old_session);

        for (nd = rb_first(&new_session->hists); nd; nd = rb_next(nd)) {
                struct hist_entry *pos = rb_entry(nd, struct hist_entry, rb_node);
                pos->pair = perf_session__find_hist_entry_by_name(old_session, pos);
        }
}

Ok, it will process all samples, store everything in hist_entries, etc, then traverse all
entries in the most recent perf.data file and look for a pair, _by name_:

static struct hist_entry *
perf_session__find_hist_entry_by_name(struct perf_session *self,
                                      struct hist_entry *he)
{
        struct rb_node *n = self->hists.rb_node;

        while (n) {
                struct hist_entry *iter = rb_entry(n, struct hist_entry, rb_node);
                int cmp = strcmp(he->map->dso->name, iter->map->dso->name);

                if (cmp > 0)
                        n = n->rb_left;
                else if (cmp < 0)
                        n = n->rb_right;
                else {
                        cmp = strcmp(he->sym->name, iter->sym->name);
                        if (cmp > 0)
                                n = n->rb_left;
                        else if (cmp < 0)
                                n = n->rb_right;
                        else
                                return iter;
                }
        }

        return NULL;
}

See? Resort the old session by "dso,symbol_name", then go on pairing them.

So at some point this got broken :-\

I.e. this is not changing an existing correct behaviour, but fixing a bug, i.e.
the changeset comment confused me :-\

Now I'm trying to figure out _when_ this got broken, what was the reasoning for
that code to have changed in a way that made it not match by dso_name, symbol_name.

Also please, when providing code to be built to reproduce your results, make it
self contained,  i.e. in the case below, I had to replace "noinline" with
"__attribute__((noinline))".

- Arnaldo
 
> Here is an examples.
> The only difference between example_v1.c and example_v2.c is the
> location of f2 and f3. There is no change in behavior, but the previous
> perf diff display the wrong differential profile.
> 
> example_v1.c
> 
> noinline void f3(void)
> {
>         volatile int i;
>         for (i = 0; i < 10000;) {
> 
>                 if(i%2)
>                         i++;
>                 else
>                         i++;
>         }
> }
> 
> noinline void f2(void)
> {
>         volatile int a = 100, b, c;
>         for (b = 0; b < 10000; b++)
>                 c = a * b;
> 
> }
> 
> noinline void f1(void)
> {
>                 f2();
>                 f3();
> }
> 
> int main()
> {
>         int i;
>         for (i = 0; i < 100000; i++)
>                 f1();
> }
> 
> example_v2.c
> 
> noinline void f2(void)
> {
>         volatile int a = 100, b, c;
>         for (b = 0; b < 10000; b++)
>                 c = a * b;
> }
> 
> noinline void f3(void)
> {
>         volatile int i;
>         for (i = 0; i < 10000;) {
>                 if(i%2)
>                         i++;
>                 else
>                         i++;
>         }
> }
> 
> noinline void f1(void)
> {
>                 f2();
>                 f3();
> }
> 
> int main()
> {
>         int i;
>         for (i = 0; i < 100000; i++)
>                 f1();
> }
> 
> [lk@localhost perf_diff]$ gcc example_v1.c -o example
> [lk@localhost perf_diff]$ perf record -o example_v1.data ./example
> [ perf record: Woken up 4 times to write data ]
> [ perf record: Captured and wrote 0.813 MB example_v1.data (~35522
> samples) ]
> 
> [lk@localhost perf_diff]$ gcc example_v2.c -o example
> [lk@localhost perf_diff]$ perf record -o example_v2.data ./example
> [ perf record: Woken up 4 times to write data ]
> [ perf record: Captured and wrote 0.824 MB example_v2.data (~36015
> samples) ]
> 
> Old perf diff result.
> [lk@localhost perf_diff]$ perf diff example_v1.data example_v2.data
>  Event 'cycles'
> 
>  Baseline    Delta  Shared Object     Symbol
>  ........  .......  ................  ...............................
> 
>                      [kernel.vmlinux]  [k] __perf_event_task_sched_out
>      0.00%           [kernel.vmlinux]  [k] apic_timer_interrupt
>                      [kernel.vmlinux]  [k] idle_cpu
>                      [kernel.vmlinux]  [k] intel_pstate_timer_func
>                      [kernel.vmlinux]  [k] native_read_msr_safe
>      0.00%           [kernel.vmlinux]  [k] native_read_tsc
>      0.00%           [kernel.vmlinux]  [k] native_write_msr_safe
>                      [kernel.vmlinux]  [k] ntp_tick_length
>      0.00%           [kernel.vmlinux]  [k] rb_erase
>      0.00%           [kernel.vmlinux]  [k] tick_sched_timer
>      0.00%           [kernel.vmlinux]  [k] unmap_single_vma
>      0.00%           [kernel.vmlinux]  [k] update_wall_time
>      0.00%           example           [.] f1
>     46.24%           example           [.] f2
>     53.71%   -7.55%  example           [.] f3
>             +53.81%  example           [.] f3
>      0.02%           example           [.] main
> 
> New perf diff result.
> [lk@localhost perf_diff]$ perf diff example_v1.data example_v2.data
>                      [kernel.vmlinux]  [k] __perf_event_task_sched_out
>      0.00%           [kernel.vmlinux]  [k] apic_timer_interrupt
>                      [kernel.vmlinux]  [k] idle_cpu
>                      [kernel.vmlinux]  [k] intel_pstate_timer_func
>                      [kernel.vmlinux]  [k] native_read_msr_safe
>      0.00%           [kernel.vmlinux]  [k] native_read_tsc
>      0.00%           [kernel.vmlinux]  [k] native_write_msr_safe
>                      [kernel.vmlinux]  [k] ntp_tick_length
>      0.00%           [kernel.vmlinux]  [k] rb_erase
>      0.00%           [kernel.vmlinux]  [k] tick_sched_timer
>      0.00%           [kernel.vmlinux]  [k] unmap_single_vma
>      0.00%           [kernel.vmlinux]  [k] update_wall_time
>      0.00%           example           [.] f1
>     46.24%   -0.08%  example           [.] f2
>     53.71%   +0.11%  example           [.] f3
>      0.02%           example           [.] main
> 
> Signed-off-by: Kan Liang <kan.liang@intel.com>
> Acked-by: Namhyung Kim <namhyung@kernel.org>
> Acked-by: Jiri Olsa <jolsa@kernel.org>
> 
> ---
> 
> The patch is seperated from "[PATCH V4 0/3] perf tool: perf diff sort changes" patch set. 
> The first patch of the patch set has been merged. 
> The third patch of the patch set for symoff will be sent out by another thread. 
> 
> Changes since V4: 
>  - Seperate from old patch set 
>  - Add an example in changelog 
>  - Update man page 
> 
> Changes since V5:
>  - Correct patch style
> 
>  tools/perf/Documentation/perf-diff.txt | 5 +++++
>  tools/perf/util/sort.c                 | 9 +++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
> index e463caa..5182661 100644
> --- a/tools/perf/Documentation/perf-diff.txt
> +++ b/tools/perf/Documentation/perf-diff.txt
> @@ -20,6 +20,11 @@ If no parameters are passed it will assume perf.data.old and perf.data.
>  The differential profile is displayed only for events matching both
>  specified perf.data files.
>  
> +If no parameters are passed the samples will be sorted by dso and symbol.
> +As the perf.data files could come from different binaries, the symbols addresses
> +could vary. So perf diff is based on the comparison of the files and
> +symbols name.
> +
>  OPTIONS
>  -------
>  -D::
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index 9139dda..e0e4173 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -1432,6 +1432,15 @@ int sort_dimension__add(const char *tok)
>  			sort__has_parent = 1;
>  		} else if (sd->entry == &sort_sym) {
>  			sort__has_sym = 1;
> +			/*
> +			 * perf diff displays the performance difference amongst
> +			 * two or more perf.data files. Those files could come
> +			 * from different binaries. So we should not compare
> +			 * their ips, but the name of symbol.
> +			 */
> +			if (sort__mode == SORT_MODE__DIFF)
> +				sd->entry->se_collapse = sort__sym_sort;
> +
>  		} else if (sd->entry == &sort_dso) {
>  			sort__has_dso = 1;
>  		}
> -- 
> 1.8.3.2

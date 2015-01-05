Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbbAEQEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 11:04:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:50941 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbbAEQEx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 11:04:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,700,1413270000"; 
   d="scan'208";a="664633074"
From: "Liang, Kan" <kan.liang@intel.com>
To: "acme@kernel.org" <acme@kernel.org>, "jolsa@redhat.com" <jolsa@redhat.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V6 1/1] perf tool: perf diff support for different
 binaries
Thread-Topic: [PATCH V6 1/1] perf tool: perf diff support for different
 binaries
Thread-Index: AQHQDkjoJ7KOEpNzNUyoh7SK6Z35IZyx1eKQ
Date: Mon, 5 Jan 2015 16:04:42 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F07701692D78@SHSMSX103.ccr.corp.intel.com>
References: <1417534758-26416-1-git-send-email-kan.liang@intel.com>
In-Reply-To: <1417534758-26416-1-git-send-email-kan.liang@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

The patch is one month old. Kim and Jirka have reviewed it. 

There is also another perf diff related patch which has similar situation.
https://lkml.org/lkml/2014/12/1/380
It was also reviewed by Jirka a month ago.

Both of them still apply to current perf/core. 
Should I re-post them for more review?

Thanks,
Kan

> 
> From: Kan Liang <kan.liang@intel.com>
> 
> Currently, the perf diff only works with same binaries. That's because it
> compares the symbol start address. It doesn't work if the perf.data comes
> from different binaries. This patch matches the function names.
> 
> Here is an examples.
> The only difference between example_v1.c and example_v2.c is the
> location of f2 and f3. There is no change in behavior, but the previous perf
> diff display the wrong differential profile.
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
> [lk@localhost perf_diff]$ gcc example_v1.c -o example [lk@localhost
> perf_diff]$ perf record -o example_v1.data ./example [ perf record:
> Woken up 4 times to write data ] [ perf record: Captured and wrote 0.813
> MB example_v1.data (~35522
> samples) ]
> 
> [lk@localhost perf_diff]$ gcc example_v2.c -o example [lk@localhost
> perf_diff]$ perf record -o example_v2.data ./example [ perf record:
> Woken up 4 times to write data ] [ perf record: Captured and wrote 0.824
> MB example_v2.data (~36015
> samples) ]
> 
> Old perf diff result.
> [lk@localhost perf_diff]$ perf diff example_v1.data example_v2.data
> Event 'cycles'
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
> The patch is seperated from "[PATCH V4 0/3] perf tool: perf diff sort
> changes" patch set.
> The first patch of the patch set has been merged.
> The third patch of the patch set for symoff will be sent out by another
> thread.
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
> diff --git a/tools/perf/Documentation/perf-diff.txt
> b/tools/perf/Documentation/perf-diff.txt
> index e463caa..5182661 100644
> --- a/tools/perf/Documentation/perf-diff.txt
> +++ b/tools/perf/Documentation/perf-diff.txt
> @@ -20,6 +20,11 @@ If no parameters are passed it will assume
> perf.data.old and perf.data.
>  The differential profile is displayed only for events matching both
> specified perf.data files.
> 
> +If no parameters are passed the samples will be sorted by dso and symbol.
> +As the perf.data files could come from different binaries, the symbols
> +addresses could vary. So perf diff is based on the comparison of the
> +files and symbols name.
> +
>  OPTIONS
>  -------
>  -D::
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c index
> 9139dda..e0e4173 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -1432,6 +1432,15 @@ int sort_dimension__add(const char *tok)
>  			sort__has_parent = 1;
>  		} else if (sd->entry == &sort_sym) {
>  			sort__has_sym = 1;
> +			/*
> +			 * perf diff displays the performance difference
> amongst
> +			 * two or more perf.data files. Those files could
> come
> +			 * from different binaries. So we should not
> compare
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaLBP65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 10:58:57 -0500
Received: from mga03.intel.com ([134.134.136.65]:18761 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255AbaLBP64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 10:58:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="492330900"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com, namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V6 1/1] perf tool: perf diff support for different binaries
Date: Tue,  2 Dec 2014 10:39:18 -0500
Message-Id: <1417534758-26416-1-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

Currently, the perf diff only works with same binaries. That's because
it compares the symbol start address. It doesn't work if the perf.data
comes from different binaries. This patch matches the function names.

Here is an examples.
The only difference between example_v1.c and example_v2.c is the
location of f2 and f3. There is no change in behavior, but the previous
perf diff display the wrong differential profile.

example_v1.c

noinline void f3(void)
{
        volatile int i;
        for (i = 0; i < 10000;) {

                if(i%2)
                        i++;
                else
                        i++;
        }
}

noinline void f2(void)
{
        volatile int a = 100, b, c;
        for (b = 0; b < 10000; b++)
                c = a * b;

}

noinline void f1(void)
{
                f2();
                f3();
}

int main()
{
        int i;
        for (i = 0; i < 100000; i++)
                f1();
}

example_v2.c

noinline void f2(void)
{
        volatile int a = 100, b, c;
        for (b = 0; b < 10000; b++)
                c = a * b;
}

noinline void f3(void)
{
        volatile int i;
        for (i = 0; i < 10000;) {
                if(i%2)
                        i++;
                else
                        i++;
        }
}

noinline void f1(void)
{
                f2();
                f3();
}

int main()
{
        int i;
        for (i = 0; i < 100000; i++)
                f1();
}

[lk@localhost perf_diff]$ gcc example_v1.c -o example
[lk@localhost perf_diff]$ perf record -o example_v1.data ./example
[ perf record: Woken up 4 times to write data ]
[ perf record: Captured and wrote 0.813 MB example_v1.data (~35522
samples) ]

[lk@localhost perf_diff]$ gcc example_v2.c -o example
[lk@localhost perf_diff]$ perf record -o example_v2.data ./example
[ perf record: Woken up 4 times to write data ]
[ perf record: Captured and wrote 0.824 MB example_v2.data (~36015
samples) ]

Old perf diff result.
[lk@localhost perf_diff]$ perf diff example_v1.data example_v2.data
 Event 'cycles'

 Baseline    Delta  Shared Object     Symbol
 ........  .......  ................  ...............................

                     [kernel.vmlinux]  [k] __perf_event_task_sched_out
     0.00%           [kernel.vmlinux]  [k] apic_timer_interrupt
                     [kernel.vmlinux]  [k] idle_cpu
                     [kernel.vmlinux]  [k] intel_pstate_timer_func
                     [kernel.vmlinux]  [k] native_read_msr_safe
     0.00%           [kernel.vmlinux]  [k] native_read_tsc
     0.00%           [kernel.vmlinux]  [k] native_write_msr_safe
                     [kernel.vmlinux]  [k] ntp_tick_length
     0.00%           [kernel.vmlinux]  [k] rb_erase
     0.00%           [kernel.vmlinux]  [k] tick_sched_timer
     0.00%           [kernel.vmlinux]  [k] unmap_single_vma
     0.00%           [kernel.vmlinux]  [k] update_wall_time
     0.00%           example           [.] f1
    46.24%           example           [.] f2
    53.71%   -7.55%  example           [.] f3
            +53.81%  example           [.] f3
     0.02%           example           [.] main

New perf diff result.
[lk@localhost perf_diff]$ perf diff example_v1.data example_v2.data
                     [kernel.vmlinux]  [k] __perf_event_task_sched_out
     0.00%           [kernel.vmlinux]  [k] apic_timer_interrupt
                     [kernel.vmlinux]  [k] idle_cpu
                     [kernel.vmlinux]  [k] intel_pstate_timer_func
                     [kernel.vmlinux]  [k] native_read_msr_safe
     0.00%           [kernel.vmlinux]  [k] native_read_tsc
     0.00%           [kernel.vmlinux]  [k] native_write_msr_safe
                     [kernel.vmlinux]  [k] ntp_tick_length
     0.00%           [kernel.vmlinux]  [k] rb_erase
     0.00%           [kernel.vmlinux]  [k] tick_sched_timer
     0.00%           [kernel.vmlinux]  [k] unmap_single_vma
     0.00%           [kernel.vmlinux]  [k] update_wall_time
     0.00%           example           [.] f1
    46.24%   -0.08%  example           [.] f2
    53.71%   +0.11%  example           [.] f3
     0.02%           example           [.] main

Signed-off-by: Kan Liang <kan.liang@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>

---

The patch is seperated from "[PATCH V4 0/3] perf tool: perf diff sort changes" patch set. 
The first patch of the patch set has been merged. 
The third patch of the patch set for symoff will be sent out by another thread. 

Changes since V4: 
 - Seperate from old patch set 
 - Add an example in changelog 
 - Update man page 

Changes since V5:
 - Correct patch style

 tools/perf/Documentation/perf-diff.txt | 5 +++++
 tools/perf/util/sort.c                 | 9 +++++++++
 2 files changed, 14 insertions(+)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index e463caa..5182661 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -20,6 +20,11 @@ If no parameters are passed it will assume perf.data.old and perf.data.
 The differential profile is displayed only for events matching both
 specified perf.data files.
 
+If no parameters are passed the samples will be sorted by dso and symbol.
+As the perf.data files could come from different binaries, the symbols addresses
+could vary. So perf diff is based on the comparison of the files and
+symbols name.
+
 OPTIONS
 -------
 -D::
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 9139dda..e0e4173 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1432,6 +1432,15 @@ int sort_dimension__add(const char *tok)
 			sort__has_parent = 1;
 		} else if (sd->entry == &sort_sym) {
 			sort__has_sym = 1;
+			/*
+			 * perf diff displays the performance difference amongst
+			 * two or more perf.data files. Those files could come
+			 * from different binaries. So we should not compare
+			 * their ips, but the name of symbol.
+			 */
+			if (sort__mode == SORT_MODE__DIFF)
+				sd->entry->se_collapse = sort__sym_sort;
+
 		} else if (sd->entry == &sort_dso) {
 			sort__has_dso = 1;
 		}
-- 
1.8.3.2


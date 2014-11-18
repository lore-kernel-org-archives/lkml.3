Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbaKRQzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:55:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:32260 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522AbaKRQyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:54:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,410,1413270000"; 
   d="scan'208";a="609874437"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com, namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V4 0/3] perf tool: perf diff sort changes
Date: Tue, 18 Nov 2014 11:38:17 -0500
Message-Id: <1416328700-1836-1-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

Current perf diff has some issues. E.g. the default sort key is
symbol, but it doesn't work well. It sorts as address. Furthermore,
the old perf diff can only work on perf.data from the same binary.

This patch set fixes the symbol issue and extends it to compare the
perf.data from different binaries and different kernels. It's useful
for debugging the regression issue.
Current perf diff can do address compare, the patch set also keep
this feature. A new sort key "symoff" is introduced. It can let the user
sort differential profile by the address. It should be useful for
debugging the scaling issue, if the user think function level diff is
too high granularity.

Here is an example.

v1_1_6perf.data is perf record result of version one tchain on 1.6 kernel.
v2_1_8perf.data is perf record result of version two tchain on 1.8 kernel.
They are from different binaries.

v1_1_8_1perf.data and v1_1_8_2perf.data are perf record result of version
one tchain on 1.8 kernel. I run perf record twice.
They are from same binary.

Old perf diff with default sort key "dso,symbol" for different binary
./perf diff -s dso,symbol  v1_1_6perf.data v2_1_8perf.data

 Event 'cycles'

 Baseline    Delta  Shared Object      Symbol
 ........  .......  .................  .........................

     0.01%           [kernel.kallsyms]  [k] native_write_msr_safe
     0.01%           [kernel.kallsyms]  [k] notifier_call_chain
     0.01%           [kernel.kallsyms]  [k] perf_event_task_tick
     0.01%           [kernel.kallsyms]  [k] run_posix_cpu_timers
     0.01%           [kernel.kallsyms]  [k] run_timer_softirq
     0.01%           [kernel.kallsyms]  [k] trigger_load_balance
     0.01%           [kernel.kallsyms]  [k] update_vsyscall
                     [kernel.vmlinux]   [k] __run_hrtimer
                     [kernel.vmlinux]   [k] apic_timer_interrupt
                     [kernel.vmlinux]   [k] enqueue_task
                     [kernel.vmlinux]   [k] hrtimer_interrupt
                     [kernel.vmlinux]   [k] native_write_msr_safe
                     [kernel.vmlinux]   [k] trigger_load_balance
                     [kernel.vmlinux]   [k] update_wall_time
     0.05%           [unknown]          [.] 0x0000000000400540
     0.04%           [unknown]          [.] 0x0000000000400541
     0.03%           [unknown]          [.] 0x000000000040054b
     0.04%           [unknown]          [.] 0x0000000000400552
    33.55%           [unknown]          [.] 0x0000000000400554
     1.22%           [unknown]          [.] 0x000000000040055a
     8.00%           [unknown]          [.] 0x000000000040055e
     0.02%           [unknown]          [.] 0x0000000000400562
     8.41%           [unknown]          [.] 0x0000000000400564
    48.13%           [unknown]          [.] 0x000000000040056b
     0.16%           [unknown]          [.] 0x0000000000400570
     0.17%           [unknown]          [.] 0x0000000000400571
             +0.45%  [unknown]          [.] 0x0000000000400580
             +0.29%  [unknown]          [.] 0x0000000000400581
     0.01%           [unknown]          [.] 0x0000000000400583
     0.01%           [unknown]          [.] 0x0000000000400588
             +0.22%  [unknown]          [.] 0x000000000040058b
     0.01%  +13.35%  [unknown]          [.] 0x000000000040058d
     0.06%           [unknown]          [.] 0x0000000000400591
             +0.78%  [unknown]          [.] 0x0000000000400593
     0.04%           [unknown]          [.] 0x0000000000400595
     0.01%   +6.18%  [unknown]          [.] 0x0000000000400597
             +1.47%  [unknown]          [.] 0x000000000040059b
             +6.46%  [unknown]          [.] 0x000000000040059d
             +1.28%  [unknown]          [.] 0x00000000004005a1
            +66.38%  [unknown]          [.] 0x00000000004005a5
             +1.34%  [unknown]          [.] 0x00000000004005a7
             +1.15%  [unknown]          [.] 0x00000000004005a8
             +0.05%  [unknown]          [.] 0x00000000004005ba
             +0.03%  [unknown]          [.] 0x00000000004005bf
             +0.02%  [unknown]          [.] 0x00000000004005c4
             +0.05%  [unknown]          [.] 0x00000000004005c9
             +0.03%  [unknown]          [.] 0x00000000004005ce
             +0.27%  [unknown]          [.] 0x00000000004005d2
             +0.15%  [unknown]          [.] 0x00000000004005d6
                     [unknown]          [.] 0x00000000004005d8
                     [unknown]          [.] 0x00000000004005d9

New perf diff with default sort key "dso,symbol" for different binary
./perf diff -s dso,symbol  v1_1_6perf.data v2_1_8perf.data

 Event 'cycles'

 Baseline    Delta  Shared Object      Symbol
 ........  .......  .................  .........................

     0.01%           [kernel.kallsyms]  [k] native_write_msr_safe
     0.01%           [kernel.kallsyms]  [k] notifier_call_chain
     0.01%           [kernel.kallsyms]  [k] perf_event_task_tick
     0.01%           [kernel.kallsyms]  [k] run_posix_cpu_timers
     0.01%           [kernel.kallsyms]  [k] run_timer_softirq
     0.01%           [kernel.kallsyms]  [k] trigger_load_balance
     0.01%           [kernel.kallsyms]  [k] update_vsyscall
                     [kernel.vmlinux]   [k] __run_hrtimer
                     [kernel.vmlinux]   [k] apic_timer_interrupt
                     [kernel.vmlinux]   [k] enqueue_task
                     [kernel.vmlinux]   [k] hrtimer_interrupt
                     [kernel.vmlinux]   [k] native_write_msr_safe
                     [kernel.vmlinux]   [k] trigger_load_balance
                     [kernel.vmlinux]   [k] update_wall_time
     0.14%   +0.47%  tchain        [.] f2
    99.82%   -0.47%  tchain        [.] f3


Changes from V1:
 - mmap2 as default of tool's definition
 - Using se_collapse to match symbol name.
 - Sort key "addr" is introduced to compare address from same binary.

Changes from V2:
 - Rename sort key name to "symoff"

Changes from V3:
 - Add sort__symoff_collapse for perf diff
 - Refine hist_entry__symoff_snprintf

Kan Liang (3):
  perf tool: Fix perf diff symble sort issue
  perf tool:perf diff support for different binaries
  perf tool: Add sort key symoff for perf diff

 tools/perf/Documentation/perf-diff.txt |  8 +++-
 tools/perf/builtin-diff.c              |  3 +-
 tools/perf/util/hist.c                 |  5 ++-
 tools/perf/util/hist.h                 |  1 +
 tools/perf/util/sort.c                 | 76 ++++++++++++++++++++++++++++++++++
 tools/perf/util/sort.h                 |  2 +
 6 files changed, 90 insertions(+), 5 deletions(-)

-- 
1.8.3.2


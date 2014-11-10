Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbaKJVQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 16:16:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:46712 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbaKJVQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 16:16:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,355,1413270000"; 
   d="scan'208";a="620185071"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com, namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V2 0/3] perf tool: perf diff sort changes
Date: Mon, 10 Nov 2014 16:01:17 -0500
Message-Id: <1415653280-1374-1-git-send-email-kan.liang@intel.com>
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
this feature. A new sort key "addr" is introduced. It can let the user 
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


New perf diff with sort key "symbol,addr" ffor same binary
perf diff -s symbol,addr  v1_1_8_1perf.data v1_1_8_2perf.data

 Event 'cycles'

 Baseline    Delta  Symbol                           Addr
 ........  .......  ...............................  ...............................

     0.00%           [k] __update_cpu_load            [k] 0xffffffff810b9b8c
                     [k] _raw_spin_lock_irqsave       [k] 0xffffffff81759364
                     [k] _raw_spin_unlock_irqrestore  [k] 0xffffffff817594ba
     0.00%           [k] apic_timer_interrupt         [k] 0xffffffff8175a9f0
                     [k] apic_timer_interrupt         [k] 0xffffffff8175aa58
                     [k] check_preempt_curr           [k] 0xffffffff810b461c
     0.00%           [.] f1                           [.] 0x00000000004005fa
     0.03%   +0.03%  [.] f2                           [.] 0x00000000004005ba
     0.03%   +0.01%  [.] f2                           [.] 0x00000000004005bf
     0.05%           [.] f2                           [.] 0x00000000004005c4
     0.04%   -0.02%  [.] f2                           [.] 0x00000000004005c9
     0.03%           [.] f2                           [.] 0x00000000004005ce
     0.17%   +0.11%  [.] f2                           [.] 0x00000000004005d2
     0.15%           [.] f2                           [.] 0x00000000004005d6
                     [.] f2                           [.] 0x00000000004005d9
     0.37%   +0.02%  [.] f3                           [.] 0x0000000000400580
     0.18%   +0.03%  [.] f3                           [.] 0x0000000000400581
     0.01%           [.] f3                           [.] 0x0000000000400584
     0.18%   +0.04%  [.] f3                           [.] 0x000000000040058b
    12.31%   +0.11%  [.] f3                           [.] 0x000000000040058d
     0.03%           [.] f3                           [.] 0x0000000000400590
     0.80%   -0.12%  [.] f3                           [.] 0x0000000000400593
     6.66%   +0.09%  [.] f3                           [.] 0x0000000000400597
     1.81%   -0.36%  [.] f3                           [.] 0x000000000040059b
     6.35%   +0.24%  [.] f3                           [.] 0x000000000040059d
     1.42%   -0.22%  [.] f3                           [.] 0x00000000004005a1
    66.83%   +0.22%  [.] f3                           [.] 0x00000000004005a5
     1.29%   -0.12%  [.] f3                           [.] 0x00000000004005a7
     1.22%   -0.04%  [.] f3                           [.] 0x00000000004005a8
     0.00%           [k] load_balance                 [k] 0xffffffff810be7f6
     0.00%           [k] native_apic_mem_write        [k] 0xffffffff81077920
     0.00%           [k] native_write_msr_safe        [k] 0xffffffff8107d7ba
     0.00%           [k] native_write_msr_safe        [k] 0xffffffff8107d7bd
     0.00%           [k] rb_erase                     [k] 0xffffffff813346b1
                     [k] resched_curr                 [k] 0xffffffff810b4095
                     [k] restore_args                 [k] 0xffffffff8175a744
     0.00%           [k] run_timer_softirq            [k] 0xffffffff810e306f
                     [k] select_task_rq_fair          [k] 0xffffffff810bbab9
     0.00%           [k] select_task_rq_fair          [k] 0xffffffff810bbc89
                     [k] task_tick_fair               [k] 0xffffffff810bd286
     0.00%           [k] task_tick_fair               [k] 0xffffffff810bd40e
                     [k] task_waking_fair             [k] 0xffffffff810baf97
     0.00%           [k] try_to_wake_up               [k] 0xffffffff810b75e8
                     [k] update_cfs_rq_blocked_load   [k] 0xffffffff810bb129
     0.00%           [k] update_cpu_load_active       [k] 0xffffffff810ba08b
                     [k] update_group_capacity        [k] 0xffffffff810bdde0
                     [k] update_wall_time             [k] 0xffffffff810eac46


Changes from V1:
 - mmap2 as default of tool's definition
 - Using se_collapse to match symbol name.
 - Sort key "addr" is introduced to compare address from same binary.


Kan Liang (3):
  perf tool: Fix perf diff symble sort issue
  perf tool:perf diff support for different binaries
  perf tool: Add sort key addr for perf diff

 tools/perf/Documentation/perf-diff.txt |  7 +++++--
 tools/perf/builtin-diff.c              |  3 ++-
 tools/perf/util/hist.c                 |  5 +++--
 tools/perf/util/hist.h                 |  1 +
 tools/perf/util/sort.c                 | 38 ++++++++++++++++++++++++++++++++++
 tools/perf/util/sort.h                 |  2 ++
 6 files changed, 51 insertions(+), 5 deletions(-)

-- 
1.8.3.2


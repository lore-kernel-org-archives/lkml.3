Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaJSWFX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:05:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:25572 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbaJSWFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:05:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="402644422"
From: Kan Liang <kan.liang@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V6 00/17] perf, x86: Haswell LBR call stack support
Date: Sun, 19 Oct 2014 17:54:55 -0400
Message-Id: <1413755712-8259-1-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(The kernel part of haswell LBR call stack patch set is original from
Yan, Zheng. I only did some modification based on his work. The perf
tool part is from me. The patches have been tested on Haswell platform.)

For many profiling tasks we need the callgraph. For example we often
need to see the caller of a lock or the caller of a memcpy or other
library function to actually tune the program. Frame pointer unwinding
is efficient and works well. But frame pointers are off by default on
64bit code (and on modern 32bit gccs), so there are many binaries around
that do not use frame pointers. Profiling unchanged production code is
very useful in practice. On some CPUs frame pointer also has a high
cost. Dwarf2 unwinding also does not always work and is extremely slow
(upto 20% overhead).

Haswell has a new feature that utilizes the existing Last Branch Record
facility to record call chains. When the feature is enabled, function
call will be collected as normal, but as return instructions are
executed the last captured branch record is popped from the on-chip LBR
registers. The LBR call stack facility provides an alternative to get
callgraph. It has some limitations too, but should work in most cases
and is significantly faster than dwarf. Frame pointer unwinding is still
the best default, but LBR call stack is a good alternative when nothing
else works.

In the implementation, both Frame pointer and LBR call stack data are
collected by kernel, and expose to user space. The frame pointer is
still output as PERF_SAMPLE_CALLCHAIN data format. The LBR call stack
data will be output as PERF_SAMPLE_BRANCH_STACK data format. A callahain
source extension of perf report call-graph option is introduced. So user
can choose call chain from either FP or LBR call stack.

When profiling bc(1) on Fedora 19:
echo 'scale=2000; 4*a(1)' > cmd; perf record --call-graph fp bc -l < cmd
If this feature is enabled, perf report with lbr output looks like:
    50.36%       bc  bc                 [.] bc_divide
                 |
                 --- bc_divide
                     execute
                     run_code
                     yyparse
                     main
                     __libc_start_main
                     _start
    33.66%       bc  bc                 [.] _one_mult
                 |
                 --- _one_mult
                     bc_divide
                     execute
                     run_code
                     yyparse
                     main
                     __libc_start_main
                     _start
     7.62%       bc  bc                 [.] _bc_do_add
                 |
                 --- _bc_do_add
                    |
                    |--99.89%-- 0x2000186a8
                     --0.11%-- [...]
     6.83%       bc  bc                 [.] _bc_do_sub
                 |
                 --- _bc_do_sub
                    |
                    |--99.94%-- bc_add
                    |          execute
                    |          run_code
                    |          yyparse
                    |          main
                    |          __libc_start_main
                    |          _start
                     --0.06%-- [...]
     0.46%       bc  libc-2.17.so       [.] __memset_sse2
                 |
                 --- __memset_sse2
                    |
                    |--54.13%-- bc_new_num
                    |          |
                    |          |--51.00%-- bc_divide
                    |          |          execute
                    |          |          run_code
                    |          |          yyparse
                    |          |          main
                    |          |          __libc_start_main
                    |          |          _start
                    |          |
                    |          |--30.46%-- _bc_do_sub
                    |          |          bc_add
                    |          |          execute
                    |          |          run_code
                    |          |          yyparse
                    |          |          main
                    |          |          __libc_start_main
                    |          |          _start
                    |          |
                    |           --18.55%-- _bc_do_add
                    |                     bc_add
                    |                     execute
                    |                     run_code
                    |                     yyparse
                    |                     main
                    |                     __libc_start_main
                    |                     _start
                    |
                     --45.87%-- bc_divide
                               execute
                               run_code
                               yyparse
                               main
                               __libc_start_main
                               _start
If this feature is disabled, perf report output looks like:
    50.49%       bc  bc                 [.] bc_divide
                 |
                 --- bc_divide
    33.57%       bc  bc                 [.] _one_mult
                 |
                 --- _one_mult
     7.61%       bc  bc                 [.] _bc_do_add
                 |
                 --- _bc_do_add
                     0x2000186a8
     6.88%       bc  bc                 [.] _bc_do_sub
                 |
                 --- _bc_do_sub
     0.42%       bc  libc-2.17.so       [.] __memcpy_ssse3_back
                 |
                 --- __memcpy_ssse3_back

Another example is to demo the extension of perf report.
If both fp and lbr are available, we can dump either them by fp or lbr
option as below.

$ perf record --call-graph fp ./a.out
[ perf record: Woken up 18 times to write data ]
[ perf record: Captured and wrote 4.322 MB perf.data (~188824 samples) ]

$ perf report --call-graph fractal,0.5,callee,function,fp -D | wc -l
605688
$ perf report --call-graph fractal,0.5,callee,function,lbr -D | wc -l
605730

The LBR call stack has following known limitations
 - Zero length calls are not filtered out by hardware
 - Exception handing such as setjmp/longjmp will have calls/returns not
   match
 - Pushing different return address onto the stack will have calls/returns
   not match
 - If callstack is deeper than the LBR, only the last entries are captured

Changes since v1
 - split change into more patches
 - introduce context switch callback and use it to flush LBR
 - use the context switch callback to save/restore LBR
 - dynamic allocate memory area for storing LBR stack, always switch the
   memory area during context switch
 - disable this feature by default
 - more description in change logs

Changes since v2
 - don't use xchg to switch PMU specific data
 - remove nr_branch_stack from struct perf_event_context
 - simplify the save/restore LBR stack logical
 - remove unnecessary 'has_branch_stack -> needs_branch_stack'
   conversion
 - more description in change logs

Changes since v3
 - remove sysfs attribute file that disable this feature

Changes since v4
 - re-organize code that save/resotre LBR stack
 - allocate pmu specific data when it's needed
 - update code comments

Changes since v5
 - Expose LBR call stack data to user perf tool
 - Add option for perf report to support LBR call stack
 - Some minor changes according to comments


Yan, Zheng (15):
  perf, x86: Reduce lbr_sel_map size
  perf, core: introduce pmu context switch callback
  perf, x86: use context switch callback to flush LBR stack
  perf, x86: Basic Haswell LBR call stack support
  perf, core: pmu specific data for perf task context
  perf, core: always switch pmu specific data during context switch
  perf, x86: allocate space for storing LBR stack
  perf, x86: track number of events that use LBR callstack
  perf, x86: Save/resotre LBR stack during context switch
  perf, core: simplify need branch stack check
  perf, core: expose LBR call stack to user perf tool
  perf, x86: re-organize code that implicitly enables LBR/PEBS
  perf, x86: enable LBR callstack when recording callchain
  perf, x86: disable FREEZE_LBRS_ON_PMI when LBR operates in callstack  
      mode
  perf, x86: Discard zero length call entries in LBR call stack

Kan Liang (2):
  perf tools: handle LBR call stack data
  perf tools: choose to dump callchain from LBR and FP

 arch/x86/kernel/cpu/perf_event.c           |  90 ++++++---
 arch/x86/kernel/cpu/perf_event.h           |  28 ++-
 arch/x86/kernel/cpu/perf_event_intel.c     |  38 +---
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |   2 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 310 ++++++++++++++++++++++-------
 include/linux/perf_event.h                 |  34 +++-
 include/uapi/linux/perf_event.h            |  49 +++--
 kernel/events/callchain.c                  |   1 +
 kernel/events/core.c                       | 200 +++++++++++--------
 tools/perf/builtin-report.c                |   8 +-
 tools/perf/util/callchain.c                |  18 +-
 tools/perf/util/callchain.h                |   6 +
 tools/perf/util/event.h                    |   8 +
 tools/perf/util/evsel.c                    |  21 +-
 tools/perf/util/machine.c                  | 198 ++++++++++++------
 tools/perf/util/session.c                  |  34 +++-
 16 files changed, 728 insertions(+), 317 deletions(-)

-- 
1.8.3.2


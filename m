Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaKFPJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:09:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:37493 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbaKFPJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:09:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,326,1413270000"; 
   d="scan'208";a="627701758"
From: Kan Liang <kan.liang@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, jolsa@redhat.com, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V8 00/14] perf, x86: Haswell LBR call stack support (kernel)
Date: Thu,  6 Nov 2014 09:54:17 -0500
Message-Id: <1415285671-16894-1-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the kernel patch. 
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

A new call chain recording option "lbr" is introduced into perf tool for
LBR call stack. The user can use --call-graph lbr to get the call stack
information from hardware.

When profiling bc(1) on Fedora 19:
echo 'scale=2000; 4*a(1)' > cmd; perf record --call-graph lbr bc -l < cmd
If enabling LBR, perf report output looks like:
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
If using FP, perf report output looks like:
echo 'scale=2000; 4*a(1)' > cmd; perf record --call-graph fp bc -l < cmd
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

Changes since v6
 - rebase on tip.git 05066a2a04
 - Modify perf test accordingly

Changes since v7
 - LBR call stack as the 3rd callchain options
 - Only include kernel patch

Yan, Zheng (13):
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
  perf, x86: re-organize code that implicitly enables LBR/PEBS
  perf, x86: disable FREEZE_LBRS_ON_PMI when LBR operates in callstack  
      mode
  perf, x86: Discard zero length call entries in LBR call stack

Peter Zijlstra (Intel) (1):
  perf, x86: expose LBR callstack to user space tool

 arch/x86/kernel/cpu/perf_event.c           |  71 +++----
 arch/x86/kernel/cpu/perf_event.h           |  20 +-
 arch/x86/kernel/cpu/perf_event_intel.c     |  36 +---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 307 ++++++++++++++++++++++-------
 include/linux/perf_event.h                 |  21 +-
 include/uapi/linux/perf_event.h            |  47 +++--
 kernel/events/core.c                       | 178 +++++++++--------
 7 files changed, 451 insertions(+), 229 deletions(-)

-- 
1.8.3.2


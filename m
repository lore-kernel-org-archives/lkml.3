Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbaKMAdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 19:33:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:14182 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117AbaKMAdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 19:33:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="415729784"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com, a.p.zijlstra@chello.nl,
        eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com, Kan Liang <kan.liang@intel.com>
Subject: [PATCH V2 0/3] perf tool: Haswell LBR call stack support (user)
Date: Wed, 12 Nov 2014 19:18:12 -0500
Message-Id: <1415837895-10275-1-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

This is the user space patch for Haswell LBR call stack support.
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

If using LBR, perf report -D output looks like:
11739295893248 0x4d0 [0xe0]: PERF_RECORD_SAMPLE(IP, 0x2): 10505/10505:
0x40054d period: 39255 addr: 0
... LBR call chain: nr:7
.....  0: fffffffffffffe00
.....  1: 0000000000400540
.....  2: 0000000000400587
.....  3: 00000000004005b3
.....  4: 00000000004005ef
.....  5: 0000003d1cc21b43
.....  6: 0000000000400474
... FP chain: nr:6
.....  0: fffffffffffffe00
.....  1: 000000000040054d
.....  2: 000000000040058c
.....  3: 00000000004005b8
.....  4: 00000000004005f4
.....  5: 0000003d1cc21b45
 ... thread: a.out:10505
 ...... dso: /home/lk/a.out


The LBR call stack has following known limitations
 - Zero length calls are not filtered out by hardware
 - Exception handing such as setjmp/longjmp will have calls/returns not
   match
 - Pushing different return address onto the stack will have calls/returns
   not match
 - If callstack is deeper than the LBR, only the last entries are captured

Changes since v1
 - Update help document
 - Force exclude_user to 0 with warning in LBR call stack
 - Dump both lbr and fp info when report -D
 - Reconstruct thread__resolve_callchain_sample and split it into two patches
 - Use has_branch_callstack function to check LBR call stack available



Kan Liang (3):
  perf tools: enable LBR call stack support
  perf tool: re-organize thread__resolve_callchain_sample
  perf tools: Construct LBR call chain

 tools/perf/Documentation/perf-record.txt |  10 +-
 tools/perf/builtin-record.c              |   6 +-
 tools/perf/builtin-report.c              |   2 +
 tools/perf/util/callchain.c              |  10 +-
 tools/perf/util/callchain.h              |   1 +
 tools/perf/util/evsel.c                  |  21 +++-
 tools/perf/util/evsel.h                  |   4 +
 tools/perf/util/machine.c                | 176 +++++++++++++++++++++----------
 tools/perf/util/session.c                |  56 ++++++++--
 9 files changed, 216 insertions(+), 70 deletions(-)

-- 
1.8.3.2


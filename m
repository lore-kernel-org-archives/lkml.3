Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaKFPNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:13:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:35147 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbaKFPNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:13:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,326,1413270000"; 
   d="scan'208";a="632672587"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com, a.p.zijlstra@chello.nl,
        eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com, Kan Liang <kan.liang@intel.com>
Subject: [PATCH 0/2] perf tool: Haswell LBR call stack support (user)
Date: Thu,  6 Nov 2014 09:58:04 -0500
Message-Id: <1415285886-16949-1-git-send-email-kan.liang@intel.com>
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

The LBR call stack has following known limitations
 - Zero length calls are not filtered out by hardware
 - Exception handing such as setjmp/longjmp will have calls/returns not
   match
 - Pushing different return address onto the stack will have calls/returns
   not match
 - If callstack is deeper than the LBR, only the last entries are captured

Kan Liang (2):
  perf tools: enable LBR call stack support
  perf tools: Construct LBR call chain

 tools/perf/builtin-record.c |   6 +-
 tools/perf/builtin-report.c |   2 +
 tools/perf/util/callchain.c |   8 ++
 tools/perf/util/callchain.h |   1 +
 tools/perf/util/evsel.c     |  15 +++-
 tools/perf/util/machine.c   | 194 +++++++++++++++++++++++++++++---------------
 tools/perf/util/session.c   |  41 ++++++++--
 7 files changed, 190 insertions(+), 77 deletions(-)

-- 
1.8.3.2


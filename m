Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbaBRGHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 01:07:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:48812 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117AbaBRGHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 01:07:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,500,1389772800"; 
   d="scan'208";a="483239630"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v3 00/14] perf, x86: Haswell LBR call stack support
Date: Tue, 18 Feb 2014 14:07:27 +0800
Message-Id: <1392703661-15104-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

This patch series adds LBR call stack support. User can enabled/disable
this through an sysfs attribute file in the CPU PMU directory:
 echo 1 > /sys/bus/event_source/devices/cpu/lbr_callstack 

When profiling bc(1) on Fedora 19:
 echo 'scale=2000; 4*a(1)' > cmd; perf record -g fp bc -l < cmd

If this feature is enabled, perf report output looks like:
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



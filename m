Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbbAEStX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:49:23 -0500
Received: from mga14.intel.com ([192.55.52.115]:5230 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbbAEStW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 13:49:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,701,1413270000"; 
   d="scan'208";a="646577660"
From: kan.liang@intel.com
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, acme@kernel.org, jolsa@redhat.com,
        eranian@google.com, mingo@redhat.com, paulus@samba.org,
        ak@linux.intel.com, namhyung@kernel.org,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V6 0/2] perf tool: Haswell LBR call stack support (user)
Date: Mon,  5 Jan 2015 13:23:03 -0500
Message-Id: <1420482185-29830-1-git-send-email-kan.liang@intel.com>
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

Please find the kernel part patch at https://lkml.org/lkml/2014/11/6/432

Changes since v1
 - Update help document
 - Force exclude_user to 0 with warning in LBR call stack
 - Dump both lbr and fp info when report -D
 - Reconstruct thread__resolve_callchain_sample and split it into two patches
 - Use has_branch_callstack function to check LBR call stack available

Changes since v2
 - Rebase to 025ce5d33373

Changes since v3
 - Rebase to cc502c23aadf
 - Separated function for lbr call stack sample resolve and print
 - Some minor changes according to comments

Changes since V4
 - Rebase to 09a6a1b
 - Falling back to framepointers if LBR not availabe, and warning user

Changes since V5
 - Only remove the 2/3 and part of 1/3 which have already been merged.

Kan Liang (2):
  perf tools: enable LBR call stack support
  perf tools: Construct LBR call chain

 tools/perf/Documentation/perf-record.txt |   8 ++-
 tools/perf/builtin-record.c              |   6 +-
 tools/perf/builtin-report.c              |   2 +
 tools/perf/util/callchain.c              |   8 +++
 tools/perf/util/callchain.h              |   1 +
 tools/perf/util/evsel.c                  |  21 ++++++-
 tools/perf/util/evsel.h                  |   4 ++
 tools/perf/util/machine.c                | 102 +++++++++++++++++++++++++++----
 tools/perf/util/session.c                |  64 +++++++++++++++++--
 9 files changed, 193 insertions(+), 23 deletions(-)

-- 
1.8.3.2


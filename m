Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbaCRP4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:56:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbaCRP4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:56:38 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 0/6] perf tools: Share map groups within process
Date: Tue, 18 Mar 2014 15:46:50 +0100
Message-Id: <1395154016-26709-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
this patchset moves thread's map_groups to be dynamically
allocated and shared within process threads.

The main benefit would be to be able to look up memory
map from any thread that belongs to the process.

This implements one of the solution ideas for issue
described by Don in following thread:
http://marc.info/?l=linux-kernel&m=139403876017159&w=2

RFC changes:
  - added automated test for thread map groups get/put methods
  - fix reference count for case described by Namhyung
  - rename the mmap-events.c test to mmap-thread-lookup.c
  - added PROT_EXEC to mmap call in tests/mmap-thread-lookup.c
    as it's not implied by default on all archs (Namhyung)
  - lazy mg allocation in thread__find_addr_map (Namhyung)
  - fix compilation failures (Arnaldo)

also available in here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/core_mmaps

thanks,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
Jiri Olsa (6):
      perf tests: Add thread maps lookup automated tests
      perf tools: Remove thread__find_map function
      perf tools: Allocate thread map_groups dynamically
      perf tools: Add machine pointer into thread struct
      perf tools: Share process map groups within process threads
      perf tests: Add map groups sharing with thread object test

 tools/perf/Makefile.perf                 |   2 +
 tools/perf/arch/x86/tests/dwarf-unwind.c |   9 +++-
 tools/perf/perf.h                        |   6 +++
 tools/perf/tests/builtin-test.c          |   8 ++++
 tools/perf/tests/mmap-thread-lookup.c    | 233 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h                 |   2 +
 tools/perf/tests/thread-mg-share.c       | 110 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/ui/stdio/hist.c               |   9 +++-
 tools/perf/util/event.c                  |  10 +++-
 tools/perf/util/machine.c                |   8 ++--
 tools/perf/util/map.h                    |   3 +-
 tools/perf/util/thread.c                 | 120 +++++++++++++++++++++++++++++++++++++++++-----
 tools/perf/util/thread.h                 |  19 ++++----
 13 files changed, 508 insertions(+), 31 deletions(-)
 create mode 100644 tools/perf/tests/mmap-thread-lookup.c
 create mode 100644 tools/perf/tests/thread-mg-share.c

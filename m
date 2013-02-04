Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab3BDMd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:33:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab3BDMdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 07:33:24 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 00/11] perf tool: Add PERF_SAMPLE_READ sample read support
Date: Mon,  4 Feb 2013 13:32:54 +0100
Message-Id: <1359981185-16819-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding support to read sample values through the PERF_SAMPLE_READ
sample type. It's now possible to specify 'S' modifier for an event
and get its sample value by PERF_SAMPLE_READ.

For group the 'S' modifier will enable sampling only for the leader
and read all the group member by PERF_SAMPLE_READ smple type with
PERF_FORMAT_GROUP read format.

This was first introduced in here:
https://lkml.org/lkml/2012/10/20/75

Example:

  $ perf record -e '{cycles,cache-misses}:S' ls
  ...
  $ perf report --group --show-total-period --stdio
  ...
  # Samples: 36  of event 'anon group { cycles, cache-misses }'
  # Event count (approx.): 12585593
  #
  #         Overhead                    Period  Command      Shared Object                      Symbol
  # ................  ........................  .......  .................  ..........................
  #
      19.92%   1.20%       2505936          31       ls  [kernel.kallsyms]  [k] mark_held_locks
      13.74%   0.47%       1729327          12       ls  [kernel.kallsyms]  [k] sched_clock_local
      13.64%  23.72%       1716147         612       ls  ld-2.14.90.so      [.] check_match.10805
      13.12%  23.22%       1650778         599       ls  libc-2.14.90.so    [.] _nl_intern_locale_data
      11.24%  29.19%       1414554         753       ls  [kernel.kallsyms]  [k] sched_clock_cpu
       8.50%   0.35%       1070150           9       ls  [kernel.kallsyms]  [k] check_chain_key
  ...


The patchset is based on following fix:
http://lkml.org/lkml/2013/2/4/122

and is available also at:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
perf/group6

TODO: add column names as suggested by Ingo in the original discussion.

thanks,
jirka


Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
Jiri Olsa (11):
      perf ui/hist: Add support to display whole group data for raw columns
      perf: Add PERF_EVENT_IOC_ID ioctl to return event ID
      perf: Do not get values from disabled counters in group format read
      perf tools: Use PERF_EVENT_IOC_ID perf ioctl to read event id
      perf tools: Add support for parsing PERF_SAMPLE_READ sample type
      perf tools: Fix event ID retrieval for group format read case
      perf tools: Add perf_evlist__id2sid function to get event ID related data
      perf tools: Add PERF_SAMPLE_READ sample related processing
      perf tools: Add 'S' event/group modifier to read sample value
      perf tests: Add attr record group sampling test
      perf tests: Add parse events tests for leader sampling

 include/uapi/linux/perf_event.h                  |   1 +
 kernel/events/core.c                             |  12 ++++++++-
 tools/perf/Documentation/perf-list.txt           |   1 +
 tools/perf/tests/attr/test-record-group-sampling |  36 ++++++++++++++++++++++++++
 tools/perf/tests/parse-events.c                  | 115 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/ui/hist.c                             |  53 +++++++++++++++++++-------------------
 tools/perf/util/event.h                          |  18 +++++++++++++
 tools/perf/util/evlist.c                         |  73 +++++++++++++++++++++++++++++++++++++++++++++++-----
 tools/perf/util/evlist.h                         |   4 +++
 tools/perf/util/evsel.c                          |  59 ++++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/evsel.h                          |   4 +++
 tools/perf/util/parse-events.c                   |   8 +++++-
 tools/perf/util/parse-events.l                   |   2 +-
 tools/perf/util/session.c                        | 110 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 14 files changed, 457 insertions(+), 39 deletions(-)

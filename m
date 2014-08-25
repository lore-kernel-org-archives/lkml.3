Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbaHYOq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:46:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536AbaHYOqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:46:20 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [RFCv2 0/9] perf: Allow leader sampling on inherited events
Date: Mon, 25 Aug 2014 16:45:34 +0200
Message-Id: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
Jen-Cheng(Tommy) Huang reported the leader sampling not working
on children processes:
  http://www.mail-archive.com/linux-perf-users@vger.kernel.org/msg01644.html

The leader sampling (example below) lets the group leader event (cycles)
do the sampling and reads the rest of the group (cache-misses) via
PERF_FORMAT_GROUP format.

Example:
  $ perf record -e '{cycles,cache-misses}:S' <workload>
  $ perf report --group

  The perf report --group allows to see all events group
  data in single view.

The reason for leader sampling being switched off for inherited
events, is that the kernel does no allow PERF_FORMAT_GROUP format
on inherited events (which is used by leader sampling).

I switched on the PERF_FORMAT_GROUP format for inherited events
with few other fixies in patches:
  perf: Deny optimized switch for events read by PERF_SAMPLE_READ
  perf: Allow PERF_FORMAT_GROUP format on inherited events

And I fixed perf tool code to be able to process data from
children processes.

Anyway, I might have missed some other reason why this was
never switched on in kernel, so sending this as RFC.

v2 changes:
   - detection of the kernel support
   - added perf script support for period column
   - separate kernel change for context_equiv change

thanks for comments,
jirka


Reported-by: Jen-Cheng(Tommy) Huang <tommy24@gatech.edu>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jen-Cheng(Tommy) Huang <tommy24@gatech.edu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
Jiri Olsa (9):
      perf: Remove redundant parent context check from context_equiv
      perf: Deny optimized switch for events read by PERF_SAMPLE_READ
      perf: Allow PERF_FORMAT_GROUP format on inherited events
      perf tools: Add support to traverse xyarrays
      perf tools: Add pr_warning_once debug macro
      perf tools: Add hash of periods for struct perf_sample_id
      perf tools: Allow PERF_FORMAT_GROUP for inherited events
      perf script: Add period data column
      perf script: Add period as a default output column

 kernel/events/core.c                     | 33 ++++++++++++++------------------
 tools/perf/Documentation/perf-script.txt |  2 +-
 tools/perf/Makefile.perf                 |  1 +
 tools/perf/builtin-script.c              | 21 +++++++++++++++++----
 tools/perf/perf.h                        |  1 +
 tools/perf/tests/builtin-test.c          |  4 ++++
 tools/perf/tests/tests.h                 |  1 +
 tools/perf/tests/xyarray.c               | 33 ++++++++++++++++++++++++++++++++
 tools/perf/util/debug.h                  | 12 ++++++++++++
 tools/perf/util/evsel.c                  | 19 ++++++++++++++++++-
 tools/perf/util/evsel.h                  |  5 ++++-
 tools/perf/util/record.c                 | 12 ++++++++++++
 tools/perf/util/session.c                | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 tools/perf/util/xyarray.c                |  4 +++-
 tools/perf/util/xyarray.h                |  6 ++++++
 15 files changed, 214 insertions(+), 33 deletions(-)
 create mode 100644 tools/perf/tests/xyarray.c

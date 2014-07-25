Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbaGYO4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:56:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbaGYO4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:56:35 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCHv4 00/19] perf tools: Factor ordered samples queue
Date: Fri, 25 Jul 2014 16:55:58 +0200
Message-Id: <1406300177-31805-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
this patchset factors session's ordered samples queue,
and allows to limit the size of this queue.

v4 changes:
  - split patch 17 into 2 patches (17/18 now) (Arnaldo)
  - omitted patch 18 which set default queue value to 100MB (Adrian)
  - factor patch 16 to display better debug messages (Adrian)

v3 changes:
  - rebased to latest tip/perf/core
  - add comment for WARN in patch 8 (David)
  - added ordered-events debug variable (David)
  - renamed ordered_events_(get|put) to ordered_events_(new|delete)
  - renamed struct ordered_events_queue to struct ordered_events

v2 changes:
  - several small changes for review comments (Namhyung)


The report command queues events till any of following
conditions is reached:
  - PERF_RECORD_FINISHED_ROUND event is processed
  - end of the file is reached

Any of above conditions will force the queue to flush some
events while keeping all allocated memory for next events.

If PERF_RECORD_FINISHED_ROUND is missing the queue will
allocate memory for every single event in the perf.data.
This could lead to enormous memory consuption and speed
degradation of report command for huge perf.data files.

With the quue allocation limit of 100 MB, I've got around
15% speedup on reporting of ~10GB perf.data file.

current code:
 Performance counter stats for './perf.old report --stdio -i perf-test.data' (3 runs):

   621,685,704,665      cycles                    ( +-  0.52% )
   873,397,467,969      instructions              ( +-  0.00% )

     286.133268732 seconds time elapsed           ( +-  1.13% )

with patches:
 Performance counter stats for './perf report --stdio -i perf-test.data' (3 runs):

   603,933,987,185      cycles                    ( +-  0.45% )
   869,139,445,070      instructions              ( +-  0.00% )

     245.337510637 seconds time elapsed           ( +-  0.49% )


The speed up seems to be mainly in less cycles spent in servicing
page faults:

current code:
     4.44%     0.01%  perf.old  [kernel.kallsyms]   [k] page_fault                                   

with patches:
     1.45%     0.00%      perf  [kernel.kallsyms]   [k] page_fault                                   

current code (faults event):
         6,643,807      faults                    ( +-  0.36% )

with patches (faults event):
         2,214,756      faults                    ( +-  3.03% )


Also now we have one of our big memory spender under control
and the ordered events queue code is put in separated object
with clear interface ready to be used by another command
like script.

Also reachable in here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/core_ordered_events

thanks,
jirka


Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
Jiri Olsa (19):
      perf tools: Fix accounting of ordered samples queue
      perf tools: Rename ordered_samples bool to ordered_events
      perf tools: Rename ordered_samples struct to ordered_events
      perf tools: Rename ordered_events members
      perf tools: Add ordered_events_(new|delete) interface
      perf tools: Factor ordered_events_flush to be more generic
      perf tools: Limit ordered events queue size
      perf tools: Flush ordered events in case of allocation failure
      perf tools: Make perf_session_deliver_event global
      perf tools: Create ordered-events object
      perf tools: Use list_move in ordered_events_delete function
      perf tools: Add ordered_events_init function
      perf tools: Add ordered_events_free function
      perf tools: Add perf_config_u64 function
      perf tools: Add report.queue-size config file option
      perf tools: Add debug prints for ordered events queue
      perf tools: Always force PERF_RECORD_FINISHED_ROUND event
      perf tools: Store PERF_RECORD_FINISHED_ROUND only for nonempty rounds
      perf tools: Allow out of order messages in forced flush

 tools/perf/Makefile.perf         |   2 +
 tools/perf/builtin-annotate.c    |   2 +-
 tools/perf/builtin-diff.c        |   2 +-
 tools/perf/builtin-inject.c      |   2 +-
 tools/perf/builtin-kmem.c        |   2 +-
 tools/perf/builtin-kvm.c         |   8 ++--
 tools/perf/builtin-lock.c        |   2 +-
 tools/perf/builtin-mem.c         |   2 +-
 tools/perf/builtin-record.c      |   7 ++-
 tools/perf/builtin-report.c      |  15 +++++-
 tools/perf/builtin-sched.c       |   2 +-
 tools/perf/builtin-script.c      |   2 +-
 tools/perf/builtin-timechart.c   |   2 +-
 tools/perf/builtin-trace.c       |   2 +-
 tools/perf/util/cache.h          |   1 +
 tools/perf/util/config.c         |  24 ++++++++++
 tools/perf/util/debug.c          |  36 ++++++++++++++-
 tools/perf/util/debug.h          |   8 ++++
 tools/perf/util/ordered-events.c | 245 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/ordered-events.h |  51 +++++++++++++++++++++
 tools/perf/util/session.c        | 217 ++++++++++++++++----------------------------------------------------------------------
 tools/perf/util/session.h        |  26 ++++-------
 tools/perf/util/tool.h           |   2 +-
 23 files changed, 448 insertions(+), 214 deletions(-)
 create mode 100644 tools/perf/util/ordered-events.c
 create mode 100644 tools/perf/util/ordered-events.h

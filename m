Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab3GDNOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:14:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:61212 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab3GDNOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:14:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,995,1363158000"; 
   d="scan'208";a="264087758"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V4 00/15] perf tools: some fixes and tweaks
Date: Thu,  4 Jul 2013 16:20:19 +0300
Message-Id: <1372944040-32690-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are some fixes and tweaks to perf tools (version 4).

I have added kernel support for matching sample types via
PERF_SAMPLE_IDENTIFIER.  perf tools support for that required
first fixing some other things.

Changes in V4:
	perf tools: fix parse_events_terms() freeing local variable on error path
		Dropped - covered by David Ahern
	perf tools: struct thread has a tid not a pid
		Added ack by David Ahern
	perf tools: add pid to struct thread
		Remove unused function
	perf tools: fix missing increment in sample parsing
		New patch
	perf tools: tidy up sample parsing overflow checking
		New patch
	perf tools: remove unnecessary callchain validation
		New patch
	perf tools: remove references to struct ip_event
		New patch
	perf tools: move struct ip_event
		New patch
	perf: make events stream always parsable
		New patch
	perf tools: add support for PERF_SAMPLE_IDENTFIER
		New patch

Changes in V3:
	perf tools: add pid to struct thread
		Split into 2 patches
	perf tools: fix ppid in thread__fork()
		Dropped for now

Changes in V2:
	perf tools: fix missing tool parameter
		Fixed one extra occurrence
	perf tools: fix parse_events_terms() freeing local variable on error path
		Made "freeing" code into a new function
	perf tools: validate perf event header size
		Corrected byte-swapping
	perf tools: allow non-matching sample types
		Added comments
		Fixed id_pos calculation
		id_pos/is_pos updated whenever sample_type changes
		Removed perf_evlist__sample_type()
		Added __perf_evlist__combined_sample_type()
		Added perf_evlist__combined_sample_type()
		Added perf_evlist__make_sample_types_compatible()
	Added ack's to patches acked by Jiri Olsa


Adrian Hunter (21):
      perf tools: remove unused parameter
      perf tools: fix missing tool parameter
      perf tools: fix missing 'finished_round'
      perf tools: fix parse_events_terms() segfault on error path
      perf tools: fix new_term() missing free on error path
      perf tools: add const specifier to perf_pmu__find name parameter
      perf tools: tidy duplicated munmap code
      perf tools: validate perf event header size
      perf tools: add debug prints
      perf tools: fix symbol_conf.nr_events
      perf tools: allow non-matching sample types
      perf tools: struct thread has a tid not a pid
      perf tools: add pid to struct thread
      perf tools: change "machine" functions to set thread pid
      perf tools: fix missing increment in sample parsing
      perf tools: tidy up sample parsing overflow checking
      perf tools: remove unnecessary callchain validation
      perf tools: remove references to struct ip_event
      perf tools: move struct ip_event
      perf: make events stream always parsable
      perf tools: add support for PERF_SAMPLE_IDENTFIER

 include/uapi/linux/perf_event.h |   3 +-
 kernel/events/core.c            |  11 +-
 tools/perf/builtin-inject.c     |  44 ++++---
 tools/perf/builtin-kmem.c       |   4 +-
 tools/perf/builtin-mem.c        |   2 +-
 tools/perf/builtin-report.c     |   2 +-
 tools/perf/builtin-sched.c      |  12 +-
 tools/perf/builtin-script.c     |   2 +-
 tools/perf/builtin-top.c        |  10 +-
 tools/perf/builtin-trace.c      |   4 +-
 tools/perf/tests/hists_link.c   |  27 ++++-
 tools/perf/tests/mmap-basic.c   |   2 +-
 tools/perf/ui/browsers/hists.c  |   6 +-
 tools/perf/util/build-id.c      |   6 +-
 tools/perf/util/callchain.c     |   8 --
 tools/perf/util/callchain.h     |   5 -
 tools/perf/util/event.c         |   6 +-
 tools/perf/util/event.h         |  30 +++--
 tools/perf/util/evlist.c        | 251 +++++++++++++++++++++++++++++++++++----
 tools/perf/util/evlist.h        |   9 +-
 tools/perf/util/evsel.c         | 256 +++++++++++++++++++++++++++++++++-------
 tools/perf/util/evsel.h         |  13 +-
 tools/perf/util/header.c        |   8 +-
 tools/perf/util/header.h        |   6 +-
 tools/perf/util/machine.c       |  47 +++++---
 tools/perf/util/machine.h       |   6 +-
 tools/perf/util/parse-events.c  |   4 +-
 tools/perf/util/pmu.c           |  14 +--
 tools/perf/util/pmu.h           |   2 +-
 tools/perf/util/session.c       |  58 ++++-----
 tools/perf/util/sort.c          |   6 +-
 tools/perf/util/thread.c        |  11 +-
 tools/perf/util/thread.h        |   5 +-
 tools/perf/util/tool.h          |   9 +-
 34 files changed, 658 insertions(+), 231 deletions(-)


Regards
Adrian

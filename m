Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaHKIug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:50:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbaHKIud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:50:33 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@kernel.org>
Subject: [RFC 00/20] perf: Finish sampling commands when events are closed
Date: Mon, 11 Aug 2014 10:49:54 +0200
Message-Id: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding support to quit sampling commands:
  record,top,trace,kvm stat live

when all the monitored events are closed, like following perf
command will now exit when monitored process (pid 1234) exits:

  $ perf record -p 1234

I added independent poller object to handle basic polling
tasks. I had to factor some parts, so sending this as RFC,
because I'm pretty sure I broke something else ;-)

The patch#1 is kernel change, which is needed for the
patchset to work properly. The current behavior stays
without this kernel change.

The code is based on latest Arnaldo's perf/core and
following kernel change:
  http://marc.info/?l=linux-kernel&m=140715910417130&w=2

The patchset is also reachable in here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/core_poll

thanks for comments,
jirka


Cc: Adrian Hunter <adrian.hunter@intel.com>
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
Jiri Olsa (20):
      perf: Add PERF_EVENT_STATE_EXIT state for events with exited task
      perf tools: Add poller object to handle polling globaly
      perf tests: Add poller object test
      perf tools: Add support to traverse xyarrays
      perf tools: Introduce perf_evsel__fd function
      perf tools: Add evlist/evsel poller object support
      perf record: Add support to see event's ERR and HUP poll errors
      perf tools: Add set_term_quiet_input helper function
      perf tui browser: Add interface to terminate browser from uotside
      perf top: Add support to see event's ERR and HUP poll errors
      perf top: Join the display thread on exit
      perf top: Use set_term_quiet_input for terminal input
      perf top: Setup signals for terminal output
      perf top: Use poller object for display thread stdin
      perf kvm: Fix stdin handling for 'kvm stat live' command
      perf kvm: Add support to see event's ERR and HUP poll errors
      perf trace: Add support to see event's ERR and HUP poll errors
      perf python: Use poller object for polling
      perf tests: Use poller object for polling
      perf tools: Remove pollfd stuff out of evlist object

 include/linux/perf_event.h                |   1 +
 kernel/events/core.c                      |  12 ++++-
 tools/perf/Makefile.perf                  |   4 ++
 tools/perf/builtin-kvm.c                  | 123 +++++++++++++++++++++++------------------------
 tools/perf/builtin-record.c               |  29 ++++++++++-
 tools/perf/builtin-report.c               |   3 +-
 tools/perf/builtin-top.c                  | 104 ++++++++++++++++++++++++++--------------
 tools/perf/builtin-trace.c                |  25 +++++++++-
 tools/perf/tests/builtin-test.c           |   8 ++++
 tools/perf/tests/open-syscall-tp-fields.c |   9 +++-
 tools/perf/tests/perf-record.c            |   4 --
 tools/perf/tests/poller.c                 | 126 ++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/task-exit.c              |   9 +++-
 tools/perf/tests/tests.h                  |   2 +
 tools/perf/tests/xyarray.c                |  33 +++++++++++++
 tools/perf/ui/browser.c                   |   4 +-
 tools/perf/ui/browser.h                   |   8 +++-
 tools/perf/ui/browsers/annotate.c         |   2 +-
 tools/perf/ui/browsers/header.c           |   2 +-
 tools/perf/ui/browsers/hists.c            |  39 ++++++++-------
 tools/perf/ui/browsers/map.c              |   2 +-
 tools/perf/ui/browsers/scripts.c          |   2 +-
 tools/perf/ui/keysyms.h                   |   1 +
 tools/perf/ui/tui/util.c                  |   2 +-
 tools/perf/util/evlist.c                  |  38 ++++++---------
 tools/perf/util/evlist.h                  |   7 ++-
 tools/perf/util/evsel.c                   |  21 +++++++-
 tools/perf/util/evsel.h                   |  10 ++++
 tools/perf/util/hist.h                    |   6 ++-
 tools/perf/util/kvm-stat.h                |   1 -
 tools/perf/util/poller.c                  | 233 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/poller.h                  |  88 ++++++++++++++++++++++++++++++++++
 tools/perf/util/python-ext-sources        |   2 +
 tools/perf/util/python.c                  |  19 ++++++--
 tools/perf/util/util.c                    |  13 +++++
 tools/perf/util/util.h                    |   2 +
 tools/perf/util/xyarray.c                 |   4 +-
 tools/perf/util/xyarray.h                 |   6 +++
 38 files changed, 832 insertions(+), 172 deletions(-)
 create mode 100644 tools/perf/tests/poller.c
 create mode 100644 tools/perf/tests/xyarray.c
 create mode 100644 tools/perf/util/poller.c
 create mode 100644 tools/perf/util/poller.h

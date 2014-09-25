Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaIYV6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 17:58:06 -0400
Received: from mail.kernel.org ([198.145.19.201]:43799 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbaIYV6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 17:58:04 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/14] perf tools polling fixes
Date: Thu, 25 Sep 2014 18:57:37 -0300
Message-Id: <1411682271-3771-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling into tip/perf/core.

Best Regards,

- Arnaldo

The following changes since commit 521e8bac67a71a6544274f39d5c61473e0e54ac0:

  perf/x86/intel/uncore: Update support for client uncore IMC PMU (2014-09-24 14:48:25 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-fdarray-for-mingo

for you to fetch changes up to 46fb3c21d20415dd2693570c33d0ea6eb8745e04:

  perf trace: Filter out POLLHUP'ed file descriptors (2014-09-25 16:46:56 -0300)

----------------------------------------------------------------
Infrastructure:

We were not handling POLLHUP notifications for event file descriptors.

Fix it by filtering entries in the events file descriptor array after
poll returns, refcounting mmaps so that when the last fd pointing to
a perf mmap goes away we do the unmap.

User visible:

Now 'record' and 'trace' properly exit when a target thread exits.

Arnaldo Carvalho de Melo (14):
  perf evlist: Introduce perf_evlist__filter_pollfd method
  perf tests: Add test for perf_evlist__filter_pollfd()
  perf evlist: Monitor POLLERR and POLLHUP events too
  perf evlist: We need to poll all event file descriptors
  perf evlist: Allow growing pollfd on add method
  perf tests: Add pollfd growing test
  perf kvm stat live: Use perf_evlist__add_pollfd() instead of local equivalent
  perf evlist: Introduce poll method for common code idiom
  tools lib api: Adopt fdarray class from perf's evlist
  perf evlist: Refcount mmaps
  tools lib fd array: Allow associating an integer cookie with each entry
  perf evlist: Unmap when all refcounts to fd are gone and events drained
  perf record: Filter out POLLHUP'ed file descriptors
  perf trace: Filter out POLLHUP'ed file descriptors

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (14):
      perf evlist: Introduce perf_evlist__filter_pollfd method
      perf tests: Add test for perf_evlist__filter_pollfd()
      perf evlist: Monitor POLLERR and POLLHUP events too
      perf evlist: We need to poll all event file descriptors
      perf evlist: Allow growing pollfd on add method
      perf tests: Add pollfd growing test
      perf kvm stat live: Use perf_evlist__add_pollfd() instead of local equivalent
      perf evlist: Introduce poll method for common code idiom
      tools lib api: Adopt fdarray class from perf's evlist
      perf evlist: Refcount mmaps
      tools lib fd array: Allow associating an integer cookie with each entry
      perf evlist: Unmap when all refcounts to fd are gone and events drained
      perf record: Filter out POLLHUP'ed file descriptors
      perf trace: Filter out POLLHUP'ed file descriptors

 tools/lib/api/Makefile                    |   7 +-
 tools/lib/api/fd/array.c                  | 127 ++++++++++++++++++++++
 tools/lib/api/fd/array.h                  |  46 ++++++++
 tools/perf/Makefile.perf                  |   3 +-
 tools/perf/builtin-kvm.c                  |  24 ++---
 tools/perf/builtin-record.c               |   9 +-
 tools/perf/builtin-top.c                  |   4 +-
 tools/perf/builtin-trace.c                |   7 +-
 tools/perf/tests/builtin-test.c           |   8 ++
 tools/perf/tests/fdarray.c                | 174 ++++++++++++++++++++++++++++++
 tools/perf/tests/open-syscall-tp-fields.c |   2 +-
 tools/perf/tests/perf-record.c            |   2 +-
 tools/perf/tests/task-exit.c              |   2 +-
 tools/perf/tests/tests.h                  |   2 +
 tools/perf/util/evlist.c                  | 105 +++++++++++++++---
 tools/perf/util/evlist.h                  |  16 ++-
 tools/perf/util/python.c                  |   6 +-
 17 files changed, 501 insertions(+), 43 deletions(-)
 create mode 100644 tools/lib/api/fd/array.c
 create mode 100644 tools/lib/api/fd/array.h
 create mode 100644 tools/perf/tests/fdarray.c

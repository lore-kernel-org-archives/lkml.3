Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaIJOJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:09:08 -0400
Received: from mail.kernel.org ([198.145.19.201]:38322 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbaIJOJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:09:05 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [RFC 00/14] perf pollfd v3
Date: Wed, 10 Sep 2014 11:08:35 -0300
Message-Id: <1410358129-9965-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Hi,

	Main different to what was discussed in v2[1]:

	Poll all event file descriptors, not just the ones mmaped.

	This is a bug that was present before, noticed by Adrian Hunter while
reviewing this patchkit, i.e. we were polling just the mmaped ones, because
then we would look at all the ring buffers when just one of the polled
descriptors was ready to read.

	But this could lead to delays in polling when one of the mmaped fds was
closed and we would then not be notified when another, associated to it by
means of PERF_EVENT_IOC_SET_OUTPUT, had events available.

	Also refcount the mmaps associated by means of PERF_EVENT_IOC_SET_OUTPUT,
so that we can properly unmap a ring buffer to which all its file descriptors
had been closed, for longer running apps.

	It is all available on my tree:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git perf/fdarray.v2

	I kept the v3 for the series as I initially called it pollfd, but since the
class that grew out of it was named fdarray, thus the fdarray.v2 branch name.

	Please let me know if there are still any other problems, now back to
fixing up my last perf/core pull req wrt those external proggies problems.

- Arnaldo

[1] http://lkml.kernel.org/r/1409781604-16778-1-git-send-email-acme@kernel.org

Arnaldo Carvalho de Melo (14):
  perf evlist: Introduce perf_evlist__filter_pollfd method
  perf tests: Add test for perf_evlist__filter_pollfd()
  perf evlist: Monitor POLLERR and POLLHUP events too
  perf evlist: We need to poll all event file descriptors
  perf record: Filter out POLLHUP'ed file descriptors
  perf trace: Filter out POLLHUP'ed file descriptors
  perf evlist: Allow growing pollfd on add method
  perf tests: Add pollfd growing test
  perf kvm stat live: Use perf_evlist__add_pollfd() instead of local equivalent
  perf evlist: Introduce poll method for common code idiom
  tools lib api: Adopt fdarray class from perf's evlist
  perf evlist: Refcount mmaps
  tools lib fd array: Allow associating an integer cookie with each entry
  perf evlist: Unmap ring buffer when fd is nuked

 tools/lib/api/Makefile                    |   7 +-
 tools/lib/api/fd/array.c                  | 128 ++++++++++++++++++
 tools/lib/api/fd/array.h                  |  34 +++++
 tools/perf/Makefile.perf                  |   1 +
 tools/perf/builtin-kvm.c                  |  24 ++--
 tools/perf/builtin-record.c               |   5 +-
 tools/perf/builtin-top.c                  |   4 +-
 tools/perf/builtin-trace.c                |   3 +-
 tools/perf/tests/builtin-test.c           |   8 ++
 tools/perf/tests/evlist.c                 | 217 ++++++++++++++++++++++++++++++
 tools/perf/tests/open-syscall-tp-fields.c |   2 +-
 tools/perf/tests/perf-record.c            |   2 +-
 tools/perf/tests/task-exit.c              |   2 +-
 tools/perf/tests/tests.h                  |   2 +
 tools/perf/util/evlist.c                  |  77 +++++++++--
 tools/perf/util/evlist.h                  |  16 ++-
 tools/perf/util/python.c                  |   6 +-
 17 files changed, 499 insertions(+), 39 deletions(-)
 create mode 100644 tools/lib/api/fd/array.c
 create mode 100644 tools/lib/api/fd/array.h
 create mode 100644 tools/perf/tests/evlist.c

-- 
1.9.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaIJOJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:09:27 -0400
Received: from mail.kernel.org ([198.145.19.201]:38380 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbaIJOJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:09:23 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/14] perf tests: Add test for perf_evlist__filter_pollfd()
Date: Wed, 10 Sep 2014 11:08:37 -0300
Message-Id: <1410358129-9965-3-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410358129-9965-1-git-send-email-acme@kernel.org>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

That will use a synthetic evlist with just what is touched by this new
method to check that it works as expected.

Output in verbose mode:

  $ perf test -v pollfd
  33: Filter fds with revents mask in a pollfd array         :
  --- start ---
  filtering all but pollfd[2]:
  before:   5 [ 5, 4, 3, 2, 1 ]
   after:   1 [ 3 ]
  filtering all but (pollfd[0], pollfd[3]):
  before:   5 [ 5, 4, 3, 2, 1 ]
   after:   2 [ 5, 2 ]
  test child finished with 0
  ---- end ----
  Filter fds with revents mask in a pollfd array: Ok
  $

Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-x7c8liszdvc3ocmanf2cet8p@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf        |   1 +
 tools/perf/tests/builtin-test.c |   4 ++
 tools/perf/tests/evlist.c       | 103 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h        |   1 +
 4 files changed, 109 insertions(+)
 create mode 100644 tools/perf/tests/evlist.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 95e832b1bc3c..9ce194fc00a0 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -399,6 +399,7 @@ LIB_OBJS += $(OUTPUT)tests/open-syscall-tp-fields.o
 LIB_OBJS += $(OUTPUT)tests/mmap-basic.o
 LIB_OBJS += $(OUTPUT)tests/perf-record.o
 LIB_OBJS += $(OUTPUT)tests/rdpmc.o
+LIB_OBJS += $(OUTPUT)tests/evlist.o
 LIB_OBJS += $(OUTPUT)tests/evsel-roundtrip-name.o
 LIB_OBJS += $(OUTPUT)tests/evsel-tp-sched.o
 LIB_OBJS += $(OUTPUT)tests/pmu.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 6a4145e5ad2c..41e556edbe02 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -158,6 +158,10 @@ static struct test {
 		.func = test__switch_tracking,
 	},
 	{
+		.desc = "Filter fds with revents mask in a pollfd array",
+		.func = test__perf_evlist__filter_pollfd,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/evlist.c b/tools/perf/tests/evlist.c
new file mode 100644
index 000000000000..77579158f4d9
--- /dev/null
+++ b/tools/perf/tests/evlist.c
@@ -0,0 +1,103 @@
+#include "util/evlist.h"
+#include "util/debug.h"
+#include "tests/tests.h"
+
+static void perf_evlist__init_pollfd(struct perf_evlist *evlist,
+				     int nr_fds_alloc, short revents)
+{
+	int fd;
+
+	evlist->nr_fds = nr_fds_alloc;
+
+	for (fd = 0; fd < nr_fds_alloc; ++fd) {
+		evlist->pollfd[fd].fd	   = nr_fds_alloc - fd;
+		evlist->pollfd[fd].revents = revents;
+	}
+}
+
+static int perf_evlist__fprintf_pollfd(struct perf_evlist *evlist,
+				       const char *prefix, FILE *fp)
+{
+	int printed = 0, fd;
+
+	if (!verbose)
+		return 0;
+
+	printed += fprintf(fp, "\n%s: %3d [ ", prefix, evlist->nr_fds);
+	for (fd = 0; fd < evlist->nr_fds; ++fd)
+		printed += fprintf(fp, "%s%d", fd ? ", " : "", evlist->pollfd[fd].fd);
+	printed += fprintf(fp, " ]");
+	return printed;
+}
+
+int test__perf_evlist__filter_pollfd(void)
+{
+	const int nr_fds_alloc = 5;
+	int nr_fds, expected_fd[2], fd;
+	struct pollfd pollfd[nr_fds_alloc];
+	struct perf_evlist evlist_alloc = {
+		.pollfd	= pollfd,
+	}, *evlist = &evlist_alloc;
+
+	perf_evlist__init_pollfd(evlist, nr_fds_alloc, POLLIN);
+	nr_fds = perf_evlist__filter_pollfd(evlist, POLLHUP);
+	if (nr_fds != nr_fds_alloc) {
+		pr_debug("\nperf_evlist__filter_pollfd()=%d != %d shouldn't have filtered anything",
+			 nr_fds, nr_fds_alloc);
+		return TEST_FAIL;
+	}
+
+	perf_evlist__init_pollfd(evlist, nr_fds_alloc, POLLHUP);
+	nr_fds = perf_evlist__filter_pollfd(evlist, POLLHUP);
+	if (nr_fds != 0) {
+		pr_debug("\nperf_evlist__filter_pollfd()=%d != %d, should have filtered all fds",
+			 nr_fds, nr_fds_alloc);
+		return TEST_FAIL;
+	}
+
+	perf_evlist__init_pollfd(evlist, nr_fds_alloc, POLLHUP);
+	pollfd[2].revents = POLLIN;
+	expected_fd[0] = pollfd[2].fd;
+
+	pr_debug("\nfiltering all but pollfd[2]:");
+	perf_evlist__fprintf_pollfd(evlist, "before", stderr);
+	nr_fds = perf_evlist__filter_pollfd(evlist, POLLHUP);
+	perf_evlist__fprintf_pollfd(evlist, " after", stderr);
+	if (nr_fds != 1) {
+		pr_debug("\nperf_evlist__filter_pollfd()=%d != 1, should have left just one event",
+			 nr_fds);
+		return TEST_FAIL;
+	}
+
+	if (pollfd[0].fd != expected_fd[0]) {
+		pr_debug("\npollfd[0].fd=%d != %d\n", pollfd[0].fd, expected_fd[0]);
+		return TEST_FAIL;
+	}
+
+	perf_evlist__init_pollfd(evlist, nr_fds_alloc, POLLHUP);
+	pollfd[0].revents = POLLIN;
+	expected_fd[0] = pollfd[0].fd;
+	pollfd[3].revents = POLLIN;
+	expected_fd[1] = pollfd[3].fd;
+
+	pr_debug("\nfiltering all but (pollfd[0], pollfd[3]):");
+	perf_evlist__fprintf_pollfd(evlist, "before", stderr);
+	nr_fds = perf_evlist__filter_pollfd(evlist, POLLHUP);
+	perf_evlist__fprintf_pollfd(evlist, " after", stderr);
+	if (nr_fds != 2) {
+		pr_debug("\nperf_evlist__filter_pollfd()=%d != 2, should have left just two events",
+			 nr_fds);
+		return TEST_FAIL;
+	}
+
+	for (fd = 0; fd < 2; ++fd) {
+		if (pollfd[fd].fd != expected_fd[fd]) {
+			pr_debug("\npollfd[%d].fd=%d != %d\n", fd, pollfd[fd].fd, expected_fd[fd]);
+			return TEST_FAIL;
+		}
+	}
+
+	pr_debug("\n");
+
+	return 0;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index be8be10e3957..72c4c039bd80 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -49,6 +49,7 @@ int test__thread_mg_share(void);
 int test__hists_output(void);
 int test__hists_cumulate(void);
 int test__switch_tracking(void);
+int test__perf_evlist__filter_pollfd(void);
 
 #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
-- 
1.9.3


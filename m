Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaIZJUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:20:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57009 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbaIZJUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:20:22 -0400
Date: Fri, 26 Sep 2014 02:19:38 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-x7c8liszdvc3ocmanf2cet8p@git.kernel.org>
Cc: eranian@google.com, acme@redhat.com, mingo@kernel.org, jolsa@kernel.org,
        peterz@infradead.org, efault@gmx.de, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        dzickus@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@kernel.org,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, acme@redhat.com, eranian@google.com,
        jolsa@kernel.org, efault@gmx.de, peterz@infradead.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, dzickus@redhat.com, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        adrian.hunter@intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Add test for perf_evlist__filter_pollfd()
Git-Commit-ID: 54dbfae3007b0c61727abba45af1e4c226908d82
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54dbfae3007b0c61727abba45af1e4c226908d82
Gitweb:     http://git.kernel.org/tip/54dbfae3007b0c61727abba45af1e4c226908d82
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 12 Aug 2014 23:34:06 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 25 Sep 2014 16:46:53 -0300

perf tests: Add test for perf_evlist__filter_pollfd()

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

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 171f4e6..f287c25 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -400,6 +400,7 @@ LIB_OBJS += $(OUTPUT)tests/open-syscall-tp-fields.o
 LIB_OBJS += $(OUTPUT)tests/mmap-basic.o
 LIB_OBJS += $(OUTPUT)tests/perf-record.o
 LIB_OBJS += $(OUTPUT)tests/rdpmc.o
+LIB_OBJS += $(OUTPUT)tests/evlist.o
 LIB_OBJS += $(OUTPUT)tests/evsel-roundtrip-name.o
 LIB_OBJS += $(OUTPUT)tests/evsel-tp-sched.o
 LIB_OBJS += $(OUTPUT)tests/pmu.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 6a4145e..41e556e 100644
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
index 0000000..7757915
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
index be8be10..72c4c03 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -49,6 +49,7 @@ int test__thread_mg_share(void);
 int test__hists_output(void);
 int test__hists_cumulate(void);
 int test__switch_tracking(void);
+int test__perf_evlist__filter_pollfd(void);
 
 #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT

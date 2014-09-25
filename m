Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaIYV6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 17:58:51 -0400
Received: from mail.kernel.org ([198.145.19.201]:44041 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbaIYV6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 17:58:48 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 09/14] tools lib api: Adopt fdarray class from perf's evlist
Date: Thu, 25 Sep 2014 18:57:46 -0300
Message-Id: <1411682271-3771-10-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411682271-3771-1-git-send-email-acme@kernel.org>
References: <1411682271-3771-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The extensible file description array that grew in the perf_evlist class
can be useful for other tools, as it is not something that only evlists
need, so move it to tools/lib/api/fd to ease sharing it.

v2: Don't use {} like in:

 libapi_dirs:
	$(QUIET_MKDIR)mkdir -p $(OUTPUT){fs,fd}/

in Makefiles, as it will not work in some systems, as in ubuntu13.10.

v3: Add fd/*.[ch] to LIBAPIKFS_SOURCES (Fix from Jiri Olsa)

v4: Leave the fcntl(fd, O_NONBLOCK) in the evlist layer, remains to
    be checked if it is really needed there, but has no place in the
    fdarray class (Fix from Jiri Olsa)

v5: Remove evlist details from fdarray grow/filter tests. Improve it a
    bit doing more tests about expected internal state.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-kleuni3hckbc3s0lu6yb9x40@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/api/Makefile          |   7 +-
 tools/lib/api/fd/array.c        | 107 ++++++++++++++++++++
 tools/lib/api/fd/array.h        |  32 ++++++
 tools/perf/Makefile.perf        |   4 +-
 tools/perf/builtin-kvm.c        |   4 +-
 tools/perf/tests/builtin-test.c |   8 +-
 tools/perf/tests/evlist.c       | 214 ----------------------------------------
 tools/perf/tests/fdarray.c      | 174 ++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h        |   4 +-
 tools/perf/util/evlist.c        |  57 ++---------
 tools/perf/util/evlist.h        |   5 +-
 tools/perf/util/python.c        |   4 +-
 12 files changed, 342 insertions(+), 278 deletions(-)
 create mode 100644 tools/lib/api/fd/array.c
 create mode 100644 tools/lib/api/fd/array.h
 delete mode 100644 tools/perf/tests/evlist.c
 create mode 100644 tools/perf/tests/fdarray.c

diff --git a/tools/lib/api/Makefile b/tools/lib/api/Makefile
index ce00f7ee6455..36c08b1f4afb 100644
--- a/tools/lib/api/Makefile
+++ b/tools/lib/api/Makefile
@@ -10,9 +10,14 @@ LIB_OBJS=
 
 LIB_H += fs/debugfs.h
 LIB_H += fs/fs.h
+# See comment below about piggybacking...
+LIB_H += fd/array.h
 
 LIB_OBJS += $(OUTPUT)fs/debugfs.o
 LIB_OBJS += $(OUTPUT)fs/fs.o
+# XXX piggybacking here, need to introduce libapikfd, or rename this
+# to plain libapik.a and make it have it all api goodies
+LIB_OBJS += $(OUTPUT)fd/array.o
 
 LIBFILE = libapikfs.a
 
@@ -29,7 +34,7 @@ $(LIBFILE): $(LIB_OBJS)
 $(LIB_OBJS): $(LIB_H)
 
 libapi_dirs:
-	$(QUIET_MKDIR)mkdir -p $(OUTPUT)fs/
+	$(QUIET_MKDIR)mkdir -p $(OUTPUT)fd $(OUTPUT)fs
 
 $(OUTPUT)%.o: %.c libapi_dirs
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
diff --git a/tools/lib/api/fd/array.c b/tools/lib/api/fd/array.c
new file mode 100644
index 000000000000..4889c7d42961
--- /dev/null
+++ b/tools/lib/api/fd/array.c
@@ -0,0 +1,107 @@
+/*
+ * Copyright (C) 2014, Red Hat Inc, Arnaldo Carvalho de Melo <acme@redhat.com>
+ *
+ * Released under the GPL v2. (and only v2, not any later version)
+ */
+#include "array.h"
+#include <errno.h>
+#include <fcntl.h>
+#include <poll.h>
+#include <stdlib.h>
+#include <unistd.h>
+
+void fdarray__init(struct fdarray *fda, int nr_autogrow)
+{
+	fda->entries	 = NULL;
+	fda->nr		 = fda->nr_alloc = 0;
+	fda->nr_autogrow = nr_autogrow;
+}
+
+int fdarray__grow(struct fdarray *fda, int nr)
+{
+	int nr_alloc = fda->nr_alloc + nr;
+	size_t size  = sizeof(struct pollfd) * nr_alloc;
+	struct pollfd *entries = realloc(fda->entries, size);
+
+	if (entries == NULL)
+		return -ENOMEM;
+
+	fda->nr_alloc = nr_alloc;
+	fda->entries  = entries;
+	return 0;
+}
+
+struct fdarray *fdarray__new(int nr_alloc, int nr_autogrow)
+{
+	struct fdarray *fda = calloc(1, sizeof(*fda));
+
+	if (fda != NULL) {
+		if (fdarray__grow(fda, nr_alloc)) {
+			free(fda);
+			fda = NULL;
+		} else {
+			fda->nr_autogrow = nr_autogrow;
+		}
+	}
+
+	return fda;
+}
+
+void fdarray__exit(struct fdarray *fda)
+{
+	free(fda->entries);
+	fdarray__init(fda, 0);
+}
+
+void fdarray__delete(struct fdarray *fda)
+{
+	fdarray__exit(fda);
+	free(fda);
+}
+
+int fdarray__add(struct fdarray *fda, int fd, short revents)
+{
+	if (fda->nr == fda->nr_alloc &&
+	    fdarray__grow(fda, fda->nr_autogrow) < 0)
+		return -ENOMEM;
+
+	fda->entries[fda->nr].fd     = fd;
+	fda->entries[fda->nr].events = revents;
+	fda->nr++;
+	return 0;
+}
+
+int fdarray__filter(struct fdarray *fda, short revents)
+{
+	int fd, nr = 0;
+
+	if (fda->nr == 0)
+		return 0;
+
+	for (fd = 0; fd < fda->nr; ++fd) {
+		if (fda->entries[fd].revents & revents)
+			continue;
+
+		if (fd != nr)
+			fda->entries[nr] = fda->entries[fd];
+
+		++nr;
+	}
+
+	return fda->nr = nr;
+}
+
+int fdarray__poll(struct fdarray *fda, int timeout)
+{
+	return poll(fda->entries, fda->nr, timeout);
+}
+
+int fdarray__fprintf(struct fdarray *fda, FILE *fp)
+{
+	int fd, printed = fprintf(fp, "%d [ ", fda->nr);
+
+	for (fd = 0; fd < fda->nr; ++fd)
+		printed += fprintf(fp, "%s%d", fd ? ", " : "", fda->entries[fd].fd);
+
+	return printed + fprintf(fp, " ]");
+}
diff --git a/tools/lib/api/fd/array.h b/tools/lib/api/fd/array.h
new file mode 100644
index 000000000000..de38361ba69e
--- /dev/null
+++ b/tools/lib/api/fd/array.h
@@ -0,0 +1,32 @@
+#ifndef __API_FD_ARRAY__
+#define __API_FD_ARRAY__
+
+#include <stdio.h>
+
+struct pollfd;
+
+struct fdarray {
+	int	       nr;
+	int	       nr_alloc;
+	int	       nr_autogrow;
+	struct pollfd *entries;
+};
+
+void fdarray__init(struct fdarray *fda, int nr_autogrow);
+void fdarray__exit(struct fdarray *fda);
+
+struct fdarray *fdarray__new(int nr_alloc, int nr_autogrow);
+void fdarray__delete(struct fdarray *fda);
+
+int fdarray__add(struct fdarray *fda, int fd, short revents);
+int fdarray__poll(struct fdarray *fda, int timeout);
+int fdarray__filter(struct fdarray *fda, short revents);
+int fdarray__grow(struct fdarray *fda, int extra);
+int fdarray__fprintf(struct fdarray *fda, FILE *fp);
+
+static inline int fdarray__available_entries(struct fdarray *fda)
+{
+	return fda->nr_alloc - fda->nr;
+}
+
+#endif /* __API_FD_ARRAY__ */
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index f287c2522cf5..262916f4a377 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -400,9 +400,9 @@ LIB_OBJS += $(OUTPUT)tests/open-syscall-tp-fields.o
 LIB_OBJS += $(OUTPUT)tests/mmap-basic.o
 LIB_OBJS += $(OUTPUT)tests/perf-record.o
 LIB_OBJS += $(OUTPUT)tests/rdpmc.o
-LIB_OBJS += $(OUTPUT)tests/evlist.o
 LIB_OBJS += $(OUTPUT)tests/evsel-roundtrip-name.o
 LIB_OBJS += $(OUTPUT)tests/evsel-tp-sched.o
+LIB_OBJS += $(OUTPUT)tests/fdarray.o
 LIB_OBJS += $(OUTPUT)tests/pmu.o
 LIB_OBJS += $(OUTPUT)tests/hists_common.o
 LIB_OBJS += $(OUTPUT)tests/hists_link.o
@@ -770,7 +770,7 @@ $(LIBTRACEEVENT)-clean:
 install-traceevent-plugins: $(LIBTRACEEVENT)
 	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) install_plugins
 
-LIBAPIKFS_SOURCES = $(wildcard $(LIB_PATH)fs/*.[ch])
+LIBAPIKFS_SOURCES = $(wildcard $(LIB_PATH)fs/*.[ch] $(LIB_PATH)fd/*.[ch])
 
 # if subdir is set, we've been called from above so target has been built
 # already
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index a440219b0be0..1e639d6265cc 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -920,7 +920,7 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 	signal(SIGTERM, sig_handler);
 
 	/* use pollfds -- need to add timerfd and stdin */
-	nr_fds = kvm->evlist->nr_fds;
+	nr_fds = kvm->evlist->pollfd.nr;
 
 	/* add timer fd */
 	if (perf_kvm__timerfd_create(kvm) < 0) {
@@ -941,7 +941,7 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 	if (fd_set_nonblock(fileno(stdin)) != 0)
 		goto out;
 
-	pollfds	 = kvm->evlist->pollfd;
+	pollfds	 = kvm->evlist->pollfd.entries;
 
 	/* everything is good - enable the events and process */
 	perf_evlist__enable(kvm->evlist);
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 174c3ffc5713..ac655b0700e7 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -158,12 +158,12 @@ static struct test {
 		.func = test__switch_tracking,
 	},
 	{
-		.desc = "Filter fds with revents mask in a pollfd array",
-		.func = test__perf_evlist__filter_pollfd,
+		.desc = "Filter fds with revents mask in a fdarray",
+		.func = test__fdarray__filter,
 	},
 	{
-		.desc = "Add fd to pollfd array, making it autogrow",
-		.func = test__perf_evlist__add_pollfd,
+		.desc = "Add fd to a fdarray, making it autogrow",
+		.func = test__fdarray__add,
 	},
 	{
 		.func = NULL,
diff --git a/tools/perf/tests/evlist.c b/tools/perf/tests/evlist.c
deleted file mode 100644
index 99d7dfd4e20a..000000000000
--- a/tools/perf/tests/evlist.c
+++ /dev/null
@@ -1,214 +0,0 @@
-#include "util/evlist.h"
-#include "util/debug.h"
-#include "util/thread_map.h"
-#include "util/cpumap.h"
-#include "tests/tests.h"
-
-static void perf_evlist__init_pollfd(struct perf_evlist *evlist,
-				     int nr_fds_alloc, short revents)
-{
-	int fd;
-
-	evlist->nr_fds = nr_fds_alloc;
-
-	for (fd = 0; fd < nr_fds_alloc; ++fd) {
-		evlist->pollfd[fd].fd	   = nr_fds_alloc - fd;
-		evlist->pollfd[fd].revents = revents;
-	}
-}
-
-static int perf_evlist__fprintf_pollfd(struct perf_evlist *evlist,
-				       const char *prefix, FILE *fp)
-{
-	int printed = 0, fd;
-
-	if (!verbose)
-		return 0;
-
-	printed += fprintf(fp, "\n%s: %3d [ ", prefix, evlist->nr_fds);
-	for (fd = 0; fd < evlist->nr_fds; ++fd)
-		printed += fprintf(fp, "%s%d", fd ? ", " : "", evlist->pollfd[fd].fd);
-	printed += fprintf(fp, " ]");
-	return printed;
-}
-
-int test__perf_evlist__filter_pollfd(void)
-{
-	const int nr_fds_alloc = 5;
-	int nr_fds, expected_fd[2], fd;
-	struct pollfd pollfd[nr_fds_alloc];
-	struct perf_evlist evlist_alloc = {
-		.pollfd	= pollfd,
-	}, *evlist = &evlist_alloc;
-
-	perf_evlist__init_pollfd(evlist, nr_fds_alloc, POLLIN);
-	nr_fds = perf_evlist__filter_pollfd(evlist, POLLHUP);
-	if (nr_fds != nr_fds_alloc) {
-		pr_debug("\nperf_evlist__filter_pollfd()=%d != %d shouldn't have filtered anything",
-			 nr_fds, nr_fds_alloc);
-		return TEST_FAIL;
-	}
-
-	perf_evlist__init_pollfd(evlist, nr_fds_alloc, POLLHUP);
-	nr_fds = perf_evlist__filter_pollfd(evlist, POLLHUP);
-	if (nr_fds != 0) {
-		pr_debug("\nperf_evlist__filter_pollfd()=%d != %d, should have filtered all fds",
-			 nr_fds, nr_fds_alloc);
-		return TEST_FAIL;
-	}
-
-	perf_evlist__init_pollfd(evlist, nr_fds_alloc, POLLHUP);
-	pollfd[2].revents = POLLIN;
-	expected_fd[0] = pollfd[2].fd;
-
-	pr_debug("\nfiltering all but pollfd[2]:");
-	perf_evlist__fprintf_pollfd(evlist, "before", stderr);
-	nr_fds = perf_evlist__filter_pollfd(evlist, POLLHUP);
-	perf_evlist__fprintf_pollfd(evlist, " after", stderr);
-	if (nr_fds != 1) {
-		pr_debug("\nperf_evlist__filter_pollfd()=%d != 1, should have left just one event",
-			 nr_fds);
-		return TEST_FAIL;
-	}
-
-	if (pollfd[0].fd != expected_fd[0]) {
-		pr_debug("\npollfd[0].fd=%d != %d\n", pollfd[0].fd, expected_fd[0]);
-		return TEST_FAIL;
-	}
-
-	perf_evlist__init_pollfd(evlist, nr_fds_alloc, POLLHUP);
-	pollfd[0].revents = POLLIN;
-	expected_fd[0] = pollfd[0].fd;
-	pollfd[3].revents = POLLIN;
-	expected_fd[1] = pollfd[3].fd;
-
-	pr_debug("\nfiltering all but (pollfd[0], pollfd[3]):");
-	perf_evlist__fprintf_pollfd(evlist, "before", stderr);
-	nr_fds = perf_evlist__filter_pollfd(evlist, POLLHUP);
-	perf_evlist__fprintf_pollfd(evlist, " after", stderr);
-	if (nr_fds != 2) {
-		pr_debug("\nperf_evlist__filter_pollfd()=%d != 2, should have left just two events",
-			 nr_fds);
-		return TEST_FAIL;
-	}
-
-	for (fd = 0; fd < 2; ++fd) {
-		if (pollfd[fd].fd != expected_fd[fd]) {
-			pr_debug("\npollfd[%d].fd=%d != %d\n", fd, pollfd[fd].fd, expected_fd[fd]);
-			return TEST_FAIL;
-		}
-	}
-
-	pr_debug("\n");
-
-	return 0;
-}
-
-int test__perf_evlist__add_pollfd(void)
-{
-	struct perf_evsel evsel = {
-		.system_wide = false,
-	};
-	struct thread_map threads = {
-		.nr = 2,
-	};
-	struct perf_evlist evlist_alloc = {
-		.pollfd	 = NULL,
-		.threads = &threads,
-	}, *evlist = &evlist_alloc;
-
-	INIT_LIST_HEAD(&evlist->entries);
-	list_add(&evsel.node, &evlist->entries);
-
-	if (perf_evlist__alloc_pollfd(evlist) < 0) {
-		pr_debug("\nperf_evlist__alloc_pollfd(evlist) failed!");
-		return TEST_FAIL;
-	}
-
-	if (evlist->nr_fds_alloc != threads.nr) {
-		pr_debug("\n_evlist__alloc_pollfd: nr_fds_alloc=%d != (threads->nr(%d) * cpu_map->nr(%d))=%d",
-			 evlist->nr_fds_alloc, thread_map__nr(evlist->threads), cpu_map__nr(evlist->cpus),
-			 thread_map__nr(evlist->threads) * cpu_map__nr(evlist->cpus));
-		return TEST_FAIL;
-	}
-
-	if (perf_evlist__add_pollfd(evlist, 1) < 0) {
-		pr_debug("\nperf_evlist__add_pollfd(evlist, 1) failed!");
-		return TEST_FAIL;
-	}
-
-	if (evlist->nr_fds != 1) {
-		pr_debug("\nperf_evlist__add_pollfd(evlist, 1)=%d != 1", evlist->nr_fds);
-		return TEST_FAIL;
-	}
-
-	if (perf_evlist__add_pollfd(evlist, 2) < 0) {
-		pr_debug("\nperf_evlist__add_pollfd(evlist, 2) failed!");
-		return TEST_FAIL;
-	}
-
-	if (evlist->nr_fds != 2) {
-		pr_debug("\nperf_evlist__add_pollfd(evlist, 2)=%d != 2", evlist->nr_fds);
-		return TEST_FAIL;
-	}
-
-	perf_evlist__fprintf_pollfd(evlist, "before growing array", stderr);
-
-	if (perf_evlist__add_pollfd(evlist, 35) < 0) {
-		pr_debug("\nperf_evlist__add_pollfd(evlist, 35) failed!");
-		return TEST_FAIL;
-	}
-
-	if (evlist->nr_fds != 3) {
-		pr_debug("\nperf_evlist__add_pollfd(evlist, 35)=%d != 3", evlist->nr_fds);
-		return TEST_FAIL;
-	}
-
-	if (evlist->pollfd == NULL) {
-		pr_debug("\nperf_evlist__add_pollfd(evlist, 35) should have allocated evlist->pollfd!");
-		return TEST_FAIL;
-	}
-
-	perf_evlist__fprintf_pollfd(evlist, "after 3rd add_pollfd", stderr);
-
-	if (evlist->pollfd[2].fd != 35) {
-		pr_debug("\nevlist->pollfd[2](%d) != 35!", evlist->pollfd[2].fd);
-		return TEST_FAIL;
-	}
-
-	if (perf_evlist__add_pollfd(evlist, 88) < 0) {
-		pr_debug("\nperf_evlist__add_pollfd(evlist, 88) failed!");
-		return TEST_FAIL;
-	}
-
-	if (evlist->nr_fds != 4) {
-		pr_debug("\nperf_evlist__add_pollfd(evlist, 88)=%d != 2", evlist->nr_fds);
-		return TEST_FAIL;
-	}
-
-	perf_evlist__fprintf_pollfd(evlist, "after 4th add_pollfd", stderr);
-
-	if (evlist->pollfd[0].fd != 1) {
-		pr_debug("\nevlist->pollfd[0](%d) != 1!", evlist->pollfd[0].fd);
-		return TEST_FAIL;
-	}
-
-	if (evlist->pollfd[1].fd != 2) {
-		pr_debug("\nevlist->pollfd[1](%d) != 2!", evlist->pollfd[1].fd);
-		return TEST_FAIL;
-	}
-
-	if (evlist->pollfd[2].fd != 35) {
-		pr_debug("\nevlist->pollfd[2](%d) != 35!", evlist->pollfd[2].fd);
-		return TEST_FAIL;
-	}
-
-	if (evlist->pollfd[3].fd != 88) {
-		pr_debug("\nevlist->pollfd[3](%d) != 88!", evlist->pollfd[3].fd);
-		return TEST_FAIL;
-	}
-
-	pr_debug("\n");
-
-	return 0;
-}
diff --git a/tools/perf/tests/fdarray.c b/tools/perf/tests/fdarray.c
new file mode 100644
index 000000000000..a0fea62ec368
--- /dev/null
+++ b/tools/perf/tests/fdarray.c
@@ -0,0 +1,174 @@
+#include <api/fd/array.h>
+#include "util/debug.h"
+#include "tests/tests.h"
+
+static void fdarray__init_revents(struct fdarray *fda, short revents)
+{
+	int fd;
+
+	fda->nr = fda->nr_alloc;
+
+	for (fd = 0; fd < fda->nr; ++fd) {
+		fda->entries[fd].fd	 = fda->nr - fd;
+		fda->entries[fd].revents = revents;
+	}
+}
+
+static int fdarray__fprintf_prefix(struct fdarray *fda, const char *prefix, FILE *fp)
+{
+	int printed = 0;
+
+	if (!verbose)
+		return 0;
+
+	printed += fprintf(fp, "\n%s: ", prefix);
+	return printed + fdarray__fprintf(fda, fp);
+}
+
+int test__fdarray__filter(void)
+{
+	int nr_fds, expected_fd[2], fd, err = TEST_FAIL;
+	struct fdarray *fda = fdarray__new(5, 5);
+
+	if (fda == NULL) {
+		pr_debug("\nfdarray__new() failed!");
+		goto out;
+	}
+
+	fdarray__init_revents(fda, POLLIN);
+	nr_fds = fdarray__filter(fda, POLLHUP);
+	if (nr_fds != fda->nr_alloc) {
+		pr_debug("\nfdarray__filter()=%d != %d shouldn't have filtered anything",
+			 nr_fds, fda->nr_alloc);
+		goto out_delete;
+	}
+
+	fdarray__init_revents(fda, POLLHUP);
+	nr_fds = fdarray__filter(fda, POLLHUP);
+	if (nr_fds != 0) {
+		pr_debug("\nfdarray__filter()=%d != %d, should have filtered all fds",
+			 nr_fds, fda->nr_alloc);
+		goto out_delete;
+	}
+
+	fdarray__init_revents(fda, POLLHUP);
+	fda->entries[2].revents = POLLIN;
+	expected_fd[0] = fda->entries[2].fd;
+
+	pr_debug("\nfiltering all but fda->entries[2]:");
+	fdarray__fprintf_prefix(fda, "before", stderr);
+	nr_fds = fdarray__filter(fda, POLLHUP);
+	fdarray__fprintf_prefix(fda, " after", stderr);
+	if (nr_fds != 1) {
+		pr_debug("\nfdarray__filter()=%d != 1, should have left just one event", nr_fds);
+		goto out_delete;
+	}
+
+	if (fda->entries[0].fd != expected_fd[0]) {
+		pr_debug("\nfda->entries[0].fd=%d != %d\n",
+			 fda->entries[0].fd, expected_fd[0]);
+		goto out_delete;
+	}
+
+	fdarray__init_revents(fda, POLLHUP);
+	fda->entries[0].revents = POLLIN;
+	expected_fd[0] = fda->entries[0].fd;
+	fda->entries[3].revents = POLLIN;
+	expected_fd[1] = fda->entries[3].fd;
+
+	pr_debug("\nfiltering all but (fda->entries[0], fda->entries[3]):");
+	fdarray__fprintf_prefix(fda, "before", stderr);
+	nr_fds = fdarray__filter(fda, POLLHUP);
+	fdarray__fprintf_prefix(fda, " after", stderr);
+	if (nr_fds != 2) {
+		pr_debug("\nfdarray__filter()=%d != 2, should have left just two events",
+			 nr_fds);
+		goto out_delete;
+	}
+
+	for (fd = 0; fd < 2; ++fd) {
+		if (fda->entries[fd].fd != expected_fd[fd]) {
+			pr_debug("\nfda->entries[%d].fd=%d != %d\n", fd,
+				 fda->entries[fd].fd, expected_fd[fd]);
+			goto out_delete;
+		}
+	}
+
+	pr_debug("\n");
+
+	err = 0;
+out_delete:
+	fdarray__delete(fda);
+out:
+	return err;
+}
+
+int test__fdarray__add(void)
+{
+	int err = TEST_FAIL;
+	struct fdarray *fda = fdarray__new(2, 2);
+
+	if (fda == NULL) {
+		pr_debug("\nfdarray__new() failed!");
+		goto out;
+	}
+
+#define FDA_CHECK(_idx, _fd, _revents)					   \
+	if (fda->entries[_idx].fd != _fd) {				   \
+		pr_debug("\n%d: fda->entries[%d](%d) != %d!",		   \
+			 __LINE__, _idx, fda->entries[1].fd, _fd);	   \
+		goto out_delete;					   \
+	}								   \
+	if (fda->entries[_idx].events != (_revents)) {			   \
+		pr_debug("\n%d: fda->entries[%d].revents(%d) != %d!",	   \
+			 __LINE__, _idx, fda->entries[_idx].fd, _revents); \
+		goto out_delete;					   \
+	}
+
+#define FDA_ADD(_idx, _fd, _revents, _nr)				   \
+	if (fdarray__add(fda, _fd, _revents) < 0) {			   \
+		pr_debug("\n%d: fdarray__add(fda, %d, %d) failed!",	   \
+			 __LINE__,_fd, _revents);			   \
+		goto out_delete;					   \
+	}								   \
+	if (fda->nr != _nr) {						   \
+		pr_debug("\n%d: fdarray__add(fda, %d, %d)=%d != %d",	   \
+			 __LINE__,_fd, _revents, fda->nr, _nr);		   \
+		goto out_delete;					   \
+	}								   \
+	FDA_CHECK(_idx, _fd, _revents)
+
+	FDA_ADD(0, 1, POLLIN, 1);
+	FDA_ADD(1, 2, POLLERR, 2);
+
+	fdarray__fprintf_prefix(fda, "before growing array", stderr);
+
+	FDA_ADD(2, 35, POLLHUP, 3);
+
+	if (fda->entries == NULL) {
+		pr_debug("\nfdarray__add(fda, 35, POLLHUP) should have allocated fda->pollfd!");
+		goto out_delete;
+	}
+
+	fdarray__fprintf_prefix(fda, "after 3rd add", stderr);
+
+	FDA_ADD(3, 88, POLLIN | POLLOUT, 4);
+
+	fdarray__fprintf_prefix(fda, "after 4th add", stderr);
+
+	FDA_CHECK(0, 1, POLLIN);
+	FDA_CHECK(1, 2, POLLERR);
+	FDA_CHECK(2, 35, POLLHUP);
+	FDA_CHECK(3, 88, POLLIN | POLLOUT);
+
+#undef FDA_ADD
+#undef FDA_CHECK
+
+	pr_debug("\n");
+
+	err = 0;
+out_delete:
+	fdarray__delete(fda);
+out:
+	return err;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 699d4bb61dc7..00e776a87a9c 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -49,8 +49,8 @@ int test__thread_mg_share(void);
 int test__hists_output(void);
 int test__hists_cumulate(void);
 int test__switch_tracking(void);
-int test__perf_evlist__filter_pollfd(void);
-int test__perf_evlist__add_pollfd(void);
+int test__fdarray__filter(void);
+int test__fdarray__add(void);
 
 #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 5ff3c667542f..398dab1a08cc 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -37,6 +37,7 @@ void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
 		INIT_HLIST_HEAD(&evlist->heads[i]);
 	INIT_LIST_HEAD(&evlist->entries);
 	perf_evlist__set_maps(evlist, cpus, threads);
+	fdarray__init(&evlist->pollfd, 64);
 	evlist->workload.pid = -1;
 }
 
@@ -102,7 +103,7 @@ static void perf_evlist__purge(struct perf_evlist *evlist)
 void perf_evlist__exit(struct perf_evlist *evlist)
 {
 	zfree(&evlist->mmap);
-	zfree(&evlist->pollfd);
+	fdarray__exit(&evlist->pollfd);
 }
 
 void perf_evlist__delete(struct perf_evlist *evlist)
@@ -402,20 +403,6 @@ int perf_evlist__enable_event_idx(struct perf_evlist *evlist,
 		return perf_evlist__enable_event_thread(evlist, evsel, idx);
 }
 
-static int perf_evlist__grow_pollfd(struct perf_evlist *evlist, int hint)
-{
-	int nr_fds_alloc = evlist->nr_fds_alloc + hint;
-	size_t size = sizeof(struct pollfd) * nr_fds_alloc;
-	struct pollfd *pollfd = realloc(evlist->pollfd, size);
-
-	if (pollfd == NULL)
-		return -ENOMEM;
-
-	evlist->nr_fds_alloc = nr_fds_alloc;
-	evlist->pollfd	     = pollfd;
-	return 0;
-}
-
 int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 {
 	int nr_cpus = cpu_map__nr(evlist->cpus);
@@ -430,8 +417,8 @@ int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 			nfds += nr_cpus * nr_threads;
 	}
 
-	if (evlist->nr_fds_alloc - evlist->nr_fds < nfds &&
-	    perf_evlist__grow_pollfd(evlist, nfds) < 0)
+	if (fdarray__available_entries(&evlist->pollfd) < nfds &&
+	    fdarray__grow(&evlist->pollfd, nfds) < 0)
 		return -ENOMEM;
 
 	return 0;
@@ -439,45 +426,19 @@ int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 
 int perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
 {
-	/*
-	 * XXX: 64 is arbitrary, just not to call realloc at each fd.
-	 *	Find a better autogrowing heuristic
-	 */
-	if (evlist->nr_fds == evlist->nr_fds_alloc &&
-	    perf_evlist__grow_pollfd(evlist, 64) < 0)
-		return -ENOMEM;
-
 	fcntl(fd, F_SETFL, O_NONBLOCK);
-	evlist->pollfd[evlist->nr_fds].fd = fd;
-	evlist->pollfd[evlist->nr_fds].events = POLLIN | POLLERR | POLLHUP;
-	evlist->nr_fds++;
-	return 0;
+
+	return fdarray__add(&evlist->pollfd, fd, POLLIN | POLLERR | POLLHUP);
 }
 
 int perf_evlist__filter_pollfd(struct perf_evlist *evlist, short revents_and_mask)
 {
-	int fd, nr_fds = 0;
-
-	if (evlist->nr_fds == 0)
-		return 0;
-
-	for (fd = 0; fd < evlist->nr_fds; ++fd) {
-		if (evlist->pollfd[fd].revents & revents_and_mask)
-			continue;
-
-		if (fd != nr_fds)
-			evlist->pollfd[nr_fds] = evlist->pollfd[fd];
-
-		++nr_fds;
-	}
-
-	evlist->nr_fds = nr_fds;
-	return nr_fds;
+	return fdarray__filter(&evlist->pollfd, revents_and_mask);
 }
 
 int perf_evlist__poll(struct perf_evlist *evlist, int timeout)
 {
-	return poll(evlist->pollfd, evlist->nr_fds, timeout);
+	return fdarray__poll(&evlist->pollfd, timeout);
 }
 
 static void perf_evlist__id_hash(struct perf_evlist *evlist,
@@ -935,7 +896,7 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist) < 0)
 		return -ENOMEM;
 
-	if (evlist->pollfd == NULL && perf_evlist__alloc_pollfd(evlist) < 0)
+	if (evlist->pollfd.entries == NULL && perf_evlist__alloc_pollfd(evlist) < 0)
 		return -ENOMEM;
 
 	evlist->overwrite = overwrite;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index d7e99b67c94f..fc013704d903 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -2,6 +2,7 @@
 #define __PERF_EVLIST_H 1
 
 #include <linux/list.h>
+#include <api/fd/array.h>
 #include <stdio.h>
 #include "../perf.h"
 #include "event.h"
@@ -29,8 +30,6 @@ struct perf_evlist {
 	struct hlist_head heads[PERF_EVLIST__HLIST_SIZE];
 	int		 nr_entries;
 	int		 nr_groups;
-	int		 nr_fds;
-	int		 nr_fds_alloc;
 	int		 nr_mmaps;
 	size_t		 mmap_len;
 	int		 id_pos;
@@ -41,8 +40,8 @@ struct perf_evlist {
 		pid_t	pid;
 	} workload;
 	bool		 overwrite;
+	struct fdarray	 pollfd;
 	struct perf_mmap *mmap;
-	struct pollfd	 *pollfd;
 	struct thread_map *threads;
 	struct cpu_map	  *cpus;
 	struct perf_evsel *selected;
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 4472f8be8e35..3dda85ca50c1 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -753,9 +753,9 @@ static PyObject *pyrf_evlist__get_pollfd(struct pyrf_evlist *pevlist,
         PyObject *list = PyList_New(0);
 	int i;
 
-	for (i = 0; i < evlist->nr_fds; ++i) {
+	for (i = 0; i < evlist->pollfd.nr; ++i) {
 		PyObject *file;
-		FILE *fp = fdopen(evlist->pollfd[i].fd, "r");
+		FILE *fp = fdopen(evlist->pollfd.entries[i].fd, "r");
 
 		if (fp == NULL)
 			goto free_list;
-- 
1.9.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaIJOKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:10:33 -0400
Received: from mail.kernel.org ([198.145.19.201]:38657 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbaIJOK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:10:29 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 11/14] tools lib api: Adopt fdarray class from perf's evlist
Date: Wed, 10 Sep 2014 11:08:46 -0300
Message-Id: <1410358129-9965-12-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410358129-9965-1-git-send-email-acme@kernel.org>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
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
Link: http://lkml.kernel.org/n/tip-tvgqy1jubh6t2epumwgey3yo@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/api/Makefile    |   7 ++-
 tools/lib/api/fd/array.c  | 108 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/lib/api/fd/array.h  |  32 ++++++++++++++
 tools/perf/builtin-kvm.c  |   4 +-
 tools/perf/tests/evlist.c |  67 ++++++++++++++--------------
 tools/perf/util/evlist.c  |  57 ++++--------------------
 tools/perf/util/evlist.h  |   5 +--
 tools/perf/util/python.c  |   4 +-
 8 files changed, 195 insertions(+), 89 deletions(-)
 create mode 100644 tools/lib/api/fd/array.c
 create mode 100644 tools/lib/api/fd/array.h

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
index 000000000000..bd923d41b450
--- /dev/null
+++ b/tools/lib/api/fd/array.c
@@ -0,0 +1,108 @@
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
+	fcntl(fd, F_SETFL, O_NONBLOCK);
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
diff --git a/tools/perf/tests/evlist.c b/tools/perf/tests/evlist.c
index 99d7dfd4e20a..fe3e118b25bd 100644
--- a/tools/perf/tests/evlist.c
+++ b/tools/perf/tests/evlist.c
@@ -8,28 +8,26 @@ static void perf_evlist__init_pollfd(struct perf_evlist *evlist,
 				     int nr_fds_alloc, short revents)
 {
 	int fd;
+	struct fdarray *fda = &evlist->pollfd;
 
-	evlist->nr_fds = nr_fds_alloc;
+	fda->nr = nr_fds_alloc;
 
 	for (fd = 0; fd < nr_fds_alloc; ++fd) {
-		evlist->pollfd[fd].fd	   = nr_fds_alloc - fd;
-		evlist->pollfd[fd].revents = revents;
+		fda->entries[fd].fd	 = nr_fds_alloc - fd;
+		fda->entries[fd].revents = revents;
 	}
 }
 
 static int perf_evlist__fprintf_pollfd(struct perf_evlist *evlist,
 				       const char *prefix, FILE *fp)
 {
-	int printed = 0, fd;
+	int printed = 0;
 
 	if (!verbose)
 		return 0;
 
-	printed += fprintf(fp, "\n%s: %3d [ ", prefix, evlist->nr_fds);
-	for (fd = 0; fd < evlist->nr_fds; ++fd)
-		printed += fprintf(fp, "%s%d", fd ? ", " : "", evlist->pollfd[fd].fd);
-	printed += fprintf(fp, " ]");
-	return printed;
+	printed += fprintf(fp, "\n%s: ", prefix);
+	return fdarray__fprintf(&evlist->pollfd, fp);
 }
 
 int test__perf_evlist__filter_pollfd(void)
@@ -38,7 +36,9 @@ int test__perf_evlist__filter_pollfd(void)
 	int nr_fds, expected_fd[2], fd;
 	struct pollfd pollfd[nr_fds_alloc];
 	struct perf_evlist evlist_alloc = {
-		.pollfd	= pollfd,
+		.pollfd	= {
+			.entries = pollfd,
+		},
 	}, *evlist = &evlist_alloc;
 
 	perf_evlist__init_pollfd(evlist, nr_fds_alloc, POLLIN);
@@ -113,9 +113,12 @@ int test__perf_evlist__add_pollfd(void)
 		.nr = 2,
 	};
 	struct perf_evlist evlist_alloc = {
-		.pollfd	 = NULL,
+		.pollfd	 = {
+			.entries = NULL,
+		},
 		.threads = &threads,
 	}, *evlist = &evlist_alloc;
+	struct fdarray *fda = &evlist->pollfd;
 
 	INIT_LIST_HEAD(&evlist->entries);
 	list_add(&evsel.node, &evlist->entries);
@@ -125,9 +128,9 @@ int test__perf_evlist__add_pollfd(void)
 		return TEST_FAIL;
 	}
 
-	if (evlist->nr_fds_alloc != threads.nr) {
+	if (fda->nr_alloc != threads.nr) {
 		pr_debug("\n_evlist__alloc_pollfd: nr_fds_alloc=%d != (threads->nr(%d) * cpu_map->nr(%d))=%d",
-			 evlist->nr_fds_alloc, thread_map__nr(evlist->threads), cpu_map__nr(evlist->cpus),
+			 fda->nr_alloc, thread_map__nr(evlist->threads), cpu_map__nr(evlist->cpus),
 			 thread_map__nr(evlist->threads) * cpu_map__nr(evlist->cpus));
 		return TEST_FAIL;
 	}
@@ -137,8 +140,8 @@ int test__perf_evlist__add_pollfd(void)
 		return TEST_FAIL;
 	}
 
-	if (evlist->nr_fds != 1) {
-		pr_debug("\nperf_evlist__add_pollfd(evlist, 1)=%d != 1", evlist->nr_fds);
+	if (fda->nr != 1) {
+		pr_debug("\nperf_evlist__add_pollfd(evlist, 1)=%d != 1", fda->nr);
 		return TEST_FAIL;
 	}
 
@@ -147,8 +150,8 @@ int test__perf_evlist__add_pollfd(void)
 		return TEST_FAIL;
 	}
 
-	if (evlist->nr_fds != 2) {
-		pr_debug("\nperf_evlist__add_pollfd(evlist, 2)=%d != 2", evlist->nr_fds);
+	if (fda->nr != 2) {
+		pr_debug("\nperf_evlist__add_pollfd(evlist, 2)=%d != 2", fda->nr);
 		return TEST_FAIL;
 	}
 
@@ -159,20 +162,20 @@ int test__perf_evlist__add_pollfd(void)
 		return TEST_FAIL;
 	}
 
-	if (evlist->nr_fds != 3) {
-		pr_debug("\nperf_evlist__add_pollfd(evlist, 35)=%d != 3", evlist->nr_fds);
+	if (fda->nr != 3) {
+		pr_debug("\nperf_evlist__add_pollfd(evlist, 35)=%d != 3", fda->nr);
 		return TEST_FAIL;
 	}
 
-	if (evlist->pollfd == NULL) {
+	if (fda->entries == NULL) {
 		pr_debug("\nperf_evlist__add_pollfd(evlist, 35) should have allocated evlist->pollfd!");
 		return TEST_FAIL;
 	}
 
 	perf_evlist__fprintf_pollfd(evlist, "after 3rd add_pollfd", stderr);
 
-	if (evlist->pollfd[2].fd != 35) {
-		pr_debug("\nevlist->pollfd[2](%d) != 35!", evlist->pollfd[2].fd);
+	if (fda->entries[2].fd != 35) {
+		pr_debug("\nfda->entries[2](%d) != 35!", fda->entries[2].fd);
 		return TEST_FAIL;
 	}
 
@@ -181,30 +184,30 @@ int test__perf_evlist__add_pollfd(void)
 		return TEST_FAIL;
 	}
 
-	if (evlist->nr_fds != 4) {
-		pr_debug("\nperf_evlist__add_pollfd(evlist, 88)=%d != 2", evlist->nr_fds);
+	if (fda->nr != 4) {
+		pr_debug("\nperf_evlist__add_pollfd(evlist, 88)=%d != 2", fda->nr);
 		return TEST_FAIL;
 	}
 
 	perf_evlist__fprintf_pollfd(evlist, "after 4th add_pollfd", stderr);
 
-	if (evlist->pollfd[0].fd != 1) {
-		pr_debug("\nevlist->pollfd[0](%d) != 1!", evlist->pollfd[0].fd);
+	if (fda->entries[0].fd != 1) {
+		pr_debug("\nfda->entries[0](%d) != 1!", fda->entries[0].fd);
 		return TEST_FAIL;
 	}
 
-	if (evlist->pollfd[1].fd != 2) {
-		pr_debug("\nevlist->pollfd[1](%d) != 2!", evlist->pollfd[1].fd);
+	if (fda->entries[1].fd != 2) {
+		pr_debug("\nfda->entries[1](%d) != 2!", fda->entries[1].fd);
 		return TEST_FAIL;
 	}
 
-	if (evlist->pollfd[2].fd != 35) {
-		pr_debug("\nevlist->pollfd[2](%d) != 35!", evlist->pollfd[2].fd);
+	if (fda->entries[2].fd != 35) {
+		pr_debug("\nfda->entries[2](%d) != 35!", fda->entries[2].fd);
 		return TEST_FAIL;
 	}
 
-	if (evlist->pollfd[3].fd != 88) {
-		pr_debug("\nevlist->pollfd[3](%d) != 88!", evlist->pollfd[3].fd);
+	if (fda->entries[3].fd != 88) {
+		pr_debug("\nfda->entries[3](%d) != 88!", fda->entries[3].fd);
 		return TEST_FAIL;
 	}
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 5ff3c667542f..477ede5367ee 100644
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
@@ -439,45 +426,17 @@ int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 
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
-	fcntl(fd, F_SETFL, O_NONBLOCK);
-	evlist->pollfd[evlist->nr_fds].fd = fd;
-	evlist->pollfd[evlist->nr_fds].events = POLLIN | POLLERR | POLLHUP;
-	evlist->nr_fds++;
-	return 0;
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
@@ -935,7 +894,7 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
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


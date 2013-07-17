Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964917Ab3GQRwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:52:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964811Ab3GQRvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:51:33 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 05/23] perf tests: Add simple session read/write test
Date: Wed, 17 Jul 2013 19:49:45 +0200
Message-Id: <1374083403-14591-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding simple session read/write test to keep up
with file format changes.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile               |   1 +
 tools/perf/tests/builtin-test.c   |   4 +
 tools/perf/tests/session-simple.c | 274 ++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h          |   1 +
 4 files changed, 280 insertions(+)
 create mode 100644 tools/perf/tests/session-simple.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5b7c6db..ca3e17b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -389,6 +389,7 @@ LIB_OBJS += $(OUTPUT)tests/bp_signal.o
 LIB_OBJS += $(OUTPUT)tests/bp_signal_overflow.o
 LIB_OBJS += $(OUTPUT)tests/task-exit.o
 LIB_OBJS += $(OUTPUT)tests/sw-clock.o
+LIB_OBJS += $(OUTPUT)tests/session-simple.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 35b45f1466..67fc0ea 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -94,6 +94,10 @@ static struct test {
 		.func = test__sw_clock_freq,
 	},
 	{
+		.desc = "Test session - simple read/write",
+		.func = test__session_simple,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/session-simple.c b/tools/perf/tests/session-simple.c
new file mode 100644
index 0000000..3bcd7eb
--- /dev/null
+++ b/tools/perf/tests/session-simple.c
@@ -0,0 +1,274 @@
+
+#include <stdlib.h>
+#include <linux/kernel.h>
+
+#include "tests.h"
+#include "session.h"
+#include "header.h"
+#include "util.h"
+#include "evlist.h"
+
+
+static char *get_file(void)
+{
+	static char buf[PATH_MAX];
+	static char *file;
+	int fd;
+
+	if (file)
+		return file;
+
+	snprintf(buf, PATH_MAX, "/tmp/perf-test-session-simple-data-XXXXXX");
+	fd = mkstemp(buf);
+	if (fd < 0) {
+		pr_err("mkstemp failed");
+		return NULL;
+	}
+
+	close(fd);
+
+	file = buf;
+	pr_debug("data file %s\n", file);
+	return file;
+}
+
+static struct perf_evlist *get_evlist(void)
+{
+	struct perf_evlist *evlist;
+	int err;
+
+	evlist = perf_evlist__new();
+	if (evlist == NULL) {
+		pr_err("perf_evlist__new failed\n");
+		return NULL;
+	}
+
+	err = perf_evlist__add_default(evlist);
+	if (err < 0) {
+		pr_err("Not enough memory to create evsel\n");
+		perf_evlist__delete(evlist);
+		evlist = NULL;
+	}
+
+	return evlist;
+}
+
+static union perf_event *get_event_MMAP(void)
+{
+	static union perf_event event;
+	size_t size;
+
+	size = snprintf(event.mmap.filename, sizeof(event.mmap.filename),
+			"krava") + 1;
+	size = PERF_ALIGN(size, sizeof(u64));
+
+	event.header.type = PERF_RECORD_MMAP;
+	event.header.misc = PERF_RECORD_MISC_KERNEL;
+	event.header.size = sizeof(event.mmap) -
+			    (sizeof(event.mmap.filename) - size);
+
+	event.mmap.pgoff = 10;
+	event.mmap.start = 0;
+	event.mmap.len   = 10;
+	event.mmap.pid   = 123;
+
+	return &event;
+}
+
+static union perf_event *get_event_COMM(void)
+{
+	static union perf_event event;
+	size_t size;
+
+	size = snprintf(event.comm.comm, sizeof(event.comm.comm),
+			"krava") + 1;
+	size = PERF_ALIGN(size, sizeof(u64));
+
+	event.header.type = PERF_RECORD_COMM;
+	event.header.size = sizeof(event.comm) -
+			    (sizeof(event.comm.comm) - size);
+
+	event.comm.pid = 1234;
+	event.comm.tid = 4321;
+
+	return &event;
+}
+
+static int store_event(int fd, union perf_event *event, size_t *size)
+{
+	*size += event->header.size;
+	return write(fd, event, event->header.size) > 0 ? 0 : -1;
+}
+
+static int session_write(void)
+{
+	struct perf_session *session;
+	struct perf_evlist *evlist;
+	size_t size = 0;
+	char *file;
+	int feat, fd;
+
+	file = get_file();
+	TEST_ASSERT_VAL("failed to get temporary file", file);
+
+	fd = open(file, O_RDWR);
+	TEST_ASSERT_VAL("failed to open data file", fd >= 0);
+
+	evlist = get_evlist();
+	TEST_ASSERT_VAL("failed to get evlist", evlist);
+
+	pr_debug("session writing start\n");
+
+	session = perf_session__new(file, O_WRONLY, true, false, NULL);
+	TEST_ASSERT_VAL("failed to create session", session);
+
+	session->evlist = evlist;
+	session->fd     = fd;
+
+	for (feat = HEADER_FIRST_FEATURE; feat < HEADER_LAST_FEATURE; feat++)
+		perf_header__set_feat(&session->header, feat);
+
+	perf_header__clear_feat(&session->header, HEADER_BUILD_ID);
+	perf_header__clear_feat(&session->header, HEADER_TRACING_DATA);
+	perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
+
+	TEST_ASSERT_VAL("failed to write header",
+		!perf_session__write_header(session, evlist, fd, false));
+
+	TEST_ASSERT_VAL("failed to store MMAP event",
+		!store_event(fd, get_event_MMAP(), &size));
+
+	TEST_ASSERT_VAL("failed to store COMM event",
+		!store_event(fd, get_event_COMM(), &size));
+
+	session->header.data_size += size;
+
+	TEST_ASSERT_VAL("failed to write header",
+		!perf_session__write_header(session, evlist, fd, true));
+
+	perf_session__delete(session);
+	perf_evlist__delete(evlist);
+
+	pr_debug("session writing stop\n");
+	return 0;
+}
+
+static int events_comm;
+static int events_mmap;
+
+static int process_comm(struct perf_tool *tool __maybe_unused,
+			union perf_event *event,
+			struct perf_sample *sample __maybe_unused,
+			struct machine *machine __maybe_unused)
+{
+	pr_debug("event COMM pid %d, tid %d, comm '%s'\n",
+		 event->comm.pid,
+		 event->comm.pid,
+		 event->comm.comm);
+
+	TEST_ASSERT_VAL("wrong COMM pid\n",
+		event->comm.pid == 1234);
+
+	TEST_ASSERT_VAL("wrong COMM tid\n",
+		event->comm.tid == 4321);
+
+	TEST_ASSERT_VAL("wrong COMM comm\n",
+		!strcmp(event->comm.comm,"krava"));
+
+	events_comm++;
+	return 0;
+}
+
+static int process_mmap(struct perf_tool *tool __maybe_unused,
+			union perf_event *event,
+			struct perf_sample *sample __maybe_unused,
+			struct machine *machine __maybe_unused)
+{
+	pr_debug("event MMAP misc %d, pgoff %lu, start %lu,"
+		 " len %lu, pid %d, filename '%s'\n",
+		 event->header.misc,
+		 event->mmap.pgoff,
+		 event->mmap.start,
+		 event->mmap.len,
+		 event->mmap.pid,
+		 event->mmap.filename);
+
+	TEST_ASSERT_VAL("wrong MMAP misc\n",
+		event->header.misc == PERF_RECORD_MISC_KERNEL);
+
+	TEST_ASSERT_VAL("wrong MMAP pgoff\n",
+		event->mmap.pgoff == 10);
+
+	TEST_ASSERT_VAL("wrong MMAP start\n",
+		event->mmap.start == 0);
+
+	TEST_ASSERT_VAL("wrong MMAP len\n",
+		event->mmap.len == 10);
+
+	TEST_ASSERT_VAL("wrong MMAP pid\n",
+		event->mmap.pid == 123);
+
+	TEST_ASSERT_VAL("wrong MMAP filename\n",
+		!strcmp(event->mmap.filename,"krava"));
+
+	TEST_ASSERT_VAL("wrong MMAP misc\n",
+		event->header.misc == PERF_RECORD_MISC_KERNEL);
+
+	TEST_ASSERT_VAL("wrong MMAP pgoff\n",
+		event->mmap.pgoff == 10);
+
+	TEST_ASSERT_VAL("wrong MMAP start\n",
+		event->mmap.start == 0);
+
+	TEST_ASSERT_VAL("wrong MMAP len\n",
+		event->mmap.len == 10);
+
+	TEST_ASSERT_VAL("wrong MMAP pid\n",
+		event->mmap.pid == 123);
+
+	TEST_ASSERT_VAL("wrong MMAP filename\n",
+		!strcmp(event->mmap.filename,"krava"));
+
+	events_mmap++;
+	return 0;
+}
+
+static int session_read(void)
+{
+	struct perf_session *session;
+	struct perf_tool tool = {
+		.mmap = process_mmap,
+		.comm = process_comm,
+	};
+	char *file;
+
+	file = get_file();
+	TEST_ASSERT_VAL("failed to get temporary file", file);
+
+	pr_debug("session reading start\n");
+
+	session = perf_session__new(file, O_RDONLY, false, false, &tool);
+	TEST_ASSERT_VAL("failed to create session", session);
+
+	TEST_ASSERT_VAL("failed to process events", session);
+		perf_session__process_events(session, &tool);
+
+	perf_session__delete(session);
+
+	pr_debug("session reading stop\n");
+
+	return 0;
+}
+
+int test__session_simple(void)
+{
+	TEST_ASSERT_VAL("failed to write data", !session_write());
+	TEST_ASSERT_VAL("failed to read data",  !session_read());
+
+	unlink(get_file());
+
+	TEST_ASSERT_VAL("wrong MMAP events count", events_mmap == 1);
+	TEST_ASSERT_VAL("wrong COMM events count", events_comm == 1);
+
+	return 0;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 07a92f9..155b474 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -35,5 +35,6 @@ int test__bp_signal(void);
 int test__bp_signal_overflow(void);
 int test__task_exit(void);
 int test__sw_clock_freq(void);
+int test__session_simple(void);
 
 #endif /* TESTS_H */
-- 
1.7.11.7


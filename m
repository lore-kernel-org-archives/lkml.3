Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbaDNPwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:52:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165AbaDNPwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:52:34 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 5/5] perf tests: Add map groups sharing with thread object test
Date: Mon, 14 Apr 2014 17:52:03 +0200
Message-Id: <1397490723-1992-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397490723-1992-1-git-send-email-jolsa@redhat.com>
References: <1397490723-1992-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This test create 2 processes abstractions, with several threads
and checks they properly share and maintain map groups info.

Cc: Don Zickus <dzickus@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile.perf           |  1 +
 tools/perf/tests/builtin-test.c    |  4 ++
 tools/perf/tests/tests.h           |  1 +
 tools/perf/tests/thread-mg-share.c | 90 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 96 insertions(+)
 create mode 100644 tools/perf/tests/thread-mg-share.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 7bad323..eba6a61 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -415,6 +415,7 @@ LIB_OBJS += $(OUTPUT)tests/dwarf-unwind.o
 endif
 endif
 LIB_OBJS += $(OUTPUT)tests/mmap-thread-lookup.o
+LIB_OBJS += $(OUTPUT)tests/thread-mg-share.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index d947d1a..a1145d1 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -128,6 +128,10 @@ static struct test {
 		.func = test__mmap_thread_lookup,
 	},
 	{
+		.desc = "Test thread mg sharing",
+		.func = test__thread_mg_share,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 6db764c..5ed3bd5 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -42,6 +42,7 @@ int test__keep_tracking(void);
 int test__parse_no_sample_id_all(void);
 int test__dwarf_unwind(void);
 int test__mmap_thread_lookup(void);
+int test__thread_mg_share(void);
 
 #if defined(__x86_64__) || defined(__i386__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
diff --git a/tools/perf/tests/thread-mg-share.c b/tools/perf/tests/thread-mg-share.c
new file mode 100644
index 0000000..2697636
--- /dev/null
+++ b/tools/perf/tests/thread-mg-share.c
@@ -0,0 +1,90 @@
+#include "tests.h"
+#include "machine.h"
+#include "thread.h"
+#include "map.h"
+
+int test__thread_mg_share(void)
+{
+	struct machines machines;
+	struct machine *machine;
+
+	/* thread group */
+	struct thread *leader;
+	struct thread *t1, *t2, *t3;
+	struct map_groups *mg;
+
+	/* other process */
+	struct thread *other, *other_leader;
+	struct map_groups *other_mg;
+
+	/*
+	 * This test create 2 processes abstractions (struct thread)
+	 * with several threads and checks they properly share and
+	 * maintain map groups info (struct map_groups).
+	 *
+	 * thread group (pid: 0, tids: 0, 1, 2, 3)
+	 * other  group (pid: 4, tids: 4, 5)
+	*/
+
+	machines__init(&machines);
+	machine = &machines.host;
+
+	/* create process with 4 threads */
+	leader = machine__findnew_thread(machine, 0, 0);
+	t1     = machine__findnew_thread(machine, 0, 1);
+	t2     = machine__findnew_thread(machine, 0, 2);
+	t3     = machine__findnew_thread(machine, 0, 3);
+
+	/* and create 1 separated process, without thread leader */
+	other  = machine__findnew_thread(machine, 4, 5);
+
+	TEST_ASSERT_VAL("failed to create threads",
+			leader && t1 && t2 && t3 && other);
+
+	mg = leader->mg;
+	TEST_ASSERT_VAL("wrong refcnt", mg->refcnt == 4);
+
+	/* test the map groups pointer is shared */
+	TEST_ASSERT_VAL("map groups don't match", mg == t1->mg);
+	TEST_ASSERT_VAL("map groups don't match", mg == t2->mg);
+	TEST_ASSERT_VAL("map groups don't match", mg == t3->mg);
+
+	/*
+	 * Verify the other leader was created by previous call.
+	 * It should have shared map groups with no change in
+	 * refcnt.
+	 */
+	other_leader = machine__find_thread(machine, 4, 4);
+	TEST_ASSERT_VAL("failed to find other leader", other_leader);
+
+	other_mg = other->mg;
+	TEST_ASSERT_VAL("wrong refcnt", other_mg->refcnt == 2);
+
+	TEST_ASSERT_VAL("map groups don't match", other_mg == other_leader->mg);
+
+	/* release thread group */
+	thread__delete(leader);
+	TEST_ASSERT_VAL("wrong refcnt", mg->refcnt == 3);
+
+	thread__delete(t1);
+	TEST_ASSERT_VAL("wrong refcnt", mg->refcnt == 2);
+
+	thread__delete(t2);
+	TEST_ASSERT_VAL("wrong refcnt", mg->refcnt == 1);
+
+	thread__delete(t3);
+
+	/* release other group  */
+	thread__delete(other_leader);
+	TEST_ASSERT_VAL("wrong refcnt", other_mg->refcnt == 1);
+
+	thread__delete(other);
+
+	/*
+	 * Cannot call machine__delete_threads(machine) now,
+	 * because we've already realased all the threads.
+	 */
+
+	machines__exit(&machines);
+	return 0;
+}
-- 
1.8.3.1


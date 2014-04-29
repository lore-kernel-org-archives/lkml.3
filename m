Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736AbaD2GrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 02:47:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56928 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbaD2GrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 02:47:17 -0400
Date: Mon, 28 Apr 2014 23:46:53 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-fabf01238289e9ae009499594fc54642f5802a24@git.kernel.org>
Cc: eranian@google.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, acme@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, dzickus@redhat.com, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, eranian@google.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, acme@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, dzickus@redhat.com, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        adrian.hunter@intel.com
In-Reply-To: <1397490723-1992-6-git-send-email-jolsa@redhat.com>
References: <1397490723-1992-6-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Add map groups sharing with thread object test
Git-Commit-ID: fabf01238289e9ae009499594fc54642f5802a24
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

Commit-ID:  fabf01238289e9ae009499594fc54642f5802a24
Gitweb:     http://git.kernel.org/tip/fabf01238289e9ae009499594fc54642f5802a24
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 17 Mar 2014 14:39:00 +0100
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 28 Apr 2014 13:43:40 +0200

perf tests: Add map groups sharing with thread object test

This test create 2 processes abstractions, with several threads
and checks they properly share and maintain map groups info.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1397490723-1992-6-git-send-email-jolsa@redhat.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Makefile.perf           |  1 +
 tools/perf/tests/builtin-test.c    |  4 ++
 tools/perf/tests/tests.h           |  1 +
 tools/perf/tests/thread-mg-share.c | 90 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 96 insertions(+)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 16d4f4e..46e0c32 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -417,6 +417,7 @@ LIB_OBJS += $(OUTPUT)tests/dwarf-unwind.o
 endif
 endif
 LIB_OBJS += $(OUTPUT)tests/mmap-thread-lookup.o
+LIB_OBJS += $(OUTPUT)tests/thread-mg-share.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index bb60792..0d5afaf 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -132,6 +132,10 @@ static struct test {
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
index 82e8061..a9d7cb0 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -43,6 +43,7 @@ int test__parse_no_sample_id_all(void);
 int test__dwarf_unwind(void);
 int test__hists_filter(void);
 int test__mmap_thread_lookup(void);
+int test__thread_mg_share(void);
 
 #if defined(__x86_64__) || defined(__i386__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
diff --git a/tools/perf/tests/thread-mg-share.c b/tools/perf/tests/thread-mg-share.c
new file mode 100644
index 0000000..2b2e0db
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
+	 * because we've already released all the threads.
+	 */
+
+	machines__exit(&machines);
+	return 0;
+}

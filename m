Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3AZR2o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 12:28:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab3AZR2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 12:28:21 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/9] perf tests: Add precise event automated test
Date: Sat, 26 Jan 2013 18:27:49 +0100
Message-Id: <1359221275-24254-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1359221275-24254-1-git-send-email-jolsa@redhat.com>
References: <1359221275-24254-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The test detects the precise attribute availability and try
to open perf event with each allowed precise attribute value.

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
 tools/perf/Makefile             |  1 +
 tools/perf/tests/builtin-test.c |  4 ++++
 tools/perf/tests/precise.c      | 52 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h        |  1 +
 4 files changed, 58 insertions(+)
 create mode 100644 tools/perf/tests/precise.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 541d242..46154f7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -489,6 +489,7 @@ LIB_OBJS += $(OUTPUT)tests/evsel-tp-sched.o
 LIB_OBJS += $(OUTPUT)tests/pmu.o
 LIB_OBJS += $(OUTPUT)tests/hists_link.o
 LIB_OBJS += $(OUTPUT)tests/python-use.o
+LIB_OBJS += $(OUTPUT)tests/precise.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index acb98e0..c7649d7 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -78,6 +78,10 @@ static struct test {
 		.func = test__python_use,
 	},
 	{
+		.desc = "Test precise event attribute",
+		.func = test__precise,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/precise.c b/tools/perf/tests/precise.c
new file mode 100644
index 0000000..ef01d78
--- /dev/null
+++ b/tools/perf/tests/precise.c
@@ -0,0 +1,52 @@
+#include <linux/kernel.h>
+#include <linux/perf_event.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include "perf.h"
+#include "tests.h"
+#include "util.h"
+#include "sysfs.h"
+
+static int event_open_precise(int precise)
+{
+	struct perf_event_attr attr = {
+		.type		= PERF_TYPE_HARDWARE,
+		.config		= PERF_COUNT_HW_CPU_CYCLES,
+		.precise_ip	= precise,
+	};
+	int fd;
+
+	pr_debug("open cycles event with precise %d\n", precise);
+
+	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
+	if (fd < 0) {
+		pr_debug("failed to open event, syscall returned "
+			 "with %d (%s)\n", fd, strerror(errno));
+		return -1;
+	}
+
+	close(fd);
+	return 0;
+
+}
+
+int test__precise(void)
+{
+	int precise = perf_precise__get();
+	int i;
+
+	if (!precise) {
+		pr_debug("no precise info or support\n");
+		return TEST_SKIP;
+	}
+
+	if (precise < 0)
+		return TEST_FAIL;
+
+	for (i = 1; i <= precise; i++)
+		if (event_open_precise(i))
+			return TEST_FAIL;
+
+	return TEST_OK;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 5de0be1..ff6db12 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -23,5 +23,6 @@ int test__dso_data(void);
 int test__parse_events(void);
 int test__hists_link(void);
 int test__python_use(void);
+int test__precise(void);
 
 #endif /* TESTS_H */
-- 
1.7.11.7


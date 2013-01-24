Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab3AXUdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:33:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50151 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab3AXUIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:41 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 10/74] perf test: Check for linking problems in the python binding
Date: Thu, 24 Jan 2013 17:07:19 -0300
Message-Id: <1359058103-31645-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It just will add the O= builddir to PYTHONPATH and try to 'use perf',
which will, in verbose mode show the python backtrace with the missing
symbols, such as in the problem fixed in the patch after this one:

  # perf test -v 15
  15: Try 'use perf' in python, checking link problems       :
  --- start ---
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  ImportError: /home/acme/git/build/perf//python/perf.so: undefined symbol: test_attr__enabled
  ---- end ----
  Try 'use perf' in python, checking link problems: FAILED!
  #

Loooong overdue, done.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-zmd2oq9gz6t1u145ub7qm2nv@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile             |  4 ++++
 tools/perf/tests/builtin-test.c |  4 ++++
 tools/perf/tests/python-use.c   | 23 +++++++++++++++++++++++
 tools/perf/tests/tests.h        |  1 +
 4 files changed, 32 insertions(+)
 create mode 100644 tools/perf/tests/python-use.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index c9f72b1..d0d7957 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -488,6 +488,7 @@ LIB_OBJS += $(OUTPUT)tests/evsel-roundtrip-name.o
 LIB_OBJS += $(OUTPUT)tests/evsel-tp-sched.o
 LIB_OBJS += $(OUTPUT)tests/pmu.o
 LIB_OBJS += $(OUTPUT)tests/hists_link.o
+LIB_OBJS += $(OUTPUT)tests/python-use.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
@@ -955,6 +956,9 @@ $(OUTPUT)tests/attr.o: tests/attr.c $(OUTPUT)PERF-CFLAGS
 		'-DBINDIR="$(bindir_SQ)"' \
 		$<
 
+$(OUTPUT)tests/python-use.o: tests/python-use.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPYTHONPATH='"$(OUTPUT)/python"' $<
+
 $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 479d104..a164e4c 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -73,6 +73,10 @@ static struct test {
 		.func = test__hists_link,
 	},
 	{
+		.desc = "Try 'use perf' in python, checking link problems",
+		.func = test__python_use,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/python-use.c b/tools/perf/tests/python-use.c
new file mode 100644
index 0000000..15301f4
--- /dev/null
+++ b/tools/perf/tests/python-use.c
@@ -0,0 +1,23 @@
+/*
+ * Just test if we can load the python binding.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include "tests.h"
+
+extern int verbose;
+
+int test__python_use(void)
+{
+	char *cmd;
+	int ret;
+
+	if (asprintf(&cmd, "echo \"import sys ; sys.path.append('%s'); import perf\" | python %s",
+		     PYTHONPATH, verbose ? "" : "2> /dev/null") < 0)
+		return -1;
+
+	ret = system(cmd) ? -1 : 0;
+	free(cmd);
+	return ret;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 0bf1069..0ded425 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -16,5 +16,6 @@ int test__attr(void);
 int test__dso_data(void);
 int test__parse_events(void);
 int test__hists_link(void);
+int test__python_use(void);
 
 #endif /* TESTS_H */
-- 
1.8.1.1.361.gec3ae6e


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab3AYK7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:59:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41139 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab3AYK7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:59:32 -0500
Date: Fri, 25 Jan 2013 02:59:01 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-zmd2oq9gz6t1u145ub7qm2nv@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test:
  Check for linking problems in the python binding
Git-Commit-ID: 54359d3340241b4cf53e42ecd5c429d7ba6fbef3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 02:59:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54359d3340241b4cf53e42ecd5c429d7ba6fbef3
Gitweb:     http://git.kernel.org/tip/54359d3340241b4cf53e42ecd5c429d7ba6fbef3
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 14 Dec 2012 13:06:13 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:09 -0300

perf test: Check for linking problems in the python binding

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

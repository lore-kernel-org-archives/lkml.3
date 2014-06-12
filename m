Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbaFLPcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:32:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070AbaFLPb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:31:59 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 13/14] perf tests: Add test for caching dso file descriptors
Date: Thu, 12 Jun 2014 17:30:44 +0200
Message-Id: <1402587045-5461-14-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402587045-5461-1-git-send-email-jolsa@kernel.org>
References: <1402587045-5461-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding test that setup test_dso_data__fd_limit and test
dso data file descriptors are cached appropriately.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1401892622-30848-13-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/tests/builtin-test.c |   6 +-
 tools/perf/tests/dso-data.c     | 135 +++++++++++++++++++++++++++++++++++++++-
 tools/perf/tests/tests.h        |   1 +
 3 files changed, 138 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 9677a5c..b8a6358 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -52,10 +52,14 @@ static struct test {
 		.func = test__pmu,
 	},
 	{
-		.desc = "Test dso data interface",
+		.desc = "Test dso data read",
 		.func = test__dso_data,
 	},
 	{
+		.desc = "Test dso data cache",
+		.func = test__dso_data_cache,
+	},
+	{
 		.desc = "roundtrip evsel->name check",
 		.func = test__perf_evsel__roundtrip_name_test,
 	},
diff --git a/tools/perf/tests/dso-data.c b/tools/perf/tests/dso-data.c
index 7384381..2d30014 100644
--- a/tools/perf/tests/dso-data.c
+++ b/tools/perf/tests/dso-data.c
@@ -1,11 +1,12 @@
-#include "util.h"
-
 #include <stdlib.h>
 #include <linux/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <string.h>
-
+#include <sys/time.h>
+#include <sys/resource.h>
+#include <api/fs/fs.h>
+#include "util.h"
 #include "machine.h"
 #include "symbol.h"
 #include "tests.h"
@@ -154,3 +155,131 @@ int test__dso_data(void)
 	unlink(file);
 	return 0;
 }
+
+static long open_files_cnt(void)
+{
+	char path[PATH_MAX];
+	struct dirent *dent;
+	DIR *dir;
+	long nr = 0;
+
+	scnprintf(path, PATH_MAX, "%s/self/fd", procfs__mountpoint());
+	pr_debug("fd path: %s\n", path);
+
+	dir = opendir(path);
+	TEST_ASSERT_VAL("failed to open fd directory", dir);
+
+	while ((dent = readdir(dir)) != NULL) {
+		if (!strcmp(dent->d_name, ".") ||
+		    !strcmp(dent->d_name, ".."))
+			continue;
+
+		nr++;
+	}
+
+	closedir(dir);
+	return nr - 1;
+}
+
+static struct dso **dsos;
+
+static int dsos__create(int cnt, int size)
+{
+	int i;
+
+	dsos = malloc(sizeof(dsos) * cnt);
+	TEST_ASSERT_VAL("failed to alloc dsos array", dsos);
+
+	for (i = 0; i < cnt; i++) {
+		char *file;
+
+		file = test_file(size);
+		TEST_ASSERT_VAL("failed to get dso file", file);
+
+		dsos[i] = dso__new(file);
+		TEST_ASSERT_VAL("failed to get dso", dsos[i]);
+	}
+
+	return 0;
+}
+
+static void dsos__delete(int cnt)
+{
+	int i;
+
+	for (i = 0; i < cnt; i++) {
+		struct dso *dso = dsos[i];
+
+		unlink(dso->name);
+		dso__delete(dso);
+	}
+
+	free(dsos);
+}
+
+static int set_fd_limit(int n)
+{
+	struct rlimit rlim;
+
+	if (getrlimit(RLIMIT_NOFILE, &rlim))
+		return -1;
+
+	pr_debug("file limit %ld, new %d\n", (long) rlim.rlim_cur, n);
+
+	rlim.rlim_cur = n;
+	return setrlimit(RLIMIT_NOFILE, &rlim);
+}
+
+int test__dso_data_cache(void)
+{
+	struct machine machine;
+	long nr_end, nr = open_files_cnt();
+	int dso_cnt, limit, i, fd;
+
+	memset(&machine, 0, sizeof(machine));
+
+	/* set as system limit */
+	limit = nr * 4;
+	TEST_ASSERT_VAL("failed to set file limit", !set_fd_limit(limit));
+
+	/* and this is now our dso open FDs limit + 1 extra */
+	dso_cnt = limit / 2 + 1;
+	TEST_ASSERT_VAL("failed to create dsos\n",
+		!dsos__create(dso_cnt, TEST_FILE_SIZE));
+
+	for (i = 0; i < (dso_cnt - 1); i++) {
+		struct dso *dso = dsos[i];
+
+		/*
+		 * Open dsos via dso__data_fd or dso__data_read_offset.
+		 * Both opens the data file and keep it open.
+		 */
+		if (i % 2) {
+			fd = dso__data_fd(dso, &machine);
+			TEST_ASSERT_VAL("failed to get fd", fd > 0);
+		} else {
+			#define BUFSIZE 10
+			u8 buf[BUFSIZE];
+			ssize_t n;
+
+			n = dso__data_read_offset(dso, &machine, 0, buf, BUFSIZE);
+			TEST_ASSERT_VAL("failed to read dso", n == BUFSIZE);
+		}
+	}
+
+	/* open +1 dso over the allowed limit */
+	fd = dso__data_fd(dsos[i], &machine);
+	TEST_ASSERT_VAL("failed to get fd", fd > 0);
+
+	/* should force the first one to be closed */
+	TEST_ASSERT_VAL("failed to close dsos[0]", dsos[0]->data.fd == -1);
+
+	/* cleanup everything */
+	dsos__delete(dso_cnt);
+
+	/* Make sure we did not leak any file descriptor. */
+	nr_end = open_files_cnt();
+	pr_debug("nr start %ld, nr stop %ld\n", nr, nr_end);
+	TEST_ASSERT_VAL("failed leadking files", nr == nr_end);
+	return 0;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 022bb68..ccc4deb 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -28,6 +28,7 @@ int test__syscall_open_tp_fields(void);
 int test__pmu(void);
 int test__attr(void);
 int test__dso_data(void);
+int test__dso_data_cache(void);
 int test__parse_events(void);
 int test__hists_link(void);
 int test__python_use(void);
-- 
1.8.3.1


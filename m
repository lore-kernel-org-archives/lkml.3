Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbaEORY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:24:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbaEORYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:24:22 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 13/14] perf tests: Add test for caching dso file descriptors
Date: Thu, 15 May 2014 19:23:34 +0200
Message-Id: <1400174615-2121-14-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
References: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding test that setup test_dso_data__fd_limit and test
dso data file descriptors are cached appropriately.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/tests/builtin-test.c |   6 +-
 tools/perf/tests/dso-data.c     | 180 +++++++++++++++++++++++++++++++++++++++-
 tools/perf/tests/tests.h        |   1 +
 3 files changed, 183 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index fe46f3e..c4d581a 100644
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
index f5c8743..84ab939 100644
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
@@ -154,3 +155,176 @@ int test__dso_data(void)
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
+	int n;
+
+	n = scnprintf(path, PATH_MAX, "%s/self/fd", procfs__mountpoint());
+	TEST_ASSERT_VAL("couldn't get fd path", n < PATH_MAX);
+
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
+static struct dso *dsos[3];
+#define dso_0 (dsos[0])
+#define dso_1 (dsos[1])
+#define dso_2 (dsos[2])
+
+static int dsos__create(int size)
+{
+	int i;
+
+	for (i = 0; i < 3; i++) {
+		char *file;
+
+		file = test_file(size);
+		TEST_ASSERT_VAL("failed to get dso file", file);
+
+		dsos[i] = dso__new((const char *)file);
+		TEST_ASSERT_VAL("failed to get dso", dsos[i]);
+	}
+
+	return 0;
+}
+
+static void dsos__delete(void)
+{
+	int i;
+
+	for (i = 0; i < 3; i++) {
+		struct dso *dso = dsos[i];
+		unlink(dso->name);
+		dso__delete(dso);
+	}
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
+	long nr = open_files_cnt();
+#define BUFSIZE 10
+	u8 buf[BUFSIZE];
+	ssize_t n;
+	int fd;
+
+	memset(&machine, 0, sizeof(machine));
+
+	/* Make sure we are able to open 3 fds anyway */
+	TEST_ASSERT_VAL("failed to set file limit",
+			!set_fd_limit((nr + 6)));
+
+	/*
+	 * Test scenario:
+	 * - create 3 dso objects
+	 * - set the limit of opened data file descriptors to 2
+	 * - open/close dsos data fds and check for proper
+	 *   handling of the dso data cache
+	 */
+
+	test_dso_data__fd_limit = 3;
+
+	TEST_ASSERT_VAL("failed to create dsos\n", !dsos__create(TEST_FILE_SIZE));
+
+	/* open dso_0 */
+	fd = dso__data_fd(dso_0, &machine);
+	TEST_ASSERT_VAL("failed to get fd", fd > 0);
+
+	n = dso__data_read_offset(dso_0, &machine, 0, buf, BUFSIZE);
+	TEST_ASSERT_VAL("failed to read dso", n == BUFSIZE);
+
+	/*
+	 * Close dso_0 data with cache = true,
+	 * dso_0 should remain open.
+	 */
+	dso__data_close(dso_0);
+	TEST_ASSERT_VAL("failed to not close dso", dso_0->data.fd != -1);
+
+	/* open dso_1 */
+	n = dso__data_read_offset(dso_1, &machine, 0, buf, BUFSIZE);
+	TEST_ASSERT_VAL("failed to read dso", n == BUFSIZE);
+
+	/*
+	 * Close dso_1 data with cache = true,
+	 * dso_0 and dso_1 should remain open.
+	 */
+	dso__data_close(dso_1);
+	TEST_ASSERT_VAL("failed to not close dso", dso_0->data.fd != -1);
+	TEST_ASSERT_VAL("failed to not close dso", dso_1->data.fd != -1);
+
+	/* open dso_2 */
+	fd = dso__data_fd(dso_2, &machine);
+	TEST_ASSERT_VAL("failed to get fd", fd > 0);
+
+	/*
+	 * Close dso_1 data with cache = true,
+	 * dso_0 should get closed now
+	 */
+	dso__data_close(dso_2);
+	TEST_ASSERT_VAL("failed to close dso_0", dso_0->data.fd == -1);
+
+	/* reopen dso_0 */
+	fd = dso__data_fd(dso_0, &machine);
+	TEST_ASSERT_VAL("failed to get fd", fd > 0);
+
+	/*
+	 * Close dso_0 data with cache = true,
+	 * dso_1 should get closed now.
+	 */
+	dso__data_close(dso_0);
+	TEST_ASSERT_VAL("failed to close dso_1", dso_1->data.fd == -1);
+
+	/* reopen dso_1 */
+	n = dso__data_read_offset(dso_1, &machine, 0, buf, BUFSIZE);
+	TEST_ASSERT_VAL("failed to read dso", n == BUFSIZE);
+
+	/*
+	 * Close dso_1 data with cache = true,
+	 * dso_2 should get closed now.
+	 */
+	dso__data_close(dso_1);
+	TEST_ASSERT_VAL("failed to close dso_2", dso_2->data.fd == -1);
+
+	/* dso_0 remains open */
+	TEST_ASSERT_VAL("failed to keep open dso_0", dso_0->data.fd >= 0);
+
+	/* cleanup everything */
+	dsos__delete();
+
+	pr_debug("nr start %ld, nr stop %ld\n", nr, open_files_cnt());
+
+	/* Make sure we did not leak any file descriptor. */
+	TEST_ASSERT_VAL("failed leadking files", nr == open_files_cnt());
+	return 0;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index a9d7cb0..61e12b6 100644
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


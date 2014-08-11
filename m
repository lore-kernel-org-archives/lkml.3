Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaHKIum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:50:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbaHKIuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:50:37 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 03/20] perf tests: Add poller object test
Date: Mon, 11 Aug 2014 10:49:57 +0200
Message-Id: <1407747014-18394-4-git-send-email-jolsa@kernel.org>
In-Reply-To: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding some basic automated tests for poller object.

Cc: Adrian Hunter <adrian.hunter@intel.com>
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
 tools/perf/Makefile.perf        |   1 +
 tools/perf/tests/builtin-test.c |   4 ++
 tools/perf/tests/poller.c       | 126 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h        |   1 +
 4 files changed, 132 insertions(+)
 create mode 100644 tools/perf/tests/poller.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 3ef50d35f8bf..69d90285a994 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -427,6 +427,7 @@ endif
 endif
 LIB_OBJS += $(OUTPUT)tests/mmap-thread-lookup.o
 LIB_OBJS += $(OUTPUT)tests/thread-mg-share.o
+LIB_OBJS += $(OUTPUT)tests/poller.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 6f8b01bc6033..e2e3827ebd17 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -154,6 +154,10 @@ static struct test {
 		.func = test__hists_cumulate,
 	},
 	{
+		.desc = "Test poller",
+		.func = test__poller,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/poller.c b/tools/perf/tests/poller.c
new file mode 100644
index 000000000000..11a7f1310172
--- /dev/null
+++ b/tools/perf/tests/poller.c
@@ -0,0 +1,126 @@
+#include <linux/compiler.h>
+#include <unistd.h>
+#include "tests.h"
+#include "poller.h"
+#include "debug.h"
+
+static int reader_hup_cnt;
+static int reader_data_cnt;
+static int writer_error_cnt;
+static int wrong_cnt;
+
+static int reader_hup_cb(struct poller *p __maybe_unused,
+			 struct poller_item *item __maybe_unused)
+{
+	pr_debug("got reader_hup_cb\n");
+	reader_hup_cnt++;
+	return 0;
+}
+
+static int reader_data_cb(struct poller *p __maybe_unused,
+			  struct poller_item *item __maybe_unused)
+{
+	pr_debug("got reader_data_cb\n");
+	reader_data_cnt++;
+	return 0;
+}
+
+static int writer_error_cb(struct poller *p __maybe_unused,
+			   struct poller_item *item __maybe_unused)
+{
+	pr_debug("got writer_error_cb\n");
+	writer_error_cnt++;
+	return 0;
+}
+
+static int wrong_cb(struct poller *p __maybe_unused,
+		    struct poller_item *item __maybe_unused)
+{
+	pr_debug("got wrong_cb\n");
+	wrong_cnt++;
+	return 0;
+}
+
+typedef int (*pipe_test_cb)(struct poller *p, int *pipefd);
+
+static int test_hup(struct poller *poller, int *pipefd)
+{
+	/* We close the writer, we should get HUP on reader. */
+	close(pipefd[1]);
+	poller__poll(poller, -1);
+
+	TEST_ASSERT_VAL("failed to get read hup", reader_hup_cnt == 1);
+	TEST_ASSERT_VAL("failed, got wrong cnt", !wrong_cnt);
+	return 0;
+}
+
+static int test_error(struct poller *poller, int *pipefd)
+{
+	/* We close the reader, we should get ERROR on writer. */
+	close(pipefd[0]);
+	poller__poll(poller, -1);
+
+	TEST_ASSERT_VAL("failed to get write error", writer_error_cnt == 1);
+	TEST_ASSERT_VAL("failed, got wrong cnt", !wrong_cnt);
+	return 0;
+}
+
+static int test_data(struct poller *poller, int *pipefd)
+{
+	int data = 1;
+
+	/* Writing data into writer, we should get data IN on reader. */
+	TEST_ASSERT_VAL("failed to write data",
+		write(pipefd[1], &data, sizeof(data)) == sizeof(data));
+
+	poller__poll(poller, -1);
+
+	TEST_ASSERT_VAL("failed to get reader data", reader_data_cnt == 1);
+	TEST_ASSERT_VAL("failed, got wrong cnt", !wrong_cnt);
+	return 0;
+}
+
+static int test_pipe(pipe_test_cb test)
+{
+	struct poller poller;
+	struct poller_item reader = {
+		.ops = {
+			.data  = reader_data_cb,
+			.error = wrong_cb,
+			.hup   = reader_hup_cb,
+		},
+	};
+	struct poller_item writer = {
+		.ops = {
+			.data  = wrong_cb,
+			.error = writer_error_cb,
+			.hup   = wrong_cb,
+		},
+	};
+	int pipefd[2], err;
+
+	TEST_ASSERT_VAL("failed to create pipe", !pipe(pipefd));
+
+	poller__init(&poller);
+
+	reader.fd = pipefd[0];
+	TEST_ASSERT_VAL("failed to add reader", !poller__add(&poller, &reader));
+
+	writer.fd = pipefd[1];
+	TEST_ASSERT_VAL("failed to add writer", !poller__add(&poller, &writer));
+
+	err = test(&poller, pipefd);
+
+	poller__cleanup(&poller);
+	close(pipefd[0]);
+	close(pipefd[1]);
+	return err;
+}
+
+int test__poller(void)
+{
+	TEST_ASSERT_VAL("failed to test HUP  ", !test_pipe(test_hup));
+	TEST_ASSERT_VAL("failed to test ERROR", !test_pipe(test_error));
+	TEST_ASSERT_VAL("failed to test DATA ", !test_pipe(test_data));
+	return 0;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index ed64790a395f..e2a76d509644 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -48,6 +48,7 @@ int test__mmap_thread_lookup(void);
 int test__thread_mg_share(void);
 int test__hists_output(void);
 int test__hists_cumulate(void);
+int test__poller(void);
 
 #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
-- 
1.8.3.1


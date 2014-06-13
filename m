Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaFMG1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:27:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44260 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaFMG1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:27:40 -0400
Date: Thu, 12 Jun 2014 23:27:22 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-45dc1bb5c1d47f9519e2101f6b073bb4bb1d1f99@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1401892622-30848-14-git-send-email-jolsa@kernel.org>
References: <1401892622-30848-14-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Add test for closing dso objects on EMFILE error
Git-Commit-ID: 45dc1bb5c1d47f9519e2101f6b073bb4bb1d1f99
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

Commit-ID:  45dc1bb5c1d47f9519e2101f6b073bb4bb1d1f99
Gitweb:     http://git.kernel.org/tip/45dc1bb5c1d47f9519e2101f6b073bb4bb1d1f99
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 12 May 2014 14:50:03 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 12 Jun 2014 16:53:23 +0200

perf tests: Add test for closing dso objects on EMFILE error

Testing that perf properly closes opened dso objects
and tries to reopen in case we run out of allowed file
descriptors for dso data.

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
Reviewed by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1401892622-30848-14-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/tests/builtin-test.c |  4 +++
 tools/perf/tests/dso-data.c     | 73 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h        |  1 +
 3 files changed, 78 insertions(+)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index b8a6358..6f8b01b 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -60,6 +60,10 @@ static struct test {
 		.func = test__dso_data_cache,
 	},
 	{
+		.desc = "Test dso data reopen",
+		.func = test__dso_data_reopen,
+	},
+	{
 		.desc = "roundtrip evsel->name check",
 		.func = test__perf_evsel__roundtrip_name_test,
 	},
diff --git a/tools/perf/tests/dso-data.c b/tools/perf/tests/dso-data.c
index 2d30014..630808c 100644
--- a/tools/perf/tests/dso-data.c
+++ b/tools/perf/tests/dso-data.c
@@ -283,3 +283,76 @@ int test__dso_data_cache(void)
 	TEST_ASSERT_VAL("failed leadking files", nr == nr_end);
 	return 0;
 }
+
+int test__dso_data_reopen(void)
+{
+	struct machine machine;
+	long nr_end, nr = open_files_cnt();
+	int fd, fd_extra;
+
+#define dso_0 (dsos[0])
+#define dso_1 (dsos[1])
+#define dso_2 (dsos[2])
+
+	memset(&machine, 0, sizeof(machine));
+
+	/*
+	 * Test scenario:
+	 * - create 3 dso objects
+	 * - set process file descriptor limit to current
+	 *   files count + 3
+	 * - test that the first dso gets closed when we
+	 *   reach the files count limit
+	 */
+
+	/* Make sure we are able to open 3 fds anyway */
+	TEST_ASSERT_VAL("failed to set file limit",
+			!set_fd_limit((nr + 3)));
+
+	TEST_ASSERT_VAL("failed to create dsos\n", !dsos__create(3, TEST_FILE_SIZE));
+
+	/* open dso_0 */
+	fd = dso__data_fd(dso_0, &machine);
+	TEST_ASSERT_VAL("failed to get fd", fd > 0);
+
+	/* open dso_1 */
+	fd = dso__data_fd(dso_1, &machine);
+	TEST_ASSERT_VAL("failed to get fd", fd > 0);
+
+	/*
+	 * open extra file descriptor and we just
+	 * reached the files count limit
+	 */
+	fd_extra = open("/dev/null", O_RDONLY);
+	TEST_ASSERT_VAL("failed to open extra fd", fd_extra > 0);
+
+	/* open dso_2 */
+	fd = dso__data_fd(dso_2, &machine);
+	TEST_ASSERT_VAL("failed to get fd", fd > 0);
+
+	/*
+	 * dso_0 should get closed, because we reached
+	 * the file descriptor limit
+	 */
+	TEST_ASSERT_VAL("failed to close dso_0", dso_0->data.fd == -1);
+
+	/* open dso_0 */
+	fd = dso__data_fd(dso_0, &machine);
+	TEST_ASSERT_VAL("failed to get fd", fd > 0);
+
+	/*
+	 * dso_1 should get closed, because we reached
+	 * the file descriptor limit
+	 */
+	TEST_ASSERT_VAL("failed to close dso_1", dso_1->data.fd == -1);
+
+	/* cleanup everything */
+	close(fd_extra);
+	dsos__delete(3);
+
+	/* Make sure we did not leak any file descriptor. */
+	nr_end = open_files_cnt();
+	pr_debug("nr start %ld, nr stop %ld\n", nr, nr_end);
+	TEST_ASSERT_VAL("failed leadking files", nr == nr_end);
+	return 0;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index ccc4deb..ed64790 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -29,6 +29,7 @@ int test__pmu(void);
 int test__attr(void);
 int test__dso_data(void);
 int test__dso_data_cache(void);
+int test__dso_data_reopen(void);
 int test__parse_events(void);
 int test__hists_link(void);
 int test__python_use(void);

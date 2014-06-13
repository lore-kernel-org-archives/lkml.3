Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaFMG1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:27:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44220 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaFMG1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:27:05 -0400
Date: Thu, 12 Jun 2014 23:26:48 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-0d8a5faaf5a1087c7212a6f0d81920a93396414a@git.kernel.org>
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
In-Reply-To: <1401892622-30848-11-git-send-email-jolsa@kernel.org>
References: <1401892622-30848-11-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Spawn child for each test
Git-Commit-ID: 0d8a5faaf5a1087c7212a6f0d81920a93396414a
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

Commit-ID:  0d8a5faaf5a1087c7212a6f0d81920a93396414a
Gitweb:     http://git.kernel.org/tip/0d8a5faaf5a1087c7212a6f0d81920a93396414a
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Sat, 10 May 2014 17:22:30 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 12 Jun 2014 16:53:22 +0200

perf tests: Spawn child for each test

In upcoming tests we will setup process limits, which
might affect other tests. Spawning child for each test
to prevent this.

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
Reviewed-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1401892622-30848-11-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/tests/builtin-test.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 802e3cd..9677a5c 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -3,6 +3,8 @@
  *
  * Builtin regression testing command: ever growing number of sanity tests
  */
+#include <unistd.h>
+#include <string.h>
 #include "builtin.h"
 #include "intlist.h"
 #include "tests.h"
@@ -172,6 +174,34 @@ static bool perf_test__matches(int curr, int argc, const char *argv[])
 	return false;
 }
 
+static int run_test(struct test *test)
+{
+	int status, err = -1, child = fork();
+
+	if (child < 0) {
+		pr_err("failed to fork test: %s\n", strerror(errno));
+		return -1;
+	}
+
+	if (!child) {
+		pr_debug("test child forked, pid %d\n", getpid());
+		err = test->func();
+		exit(err);
+	}
+
+	wait(&status);
+
+	if (WIFEXITED(status)) {
+		err = WEXITSTATUS(status);
+		pr_debug("test child finished with %d\n", err);
+	} else if (WIFSIGNALED(status)) {
+		err = -1;
+		pr_debug("test child interrupted\n");
+	}
+
+	return err;
+}
+
 static int __cmd_test(int argc, const char *argv[], struct intlist *skiplist)
 {
 	int i = 0;
@@ -200,7 +230,7 @@ static int __cmd_test(int argc, const char *argv[], struct intlist *skiplist)
 		}
 
 		pr_debug("\n--- start ---\n");
-		err = tests[curr].func();
+		err = run_test(&tests[curr]);
 		pr_debug("---- end ----\n%s:", tests[curr].desc);
 
 		switch (err) {

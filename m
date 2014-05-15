Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbaEORZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:25:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbaEORYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:24:17 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/14] perf tests: Spawn child for each test
Date: Thu, 15 May 2014 19:23:31 +0200
Message-Id: <1400174615-2121-11-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
References: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In upcoming tests we will setup process limits, which
might affect other tests. Spawning child for each test
to prevent this.

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
 tools/perf/tests/builtin-test.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 0d5afaf..fe46f3e 100644
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
@@ -164,6 +166,34 @@ static bool perf_test__matches(int curr, int argc, const char *argv[])
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
@@ -192,7 +222,7 @@ static int __cmd_test(int argc, const char *argv[], struct intlist *skiplist)
 		}
 
 		pr_debug("\n--- start ---\n");
-		err = tests[curr].func();
+		err = run_test(&tests[curr]);
 		pr_debug("---- end ----\n%s:", tests[curr].desc);
 
 		switch (err) {
-- 
1.8.3.1


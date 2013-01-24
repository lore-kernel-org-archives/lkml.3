Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab3AXUUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:20:04 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54070
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755875Ab3AXUIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:43 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 24/74] perf tests: Add return states enum for tests
Date: Thu, 24 Jan 2013 17:07:33 -0300
Message-Id: <1359058103-31645-25-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Test can currently return one of 3 states: ok, fail, skip.

The ok and fail states are self-explanatory. The skip state means that
some of the conditions for running the test was not met, making it
impossible to even run the test. For instance, if the hardware doesn't
support the 'precise' level required by a test, it will be skipped.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: http://lkml.kernel.org/n/tip-04vnsdndarctfb1eii5c9hcy@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/builtin-test.c | 15 ++++++++++++---
 tools/perf/tests/tests.h        |  6 ++++++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index a164e4c..6a5dee2 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -129,10 +129,19 @@ static int __cmd_test(int argc, const char *argv[])
 		pr_debug("\n--- start ---\n");
 		err = tests[curr].func();
 		pr_debug("---- end ----\n%s:", tests[curr].desc);
-		if (err)
-			color_fprintf(stderr, PERF_COLOR_RED, " FAILED!\n");
-		else
+
+		switch (err) {
+		case TEST_OK:
 			pr_info(" Ok\n");
+			break;
+		case TEST_SKIP:
+			color_fprintf(stderr, PERF_COLOR_YELLOW, " Skip\n");
+			break;
+		case TEST_FAIL:
+		default:
+			color_fprintf(stderr, PERF_COLOR_RED, " FAILED!\n");
+			break;
+		}
 	}
 
 	return 0;
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 0ded425..5de0be1 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -1,6 +1,12 @@
 #ifndef TESTS_H
 #define TESTS_H
 
+enum {
+	TEST_OK   =  0,
+	TEST_FAIL = -1,
+	TEST_SKIP = -2,
+};
+
 /* Tests */
 int test__vmlinux_matches_kallsyms(void);
 int test__open_syscall_event(void);
-- 
1.8.1.1.361.gec3ae6e


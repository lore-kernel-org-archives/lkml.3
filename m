Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab3AYLQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:16:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41472 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab3AYLQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:16:14 -0500
Date: Fri, 25 Jan 2013 03:15:30 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-04vnsdndarctfb1eii5c9hcy@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add return states enum for tests
Git-Commit-ID: f4c1ea5f2a6b9e1c0aaa874ffb25fe4a4f9f1a3f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:15:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4c1ea5f2a6b9e1c0aaa874ffb25fe4a4f9f1a3f
Gitweb:     http://git.kernel.org/tip/f4c1ea5f2a6b9e1c0aaa874ffb25fe4a4f9f1a3f
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 19 Dec 2012 11:33:39 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:14 -0300

perf tests: Add return states enum for tests

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

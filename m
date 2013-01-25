Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab3AYMPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:15:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42456 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174Ab3AYMPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:15:45 -0500
Date: Fri, 25 Jan 2013 04:15:18 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-klzd8p57jzdryafqkmlppcb1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test: Allow skipping tests
Git-Commit-ID: 2ae828786c65ab8f587647bd0f22f8fe00f1f238
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 04:15:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ae828786c65ab8f587647bd0f22f8fe00f1f238
Gitweb:     http://git.kernel.org/tip/2ae828786c65ab8f587647bd0f22f8fe00f1f238
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 24 Jan 2013 16:22:55 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:53 -0300

perf test: Allow skipping tests

Sometimes a test is problematic for some reason and one wants to skip it,
for instance:

[root@sandy ~]# perf test
   1: vmlinux symtab matches kallsyms                        : Ok
   2: detect open syscall event                              : Ok
   3: detect open syscall event on all cpus                  : Ok
   4: read samples using the mmap interface                  : Ok
   5: parse events tests                                     :  Warning: bad op token {
    Warning: bad op token {
    Warning: bad op token {
    Warning: bad op token {
    Warning: bad op token {
    Warning: function is_writable_pte not defined
  Segmentation fault (core dumped)

So now we can use -s/--skip while the problematic tests are being fixed,
allowing us to test all the other entries:

  [root@sandy ~]# perf test -s 5
   1: vmlinux symtab matches kallsyms                        : Ok
   2: detect open syscall event                              : Ok
   3: detect open syscall event on all cpus                  : Ok
   4: read samples using the mmap interface                  : Ok
   5: parse events tests                                     : Skip (user override)
   6: x86 rdpmc test                                         : Ok
   7: Validate PERF_RECORD_* events & perf_sample fields     : Ok
   8: Test perf pmu format parsing                           : Ok
   9: Test dso data interface                                : Ok
  10: roundtrip evsel->name check                            : Ok
  11: Check parsing of sched tracepoints fields              : Ok
  12: Generate and check syscalls:sys_enter_open event fields: Ok
  13: struct perf_event_attr setup                           : Ok
  14: Test matching and linking mutliple hists               : Ok
  15: Try 'use perf' in python, checking link problems       : Ok
  [root@sandy ~]#

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-klzd8p57jzdryafqkmlppcb1@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-test.txt |  4 ++++
 tools/perf/tests/builtin-test.c        | 17 +++++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-test.txt b/tools/perf/Documentation/perf-test.txt
index b24ac40..d1d3e5121 100644
--- a/tools/perf/Documentation/perf-test.txt
+++ b/tools/perf/Documentation/perf-test.txt
@@ -23,6 +23,10 @@ from 'perf test list'.
 
 OPTIONS
 -------
+-s::
+--skip::
+	Tests to skip (comma separater numeric list).
+
 -v::
 --verbose::
 	Be more verbose.
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 6a5dee2..acb98e0 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -4,6 +4,7 @@
  * Builtin regression testing command: ever growing number of sanity tests
  */
 #include "builtin.h"
+#include "intlist.h"
 #include "tests.h"
 #include "debug.h"
 #include "color.h"
@@ -105,7 +106,7 @@ static bool perf_test__matches(int curr, int argc, const char *argv[])
 	return false;
 }
 
-static int __cmd_test(int argc, const char *argv[])
+static int __cmd_test(int argc, const char *argv[], struct intlist *skiplist)
 {
 	int i = 0;
 	int width = 0;
@@ -126,6 +127,12 @@ static int __cmd_test(int argc, const char *argv[])
 			continue;
 
 		pr_info("%2d: %-*s:", i, width, tests[curr].desc);
+
+		if (intlist__find(skiplist, i)) {
+			color_fprintf(stderr, PERF_COLOR_YELLOW, " Skip (user override)\n");
+			continue;
+		}
+
 		pr_debug("\n--- start ---\n");
 		err = tests[curr].func();
 		pr_debug("---- end ----\n%s:", tests[curr].desc);
@@ -169,11 +176,14 @@ int cmd_test(int argc, const char **argv, const char *prefix __maybe_unused)
 	"perf test [<options>] [{list <test-name-fragment>|[<test-name-fragments>|<test-numbers>]}]",
 	NULL,
 	};
+	const char *skip = NULL;
 	const struct option test_options[] = {
+	OPT_STRING('s', "skip", &skip, "tests", "tests to skip"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
 	OPT_END()
 	};
+	struct intlist *skiplist = NULL;
 
 	argc = parse_options(argc, argv, test_options, test_usage, 0);
 	if (argc >= 1 && !strcmp(argv[0], "list"))
@@ -186,5 +196,8 @@ int cmd_test(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (symbol__init() < 0)
 		return -1;
 
-	return __cmd_test(argc, argv);
+	if (skip != NULL)
+		skiplist = intlist__new(skip);
+
+	return __cmd_test(argc, argv, skiplist);
 }

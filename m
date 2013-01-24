Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab3AXUNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:13:21 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54104
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755965Ab3AXUIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:54 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 74/74] perf test: Allow skipping tests
Date: Thu, 24 Jan 2013 17:08:23 -0300
Message-Id: <1359058103-31645-75-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.8.1.1.361.gec3ae6e


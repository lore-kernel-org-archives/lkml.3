Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3KAO5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:57:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53261 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab3KAO5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:57:01 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/3] perf test: Update command line callchain attribute tests
Date: Fri,  1 Nov 2013 11:56:47 -0300
Message-Id: <1383317807-25062-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383317807-25062-1-git-send-email-acme@infradead.org>
References: <1383317807-25062-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The "struct perf_event_attr setup" entry in 'perf test' is in fact a
series of tests that will exec the tools, passing different sets of
command line arguments to then intercept the sys_perf_event_open
syscall, in user space, to check that the perf_event_attr->sample_type
and other feature request bits are setup as expected.

We recently restored the callchain requesting command line argument, -g,
to not require a parameter ("dwarf" or "fp"), instead using a default
("fp" for now) and making the long option variant, --call-chain, be the
one to be used when a different callchain collection method is
preferred.

The "struct perf_event_attr setup" test failed because we forgot to
update the tests involving callchains, not switching from, '-g dwarf' to
'--call-chain dwarf', making 'perf test' detect it:

  [root@sandy ~]# perf test -v 13
  13: struct perf_event_attr setup                           :
  --- start ---
  running '/home/acme/libexec/perf-core/tests/attr/test-record-basic'
  running '/home/acme/libexec/perf-core/tests/attr/test-record-branch-any'
  <SNIP>
  running '/home/acme/libexec/perf-core/tests/attr/test-record-graph-default'
  running '/home/acme/libexec/perf-core/tests/attr/test-record-graph-dwarf'
  expected sample_type=12583, got 295
  expected exclude_callchain_user=1, got 0
  expected sample_stack_user=8192, got 0
  FAILED '/home/acme/libexec/perf-core/tests/attr/test-record-graph-dwarf' - match failure
  ---- end ----
  struct perf_event_attr setup: FAILED!
  [root@sandy ~]#

Fix all of them now to use --call-chain when explicitely specifying a
method.

There is still work to do, as '-g fp', for instance, passed without
problems.

In that case 'perf test' saw no problems as the intercepted syscall got
the bits as expected, i.e. the default is 'fp', but the fact that 'fp'
may be an existing program and the specified workload would then be
passed as a parameter to it is an usability problem that needs fixing.

Next merge window tho.

Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-jr3oq1k5iywnp7vvqlslzydm@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/README                    | 6 +++---
 tools/perf/tests/attr/test-record-graph-default | 2 +-
 tools/perf/tests/attr/test-record-graph-dwarf   | 2 +-
 tools/perf/tests/attr/test-record-graph-fp      | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/tests/attr/README b/tools/perf/tests/attr/README
index d102957cd59a..430024f618f1 100644
--- a/tools/perf/tests/attr/README
+++ b/tools/perf/tests/attr/README
@@ -44,9 +44,9 @@ Following tests are defined (with perf commands):
   perf record -c 123 kill                       (test-record-count)
   perf record -d kill                           (test-record-data)
   perf record -F 100 kill                       (test-record-freq)
-  perf record -g -- kill                        (test-record-graph-default)
-  perf record -g dwarf -- kill                  (test-record-graph-dwarf)
-  perf record -g fp kill                        (test-record-graph-fp)
+  perf record -g kill                           (test-record-graph-default)
+  perf record --call-graph dwarf kill		(test-record-graph-dwarf)
+  perf record --call-graph fp kill              (test-record-graph-fp)
   perf record --group -e cycles,instructions kill (test-record-group)
   perf record -e '{cycles,instructions}' kill   (test-record-group1)
   perf record -D kill                           (test-record-no-delay)
diff --git a/tools/perf/tests/attr/test-record-graph-default b/tools/perf/tests/attr/test-record-graph-default
index 833d1849d767..853597a9a8f6 100644
--- a/tools/perf/tests/attr/test-record-graph-default
+++ b/tools/perf/tests/attr/test-record-graph-default
@@ -1,6 +1,6 @@
 [config]
 command = record
-args    = -g -- kill >/dev/null 2>&1
+args    = -g kill >/dev/null 2>&1
 
 [event:base-record]
 sample_type=295
diff --git a/tools/perf/tests/attr/test-record-graph-dwarf b/tools/perf/tests/attr/test-record-graph-dwarf
index e93e082f5208..d6f324ea578c 100644
--- a/tools/perf/tests/attr/test-record-graph-dwarf
+++ b/tools/perf/tests/attr/test-record-graph-dwarf
@@ -1,6 +1,6 @@
 [config]
 command = record
-args    = -g dwarf -- kill >/dev/null 2>&1
+args    = --call-graph dwarf -- kill >/dev/null 2>&1
 
 [event:base-record]
 sample_type=12583
diff --git a/tools/perf/tests/attr/test-record-graph-fp b/tools/perf/tests/attr/test-record-graph-fp
index 7cef3743f03f..055e3bee7993 100644
--- a/tools/perf/tests/attr/test-record-graph-fp
+++ b/tools/perf/tests/attr/test-record-graph-fp
@@ -1,6 +1,6 @@
 [config]
 command = record
-args    = -g fp kill >/dev/null 2>&1
+args    = --call-graph fp kill >/dev/null 2>&1
 
 [event:base-record]
 sample_type=295
-- 
1.8.1.4


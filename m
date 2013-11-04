Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab3KDG4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 01:56:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42472 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab3KDG4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 01:56:01 -0500
Date: Sun, 3 Nov 2013 22:54:49 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-jr3oq1k5iywnp7vvqlslzydm@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test:
  Update command line callchain attribute tests
Git-Commit-ID: 46d525eae2a076adfde92dca1db12d9a3b8ad8bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 03 Nov 2013 22:54:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46d525eae2a076adfde92dca1db12d9a3b8ad8bb
Gitweb:     http://git.kernel.org/tip/46d525eae2a076adfde92dca1db12d9a3b8ad8bb
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 31 Oct 2013 09:46:59 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 1 Nov 2013 10:42:57 -0300

perf test: Update command line callchain attribute tests

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
index d102957..430024f 100644
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
index 833d184..853597a 100644
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
index e93e082..d6f324e 100644
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
index 7cef374..055e3be 100644
--- a/tools/perf/tests/attr/test-record-graph-fp
+++ b/tools/perf/tests/attr/test-record-graph-fp
@@ -1,6 +1,6 @@
 [config]
 command = record
-args    = -g fp kill >/dev/null 2>&1
+args    = --call-graph fp kill >/dev/null 2>&1
 
 [event:base-record]
 sample_type=295

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab3AYLAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:00:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41174 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab3AYLAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:00:48 -0500
Date: Fri, 25 Jan 2013 03:00:12 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-0rsca2kn44b38rgdpr3tz6n5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf python:
  Fix breakage introduced by the test_attr infrastructure
Git-Commit-ID: 0c6332e9d8b8f38a9d5f0cdd66c5575e76ad8995
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:00:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c6332e9d8b8f38a9d5f0cdd66c5575e76ad8995
Gitweb:     http://git.kernel.org/tip/0c6332e9d8b8f38a9d5f0cdd66c5575e76ad8995
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 13 Dec 2012 16:43:04 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:09 -0300

perf python: Fix breakage introduced by the test_attr infrastructure

The test_attr infrastructure hooks on the sys_perf_event_open call,
checking if a variable is set and if so calling a function to intercept
calls and do the checking.

But both the variable and the function aren't on objects that are
linked on the python binding, breaking it:

  # perf test -v 15
  15: Try 'use perf' in python, checking link problems       :
  --- start ---
  Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
  ImportError: /home/acme/git/build/perf//python/perf.so: undefined symbol: test_attr__enabled
  ---- end ----
  Try 'use perf' in python, checking link problems: FAILED!
  #

Fix it by moving the variable to one of the linked object files and
providing a stub for the function in the python.o object, that is only
linked in the python binding.

Now 'perf test' is happy again:

  # perf test 15
  15: Try 'use perf' in python, checking link problems       : Ok
  #

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-0rsca2kn44b38rgdpr3tz6n5@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr.c  | 2 --
 tools/perf/util/python.c | 9 +++++++++
 tools/perf/util/util.c   | 2 ++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index 25638a9..05b5acb 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -33,8 +33,6 @@
 
 extern int verbose;
 
-bool test_attr__enabled;
-
 static char *dir;
 
 void test_attr__init(void)
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index a2657fd..925e0c3 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -1045,3 +1045,12 @@ error:
 	if (PyErr_Occurred())
 		PyErr_SetString(PyExc_ImportError, "perf: Init failed!");
 }
+
+/*
+ * Dummy, to avoid dragging all the test_attr infrastructure in the python
+ * binding.
+ */
+void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
+                     int fd, int group_fd, unsigned long flags)
+{
+}
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 5906e84..252b889 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -12,6 +12,8 @@
  */
 unsigned int page_size;
 
+bool test_attr__enabled;
+
 bool perf_host  = true;
 bool perf_guest = false;
 

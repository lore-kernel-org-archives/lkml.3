Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3AXUTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:19:19 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54087
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755916Ab3AXUIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:46 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 11/74] perf python: Fix breakage introduced by the test_attr infrastructure
Date: Thu, 24 Jan 2013 17:07:20 -0300
Message-Id: <1359058103-31645-12-git-send-email-acme@infradead.org>
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
 
-- 
1.8.1.1.361.gec3ae6e


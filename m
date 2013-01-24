Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422644Ab3AXUdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:33:51 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54051
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755847Ab3AXUIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:40 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/74] perf tests: Check python path on attr and binding test
Date: Thu, 24 Jan 2013 17:07:24 -0300
Message-Id: <1359058103-31645-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Current perf test code tries to execute python version 2 in order to
test attributes on perf_event_open syscall.  However it's not default
python version anymore a system can have python v3 only or v2 with a
different name (e.g. python2).  So if there's no such python interpreter
with the name 'python', the test would fail like this (yes, it's
happened on my new archlinux laptop :).

13: struct perf_event_attr setup                 :sh: python: command not found
 FAILED!

As we can pass name of the python interpreter on make, use it for
the attr test also.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1355729101-31317-1-git-send-email-namhyung@kernel.org
[ committer note: Added the same mechanism to the python binding test ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile           | 7 +++++--
 tools/perf/tests/attr.c       | 2 +-
 tools/perf/tests/python-use.c | 4 ++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d0d7957..3158f45 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -953,11 +953,14 @@ $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
 
 $(OUTPUT)tests/attr.o: tests/attr.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
-		'-DBINDIR="$(bindir_SQ)"' \
+		'-DBINDIR="$(bindir_SQ)"' -DPYTHON='"$(PYTHON_WORD)"' \
 		$<
 
 $(OUTPUT)tests/python-use.o: tests/python-use.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPYTHONPATH='"$(OUTPUT)/python"' $<
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
+		-DPYTHONPATH='"$(OUTPUT)/python"' \
+		-DPYTHON='"$(PYTHON_WORD)"' \
+		$<
 
 $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index 05b5acb..f61dd3f 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -144,7 +144,7 @@ static int run_dir(const char *d, const char *perf)
 {
 	char cmd[3*PATH_MAX];
 
-	snprintf(cmd, 3*PATH_MAX, "python %s/attr.py -d %s/attr/ -p %s %s",
+	snprintf(cmd, 3*PATH_MAX, PYTHON " %s/attr.py -d %s/attr/ -p %s %s",
 		 d, d, perf, verbose ? "-v" : "");
 
 	return system(cmd);
diff --git a/tools/perf/tests/python-use.c b/tools/perf/tests/python-use.c
index 15301f4..7760277 100644
--- a/tools/perf/tests/python-use.c
+++ b/tools/perf/tests/python-use.c
@@ -13,8 +13,8 @@ int test__python_use(void)
 	char *cmd;
 	int ret;
 
-	if (asprintf(&cmd, "echo \"import sys ; sys.path.append('%s'); import perf\" | python %s",
-		     PYTHONPATH, verbose ? "" : "2> /dev/null") < 0)
+	if (asprintf(&cmd, "echo \"import sys ; sys.path.append('%s'); import perf\" | %s %s",
+		     PYTHONPATH, PYTHON, verbose ? "" : "2> /dev/null") < 0)
 		return -1;
 
 	ret = system(cmd) ? -1 : 0;
-- 
1.8.1.1.361.gec3ae6e


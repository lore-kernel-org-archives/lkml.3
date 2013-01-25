Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab3AYLFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:05:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41256 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab3AYLFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:05:42 -0500
Date: Fri, 25 Jan 2013 03:04:55 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-000ae33fdb5ff7bc7ae985b43e6278024a4985c2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org,
        jolsa@redhat.com
In-Reply-To: <1355729101-31317-1-git-send-email-namhyung@kernel.org>
References: <1355729101-31317-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Check python path on attr and binding test
Git-Commit-ID: 000ae33fdb5ff7bc7ae985b43e6278024a4985c2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:05:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  000ae33fdb5ff7bc7ae985b43e6278024a4985c2
Gitweb:     http://git.kernel.org/tip/000ae33fdb5ff7bc7ae985b43e6278024a4985c2
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 17 Dec 2012 16:25:01 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:10 -0300

perf tests: Check python path on attr and binding test

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

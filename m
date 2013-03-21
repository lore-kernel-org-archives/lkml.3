Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab3CUKzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:55:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56049 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab3CUKzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:55:53 -0400
Date: Thu, 21 Mar 2013 03:54:03 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-097c87582c5719adbd8b700f4250e1f1d9f15ebf@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, oleg@redhat.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, oleg@redhat.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1361785972-7431-3-git-send-email-jolsa@redhat.com>
References: <1361785972-7431-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Make attr script verbose friendly
Git-Commit-ID: 097c87582c5719adbd8b700f4250e1f1d9f15ebf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 03:54:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  097c87582c5719adbd8b700f4250e1f1d9f15ebf
Gitweb:     http://git.kernel.org/tip/097c87582c5719adbd8b700f4250e1f1d9f15ebf
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 25 Feb 2013 10:52:49 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:05:59 -0300

perf tests: Make attr script verbose friendly

Making the attr test script runner to pass proper verbose option. Also
making single '-v' be more reader friendly and display just the test
name.

Making the current output to be display for '-vv'.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1361785972-7431-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr.c  | 9 +++++++--
 tools/perf/tests/attr.py | 4 ++--
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index bdcceb8..038de3e 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -147,10 +147,15 @@ void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
 
 static int run_dir(const char *d, const char *perf)
 {
+	char v[] = "-vvvvv";
+	int vcnt = min(verbose, (int) sizeof(v) - 1);
 	char cmd[3*PATH_MAX];
 
-	snprintf(cmd, 3*PATH_MAX, PYTHON " %s/attr.py -d %s/attr/ -p %s %s",
-		 d, d, perf, verbose ? "-v" : "");
+	if (verbose)
+		vcnt++;
+
+	snprintf(cmd, 3*PATH_MAX, PYTHON " %s/attr.py -d %s/attr/ -p %s %.*s",
+		 d, d, perf, vcnt, v);
 
 	return system(cmd);
 }
diff --git a/tools/perf/tests/attr.py b/tools/perf/tests/attr.py
index 2f629ca..e0ea513 100644
--- a/tools/perf/tests/attr.py
+++ b/tools/perf/tests/attr.py
@@ -121,7 +121,7 @@ class Test(object):
         parser = ConfigParser.SafeConfigParser()
         parser.read(path)
 
-        log.debug("running '%s'" % path)
+        log.warning("running '%s'" % path)
 
         self.path     = path
         self.test_dir = options.test_dir
@@ -172,7 +172,7 @@ class Test(object):
               self.perf, self.command, tempdir, self.args)
         ret = os.WEXITSTATUS(os.system(cmd))
 
-        log.warning("  running '%s' ret %d " % (cmd, ret))
+        log.info("  '%s' ret %d " % (cmd, ret))
 
         if ret != int(self.ret):
             raise Unsup(self)

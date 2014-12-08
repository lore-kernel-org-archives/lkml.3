Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaLHGuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:50:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34665 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbaLHGuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:50:12 -0500
Date: Sun, 7 Dec 2014 22:50:01 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-f78eaef0e0493f6068777a246b9c4d9d5cf2b7aa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        acme@redhat.com, mingo@kernel.org, hpa@zytor.com, tglx@linutronix.de,
        ak@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, jolsa@redhat.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org, ak@linux.intel.com,
        tglx@linutronix.de
In-Reply-To: <1416605880-25055-2-git-send-email-andi@firstfloor.org>
References: <1416605880-25055-2-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Allow to force redirect pr_debug to stderr.
Git-Commit-ID: f78eaef0e0493f6068777a246b9c4d9d5cf2b7aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f78eaef0e0493f6068777a246b9c4d9d5cf2b7aa
Gitweb:     http://git.kernel.org/tip/f78eaef0e0493f6068777a246b9c4d9d5cf2b7aa
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Fri, 21 Nov 2014 13:38:00 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Nov 2014 18:03:48 -0300

perf tools: Allow to force redirect pr_debug to stderr.

When debugging the tui browser I find it useful to redirect the debug
log into a file. Currently it's always forced to the message line.

Add an option to force it to stderr. Then it can be easily redirected.

Example:

  [root@zoo ~]# perf --debug stderr report -vv 2> /tmp/debug
  [root@zoo ~]# tail /tmp/debug
  dso open failed, mmap: No such file or directory
  dso open failed, mmap: No such file or directory
  dso open failed, mmap: No such file or directory
  dso open failed, mmap: No such file or directory
  dso open failed, mmap: No such file or directory
  Using /root/.debug/.build-id/4e/841948927029fb650132253642d5dbb2c1fb93 for symbols
  Failed to open /tmp/perf-8831.map, continuing without symbols
  Failed to open /tmp/perf-12721.map, continuing without symbols
  Failed to open /tmp/perf-6966.map, continuing without symbols
  Failed to open /tmp/perf-8802.map, continuing without symbols
  [root@zoo ~]#

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1416605880-25055-2-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/debug.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index ba357f3..ad60b2f 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -19,13 +19,14 @@
 int verbose;
 bool dump_trace = false, quiet = false;
 int debug_ordered_events;
+static int redirect_to_stderr;
 
 static int _eprintf(int level, int var, const char *fmt, va_list args)
 {
 	int ret = 0;
 
 	if (var >= level) {
-		if (use_browser >= 1)
+		if (use_browser >= 1 && !redirect_to_stderr)
 			ui_helpline__vshow(fmt, args);
 		else
 			ret = vfprintf(stderr, fmt, args);
@@ -145,6 +146,7 @@ static struct debug_variable {
 } debug_variables[] = {
 	{ .name = "verbose",		.ptr = &verbose },
 	{ .name = "ordered-events",	.ptr = &debug_ordered_events},
+	{ .name = "stderr",		.ptr = &redirect_to_stderr},
 	{ .name = NULL, }
 };
 

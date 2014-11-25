Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbaKYNWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:22:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:35748 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800AbaKYNWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:22:49 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/12] perf tools: Allow to force redirect pr_debug to stderr.
Date: Tue, 25 Nov 2014 10:22:05 -0300
Message-Id: <1416921730-5063-8-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416921730-5063-1-git-send-email-acme@kernel.org>
References: <1416921730-5063-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

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
index ba357f3226c6..ad60b2f20258 100644
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
 
-- 
1.9.3


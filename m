Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab3C1RNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:13:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36274 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab3C1RCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:02:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/36] perf tools: Cleanup calc_data_size logic
Date: Thu, 28 Mar 2013 14:02:10 -0300
Message-Id: <1364490156-32064-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1364490156-32064-1-git-send-email-acme@infradead.org>
References: <1364490156-32064-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It's for calculating whole trace data size during reading.  However
relation functions are called only in this file, no need to
conditionalize it with tricky +1 offset and rename the variable to
more meaningful name like trace_data_size.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1363850332-25297-10-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-read.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 644ad3b..af215c0 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -43,7 +43,7 @@ int file_bigendian;
 int host_bigendian;
 static int long_size;
 
-static ssize_t calc_data_size;
+static ssize_t trace_data_size;
 static bool repipe;
 
 static int __do_read(int fd, void *buf, int size)
@@ -83,8 +83,7 @@ static int do_read(void *data, int size)
 		return -1;
 	}
 
-	if (calc_data_size)
-		calc_data_size += r;
+	trace_data_size += r;
 
 	return r;
 }
@@ -155,8 +154,7 @@ static char *read_string(void)
 			break;
 	}
 
-	if (calc_data_size)
-		calc_data_size += size;
+	trace_data_size += size;
 
 	str = malloc(size);
 	if (str)
@@ -356,9 +354,7 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 
 	*ppevent = NULL;
 
-	calc_data_size = 1;
 	repipe = __repipe;
-
 	input_fd = fd;
 
 	if (do_read(buf, 3) < 0)
@@ -417,8 +413,7 @@ ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
 	if (err)
 		goto out;
 
-	size = calc_data_size - 1;
-	calc_data_size = 0;
+	size = trace_data_size;
 	repipe = false;
 
 	if (show_funcs) {
-- 
1.7.1

